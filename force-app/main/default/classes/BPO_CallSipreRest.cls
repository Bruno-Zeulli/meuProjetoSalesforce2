/**
 * @description       :
 * @author            : Windson Santos
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/

public class BPO_CallSipreRest extends WebserviceREST {
  /**
   * @descripion
   * @param serializedParameter
   * @return results
   */
  public Map<String, Object> postSipreRest(String serializedParameter){
    String token;
    Map<String, Object> results = new Map<String, Object>();
    method = 'POST';
    URL = ExternalAPI__c.getValues('SIPRE').Endpoint__c;
    String strJSON = Callout(token, serializedParameter);
    //System.debug('Retorno json contract: ' + strJSON);
    results.put('Status', 'Success');
    results.put('WSResponseStatusCode', StatusCode);

    if(Error){
      results.put('Status', 'Failed');
      results.put('ErrorMessage', ErrorMessage);
      System.debug('Callout error: ' + ErrorMessage);
    }else if(StatusCode == 201 || StatusCode == 200){
      results.put('Retorno', 'Comunicado processado.');
    }else{
      results.put('Status', 'Failed');
      results.put('ErrorMessage', 'Endpoint retornou código de falha.');
    }

    return results;
  }
}