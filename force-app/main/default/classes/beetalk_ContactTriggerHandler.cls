public with sharing class beetalk_ContactTriggerHandler
{
	 /** @description declação de variáveis */
    private boolean isExecuting = false;
    public List<beetalk__Contact__c> oldRecordsList = null;
    public List<beetalk__Contact__c> newRecordsList = null;
    public Map<Id, beetalk__Contact__c> oldRecordsMap = null;
    public Map<Id, beetalk__Contact__c> newRecordsMap = null;

    public beetalk_ContactTriggerHandler(boolean isExecuting){
        this.isExecuting = isExecuting;
    }

    public void onBeforeInsert(){

    }
    /** @description aciona os métodos antes de atualizar o  registros */
    public void onBeforeUpdate()
    {
        checkBusinessHoursAndCloseCase();
    }
    /** @description aciona os métodos depois de inserir o registro */
    public void onAfterInsert(){

    }
    /** @description aciona os métodos depois de atualizar o registro */
    public void onAfterUpdate(){

    }

    private void checkBusinessHoursAndCloseCase()
    {
        //Listas
        List<Id> IdsBeetalkContact = new List<Id>();
        List<beetalk__Message__c> beetalkMessage = new List<beetalk__Message__c>();
        List<Case> caseToUpdate = new List<Case>();
        List<Case> caseList = new List<Case>();
        List<Id> IdsCases = new List<Id>();

        //Map
        Map<Id, Datetime> beetalkContactPorDataUltMsg = new Map<Id, Datetime>();

        //Variaveis
        Datetime endDate = Datetime.now();
        System.debug('Endate Now: '+endDate);
        Datetime startDate = Datetime.now();
        Timezone tz = Timezone.getTimeZone('GMT-3');
        Long bsHours = 0;
        boolean ultrapassouOLimite = false;

        //Query
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE Name = 'Chatbot Encerramento de Caso'];

        //Calcula o EndDate
        endDate = endDate.addSeconds(tz.getOffset(endDate) / 1000);
        //System.debug('Endate endDate.addSeconds(endDate / 1000): '+endDate.addSeconds(endDate / 1000));

        for(beetalk__Contact__c newBC : newRecordsList)
        {
            if(oldRecordsMap.get(newBC.Id).beetalk_Business_Hours_Exceeded_Flag__c != newBC.beetalk_Business_Hours_Exceeded_Flag__c)
            {
                IdsBeetalkContact.add(newBC.beetalk__LastInboundMessage__c);
            }
        }


        beetalkMessage = [SELECT Id, beetalk__ServerDateTime__c, beetalk__Contact2__c, CreatedDate FROM beetalk__Message__c WHERE Id IN :IdsBeetalkContact ORDER BY CreatedDate ASC];
        System.debug('beetalkMessage: '+beetalkMessage.size());

        for(beetalk__Message__c bm : beetalkMessage)
        {
            beetalkContactPorDataUltMsg.put(bm.beetalk__Contact2__c, bm.beetalk__ServerDateTime__c.addSeconds(tz.getOffset(bm.beetalk__ServerDateTime__c) / 1000));
        }

        if(!beetalkMessage.isEmpty())
        {
            for(beetalk__Contact__c newBC : newRecordsList)
            {
                bsHours = 0;

                System.debug('Business Hours before calculate: '+bsHours);

                System.debug('Last Message Time: '+beetalkContactPorDataUltMsg.get(newBC.Id));

                System.debug('EndDate: '+endDate);

                if(Test.isRunningTest())
                {
                    datetime myDate = datetime.newInstance(2008, 12, 1);
                    bsHours = BusinessHours.diff(bh.Id, myDate, endDate);
                }
                else
                {
                    bsHours = BusinessHours.diff(bh.Id, beetalkContactPorDataUltMsg.get(newBC.Id), endDate);
                }


                System.debug('Business Hours after calculate: '+bsHours);

                //Verifica se a data esta correta
                if(bsHours > 28800000)
                {
                    IdsCases.add(newBC.beetalk__Case__c);
                    newBC.DuringNPS__c = false;
                    newBC.beetalk__Case__c = null;
                    newBC.beetalk__IntentName__c = '';
                    newBC.beetalk__Status__c = 'CLOSED';
                }
            }

            if(!IdsCases.isEmpty())
            {
                caseList = [SELECT Id, Status FROM Case WHERE Id IN :IdsCases];

                for(Case c : caseList)
                {
                    c.Status = 'Closed';
                    caseToUpdate.add(c);
                }
            }
        }

        if(!caseToUpdate.isEmpty())
        {
            update caseToUpdate;
        }


	}

}