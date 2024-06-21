/**
 * @description       :
 * @author            : samuelsirkis@wiz.co
 * @group             :
 * @last modified on  : 11-04-2023
 * @last modified by  : samuelsirkis@wiz.co
**/
public without sharing class AssetBO {

    /**
    * @description declaração de variaveis */
    private static final AssetBO INSTANCE = new AssetBO();

    /**
    * @description constroi a instancia da classe AssetBO
    * @return instancia da classe AssetBO
    */
    public static AssetBO getInstance(){
        return INSTANCE;
    }

    public void createAssetAutomobilesByOpportunityDescription(Set<Id> setOpportunitiesIds){

        Id assetRecordTypeAutomobiles = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName()
        .get('Automobiles')
        .getRecordTypeId();

        Map<String, String> mapStringValues = new Map<String, String>();
        Map<String, String> mapOpportunityIdByVIN = new Map<String, String>();
        Map<String, Asset> mapAssetByVIN = new Map<String, Asset>();
        List<Opportunity> lstOpportunitiesUpd = new List<Opportunity>();
        Set<String> lstVIN = new Set<String>();
        List<Asset> lstAssetAssingOpportunity = new List<Asset>();

        for(Opportunity objOpportunity: [SELECT Id, AccountId, Description FROM Opportunity WHERE Id IN :setOpportunitiesIds]){

            Asset objAsset = setAssetAutomobilesByOpportunityDescriptions(objOpportunity, assetRecordTypeAutomobiles);

            if(objAsset.AssetIdentifierCode__c != null){
                lstVIN.add(objAsset.AssetIdentifierCode__c);
                System.debug('lstVIN ==>>> '+ lstVIN);

                mapOpportunityIdByVIN.put(objAsset.AssetIdentifierCode__c, objOpportunity.Id);
                mapAssetByVIN.put(objAsset.AssetIdentifierCode__c, objAsset);
            }
        }

        for(Asset objAsset : [ SELECT  Id, AssetIdentifierCode__c FROM Asset WHERE AssetIdentifierCode__c IN:lstVIN]){
            mapAssetByVIN.remove(objAsset.AssetIdentifierCode__c);
            lstAssetAssingOpportunity.add(objAsset);
        }

        List<Asset> lstAsset = new List<Asset>(mapAssetByVIN.values());

        if(!lstAsset.isEmpty()){

            String msgErrorSubject = 'Error ao criar o bem relacionado';

            Savepoint sp = Database.setSavepoint();
            try{
                Database.SaveResult[] srListFiles = Database.insert(lstAsset, false);
                ErrorLogService.getInstance().saveResult(srListFiles, msgErrorSubject, lstAsset);
            } catch (Exception e){
                System.Debug(e);
                Database.rollback(sp);
            }

            list<Asset> lstAssetInseted = [SELECT Id,AssetIdentifierCode__c FROM Asset WHERE AssetIdentifierCode__c IN:lstVIN];

            lstOpportunitiesUpd = getListOpportunityToUpdate(lstAssetInseted, lstOpportunitiesUpd, mapOpportunityIdByVIN);

        }


        if(!lstAssetAssingOpportunity.IsEmpty()){

            lstOpportunitiesUpd = getListOpportunityToUpdate(lstAssetAssingOpportunity, lstOpportunitiesUpd, mapOpportunityIdByVIN);

        }

        if(!lstOpportunitiesUpd.isEmpty()){
            String msgErrorSubject = 'Error ao vincular o Bem Relaciondo a Opportunidade';

            Savepoint sp = Database.setSavepoint();
            try{
                Database.SaveResult[] srListFiles = Database.update(lstOpportunitiesUpd, false);
                ErrorLogService.getInstance().saveResult(srListFiles, msgErrorSubject, lstOpportunitiesUpd);
            } catch (Exception e){
                System.Debug(e);
                Database.rollback(sp);
            }

        }
    }

    private List<Opportunity> getListOpportunityToUpdate(List<Asset> lstAsset, List<Opportunity> lstOpportunitiesUpd, Map<String, String> mapOpportunityIdByVIN){

        for(Asset objAsset : lstAsset){

            Opportunity objOpportunity = new Opportunity();

            if(mapOpportunityIdByVIN.containsKey(objAsset.AssetIdentifierCode__c)){
                objOpportunity.Id = mapOpportunityIdByVIN.get(objAsset.AssetIdentifierCode__c);
                objOpportunity.Asset__c = objAsset.Id;
                lstOpportunitiesUpd.add(objOpportunity);
            }
        }

        return lstOpportunitiesUpd;
    }

    private Asset setAssetAutomobilesByOpportunityDescriptions(Opportunity objOpportunity, Id assetRecordTypeAutomobiles){

        Map<String, String> mapStringValues = setMapStringValuesAssetAutomobiles(objOpportunity);

        System.debug('MAPSTRING ==>>> '+ mapStringValues);

        Asset objAsset = new Asset();

        objAsset.AccountId = objOpportunity.AccountId;
        Account acc = [SELECT Id, Name FROM Account WHERE Id = : objOpportunity.AccountId ];
        objAsset.ManufacturersName__c = mapStringValues.containsKey('Marca') ?
                                            mapStringValues.get('Marca').toUpperCase() :
                                            null;
        objAsset.ModelName__c = mapStringValues.containsKey('Modelo') ?
                                    mapStringValues.get('Modelo').toUpperCase() :
                                    null;
        objAsset.AssetIdentifierCode__c = mapStringValues.containsKey('Chassi') ?
                                            mapStringValues.get('Chassi').length() > 0 ?
                                                mapStringValues.get('Chassi').toUpperCase() :
                                                null :
                                            null;
        objAsset.AssetIdentifierType__c = mapStringValues.containsKey('Chassi') ?
                                            mapStringValues.get('Chassi').length() > 0 ?
                                                'Chassi (VIN)' :
                                                null:
                                            null;
        objAsset.AssetIdentifierCodeSecondary__c = mapStringValues.containsKey('Renavam') ?
                                                        mapStringValues.get('Renavam').length() > 0 ?
                                                            mapStringValues.get('Renavam').toUpperCase() :
                                                            null :
                                                        null;
        objAsset.AssetIdentifierTypeSecondary__c = mapStringValues.containsKey('Renavam') ?
                                                        mapStringValues.get('Renavam').length() > 0 ?
                                                            'Renavam' :
                                                            null :
                                                        null;
        objAsset.IsNewOrZeroKm__c = mapStringValues.containsKey('Veículo 0km') ?
                                        mapStringValues.get('Veículo 0km') == 'Sim' ?
                                            true :
                                            false :
                                        false;
        objAsset.ManufactureYear__c = mapStringValues.containsKey('Ano/Fabricação') ?
                                        mapStringValues.get('Ano/Fabricação') :
                                        null;
        objAsset.ModelYear__c = mapStringValues.containsKey('Ano/Modelo') ?
                                    mapStringValues.get('Ano/Modelo') :
                                    null;
        objAsset.Status = mapStringValues.containsKey('Status Vnd') ?
                                mapStringValues.get('Status Vnd') :
                                null;
        objAsset.InvoiceNumber__c = mapStringValues.containsKey('Nr NF') ?
                                        mapStringValues.get('Nr NF') :
                                        null;
        objAsset.HasCreditInsurance__c = mapStringValues.containsKey('Prestamista') ?
                                            mapStringValues.get('Prestamista') == 'Sim' ?
                                                true :
                                                false :
                                            false;
        objAsset.ZipCode__c = mapStringValues.containsKey('Cliente CEP') ?
                                mapStringValues.get('Cliente CEP') :
                                null;
        objAsset.Mileage__c = mapStringValues.containsKey('Km') ?
                                mapStringValues.get('Km') :
                                null;
        objAsset.LicensePlate__c = mapStringValues.containsKey('Placa') ?
                                        mapStringValues.get('Placa') :
                                        null;
        objAsset.Uuid = 'VIN | ' + objAsset.AssetIdentifierCode__c;
        objAsset.Name = 'CHASSI | ' + objAsset.AssetIdentifierCode__c + ' | ' + acc.Name;
        objAsset.ContactId = null;
        objAsset.RecordTypeId = assetRecordTypeAutomobiles;

        return objAsset;
    }

    private Map<String, String> setMapStringValuesAssetAutomobiles(Opportunity objOpportunity){

        Map<String, String> mapStringValues = new Map<String, String>();
        List<String> lstParamSplit = getListParamSplitAssetAutomobiles();
        String paramSplitAfter = '\r\n';
        String paramRemoveString = ': ';

        for(String paramSplitBefore: lstParamSplit){
            String srtReturn = StringUtil.getInstance().getValueInStringByParamSplit(objOpportunity.Description, paramSplitBefore, paramSplitAfter, paramRemoveString);
            System.debug('String return =>>' + srtReturn);
            if(srtReturn != null){
                mapStringValues.put(paramSplitBefore, srtReturn);
            }

        }

        return mapStringValues;

    }

    private List<string> getListParamSplitAssetAutomobiles(){

        List<String> lstParamSplit = new List<String>();
        lstParamSplit.add('Marca');
        lstParamSplit.add('Modelo');
        lstParamSplit.add('Veículo 0km');
        lstParamSplit.add('Chassi');
        lstParamSplit.add('Renavam');
        lstParamSplit.add('Placa');
        lstParamSplit.add('Ano/Fabricação');
        lstParamSplit.add('Ano/Modelo');
        lstParamSplit.add('Status Vnd');
        lstParamSplit.add('Nr NF');
        lstParamSplit.add('Loja');
        lstParamSplit.add('Vendedor');
        lstParamSplit.add('Prestamista');
        lstParamSplit.add('Cliente CEP');
        lstParamSplit.add('Km');

        return lstParamSplit;
    }

    public void upsertAssets(List<Asset> assetList){
        Savepoint sp = Database.setSavepoint();
        try{
            Database.UpsertResult[] urListFiles = Database.upsert(assetList, Asset.Id, false);
            System.debug(urListFiles);
            // ErrorLogService.getInstance().saveResult(srListFiles, 'Erro ao criar as respostas em branco', answersList);
        } catch (Exception e){
            System.Debug(e);
            Database.rollback(sp);
        }
    }
}