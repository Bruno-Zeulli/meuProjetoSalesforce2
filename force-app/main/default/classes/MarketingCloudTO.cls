/**
 * @description       : Model utilizada para chamadas de autenticacao
 * @author            : Marcelo Martins
 * @email             : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-11-2022   marcelomartins@wizsolucoes.com.br    Initial Version
 **/
public without sharing class MarketingCloudTO {
    
    public class InputMarketingCloud {
       public String contactKey { get; set; }
       public String eventDefinitionKey { get; set; }
       public Boolean establishContactKey { get; set; }
       public CustomData data { get; set; }
    }
    /** @description da viewModel a ser enviado à jornada. **/
    public class CustomData {
        public String caseId { get; set; }
        public String contactId { get; set; }
        public String accountId { get; set; }

        public String produto { get; set; }
        public String email { get; set; }
        public String mobilePhone { get; set; }
        public String locale { get; set; }
        public String status { get; set; }

        public Boolean saldoResidual { get; set; }
        public Boolean clienteCaixa { get; set; }
        public String cpfComunicante { get; set; }
        public String cpfSegurado { get; set; }
        public String contactDetail { get; set; }
        public String identificationNumber { get; set; }

        public String name { get; set; }
        public String source { get; set; }
        public String relationshipGroup { get; set; }
        public String doNotSendMessage { get; set; }

        public String taskId { get; set; }
        public String callDisposition { get; set; }
        public String five9AgentName { get; set; }
        public String five9Agent { get; set; }
        public String createdDate { get; set; }

        public String campaignName { get; set; }        
    }


    public class InputItemsMktcCloud{
        public Item[] items { get; set; }
    }
    public Item[] items;
    public class Item{
        public String id { get; set; }
        public String productCode { get; set; }
        public String product2Id { get; set; }
        public String pricebook2 { get; set; }
        public String pricebook2_Name { get; set; }
        public String isActive { get; set; }
        public String name { get; set; }
    }


}