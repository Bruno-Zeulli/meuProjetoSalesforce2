/*****************************************************************
Nome:  CampaignHelper
Data de criação: 11/12/2018
============================================================
Propósito: Classe de criação e manipulação de registros de Campaign
para serem utilizandos como massa de teste
============================================================
Histórico de alterações
-------
VERSÃO      AUTOR               DATA                Descrição
1.0.0       Pedro Sozin     	11/12/2018          Criação
2.0.0		Ronnie Jr			06/06/2019			iData
*****************************************************************/
public with sharing class CampaignHelper {
    public static Campaign criaCampanha(){
        Campaign campanha = new Campaign(Name = 'Teste');

        if(Schema.sObjectType.Campaign.isCreateable()){
            insert campanha;
            return campanha;
        }
        return null;
    }
}