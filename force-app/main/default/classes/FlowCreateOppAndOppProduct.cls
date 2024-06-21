public class FlowCreateOppAndOppProduct
{
    @invocableMethod
    public static list<ReturnVariables> createOppAndOppProduct (List<InputVariables> InputVariables)
    {
        //Variaveis
        String accountId = InputVariables.get(0).accountIdFromFlow.get(0);
        String pricebookId = InputVariables.get(0).pricebookEntryIdFromFlow.get(0);
        String pklType = InputVariables.get(0).pklTypeFromFlow.get(0);
        List<String> responseList = new List<String>();
        List<String> returnList = new List<String>();
        String token = '';
        String endpointApiCRM = '';

        //Pegar Opp
        Opportunity oppToUse = [SELECT Id, CreatedDate FROM Opportunity WHERE CreatedDate = TODAY and accountId =: accountId ORDER BY CreatedDate DESC LIMIT 1 ];

        //Variaveis de Retorno
        List<ReturnVariables> retornoList = new List<ReturnVariables>();
        ReturnVariables retorno = new ReturnVariables();

        if(!Test.isRunningTest())
        token = GetAccessTokenUtil.getInstance().getToken('ApiCRM', 'SSO');

        String apiNameToGetEndpoint = 'ApiCRM';

        if(!Test.isRunningTest())
        endpointApiCRM = ExternalAPI__c.getValues(apiNameToGetEndpoint).Endpoint__c;

        // Defina o URL do endpoint que você deseja chamar
        // /api/v2/opportunities/account-id/{accountId}
        String endpointURL = endpointApiCRM+'/api/v2/opportunities/opportunity/add-line-item';

        // Crie uma instância HttpRequest
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();

        // Criar um mapa para representar o objeto JSON
        Map<String, Object> requestBodyMap = new Map<String, Object>();

        // Definir o novo valor do ownerId no mapa
        if(!Test.isRunningTest())
       	requestBodyMap.put('opportunityId', oppToUse.Id);

        requestBodyMap.put('product2Id', pricebookId);
        requestBodyMap.put('type', pklType);
        requestBodyMap.put('quantity', 1);
        requestBodyMap.put('unitPrice', 1);
        System.debug('Body Map: ' + requestBodyMap);
        
        //TESTE

        // Converter o mapa em JSON
        String requestBody = JSON.serialize(requestBodyMap);

        String authHeader = 'Bearer ' + token;
        req.setEndpoint(endpointURL);
        req.setHeader('Authorization', authHeader);
        req.setMethod('POST'); // Defina o método como PATCH
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setBody(requestBody);


        try {
            // Faça a chamada ao endpoint
            if(!Test.isRunningTest())
            res = http.send(req);

            // Verifique se a resposta foi bem-sucedida (código de status 200)
            if (res.getStatusCode() == 204 || res.getStatusCode() == 200 || res.getStatusCode() == 201) {
               // A resposta está no corpo da variável 'res'
               // String responseBody = res.getBody();
                String responseBody = 'Sucesso';
                responseList.add(responseBody);
                // Faça o que desejar com os dados da resposta
            } else {
                // A chamada não foi bem-sucedida, você pode tratar isso aqui
                System.debug('Chamada ao endpoint falhou com código de status: ' + res.getStatusCode());
                System.debug('Body: ' + res.getBody());
                System.debug('Status: ' + res.getStatus());
                
            }
        } catch (Exception ex) {
            // Lida com exceções, se ocorrerem
            System.debug('Exceção ao fazer a chamada ao endpoint: ' + ex.getMessage());
            String mensagemExcecao =
            'CLASSE = FlowCreateOppAndOppProduct' +
            ', LINHA = ' +
            ex.getLineNumber() +
            ', TYPE = ' +
            ex.getTypeName() +
            ', MESSAGE = ' +
            ex.getMessage();
            System.debug(mensagemExcecao);
        }

        retorno.textoRetorno = returnList;
        retornoList.add(retorno);
        return retornoList;
    }

    public class InputVariables
    {
        @InvocableVariable
        public List<String> accountIdFromFlow;
        
        @InvocableVariable
        public List<String> pricebookEntryIdFromFlow;

        @InvocableVariable
        public List<String> pklTypeFromFlow;

    }

    public class ReturnVariables
    {
        @InvocableVariable
        public List<String> textoRetorno;
    }
}