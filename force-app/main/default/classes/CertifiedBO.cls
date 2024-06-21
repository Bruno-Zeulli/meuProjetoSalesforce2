/**
 * @description       :
 * @author            :viniciusazevedo@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 02-07-2022
 * @last modified by  :viniciusazevedo@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-07-2022  viniciusazevedo@wizsolucoes.com.br   Initial Version
 **/
public without sharing class CertifiedBO {

    private static final CertifiedBO INSTANCE = new CertifiedBO();

    public static CertifiedBO getInstance(){
        return INSTANCE;
    }

    public List<Certified__c> formatingForNumber(List<Certified__c> lstCertified){
        List<Certified__c> lstReturnCertified = new List<Certified__c>();

        for(Certified__c objCertified : lstCertified){

            String numberAverbacao;

            if(objCertified.RegistrationNumber__c.length() >=1 &&
                objCertified.RegistrationNumber__c.length() <=20
                ){

                numberAverbacao = objCertified.RegistrationNumber__c
                                                .Replace('/','')
                                                .Replace('-','')
                                                .Replace('.','')
                                                .trim();
                objCertified.RegistrationNumber__c = numberAverbacao;

            }else{ objCertified.addError(
                    'Número de Averbação incorreto para este Certificado'
                    );
            }
            lstReturnCertified.add(objCertified);
        }
        return lstReturnCertified;
    }
}