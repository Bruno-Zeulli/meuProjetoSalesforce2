global with sharing class QuestionnaireRestTO {
    public class Error {
        public String title {get; set;}
        public String details {get; set;}
    }

    public class Questionnaire {
        public String opportunityId {get; set;}
        public String formDefName {get; set;}
        public List<Answer> answers {get; set;}
        public Tables tables {get; set;}
    }

    public class QuestionnaireUpdate {
        public List<Answer> answers {get; set;}
        public Tables tables {get; set;}
    }

    public class Answer {
        public String code {get; set;}
        public String answer {get; set;}
        public String comment {get; set;}
    }

    public class Tables {
        // Add new tables here
        public List<RiskyPlace> riskyPlaces {get; set;}
    }

    public class RiskyPlace {
        public String id {get; set;}
        public String name {get; set;}
        public String placeCode {get; set;}
        public String address {get; set;}
        public String activity {get; set;}
    }

    public class QuestionnaireDefinition{
        public String name;
        public String status;
        public Boolean allowPlaces;
        public List<Section> sections;
    }

    public class Section{
        public Decimal sectionOrder;
        public String label;
        public List<Question> questions;
    }

    public class Question{
        public Decimal questionOder;
        public String label;
        public String type;
        public Boolean allowComment;
        public String externalCode;
        public List<String> options;
    }
}