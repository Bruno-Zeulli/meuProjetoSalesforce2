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
public class OlosEntity {
    //// MAILING ////
    public class Addr {
        public string isd = '55';
        public string prefix;
        public string phone;

        public Addr(string prefix, string phone) {
            this.prefix = prefix;
            this.phone = phone;
        }
    }

    public class MediaData {
        public Integer type = 9;
        public Addr addr;

        public MediaData(Addr addr) {
            this.addr = addr;
        }
    }

    public class Fields {
        public string Id_Cliente_Salesforce;
        public string Nome_Cliente_Salesforce;
        public string Cliente_WhatId;
        public string Cliente_WhoId;
        public string Coringa1_Salesforce;
        public string Coringa2_Salesforce;
        public string Coringa3_Salesforce;
        public string Coringa4_Salesforce;
        public string Coringa5_Salesforce;
        public string Coringa6_Salesforce;
        public string Coringa7_Salesforce;
        public string Coringa8_Salesforce;
        public string ContactDispositionId;
        public string ContactDisposition;

        public Fields(
            String Id_Cliente_Salesforce,
            string Nome_Cliente_Salesforce,
            String Cliente_WhatId,
            String Cliente_WhoId,
            String Coringa4_Salesforce,
            String Coringa1_Salesforce,
            String Coringa2_Salesforce,
            String Coringa3_Salesforce,
            String Coringa6_Salesforce,
            String Coringa7_Salesforce,
            String Coringa8_Salesforce
        ) {
            this.Id_Cliente_Salesforce = Id_Cliente_Salesforce;
            this.Nome_Cliente_Salesforce = Nome_Cliente_Salesforce;
            this.Cliente_WhatId = Cliente_WhatId;
            this.Cliente_WhoId = Cliente_WhoId;
            this.Coringa4_Salesforce = Coringa4_Salesforce;
            this.Coringa5_Salesforce = DateTime.now().format();
            this.Coringa1_Salesforce = Coringa1_Salesforce;
            this.Coringa2_Salesforce = Coringa2_Salesforce;
            this.Coringa3_Salesforce = Coringa3_Salesforce;
            this.Coringa6_Salesforce = Coringa6_Salesforce;
            this.Coringa7_Salesforce = Coringa7_Salesforce;
            this.Coringa8_Salesforce = Coringa8_Salesforce;
        }
        
        public Fields(
            String Id_Cliente_Salesforce,
            string Nome_Cliente_Salesforce,
            String Cliente_WhatId,
            String Cliente_WhoId,
            String Coringa4_Salesforce,
            String Coringa1_Salesforce,
            String Coringa2_Salesforce,
            String Coringa3_Salesforce,
            String Coringa6_Salesforce,
            String Coringa7_Salesforce,
            String Coringa8_Salesforce,
            String ContactDispositionId,
            String ContactDisposition
        ) {
            this.Id_Cliente_Salesforce = Id_Cliente_Salesforce;
            this.Nome_Cliente_Salesforce = Nome_Cliente_Salesforce;
            this.Cliente_WhatId = Cliente_WhatId;
            this.Cliente_WhoId = Cliente_WhoId;
            this.Coringa4_Salesforce = Coringa4_Salesforce;
            this.Coringa5_Salesforce = DateTime.now().format();
            this.Coringa1_Salesforce = Coringa1_Salesforce;
            this.Coringa2_Salesforce = Coringa2_Salesforce;
            this.Coringa3_Salesforce = Coringa3_Salesforce;
            this.Coringa6_Salesforce = Coringa6_Salesforce;
            this.Coringa7_Salesforce = Coringa7_Salesforce;
            this.Coringa8_Salesforce = Coringa8_Salesforce;
            this.ContactDispositionId = ContactDispositionId;
            this.ContactDisposition = ContactDisposition;
        }
    }
        
    public class FieldsLeads {

        public string Id_Cliente_Salesforce;
        public string Nome_Cliente_Salesforce;
        public string Cliente_WhatId;
        public string Cliente_WhoId;
        public string Coringa1_Salesforce;
        public string Coringa2_Salesforce;
        public string Coringa3_Salesforce;
        public string Coringa4_Salesforce;
        public string Coringa5_Salesforce;
        public string Coringa6_Salesforce;
        public string Coringa7_Salesforce;
        public string Coringa8_Salesforce;
        public string ContactDispositionId;
        public string ContactDisposition;

        public FieldsLeads(
            String Id_Cliente_Salesforce,
            string Nome_Cliente_Salesforce,
            String Cliente_WhatId,
            String Cliente_WhoId,
            String Coringa4_Salesforce,
            String Coringa1_Salesforce,
            String Coringa2_Salesforce,
            String Coringa3_Salesforce,
            String Coringa6_Salesforce,
            String Coringa7_Salesforce,
            String Coringa8_Salesforce,
            String ContactDispositionId,
            String ContactDisposition
        ) {
            this.Id_Cliente_Salesforce = Id_Cliente_Salesforce;
            this.Nome_Cliente_Salesforce = Nome_Cliente_Salesforce;
            this.Cliente_WhatId = Cliente_WhatId;
            this.Cliente_WhoId = Cliente_WhoId;
            this.Coringa4_Salesforce = Coringa4_Salesforce;
            this.Coringa5_Salesforce = DateTime.now().format();
            this.Coringa1_Salesforce = Coringa1_Salesforce;
            this.Coringa2_Salesforce = Coringa2_Salesforce;
            this.Coringa3_Salesforce = Coringa3_Salesforce;
            this.Coringa6_Salesforce = Coringa6_Salesforce;
            this.Coringa7_Salesforce = Coringa7_Salesforce;
            this.Coringa8_Salesforce = Coringa8_Salesforce;
            this.ContactDispositionId = ContactDispositionId;
            this.ContactDisposition = ContactDisposition;
        }
    }

    public class MailingJson {
        public string customer;
        public Fields fields;
        public List<MediaData> mediaData;

        public MailingJson(string customer, Fields fields, List<MediaData> mediaData) {
            this.customer = customer;
            this.fields = fields;
            this.mediaData = mediaData;
        }
    }

    public class MailingJsonLeads {
        public string customer;
        public FieldsLeads fields;
        public List<MediaData> mediaData;

        public MailingJsonLeads(string customer, FieldsLeads fields, List<MediaData> mediaData) {
            this.customer = customer;
            this.fields = fields;
            this.mediaData = mediaData;
        }
    }
    //// MAILING ////

    public class OlosEvent {
        public string AgentEventType;
        public string[] EventObject;
        public EventObjectLoginCCM EventObjectLoginCCM;
        public EventSendMsgToSupervisorFail EventSendMsgToSupervisorFail;
        public EventNewMsgFromSupervisor EventNewMsgFromSupervisor;
        public EventObjectLogout EventObjectLogout;
    }

    public class EventObjectLoginCCM {
        public string AgentId;
        public string AgentName;
    }

    public class EventSendMsgToSupervisorFail {
        public string AgentId;
        public string Reason;
        public string Description;
    }

    public class EventNewMsgFromSupervisor {
        public string MessageId;
        public string BroadcastId;
        public string AgentId;
        public string SupervisorId;
        public string Message;
    }

    public class EventObjectLoginCampaign {
        public string AgentId;
        public string CampaignId;
        public string CampaignName;
        public string CampaignCode;
    }

    public class EventObjectLogout {
        public string AgentId;
        public string CampaignId;
    }
}