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
public class DateUtilTest {
  @isTest
  static void testStringToDate(){
    String dateVariable = '27/01/1996';
    Date expected = Date.valueOf('1996-01-27');
    Date actual = DateUtil.stringToDate(dateVariable);
    System.assertEquals(expected, actual, 'Check useful date');
    dateVariable += '1';
    actual = DateUtil.stringToDate(dateVariable);
    System.assert(actual == null, 'Useful date must be null');
    dateVariable = null;
    actual = DateUtil.stringToDate(dateVariable);
    System.assert(actual == null, 'Useful date must be null');
  }

  @isTest
  static void testDateToString(){
    String expected = '27/01/1996';
    Date dateVariable = Date.valueOf('1996-01-27');
    String actual = DateUtil.dateToString(dateVariable);
    System.assertEquals(expected, actual, 'Check useful date');
    System.assert(DateUtil.dateToString(null) == '', 'Useful date must be null');
  }

  @isTest
  static void testDateToStringMonthYear(){
    Date dateVariable = Date.valueOf('1996-01-27');
    String expected = '01/1996';
    String actual = DateUtil.dateToStringMonthYear(dateVariable);
    System.assertEquals(expected, actual, 'Check useful date');
    expected = '';
    actual = DateUtil.dateToStringMonthYear(null);
    System.assertEquals(expected, actual, 'Useful date must be null');
  }

  @isTest
  static void testDateToStringDayMonth(){
    Date dateVariable = Date.valueOf('1996-01-27');
    String expected = '27/01';
    String actual = DateUtil.dateToStringDayMonth(dateVariable);
    System.assertEquals(expected, actual, 'Check useful date');
    expected = '';
    actual = DateUtil.dateToStringDayMonth(null);
    System.assertEquals(expected, actual, 'Useful date must be null');
  }

  @isTest
  static void testDatetimeToString(){
    Datetime dateVariable = Datetime.newInstance(1996, 1, 27, 12, 0, 0);
    String expected = '27/01/1996 12:00';
    String actual = DateUtil.datetimeToString(dateVariable);
    System.assertEquals(expected, actual, 'Check useful date');
    expected = '';
    actual = DateUtil.datetimeToString(null);
    System.assertEquals(expected, actual, 'Useful date must be null');
  }

  @isTest
  static void testGetShortMonthName(){
    String expected = 'JAN';
    String actual = DateUtil.getShortMonthName(1);
    System.assertEquals(expected, actual, 'Check month');
    expected = null;
    actual = DateUtil.getMonthName(13);
    System.assertEquals(expected, actual, 'Mont not exist');
  }

  @isTest
  static void testGetMonthName(){
    String expected = 'Janeiro';
    String actual = DateUtil.getMonthName(1);
    System.assertEquals(expected, actual, 'Check month');
    expected = null;
    actual = DateUtil.getMonthName(13);
    System.assertEquals(expected, actual, 'Mont not exist');
  }

  @isTest
  static void testUnformattedDatetime(){
    String expected = '19960127T000000';
    String actual = DateUtil.unformattedDatetime(Datetime.newInstance(1996, 1, 27, 0, 0, 0));
    System.assertEquals(expected, actual, 'Check useful date');
    expected = '';
    actual = DateUtil.unformattedDatetime(null);
    System.assertEquals(expected, actual, 'Useful date must be null');
  }
}