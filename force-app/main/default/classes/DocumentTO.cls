public with sharing class DocumentTO {
    public String name {get; set;}
    public String documentId {get; set;}
    public String contentVersionId {get; set;}
    public String path {get; set;}
    public String url {get;set;}
    public String tipoDocumento {get;set;}
    public Boolean isOpportunityOFCorporate {get;set;}

    public DocumentTypeGetResponse[] documentTypeGetResponses;
    public class DocumentTypeGetResponse{
        public String idTipoArquivo {get; set;}
        public String descricaoTipoArquivo {get; set;}
    }

    public Pessoa[] pessoa;
    public class Pessoa{
        public String documento {get; set;}
        public String tipoPessoa {get; set;}
        public String desCaminho {get; set;}
    }

    public DocumentGetResponse[] documentGetResponses;
    public class DocumentGetResponse{
        public String idArquivo {get; set;}
        public String idTipoArquivo {get; set;}
        public String documento {get; set;}
        public String desCaminho {get; set;}
        public String desCpf {get; set;}
        public String urlBlob {get; set;}
        public String base64 {get; set;}
        public String isExcluido {get; set;}
        public String dtExclusao {get; set;}
        public String tenant {get; set;}
        public Pessoa[] pessoa;
    }

    public class DocumentSendCMP{
        public String id {get; set;}
        public String type {get; set;}
        public String name {get; set;}
        public String status {get; set;}
        public String contentVersionId {get; set;}
        public String url {get; set;}
        public Boolean hasPreview {get; set;}
        public Datetime dataCriacao {get;set;}
        public Boolean isIntegrated {get;set;}
        public String extension {get;set;}
        public String contentType {get;set;}
        public String recordId {get;set;}
    }

    public class DocumentChecklistSendCMP{
        public String id {get; set;}
        public String documentType {get; set;}
        public String required {get; set;}
    }

    public class DocumentPostResponseTO {
        public String idArquivo {get; set;}
        public String idTipoArquivo {get; set;}
        public String desCaminho {get; set;}
        public Boolean snExcluido {get; set;}
        public Date dtExclusao {get; set;}
        public DocumentPostFileTO arquivo {get; set;}
        public Pessoa[] pessoa;
    }


    public class DocumentPostFileTO {
        public String contentDisposition {get; set;}
        public String contentType {get; set;}
        public Integer length {get; set;}
        public String name {get; set;}
        public String fileName {get; set;}
    }

    public class DocumentForSave {
        public String opportunitySfId {get;set;}
        public String originalName {get;set;}
        public String extension {get;set;}
        public String url {get;set;}
        public String objectType {get;set;}
        public String externalReferenceId {get;set;}
        public String documentTypeExternalId {get;set;}
    }

    public class RelateExistingDocument {
        @AuraEnabled public String recordId {get;set;}
        @AuraEnabled public String objectName {get;set;}
    }
}