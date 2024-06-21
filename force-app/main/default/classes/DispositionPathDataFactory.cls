/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
@isTest
public class DispositionPathDataFactory {
    public static DispositionPath__c createDispositionPath(String category, String subcategory, String reason, String specificReason){
        String disposition;
        if(specificReason != null){
            disposition = specificReason;
        }else if(reason != null){
            disposition = reason;
        }else if(subcategory != null){
            disposition = subcategory;
        }else if(category != null){
            disposition = category;
        }
        DispositionPath__c dp = new DispositionPath__c(
            Name = disposition,
            Category__c = category,
            Subcategory__c = subcategory,
            Reason__c = reason,
            SpecificReason__c = specificReason,
            Disposition__c = disposition
        );
        return dp;
    }

    public static DispositionPath__c insertDispositionPath4LevelsDeep(){
        DispositionPath__c dp = createDispositionPath(
            '1 - Atendimento realizado',
            '1.5 - Sem oportunidade de venda',
            '1.5.3 - Já contratou com outras seguradoras',
            '1.5.3.1 - Bradesco'
        );
        insert dp;
        return dp;
    }

    public static DispositionPath__c insertDispositionPath3LevelsDeep(){
        DispositionPath__c dp = createDispositionPath('1 - Atendimento realizado', '1.5 - Sem oportunidade de venda', '1.5.1 - Falecido', null);
        insert dp;
        return dp;
    }

    public static DispositionPath__c insertDispositionPath2LevelsDeep(){
        DispositionPath__c dp = createDispositionPath('1 - Atendimento realizado', '1.1 - Venda', null, null);
        insert dp;
        return dp;
    }

    public static DispositionPath__c insertDispositionPath1LevelDeep(){
        DispositionPath__c dp = createDispositionPath('5 - Transferência', null, null, null);
        insert dp;
        return dp;
    }
}