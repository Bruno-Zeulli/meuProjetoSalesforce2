/**
 * @description       : Model utilizada para chamadas mktc
 * @author            : Marcelo Martins
 * @email             : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-11-2022   marcelomartins@wizsolucoes.com.br    Initial Version
 **/

@SuppressWarnings('PMD.ExcessivePublicCount')
public without sharing class GetAccessTokenTO {
  
    public class ResponseToken {
        public String access_token { get; set; }
        public Integer expires_in { get; set; }
        public String token_type { get; set; }
        public String scope { get; set; }
    }

    public class LoginCredentialsMktCloud {
        public String client_id { get; set; }
        public String client_secret { get; set; }
        public String account_id { get; set; }
        public String grant_type { get; set; }
    }

}