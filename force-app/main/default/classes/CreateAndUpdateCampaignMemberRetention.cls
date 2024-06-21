public class CreateAndUpdateCampaignMemberRetention
{
    @invocableMethod
    public static list<ReturnVariables> campaignMemberRetention (List<InputVariables> InputVariables)
    {
        //Listas
        List<Contract2__c> ContratosAtualizados = new List<Contract2__c>();
        List<Contract2__c> ContratosFiltrados = new List<Contract2__c>();
        List<ContactDetail__c> listaDetalheDeContato = new List<ContactDetail__c>();
        List<CampaignMember> CampaignMemberRetencao = new List<CampaignMember>();
        List<CampaignMember> CampaignMemberToUpdate = new List<CampaignMember>();
        List<CampaignMember> ListCmParaCriar = new List<CampaignMember>();
        List<CampaignActivity__c> ListCaParaCriar = new List<CampaignActivity__c>();
        List<CampaignActivity__c> ListCaQueJaExistem = new List<CampaignActivity__c>();
        List<String> IdsCampaignMemberParaAtualizar = new List<String>();

        //Sets
        Set<String> IdsContatos = new Set<String>();
        Set<String> IdsContatosParaCriarCM = new Set<String>();

        //Date
        Date DataInicio = InputVariables.get(0).DataInicio.get(0);
        Date DataFinal = InputVariables.get(0).DataFinal.get(0);

        //Maps
        Map<String, Contract2__c> mapIdContatoToContrato = new map<String, Contract2__c>();
        Map<String, ContactDetail__c> mapIdDetalheDeContato = new map<String, ContactDetail__c>();
        Map<String, CampaignMember> mapContatoCampaignMember = new map<String, CampaignMember>();
        Map<String, CampaignActivity__c> mapContratoCampaignActivity = new map<String, CampaignActivity__c>();

        //Variaveis
        String IdCampaignRetencao = InputVariables.get(0).IdCampaign.get(0);

        //Variaveis de Retorno
        List<ReturnVariables> retornoList = new List<ReturnVariables>();
        ReturnVariables retorno = new ReturnVariables();

        //Lista de contratos inicial
        ContratosAtualizados = InputVariables.get(0).contratos;

        //Pegar todas as Atividades que ja existem para o periodo selecionado
        ListCaQueJaExistem = [SELECT Id, Contact__c, Contrato__c, AllocationDate__c FROM CampaignActivity__c WHERE AllocationDate__c >=: DataInicio AND AllocationDate__c <=: DataFinal AND Campaign__c =: IdCampaignRetencao];

        //Percorrer todas as atividades e setar o mapa
        for(CampaignActivity__c ca : ListCaQueJaExistem)
        {
          mapContratoCampaignActivity.put(ca.Contrato__c, ca);
        }

        //Percorrer todos os contratos e setar o mapa
        for(Contract2__c ctr : InputVariables.get(0).contratos)
        {
            mapIdContatoToContrato.put(ctr.Contact__c, ctr);

            //Caso nao exista nenhuma Atividade relacionada ao contrato, adicione a lista para criar
            if(mapContratoCampaignActivity.get(ctr.Id) == null)
            {
                ContratosFiltrados.add(ctr);
            }
        }

        //Percorrer lista de contratos para setar um SET de Contato
        for(Contract2__c c : ContratosFiltrados)
        {
          IdsContatos.add(c.Contact__c);
        }

        //Identificar a lista de Detalhes de Contato e setar no MAP
        listaDetalheDeContato = [SELECT Id, Contact__c FROM ContactDetail__c WHERE Contact__c IN :IdsContatos];

        for(ContactDetail__c cd : listaDetalheDeContato)
        {
          mapIdDetalheDeContato.put(cd.Contact__c, cd);
        }

        //Pegar todos os CampaignMembers de retencao que estao presentes no SET de contato
        CampaignMemberRetencao = [SELECT Id, ContactId, IntegrationStatus__c FROM CampaignMember WHERE CampaignId =:IdCampaignRetencao AND ContactId IN :IdsContatos];

        //Percorrer todos os membros de campanha e setar o mapa
        for(CampaignMember cm : CampaignMemberRetencao)
        {
          mapContatoCampaignMember.put(cm.ContactId, cm);
        }

        //Para cada ID de contato unico, verifico se existe o CampaignMember ou nao. Caso sim, eu separo o CM para atualizar, caso nao, eu separo o Contrato para criar
        for(String c : IdsContatos)
        {
            //Existe o CM
            if(mapContatoCampaignMember.get(c) != null)
            {
                mapContatoCampaignMember.get(c).IntegrationStatus__c = 'Retirado';

                if(mapIdContatoToContrato.get(c) != null)
                mapContatoCampaignMember.get(c).Contrato__c = mapIdContatoToContrato.get(c).Id;

                if(mapIdDetalheDeContato.get(c) != null)
                mapContatoCampaignMember.get(c).ContactDetail__c = mapIdDetalheDeContato.get(c).Id;

                CampaignMemberToUpdate.add(mapContatoCampaignMember.get(c));
                IdsCampaignMemberParaAtualizar.add(mapContatoCampaignMember.get(c).Id);
            }
            //Nao existe o CM
            else
            {
                IdsContatosParaCriarCM.add(c);
            }
        }

        //Atualizar Lista de CampaignMember
        if(!CampaignMemberToUpdate.IsEmpty())
        Database.update(CampaignMemberToUpdate,false);

        //Preparar lista de criacao de CM para enviar pro fluxo
        for(String c : IdsContatosParaCriarCM)
        {
            CampaignMember cmAux = new CampaignMember();
            cmAux.CampaignId = IdCampaignRetencao;
            cmAux.ContactId = c;
            cmAux.IntegrationStatus__c = 'Enviado';

            if(mapIdContatoToContrato.get(c) != null)
            cmAux.Contrato__c = mapIdContatoToContrato.get(c).Id;
            
            cmAux.Status = 'Enviado';
            cmAux.Priority__c = 5;

            if(mapIdDetalheDeContato.get(c) != null)
            cmAux.ContactDetail__c = mapIdDetalheDeContato.get(c).Id;

            ListCmParaCriar.add(cmAux);
        }

        //Percorrer lista de criacao de CA para enviar ao fluxo
        for(Contract2__c c : ContratosFiltrados)
        {
            CampaignActivity__c caAux = new CampaignActivity__c();
            caAux.AllocationDate__c = c.StartDate__c;
            caAux.Campaign__c = IdCampaignRetencao;
            caAux.Contact__c = c.Contact__c;
            caAux.Contrato__c = c.Id;
            caAux.Status__c = 'Closed';
            caAux.ExtraInfo__c = c.ProductName__c;

            ListCaParaCriar.add(caAux);
        }

        //Preencher variaveis de retorno
        retorno.CampaignMemberParaCriar2 = ListCmParaCriar;
        retorno.CampaignActivityParaCriar2 = ListCaParaCriar;
        retorno.IdsCampaignMemberParaAtualizar = IdsCampaignMemberParaAtualizar;

        retornoList.add(retorno);
        return retornoList;
    }

    public class InputVariables
    {
        @InvocableVariable
        public List<Contract2__c> contratos;

        @InvocableVariable
        public List<String> IdCampaign;

        @InvocableVariable
        public List<Date> DataInicio;

        @InvocableVariable
        public List<Date> DataFinal;
    }

    public class ReturnVariables
    {
        @InvocableVariable
        public List<Contract2__c> CampaignMemberParaCriar;

        @InvocableVariable
        public List<CampaignMember> CampaignMemberParaAtualizar;

        @InvocableVariable
        public List<String> IdsCampaignMemberParaAtualizar;

        @InvocableVariable
        public List<Contract2__c> CampaignActivityParaCriar;

        @InvocableVariable
        public List<CampaignMember> CampaignMemberParaCriar2;

         @InvocableVariable
        public List<CampaignActivity__c> CampaignActivityParaCriar2;
    }
}