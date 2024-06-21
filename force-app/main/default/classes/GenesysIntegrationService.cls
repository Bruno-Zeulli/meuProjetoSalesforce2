public class GenesysIntegrationService {
    private final static String BASE_URL = 'callout:GenesysCloudAPI';
    private final static String CONTACT_LISTS_BASE_URL = '/api/v2/outbound/contactlists/';

    @AuraEnabled
    public static String getDialerDetail(
        String dialerContactId,
        String dialerContactListId
    ) {
        Map<String, String> jsonResponse = new Map<String, String>();
        String urlSufix =
            CONTACT_LISTS_BASE_URL +
            dialerContactListId +
            '/contacts/' +
            dialerContactId;

        HttpUtil httpUtil = new HttpUtil(BASE_URL + urlSufix, 'GET');
        httpUtil.buildRequest();
        httpUtil.sendRequest();

        Map<String, Object> jsonRoot = (Map<String, Object>) JSON.deserializeUntyped(
            httpUtil.getResponseBody()
        );
        Map<String, Object> dialerDetail = (Map<String, Object>) (jsonRoot.get(
            'data'
        ));
        String campaignMemberId = (String) dialerDetail.get('CampaignMemberId');

        List<CampaignMember> campaignMember = [
            SELECT
                Id,
                WhatId__c,
                LeadOrContactId,
                ContactDetail__c,
                Campaign.CampaignSource__c
            FROM CampaignMember
            WHERE Id = :campaignMemberId
        ];

        if (campaignMember.isEmpty()) {
            return null;
        }

        String recordId;
        if (campaignMember[0].Campaign.CampaignSource__c == 'Parceiros') {
            recordId = campaignMember[0].LeadOrContactId;
        } else {
            recordId = String.isNotBlank(campaignMember[0].WhatId__c)
                ? campaignMember[0].WhatId__c
                : String.isNotBlank(campaignMember[0].ContactDetail__c)
                      ? campaignMember[0].ContactDetail__c
                      : campaignMember[0].LeadOrContactId;
        }

        jsonResponse.put('recordId', recordId);
        jsonResponse.put(
            'objectApiName',
            ((Id) recordId).getSObjectType().getDescribe().getName()
        );
        return JSON.serialize(jsonResponse);
    }

    @AuraEnabled
    public static String putTabulacao(
        String dialerContactId,
        String dialerContactListId,
        String requestBody
    ) {
        Map<String, String> jsonResponse = new Map<String, String>();
        String urlSufix =
            CONTACT_LISTS_BASE_URL +
            dialerContactListId +
            '/contacts/' +
            dialerContactId;
            
        HttpUtil httpUtil = new HttpUtil(BASE_URL + urlSufix, 'PUT');
        httpUtil.setRequestBody(requestBody);
        httpUtil.addHeader('Content-Type', 'application/json');
        httpUtil.buildRequest();
        httpUtil.sendRequest();

        return httpUtil.getResponseBody();
    }

    public static String createContacts(
        String requestBody,
        String contactListId
    ) {
        String urlSufix = CONTACT_LISTS_BASE_URL + contactListId + '/contacts/';

        HttpUtil httpUtil = new HttpUtil(BASE_URL + urlSufix, 'POST');
        httpUtil.setRequestBody(requestBody);
        httpUtil.addHeader('Content-Type', 'application/json');
        httpUtil.buildRequest();
        httpUtil.sendRequest();

        System.debug(httpUtil.getResponseBody());

        return httpUtil.getResponseBody();
    }
}