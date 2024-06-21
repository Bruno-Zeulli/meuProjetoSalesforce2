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
public class StringUtilTest {
  @isTest
  static void testConvertToTwoDigits(){
    String expected = '01';
    String actual = StringUtil.convertToTwoDigits(1);
    System.assertEquals(expected, actual, 'Test convert to two digits equals "01"');
    expected = null;
    actual = StringUtil.convertToTwoDigits(null);
    System.assertEquals(expected, actual, 'Test convert to two digits equals "null"');
  }

  @isTest
  static void testConvertToNDigits(){
    String expected = '0001';
    String actual = StringUtil.convertToNDigits(4, 1);
    System.assertEquals(expected, actual, 'Test convert to N digits equals "0001"');
    expected = '200';
    actual = StringUtil.convertToNDigits(3, 200);
    System.assertEquals(expected, actual, 'Test convert to N digits equals "200"');
    expected = '0200';
    actual = StringUtil.convertToNDigits(4, 200);
    System.assertEquals(expected, actual, 'Test convert to N digits equals "0200"');
    expected = null;
    actual = StringUtil.convertToNDigits(2, null);
    System.assertEquals(expected, actual, 'Test convert to N digits equals "null"');
    expected = null;
    actual = StringUtil.convertToNDigits(null, 2);
    System.assertEquals(expected, actual, 'Test convert to N digits equals "null"');
    expected = null;
    actual = StringUtil.convertToNDigits(2, 200);
    System.assertEquals(expected, actual, 'Test convert to N digits equals "null"');
  }
}