/**
 * @description       : formatação da data está funcionando como esperado
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 20-10-2023
 * @last modified by  : joao@beecloud.com.br
**/
public with sharing class formatGmtDateTimeInvocable {
    @invocableMethod(label='Format Gmt DateTime' description='Recebe uma DateTime e retorna no formato GMT')
    public static List<String> formatGmtDateTime(List<String> dateTimeParam){
        List<String> dateTimeList = new List<String>();

        String dateTimeReplaced = dateTimeParam[0]?.replace('Z', '').replace('T', ' ');
        Datetime dateTimeConverted = Datetime.valueOfGmt(dateTimeReplaced);

        dateTimeList.add(String.valueOf(dateTimeConverted));

        return dateTimeList;
    }
}