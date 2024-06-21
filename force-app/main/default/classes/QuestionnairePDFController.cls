public with sharing class QuestionnairePDFController {

    public String content {get; set;}
    public Questionnaire__c questionnaire {get; set;}

    public QuestionnairePDFController(ApexPages.StandardController stdController) {
        if (!Test.isRunningTest()){
            stdController.addFields(getFields());
        }

        this.questionnaire = (Questionnaire__c) stdController.getRecord();

        StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'modeloQuestionarioPdf' LIMIT 1];
        String body = sr.Body.toString();

        Map<String, String> mergeFields = getMergeFieldsValues();
        System.debug(mergeFields);
        for(String key: mergeFields.keySet()){
            String fieldValue = mergeFields.get(key) == null ? '' : mergeFields.get(key);            
            body = body.replace('{!'+key+'}',fieldValue);
        }

        List<Questionnaire_Answer__c> answers = [SELECT Id, Questionnaire_Question__r.Label__c, Questionnaire_Question__r.Order__c, Questionnaire_Question__r.Session__r.Label__c, Answer__c, Comment__c FROM Questionnaire_Answer__c WHERE Questionnaire__c = :questionnaire.Id ORDER BY Questionnaire_Question__r.Order__c];
        Map<String, List<Questionnaire_Answer__c>> sectionAnswersMap = new Map<String, List<Questionnaire_Answer__c>>();
        for (Questionnaire_Answer__c answer : answers){
            List<Questionnaire_Answer__c> answerList = sectionAnswersMap.get(answer.Questionnaire_Question__r.Session__r.Label__c);
            if (answerList == null){
                answerList = new List<Questionnaire_Answer__c>();
            }
            answerList.add(answer);
            sectionAnswersMap.put(answer.Questionnaire_Question__r.Session__r.Label__c, answerList);
        }

        Integer sectionNumber = 1;
        String sectionContent = '';
        for (String section : sectionAnswersMap.keySet()){
            String sectionTemplate = body.substringBetween('<!-- {!initLoopSecao} -->', '<!-- {!fimLoopSecao} -->');
            sectionTemplate = sectionTemplate.replace('{!ordemSecao}',String.valueOf(sectionNumber++));
            sectionTemplate = sectionTemplate.replace('{!rotuloSecao}',section);

            String answerContent = '';
            for (Questionnaire_Answer__c answer : sectionAnswersMap.get(section)){
                String answerTemplate = sectionTemplate.substringBetween('<!-- {!initLoopQuestion} -->', '<!-- {!fimLoopQuestion} -->');
                answerTemplate = answerTemplate.replace('{!rotuloPergunta}',answer.Questionnaire_Question__r.Label__c);
                answerTemplate = answerTemplate.replace('{!rotuloResposta}',answer.Answer__c == null ? '' : answer.Answer__c);
                answerContent += answerTemplate;
            }
            sectionTemplate = sectionTemplate.replace(body.substringBetween('<!-- {!initLoopQuestion} -->', '<!-- {!fimLoopQuestion} -->'), answerContent);

            sectionContent += sectionTemplate;
        }

        body = body.replace(body.substringBetween('<!-- {!initLoopSecao} -->', '<!-- {!fimLoopSecao} -->'), sectionContent);
        this.content = body;
    }
    
    public Map<String, String> getMergeFieldsValues(){

        Datetime today = System.now();
        return new Map<String, String>{
            'RazaoSocial' => this.questionnaire.Opportunity__r.Account.Name,
            'CNPJ' => this.questionnaire.Opportunity__r.Account.IdentificationNumber__c,
            'NomeResponsavel' => '',
            'local' => 'São Paulo',
            'dia' => today.format('dd'),
            'mes' => today.format('MMMM'),
            'ano' => today.format('y')
        };
    }

    public List<String> getFields() {
        List<String> fields = new List<String>();
        fields.add('Opportunity__r.Account.Name');
        fields.add('Opportunity__r.Account.IdentificationNumber__c');
        return fields;
    }
}