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

public without sharing class StringUtil {

      /**
    * @description declaração de variaveis */
    private static final StringUtil INSTANCE = new StringUtil();

    /**
    * @description constroi a instancia da classe StringUtil
    * @return instancia da classe StringUtil
    */
    public static StringUtil getInstance(){
        return INSTANCE;
    }

    public String getValueInStringByParamSplit(String valueString, String paramSplitBefore, String paramSplitAfter, String paramRemoveString){

        List<String> lstSplitString;
        String splitString;

        if(valueString.Contains(paramSplitBefore)){
            splitString = valueString.Split(paramSplitBefore)[1];

            System.debug('splitString =>>' + splitString);

            if(paramSplitAfter != null){
                lstSplitString = splitString.Split(paramSplitAfter);

                System.debug('lstSplitString =>>' + lstSplitString);
            }
            if(paramRemoveString != null && !lstSplitString.isEmpty()){
                splitString = lstSplitString[0].remove(paramRemoveString);
                System.debug('paramRemoveString =>>' + splitString);
            }
            return splitString;
        }
        return splitString;
    }

    public static String convertToTwoDigits(Integer value){
        return convertToNDigits(2, value);
    }

    public static String convertToNDigits(Integer digits, Integer value){
        if(digits < 1 || digits == null || value == null){
            return null;
        }
        String stringValue = String.valueOf(value);
        if(stringValue.length() > digits){
            return null;
        }else if(stringValue.length() == digits){
            return stringValue;
        }
        String result = '';
        while (digits - (stringValue.length() - 1) > 1){
            result += '0';
            digits--;
        }
        result += value;
        return result;
    }

    public Integer getSizeListString(List<String> lString){
        return lString.size();
    }
}