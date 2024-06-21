public with sharing class RetornoTokenTO {
    public String access_token { get; set; }
    public Integer expires_in { get; set; }
    public String token_type { get; set; }
    public String scope { get; set; }
}