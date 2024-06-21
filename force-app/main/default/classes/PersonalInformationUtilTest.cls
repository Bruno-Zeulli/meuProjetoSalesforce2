/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
@isTest
public class PersonalInformationUtilTest {
  @isTest
  static void testCNPJGenerator(){
    String cnpj = PersonalInformationUtil.generateRandomCNPJ();
    System.assert(cnpj != null, 'Valid cnpj format');
    System.assert(PersonalInformationUtil.isValidCNPJ(cnpj), 'Valid cnpj format');
    cnpj = PersonalInformationUtil.generateRandomFormattedCNPJ();
    System.assert(PersonalInformationUtil.isFormattedValidCNPJ(cnpj), 'Valid cnpj format');
  }

  @isTest
  static void testCPFGenerator(){
    String cpf = PersonalInformationUtil.generateRandomCPF();
    System.assert(cpf != null, 'Valid cpf format');
    System.assert(PersonalInformationUtil.isValidCPF(cpf), 'Valid cpf format');
    cpf = PersonalInformationUtil.generateRandomFormattedCPF();
    System.assert(PersonalInformationUtil.isFormattedValidCPF(cpf), 'Valid cpf format');
  }

  @isTest
  static void testEmailValidator(){
    String email = null;
    Boolean validEmail = PersonalInformationUtil.isValidEmail(email);
    System.assert(validEmail, 'Email not informed');
    email = 'daniloteixeira@wizsolucoes.com.br';
    validEmail = PersonalInformationUtil.isValidEmail(email);
    System.assert(validEmail, 'Correct email format');
    email = 'daniloteixeira@@wizsolucoes.com.br';
    validEmail = PersonalInformationUtil.isValidEmail(email);
    System.assert(!validEmail, 'Incorrect email format');
  }

  @isTest
  static void testCPFCNPJMethods(){
    String cpf = '711.909.030-59';
    String cnpj = '42.278.473/0001-03';

    //Expected true
    Boolean expected = true;
    Boolean actual;
    actual = PersonalInformationUtil.isFormattedValidCPFCNPJ(cpf);
    System.assertEquals(expected, actual, 'Correct cpf/cnpj format');
    actual = PersonalInformationUtil.isFormattedValidCPFCNPJ(cnpj);
    System.assertEquals(expected, actual, 'Correct cpf/cnpj format');
    actual = PersonalInformationUtil.isValidCPFCNPJ(cnpj);
    System.assertEquals(expected, actual, 'Correct cpf/cnpj format');
    actual = PersonalInformationUtil.isFormattedCPFCNPJ(cnpj);
    System.assertEquals(expected, actual, 'Correct cpf/cnpj format');
    expected = false;

    //Expected false
    actual = PersonalInformationUtil.isFormattedValidCPFCNPJ(null);
    System.assertEquals(expected, actual, 'Incorrect cpf/cnpj format');
    cpf = PersonalInformationUtil.unformatCPFCNPJ(null);
    System.assertEquals(null, cpf, 'Incorrect cpf/cnpj format');
    cpf = PersonalInformationUtil.formatCPFCNPJ(null);
    System.assertEquals(null, cpf, 'Incorrect cpf/cnpj format');
    cpf = '1111111';
    cpf = PersonalInformationUtil.formatCPFCNPJ(cpf);
    System.assertEquals(null, cpf, 'Incorrect cpf/cnpj format');
    cpf = '71190903059';
    actual = PersonalInformationUtil.isFormattedCPFCNPJ(cpf);
    System.assertEquals(expected, actual, 'Incorrect cpf/cnpj format');
    cpf = '71190903058';
    actual = PersonalInformationUtil.isValidCPFCNPJ(cpf);
    System.assertEquals(expected, actual, 'Incorrect cpf/cnpj format');
    cnpj = '42278473000101';
    actual = PersonalInformationUtil.isValidCPFCNPJ(cnpj);
    System.assertEquals(expected, actual, 'Incorrect cpf/cnpj format');
    actual = PersonalInformationUtil.isValidCPF(null);
    System.assertEquals(expected, actual, 'Incorrect cpf/cnpj format');
    actual = PersonalInformationUtil.isValidCNPJ(null);
    System.assertEquals(expected, actual, 'Incorrect cpf/cnpj format');
  }

  @isTest
  static void testPhoneMethods(){
    String phone = '(61) 99999-5555';
    Boolean expected = true;
    Boolean actual;
    actual = PersonalInformationUtil.isFormattedPhone(phone);
    System.assertEquals(expected, actual, 'Correct phone format');
    phone = '(61)99999-5555';
    actual = PersonalInformationUtil.isFormattedPhone(phone);
    System.assertEquals(expected, actual, 'Correct phone format');
    expected = false;
    phone = null;
    actual = PersonalInformationUtil.isFormattedPhone(phone);
    System.assertEquals(expected, actual, 'Telefone não informado!');
    String phoneDesformatado = PersonalInformationUtil.unformatPhone(phone);
    System.assertEquals(null, phoneDesformatado, 'Telefone formatado!');
    phone = '(61)99999-5555';
    phoneDesformatado = PersonalInformationUtil.unformatPhone(phone);
    System.assertEquals('61999995555', phoneDesformatado, 'Telefone desformatado!');
  }
}