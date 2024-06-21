/**
 * @description       :
 * @author            : marcelomartins@wizsolucoes.com.br
 * @group             :
 * @last modified on  : 11-25-2021
 * @last modified by  : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   11-25-2021   marcelomartins@wizsolucoes.com.br   Initial Version
 **/
@isTest
public class DocumentTOTest {

    @isTest
    static void instantiateDocumentTO(){
        DocumentTO documentTO = new DocumentTO();
        documentTO.name = 'test';
        documentTO.documentId = '123L';
        documentTO.contentVersionId = '123L';
        documentTO.tipoDocumento = '123L';
        documentTO.path = '123L';
        documentTO.url = '123L';
        documentTO.isOpportunityOFCorporate =false;

        Integer expected ;
        Integer actual;
        System.assertEquals(expected, actual, 'nothing to expect');
    }

    @isTest
    static void instantiateDocumentTypeGetResponse(){
        DocumentTO.DocumentTypeGetResponse documentTypeGetResponse = new DocumentTO.DocumentTypeGetResponse();
        documentTypeGetResponse.idTipoArquivo = '123L';
        documentTypeGetResponse.descricaoTipoArquivo = 'test';

        Integer expected ;
        Integer actual;
        System.assertEquals(expected, actual, 'nothing to expect');
    }

    @isTest
    static void instantiatePessoa(){
        DocumentTO.Pessoa pessoa = new DocumentTO.Pessoa();
        pessoa.documento = 'test';
        pessoa.tipoPessoa = 'test';
        pessoa.desCaminho = 'test';

        Integer expected ;
        Integer actual;
        System.assertEquals(expected, actual, 'nothing to expect');

    }

    @isTest
    static void instantiateDocumentGetResponse(){
        DocumentTO.DocumentGetResponse documentGetResponse = new DocumentTO.DocumentGetResponse();
        documentGetResponse.idArquivo = 'test';
        documentGetResponse.idTipoArquivo = 'test';
        documentGetResponse.documento = 'test';
        documentGetResponse.desCaminho = 'test';
        documentGetResponse.desCpf = 'test';
        documentGetResponse.urlBlob = 'test';
        documentGetResponse.base64 = 'test';
        documentGetResponse.isExcluido = 'test';
        documentGetResponse.dtExclusao = 'test';
        documentGetResponse.tenant = 'test';
        documentGetResponse.pessoa = getPessoa();

        Integer expected ;
        Integer actual;
        System.assertEquals(expected, actual, 'nothing to expect');

    }
    @isTest
    static void instantiateDocumentSendCMP(){
        DocumentTO.DocumentSendCMP documentSendCMP = new DocumentTO.DocumentSendCMP();
        documentSendCMP.id = 'test';
        documentSendCMP.type = 'test';
        documentSendCMP.name = 'test';
        documentSendCMP.status = 'test';
        documentSendCMP.contentVersionId = 'test';
        documentSendCMP.url = 'test';
        documentSendCMP.hasPreview = true;
        documentSendCMP.contentType = 'test';
        documentSendCMP.extension = 'test';
        documentSendCMP.isIntegrated = false;

        Integer expected ;
        Integer actual;
        System.assertEquals(expected, actual, 'nothing to expect');
    }
    @isTest
    static void instantiateDocumentChecklistSendCMP(){
        DocumentTO.DocumentChecklistSendCMP documentChecklistSendCMP = new DocumentTO.DocumentChecklistSendCMP();
        documentChecklistSendCMP.id = 'test';
        documentChecklistSendCMP.documentType = 'test';
        documentChecklistSendCMP.required = 'test';

        Integer expected ;
        Integer actual;
        System.assertEquals(expected, actual, 'nothing to expect');
    }
    @isTest
    static void instantiateDocumentPostResponseTO(){
        DocumentTO.DocumentPostResponseTO documentPostResponseTO = new DocumentTO.DocumentPostResponseTO();
        documentPostResponseTO.idArquivo = 'test';
        documentPostResponseTO.idTipoArquivo = 'test';
        documentPostResponseTO.desCaminho = 'test';
        documentPostResponseTO.snExcluido = true;
        documentPostResponseTO.dtExclusao = Date.today();
        documentPostResponseTO.arquivo = new DocumentTO.DocumentPostFileTO();
        documentPostResponseTO.arquivo.name = 'test';
        documentPostResponseTO.pessoa = getPessoa();

        Integer expected ;
        Integer actual;
        System.assertEquals(expected, actual, 'nothing to expect');
    }

    @isTest
    static List<DocumentTO.Pessoa> getPessoa(){
        DocumentTO.Pessoa pessoa = new DocumentTO.Pessoa();
        pessoa.documento = 'test';
        pessoa.tipoPessoa = 'test';
        pessoa.desCaminho = 'test';

        List<DocumentTO.Pessoa> lstPessoa = new List<DocumentTO.Pessoa>();
        lstPessoa.add(pessoa);

        return lstPessoa;
    }

}