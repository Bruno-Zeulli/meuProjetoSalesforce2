@isTest
public class CreateAndUpdateCMRetentionTest 
{
    @isTest
    public static void createAndUpdate()
    {
        Account acc = new Account();
        acc.Name = 'TESTE';
        acc.Phone = '31992420053';
        acc.CompanyIdentificationNumber__c = '05276260000108';
        insert acc;
        
        List<Contract2__c> lstctr = new List<Contract2__c>();
        Contract2__c ctr = new Contract2__c();
        ctr.BidNumber__c = '1111111';
        ctr.Account__c = acc.Id;
        ctr.Company__c = 'Banco do Brasil';
        ctr.RecordTypeId = '0121U000000jXjYQAU';
        insert ctr;
        
        lstctr.add(ctr);
        
        Campaign idCampaign = new Campaign();
        idCampaign.Name = 'PARCEIROS - Retencao CNP';
        insert idCampaign;
        String idC = idCampaign.Id;
         List<String> lstCampaign = new List<String>();
        lstCampaign.add(idC);
        
        CampaignActivity__c ca = new CampaignActivity__c();
        ca.Campaign__c = idC;
        insert ca;
        
        Date dtInicio = Date.newInstance(2023, 1, 10);
        Date dtFinal = Date.newInstance(2033, 12, 10);
        
        List<Date> listDtInicio = new List<Date>();
        List<Date> listDtFinal = new List<Date>();
        
        listDtInicio.add(dtInicio);
        listDtFinal.add(dtFinal);
        
        List<CreateAndUpdateCampaignMemberRetention.InputVariables> lstIv = new List<CreateAndUpdateCampaignMemberRetention.InputVariables>();
        CreateAndUpdateCampaignMemberRetention.InputVariables iv = new  CreateAndUpdateCampaignMemberRetention.InputVariables();
        iv.contratos = lstctr;
        iv.DataFinal = listDtFinal;
        iv.DataInicio = listDtInicio;
        iv.IdCampaign = lstCampaign;
        
        lstIv.add(iv);
        
        CreateAndUpdateCampaignMemberRetention.campaignMemberRetention(lstIv);
    }
}