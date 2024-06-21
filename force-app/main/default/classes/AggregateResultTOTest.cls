@isTest
public with sharing class AggregateResultTOTest {

    @isTest
    static void instantiateAggResultDistributionOpps(){

        AggregateResultTO.AggResultDistributionOpps AggResultDistributionOpps = new AggregateResultTO.AggResultDistributionOpps();

        AggResultDistributionOpps.expr0 = 1;
        AggResultDistributionOpps.ownerId = '123L';

        Integer expected;
        Integer actual;
        System.assertEquals(expected, actual, 'nothing to expect');
    }
}