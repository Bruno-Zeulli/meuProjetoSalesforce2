@isTest
public class InvocableIsInBusinessHoursTest {
    @isTest
    static void testIsInBusinessHours(){
        List<BusinessHours> bhs=[select id, Name from BusinessHours];
        
        List<InvocableIsInBusinessHours.ParamsRequests> reqs = new List<InvocableIsInBusinessHours.ParamsRequests>();
        InvocableIsInBusinessHours.ParamsRequests req = new InvocableIsInBusinessHours.ParamsRequests();
        req.businessHoursName = bhs[0].Name;
        reqs.add(req);
        
        Test.startTest();
        	InvocableIsInBusinessHours.isInBusinessHour(reqs);
        Test.stopTest();
    }
}