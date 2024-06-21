/**
 * @description       :
 * @author            : Windson Santos
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
public with sharing class B2U_AgendaMaisListController {
  @AuraEnabled(cacheable=true)
  public static List<OppReturnModel> getOppsList(
    String db,
    String city,
    String stageName,
    String description,
    Integer offsetValue
  ) {
    List<OppReturnModel> returnModelList = new List<OppReturnModel>();
    String q = 'SELECT Id, Name, AccountId, Account.Name, Account.Phone, Account.Industry, Account.NumberOfEmployees, StageName, CloseDate, Description, LastModifiedDate FROM Opportunity WHERE RecordType.Name = \'B2U - Lead2Business\'';
    if (String.isNotBlank(db)) {
      q += ' AND DerivedFrom__c = :db';
    }
    if (String.isNotBlank(city)) {
      q += ' AND Account.BillingCity = :city';
    }
    if (String.isNotBlank(stageName)) {
      q += ' AND StageName = :stageName';
    }
    q += ' ORDER BY AccountId LIMIT 50 OFFSET :offsetValue';
    List<Opportunity> oppList = (List<Opportunity>) Database.query(q);
    for (Opportunity opp : oppList) {
      if (
        String.isBlank(description) ||
        (String.isNotBlank(description) &&
        String.isNotBlank(opp.Description) &&
        opp.Description.containsIgnoreCase(description))
      ) {
        OppReturnModel returnModel = new OppReturnModel(
          opp.Id,
          opp.Name,
          '/lightning/r/Opportunity/' +
          opp.Id +
          '/view',
          opp.AccountId,
          opp.Account.Name,
          '/lightning/r/Account/' +
          opp.AccountId +
          '/view',
          opp.Account.Phone,
          opp.StageName,
          opp.CloseDate,
          opp.LastModifiedDate,
          opp.Account.Industry,
          opp.Account.NumberOfEmployees,
          opp.Description
        );
        returnModelList.add(returnModel);
      }
    }
    return returnModelList;
  }

  // Adicionado acessão para Warning
  @SuppressWarnings('PMD.ExcessivePublicCount ')
  public class OppReturnModel {
    @AuraEnabled
    public Id id { get; set; }
    @AuraEnabled
    public String oppName { get; set; }
    @AuraEnabled
    public String oppURL { get; set; }
    @AuraEnabled
    public String accId { get; set; }
    @AuraEnabled
    public String accName { get; set; }
    @AuraEnabled
    public String accURL { get; set; }
    @AuraEnabled
    public String accPhone { get; set; }
    @AuraEnabled
    public String stageName { get; set; }
    @AuraEnabled
    public String industry { get; set; }
    @AuraEnabled
    public Integer employees { get; set; }
    @AuraEnabled
    public Date closeDate { get; set; }
    @AuraEnabled
    public Datetime lastModifiedDate { get; set; }
    @AuraEnabled
    public String description { get; set; }

    // Adicionado acessão para Warning
    @SuppressWarnings('PMD.ExcessiveParameterList')
    public OppReturnModel(
      Id id,
      String oppName,
      String oppURL,
      String accId,
      String accName,
      String accURL,
      String accPhone,
      String stageName,
      Date closeDate,
      Datetime lastModifiedDate,
      String industry,
      Integer employees,
      String description
    ) {
      this.id = id;
      this.oppName = oppName;
      this.oppURL = oppURL;
      this.accId = accId;
      this.accName = accName;
      this.accURL = accURL;
      this.accPhone = accPhone;
      this.stageName = stageName;
      this.closeDate = closeDate;
      this.lastModifiedDate = lastModifiedDate;
      this.industry = industry;
      this.employees = employees;
      this.description = description;
    }
  }
}