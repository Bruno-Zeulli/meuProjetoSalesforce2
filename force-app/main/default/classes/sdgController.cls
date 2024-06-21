/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
public with sharing class sdgController {

    public static String lModify {get;set;}
    public static String lHeaderTitle {get;set;}

    @AuraEnabled
    public static string GetNamespace()
    {
        return JSON.serialize(sdgNamespaceUtility.GetNamespace());
    }

    @AuraEnabled
    public static String GetSDGInitialLoad(String ParentRecordID, String SDGTag, String RelationshipName, String FieldSetName, integer DefaultPageSize)
    {
        //Create response object
        SDGInitialLoad initial = new SDGInitialLoad();
        // Salesforce bug with Lightning serializer requires re-casting this value
        //https://salesforce.stackexchange.com/questions/108355/limit-expression-must-be-of-type-integer-error-when-using-apex-variable-in-soq/108423#108423
         try{
            DefaultPageSize = Integer.valueOf(DefaultPageSize);
        }
        catch (Exception ex)
        {
            throw new AuraHandledException('Invalid DefaultPageSize provided');
        }

        System.debug('sdgController:GetSDGInitialLoad:' + ParentRecordID + ':' + SDGTag + ':' + RelationshipName + ':' + FieldSetName);
        try
        {
            SDG newSDG = SDGDataProviderFactory.LoadSDG(SDGTag, ParentRecordId, RelationshipName, FieldsetName);
            //Create a full request:
            SDGRequest req = new SDGRequest();

            if(!String.isBlank(SDGTag))
            {
            	req = sdgPreferences.GenerateRequestWithFilters(newSDG, ParentRecordID, SDGTag);
            }
            req.RelationshipName = RelationshipName;
            req.FieldSetName = FieldSetName;
            req.ParentRecordID = ParentRecordID;
            req.SDGTag = SDGTag;
            req.PageSize = DefaultPageSize;

            String lRemoveTag = SDGTag.replace('CustomObject:','');

            SDGResult result = sdgDataProviderFactory.getData( req, newSDG);
            //Blank out the internal data to save payload:
            newSDG.InternalData = null;

            //build response object:
            initial.SDGObject = newSDG;
            initial.results = result;
            initial.isError = false;
            initial.SDGTag = lRemoveTag;
        }

        catch (SDGException ex)
        {
            initial.ErrorMessage = ex.getMessage();
            initial.isError = true;
        }
        catch (Exception standardex)
        {
            initial.ErrorMessage = standardex.getMessage();
            initial.isError = true;
        }
        return JSON.serialize(initial);
    }

    @AuraEnabled
    public static string getSDGResult(String jsonrequest)
    {
        SDGResult results = new SDGResult();

        String resultsstring = '';
        try
        {
            System.debug('sdgController:getSDGResult: getting request');
            SDGRequest request = (SDGRequest)JSON.deserialize(jsonrequest, SDGRequest.class);
            system.debug('sdgController:getSDGResult: getting result');

            results = sdgDataProviderFactory.getData(request);

            results.isError=false;
        }
        catch (Exception ex)
        {
            System.debug('sdgController:getSDGResult: Exception: ' + ex.getMessage() );
            results.ErrorMessage = ex.getMessage();
            results.isError = true;
        }
        return JSON.serialize(results);
    }

     @AuraEnabled
    public static list<SDG__c> getButtonSelect()
    {
        list<String> lLstOutPut = new list<String>();

        if(lLstOutPut.isEmpty()) return new list<SDG__c>();

        list<SDG__c> lLstObj = new list<SDG__c>();
        for(SDG__c iSdg :[SELECT id,SDG_Tag__c,sObjectName__c FROM SDG__c WHERE SDG_Tag__c = : lLstOutPut AND Is_Valid__c = true])
        {
            //lLstObj.add(iSdg.sObjectName__c);
            lLstObj.add(iSdg);
        }

        if(lLstObj.isEmpty()) return new list<SDG__c>();
        else return lLstObj;
    }

    @AuraEnabled
    public static sdgController.wrapperMain getMain(String ObjectName, String aTag, String aId)
    {
        String lTag = '';

        for(SDG__c iSdg :[SELECT id,SDG_Tag__c,sObjectName__c,SDG_Title__c FROM SDG__c WHERE sObjectName__c = : ObjectName AND SDG_Tag__c = : aTag])
        {
            if(iSdg.SDG_Tag__c == null) continue;
            lTag = iSdg.SDG_Tag__c;
            system.debug('TAG >> ' +  lTag);
        }

        wrapperMain returnwrapperClass = new  wrapperMain ();

        returnWrapperClass.lTagSapOrder = lTag;
        returnwrapperClass.jCabecalho = getHeader(ObjectName,lTag);
        returnWrapperClass.lTitleMain = lHeaderTitle;

        list<sObject> lLstCorpo = getBody(ObjectName,ObjectName,'',aId,1,'1');
        returnwrapperClass.jCorpo = lLstCorpo;
        system.debug('RETURN MAIN >> ' + returnwrapperClass);
        return returnwrapperClass;
    }

    @AuraEnabled
    public static sdgController.wrapperClass initMethod(String ObjectName,String aTag, String aId, Decimal pageNumber ,String recordToDisply){

        wrapperClass returnwrapperClass = new  wrapperClass ();
        list<String> lLst = new list<String>();
        String lNewTtitle = '';

        for(SDG__c iSdg :[SELECT id,SDG_Tag__c,sObjectName__c,SDG_Title__c FROM SDG__c WHERE sObjectName__c = : ObjectName AND SDG_Tag__c = : aTag])
        {
            if(iSdg.SDG_Tag__c == null) continue;
            lLst.add(iSdg.SDG_Tag__c);
        }

        String lObjeto= '',lVerificar= '',lTag= '';


        if(lObjeto == '' || lVerificar == '' || lTag == '') return returnwrapperClass;

        returnwrapperClass.lCabecalho = getHeader(lObjeto,lTag);
        lNewTtitle = lHeaderTitle;
        returnwrapperClass.lTitle = lHeaderTitle;

        list<sObject> iLstCorpo = getBody(lObjeto,ObjectName,lVerificar,aId,pageNumber,recordToDisply);
        returnwrapperClass.lCorpo = iLstCorpo;

        returnwrapperClass.lId = aId;
        returnwrapperClass.pageSize = Integer.valueOf(recordToDisply);
        returnwrapperClass.page = (Integer) pageNumber;
        returnwrapperClass.total = database.countQuery('SELECT count() FROM '+ lObjeto + ' WHERE '+ lVerificar + ' = \'' + aId + '\'');

        system.debug('RETURN INITMETHOD >> ' + returnwrapperClass);
        return returnwrapperClass;
    }

    public static String getHeader(String lObjeto,String lTag)
    {
        String result = '', lLst = '';
        Schema.DescribeFieldResult lFields;

        list<SDG_Field__c> lstFields = new list<SDG_Field__c>();
        for(SDG_Field__c lst : [SELECT id, APIName__c,Hide_Filter__c, Override_Label__c , Field_Style__c, fieldOrder__c,
                                sdg__r.sObjectName__c, sdg__r.SDG_Title__c, is_valid_field__c,sdg__r.SDG_Tag__c
                                FROM SDG_Field__c WHERE sdg__r.sObjectName__c = :lObjeto AND sdg__r.SDG_Tag__c = :lTag
                                AND is_valid_field__c = true ORDER BY fieldOrder__c ])
        {
            lHeaderTitle = lst.sdg__r.SDG_Title__c;
            lstFields.add(lst);
        }

        return getFields(lstFields, lObjeto);
    }

    public static List<sObject> getBody(String lObjeto, String objectName, String lVerificar,String aId, Decimal pageNumber,String recordToDisply)
    {
        List<sObject> lstResult = new List<sObject>();
        String lResult = '[]';
        Integer pageSize = Integer.valueOf(recordToDisply);
        Integer offset = pageNumber == 1 ?  0 : ((Integer)pageNumber - 1) * Integer.valueOf(recordToDisply);


            String lQuery = 'SELECT Id, '+ lModify;
            lQuery += ' FROM '+ lObjeto + ' WHERE ';
            lQuery += (lObjeto == objectName) ? ' id ' : lVerificar;
            lQuery += ' = \'' + aId + '\'';
            lQuery += ' LIMIT ' + recordToDisply + ' OFFSET  ' + offset;
            lstResult = Database.query(lQuery);

        System.debug('RETURN QUERY BODY >> ' + JSON.serializePretty(lstResult));

        return lstResult;
        }

    public static String getFields(list<SDG_Field__c> lstFields, String lObjeto)
    {
        String result = '';
        String lLst = '';
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(lObjeto);
        List<SDGField> results = sdgMapper.MapToSDGFields(targetType, lstFields, true);

        for(SDGField iField :results)
        {
            if(result != ''){
                result += ',';
            }

            String colname = iField.columnName;
            if(iField.FieldType ==String.valueof(Schema.DisplayType.PICKLIST))
            {
                colname = 'tolabel(' + colname + ')';
            }
            if(iField.ColumnName.contains('__r')){iField.FieldType = 'STRING';}

            String jsonPart = '{';
            jsonPart += '"label":"' + iField.Label + '",';
            jsonPart += '"type":"' + iField.FieldType + '",';
            jsonPart += '"name":"' + iField.ColumnName + '"';
            jsonPart += '}';
            result += jsonPart;

            lLst += colname + ',';
        }

        lModify = lLst.substring(0, lLst.length() - 1);
        System.debug('RETURN FIELDS >> ' + result);
        return '['+result+']';
    }

    @AuraEnabled
    public static List<sObject> searchExportData(String aQuery)
    {
        System.debug('Query =>> '+ aQuery);
        Integer lRemoveLimit = aQuery.indexOf('limit');
        String lQuery = aQuery.substring(0,lRemoveLimit);

        List<sObject> lstResult = Database.query(lQuery);

        return lstResult;
    }

    public class wrapperClass{
        @AuraEnabled public String lCabecalho{get;set;}
        @AuraEnabled public List<sObject> lCorpo {get;set;}
        @AuraEnabled public Integer pageSize {get;set;}
        @AuraEnabled public Integer page {get;set;}
        @AuraEnabled public Integer total {get;set;}
        @AuraEnabled public String lCabecalho1{get;set;}
        @AuraEnabled public List<sObject> lCorpo1 {get;set;}
        @AuraEnabled public Integer pageSize1 {get;set;}
        @AuraEnabled public Integer page1 {get;set;}
        @AuraEnabled public Integer total1 {get;set;}
        @AuraEnabled public String lId{get;set;}
        @AuraEnabled public String lTitle{get;set;}
    }

    public class wrapperMain{
        @AuraEnabled public String jCabecalho{get;set;}
        @AuraEnabled public List<sObject> jCorpo{get;set;}
        @AuraEnabled public String lTitleMain{get;set;}
        @AuraEnabled public String lTagSapOrder{get;set;}
    }
}