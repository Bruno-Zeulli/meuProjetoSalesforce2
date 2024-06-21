/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
public class CTIIntegrationQueueable implements Queueable, Database.AllowsCallouts {
    public static final Integer CALLOUT_ATTEMPTS = 3;
    public static final String CTI_API_VERSION = '1';
    private Map<Id, CampaignMember> mapCampaignMembers;
    private String token { get; set; }
    private Map<String, List<CTIIntegrationModel>> mapCTILists { get; set; }
    private System.TriggerOperation operation { get; set; }

    public CTIIntegrationQueueable(Map<String, List<CTIIntegrationModel>> mapCTILists, System.TriggerOperation operation){
        this.mapCTILists = mapCTILists;
        this.operation = operation;
    }

    public void execute(QueueableContext context){
        token = GetAccessTokenUtil.getInstance().getToken('CTI', 'SSO');
        if(token != null){
            sendToCTI();
        }
    }

    private void sendToCTI(){
        for(String key : mapCTILists.keySet()){
            Integer httpMethod = getFunctionHttpMethod();
            String endpoint =
                ExternalAPI__c.getValues('CTI').Endpoint__c +
                'api/v' +
                CTI_API_VERSION +
                '/five9/list/' +
                EncodingUtil.urlEncode(key, 'UTF-8').replaceAll('\\+', '%20') +
                '/' +
                httpMethod +
                '/integration';
            String body = JSON.serialize(mapCTILists.get(key));
            CallAPI call = new CallAPI(endpoint, body, 'Bearer ' + this.token);
            HttpResponse retorno;
            Integer attempts = 0;
            Boolean success = false;
            do {
                attempts++;
                retorno = call.postHttpResponse();
                if(retorno != null){
                    success = (retorno.getStatusCode() == 200);
                }
                System.debug('sendToCTI (' + key + ') (' + operation + ') Retorno: ' + retorno);
            } while (!success && (attempts < CALLOUT_ATTEMPTS));
        }
    }

    private Integer getFunctionHttpMethod(){
        if(operation == System.TriggerOperation.BEFORE_DELETE){
            return 2;
        }
        return 1;
    }

    public class CTIIntegrationModel {
        String number1 { get; set; }
        String number2 { get; set; }
        String number3 { get; set; }
        String number4 { get; set; }
        String firstName { get; set; }
        String lastName { get; set; }
        String cpf { get; set; }
        String salesforceId { get; set; }
        String dtCarga { get; set; }
        String prioridade { get; set; }
        String nuContrato { get; set; }
        String dtAlocacao { get; set; }
        String dtAdesao { get; set; }
        String email { get; set; }

        public CTIIntegrationModel(
            String number1,
            String number2,
            String number3,
            String number4,
            String firstName,
            String lastName,
            String cpf,
            String salesforceId,
            Datetime dtCarga,
            Decimal prioridade,
            string nuContrato,
            date dtAlocacao,
            date dtAdesao,
            string email
        ){
            this.number1 = number1;
            this.number2 = number2;
            this.number3 = number3;
            this.number4 = number4;
            this.firstName = firstName;
            this.lastName = lastName;
            this.cpf = PersonalInformationUtil.formatCPFCNPJ(cpf);
            this.salesforceId = salesforceId;
            this.dtCarga = String.valueOf(dtCarga.date());
            this.prioridade = String.valueOf(prioridade);
            this.nuContrato = String.valueOf(nuContrato);
            this.dtAlocacao = String.valueOf(dtAlocacao);
            this.dtAdesao = String.valueOf(dtAdesao);
            this.email = email;
        }
    }
}