@isTest
public class ConnectWizCMPTOTest 
{
	@isTest
    static void cmpto()
    {
         ConnectWizCMPTO.Proposta proposta = new ConnectWizCMPTO.Proposta();
        proposta.seguradora = 'Argo';
        proposta.premio = '20';
        proposta.importanciaSegurada = '10';
        proposta.dataDeEnvioParaSeguradora = '2050-12-11';
        proposta.dataDeRecebimentoDaSeguradora = '2050-12-22';
        proposta.isValorDetalhado = true;
        proposta.isAddValorImportancia = true;
        proposta.valorLiquidoPremio = '10';
        proposta.valorIOFPremio = '10';
        proposta.importanciaSeguradaAdicional = '10';
        proposta.importanciaSeguradaAdicional2 = '10';
        proposta.porcentagemComissao = '1';
        proposta.porcentagemAgenciamento = '1';
        
         ConnectWizCMPTO.QuotesRequestsSendCMP qrs = new ConnectWizCMPTO.QuotesRequestsSendCMP();
        qrs.caseId  = null;
        qrs.ownerId = null;
        qrs.ownerName = null;
        qrs.opportunityId = null;
        qrs.opportunityOwner = null;
        qrs.opportunityNumber = null;
        qrs.accountId = null;
        qrs.accountName = null;
        qrs.accountIdentificationNumber = null;
        qrs.originCase = null;
        qrs.statusCase = null;
        qrs.createDate = null;
        qrs.strCreateDate = null;
        qrs.lastModifiedDate = null;
        qrs.lastModifiedName = null;
        qrs.quantityQuoteRequest = null;
        qrs.quantityQuoteReceipt = null;
        qrs.quantityRequestInsideSLA = null;
        qrs.quantityRequestOutsideSLA = null;
        
         ConnectWizCMPTO.CaseInformationHeader cih = new ConnectWizCMPTO.CaseInformationHeader();
        cih.accountName = null;
        cih.OwnerName = null;
        cih.identificationNumber = null;
        cih.CaseOrigin = null;
        cih.opportunityNumber = null;
        cih.OpportunityId = null;
        cih.contactOrLeadId = null;
        cih.accountId = null;
        cih.productName = null;
        cih.hasForm = true;
        
         ConnectWizCMPTO.ContactDetail contactResponse = new ConnectWizCMPTO.ContactDetail();
            contactResponse.showDetails = false;
            contactResponse.moduloCliente = 'Não informado';
            contactResponse.telefone = 'Não informado';
            contactResponse.celular = 'Não informado';
            contactResponse.nome = 'Não informado';
            contactResponse.email = 'Não informado';
            contactResponse.cargo = 'Não informado';
            contactResponse.dataDeNascimento = 'Não informado';
            contactResponse.timeDoCoracao = 'Não informado';
            contactResponse.ordem = '1';
        
        ConnectWizCMPTO.UsersInformationSendCMP us = new ConnectWizCMPTO.UsersInformationSendCMP();
        us.Id = null;
        us.userName = 'Teste';
        
        ConnectWizCMPTO.quote quote = new ConnectWizCMPTO.quote();
        quote.quoteRequestDate = null;
        quote.quoteReceiptDate = null;
       quote.insuranceCompany = 'Teste';
        
        ConnectWizCMPTO.Product prod = new ConnectWizCMPTO.Product();
        prod.productId = null;
        prod.productName = null;
       prod.productFamily = 'Teste';
    }
}