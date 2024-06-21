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
public class PersonalInformationUtilCNPJTest {
    @isTest
    static void personalInformationUtilCNPJTest(){
        String cnpj1 = PersonalInformationUtil.generateRandomFormattedCNPJ();
        String cnpj2 = PersonalInformationUtil.generateRandomCNPJ();
        Boolean cnpjTest =false;
        Test.startTest();
            cnpjTest=   PersonalInformationUtilCNPJ.isFormattedValidCNPJ(cnpj1);
            System.assertEquals(cnpjTest,true , 'Teste fail personalInformationUtilCNPJTest');
            cnpjTest=   PersonalInformationUtilCNPJ.isFormattedValidCNPJ(cnpj2);
            System.assertEquals(cnpjTest,false , 'Teste fail personalInformationUtilCNPJTest');
        Test.stopTest();
    }
}