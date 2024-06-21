/**
 * @description       :
 * @author            : samuelsirkis@wiz.co
 * @group             :
 * @last modified on  : 31-01-2023
 * @last modified by  : samuelsirkis@wiz.co
 * Modifications Log
 * Ver   Date         Author                Modification
 * 1.0   31-01-2023   samuelsirkis@wiz.co   Initial Version
 **/
@isTest
public class PersonalInformationUtilCPFTest {
    @isTest
    static void personalInformationUtilCPFTest(){
        String cpf1 = PersonalInformationUtil.generateRandomFormattedCPF();
        String cpf2 = PersonalInformationUtil.generateRandomCPF();
        Boolean cpfTest =false;
        Test.startTest();
            cpfTest=   PersonalInformationUtilCPF.isFormattedValidCPF(cpf1);
            System.assertEquals(cpfTest,true , 'Teste fail personalInformationUtilCPFTest');
            cpfTest=   PersonalInformationUtilCPF.isFormattedValidCPF(cpf2);
            System.assertEquals(cpfTest,false , 'Teste fail personalInformationUtilCPFTest');
        Test.stopTest();
    }
}