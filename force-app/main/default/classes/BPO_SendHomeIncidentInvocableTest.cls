@isTest
public class BPO_SendHomeIncidentInvocableTest 
{
	@isTest
    public static void sendToMAC()
    {
        List<Id> idsComunicado = new List<Id>();
        BPO_SendHomeIncidentInvocable.sendToMAC(idsComunicado);
    }
}