public with sharing class TicketBO {
    private static final TicketBO INSTANCE = new TicketBO();
    private static Map<String, Id> mapRecordTypeIdByName = new Map<String, Id>();
    public static TicketBO getInstance(){
        return INSTANCE;
    }

    public void toDefineRecordTypeTickets(Map<Id,Case> mapaTicketsParceiros){
        this.populateMapRecordTypesParceirosTickets();

        Id tipoRegistroTicketPadrao = mapRecordTypeIdByName.get('Parceiros Tickets');

        List<Case> tickets = CaseDAO.getInstance().getCasesByOwnerIds(mapaTicketsParceiros.keySet());

        for(Case ticket: tickets){
            ticket = this.searchRecordtype(ticket, 'Reclamação', 'Agro', 'Parceiros Tickets - Bacen');
            ticket = this.searchRecordtype(ticket, 'Reclamação', 'ASC', 'Parceiros Tickets - Central');
        }
        update tickets;
    }

    public Boolean encontrouTipoRegistroCorreto(Case ticket, Id tipoRegistroTicketPadrao){
        return ticket.RecordtypeId != tipoRegistroTicketPadrao;
    }

    public void populateMapRecordTypesParceirosTickets(){
        List<RecordType> tiposRegistrosCasosParceirosTickets = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Case' AND Name LIKE '%Parceiros Tickets%'];
        for(RecordType tipoRegistro : tiposRegistrosCasosParceirosTickets){
            if(tipoRegistro != null) mapRecordTypeIdByName.put(tipoRegistro.Name,tipoRegistro.Id);
        }
    }

    public Case searchRecordtype(Case caso, String motivoCasoEsperado, String tipoCasoEsperado, String rercordTypeName){
        if(caso.CaseReason__c == motivoCasoEsperado && caso.Type == tipoCasoEsperado){

            Id recordtypeId = mapRecordTypeIdByName.get(rercordTypeName);

            if(recordtypeId != null) caso.RecordTypeId = recordtypeId;

            return caso;
        }
        return caso;

    }
}