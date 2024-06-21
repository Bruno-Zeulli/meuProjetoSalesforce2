@isTest()
public with sharing class ConvertCSVToRecordsHelperTest {

    static testMethod void getObjectFieldsTest(){
        List<Map<String,String>> fields = ConvertCSVToRecordsHelper.getObjectFields('Account');
     }

}