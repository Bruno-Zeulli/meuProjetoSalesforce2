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

global class PersonalInformationUtil {
    global static String formatCPFCNPJ(String cpfCnpj){
        if(String.isBlank(cpfCnpj)){
            return null;
        }
        if(cpfCnpj.length() == 11){
            String cpf =
            cpfCnpj.substring(0, 3) +
            '.' +
            cpfCnpj.substring(3, 6) +
            '.' +
            cpfCnpj.substring(6, 9) +
            '-' +
            cpfCnpj.substring(9, 11);
            return cpf;
        }else if(cpfCnpj.length() == 14){
            String cnpj =
            cpfCnpj.substring(0, 2) +
            '.' +
            cpfCnpj.substring(2, 5) +
            '.' +
            cpfCnpj.substring(5, 8) +
            '/' +
            cpfCnpj.substring(8, 12) +
            '-' +
            cpfCnpj.substring(12, 14);
            return cnpj;
        }else{
            return null;
        }
    }

    global static String unformatCPFCNPJ(String cpfCnpj){
        if(String.isBlank(cpfCnpj)){
            return null;
        }
        return cpfCnpj.remove('.').remove('/').remove('-');
    }

    global static Boolean isFormattedCPF(String cpf){
        if(String.isBlank(cpf)){
            return false;
        }
        Pattern myPattern = Pattern.compile('^(\\d{3}\\.\\d{3}\\.\\d{3}\\-\\d{2})?$');
        Matcher myMatcher = myPattern.matcher(cpf);
        return myMatcher.matches();
    }

    global static Boolean isValidCPF(String cpf){
        if(String.isBlank(cpf)){
            return false;
        }
        String cpfDesformatado = unformatCPFCNPJ(cpf);
        if(
        cpfDesformatado.equals('00000000000') ||
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

    global static Boolean isFormattedValidCPF(String cpf){
        if(isFormattedCPF(cpf) && isValidCPF(cpf)){
            return true;
        }
        return false;
    }

    global static Boolean isFormattedCNPJ(String cnpj){
        if(String.isBlank(cnpj)){
            return false;
        }
        Pattern myPattern = Pattern.compile('^(\\d{2}\\.\\d{3}\\.\\d{3}/\\d{4}\\-\\d{2})?$');
        Matcher myMatcher = myPattern.matcher(cnpj);
        return myMatcher.matches();
    }

    global static Boolean isValidCNPJ(String cnpj){
        if(String.isBlank(cnpj)){
            return false;
        }
        String cnpjDesformatado = unformatCPFCNPJ(cnpj);
        // considera-se erro CNPJ's formados por uma sequencia de numeros iguais
        if(
        cnpjDesformatado.equals('00000000000000') ||
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

    global static Boolean isFormattedValidCNPJ(String cnpj){
        if(isFormattedCNPJ(cnpj) && isValidCNPJ(cnpj)){
            return true;
        }
        return false;
    }

    global static Boolean isFormattedCPFCNPJ(String cpfCnpj){
        if(isFormattedCPF(cpfCnpj) || isFormattedCNPJ(cpfCnpj)){
            return true;
        }
        return false;
    }

    global static Boolean isValidCPFCNPJ(String cpfCnpj){
        if(isValidCPF(cpfCnpj) || isValidCNPJ(cpfCnpj)){
            return true;
        }
        return false;
    }

    global static Boolean isFormattedValidCPFCNPJ(String cpfCnpj){
        if(isFormattedValidCPF(cpfCnpj) || isFormattedValidCNPJ(cpfCnpj)){
            return true;
        }
        return false;
    }

    global static Boolean isFormattedPhone(String telefone){
        if(String.isBlank(telefone)){
            return false;
        }
        Pattern myPattern = Pattern.compile('^((\\+\\d{2}\\s)?\\(\\d{2}\\)\\s?\\d{4}\\d?\\-\\d{4})?$');
        Matcher myMatcher = myPattern.matcher(telefone);
        return myMatcher.matches();
    }

    global static String unformatPhone(String telefone){
        if(String.isBlank(telefone)){
            return null;
        }
        return telefone.remove('(').remove(')').remove('-').remove(' ').remove('_').remove('+');
    }

    global static Boolean isValidEmail(String email){
        if(String.isBlank(email)){
            return true;
        }
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
        Pattern emailPattern = Pattern.compile(emailRegex);
        Matcher emailMatcher = emailPattern.matcher(email);
        return emailMatcher.matches();
    }

    global static String generateRandomCNPJ(){
        String cnpj;
        do {
            Decimal cnpjNumero = Math.random() * 1000000000000L;
            cnpjNumero = cnpjNumero.round();
            cnpj = String.valueOf(cnpjNumero);
        } while (cnpj.length() != 12);
        Integer sm, i, r, num, peso, dig13, dig14;
        List<String> cnpjString = cnpj.split('');
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
        r = math.mod(sm, 11);
        dig13 = ((r == 0) || (r == 1)) ? 0 : Integer.valueOf(11 - r);
        cnpj += dig13;
        cnpjString = cnpj.split('');
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
        cnpj += dig14;
        return cnpj;
    }

    global static String generateRandomCPF(){
        String cpf;
        do {
            Decimal cpfNumero = Math.random() * 1000000000L;
            cpfNumero = cpfNumero.round();
            cpf = String.valueOf(cpfNumero);
        } while (cpf.length() != 9);
        Integer dig10, dig11, sm, i, r, num, peso;

        sm = 0;
        peso = 10;
        List<String> cpfString = cpf.split('');
        for(i = 0; i < 9; i++){
            num = Integer.valueOf(cpfString[i]);
            sm = sm + (num * peso);
            peso = peso - 1;
        }

        r = 11 - (math.mod(sm, 11));
        dig10 = ((r == 10) || (r == 11)) ? 0 : r;
        cpf += dig10;
        // Calculo do 2o. Digito Verificador
        sm = 0;
        peso = 11;
        cpfString = cpf.split('');
        for(i = 0; i < 10; i++){
            num = Integer.valueOf(cpfString[i]);
            sm = sm + (num * peso);
            peso = peso - 1;
        }

        r = 11 - (Math.mod(sm, 11));
        dig11 = ((r == 10) || (r == 11)) ? 0 : r;
        cpf += dig11;
        return cpf;
    }

    global static String generateRandomFormattedCPF(){
        return formatCPFCNPJ(generateRandomCPF());
    }

    global static String generateRandomFormattedCNPJ(){
        return formatCPFCNPJ(generateRandomCNPJ());
    }
}