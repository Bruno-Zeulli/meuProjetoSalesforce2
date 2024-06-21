/**
 * @description       : Classe Service responsável por receber e direcionar chamadas para a API DIRETRIX.
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 07-24-2022
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   07-24-2022   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
public without sharing class DiretrixService {

    /**
    * @description declaração de variaveis globais e constantes*/
    public static final DiretrixService INSTANCE = new DiretrixService();

    /**
    * @description constroi a instancia da classe DiretrixService
    * @return instancia da classe DiretrixService
    */
    public static DiretrixService getInstance(){
        return INSTANCE;
    }

    /**
    * @description Realiza a chamada a classe de integração com a API Diretrix, monta a DTO com o response da chamada da API Diretrix.
    * @param identificationNumber recebe uma string com o valor do CNPJ.
    * @return retorna a DTO com o objeto do retorno da chamada API Diretrix.
    */
    public DiretrixTO.DiretrixResponseFindByIndentificationNumber findCompanyByIndentificationNumber(String identificationNumber){

        Map<String, Object> mapReturnJson = (Map<String, Object>) IntegrationAPIDiretrix.getInstance().getCompanyByIndentificationNumber(identificationNumber);
        System.debug('MAP Return : ' + mapReturnJson);

        if(mapReturnJson.containsKey('Retorno')){
            DiretrixTO.DiretrixResponseFindByIndentificationNumber diretrixResponseFindByIndentificationNumber =
                (DiretrixTO.DiretrixResponseFindByIndentificationNumber) (JSON.deserialize(
                    (String) mapReturnJson.get('Retorno'),
                    DiretrixTO.DiretrixResponseFindByIndentificationNumber.class
                ));

            return diretrixResponseFindByIndentificationNumber;
        }

        return null;
    }
}