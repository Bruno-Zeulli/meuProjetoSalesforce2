/**
 * @description       : Corporate Order Process
 * @author            : lucasmoro.mirante@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 21-06-2023
 * @last modified by  : pedrotofani@wiz.co
 * Modifications Log
 * Ver   Date         Author                               	Modification
 * 1.0   22-02-2021   lucasmoro.mirante@wizsolucoes.com.br  Initial Version
 * 1.1   03-02-2021   windsonsantos@wizsolucoes.com.br      PMD | Alterado parametro método
 * 1.2   05-19-2021   marcelomartins@wizsolucoes.com.br     Ajuste nas condições Porto Seguro
 * 1.3   05-21-2021   ericdaniel@wizsolucoes.com.br		    Ajustadas condições para BMG Seguros
 * 1.4   11-07-2022   samuelsirkis@wizsolucoes.com.br	    Ajustes no reference id e voltando potencial seguradora verify PONumber
 * 1.5   21-06-2023   pedrotofani@wiz.com							Adicao de um metodo de verificacao se os pedidos estao no book de apolices
 */
@SuppressWarnings('PMD')
public class Corporate_OrderBO {

    public static boolean verifyOrderInBook(Order order)
    {
        boolean retorno = false; 
        
        if (order.Company__c == 'Alfa Seguros' || order.Company__c == 'AIG Seguros' || order.Company__c == 'American Life' || order.Company__c == 'Argo Seguros' || order.Company__c == 'Austral Seguros'
            || order.Company__c == 'Azul Seguros' || order.Company__c == 'Axa Seguros' || order.Company__c == 'Berkley Seguros' || order.Company__c == 'BMG Seguros' || order.Company__c == 'Bradesco Seguros'
            || order.Company__c == 'Capemisa' || order.Company__c == 'Cescebrasil' || order.Company__c == 'Chubb Seguros' || order.Company__c == 'Excelsior Seguros' || order.Company__c == 'Ezze Seguros'
            || order.Company__c == 'Fairfax' || order.Company__c == 'Fator' || order.Company__c == 'Generali Seguros' || order.Company__c == 'HDI Seguros' || order.Company__c == 'Kovr Seguradora S/A'
            || order.Company__c == 'Itau Seguros' || order.Company__c == 'Liberty Seguros' || order.Company__c == 'Mapfre Vida' || order.Company__c == 'MetLife' || order.Company__c == 'Mitsui Sumitomo Seguros'
            || order.Company__c == 'MAG Seguros' || order.Company__c == 'Nobre' || order.Company__c == 'Porto Seguro' || order.Company__c == 'Pottencial Seguradora' || order.Company__c == 'SulAmérica'
            || order.Company__c == 'Sura Seguros' || order.Company__c == 'Tokio Marine' || order.Company__c == 'Btg Pactual' || order.Company__c == 'XI Seguros' || order.Company__c == 'Zurich')
         {
             retorno = true;
         }
        
        return retorno;
    }
    
    
    public static Order verifyCompanyAndPONumber(Order order){
        String apoliceNumber;
        Set<Id> idOrderSet = new Set<Id>();
        List<String> apoliceListNumber;

        String ultimos;
        String ramo;
        Integer index;
        String regexCharEsp = '(?:\\.|,|\\/|\\s|-)';

        if (order.Company__c == 'Alfa Seguros') {
            System.debug('order length Alfa Seguros ' + order.PoNumber.length());

            if (order.PoNumber.length() >= 7) {
                apoliceNumber = order.PoNumber.Replace('/', '').Replace('-', '').Replace('.', '');
                order.PoNumber = apoliceNumber;
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * @description Preencher apenas os onze dígitos a direita. Iniciando pelo "10".
         */
        if (order.Company__c == 'AIG Seguros') {
            System.debug('order length AIG Seguros ' + order.PoNumber.length());

            if (order.PoNumber.length() >= 21) {
                apoliceNumber = order.PoNumber.Replace('/', '').Replace('-', '').Replace('.', '');
                apoliceNumber = apoliceNumber.substring(apoliceNumber.length() - 11);
                order.PoNumber = apoliceNumber;
            } else if (order.PoNumber.length() == 11) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Se apólice SUSEP, preencher: “100” + 2 dígitos do Ramo + “0” + 7 últimos dígitos.
         */
        if (order.Company__c == 'American Life') {
            System.debug('order length American Life ' + order.PoNumber.length());

            if (order.PoNumber.length() >= 24) {
                ultimos = order.PoNumber.substring(order.PoNumber.Length() - 7);
                ramo = order.PoNumber.substring(order.PoNumber.length() - 9).substring(0, 2);
                apoliceNumber = '100' + ramo + '0' + ultimos;
                order.PoNumber = apoliceNumber;
            } else if (order.PoNumber.length() >= 14 && order.PoNumber.length() <= 23) {
                apoliceNumber = order.PoNumber.Replace('X', '');
                order.PoNumber = apoliceNumber;
            } else if (order.PoNumber.length() == 13) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Preencher conforme apólice mas apenas os números sem pontos e/ou traços.
         */
        if (order.Company__c == 'Argo Seguros') {
            System.debug('order length Argo Seguros ' + order.PoNumber.length());

            if (order.PoNumber.length() >= 25) {
                apoliceNumber = order.PoNumber.Replace('/', '').Replace('.', '').Replace('-', '');
                order.PoNumber = apoliceNumber;
            } else if (order.PoNumber.length() < 24 && order.PoNumber.length() >= 19) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra.'
                );
            }
        }
        /**
         * Preencher apenas os doze dígitos da direita pra esquerda.
         */
        if (order.Company__c == 'Austral Seguros') {
            System.debug('order length Austral Seguros ' + order.PoNumber.length());

            if (order.PoNumber.length() >= 24) {
                apoliceNumber = order.PoNumber.Replace('/', '').Replace('.', '').Replace('-', '');
                apoliceNumber = apoliceNumber.substring(apoliceNumber.length() - 12);
                order.PoNumber = apoliceNumber;
            } else if (order.PoNumber.length() == 12) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Preencher conforme apólice mas apenas os números sem pontos e/ou traços.
         */
        if (order.Company__c == 'Azul Seguros') {
            System.debug('order length Azul Seguros ' + order.PoNumber.length());

            if (order.PoNumber.length() >= 18) {
                apoliceNumber = order.PoNumber.Replace('/', '').Replace('.', '').Replace('-', '');
                order.PoNumber = apoliceNumber;
            } else if (order.PoNumber.length() == 17) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Considerar os dígitos após o último ponto e desconsiderar os “0”.
         */
        if (order.Company__c == 'Axa Seguros') {
            System.debug('order length Axa Seguros ' + order.PoNumber.length());

            if (order.PoNumber.length() >= 24 && order.PoNumber.Contains('.')) {
                apoliceListNumber = order.PoNumber.split('\\.');
                index = apoliceListNumber.size() - 1;

                if (apoliceListNumber.size() > 1) {
                    apoliceNumber = apoliceListNumber[index];
                    order.PoNumber = leftZeroesTrim(apoliceNumber);
                    if (order.Company__c != null && order.PoNumber != null) {
                        // order.ReferenceId__c = order.Company__c + ' | ' + order.PoNumber;
                    }
                }
            } else if (order.PoNumber.length() >= 2 && order.PoNumber.length() <= 5) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Preencher com “100” + 2 dígitos do Ramo + “0” + 7 últimos dígitos da apólice.
         */
        if (order.Company__c == 'Berkley Seguros') {
            System.debug('order length Berkley Seguros ' + order.PoNumber.length());

            if (order.PoNumber.length() >= 24) {
                ultimos = order.PoNumber.substring(order.PoNumber.length() - 7);
                ramo = order.PoNumber.Replace('/', '')
                .Replace('.', '')
                .Replace('-', '')
                .substring(order.PoNumber.length() - 9)
                .substring(0, 2);
                apoliceNumber = '100' + ramo + '0' + ultimos;
                order.PoNumber = apoliceNumber;
            } else if (order.PoNumber.length() == 13) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Cadastrar a partir dos números “107”.
         * Se a apólice começar com 1007, é uma apólice partner e deve ter 13 dígitos;
         * Caso comece com 107, é uma apólice Corporate e deve ter 12 dígitos.
         */
        if (order.Company__c == 'BMG Seguros') {
            System.debug('order length BMG Seguros ' + order.PoNumber.length());

           /* if (order.PoNumber.length() >= 24) {
                apoliceNumber = order.PoNumber.Replace('/', '').Replace('.', '').Replace('-', '');
                apoliceNumber = apoliceNumber.substring(apoliceNumber.length() - 13);

                if (apoliceNumber.startsWith('1007')){
                    System.debug('Case 1007' + apoliceNumber);

                    order.PoNumber = apoliceNumber;
                }else if(apoliceNumber.substring(1).startsWith('107')){
                    apoliceNumber = apoliceNumber.substring(1);

                    System.debug('Case 107' + apoliceNumber);
                    order.PoNumber = apoliceNumber;
                }
                order.PoNumber = apoliceNumber;
            } else if (order.PoNumber.length() == 12 || order.PoNumber.length() == 13) {
                //Valor Formatado
            }
            */
         if (order.PoNumber.length() >= 23) {
                ultimos = order.PoNumber.substring(order.PoNumber.Length() - 7);
                ramo = order.PoNumber.substring(order.PoNumber.length() - 9).substring(0, 2);
                apoliceNumber = '100' + ramo + '0' + ultimos;
                order.PoNumber = apoliceNumber;
            } else if (order.PoNumber.length() == 13) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Ignorar os 3 primeiros dígitos do Ramo, considerar os demais sem pontos ou traços.
         */
        if (order.Company__c == 'Bradesco Seguros') {
            System.debug('order length 	Bradesco Seguros ' + order.PoNumber.length());
            if(order.PoNumber.Contains('.')){
                apoliceNumber = order.PoNumber.substring(order.PoNumber.length() - 6);
                order.PoNumber = leftZeroesTrim(apoliceNumber);
            } else if(order.PoNumber.length() >  3 && !order.PoNumber.Contains('.')){
                apoliceNumber = order.PoNumber.substring(3, order.PoNumber.length());
                order.PoNumber = apoliceNumber;
            }else if (order.PoNumber.length() >= 3 && order.PoNumber.length() <= 6) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Ramos Elementares considerar os 12 dígitos a direita iniciando pelo “10”.
         */
        if (order.Company__c == 'Capemisa') {
            System.debug('order length Capemisa ' + order.PoNumber.length());

            if (order.PoNumber.length() >= 24) {
                apoliceNumber = order.PoNumber.substring(order.PoNumber.length() - 12);
                order.PoNumber = apoliceNumber;
            } else if (order.PoNumber.length() >= 12 && order.PoNumber.length() <= 15) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Se apólice SUSEP, preencher: “100” + 2 dígitos do Ramo + “0” + 7 últimos dígitos.
         */
        if (order.Company__c == 'Cescebrasil') {
            System.debug('order length Cescebrasil ' + order.PoNumber.length());

            if (order.PoNumber.length() >= 23) {
                ultimos = order.PoNumber.substring(order.PoNumber.Length() - 7);
                ramo = order.PoNumber.substring(order.PoNumber.length() - 9).substring(0, 2);
                apoliceNumber = '100' + ramo + '0' + ultimos;
                order.PoNumber = apoliceNumber;
            } else if (order.PoNumber.length() == 13) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Preencher conforme apólice, sem pontos, barras ou traços.
         */
        if (order.Company__c == 'Chubb Seguros') {
            System.debug('order length Chubb Seguros ' + order.PoNumber.length());
            apoliceNumber = order.PoNumber.Replace('/', '').Replace('.', '').Replace('-', '');
            order.PoNumber = apoliceNumber;

            if (order.PoNumber.length() >= 13) {
                apoliceNumber = order.PoNumber.substring(0, order.PoNumber.length() -2);
                order.PoNumber = apoliceNumber;
            } else if (order.PoNumber.length() == 11) {
                /** valor formatado */
            } else if (order.PoNumber.length() == 10) {
                order.PoNumber = apoliceNumber;
            } else if (order.PoNumber.length() == 8) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Preencher conforme vem na apólice, desconsiderar os “0” a esquerda.
         */
        if (order.Company__c == 'Excelsior Seguros') {
            System.debug('order length Excelsior Seguros ' + order.PoNumber.length());
			System.debug('order.PoNumber ' + order.PoNumber);
            apoliceNumber = order.PoNumber.Replace('/', '').Replace('.', '').Replace('-', '');

			apoliceNumber = leftZeroesTrim(apoliceNumber);
            System.debug('apoliceNumber after leftzerotrim ' + apoliceNumber);
            
            if (order.PoNumber.length() > 10) {
                if (order.PoNumber.length() > 13 && order.PoNumber.length() <= 30) {
                    apoliceNumber = apoliceNumber.substring(order.PoNumber.length()-19,order.PoNumber.length()-7);
                     System.debug('apoliceNumber:  ' + apoliceNumber);
                    order.PoNumber = apoliceNumber;

                } else {
                    apoliceNumber = leftZeroesTrim(order.PoNumber.Replace('/', '').Replace('.', '').Replace('-', ''));
                    order.PoNumber = apoliceNumber;
                }

            } else if (order.PoNumber.length() == 12) {
                /** valor formatado */
            } else if (order.PoNumber.length() >= 2 && order.PoNumber.length() <= 10) {
                /** valor formatado */
                apoliceNumber = leftZeroesTrim(order.PoNumber.Replace('/', '').Replace('.', '').Replace('-', ''));
                order.PoNumber = apoliceNumber;
            } else {
                order.addError(
                    'Quantidade de números incorreta para ' +
                    order.Company__c +
                    ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Preencher conforme apólice de 13 dígitos. Se apólice SUSEP, preencher “1007507” + os 6 dígitos da direita pra esquerda.
         */
        if (order.Company__c == 'Ezze Seguros') {
            System.debug('order length Ezze Seguros ' + order.PoNumber.length());

            if (order.PoNumber.length() >= 23) {
                ultimos = order.PoNumber.substring(order.PoNumber.length() - 6);
                apoliceNumber = '1007507' + ultimos;
                order.PoNumber = apoliceNumber;
            } else if (order.PoNumber.length() == 12 || order.PoNumber.length() == 13) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Se apólice SUSEP, preencher apenas os 12 dígitos da direita pra esquerda.
         */
        if (order.Company__c == 'Fairfax') {
            System.debug('order length Fairfax ' + order.PoNumber.length());

            if (order.PoNumber.length() > 13 ) {
                apoliceNumber = order.PoNumber.substring(order.PoNumber.length() -12);
                order.PoNumber = apoliceNumber;
            } else if(order.PoNumber.length() == 13 || order.PoNumber.length() == 12){
                /** valor formatado */
                order.PoNumber = order.PoNumber;
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Se apólice SUSEP, preencher apenas os 12 dígitos da direita pra esquerda.
         */
        if (order.Company__c == 'Fator') {
            System.debug('order length Fator ' + order.PoNumber.length());

            if (order.PoNumber.length() >= 23) {
                apoliceNumber = order.PoNumber.substring(order.PoNumber.length() - 12);
                order.PoNumber = apoliceNumber;
            } else if (order.PoNumber.length() == 12 || order.PoNumber.length() == 13) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Cadastrar conforme apólice retirando pontos, traços e barras.
         */
        if (order.Company__c == 'Generali Seguros') {
            System.debug('order length Generali Seguros ' + order.PoNumber.length());

            if (order.PoNumber.length() >= 11) {
                apoliceNumber = order.PoNumber.Replace('/', '').Replace('.', '').Replace('-', '');
                order.PoNumber = apoliceNumber;
            } else if (order.PoNumber.length() > 2) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Preencher os números entre o terceiro e quarto ponto.
         * Caso haja, desconsiderar os “0” a esquerda.
         */
        if (order.Company__c == 'HDI Seguros') {
            System.debug('order length 	HDI Seguros ' + order.PoNumber.length());

            if (order.PoNumber.length() >= 22 && order.PoNumber.Contains('.')) {
                apoliceListNumber = order.PoNumber.split('\\.');

                if (apoliceListNumber.size() > 3) {
                    apoliceNumber = leftZeroesTrim(order.PoNumber.Split('\\.')[3]);
                    order.PoNumber = apoliceNumber.Replace('/', '').Replace('.', '').Replace('-', '');
                    if (order.Company__c != null && order.PoNumber != null) {
                        // order.ReferenceId__c = order.Company__c + ' | ' + order.PoNumber;
                    }
                    return new Order();
                }
            } else if (order.PoNumber.length() >= 4 && order.PoNumber.length() <= 6) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Preencher conforme apólice. Caso haja, ignorar ponto e dígitos da filial a esquerda.
         */
        if (order.Company__c == 'Kovr Seguradora S/A') {
            System.debug('order length ' + order.PoNumber.length());
            if(order.PoNumber.length() >= 13 && order.PoNumber.length() <= 20 && order.PoNumber.Contains('.')){
                apoliceNumber = order.PoNumber.split('\\.')[1];
                order.PoNumber = apoliceNumber;
                }else if(order.PoNumber.length() > 20 && !order.PoNumber.Contains('.')){
                    ultimos = order.PoNumber.substring(order.PoNumber.length() - 6);
                    ramo = order.PoNumber.substring(order.PoNumber.length() - 9).substring(0, 2);
                    apoliceNumber = '100' + ramo + '07' + ultimos;
                    order.PoNumber = apoliceNumber;
            } else if (order.PoNumber.length() >= 10 && order.PoNumber.length() <= 13) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }

        /**
         * Considerar os números entre o último e penúltimo ponto.
         */
        if (order.Company__c == 'Itau Seguros') {
            System.debug('order length Itau Seguros ' + order.PoNumber.length());

            if (order.PoNumber.length() >= 11 && order.PoNumber.Contains('.')) {
                apoliceListNumber = order.PoNumber.split('\\.');

                if (apoliceListNumber.size() > 2) {
                    apoliceNumber = order.PoNumber.split('\\.')[2];
                    order.PoNumber = apoliceNumber;
                }
            } else if (order.PoNumber.length() > 2 && order.PoNumber.length() < 11) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Retirar os pontos e preencher o número completo.
         */
        if (order.Company__c == 'Liberty Seguros') {
            System.debug('order length Generali Seguros ' + order.PoNumber.length());

            if (order.PoNumber.length() >= 8) {
                apoliceNumber = order.PoNumber.Replace('/', '').Replace('.', '').Replace('-', '');
                order.PoNumber = apoliceNumber;
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Caso haja, ignorar pontos, traços e barras.
         */
        if (order.Company__c == 'Mapfre Vida') {
            System.debug('order length Mapfre Vida ' + order.PoNumber.length());

            if (order.PoNumber.length() >= 5) {
                apoliceNumber = order.PoNumber.Replace('-', '').Replace('.', '').Replace('/', '');
                order.PoNumber = apoliceNumber;
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Considerar os 5 primeiros números da esquerda para direita.
         */
        if (order.Company__c == 'MetLife') {
            System.debug('order length MetLife ' + order.PoNumber.length());

            if (order.PoNumber.length() >= 8) {
                apoliceNumber = order.PoNumber.Replace('/', '').Replace('.', '').Replace('-', '');
                apoliceNumber = apoliceNumber.substring(apoliceNumber.length() - 8).substring(0, 5);
                order.PoNumber = apoliceNumber;
            } else if (order.PoNumber.length() == 5) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Desconsiderar os zeros a esquerda e preencher o restante do número.
         */
        if (order.Company__c == 'Mitsui Sumitomo Seguros') {
            System.debug('order length Mitsui Sumitomo Seguros ' + order.PoNumber.length());

            if (order.PoNumber.length() >= 11) {
                apoliceNumber = leftZeroesTrim(order.PoNumber);
                order.PoNumber = apoliceNumber;
            } else if (order.PoNumber.length() == 10) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        if (order.Company__c == 'MAG Seguros') {
            System.debug('order length MAG Seguros ' + order.PoNumber.length());

            if (order.PoNumber.length() <= 10 && order.PoNumber.length() >= 5) {
                /** valor formatado */
            }  else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Preencher o número entre a segunda e a terceira barra.
         * Caso haja, desconsiderar os zeros a esquerda.
         */
        if (order.Company__c == 'Nobre') {
            System.debug('order length Nobre ' + order.PoNumber.length());

            if (order.PoNumber.length() >= 18 && order.PoNumber.Contains('/')) {
                apoliceListNumber = order.PoNumber.Split('\\/');

                if (apoliceListNumber.size() > 2) {
                    apoliceNumber = leftZeroesTrim(order.PoNumber.Split('\\/')[2]);
                    order.PoNumber = apoliceNumber;
                }
            } else if (order.PoNumber.length() == 2) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Desconsiderar zeros a esquerda, pontos e traços.
         */
        if (order.Company__c == 'Porto Seguro') {
            System.debug('order length o Seguro ' + order.PoNumber.length());
            apoliceListNumber = order.PoNumber.Split(regexCharEsp);
            index = apoliceListNumber.size() - 1;

            if (order.PoNumber.length() <= 10 ){
                apoliceNumber = apNumberFormat(0, index, apoliceListNumber);
            } else if (apoliceListNumber.size() <= 2) {
                apoliceNumber = apoliceListNumber[index];
            } else if(apoliceListNumber.size() > 2) {
                apoliceNumber = apNumberFormat(2, index, apoliceListNumber);
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
            order.PoNumber = apoliceNumber;
        }

        if (order.Company__c == 'Pottencial Seguradora') {
            System.debug('order length Pottencial Seguradora ' + order.PoNumber.length());
            order.PoNumber = order.PoNumber.replaceAll('\\D', '');
            if(order.PoNumber.length() == 25){
                apoliceNumber = order.PoNumber.substring(15, order.PoNumber.length() -3);
                order.PoNumber = apoliceNumber;
            } else if(order.PoNumber.length() == 15){
                apoliceNumber = order.PoNumber.substring(8, order.PoNumber.length());
                order.PoNumber = apoliceNumber;

            } else if (order.PoNumber.length() == 7) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Utilizar os 7 últimos dígitos desconsiderado zeros a esquerda.
         * Se apólice menor que 7 dígitos, preencher conforme apólice.
         */
        if (order.Company__c == 'SulAmérica') {
            System.debug('order length SulAmérica ' + order.PoNumber.length());

            if (order.PoNumber.length() >= 7) {
                apoliceNumber = order.PoNumber.substring(order.PoNumber.length() - 7);
                order.PoNumber = leftZeroesTrim(apoliceNumber);
            } else if (order.PoNumber.length() > 2) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        if (order.Company__c == 'Sura Seguros'){
            System.debug('order length Sura Seguros ' + order.PoNumber.length());
            if(order.PoNumber.length() >= 15 && order.PoNumber.length() <= 24){
                ultimos = order.PoNumber.substring(order.PoNumber.length() - 6);
                ramo = order.PoNumber.substring(order.PoNumber.length() - 9).substring(0, 2);
                apoliceNumber = ramo + '07' + ultimos;
                order.PoNumber = apoliceNumber;
            }else if(order.PoNumber.length() > 0){
                /** valor formatado */
            }else{
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Para Garantia preencher usando os seis últimos dígitos incluindo os zeros.
         */
        if (order.Company__c == 'Tokio Marine') {
            System.debug('order length Tokio Marine ' + order.PoNumber.length());

            if (order.PoNumber.length() >= 16) {
                apoliceNumber = order.PoNumber.substring(order.PoNumber.length() - 6);
                order.PoNumber = apoliceNumber;
                if (order.Company__c != null && order.PoNumber != null) {
                    // order.ReferenceId__c = order.Company__c + ' | ' + order.PoNumber;
                }
                return new Order();
            } else if (order.PoNumber.length() >= 10 && order.PoNumber.length() <= 15) {
                apoliceNumber = order.PoNumber.substring(order.PoNumber.length() - 10);
                order.PoNumber = leftZeroesTrim(apoliceNumber);
            } else if (order.PoNumber.length() >= 2 && order.PoNumber.length() <= 8) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Para apólices BTG, considerar somente os 12 dígitos a direita iniciando pelo "10".
         */
        if (order.Company__c == 'Btg Pactual') {
            System.debug('order length Too Seguros ' + order.PoNumber.length());

            if (order.PoNumber.length() == 24) {
                apoliceNumber = order.PoNumber.substring(order.PoNumber.length() - 12);

                order.PoNumber = apoliceNumber;
            } else if (order.PoNumber.length() == 12) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
         * Preencher conforme vem na apólice e desconsiderar “0” à esquerda. Caso haja, ignorar pontos, traços e barras.
         */
        if (order.Company__c == 'XI Seguros') {
            System.debug('order length XI Seguros ' + order.PoNumber.length());

            if (order.PoNumber.length() >= 11) {
                apoliceNumber = order.PoNumber.Replace('-', '').Replace('.', '').Replace('/', '');
                order.PoNumber = leftZeroesTrim(apoliceNumber);
            } else if (order.PoNumber.length() == 10) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra'
                );
            }
        }
        /**
        * Se contiver pontos, desconsiderar os zeros a esquerda dos 7 números finais.
        */
        if (order.Company__c == 'Zurich') {
            System.debug('order length Zurich ' + order.PoNumber.length());

            if (order.PoNumber.length() > 7) {
                apoliceNumber = order.PoNumber.Replace('-', '').Replace('.', '').Replace('/', '');
                apoliceNumber = apoliceNumber.substring(apoliceNumber.length() - 7);
                order.PoNumber = leftZeroesTrim(apoliceNumber);
            } else if (order.PoNumber.length() > 1 && order.PoNumber.length() <= 7) {
                /** valor formatado */
            } else {
                order.addError(
                'Quantidade de números incorreta para ' +
                order.Company__c +
                ' por favor verifique o número do pedido de compra.'
                );
            }
        }

        return order;
    }

    /**
    * @description verifica o book de aplices para formatar o PONumber
    * @param order
    */
    public static void processarPoNumber(Order order) {
        order = verifyCompanyAndPONumber(order);
    }

    /**
    * @description Função para retirar zeros a esquerda da String
    * @param str
    * @return str
    */
    public static String leftZeroesTrim(String str) {
        Integer indexFunc = str.indexOfAnyBut('0');
        if (indexFunc == -1 || indexFunc == null) {
            return str;
        } else {
            return str.substring(indexFunc);
        }
    }

    /**
    * @description
    * @param indexInitial
    * @param index
    * @param apoliceListNumber
    * @return apoliceNumber
    */
    private static string apNumberFormat (Integer indexInitial, Integer index, List<String> apoliceListNumber){
        String apoliceNumber;

        for (Integer i=indexInitial; i<=index; i++) {
            if (apoliceNumber==null) {
                apoliceNumber = apoliceListNumber[i];
            } else {
                apoliceNumber = apoliceNumber+apoliceListNumber[i];
            }
        }
        return apoliceNumber;
    }
}