/**
 * @description       :  Coporate contract Process
 * @author            : lucasmoro.mirante@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 03-04-2021
 * @last modified by  : lucasmoro.mirante@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                                Modification
 * 1.0   02-22-2021   lucasmoro.mirante@wizsolucoes.com.br  Initial Version
 * 1.1   03-02-2021   Lucas Moro                            PMD | Alterado parametro método
 * 1.2   05-19-2021   marcelomartins@wizsolucoes.com.br     Ajuste nas condições Porto Seguro
 */
@SuppressWarnings('PMD')
public class Corporate_ContractBO {

    static final Id RT_CORPORATE = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('CorporateApolice').getRecordTypeId();
    static final Id RT_CORPORATE_ENDOSSO_PREMIO = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('CorporateEndossoMovimentaoPremio').getRecordTypeId();
    static final Id RT_CORPORATE_ENDOSSO_NEUTRO = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('CorporateEndossoNeutro').getRecordTypeId();
    static final Id RT_CORPORATE_SUBCONTRATOBENEFICIOS = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('CorporateBeneficiosSubcontrato').getRecordTypeId();
    static final Id RT_CONTRACT_CORPORATE = Schema.SObjectType.Contract2__c.getRecordTypeInfosByDeveloperName().get('SeguroCorporate').getRecordTypeId();

