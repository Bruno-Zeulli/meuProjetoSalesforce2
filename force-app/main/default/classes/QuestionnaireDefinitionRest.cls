@RestResource(urlMapping='/v1/Questionnaire/Definition')
global without sharing class QuestionnaireDefinitionRest {

    public static final Set<String> TYPE_OPTIONS_AVAILABLE = new Set<String>{'Lista de Opções', 'Checkbox', 'Radio', 'Tabela'};

    @HttpGet
    global static void getDefinition(){
        RestRequest req = RestContext.request;
        String definitionProduct = req.params.get('product');
        String definitionSubproduct = req.params.get('subproduct');
        if (String.isBlank(definitionProduct)){
            setError('Missing product parameter', '', 422);
            return ;
        }

        if (String.isBlank(definitionSubproduct)){
            setError('Missing subproduct parameter', '', 422);
            return ;
        }

        List<Questionnaire_Definition__c> defList;
        if(definitionSubproduct=='null'){
            List<Questionnaire__c> questOpp = [SELECT Id, Questionnaire_Definition__c FROM Questionnaire__c WHERE Opportunity__c=:definitionProduct];
            Id qDefId;
            if(!questOpp.isEmpty()){
                qDefId = questOpp.get(0).Questionnaire_Definition__c;
            }
            defList = [
            SELECT
                Id, Name, Allow_Places__c, Status__c,
                (
                    SELECT Id, Label__c, Type__c, Options__c, Allow_Comment__c, External_Code__c, Question_Order__c, Session_Order__c, Order__c, Session__c
                    FROM Questionnaire_Questions__r
                    ORDER BY Order__c
                )
            FROM Questionnaire_Definition__c
            WHERE Id=:qDefId
            ];
        }else{
            defList = [
            SELECT
                Id, Name, Allow_Places__c, Status__c,
                (
                    SELECT Id, Label__c, Type__c, Options__c, Allow_Comment__c, External_Code__c, Question_Order__c, Session_Order__c, Order__c, Session__c
                    FROM Questionnaire_Questions__r
                    ORDER BY Order__c
                )
            FROM Questionnaire_Definition__c
            WHERE Product__c = :definitionProduct AND SUB_Product__c = :definitionSubproduct
            ];
        }

        if (defList.isEmpty()){
            RestResponse res = RestContext.response;
            res.statusCode = 204;
        } else {
            Questionnaire_Definition__c definition = defList.get(0);

            QuestionnaireRestTO.QuestionnaireDefinition defBody = new QuestionnaireRestTO.QuestionnaireDefinition();
            defBody.name = definition.Name;
            defBody.status = definition.Status__c;
            defBody.allowPlaces = definition.Allow_Places__c;
            defBody.sections = new List<QuestionnaireRestTO.Section>();

            Map<String, QuestionnaireRestTO.Section> sectionMap = new Map<String, QuestionnaireRestTO.Section>();
            Map<String, List<QuestionnaireRestTO.Question>> questionsMap = new Map<String, List<QuestionnaireRestTO.Question>>();

            for (Questionnaire_Question__c q : definition.Questionnaire_Questions__r){
                if (q.Type__c == 'Sessão'){
                    QuestionnaireRestTO.Section section;
                    section = new QuestionnaireRestTO.Section();
                    section.label = q.Label__c;
                    section.sectionOrder = q.Session_Order__c;
                    sectionMap.put(q.Id, section);
                } else {
                    String sectionKey = q.Session__c == null ? 'Default' : q.Session__c;
                    List<QuestionnaireRestTO.Question> questionList = questionsMap.get(sectionKey);
                    if (questionList == null){
                        questionList = new List<QuestionnaireRestTO.Question>();
                    }

                    QuestionnaireRestTO.Question question = new QuestionnaireRestTO.Question();
                    question.label = q.Label__c;
                    question.type = q.Type__c;
                    question.allowComment = q.Allow_Comment__c;
                    question.externalCode = q.External_Code__c;
                    question.questionOder = q.Question_Order__c;
                    if (TYPE_OPTIONS_AVAILABLE.contains(question.type)){
                        question.options = String.isEmpty(q.Options__c) ? null : q.Options__c.split(';');
                    }
                    questionList.add(question);
                    questionsMap.put(sectionKey, questionList);
                }
            }

            if (questionsMap.containsKey('Default')){
                QuestionnaireRestTO.Section section;
                section = new QuestionnaireRestTO.Section();
                section.label = 'Default';
                section.sectionOrder = 99.999;
                sectionMap.put('Default', section);
            }

            for (String sectionId : sectionMap.keySet()){
                sectionMap.get(sectionId).questions = questionsMap.get(sectionId);
            }

            defBody.sections = sectionMap.values();

            RestResponse res = RestContext.response;
            res.statusCode = 200;
            res.headers.put('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(JSON.serialize(defBody));
        }
    }

    private static void setError(String errorTitle, String errorDetails, Integer statusCode){
        RestResponse res = RestContext.response;
        QuestionnaireRestTO.Error e = new QuestionnaireRestTO.Error();
        e.title = errorTitle;
        e.details = errorDetails;
        res.statusCode = statusCode;
        res.headers.put('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(JSON.serialize(e));
    }

}