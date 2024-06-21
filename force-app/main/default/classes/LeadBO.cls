/**
 * @description       : Classe BO responsável por manipular as regras de négocio de Lead.
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 07-24-2022
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   07-24-2022   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
@SuppressWarnings('PMD')
public without sharing class LeadBO {

    /**
    * @description Realiza o update dos lead com o enriquecimento dos dados vindo da Diretrix.
    * @param setLeadId recebe uma lista de LeadIds.
    */
    @future(callout = true)
    public static void updateLeadDataThroughDiretrix(Set<Id> setLeadId){
        String msgErrorSubject = 'Error ao atualizar o Lead com os dados Diretrix.';
        List<Lead> lstUpdateLeads = new List<Lead>();
        DiretrixTO.DiretrixResponseFindByIndentificationNumber diretrixResponse =
            new DiretrixTO.DiretrixResponseFindByIndentificationNumber();

        for(Lead objLead : [   SELECT  Id,
                                        IdentificationNumber__c,
                                        Email,
                                        Phone,
                                        MobilePhone
                                FROM    LEAD
                                WHERE   Id IN :setLeadId]){


            diretrixResponse = DiretrixService.getInstance()
                .findCompanyByIndentificationNumber(objLead.IdentificationNumber__c);

            if(diretrixResponse != null){

                Lead updObjLead = new Lead();
                updObjLead.Id = objLead.Id;
                updObjLead.AnnualRevenue = Decimal.valueOf(
                                                diretrixResponse.consulta
                                                    .dadosGerais[0]
                                                    .FATURAMENTO_PRESUMIDO_ANUAL
                                            );
                updObjLead.Company = diretrixResponse.consulta.dadosGerais[0].RAZAO;
                updObjLead.Email = objLead.Email == null ?
                                    diretrixResponse.consulta.emails[0].EMAIL :
                                    objLead.Email;
                updObjLead.Street = diretrixResponse.consulta.enderecos[0].ENDERECO;
                updObjLead.City = diretrixResponse.consulta.enderecos[0].CIDADE;
                updObjLead.PostalCode = diretrixResponse.consulta.enderecos[0].CEP;
                updObjLead.State = diretrixResponse.consulta.enderecos[0].UF;
                updObjLead.Phone = objLead.Phone == null ?
                                        diretrixResponse.consulta.telefones[0].TIPO_TELEFONE == 'Comercial' ?
                                        diretrixResponse.consulta.telefones[0].DDD +
                                        diretrixResponse.consulta.telefones[0].TELEFONE :
                                        null :
                                        objLead.Phone;

                updObjLead.MobilePhone = objLead.MobilePhone == null ?
                                            diretrixResponse.consulta.telefones[0].TIPO_TELEFONE == 'Celular' ?
                                            diretrixResponse.consulta.telefones[0].DDD +
                                            diretrixResponse.consulta.telefones[0].TELEFONE :
                                            null :
                                            objLead.MobilePhone;

                lstUpdateLeads.add(updObjLead);



            }
        }

        if(!lstUpdateLeads.isEmpty()){
            Savepoint sp = Database.setSavepoint();

             try{
                Database.SaveResult[] srListFiles = Database.update(lstUpdateLeads, false);
                ErrorLogService.getInstance().saveResult(srListFiles, msgErrorSubject, lstUpdateLeads);
            } catch (Exception e){
                System.Debug(e);
                Database.rollback(sp);
            }
        }
    }
}