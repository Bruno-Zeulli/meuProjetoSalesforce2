@isTest
public class EmailMessageBOTest {
    
    @isTest
    public static void testSendEmail() {
        
        Id recordType = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('AcessosPPW_Tkt').getRecordTypeId();
        Case caso = new Case(
            Subject = 'Teste Chat',
            Description = 'Test chat',
            Origin = 'App',
            Type = 'Chat',
            Status = 'Comunicado Aberto',
            Priority = 'High',
            RecordTypeId = recordType
        );
        insert caso;
        
        EmailMessage email = new EmailMessage();
        email.FromAddress = 'test@abc.org';
        email.Incoming = True;
        email.ToAddress= 'test@xyz.org';
        email.Subject = 'Test email';
        email.HtmlBody = 'Test email body';
        email.ParentId = caso.Id; 
        insert email;
    }
    
}