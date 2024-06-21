public with sharing class EventosBO {
    private static final EventosBO INSTANCE = new EventosBO();
    public static EventosBO getInstance(){
        return INSTANCE;
    }

    public Boolean hasRecordType(EventosSalesforce__e event){
        EventoTO.Event eventWithRecordTypeName = getEventWithRecordType(event);
        return eventWithRecordTypeName.RecordTypeName != null;
    }

    public Boolean validateObjectType(String objectEvent, String objectType){
        return objectEvent == objectType;
    }

    public Map<String, RecordType> getRecordtypesOfEvents(List<EventosSalesforce__e> events, String objectType){
         try{
            Set<String> setRecordtypeName = new Set<String>();

            for(EventosSalesforce__e event : events){
                if(event.Object__c == objectType){
                    EventoTO.Event eventWithRecordTypeName = getEventWithRecordType(event);
                    setRecordtypeName.add(eventWithRecordTypeName.RecordTypeName);
                }
            }

            List<RecordType> listRecordTypes = [SELECT Id, Name, DeveloperName, SobjectType FROM RecordType WHERE Name IN :setRecordtypeName AND SobjectType = :objectType];
            Map<String, RecordType> mapRecordtypeByName = new Map<String, RecordType>();

            for(RecordType recordType : listRecordTypes){
                mapRecordtypeByName.put(recordType.Name, recordType);
            }

            return mapRecordtypeByName;
        } catch (DmlException e){
            LogBO.getInstance().insertErrorOfEvents(events, e.getMessage());
            return new Map<String, RecordType>();
        }
    }

    public EventoTO.Event getEventWithRecordType(EventosSalesforce__e event){
        EventoTO.Event eventWithRecordTypeName = (EventoTO.Event) JSON.deserialize(event.Body__c, EventoTO.Event.class);
        return eventWithRecordTypeName;
    }

    /**
     * Separar os Eventos e encaminhar para inserção do Objeto
     */
    public void distributionEvents(List<EventosSalesforce__e> events){
        List<EventosSalesforce__e> lstNewLeadsEvents = new List<EventosSalesforce__e>();
        List<EventosSalesforce__e> lstNewTasksEvents = new List<EventosSalesforce__e>();
        List<EventosSalesforce__e> lstNewAccountsEvents = new List<EventosSalesforce__e>();

        System.debug('Distribuindo eventos: ' + events.size());
        for(EventosSalesforce__e event : events){
            if(validateObjectType(event.Object__c, 'Lead')){
                lstNewLeadsEvents.add(event);
            }else if(validateObjectType(event.Object__c, 'Task')){
                lstNewTasksEvents.add(event);
            }else if(validateObjectType(event.Object__c, 'Account')){
                lstNewAccountsEvents.add(event);
            }
        }

        if(lstNewLeadsEvents.size() > 0)
            insertLeadsOnEvent(lstNewLeadsEvents);
        if(lstNewTasksEvents.size() > 0)
            insertTasksOnEvent(lstNewTasksEvents);
        if(lstNewAccountsEvents.size() > 0)
            insertAccountsOnEvent(lstNewAccountsEvents);
    }

    public void insertLeadsOnEvent(List<EventosSalesforce__e> events){
         try{
            Map<String, RecordType> mapRecordtypeByName = EventosBO.getInstance().getRecordtypesOfEvents(events, 'Lead');
            List<Lead> leadsToInsert = new List<Lead>();
            List<EventoTO.Lead> leadsOnEvents = new List<EventoTO.Lead>();

            for(EventosSalesforce__e event : events){
                if(hasRecordType(event)){
                    EventoTO.Lead leadEvent = (EventoTO.Lead) JSON.deserialize(event.Body__c, EventoTO.Lead.class);
                    RecordType recordType = mapRecordtypeByName.get(leadEvent.RecordTypeName);
                    leadEvent.RecordTypeId = recordType.Id;
                    leadsOnEvents.add(leadEvent);
                }
            }
            if(leadsOnEvents.size() > 0){
                for(EventoTO.Lead eventLeadType : leadsOnEvents){
                    Lead lead = (Lead) JSON.deserialize(JSON.serialize(eventLeadType), Lead.class);
                    leadsToInsert.add(lead);
                }
                insert leadsToInsert;
            }
        } catch (DmlException e){
            LogBO.getInstance().insertErrorOfEvents(events, e.getMessage());
        }
    }

    public void insertTasksOnEvent(List<EventosSalesforce__e> events){
         try{
            Map<String, RecordType> mapRecordtypeByName = EventosBO.getInstance().getRecordtypesOfEvents(events, 'Task');
            List<EventoTO.Task> tasksOnEvents = new List<EventoTO.Task>();
            List<Task> tasksToInsert = new List<Task>();
            for(EventosSalesforce__e event : events){
                if(hasRecordType(event)){
                    EventoTO.Task taskEvent = (EventoTO.Task) JSON.deserialize(event.Body__c, EventoTO.Task.class);
                    RecordType recordType = mapRecordtypeByName.get(taskEvent.RecordTypeName);
                    taskEvent.RecordTypeId = recordType.Id;
                    tasksOnEvents.add(taskEvent);
                }
            }

            if(tasksOnEvents.size() > 0){
                for(EventoTO.Task eventTaskType : tasksOnEvents){
                    Task task = (Task) JSON.deserialize(JSON.serialize(eventTaskType), Task.class);
                    tasksToInsert.add(task);
                }
            }

            insert tasksToInsert;
        } catch (DmlException e){
            LogBO.getInstance().insertErrorOfEvents(events, e.getMessage());
        }
    }

    public void insertAccountsOnEvent(List<EventosSalesforce__e> events){
         try{
            Map<String, RecordType> mapRecordtypeByName = EventosBO.getInstance().getRecordtypesOfEvents(events, 'Account');
            List<EventoTO.Account> accountsOnEvents = new List<EventoTO.Account>();
            List<Account> accountsToInsert = new List<Account>();

            for(EventosSalesforce__e event : events){
                if(hasRecordType(event)){
                    EventoTO.Account accountEvent = (EventoTO.Account) JSON.deserialize(event.Body__c, EventoTO.Account.class);
                    RecordType recordType = mapRecordtypeByName.get(accountEvent.RecordTypeName);
                    accountEvent.RecordTypeId = recordType.id;
                    accountsOnEvents.add(accountEvent);
                }
            }

            if(accountsOnEvents.size() > 0){
                for(EventoTO.Account eventAccountType : accountsOnEvents){
                    Account account = (Account) JSON.deserialize(JSON.serialize(eventAccountType), Account.class);
                    account.IdentificationNumber__c = eventAccountType.IdentificationNumber;

                    if(eventAccountType.RecordtypeName == 'PF'){
                        account.IndividualIdentificationNumber__pc = eventAccountType.IdentificationNumber;
                    }

                    accountsToInsert.add(account);
                }
            }

            insert accountsToInsert;
        } catch (DmlException e){
            LogBO.getInstance().insertErrorOfEvents(events, e.getMessage());
        }
    }
}