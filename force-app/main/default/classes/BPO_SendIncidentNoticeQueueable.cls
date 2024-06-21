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
public class BPO_SendIncidentNoticeQueueable implements Queueable, Database.AllowsCallouts {
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
    public BPO_SendIncidentNoticeQueueable(Id idCase, Integer numTentativas){
        this.idCase = idCase;
        this.numTentativas = numTentativas + 1;
    }

    /**
     *@description Executa o enfileiramento dos sinistro enviados à APISipre;
     *@param context contexto de enfileitamento;
     */
    public void execute(QueueableContext context){
        System.debug('------------------------------------------INICIO------------------------------------------');

        BPO_IncidentNoticeSipre comunicadoSipre;

        Map<String, Object> retornoWS;
        if(numTentativas <= NUM_MAXIMO_TENTATIVAS){
            //limita o número de tentativas de integração
            System.debug('EnviarComunicadoSinistroQueueable - Buscando case.');
             try{
                comunicadoSipre = getSinistro();
                if(comunicadoSipre != null){
                    BPO_CallSipreRest call = new BPO_CallSipreRest();
                    retornoWS = call.PostSipreRest(JSON.serialize(comunicadoSipre));

                    if((String) retornoWS.get('Status') != 'Success'){
                        logEDisparaEmail((String) retornoWS.get('ErrorMessage') + JSON.serialize(comunicadoSipre));
                    }
                    if((String) retornoWS.get('Status') == 'Success'){
                        numTentativas = NUM_MAXIMO_TENTATIVAS;
                    }
                    System.debug(retornoWS.get('Retorno'));
                }else{
                    System.debug('Comunicado já possui External Workflow Id.');
                    //logEDisparaEmail('Comunicado já possui External Workflow Id. Id comunicado: ' + this.idCase);
                }
            } catch (Exception e){
                logEDisparaEmail(e.getMessage() + ' ' + e.getLineNumber() + JSON.serialize(comunicadoSipre));
                System.debug('Erro: ' + e.getMessage() + ' Linha: ' + e.getLineNumber() + ' Stack: ' + e.getStackTraceString());
            }
        }

        System.debug('------------------------------------------FIM------------------------------------------');
    }
    /**
     *@description Processa e envia os logs do processo de integração para o grupo "Wiz BPO Seguros - Canal Integração"
     *
     *@param errorMsg Mensagem do response da chamada da APISipre
     */
    private void logEDisparaEmail(String errorMsg){
        System.debug('errorMsg: ' + errorMsg);
        if(numTentativas == NUM_MAXIMO_TENTATIVAS){
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new List<String>{ 'c2f4acc6.parcorretoradeseguros.onmicrosoft.com@amer.teams.ms' };
            message.optOutPolicy = 'FILTER';
            message.subject = 'Erro de integração comunicado de sinistro';
            message.plainTextBody = 'Houve um erro na integração do comunicado de sinistro. Id de Salesforce: ' + this.idCase + '. Mensagem de erro: ' + errorMsg;
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{ message };
            Messaging.SendEmailResult[] results;
            if(!Test.isRunningTest()){
                results = Messaging.sendEmail(messages);
            }
            if(results != null && !results.isEmpty()){
                if(results[0].success){
                    System.debug('Email enviado com sucesso.');
                }else{
                    System.debug('Erro ao enviar email: ' + results[0].errors[0].message);
                }
            }
        }
        if(!Test.isRunningTest()){
            System.enqueueJob(new BPO_SendIncidentNoticeQueueable(idCase, numTentativas));
        }
    }

