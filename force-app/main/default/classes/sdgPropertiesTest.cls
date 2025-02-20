/*
Sortable Data Grid
Copyright © Felix Lindsay 21 November 2017
flindsay@gmail.com
All rights reserved
*/
@isTest
public class sdgPropertiesTest {

    @isTest
    static void testList()
    {
        Test.startTest();
        //Generate SOSL response: doesn't work in deployment
        //Id [] fixedSearchResults= new Id[1];
        //ApexClass classobj = [select id from apexclass where name = 'sdgDataProviderCustomExample' and namespaceprefix = :sdgNamespaceUtility.getNamespace() limit 1];

        //fixedSearchResults[0] = classobj.id;
        //Test.setFixedSearchResults(fixedSearchResults);


        sdgProperties props1 = new sdgProperties();
        VisualEditor.DynamicPickListRows items1 = props1.getValues();
        integer i = database.countquery ('SELECT count() FROM SDGDefaults__mdt');
        System.debug('count: ' + i);
        System.assertnotequals(0, items1.size(),  'sdgPropertiesTest:TestList Should be at least some items in SDGDefaults');
        //we can't know how many items there are though
        Boolean hasMeta = false;
        Boolean hasCustom = false;
        Boolean hasApex = false;
        for(VisualEditor.DataRow item: items1.getDataRows())
        {
            if(item.getValue()!=null)
            {
                if(String.valueOf((item.getvalue())).startswithignorecase(sdgDataProviderType.Metadata.name()))
                {    hasMeta = true;}
                if(String.valueOf((item.getvalue())).startswithignorecase(sdgDataProviderType.CustomObject.name()))
                {    hasCustom = true;}
                if(String.valueOf((item.getvalue())).startswithignorecase(sdgDataProviderType.Apex.name()))
                {    hasApex = true;}
            }
        }
        System.assertEquals(true, hasMeta, 'sdgPropertiesTest:TestList: Expected a metadata data provider (part of package)');
        System.assertEquals(false, hasCustom, 'sdgPropertiesTest:TestList: Expected no custom data providers');
        System.assertEquals(false, hasApex, 'sdgPropertiesTest:TestList: Expected no apex data provider - so SOSL results set');

        //now add one
        sdgtestdata.GenerateTestSDG();
        //And try again
        sdgProperties props2 = new sdgProperties();
        VisualEditor.DynamicPickListRows items2 = props2.getValues();
        System.assertequals(items1.size()+1, items2.size(), 'sdgPropertiesTest:TestList: Should be 1 more item');

        //now get default:
        VisualEditor.DataRow defaultitem =  props2.getDefaultValue();
        System.assertEquals(sdgProperties.DefaultLabel, defaultitem.getlabel(),'sdgPropertiesTest:TestList: Expected Relationship editor item as default');
        Test.stopTest();
    }
}