    public static void processarContractNumber(Contract2__c contract){
        Set<Id> idcontractSet = new Set<Id>();
        List<String> apoliceListNumber;

        String apoliceNumber;
        String ultimos;
        String ramo;
        Integer index;
        String regexCharEsp = '(?:\\.|,|\\/|\\s|-)';

        if(contract.Company__c == 'Alfa Seguros'){
            System.debug('contract length Alfa Seguros ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() >= 7){
                apoliceNumber = contract.ContractNumber__c.Replace('/', '').Replace('-', '').Replace('.', '');
                contract.ContractNumber__c = apoliceNumber;
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
        * Preencher apenas os onze dígitos a direita. Iniciando pelo "10".
        **/
        if(contract.Company__c == 'AIG Seguros'){
            System.debug('contract length AIG Seguros ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() >= 21){
                apoliceNumber = contract.ContractNumber__c.Replace('/', '').Replace('-', '').Replace('.', '');
                apoliceNumber = apoliceNumber.substring(apoliceNumber.length() - 11);
                contract.ContractNumber__c = apoliceNumber;
            }else if(contract.ContractNumber__c.length() == 11){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
        *Se apólice SUSEP, preencher: “100” + 2 dígitos do Ramo + “0” + 7 últimos dígitos.
        **/
        if(contract.Company__c == 'American Life'){
            System.debug('contract length American Life ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() >= 24){
                ultimos = contract.ContractNumber__c.substring(contract.ContractNumber__c.Length() - 7);
                ramo = contract.ContractNumber__c.substring(contract.ContractNumber__c.length() - 9).substring(0, 2);
                apoliceNumber = '100' + ramo + '0' + ultimos;
                contract.ContractNumber__c = apoliceNumber;
            }else if(contract.ContractNumber__c.length() >= 14 && contract.ContractNumber__c.length() <= 23){
                apoliceNumber = contract.ContractNumber__c.Replace('X', '');
                contract.ContractNumber__c = apoliceNumber;
            }else if(contract.ContractNumber__c.length() == 13){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Preencher conforme apólice mas apenas os números sem pontos e/ou traços.
         */
        if(contract.Company__c == 'Argo Seguros'){
            System.debug('contract length Argo Seguros ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() >= 25){
                apoliceNumber = contract.ContractNumber__c.Replace('/', '').Replace('.', '').Replace('-', '');
                contract.ContractNumber__c = apoliceNumber;
            }else if(contract.ContractNumber__c.length() < 24 && contract.ContractNumber__c.length() >= 19){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Preencher apenas os doze dígitos da direita pra esquerda.
         */
        if(contract.Company__c == 'Austral Seguros'){
            System.debug('contract length Austral Seguros ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() >= 24){
                apoliceNumber = contract.ContractNumber__c.Replace('/', '').Replace('.', '').Replace('-', '');
                apoliceNumber = apoliceNumber.substring(apoliceNumber.length() - 12);
                contract.ContractNumber__c = apoliceNumber;
            }else if(contract.ContractNumber__c.length() == 12){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Preencher conforme apólice mas apenas os números sem pontos e/ou traços.
         */
        if(contract.Company__c == 'Azul Seguros'){
            System.debug('contract length Azul Seguros ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() >= 18){
                apoliceNumber = contract.ContractNumber__c.Replace('/', '').Replace('.', '').Replace('-', '');
                contract.ContractNumber__c = apoliceNumber;
            }else if(contract.ContractNumber__c.length() == 17){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Considerar os dígitos após o último ponto e desconsiderar os “0”.
         */
        if(contract.Company__c == 'Axa Seguros'){
            System.debug('contract length Axa Seguros ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() >= 24 && contract.ContractNumber__c.Contains('.')){
                apoliceListNumber = contract.ContractNumber__c.split('\\.');
                index = apoliceListNumber.size() - 1;

                if(apoliceListNumber.size() > 1){
                    apoliceNumber = apoliceListNumber[index];
                    contract.ContractNumber__c = leftZeroesTrim(apoliceNumber);
                    return;
                }
            }else if(contract.ContractNumber__c.length() >= 2 && contract.ContractNumber__c.length() <= 5){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Preencher com “100” + 2 dígitos do Ramo + “0” + 7 últimos dígitos da apólice.
         */
        if(contract.Company__c == 'Berkley Seguros'){
            System.debug('contract length Berkley Seguros ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() >= 24){
                ultimos = contract.ContractNumber__c.substring(contract.ContractNumber__c.length() - 7);
                ramo = contract.ContractNumber__c.Replace('/', '')
                .Replace('.', '')
                .Replace('-', '')
                .substring(contract.ContractNumber__c.length() - 9)
                .substring(0, 2);
                apoliceNumber = '100' + ramo + '0' + ultimos;
                contract.ContractNumber__c = apoliceNumber;
            }else if(contract.ContractNumber__c.length() == 13){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Cadastrar a partir dos números “107”.
         */
        if(contract.Company__c == 'BMG Seguros'){
            System.debug('contract length BMG Seguros ' + contract.ContractNumber__c.length());

          /*  if(contract.ContractNumber__c.length() >= 24){
                apoliceNumber = contract.ContractNumber__c.Replace('/', '').Replace('.', '').Replace('-', '');
                apoliceNumber = apoliceNumber.substring(apoliceNumber.length() - 13);

                if(apoliceNumber.startsWith('1007')){
                    System.debug('Case 1007' + apoliceNumber);

                    contract.ContractNumber__c = apoliceNumber;
                }else if(apoliceNumber.substring(1).startsWith('107')){
                    apoliceNumber = apoliceNumber.substring(1);

                    System.debug('Case 107' + apoliceNumber);
                    contract.ContractNumber__c = apoliceNumber;
                }

                contract.ContractNumber__c = apoliceNumber;
            }else if(contract.ContractNumber__c.length() == 12 || contract.ContractNumber__c.length() == 13){
                // valor formatado 
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            } */

            if(contract.ContractNumber__c.length() >= 23){
                ultimos = contract.ContractNumber__c.substring(contract.ContractNumber__c.Length() - 7);
                ramo = contract.ContractNumber__c.substring(contract.ContractNumber__c.length() - 9).substring(0, 2);
                apoliceNumber = '100' + ramo + '0' + ultimos;
                contract.ContractNumber__c = apoliceNumber;
            }else if(contract.ContractNumber__c.length() == 13){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Ignorar os 3 primeiros dígitos do Ramo, considerar os demais sem pontos ou traços.
         */
        if(contract.Company__c == 'Bradesco Seguros'){
            System.debug('contract length Bradesco Seguros ' + contract.ContractNumber__c.length());
            if(contract.ContractNumber__c.Contains('.')){
                apoliceNumber = contract.ContractNumber__c.substring(contract.ContractNumber__c.length() - 6);
                contract.ContractNumber__c = leftZeroesTrim(apoliceNumber);
            }else if(contract.ContractNumber__c.length() > 5 && !contract.ContractNumber__c.Contains('.')){
                apoliceNumber = contract.ContractNumber__c.substring(3, contract.ContractNumber__c.length());
                contract.ContractNumber__c = apoliceNumber;
            }else if(contract.ContractNumber__c.length() >= 3 && contract.ContractNumber__c.length() <= 6){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Ramos Elementares considerar os 12 dígitos a direita iniciando pelo “10”.
         */
        if(contract.Company__c == 'Capemisa'){
            System.debug('contract length Capemisa ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() >= 24){
                apoliceNumber = contract.ContractNumber__c.substring(contract.ContractNumber__c.length() - 12);
                contract.ContractNumber__c = apoliceNumber;
            }else if(contract.ContractNumber__c.length() >= 12 && contract.ContractNumber__c.length() <= 15){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Se apólice SUSEP, preencher: “100” + 2 dígitos do Ramo + “0” + 7 últimos dígitos.
         */
        if(contract.Company__c == 'Cescebrasil'){
            System.debug('contract length Cescebrasil ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() >= 23){
                ultimos = contract.ContractNumber__c.substring(contract.ContractNumber__c.Length() - 7);
                ramo = contract.ContractNumber__c.substring(contract.ContractNumber__c.length() - 9).substring(0, 2);
                apoliceNumber = '100' + ramo + '0' + ultimos;
                contract.ContractNumber__c = apoliceNumber;
            }else if(contract.ContractNumber__c.length() == 13){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Preencher conforme apólice, sem pontos, barras ou traços.
         */
        if(contract.Company__c == 'Chubb Seguros'){
            System.debug('contract length Chubb Seguros ' + contract.ContractNumber__c.length());
            apoliceNumber = contract.ContractNumber__c.Replace('/', '').Replace('.', '').Replace('-', '');
            contract.ContractNumber__c = apoliceNumber;

            if(contract.ContractNumber__c.length() >= 13){
                apoliceNumber = contract.ContractNumber__c.substring(0, contract.ContractNumber__c.length() -2);
                contract.ContractNumber__c = apoliceNumber;
            }else if(contract.ContractNumber__c.length() == 11){
                /** valor formatado */
            }else if(contract.ContractNumber__c.length() == 10){
                contract.ContractNumber__c = apoliceNumber;
            }else if(contract.ContractNumber__c.length() == 8){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Preencher conforme vem na apólice, desconsiderar os “0” a esquerda.
         */
        if(contract.Company__c == 'Excelsior Seguros'){
            System.debug('contract length Excelsior Seguros ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() > 10){
                if(contract.ContractNumber__c.length() > 13 && contract.ContractNumber__c.length() <= 30){
                    apoliceNumber = contract.ContractNumber__c.substring(12, contract.ContractNumber__c.length() - 7);
                    contract.ContractNumber__c = apoliceNumber;

                }else{
                    apoliceNumber = leftZeroesTrim(contract.ContractNumber__c.Replace('/', '').Replace('.', '').Replace('-', ''));
                    contract.ContractNumber__c = apoliceNumber;
                }

            }else if(contract.ContractNumber__c.length() == 12){
                /** valor formatado */
            }else if(contract.ContractNumber__c.length() >= 2 && contract.ContractNumber__c.length() <= 10){
                /** valor formatado */
                apoliceNumber = leftZeroesTrim(contract.ContractNumber__c.Replace('/', '').Replace('.', '').Replace('-', ''));
                contract.ContractNumber__c = apoliceNumber;
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Preencher conforme apólice de 13 dígitos.
         * Se apólice SUSEP, preencher “1007507” + os 6 dígitos da direita pra esquerda.
         */
        if(contract.Company__c == 'Ezze Seguros'){
            System.debug('contract length Ezze Seguros ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() >= 23){
                ultimos = contract.ContractNumber__c.substring(contract.ContractNumber__c.length() - 6);
                apoliceNumber = '1007507' + ultimos;
                contract.ContractNumber__c = apoliceNumber;
            }else if(contract.ContractNumber__c.length() == 12 || contract.ContractNumber__c.length() == 13){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Se apólice SUSEP, preencher apenas os 12 dígitos da direita pra esquerda.
         */
        if(contract.Company__c == 'Fairfax'){
            System.debug('contract length Fairfax ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() > 13){
                apoliceNumber = contract.ContractNumber__c.substring(contract.ContractNumber__c.length() - 12);
                contract.ContractNumber__c = apoliceNumber;
            }else if(contract.ContractNumber__c.length() == 13 || contract.ContractNumber__c.length() == 12){
                /** valor formatado */
                contract.ContractNumber__c = contract.ContractNumber__c;
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Se apólice SUSEP, preencher apenas os 12 dígitos da direita pra esquerda.
         */
        if(contract.Company__c == 'Fator'){
            System.debug('contract length Fator ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() >= 23){
                apoliceNumber = contract.ContractNumber__c.substring(contract.ContractNumber__c.length() - 12);
                contract.ContractNumber__c = apoliceNumber;
            }else if(contract.ContractNumber__c.length() == 12 || contract.ContractNumber__c.length() == 13){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Cadastrar conforme apólice retirando pontos, traços e barras.
         */
        if(contract.Company__c == 'Generali Seguros'){
            System.debug('contract length Generali Seguros ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() >= 11){
                apoliceNumber = contract.ContractNumber__c.Replace('/', '').Replace('.', '').Replace('-', '');
                contract.ContractNumber__c = apoliceNumber;
            }else if(contract.ContractNumber__c.length() > 2){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Preencher os números entre o terceiro e quarto ponto.
         * Caso haja, desconsiderar os “0” a esquerda.
         */
        if(contract.Company__c == 'HDI Seguros'){
            System.debug('contract length 	HDI Seguros ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() >= 22 && contract.ContractNumber__c.Contains('.')){
                apoliceListNumber = contract.ContractNumber__c.split('\\.');

                if(apoliceListNumber.size() > 3){
                    apoliceNumber = leftZeroesTrim(contract.ContractNumber__c.Split('\\.')[3]);
                    contract.ContractNumber__c = apoliceNumber.Replace('/', '').Replace('.', '').Replace('-', '');
                    return;
                }
            }else if(contract.ContractNumber__c.length() >= 4 && contract.ContractNumber__c.length() <= 6){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Preencher conforme apólice. Caso haja, ignorar ponto e dígitos da filial a esquerda.
         */
        if(contract.Company__c == 'Kovr Seguradora S/A'){
            System.debug('contract length ' + contract.ContractNumber__c.length());
            if(contract.ContractNumber__c.length() > 13 && contract.ContractNumber__c.length() < 20 && contract.ContractNumber__c.Contains('.')){
                apoliceNumber = contract.ContractNumber__c.split('\\.')[1];
                contract.ContractNumber__c = apoliceNumber;
                }else if(contract.ContractNumber__c.length() > 20 && !contract.ContractNumber__c.Contains('.')){
                    System.debug('contract length Segundo IF' + contract.ContractNumber__c.length());
                    ultimos = contract.ContractNumber__c.substring(contract.ContractNumber__c.length() - 6);
                    ramo = contract.ContractNumber__c.substring(contract.ContractNumber__c.length() - 9).substring(0, 2);
                    apoliceNumber = '100' + ramo + '07' + ultimos;
                    contract.ContractNumber__c = apoliceNumber;

            }else if(contract.ContractNumber__c.length() >= 10 && contract.ContractNumber__c.length() <= 13){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Considerar os números entre o último e penúltimo ponto.
         */
        if(contract.Company__c == 'Itau Seguros'){
            System.debug('contract length Itau Seguros ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() >= 11 && contract.ContractNumber__c.Contains('.')){
                apoliceListNumber = contract.ContractNumber__c.split('\\.');

                if(apoliceListNumber.size() > 2){
                    apoliceNumber = contract.ContractNumber__c.split('\\.')[2];
                    contract.ContractNumber__c = apoliceNumber;
                }
            }else if(contract.ContractNumber__c.length() > 2 && contract.ContractNumber__c.length() < 11){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Retirar os pontos e preencher o número completo.
         */
        if(contract.Company__c == 'Liberty Seguros'){
            System.debug('contract length Generali Seguros ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() >= 8){
                apoliceNumber = contract.ContractNumber__c.Replace('/', '').Replace('.', '').Replace('-', '');
                contract.ContractNumber__c = apoliceNumber;
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Caso haja, ignorar pontos, traços e barras.
         */
        if(contract.Company__c == 'Mapfre Vida'){
            System.debug('contract length Mapfre Vida ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() >= 5){
                apoliceNumber = contract.ContractNumber__c.Replace('-', '').Replace('.', '').Replace('/', '');
                contract.ContractNumber__c = apoliceNumber;
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Considerar os 5 primeiros números da esquerda para direita.
         */
        if(contract.Company__c == 'MetLife'){
            System.debug('contract length MetLife ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() >= 8){
                apoliceNumber = contract.ContractNumber__c.Replace('/', '').Replace('.', '').Replace('-', '');
                apoliceNumber = apoliceNumber.substring(apoliceNumber.length() - 8).substring(0, 5);
                contract.ContractNumber__c = apoliceNumber;
            }else if(contract.ContractNumber__c.length() == 5){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Desconsiderar os zeros a esquerda e preencher o restante do número.
         */
        if(contract.Company__c == 'Mitsui Sumitomo Seguros'){
            System.debug('contract length Mitsui Sumitomo Seguros ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() >= 11){
                apoliceNumber = leftZeroesTrim(contract.ContractNumber__c);
                contract.ContractNumber__c = apoliceNumber;
            }else if(contract.ContractNumber__c.length() == 10){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        if(contract.Company__c == 'MAG Seguros'){
            System.debug('contract length MAG Seguros ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() == 10){
                /** valor formatado */
            }else if(contract.ContractNumber__c.length() == 5){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Preencher o número entre a segunda e a terceira barra.
         * Caso haja, desconsiderar os zeros a esquerda.
         */
        if(contract.Company__c == 'Nobre'){
            System.debug('contract length Nobre ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() >= 18 && contract.ContractNumber__c.Contains('/')){
                apoliceListNumber = contract.ContractNumber__c.Split('\\/');

                if(apoliceListNumber.size() > 2){
                    apoliceNumber = leftZeroesTrim(contract.ContractNumber__c.Split('\\/')[2]);
                    contract.ContractNumber__c = apoliceNumber;
                }
            }else if(contract.ContractNumber__c.length() == 2){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Desconsiderar zeros a esquerda, pontos e traços.
         */
        if(contract.Company__c == 'Porto Seguro'){
            System.debug('contract length Porto Seguro ' + contract.ContractNumber__c.length());

            apoliceListNumber = contract.ContractNumber__c.Split(regexCharEsp);
            index = apoliceListNumber.size() - 1;

            if(contract.ContractNumber__c.length() <= 10){
                apoliceNumber = apNumberFormat(0, index, apoliceListNumber);
            }else if(apoliceListNumber.size() <= 2){
                apoliceNumber = apoliceListNumber[index];
            }else if(apoliceListNumber.size() > 2){
                apoliceNumber = apNumberFormat(2, index, apoliceListNumber);
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
            contract.ContractNumber__c = apoliceNumber;
        }
        if(contract.Company__c == 'Pottencial Seguradora'){
            System.debug('contract length Pottencial Seguradora ' + contract.ContractNumber__c.length());

            contract.ContractNumber__c = contract.ContractNumber__c.replaceAll('\\D', '');
            if(contract.ContractNumber__c.length() == 25){
                apoliceNumber = contract.ContractNumber__c.substring(15 , contract.ContractNumber__c.length() -3);
                contract.ContractNumber__c = apoliceNumber;
            }else if(contract.ContractNumber__c.length() == 15){
                apoliceNumber = contract.ContractNumber__c.substring(8, contract.ContractNumber__c.length());
                contract.ContractNumber__c = apoliceNumber;

            }else if(contract.ContractNumber__c.length() == 7){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Utilizar os 7 últimos dígitos desconsiderado zeros a esquerda.
         * Se apólice menor que 7 dígitos, preencher conforme apólice.
         */
        if(contract.Company__c == 'SulAmérica'){
            System.debug('contract length SulAmérica ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() >= 7){
                apoliceNumber = contract.ContractNumber__c.substring(contract.ContractNumber__c.length() - 7);
                contract.ContractNumber__c = leftZeroesTrim(apoliceNumber);
            }else if(contract.ContractNumber__c.length() > 2){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        if(contract.Company__c == 'Sura Seguros'){
            System.debug('contract length Sura Seguros ' + contract.ContractNumber__c.length());
            if(contract.ContractNumber__c.length() >= 15 && contract.ContractNumber__c.length() <= 24){
                System.debug('DENTRO DO IF');
                ultimos = contract.ContractNumber__c.substring(contract.ContractNumber__c.length() - 6);
                ramo = contract.ContractNumber__c.substring(contract.ContractNumber__c.length() - 9).substring(0, 2);
                apoliceNumber = ramo + '07' + ultimos;
                contract.ContractNumber__c = apoliceNumber;
                System.debug('apolicenumber:' + apoliceNumber);
                System.debug('contract.contract:' + contract.ContractNumber__c);

            }else if(contract.ContractNumber__c.length() > 0){
                /** valor formatado */
            }else{
                System.debug('Err apolicenumber:' + apoliceNumber);
                System.debug('Err contract.contract:' + contract.ContractNumber__c);
                contract.addError(
                'apolice:'+ apoliceNumber + 'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra' + 'contract' +contract.ContractNumber__c
                );
            }
        }
        /**
         * Para Garantia preencher usando os seis últimos dígitos incluindo os zeros.
         */
        if(contract.Company__c == 'Tokio Marine'){
            System.debug('contract length Tokio Marine ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() >= 16){
                apoliceNumber = contract.ContractNumber__c.substring(contract.ContractNumber__c.length() - 6);
                contract.ContractNumber__c = apoliceNumber;
                return;
            }else if(contract.ContractNumber__c.length() >= 10 && contract.ContractNumber__c.length() <= 15){
                apoliceNumber = contract.ContractNumber__c.substring(contract.ContractNumber__c.length() - 10);
                contract.ContractNumber__c = leftZeroesTrim(apoliceNumber);
            }else if(contract.ContractNumber__c.length() >= 2 && contract.ContractNumber__c.length() <= 8){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Para apólices BTG, considerar somente os 12 dígitos a direita iniciando pelo "10".
         */
        if(contract.Company__c == 'Btg Pactual'){
            System.debug('contract length Too Seguros ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() == 24){
                apoliceNumber = contract.ContractNumber__c.substring(contract.ContractNumber__c.length() - 12);

                contract.ContractNumber__c = apoliceNumber;
            }else if(contract.ContractNumber__c.length() == 12){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Preencher conforme vem na apólice e desconsiderar “0” à esquerda. Caso haja, ignorar pontos, traços e barras.
         */
        if(contract.Company__c == 'XI Seguros'){
            System.debug('contract length XI Seguros ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() >= 11){
                apoliceNumber = contract.ContractNumber__c.Replace('-', '').Replace('.', '').Replace('/', '');
                contract.ContractNumber__c = leftZeroesTrim(apoliceNumber);
            }else if(contract.ContractNumber__c.length() == 10){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Se contiver pontos, desconsiderar os zeros a esquerda dos 7 números finais.
         */
        if(contract.Company__c == 'Zurich'){
            System.debug('contract length Zurich ' + contract.ContractNumber__c.length());

            if(contract.ContractNumber__c.length() > 7){
                apoliceNumber = contract.ContractNumber__c.Replace('-', '').Replace('.', '').Replace('/', '');
                apoliceNumber = apoliceNumber.substring(apoliceNumber.length() - 7);
                contract.ContractNumber__c = leftZeroesTrim(apoliceNumber);
            }else if(contract.ContractNumber__c.length() > 1 && contract.ContractNumber__c.length() <= 7){
                /** valor formatado */
            }else{
                contract.addError(
                'Quantidade de números incorreta para ' +
                contract.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
    }
    /**
     * Função para retirar zeros a esquerda da String
     */
    public static String leftZeroesTrim(String str){
        Integer indexFunc = str.indexOfAnyBut('0');
        if(indexFunc == -1 || indexFunc == null){
            return str;
        }else{
            return str.substring(indexFunc);
        }
    }

    private static string apNumberFormat(Integer indexInitial, Integer index, List<String> apoliceListNumber){
        String apoliceNumber;

        for(Integer i = indexInitial; i <= index; i++){
            if(apoliceNumber == null){
                apoliceNumber = apoliceListNumber[i];
            }else{
                apoliceNumber = apoliceNumber + apoliceListNumber[i];
            }
        }
        return apoliceNumber;
    }

    public static void insertContratosCorporate(List<Order> orders){

        List<Contract2__c> lstContract = new List<Contract2__c>();
        Set<Id> orderIdSet = new Set<Id>();

        for(Order iOrders : orders){
            orderIdSet.add(iOrders.Id);
        }
        Map<Id, Opportunity> iOppMap = new Map<Id, Opportunity>();
        Map<Id, Decimal> totalAmountMap = new Map<Id, Decimal>();
        Map<Id, OpportunityLineItem> iOppliMap = new Map<Id, OpportunityLineItem>();
        List<Opportunity> oppLst = [SELECT Id, Subestipulante__c, InsuredAmount__c, (SELECT Id FROM Orders), (SELECT Id, ProductCode, Product2.Name FROM OpportunityLineItems) FROM Opportunity WHERE Id IN (SELECT OpportunityId FROM Order WHERE Id IN : orderIdSet)];

        for(Opportunity iOpp : oppLst){
            for(Order iOrder : iOpp.Orders){
                iOppMap.put(iOrder.Id, iOpp);
            }
            for(OpportunityLineItem iOppli : iOpp.OpportunityLineItems){
                iOppliMap.put(iOpp.Id, iOppli);
            }
        }

        for(Order order : orders){
            if(order.RecordTypeId == RT_CORPORATE && order.PoNumber != null && order.Contract2__c == null){
                Contract2__c preContrato = new Contract2__c();
                preContrato.Name = order.Company__c + ' | ' + order.OriginalPONumber__c;
                preContrato.Company__c = order.Company__c;
                preContrato.Account__c = order.AccountId;
                preContrato.BidNumber__c = order.OriginalPONumber__c;
                preContrato.ContractNumber__c = order.OriginalPONumber__c;
                preContrato.Status__c = 'Pendente';
                preContrato.StartDate__c = order.EffectiveDate;
                preContrato.EndDate__c = order.EndDate;
                preContrato.ProductFamily__c = 'Seguro';
                preContrato.RecordTypeId = RT_CONTRACT_CORPORATE;
                preContrato.OwnerId = order.OwnerId;
                preContrato.Subestipulante__c = iOppMap.get(order.Id)?.Subestipulante__c;
                preContrato.InsuredAmount__c = iOppMap.get(order.Id)?.InsuredAmount__c;
                preContrato.ProductCode__c = iOppliMap.get(iOppMap.get(order.Id)?.Id)?.ProductCode;
                preContrato.ProductName__c = iOppliMap.get(iOppMap.get(order.Id)?.Id)?.Product2.Name;

                lstContract.add(preContrato);
            }
            else if((order.RecordTypeId == RT_CORPORATE_ENDOSSO_PREMIO ||
                        order.RecordTypeId == RT_CORPORATE_ENDOSSO_NEUTRO ||
                        order.RecordTypeId == RT_CORPORATE_SUBCONTRATOBENEFICIOS) &&
                        order.PoNumber != null && order.Contract2__c == null &&
                        order.EndorsementNumber__c != null)
            {
                system.debug('@BPS entrou  no else');
                Contract2__c preContrato = new Contract2__c();
                preContrato.Name = order.Company__c + ' | ' + order.OriginalPONumber__c + ' | ' + order.EndorsementNumber__c;
                preContrato.Company__c = order.Company__c;
                preContrato.Account__c = order.AccountId;
                preContrato.BidNumber__c = order.OriginalPONumber__c;
                preContrato.ContractNumber__c = order.OriginalPONumber__c;
                preContrato.Status__c = 'Pendente';
                preContrato.StartDate__c = order.EffectiveDate;
                preContrato.EndDate__c = order.EndDate;
                preContrato.RecordTypeId = RT_CONTRACT_CORPORATE;
                preContrato.ProductFamily__c = 'Seguro';
                preContrato.OwnerId = order.OwnerId;
                preContrato.EndorsementNumber__c = order.EndorsementNumber__c;
                preContrato.Subestipulante__c = iOppMap.get(order.Id)?.Subestipulante__c;
                preContrato.InsuredAmount__c = iOppMap.get(order.Id)?.InsuredAmount__c;
                preContrato.ProductCode__c = iOppliMap.get(iOppMap.get(order.Id)?.Id)?.ProductCode;
                preContrato.ProductName__c = iOppliMap.get(iOppMap.get(order.Id)?.Id)?.Product2.Name;

                lstContract.add(preContrato);
            }
        }
        if(lstContract.size() > 0 && Schema.sObjectType.Contract2__c.isCreateable()){
            insert lstContract;
            System.debug('precontrato ' + lstContract[0].Id);
        }
    }

	public static void updateContratosCorporate(Map<Id,Order> ordersByContractId){

        List<String> contractIds = new List<String>();
        for(String ctrId : ordersByContractId.keySet()){
            contractIds.add(ctrId);
        }
        String inClause = String.format('(\'\'{0}\'\')',
                            new List<String> { String.join(new List<String>(contractIds) , '\',\'') }
                        );


        String whereCondition = 'WHERE Id IN ' + inClause;
        System.debug('query => ' +whereCondition);

        List<Contract2__c> lstContract = new List<Contract2__c>(Contract2DAO.getInstance().getAllFields(whereCondition));
        List<Contract2__c> updateContracts = new List<Contract2__c>();

        for(Contract2__c ctr : lstContract){
            Order order = ordersByContractId.get(ctr.Id);

            if(order.RecordTypeId == RT_CORPORATE && order.EndorsementNumber__c == null){
                Contract2__c contract2 = ctr.clone(true,false,true,true);
                contract2.BidNumber__c = order.OriginalPONumber__c;
                contract2.ContractNumber__c = order.OriginalPONumber__c;
                contract2.Name = order.Company__c + ' | ' + order.OriginalPONumber__c;
                updateContracts.add(contract2);
            }
            else if((order.RecordTypeId == RT_CORPORATE_ENDOSSO_PREMIO ||
                        order.RecordTypeId == RT_CORPORATE_ENDOSSO_NEUTRO ||
                        order.RecordTypeId == RT_CORPORATE_SUBCONTRATOBENEFICIOS) &&
                        order.EndorsementNumber__c != null)
            {
                Contract2__c contract2 = ctr.clone(true,false,true,true);
                contract2.BidNumber__c = order.OriginalPONumber__c;
                contract2.ContractNumber__c = order.OriginalPONumber__c;
                contract2.Name = order.Company__c + ' | ' + order.OriginalPONumber__c + ' | ' + order.EndorsementNumber__c;
                updateContracts.add(contract2);
            }
        }
        if(updateContracts.size() > 0 && Schema.sObjectType.Contract2__c.isCreateable()){
            Database.SaveResult [] updateResult = Database.update(updateContracts, false);
        }
	}
}