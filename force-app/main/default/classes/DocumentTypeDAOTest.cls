@isTest
public class DocumentTypeDAOTest {
    @isTest
    static void testGetMapAllDocumentType(){
        // Crie alguns tipos de documentos fictícios para serem usados no teste
        DocumentType__c documentType1 = new DocumentType__c(Name = 'Type A', ExternalReferenceId__c = '123');
        DocumentType__c documentType2 = new DocumentType__c(Name = 'Type B', ExternalReferenceId__c = '456');
        DocumentType__c documentType3 = new DocumentType__c(Name = 'Type C', ExternalReferenceId__c = '789');

        insert new List<DocumentType__c>{documentType1, documentType2, documentType3};

        // Execute o método sob teste
        Map<Id, DocumentType__c> resultDocumentTypeMap = DocumentTypeDAO.getMapAllDocumentType();

        // Verifique se o tamanho do mapa resultante é o esperado
        System.assertEquals(3, resultDocumentTypeMap.size());

        // Verifique se cada tipo de documento está no mapa
        System.assertEquals(true, resultDocumentTypeMap.containsKey(documentType1.Id));
        System.assertEquals(true, resultDocumentTypeMap.containsKey(documentType2.Id));
        System.assertEquals(true, resultDocumentTypeMap.containsKey(documentType3.Id));

        // Verifique se os atributos dos tipos de documento correspondem ao esperado
        System.assertEquals('Type A', resultDocumentTypeMap.get(documentType1.Id).Name);
        System.assertEquals('123', resultDocumentTypeMap.get(documentType1.Id).ExternalReferenceId__c);

        System.assertEquals('Type B', resultDocumentTypeMap.get(documentType2.Id).Name);
        System.assertEquals('456', resultDocumentTypeMap.get(documentType2.Id).ExternalReferenceId__c);

        System.assertEquals('Type C', resultDocumentTypeMap.get(documentType3.Id).Name);
        System.assertEquals('789', resultDocumentTypeMap.get(documentType3.Id).ExternalReferenceId__c);
    }
}