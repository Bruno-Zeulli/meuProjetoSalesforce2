/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-20-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
public with sharing class B2U_AgendaMaisMapController {
  @AuraEnabled(cacheable=true)
  public static List<Pin> getLocations(
    String db,
    String city,
    String stageName,
    String description,
    Integer offsetValue
  ) {
    List<Pin> pinList = new List<Pin>();
    String query = 'SELECT Description, AccountId, Account.Name, Account.BillingStreet, Account.BillingCity, Account.BillingState, Account.BillingPostalCode, Account.BillingCountry, Account.BillingLatitude, Account.BillingLongitude FROM Opportunity WHERE RecordType.Name = \'B2U - Lead2Business\'';
    if (String.isNotBlank(db)) {
      query += ' AND DerivedFrom__c = :db';
    }
    if (String.isNotBlank(stageName)) {
      query += ' AND StageName = :stageName';
    }
    if (String.isNotBlank(city)) {
      query += ' AND Account.BillingCity = :city';
    }
    query += ' ORDER BY AccountId LIMIT 50 OFFSET :offsetValue';
    List<Opportunity> oppList = (List<Opportunity>) Database.query(query);

    for (Opportunity opp : oppList) {
      if (
        String.isBlank(description) ||
        (String.isNotBlank(description) &&
        String.isNotBlank(opp.Description) &&
        opp.Description.containsIgnoreCase(description))
      ) {
        Location l = new Location(
          opp.Account.BillingCity,
          opp.Account.BillingCountry,
          opp.Account.BillingPostalCode,
          opp.Account.BillingState,
          opp.Account.BillingStreet
        );
        Pin p = new Pin(l, 'standard:account', opp.Account.Name);
        pinList.add(p);
      }
    }
    return pinList;
  }

  public class Location {
    @AuraEnabled
    public String city { get; set; }
    @AuraEnabled
    public String country { get; set; }
    @AuraEnabled
    public String postalCode { get; set; }
    @AuraEnabled
    public String state { get; set; }
    @AuraEnabled
    public String street { get; set; }

    private Location(String city, String country, String postalCode, String state, String street) {
      this.City = city;
      this.Country = country;
      this.PostalCode = postalCode;
      this.State = state;
      this.Street = street;
    }
  }

  public class Pin {
    @AuraEnabled
    public Location location { get; set; }
    @AuraEnabled
    public String icon { get; set; }
    @AuraEnabled
    public String title { get; set; }

    private Pin(Location location, String icon, String title) {
      this.location = location;
      this.icon = icon;
      this.title = title;
    }
  }
}