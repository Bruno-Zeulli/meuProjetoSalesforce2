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

public with sharing class PersonalInformationUtilCNPJ {
    public static String isBlankOrNot(String str){
        if(String.isBlank(str)){
            return null;
        }
        return str;
    }

    public static Boolean isFormattedCNPJ(String cnpj){
        isBlankOrNot(cnpj);
        Pattern myPattern = Pattern.compile('^(\\d{2}\\.\\d{3}\\.\\d{3}/\\d{4}\\-\\d{2})?$');
        Matcher myMatcher = myPattern.matcher(cnpj);
        return myMatcher.matches();
    }

    public static Boolean isValidCNPJ(String cnpj){
        isBlankOrNot(cnpj);
        String cnpjDesformatado = PersonalInformationUtil.unformatCPFCNPJ(cnpj);
        // considera-se erro CNPJ's formados por uma sequencia de numeros iguais
        if(cnpjDesformatado.equals('00000000000000') ||
            cnpjDesformatado.equals('11111111111111') ||
            cnpjDesformatado.equals('22222222222222') ||
            cnpjDesformatado.equals('33333333333333') ||
            cnpjDesformatado.equals('44444444444444') ||
            cnpjDesformatado.equals('55555555555555') ||
            cnpjDesformatado.equals('66666666666666') ||
            cnpjDesformatado.equals('77777777777777') ||
            cnpjDesformatado.equals('88888888888888') ||
            cnpjDesformatado.equals('99999999999999') ||
            (cnpjDesformatado.length() != 14)
        ){
            return false;
        }

        Integer sm, i, r, num, peso, dig13, dig14;

        List<String> cnpjString = cnpjDesformatado.split('');
        sm = 0;
        peso = 2;
        for(i = 11; i >= 0; i--){
                num = Integer.valueOf(cnpjString[i]);
                sm = sm + (num * peso);
                peso = peso + 1;
                if(peso == 10){
                    peso = 2;
                }
        }

        r = Math.mod(sm, 11);
        dig13 = ((r == 0) || (r == 1)) ? 0 : Integer.valueOf(11 - r);

        // Calculo do 2o. Digito Verificador
        sm = 0;
        peso = 2;
        for(i = 12; i >= 0; i--){
            num = Integer.valueOf(cnpjString[i]);
            sm = sm + (num * peso);
            peso = peso + 1;
            if(peso == 10){
                peso = 2;
            }
        }

        r = math.mod(sm, 11);
        dig14 = ((r == 0) || (r == 1)) ? 0 : Integer.valueOf(11 - r);

        // Verifica se os dígitos calculados conferem com os dígitos informados.
        if(dig13 == Integer.valueOf(cnpjString[12]) && dig14 == Integer.valueOf(cnpjString[13])){
            return true;
        }
        return false;
    }

    public static Boolean isFormattedValidCNPJ(String cnpj){
        if(isFormattedCNPJ(cnpj) && isValidCNPJ(cnpj)){
            return true;
        }
        return false;
    }
}