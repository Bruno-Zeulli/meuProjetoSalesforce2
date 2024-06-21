@IsTest
public with sharing class QueueAssignmentControllerTest {
    @testSetup static void setup() {

        Group gp = new Group(Name='CONSEG_TEST', DeveloperName='TEST');
        insert gp;
        
        Id p = [SELECT Id FROM Profile WHERE Name='Administrador'].id;
       
        Account ac = new Account(name ='Test', CompanyIdentificationNumber__c = '14343271000154') ;
        insert ac; 
        
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id);
        insert con; 
                    
        User user = new User(alias = 'test123', email='queueassignment@noemail.com',
                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                    localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                    BusinessUnit__c = 'CONSEG',
                    timezonesidkey='America/Los_Angeles', username='tester@noemail.com' + System.currentTimeMillis());
        
        insert user;
        
                    
        User user2 = new User(alias = 'test456', email='queueassignment2@noemail.com',
                    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                    localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                    BusinessUnit__c = 'CONSEG',
                    timezonesidkey='America/Los_Angeles', username='tester2@noemail.com' + System.currentTimeMillis());
        
        insert user2;
        
    }

    @IsTest
    static void fetchQueueAssignmentsTest() {
        
        Group gp = [SELECT Id, Name FROM Group WHERE Name = 'CONSEG_TEST'];

        User user = [SELECT Id FROM User WHERE Email = 'queueassignment@noemail.com'];

        GroupMember gpm = new GroupMember(GroupId=gp.Id, UserOrGroupId=user.Id);
        insert gpm;
        
        system.runAs(user) {
            Assert.areNotEqual(0, QueueAssignmentController.fetchQueueAssignments(gp.Id).availableUsers.size());
        }
    }

    @IsTest
    static void addRemoveInQueuesTest() {
        
        Group gp = [SELECT Id, Name FROM Group WHERE Name = 'CONSEG_TEST'];

        User user = [SELECT Id FROM User WHERE Email = 'queueassignment@noemail.com'];
        //Buscando qualquer outro usuário pra ser 'adicionado' na fila
        User userSelected = [SELECT Id FROM User WHERE Email = 'queueassignment2@noemail.com' LIMIT 1];
        String userIdSel = userSelected.Id;
        
        GroupMember gpm = new GroupMember(GroupId=gp.Id, UserOrGroupId=user.Id);
        insert gpm;
        
        system.runAs(user) {
            Assert.areEqual('Successful', QueueAssignmentController.addRemoveInQueues(new List<String>{userIdSel}, gp.Id), 'Retorno esperado é: Successful');
        }
    }
}