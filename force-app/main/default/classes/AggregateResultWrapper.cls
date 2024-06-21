public without sharing class AggregateResultWrapper implements Comparable  {
    public AggregateResultTO.AggResultDistributionOpps agg;
    public AggregateResultWrapper(AggregateResultTO.AggResultDistributionOpps ag){
        agg = ag;
    }
    public Integer compareTo(Object compareTo){
        Integer returnValue = 0;
        AggregateResultWrapper compareToAgg = (AggregateResultWrapper)compareTo;
        if(agg.expr0 > compareToAgg.agg.expr0){
            returnValue = 1;
        }else if(agg.expr0 == compareToAgg.agg.expr0){
            returnValue = 0;
        }
        return returnValue;
    }
}