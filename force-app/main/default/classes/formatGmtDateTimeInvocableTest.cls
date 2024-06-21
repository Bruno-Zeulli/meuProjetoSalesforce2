/**
 * @description       : Testa se a formatação da data está funcionando como esperado
 * @author            : joao@beecloud.com.br
 * @group             :
 * @last modified on  : 20-10-2023
 * @last modified by  : joao@beecloud.com.br
**/
@isTest
public class formatGmtDateTimeInvocableTest {
    
    @isTest
    public static void formatGmtDateTimeTest(){
        
        Test.startTest();
            List<String> formatedGMTDatetime = formatGmtDateTimeInvocable.formatGmtDateTime(new List<String>{'2023-10-20T15:26:59Z'});

            System.assertEquals('2023-10-20 12:26:59', formatedGMTDatetime[0], 'A data não está formatada corretamente.');
        Test.stopTest();
    }
}