public with sharing class DocusignCalloutSchedule implements Schedulable {
    public void execute(SchedulableContext ctx) {
        Id batchId = Database.executeBatch(new DocusignCalloutBatch(),40);
    }

    public static void schedule(){
        String isTest = '';
        if(Test.isRunningTest()){
            isTest += ' Test';
        }
        System.schedule('Buscar documentos Docusign e salvar no Blob' + isTest, '0 0 5 * * ?', new DocusignCalloutSchedule());
    }
}