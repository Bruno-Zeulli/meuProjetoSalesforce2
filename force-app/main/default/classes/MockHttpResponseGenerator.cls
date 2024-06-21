/**
* @description       :
* @author            : ChangeMeIn@UserSettingsUnder.SFDoc
* @group             :
* @last modified on  : 09-16-2023
* @last modified by  : samuelsirkis@wiz.co
* Modifications Log
* Ver   Date         Author                               Modification
* 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
* 1.1   03-02-2021   windson santos                       PMD
**/
@isTest
public class MockHttpResponseGenerator implements HttpCalloutMock {
    private Integer statusCode = 200;
    private String body;
    private Map<String, String> bodyForRequestUrl = null;

    public void setStatusCode(Integer statusCode){
        this.statusCode = statusCode;
    }

    public void addBodyToRequest(String requestUrl, String body){
        if(this.bodyForRequestUrl == null){
            this.bodyForRequestUrl = new Map<String, String>();
        }
        this.bodyForRequestUrl.put(requestUrl, body);
    }

    public void clearBodyToRequest(){
        this.bodyForRequestUrl.clear();
    }

    public void setBody(String body){
        this.body = body;
    }

    public HTTPResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');

        if(bodyForRequestUrl != null){
            String bodyToSend = bodyForRequestUrl.get(req.getEndpoint());
            res.setBody(bodyToSend);
        }

        if(String.isNotBlank(body)){
            res.setBody(body);
        }
        res.setStatusCode(statusCode);

        return res;
    }
}