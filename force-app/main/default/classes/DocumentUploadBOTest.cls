/**
 * @description       : 
 * @author            : samuelsirkis@wiz.co
 * @group             : 
 * @last modified on  : 09-22-2023
 * @last modified by  : samuelsirkis@wiz.co
**/
@isTest
public class DocumentUploadBOTest {

    @isTest
    static void testCreateTaskDocPending() {
        // Preparar dados de teste, incluindo DocumentUpload__c e outros dados necessários
        List<DocumentUpload__c> lstDocUploadPending = new List<DocumentUpload__c>();
        // Adicione objetos DocumentUpload__c à lista lstDocUploadPending

        // Executar o método createTaskDocPending da classe DocumentUploadBO
        DocumentUploadBO documentUploadBO = DocumentUploadBO.getInstance();
        documentUploadBO.createTaskDocPending(lstDocUploadPending);

        // Recuperar as tarefas criadas ou verificar o comportamento esperado
        List<Task> createdTasks = [SELECT Id FROM Task WHERE Subject = 'Pendência' AND Status = 'Open'];

        // Adicione asserts para verificar se as tarefas foram criadas corretamente
        System.assertEquals(lstDocUploadPending.size(), createdTasks.size());

        // Adicione mais asserts conforme necessário para verificar o comportamento esperado
    }
}