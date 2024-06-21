/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
@isTest
public class GeneralUtilTest {
  @isTest
  static void testGetUFAcronym(){
    String expected = 'DF';
    String actual = GeneralUtil.getUFAcronym('Distrito Federal');
    System.assertEquals(expected, actual, 'UF conversion test expected "DF"');
    expected = null;
    actual = GeneralUtil.getUFAcronym('Guanabara');
    System.assertEquals(expected, actual, 'UF conversion test expected "null"');
  }
}