/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 11-01-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-01-2021   Samuel SIrkis                        Initial Version
 **/
public class OlosUtil {
    /**
     *   Retorna uma String a partir de um Object.
     *   Se o objeto for igual a NULL, retorna uma String vazia, caso contrário, faz a conversão e retorna uma String sem os espaços iniciais e finais(trim()).
     *   @param obj Um Object qualquer.
     *   @return O objeto convertido em String.
     */
    public static String getString(Object obj){
        return (obj == null ? '' : String.valueOf(obj));
    }

    public static Boolean getBoolean(Object obj){
        return (obj == null ? false : Boolean.valueOf(obj));
    }

    public static Integer getInteger(Object obj){
        return (obj == null ? 0 : Integer.valueOf(obj));
    }

    public static String geraGUID(){
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        return (String) h.SubString(0, 8) + '-' + h.SubString(8, 12) + '-' + h.SubString(12, 16) + '-' + h.SubString(16, 20) + '-' + h.substring(20);
    }
}