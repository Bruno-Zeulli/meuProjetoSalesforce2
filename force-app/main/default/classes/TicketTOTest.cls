@isTest
private class TicketTOTest {
    @isTest
    static void testTicketTO(){
        TicketTO.Contact contact = new TicketTO.Contact();
        contact.id = '001';
        contact.name = 'John Doe';

        TicketTO.Owner owner = new TicketTO.Owner();
        owner.id = '005';
        owner.name = 'Jane Smith';

        TicketTO.ContactDetail contactDetail = new TicketTO.ContactDetail();
        contactDetail.id = '002';
        contactDetail.name = 'Contact Detail';
        contactDetail.email = 'contact@example.com';

        TicketTO.RecordType recordType = new TicketTO.RecordType();
        recordType.id = '012';
        recordType.name = 'Record Type';
        recordType.developerName = 'Record_Type';

        TicketTO ticketTO = new TicketTO();
        ticketTO.id = '123';
        ticketTO.caseNumber = 'CASE-001';
        ticketTO.dataCriacao = Datetime.newInstanceGmt(2023, 8, 10, 12, 0, 0);
        ticketTO.dataModificacao = Datetime.newInstanceGmt(2023, 8, 10, 14, 0, 0);
        ticketTO.prioridade = 'High';
        ticketTO.status = 'Open';
        ticketTO.prioridadeFormatada = 'Alta';
        ticketTO.statusFormatado = 'Aberto';
        ticketTO.motivo = 'Problema Técnico';
        ticketTO.tipo = 'Incidência';
        ticketTO.subtipo = 'Hardware';
        ticketTO.procedente = 'Sim';
        ticketTO.nota = 'Este é um ticket de teste';
        ticketTO.createdDateToFilter = Date.newInstance(2023, 8, 10);
        ticketTO.contact = contact;
        ticketTO.owner = owner;
        ticketTO.contactDetail = contactDetail;
        ticketTO.recordtype = recordType;

        // Verifique se os valores atribuídos correspondem aos valores esperados
        System.assertEquals('123', ticketTO.id);
        System.assertEquals('CASE-001', ticketTO.caseNumber);
        System.assertEquals(Datetime.newInstanceGmt(2023, 8, 10, 12, 0, 0), ticketTO.dataCriacao);
        System.assertEquals(Datetime.newInstanceGmt(2023, 8, 10, 14, 0, 0), ticketTO.dataModificacao);
        System.assertEquals('High', ticketTO.prioridade);
        System.assertEquals('Open', ticketTO.status);
        System.assertEquals('Alta', ticketTO.prioridadeFormatada);
        System.assertEquals('Aberto', ticketTO.statusFormatado);
        System.assertEquals('Problema Técnico', ticketTO.motivo);
        System.assertEquals('Incidência', ticketTO.tipo);
        System.assertEquals('Hardware', ticketTO.subtipo);
        System.assertEquals('Sim', ticketTO.procedente);
        System.assertEquals('Este é um ticket de teste', ticketTO.nota);
        System.assertEquals(Date.newInstance(2023, 8, 10), ticketTO.createdDateToFilter);
        System.assertEquals(contact, ticketTO.contact);
        System.assertEquals(owner, ticketTO.owner);
        System.assertEquals(contactDetail, ticketTO.contactDetail);
        System.assertEquals(recordType, ticketTO.recordtype);
    }
}