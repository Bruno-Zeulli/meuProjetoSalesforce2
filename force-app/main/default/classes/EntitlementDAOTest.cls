/**
 * @description       : 
 * @author            : samuelsirkis@wiz.co
 * @group             : 
 * @last modified on  : 09-22-2023
 * @last modified by  : samuelsirkis@wiz.co
**/
@isTest
public class EntitlementDAOTest {

    @isTest
    static void testGetEntitlementByName() {
        // Preparar dados de teste, incluindo um registro de Entitlement
        String entitlementName = 'Entitlement Test'; // Substitua pelo nome do Entitlement desejado
        Account acc = AccountDataFactory.insertBusinessAccount();

        // Criar um registro de Entitlement para o teste
        Entitlement testEntitlement = new Entitlement(
            Name = entitlementName,
            AccountId = acc.Id
            // Adicione outros campos necessários aqui
        );
        insert testEntitlement;

        // Executar o método getEntitlementByName da classe EntitlementDAO
        Entitlement retrievedEntitlement = EntitlementDAO.getEntitlementByName(entitlementName);

        // Verificar se o registro de Entitlement foi recuperado corretamente
        System.assertEquals(entitlementName, retrievedEntitlement.Name);
        System.assertEquals(testEntitlement.Id, retrievedEntitlement.Id);

        // Adicione mais asserts conforme necessário para verificar o comportamento esperado
    }
}