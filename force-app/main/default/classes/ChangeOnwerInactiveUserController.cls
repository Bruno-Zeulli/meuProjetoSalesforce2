public with sharing class ChangeOnwerInactiveUserController {
    @AuraEnabled
    public static List<User> obterInativos(){
        List<User> usuarios = [SELECT Id, Name, Email FROM User 
                                WHERE isActive = false
                                WITH SECURITY_ENFORCED  ORDER by Name asc];
        return usuarios;
    }
    @AuraEnabled
    public static List<User> obterAtivos(){
        List<User> usuarios = [SELECT Id, Name, Email FROM User 
                                WHERE isActive = true
                                WITH SECURITY_ENFORCED  ORDER by Name asc];
        return usuarios;
    }
    @AuraEnabled
    @SuppressWarnings('PMD.ExcessiveParameterList')
    public static Integer transferirRegistrosInativos(String usuarioInativo, String usuariosAtivos, Boolean getAcc, Boolean getOpp, Boolean getCase){
        List<String> ids = usuariosAtivos.split(',');
        Integer contador = 0;
        List<SObject> records = new List<SObject>();
        if(getAcc && Account.SObjectType.getDescribe().isAccessible() &&
            Schema.SObjectType.Account.fields.Id.isAccessible() &&
            Schema.SObjectType.Account.fields.OwnerId.isAccessible()
        ){
            records.addAll([SELECT Id FROM Account WHERE OwnerId =: usuarioInativo WITH SECURITY_ENFORCED]);
        }
        if(getCase && Case.SObjectType.getDescribe().isAccessible() &&
            Schema.SObjectType.Case.fields.Id.isAccessible() &&
            Schema.SObjectType.Case.fields.OwnerId.isAccessible()
        ){
            records.addAll([SELECT Id FROM Case WHERE OwnerId =: usuarioInativo WITH SECURITY_ENFORCED]);
        }
        if(getOpp && Opportunity.SObjectType.getDescribe().isAccessible() &&
            Schema.SObjectType.Opportunity.fields.Id.isAccessible() &&
            Schema.SObjectType.Opportunity.fields.OwnerId.isAccessible()
        ){
            records.addAll([SELECT Id FROM Opportunity WHERE OwnerId =: usuarioInativo and Isclosed = false and isWon = false WITH SECURITY_ENFORCED]);
        }
        for(SObject record : records){
            record.put('OwnerId', ids[Math.mod(contador, ids.size())]);
            contador++;
        }
        if(records.size() > 0){
            update records;
        }
        return records.size();
    }
}