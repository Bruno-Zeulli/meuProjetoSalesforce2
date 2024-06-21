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

public with sharing class PersonalInformationUtilCPF {
    public static String isBlankOrNot(String str){
        if(String.isBlank(str)){
            return null;
        }
        return str;
    }

    public static Boolean isFormattedCPF(String cpf){
        isBlankOrNot(cpf);
        Pattern myPattern = Pattern.compile('^(\\d{3}\\.\\d{3}\\.\\d{3}\\-\\d{2})?$');
        Matcher myMatcher = myPattern.matcher(cpf);
        return myMatcher.matches();
    }

    public static Boolean isValidCPF(String cpf){
        isBlankOrNot(cpf);
        String cpfDesformatado = PersonalInformationUtil.unformatCPFCNPJ(cpf);
        if(cpfDesformatado.equals('00000000000') ||
            cpfDesformatado.equals('11111111111') ||
            cpfDesformatado.equals('22222222222') ||
            cpfDesformatado.equals('33333333333') ||
            cpfDesformatado.equals('44444444444') ||
            cpfDesformatado.equals('55555555555') ||
            cpfDesformatado.equals('66666666666') ||
            cpfDesformatado.equals('77777777777') ||
            cpfDesformatado.equals('88888888888') ||
            cpfDesformatado.equals('99999999999') ||
            (cpfDesformatado.length() != 11)
        ){
            return false;
        }

        Integer dig10, dig11, sm, i, r, num, peso;

        sm = 0;
        peso = 10;
        List<String> cpfString = cpfDesformatado.split('');
        for(i = 0; i < 9; i++){
            num = Integer.valueOf(cpfString[i]);
            sm = sm + (num * peso);
            peso = peso - 1;
        }

        r = 11 - (math.mod(sm, 11));
        dig10 = ((r == 10) || (r == 11)) ? 0 : r;

        // Calculo do 2o. Digito Verificador
        sm = 0;
        peso = 11;
        for(i = 0; i < 10; i++){
            num = Integer.valueOf(cpfString[i]);
            sm = sm + (num * peso);
            peso = peso - 1;
        }

        r = 11 - (Math.mod(sm, 11));
        dig11 = ((r == 10) || (r == 11)) ? 0 : r;

        // Verifica se os digitos calculados conferem com os digitos informados.
        if(dig10 == Integer.valueOf(cpfString[9]) && dig11 == Integer.valueOf(cpfString[10])){
            return true;
        }
        return false;
    }

    public static Boolean isFormattedValidCPF(String cpf){
        if(isFormattedCPF(cpf) && isValidCPF(cpf)){
            return true;
        }
        return false;
    }
}