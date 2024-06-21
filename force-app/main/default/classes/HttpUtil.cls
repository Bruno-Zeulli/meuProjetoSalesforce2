public class HttpUtil {
    private String endpoint;
    private String method;
    private String requestBody;
    private HttpRequest request;
    private HttpResponse response;
    private Map<String, String> headers = new Map<String, String>();

    public HttpUtil(String endpoint, String method) {
        this.endpoint = endpoint;
        this.method = method.toUpperCase();
    }

    public Integer getStatusCode(){
      return this.response.getStatusCode();
    }

    public String getResponseBody(){
      return this.response.getBody();
    }

    public void setEndpoint(String endpoint){
        this.endpoint = endpoint;
    }

    public void setMethod(String method){
        this.method = method;
    }

    public void setRequestBody(String requestBody) {
        this.requestBody = requestBody;
    }

    public void addHeader(String key, String value) {
        this.headers.put(key, value);
    }

    public void buildRequest() {
        this.request = new HttpRequest();
        this.request.setEndpoint(endpoint);
        this.request.setMethod(method);

        if (!headers.isEmpty()) {
            for (String key : headers.keySet()) {
                this.request.setHeader(key, headers.get(key));
            }
        }

        if (method != null && (method.equals('POST') || method.equals('PUT') || method.equals('PATCH'))) {
            this.request.setBody(requestBody);
        }
    }

    public void sendRequest(){
      Http http = new Http();
      this.response = http.send(request);
    }
}