    /**
     *@description Instancia os dados a serem enviados ao Sipre dados do comunicado, sinistro, comunicante, segurado, contato, local de vistoria e data de agendamento,
     *@return sinistro
     */
    private BPO_IncidentNoticeSipre getSinistro(){
        BPO_IncidentNoticeSipre comunicadoSipre = new BPO_IncidentNoticeSipre();
        comunicadoSipre.Segurado = new BPO_IncidentNoticeSipre.EstruturaSegurado();
        comunicadoSipre.Reclamante = new BPO_IncidentNoticeSipre.EstruturaReclamante();
        comunicadoSipre.Endereco = new BPO_IncidentNoticeSipre.EstruturaEndereco();
        comunicadoSipre.Contratos = new List<BPO_IncidentNoticeSipre.EstruturaContrato>();

        Map<String, Integer> mapTipoSinistro = new Map<String, Integer>{
            'BPO - MIP - IPA' => 1,
            'BPO - MIP - IPTA' => 2,
            'BPO - MIP - Morte acidental' => 3,
            'BPO - MIP - Morte natural' => 4,
            'BPO - MIP - Suicídio' => 5,
            'BPO - MIP - IPD' => 6,
            'BPO - MIP - Desemprego' => 7
        };

        Map<String, Integer> mapTipoSinistro2 = new Map<String, Integer>{
            'MIP - IPA' => 1,
            'MIP - IPTA' => 2,
            'MIP - Morte acidental' => 3,
            'MIP - Morte natural' => 4,
            'MIP - Suicídio' => 5,
            'MIP - IPD' => 6,
            'MIP - Desemprego' => 7
        };

        Map<String, Integer> mapGenero = new Map<String, Integer>{ 'Masculino' => 1, 'Feminino' => 2 };

        Map<String, String> mapStatusContrato = new Map<String, String>{ 'Ativo' => '1', 'Inativo' => '2', 'Cancelado' => '3' };

        Map<String, Integer> mapParentescoNum = new Map<String, Integer>{ 'Mãe' => 1, 'Filho' => 2, 'Cônjuge' => 3, 'Irmão' => 4, 'Outros' => 5, 'Segurado' => 5 };

        Case comunicadoSinistro = [
            SELECT
                CaseNumber,
                ExternalReferenceId__c,
                CreatedDate,
                RequestDate__c,
                Description,
                Type,
                Status,
                Origin,
                AccountId,
                Account.Name,
                Account.IsPersonAccount,
                Account.IdentificationNumber__c,
                Account.Gender__pc,
                Account.PersonBirthdate,
                ContactId,
                Contact.Name,
                Contact.IndividualIdentificationNumber__c,
                ContactDetail__r.MobilePhone__c,
                ContactDetail__r.HomePhone__c,
                ContactDetail__r.OtherPhone__c,
                ContactDetail__r.Email__c,
                ContactDetail__r.Street__c,
                ContactDetail__r.District__c,
                ContactDetail__r.State__c,
                ContactDetail__r.City__c,
                ContactDetail__r.PostalCode__c,
                ContactDetail__r.Country__c
            FROM CASE
            WHERE Id = :this.idCase
        ];
        System.debug(comunicadoSinistro);
        // if(comunicadoSinistro.ExternalReferenceId__c != null){
        //     return null;
        // }else{
        Map<Id, Integer> mapaContatoParentesco = new Map<Id, Integer>();
        List<CaseContactRelation__c> grupoDoSinistro = [SELECT Contact__c, Relationship__c, Kinship__c FROM CaseContactRelation__c WHERE Case__r.ParentId = :this.idCase];

        for(CaseContactRelation__c atorCaso : grupoDoSinistro){
            mapaContatoParentesco.put(atorCaso.Contact__c, mapParentescoNum.get(atorCaso.Kinship__c));
        }

        // Dados de Sistema
        comunicadoSipre.ProtocoloSF = comunicadoSinistro.CaseNumber;
        System.debug(comunicadoSipre);
        // Dados do Sinistro
        comunicadoSipre.TipoDemanda = comunicadoSinistro.Origin == 'BPO - App' ? '5' : '4';
        comunicadoSipre.Flag = '0';
        comunicadoSipre.Datacomunicado = comunicadoSinistro.CreatedDate != null ? String.valueOf(comunicadoSinistro.CreatedDate).substringBefore(' ') : null;
        comunicadoSipre.DataSinistro = String.valueOf(comunicadoSinistro.RequestDate__c);

        comunicadoSipre.TipoSinistro = mapTipoSinistro.get(comunicadoSinistro.Type) == null
            ? mapTipoSinistro2.get(comunicadoSinistro.Type)
            : mapTipoSinistro.get(comunicadoSinistro.Type);
        System.debug(comunicadoSipre.TipoSinistro);
        comunicadoSipre.HistoricoSinistro = comunicadoSinistro.Description;

        // Dados do Segurado
        comunicadoSipre.Segurado.Nome = comunicadoSinistro.Account.Name;
        comunicadoSipre.Segurado.Usuario = comunicadoSinistro.Account.IdentificationNumber__c;
        comunicadoSipre.Segurado.TipoInclusao = 1;
        if(comunicadoSinistro.Account.IsPersonAccount){
            comunicadoSipre.Segurado.Cpfcnpj = comunicadoSinistro.Account.IdentificationNumber__c;
            comunicadoSipre.Segurado.DataNascimento = String.valueOf(comunicadoSinistro.Account.PersonBirthdate);
            comunicadoSipre.Segurado.Sexo = mapGenero.get(comunicadoSinistro.Account.Gender__pc);
        }else{
            comunicadoSipre.Segurado.Cpfcnpj = comunicadoSinistro.Account.IdentificationNumber__c;
        }

        // Dados do Reclamante
        comunicadoSipre.Reclamante.Cpf = comunicadoSinistro.Contact.IndividualIdentificationNumber__c;
        comunicadoSipre.Reclamante.Nome = comunicadoSinistro.Contact.Name;
        comunicadoSipre.Reclamante.Parentesco = mapaContatoParentesco.get(comunicadoSinistro.ContactId);
        comunicadoSipre.Reclamante.Email = comunicadoSinistro.ContactDetail__r.Email__c;
        comunicadoSipre.Reclamante.TelResidencial = comunicadoSinistro.ContactDetail__r.HomePhone__c;
        comunicadoSipre.Reclamante.TelComercial = comunicadoSinistro.ContactDetail__r.OtherPhone__c;
        comunicadoSipre.Reclamante.Celular = comunicadoSinistro.ContactDetail__r.MobilePhone__c;
        comunicadoSipre.Endereco.Descricao = comunicadoSinistro.ContactDetail__r.Street__c;
        comunicadoSipre.Endereco.Cidade = comunicadoSinistro.ContactDetail__r.City__c;
        comunicadoSipre.Endereco.Bairro = comunicadoSinistro.ContactDetail__r.District__c;
        comunicadoSipre.Endereco.UF = comunicadoSinistro.ContactDetail__r.State__c;
        comunicadoSipre.Endereco.CEP = comunicadoSinistro.ContactDetail__r.PostalCode__c;

        //Lista de Contratos
        List<Contract2__c> listaContratos = [
            SELECT BidNumber__c, CertificateNumber__c, InsuredAmount__c, StartDate__c, EndDate__c, Status__c
            FROM Contract2__c
            WHERE
                Id IN (
                    SELECT Contract2__c
                    FROM Case
                    WHERE ParentId = :this.idCase AND RecordTypeId = :Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('BPOSinistroPrestamista').getRecordTypeId()
                )
        ];
        // Dados de Contrato
        for(Contract2__c c : listaContratos){
            BPO_IncidentNoticeSipre.EstruturaContrato contratoSipre = new BPO_IncidentNoticeSipre.EstruturaContrato();

            contratoSipre.Apolice = c.CertificateNumber__c;
            contratoSipre.Certificado = c.BidNumber__c;
            contratoSipre.Status = mapStatusContrato.get(c.Status__c);
            contratoSipre.InicioVigencia = c.StartDate__c != null ? String.valueOf(c.StartDate__c) : null;
            contratoSipre.FimVigencia = c.EndDate__c != null ? String.valueOf(c.EndDate__c) : null;
            contratoSipre.ValorSegurado = c.InsuredAmount__c != null ? String.valueOf(c.InsuredAmount__c) : null;
            contratoSipre.TipoBeneficiario = '1';

            comunicadoSipre.Contratos.add(contratoSipre);
        }
        // }

        System.debug(comunicadoSipre);
        return comunicadoSipre;
    }
}