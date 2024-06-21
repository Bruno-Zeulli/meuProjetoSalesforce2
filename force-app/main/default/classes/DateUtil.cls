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

global class DateUtil {
  global static Date stringToDate(string value){
     try{
      if(value.length() == 10){
        String[] dateVariable = value.split('/');
        return Date.newInstance(
          integer.valueOf(dateVariable[2]),
          integer.valueOf(dateVariable[1]),
          integer.valueOf(dateVariable[0])
        );
      }
      return null;
    } catch (Exception e){
      return null;
    }
  }

  global static String dateToString(Date value){
    if(value == null){
      return '';
    }

    Datetime dateVariable = Datetime.newInstance(value.year(), value.month(), value.day());
    return dateVariable.format('dd/MM/yyyy');
  }

  global static String dateToStringMonthYear(Date value){
    if(value == null){
      return '';
    }

    Datetime dateVariable = Datetime.newInstance(value.year(), value.month(), value.day());
    return dateVariable.format('MM/yyyy');
  }

  global static String dateToStringDayMonth(Date value){
    if(value == null){
      return '';
    }

    Datetime dateVariable = Datetime.newInstance(value.year(), value.month(), value.day());
    return dateVariable.format('dd/MM');
  }

  global static String datetimeToString(Datetime value){
    if(value == null){
      return '';
    }

    return value.format('dd/MM/yyyy HH:mm');
  }

  global static String getShortMonthName(Integer monthInt){
    Map<Integer, String> mapMonths = new Map<Integer, String>{
      1 => 'JAN',
      2 => 'FEV',
      3 => 'MAR',
      4 => 'ABR',
      5 => 'MAI',
      6 => 'JUN',
      7 => 'JUL',
      8 => 'AGO',
      9 => 'SET',
      10 => 'OUT',
      11 => 'NOV',
      12 => 'DEZ'
    };

    return mapMonths.get(monthInt);
  }

  global static String getMonthName(Integer monthInt){
    Map<Integer, String> mapMonths = new Map<Integer, String>{
      1 => 'Janeiro',
      2 => 'Fevereiro',
      3 => 'Março',
      4 => 'Abril',
      5 => 'Maio',
      6 => 'Junho',
      7 => 'Julho',
      8 => 'Agosto',
      9 => 'Setembro',
      10 => 'Outubro',
      11 => 'Novembro',
      12 => 'Dezembro'
    };

    return mapMonths.get(monthInt);
  }

  global static String unformattedDatetime(Datetime value){
    if(value == null){
      return '';
    }
    return value.format('yyyy/MM/dd HH:mm:ss').remove('/').remove(':').remove('-').replace(' ', 'T');
  }
}