@isTest
public with sharing class AggregateResultWrapperTest {
    @isTest
    static void implementationAggregateResultWrapper(){
        AggregateResultWrapper[] lstAggResult = new List<AggregateResultWrapper>();
        AggregateResultTO.AggResultDistributionOpps agg1 = new AggregateResultTO.AggResultDistributionOpps();
        AggregateResultTO.AggResultDistributionOpps agg2 = new AggregateResultTO.AggResultDistributionOpps();
        AggregateResultTO.AggResultDistributionOpps agg3 = new AggregateResultTO.AggResultDistributionOpps();

        agg1.expr0 = 2;
        agg1.ownerId = 'id002';
        agg2.expr0 = 1;
        agg2.ownerId = 'id001';
        agg3.expr0 = 3;
        agg3.ownerId = 'id003';

        lstAggResult.add(new AggregateResultWrapper(agg1));
        lstAggResult.add(new AggregateResultWrapper(agg2));
        lstAggResult.add(new AggregateResultWrapper(agg3));
        lstAggResult.sort();

        String expected = 'id001'; // O ID 'id001' é o menor valor (expr0 = 1)
        String actual = lstAggResult[0].agg.ownerId;

        System.assertEquals(expected, actual, 'Expected the first ownerId to be id001');
    }
}