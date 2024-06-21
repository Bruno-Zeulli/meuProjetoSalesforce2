public class FlowUpdateOwnerAccount
{
    @invocableMethod
    public static list<ReturnVariables> updateOwnerAccount (List<InputVariables> InputVariables)
    {
        //Variaveis
        String idAccountToUpdate = InputVariables.get(0).IdAccountToUpdate.get(0);
        String newOwnerId = InputVariables.get(0).IdUserToUpdate.get(0);
        List<String> responseList = new List<String>();
        String PjouPf = InputVariables.get(0).PjouPf.get(0);
        String token = '';
        String endpointApiCRM = '';

        //Variaveis de Retorno
        List<ReturnVariables> retornoList = new List<ReturnVariables>();
        ReturnVariables retorno = new ReturnVariables();

        if(!Test.isRunningTest())
        token = GetAccessTokenUtil.getInstance().getToken('ApiCRM', 'SSO');

        String apiNameToGetEndpoint = 'ApiCRM';

        if(!Test.isRunningTest())
        endpointApiCRM = ExternalAPI__c.getValues(apiNameToGetEndpoint).Endpoint__c;

        // Defina o URL do endpoint que você deseja chamar
        String endpointURL = endpointApiCRM+'/api/v2/accounts/'+PjouPf+'/'+idAccountToUpdate;

        // Crie uma instância HttpRequest
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();

        // Criar um mapa para representar o objeto JSON
        Map<String, Object> requestBodyMap = new Map<String, Object>();

        // Definir o novo valor do ownerId no mapa
        requestBodyMap.put('ownerId', newOwnerId);

        // Converter o mapa em JSON
        String requestBody = JSON.serialize(requestBodyMap);

        String authHeader = 'Bearer ' + token;
        req.setEndpoint(endpointURL);
        req.setHeader('Authorization', authHeader);
        req.setMethod('PATCH'); // Defina o método como PATCH
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setBody(requestBody);


        try {
            // Faça a chamada ao endpoint
            if(!Test.isRunningTest())
            res = http.send(req);

            // Verifique se a resposta foi bem-sucedida (código de status 200)
            if (res.getStatusCode() == 204) {
                // A resposta está no corpo da variável 'res'
               // String responseBody = res.getBody();
                String responseBody = 'Sucesso';
                responseList.add(responseBody);
                // Faça o que desejar com os dados da resposta
            } else {
                // A chamada não foi bem-sucedida, você pode tratar isso aqui
                System.debug('Chamada ao endpoint falhou com código de status: ' + res.getStatusCode());
            }
        } catch (Exception ex) {
            // Lida com exceções, se ocorrerem
            System.debug('Exceção ao fazer a chamada ao endpoint: ' + ex.getMessage());
            String mensagemExcecao =
            'CLASSE = FlowUpdateOwnerAccount' +
            ', LINHA = ' +
            ex.getLineNumber() +
            ', TYPE = ' +
            ex.getTypeName() +
            ', MESSAGE = ' +
            ex.getMessage();
            System.debug(mensagemExcecao);
        }

        retorno.textoRetorno = responseList;
        retornoList.add(retorno);
        return retornoList;
    }

    public class InputVariables
    {
        @InvocableVariable
        public List<String> IdAccountToUpdate;

        @InvocableVariable
        public List<String> IdUserToUpdate;

        @InvocableVariable
        public List<String> PjouPf;
    }

    public class ReturnVariables
    {
        @InvocableVariable
        public List<String> textoRetorno;
    }
}