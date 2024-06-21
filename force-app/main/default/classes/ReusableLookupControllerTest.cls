@IsTest
private class ReusableLookupControllerTest {
    @TestSetup
    static void makeData(){
        AccountDataFactory.insertBusinessAccount();
    }

    @IsTest
    static void testSearch(){
        
        ReusableLookupController.SearchWrapper input = new ReusableLookupController.SearchWrapper();
        input.objectApiName = 'Account';
        input.fieldApiName = 'Name';
        input.otherFieldApiName = 'Industry';
        input.searchString = 'Test';
        Test.startTest();
        List<ReusableLookupController.ResultWrapper> result = ReusableLookupController.fetchRecords(input);
        Test.stopTest();

        Assert.isFalse(result.isEmpty(), 'The result should not be empty');
    }

    @IsTest
    static void testSearch2(){
        
        ReusableLookupController.SearchWrapper input = new ReusableLookupController.SearchWrapper();
        input.objectApiName = 'Account';
        input.fieldApiName = 'Name';
        input.otherFieldApiName = 'Industry';
        input.searchString = 'Test';
        input.selectedRecordId = '001000000000000000';
        Test.startTest();
        List<ReusableLookupController.ResultWrapper> result = ReusableLookupController.fetchRecords(input);
        Test.stopTest();

        Assert.isFalse(!result.isEmpty(), 'The result should be empty');
    }

    @IsTest
    static void testSearch3(){
        
        ReusableLookupController.SearchWrapper input = new ReusableLookupController.SearchWrapper();
        input.objectApiName = 'Account';
        input.fieldApiName = 'Name';
        input.otherFieldApiName = 'Industry';
        input.searchString = 'Test';
        input.parentFieldApiName = 'Name';
        input.parentRecordId = '001000000000000000';
        Test.startTest();
        List<ReusableLookupController.ResultWrapper> result = ReusableLookupController.fetchRecords(input);
        Test.stopTest();

        Assert.isFalse(!result.isEmpty(), 'The result should be empty');
    }
}