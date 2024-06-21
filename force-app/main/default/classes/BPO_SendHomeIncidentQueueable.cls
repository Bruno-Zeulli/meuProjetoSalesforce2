/**
 * @description       :
 * @author            : Windson Santos
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
public class BPO_SendHomeIncidentQueueable implements Queueable, Database.AllowsCallouts {
    /*@description atributo idCase*/
    private Id idCase { get; set; }
    /*@description atributo numTentativas*/
    private integer numTentativas { get; set; }
    /*@description atributo NUM_MAXIMO_TENTATIVAS*/
    private static final Integer NUM_MAXIMO_TENTATIVAS = 3;

    /**
     *@description Construtor que recebe os parametros
     *@param idCase Id do caso sinistro;
     *@param numTentativas posição inicial do número de tentativas
     */
    public BPO_SendHomeIncidentQueueable(Id idCase, Integer numTentativas){
        this.idCase = idCase;
        this.numTentativas = numTentativas + 1;
    }

    /**
     *@description Executa o enfileiramento dos sinitros enviados a APIMAC;
     *@param context contexto de enfileitamento;
     */
    public void execute(QueueableContext context){
        System.debug('------------------------------------------INICIO------------------------------------------');
        BPO_MacNoticeEntity.InputMACCreate sinistroMAC;
        Map<String, Object> retornoWS;
        if(numTentativas <= NUM_MAXIMO_TENTATIVAS){
            //limita o número de tentativas de integração
            System.debug('BPO_SendHomeIncidentQueueable - Buscando case.');
             try{
                sinistroMAC = getSinistro();
                validationSinistroMac(retornoWS, sinistroMAC);
            } catch (Exception e){
                System.debug('Erro: ' + e.getMessage() + ' ' + e.getLineNumber());
                logEDisparaEmail(e.getMessage() + ' Request: ' + JSON.serialize(sinistroMAC));
            }
        }

        System.debug('------------------------------------------FIM------------------------------------------');
    }

    /**
     *@description realiza a chamada do callout e processa o retornoWS além de atualizar o número do comunicadoMac no casa que representa o comunicado no SF
     *@param retornoWS o mapeamento do retorno Web Service
     *@param sinistroMAC instancia do sinistro
     */
    private void validationSinistroMac(Map<String, Object> retornoWS, BPO_MacNoticeEntity.InputMACCreate sinistroMAC){
        if(sinistroMAC != null){
            BPO_MacCallRest call = new BPO_MacCallRest();
            retornoWS = call.PostMACRest(JSON.serialize(sinistroMAC));
            if((String) retornoWS.get('Status') != 'Success'){
                logEDisparaEmail((String) retornoWS.get('ErrorMessage') + ' Request: ' + JSON.serialize(sinistroMAC));
            }else{
                BPO_MacNoticeEntity.ResponseMAC deserializedWSReturn = (BPO_MacNoticeEntity.ResponseMAC) JSON.deserialize(
                    (String) retornoWS.get('Retorno'),
                    BPO_MacNoticeEntity.ResponseMAC.class
                );
                if(deserializedWSReturn.idComunicado != null){
                    Case sinistro = [SELECT Id, ParentId, ExternalReferenceId__c FROM Case WHERE Id = :this.idCase];
                    Case comunicado = new Case(Id = sinistro.ParentId, ExternalReferenceId__c = String.valueOf(deserializedWSReturn.idComunicado));
                    update comunicado;
                    this.numTentativas = NUM_MAXIMO_TENTATIVAS;
                }
            }
        }else{
            System.debug('Sinistro já possui External Workflow Id.');
            //logEDisparaEmail('Sinistro já possui External Workflow Id. Id comunicado: ' + this.idCase);
        }
    }

    /**
     *@description Processa e envia os logs do processo de integração para o grupo "Wiz BPO Seguros - Canal Integração"
     *
     *@param errorMsg Mensagem do response da chamada da APIMAC
     */
    private void logEDisparaEmail(String errorMsg){
        if(numTentativas == NUM_MAXIMO_TENTATIVAS){
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new List<String>{ 'c2f4acc6.parcorretoradeseguros.onmicrosoft.com@amer.teams.ms' };
            message.optOutPolicy = 'FILTER';
            message.subject = 'Erro de integração comunicado de sinistro';
            message.plainTextBody = 'Houve um erro na integração do comunicado de sinistro. Id de Salesforce: ' + this.idCase + '. Mensagem de erro: ' + errorMsg;
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{ message };
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

            if(results[0].success){
                System.debug('Email enviado com sucesso.');
            }else{
                System.debug('Erro ao enviar email: ' + results[0].errors[0].message);
            }
        }
        if(!Test.isRunningTest()){
            System.enqueueJob(new BPO_SendHomeIncidentQueueable(idCase, numTentativas));
        }
    }

    /**
     *@description Instancia os dados a serem enviados ao MAC dados do comunicado, sinistro, comunicante, segurado, contato, local de vistoria e data de agendamento,
     *@return sinistro
     */
    private BPO_MacNoticeEntity.InputMACCreate getSinistro(){
        BPO_MacNoticeEntity.InputMACCreate sinistro = new BPO_MacNoticeEntity.InputMACCreate();

        Map<String, Integer> tipoSinistro = new Map<String, Integer>{
            'BPO - MIP - Morte natural' => 1,
            'BPO - MIP - Morte acidental' => 2,
            'BPO - MIP - IPD' => 3,
            'BPO - MIP - IPA' => 4,
            'BPO - DFI - Imóvel construído' => 5,
            'BPO - DFI - Imóvel em construção' => 6
        };

        Map<String, Integer> tipoSinistro2 = new Map<String, Integer>{
            'MIP - Morte natural' => 1,
            'MIP - Morte acidental' => 2,
            'MIP - IPD' => 3,
            'MIP - IPA' => 4,
            'DFI - Imóvel construído' => 5,
            'DFI - Imóvel em construção' => 6
        };

        Map<String, Integer> causa = new Map<String, Integer>{
            'BPO - Incêndio, Raio e Explosão' => 1,
            'BPO - Vendaval' => 2,
            'BPO - Ameaça de Desmoronamento' => 3,
            'BPO - Desmoronamento Parcial' => 4,
            'BPO - Desmoronamento Total' => 5,
            'BPO - Destelhamento' => 6,
            'BPO - Inundação ou Alagamento' => 7,
            'BPO - Infestação de Cupins e outros insetos' => 8,
            'BPO - Trincas e/ou Fissuras em tetos ou paredes' => 9,
            'BPO - Danos nas instalações elétricas' => 10,
            'BPO - Danos em esquadrias, vidros ou ferragens' => 11,
            'BPO - Outros' => 12
            // 'BPO - Pisos soltando ou estufando' => 13,
            // 'BPO - Portas, janelas e portão' => 14,
            // 'BPO - Vícios de construção' => 15,
            // 'BPO - Infiltração, mofo e bolor' => 16
        };
        Map<String, Integer> causa2 = new Map<String, Integer>{
            'Incêndio, Raio e Explosão' => 1,
            'Vendaval' => 2,
            'Ameaça de Desmoronamento' => 3,
            'Desmoronamento Parcial' => 4,
            'Desmoronamento Total' => 5,
            'Destelhamento' => 6,
            'Inundação ou Alagamento' => 7,
            'Infestação de Cupins e outros insetos' => 8,
            'Trincas e/ou Fissuras em tetos ou paredes' => 9,
            'Danos nas instalações elétricas' => 10,
            'Danos em esquadrias, vidros ou ferragens' => 11,
            'Outros' => 12
            // 'Pisos soltando ou estufando' => 13,
            // 'Portas, janelas e portão' => 14,
            // 'Vícios de construção' => 15,
            // 'Infiltração, mofo e bolor' => 16
        };

        Map<String, String> turno = new Map<String, String>{ 'Manhã' => 'M', 'Tarde' => 'T', 'Noite' => 'N' };

        Map<String, Integer> parentesco = new Map<String, Integer>{
            'Segurado' => 1,
            'Parente' => 2,
            'Filho' => 2,
            'Mãe' => 2,
            'Pai' => 2,
            'Irmão' => 2,
            'Conjuge' => 3,
            'Amigo' => 4,
            'Outros' => 5,
            'Economiário' => 5,
            'Representante Legal' => 5
        };

        Case casoSinistro = [
            SELECT
                Id,
                ExternalReferenceId__c,
                Account.Name,
                Account.IdentificationNumber__c,
                Contract2__r.CertificateNumber__c,
                RequestDate__c,
                Type,
                Reason,
                Description,
                InspectionDate__c,
                ContactDetail__r.Street__c,
                ContactDetail__r.City__c,
                ContactDetail__r.PostalCode__c,
                ContactDetail__r.District__c,
                ContactDetail__r.State__c,
                Origin,
                PaymentValue__c,
                CreatedBy.Name,
                CreatedBy.IndividualIdentificationNumber__c,
                CreatedBy.Email,
                OwnerId,
                Concierge_QuotationValue__c,
                InspectionAddressPostalCode__c,
                InspectionAddress__c,
                InspectionAddressDistrict__c,
                InspectionAddressCity__c,
                InspectionAddressState__c,
                InspectionAddressReference__c,
                InspectionDescription__c,
                InspectionPreferredDayPeriod__c
            FROM Case
            WHERE Id = :this.idCase
        ];

        String cobertura = casoSinistro.Type.contains('MIP') ? 'MIP' : 'DFI';

        // if(casoSinistro.ExternalReferenceId__c != null){
        //   return null;
        // }else{
        String numeroContrato = casoSinistro.Contract2__r.CertificateNumber__c;

        sinistro.codSF = casoSinistro.Id;
        sinistro.numContratoCEF = Long.valueOf(numeroContrato);
        sinistro.cPFCNPJSinistrado = casoSinistro.Account.IdentificationNumber__c;
        sinistro.nomeSinistrado = casoSinistro.Account.Name;

        if(casoSinistro.RequestDate__c != null){
            string dataString = Dateutil.datetimeToString(casoSinistro.RequestDate__c).substring(0, 10);
            sinistro.dataOcorrencia = dataString;
        }

        sinistro.idCobertura = cobertura == 'DFI' ? 1 : 2; // Se DFI 1, se MIP 2.\\
        sinistro.idTipoSinistro = tipoSinistro.get(casoSinistro.Type) == null ? tipoSinistro2.get(casoSinistro.Type) : tipoSinistro.get(casoSinistro.Type);
        System.debug(sinistro.idTipoSinistro);
        sinistro.idCausa = causa.get(casoSinistro.Reason) == null ? causa2.get(casoSinistro.Reason) : causa.get(casoSinistro.Reason);
        sinistro.valoR_ORC_COMUNIC = casoSinistro.Concierge_QuotationValue__c;
        sinistro.descricaoCausaEvento = casoSinistro.Description.length() > 199 ? casoSinistro.Description.substring(0, 199) : casoSinistro.Description;
        sinistro.idhoraVistoria = turno.get(casoSinistro.InspectionPreferredDayPeriod__c);
        sinistro.vistoriaCEP = casoSinistro.InspectionAddressPostalCode__c != null ? Long.valueOf(casoSinistro.InspectionAddressPostalCode__c) : null;
        sinistro.vistoriaEndereco = casoSinistro.InspectionAddress__c;
        sinistro.vistoriaBairro = casoSinistro.InspectionAddressDistrict__c;
        sinistro.vistoriaCidade = casoSinistro.InspectionAddressCity__c;
        sinistro.vistoriaUF = casoSinistro.InspectionAddressState__c;
        sinistro.vistoriaRef = casoSinistro.InspectionAddressReference__c != null ? casoSinistro.InspectionAddressReference__c.abbreviate(50) : null;
        sinistro.vistoriaObs = casoSinistro.InspectionDescription__c != null ? casoSinistro.InspectionDescription__c.abbreviate(50) : null;

        List<CaseContactRelation__c> listCaseRelation = [
            SELECT
                Kinship__c,
                Relationship__c,
                Contact__r.Name,
                Contact__r.IndividualIdentificationNumber__c,
                Case__r.Parent.ContactDetail__r.HomePhone__c,
                Case__r.Parent.ContactDetail__r.MobilePhone__c,
                Case__r.Parent.ContactDetail__r.OtherPhone__c,
                Case__r.Parent.ContactDetail__r.Email__c,
                Case__r.Parent.ContactDetail__r.Street__c,
                Case__r.Parent.ContactDetail__r.City__c,
                Case__r.Parent.ContactDetail__r.PostalCode__c,
                Case__r.Parent.ContactDetail__r.District__c,
                Case__r.Parent.ContactDetail__r.State__c,
                Case__r.Parent.ContactDetail__r.PreferredContactMeans__c
            FROM CaseContactRelation__c
            WHERE Case__c = :this.idCase
        ];

        for(CaseContactRelation__c grupo : listCaseRelation){
            if(grupo.Relationship__c == 'Comunicante'){
                sinistro.idParentescoCom = 1;
                sinistro.cpfCNPJComunicante = grupo.Contact__r.IndividualIdentificationNumber__c;
                sinistro.nomeComunicante = grupo.Contact__r.Name;
                sinistro.foneResidencialCom = grupo.Case__r.Parent.ContactDetail__r.HomePhone__c != null
                    ? Long.valueOf(grupo.Case__r.Parent.ContactDetail__r.HomePhone__c.substring(grupo.Case__r.Parent.ContactDetail__r.HomePhone__c.length() - 11))
                    : null;
                sinistro.foneCelularCom = grupo.Case__r.Parent.ContactDetail__r.MobilePhone__c != null
                    ? Long.valueOf(grupo.Case__r.Parent.ContactDetail__r.MobilePhone__c.substring(grupo.Case__r.Parent.ContactDetail__r.MobilePhone__c.length() - 11))
                    : null;
                sinistro.foneComercialCom = grupo.Case__r.Parent.ContactDetail__r.OtherPhone__c != null
                    ? Long.valueOf(grupo.Case__r.Parent.ContactDetail__r.OtherPhone__c.substring(grupo.Case__r.Parent.ContactDetail__r.OtherPhone__c.length() - 11))
                    : null;
                sinistro.emailPesComunicante = grupo.Case__r.Parent.ContactDetail__r.Email__c;
                sinistro.emailComComunicante = grupo.Case__r.Parent.ContactDetail__r.Email__c;
                sinistro.cepComunicante = grupo.Case__r.Parent.ContactDetail__r.PostalCode__c != null
                    ? Long.valueOf(grupo.Case__r.Parent.ContactDetail__r.PostalCode__c.remove(' ').remove('(').remove(')').remove('-'))
                    : null;
                sinistro.enderecoComunicante = grupo.Case__r.Parent.ContactDetail__r.Street__c;
                sinistro.bairroComunicante = grupo.Case__r.Parent.ContactDetail__r.District__c != null ? grupo.Case__r.Parent.ContactDetail__r.District__c : 'N/A';
                sinistro.cidadeComunicante = grupo.Case__r.Parent.ContactDetail__r.City__c;
                sinistro.ufComunicante = grupo.Case__r.Parent.ContactDetail__r.State__c;
            }else if(grupo.Relationship__c == 'Contato'){
                sinistro.idParentescoCont = parentesco.get(grupo.Kinship__c);
                sinistro.cpfCNPJContato = grupo.Contact__r.IndividualIdentificationNumber__c;
                sinistro.nomeContato = grupo.Contact__r.Name;
                sinistro.foneResidencialCont = grupo.Case__r.Parent.ContactDetail__r.HomePhone__c != null
                    ? Long.valueOf(grupo.Case__r.Parent.ContactDetail__r.HomePhone__c.substring(grupo.Case__r.Parent.ContactDetail__r.HomePhone__c.length() - 11))
                    : null;
                sinistro.foneCelularCont = grupo.Case__r.Parent.ContactDetail__r.MobilePhone__c != null
                    ? Long.valueOf(grupo.Case__r.Parent.ContactDetail__r.MobilePhone__c.substring(grupo.Case__r.Parent.ContactDetail__r.MobilePhone__c.length() - 11))
                    : null;
                sinistro.foneComercialCont = grupo.Case__r.Parent.ContactDetail__r.OtherPhone__c != null
                    ? Long.valueOf(grupo.Case__r.Parent.ContactDetail__r.OtherPhone__c.substring(grupo.Case__r.Parent.ContactDetail__r.OtherPhone__c.length() - 11))
                    : null;
                sinistro.emailPesContato = grupo.Case__r.Parent.ContactDetail__r.Email__c;
                sinistro.emailComContato = null;
                sinistro.cepContato = grupo.Case__r.Parent.ContactDetail__r.PostalCode__c != null
                    ? Long.valueOf(grupo.Case__r.Parent.ContactDetail__r.PostalCode__c.remove(' ').remove('(').remove(')').remove('-'))
                    : null;
                sinistro.enderecoContato = grupo.Case__r.Parent.ContactDetail__r.Street__c;
                sinistro.bairroContato = grupo.Case__r.Parent.ContactDetail__r.District__c != null ? grupo.Case__r.Parent.ContactDetail__r.District__c : 'N/A';
                sinistro.cidadeContato = grupo.Case__r.Parent.ContactDetail__r.City__c;
                sinistro.ufContato = grupo.Case__r.Parent.ContactDetail__r.State__c;
                sinistro.melhorFormaCom1 = '1';
                sinistro.fonePrincipalCont = 1;
            }
        }

        sinistro.comunicanteContatosAoMesmo = sinistro.cpfCNPJComunicante == sinistro.cpfCNPJContato ? 1 : 0;
        sinistro.tipoOrig = casoSinistro.Origin == 'BPO - App' ? 9 : 8;
        sinistro.obsAtendimento = casoSinistro.Description != null ? casoSinistro.Description.abbreviate(250) : null;

        // Dados do operador, necessário ser hardcode devido problemas de migração, migração foi realizada com o usuário integrador padrão
        // ao invés de usar o integrador BPO, Cases com o CreatedBy igual integrador, o IndividualIdentificationNumber__c é null, então
        // setamos os valores hardcode para os dados abaixo, com os dados do integrador BPO.
        sinistro.matricula = casoSinistro.CreatedBy.IndividualIdentificationNumber__c != null ? casoSinistro.CreatedBy.IndividualIdentificationNumber__c : '01821332229';
        sinistro.nomeOrig = casoSinistro.CreatedBy.IndividualIdentificationNumber__c != null ? casoSinistro.CreatedBy.Name : 'Integrador BPO';
        sinistro.emailOrig = casoSinistro.CreatedBy.IndividualIdentificationNumber__c != null ? casoSinistro.CreatedBy.Email : 'windsonsantos@wizsolucoes.com.br';
        return sinistro;
    }
    // }
}