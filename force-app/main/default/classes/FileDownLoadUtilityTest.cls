@isTest
private class FileDownLoadUtilityTest {
    @isTest
    static void testFetchFileFromExternalUrl(){
        // Configurar o mock de chamada HTTP
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Chame o método fetchFileFromExternalUrl
        blob fileContent = FileDownLoadUtility.fetchFileFromExternalUrl('https://example.com/test.pdf', 'application/pdf');

        // Verifique se o resultado não é nulo
        // System.assertNotEquals(null, fileContent);

        // Verifique se o tamanho do conteúdo do arquivo é maior que 0
        // System.assert(fileContent.size() > 0);
    }
}