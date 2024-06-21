@isTest
public class beetalk_calculateBH_contact_Test 
{
    @isTest
    public static void calculateBHBeetalk()
    {
        List<beetalk_calculateBusinessHours_contact.InputVariables> lstIv = new List<beetalk_calculateBusinessHours_contact.InputVariables>();
        beetalk_calculateBusinessHours_contact.InputVariables iv = new  beetalk_calculateBusinessHours_contact.InputVariables();
        List<Datetime> dt = new List<Datetime>();
        Datetime n = (Datetime) System.now();
        dt.add(n);
        iv.dateMessage = dt;
           
        lstIv.add(iv);
        
        beetalk_calculateBusinessHours_contact.calculateBusinessHours(lstIv);
    }
}