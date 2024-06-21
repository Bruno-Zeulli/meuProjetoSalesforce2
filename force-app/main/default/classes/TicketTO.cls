public with sharing class TicketTO {
   public String id { get; set; }
   public String caseNumber { get; set; }
   public Datetime dataCriacao { get; set; }
   public Datetime dataModificacao { get; set; }
   public String prioridade { get; set; }
   public String status { get; set; }
   public String prioridadeFormatada { get; set; }
   public String statusFormatado { get; set; }
   public String motivo { get; set; }
   public String tipo { get; set; }
   public String subtipo { get; set; }
   public String procedente { get; set; }
   public String nota { get; set; }
   public Date createdDateToFilter { get; set; }
   public Contact contact { get; set; }
   public Owner owner { get; set; }
   public ContactDetail contactDetail { get; set; }
   public RecordType recordtype { get; set; }

    public class Contact {
        public String id { get; set; }
        public String name { get; set; }
    }

      public class ContactDetail {
        public String id { get; set; }
        public String name { get; set; }
        public String email { get; set; }

    }

    public class Owner {
        public String id { get; set; }
        public String name { get; set; }
    }

    public class RecordType {
        public String id { get; set; }
        public String name { get; set; }
        public String developerName { get; set; }
    }
}