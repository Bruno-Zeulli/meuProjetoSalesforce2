public class ExpurgoBO {
    private static final ExpurgoBO INSTANCE = new ExpurgoBO();

    public static ExpurgoBO getInstance(){
        return INSTANCE;
    }


    public List<Account> verificarContasSemVinculo(List<Account> contas){
        Set<Id> contatosIdentificadores  = new Set<Id>();
        List<Account> contasSemCasosOportunidadesEPedidos = new List<Account>();
        List<Account> contasSemVinculos = new List<Account>();
         
        for(Account conta : contas){

            /**
             * Validar se a Conta não possui Casos, pedidos e Oportunidades
             */
            if(conta.Cases.size() < 1 && conta.Opportunities.size() < 1 && conta.Orders.size() < 1 && conta.Contacts.size() > 0){
                contasSemCasosOportunidadesEPedidos.add(conta);
                
                for(Contact contato : conta.Contacts){
                    contatosIdentificadores.add(contato.Id);
                }

            }
        }


        Map<String, CampaignMember> mapMembroCampanhaPeloContatoId = pegarMapeamentoMembrosCampanhaPorContatoId(contatosIdentificadores);

        contasSemVinculos = separarContasSemCampanhas(contasSemCasosOportunidadesEPedidos, mapMembroCampanhaPeloContatoId);

        return contasSemVinculos;
        

    }

    public List<Account> verificarContatosFilhosPossuiCasosERetirarDaLista(List<Account> contas){
        Map<String, Account> mapapeamentoContasPorId = new Map<String, Account>();
        Map<String, Account> mapapeamentoContasPorContato = new Map<String, Account>();
        Set<Id> contatosIds = new Set<Id>(); 

        for(Account conta : contas){
            mapapeamentoContasPorId.put(conta.Id, conta);
        }

        List<Contact> contatos = [SELECT Id, AccountId FROM Contact WHERE AccountId IN :mapapeamentoContasPorId.keySet()];

        for(Contact contato : contatos){
            Account conta = mapapeamentoContasPorId.get(contato.AccountId);

            if(conta != null){
                mapapeamentoContasPorContato.put(contato.Id, conta);
            }
            
        }
        
        List<Case> casosContatos = [SELECT Id, ContactId From Case WHERE ContactId IN :mapapeamentoContasPorContato.keySet()];

        for(Case caso : casosContatos){
            Account conta = mapapeamentoContasPorContato.get(caso.ContactId);

            if(conta != null){
                mapapeamentoContasPorId.remove(conta.Id);
            }
        }

        return mapapeamentoContasPorId.values();

    }

    
    public Map<String, CampaignMember>  pegarMapeamentoMembrosCampanhaPorContatoId(Set<Id> contatosIdentificadores){

        List<CampaignMember> membrosCampanhas = [SELECT id, ContactId FROM CampaignMember WHERE ContactId IN :contatosIdentificadores];

        Map<String, CampaignMember> mapMembroCampanhaPeloContatoId = new Map<String, CampaignMember>();

        for(CampaignMember membroCampanha : membrosCampanhas){
            mapMembroCampanhaPeloContatoId.put(membroCampanha.ContactId, membroCampanha);
        }

        return mapMembroCampanhaPeloContatoId;


    }

    public List<Account> separarContasSemCampanhas(List<Account> contas, Map<String, CampaignMember> mapMembroCampanhaPeloContatoId ){

        List<Account> contasSemVinculos = new List<Account>();

        for(Account conta : contas){
                Boolean possuiMembrosCampanhas = false;

                for(Contact contato : conta.Contacts){
                    CampaignMember membroCampanha =  mapMembroCampanhaPeloContatoId.get(contato.Id);
                    if(membroCampanha != null){
                        possuiMembrosCampanhas = true;
                    }
                }
        
                if(possuiMembrosCampanhas == false){
                    contasSemVinculos.add(conta);
                }
        }

        return contasSemVinculos;

    }

    public List<Contact> pegarContatosPorContasIds(List<Account> contas){
        Set<Id> contasIds = new Set<Id>(); 
        List<Contact> contatosSemCasos = new List<Contact>();
        Map<Id, Contact> mapContactsById = new Map<Id, Contact>();
        for(Account conta : contas){
            contasIds.add(conta.Id);
        }

        List<Contact> contatos = [SELECT Id, (SELECT Id FROM Cases) FROM Contact WHERE AccountId IN :contasIds AND Account.isPersonAccount = false];

        for(Contact contato : contatos){
            mapContactsById.put(contato.Id, contato);
            // if(contato.Cases == null || contato.Cases.size() < 1){
            //     contatosSemCasos.add(contato);
            // }
        }

        List<Case> casos = [SELECT Id, ContactId FROM Case WHERE ContactId IN :mapContactsById.keySet()];

        for(Case caso: casos){
            if(mapContactsById.get(caso.ContactId) != null){
                mapContactsById.remove(caso.ContactId);
            }
        }

        return mapContactsById.values();
    }

    public List<ContactDetail__c> pegarContatosDetalhesPorContatosIds(List<Contact> contatos){
        Set<Id> contatosIds = new Set<Id>(); 
        
        for(Contact contato : contatos){
            contatosIds.add(contato.Id);
        }

        List<ContactDetail__c> contatosDetalhes = [SELECT Id FROM ContactDetail__c WHERE Contact__c IN :contatosIds];

        return contatosDetalhes;
    }


}