public with sharing class EntitlementDAO {
    
    public static Entitlement getEntitlementByName(String entitlementName){
        return [SELECT Id,Name from Entitlement where name =:entitlementName LIMIT 1];
    }
}