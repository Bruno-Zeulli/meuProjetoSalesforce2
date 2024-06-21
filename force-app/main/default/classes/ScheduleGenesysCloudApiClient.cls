/**
 * @description            : Salva o token que valerá pelo dia inteiro, para evitar realizar diversas requisições sem necessidade
 * @author                 : joao@beecloud.com.br
 * @group                  :
 * @last modified on       : 27-11-2023
 * @last modified by       : joao@beecloud.com.br
 * ExecuteSchedule         : System.schedule('ScheduleAuthTokenGenesys', cronTime, new ScheduleGenesysCloudApiClient());
 * EveryDaySixInTheMorning : String cronTime = '0 0 6 * * ? *';
**/
global class ScheduleGenesysCloudApiClient implements Schedulable{
    global void execute(SchedulableContext context){
        ExternalAPI__c settings = new ExternalAPI__c();

        if(Test.isRunningTest()){
            settings = ExternalAPI__c.getInstance('GenesysCloudApiClientTest');
        } else{
            settings = ExternalAPI__c.getInstance('Genesys Cloud');
        }

        GenesysCloudApiClient.saveAccessToken(settings.Name);
    }
}