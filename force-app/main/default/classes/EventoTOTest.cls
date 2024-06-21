/**
 * @description       :
 * @author            : samuelsirkis@wiz.co
 * @group             :
 * @last modified on  : 11-04-2023
 * @last modified by  : samuelsirkis@wiz.co
**/
@isTest
public class EventoTOTest {

    @isTest
    static void testEventoTO() {
        // Test the Event object
        EventoTO.Event eventObj = new EventoTO.Event();
        eventObj.RecordtypeName = 'Test Event Record Type';
        System.assertEquals('Test Event Record Type', eventObj.RecordtypeName);

        // Test the Lead object
        EventoTO.Lead leadObj = new EventoTO.Lead();
        leadObj.LeadSource = 'Test Lead Source';
        leadObj.RecordTypeId = '001xxxxxxxxxxxxxxx'; // Replace with a valid RecordTypeId
        leadObj.RecordTypeName = 'Test Lead Record Type';
        leadObj.LastName = 'Test Lead LastName';
        System.assertEquals('Test Lead Source', leadObj.LeadSource);
        System.assertEquals('001xxxxxxxxxxxxxxx', leadObj.RecordTypeId);
        System.assertEquals('Test Lead Record Type', leadObj.RecordTypeName);
        System.assertEquals('Test Lead LastName', leadObj.LastName);

        // Test the Task object
        EventoTO.Task taskObj = new EventoTO.Task();
        taskObj.Subject = 'Test Task Subject';
        taskObj.Status = 'Test Status';
        taskObj.Priority = 'High';
        taskObj.RecordTypeId = '002xxxxxxxxxxxxxxx'; // Replace with a valid RecordTypeId
        taskObj.RecordTypeName = 'Test Task Record Type';
        System.assertEquals('Test Task Subject', taskObj.Subject);
        System.assertEquals('Test Status', taskObj.Status);
        System.assertEquals('High', taskObj.Priority);
        System.assertEquals('002xxxxxxxxxxxxxxx', taskObj.RecordTypeId);
        System.assertEquals('Test Task Record Type', taskObj.RecordTypeName);

        // Test the Account object
        EventoTO.Account accountObj = new EventoTO.Account();
        accountObj.LastName = 'Test Account LastName';
        accountObj.RecordtypeId = '003xxxxxxxxxxxxxxx'; // Replace with a valid RecordTypeId
        accountObj.RecordtypeName = 'Test Account Record Type';
        accountObj.IdentificationNumber = '12345';
        System.assertEquals('Test Account LastName', accountObj.LastName);
        System.assertEquals('003xxxxxxxxxxxxxxx', accountObj.RecordtypeId);
        System.assertEquals('Test Account Record Type', accountObj.RecordtypeName);
        System.assertEquals('12345', accountObj.IdentificationNumber);

        // Test the EventoAgro object
        EventoTO.EventoAgro eventoAgroObj = new EventoTO.EventoAgro();
        eventoAgroObj.Origem = 'Test EventoAgro Origem';
        eventoAgroObj.DataEnvio = Datetime.now();
        eventoAgroObj.Evento = 'Test Evento';
        // Test setting other properties...

        // Test the BodyAgro object
        EventoTO.BodyAgro bodyAgroObj = new EventoTO.BodyAgro();
        bodyAgroObj.IdentificadorUnicoInteressado = 'Test Identifier';
        bodyAgroObj.NomeInteressado = 'TESTE';
        bodyAgroObj.Email = 'TESTE';
        bodyAgroObj.Telefone = 'TESTE';
        bodyAgroObj.Endereco = 'TESTE';
        bodyAgroObj.Bairro = 'TESTE';
        bodyAgroObj.CEP  = 'TESTE';
        bodyAgroObj.DataEnvio = 'TESTE';
        bodyAgroObj.UF = 'TESTE';
        bodyAgroObj.Cidade = 'TESTE';
        bodyAgroObj.NumeroCalculoCotacao = 'TESTE';
        bodyAgroObj.NumeroIdentificadorProposta = 'TESTE';
        bodyAgroObj.NumeroIdentificadorApolice = 'TESTE';
        bodyAgroObj.DataHoraCalculo = 'TESTE';
        bodyAgroObj.SituacaoCalculo = 'TESTE';
        bodyAgroObj.DataInicioVigencia = 'TESTE';
        bodyAgroObj.DataFimVigencia = 'TESTE';
        bodyAgroObj.TipoCotacao = 'TESTE';
        bodyAgroObj.CodigoProduto = 'TESTE';
        bodyAgroObj.NomeProdutoCotado = 'TESTE';
        bodyAgroObj.ImportanciaSegurada = 'TESTE';
        bodyAgroObj.TotalImposto = 'TESTE';
        bodyAgroObj.ValorCotacao = 'TESTE';
        bodyAgroObj.PremioBruto = 'TESTE';
        bodyAgroObj.EnderecoIP = 'TESTE';
        bodyAgroObj.CodigoFuncionario = 'TESTE';
        bodyAgroObj.CodigoUnidadeAgenciaCotacao = 'TESTE';
        bodyAgroObj.CodigoEmpresaGestorContrato = 'TESTE';
        bodyAgroObj.CanalVenda = 'TESTE';
        bodyAgroObj.CodigoUnidadeVenda = 'TESTE';
        bodyAgroObj.MotivoDesistencia = 'TESTE';
        // Test setting other properties...

        // Test the InformacaoEspecificaAgro object
        EventoTO.InformacaoEspecificaAgro informacaoAgroObj = new EventoTO.InformacaoEspecificaAgro();
        informacaoAgroObj.AreaTerreno = 'Test Area Terreno';
        informacaoAgroObj.CodigoSifec = 'TESTE';
        informacaoAgroObj.TipoPagamento  = 'TESTE';
        informacaoAgroObj.ObjetivoSolicitacao = 'TESTE';
        informacaoAgroObj.ClassificacaoProduto = 'TESTE';
        informacaoAgroObj.AtividadeRural = 'TESTE';
        informacaoAgroObj.ObjetivoOperacao = 'TESTE';
        informacaoAgroObj.NumeroPropostaCredito = 'TESTE';
        // Test setting other properties...

        // Test the BodySinistro object
        EventoTO.BodySinistro bodySinistroObj = new EventoTO.BodySinistro();
        bodySinistroObj.CdSinistro = 'Test Cd Sinistro';
        bodySinistroObj.DtOcorrenciaSinistro = 'TESTE';
        bodySinistroObj.DtAvisoSeguradora = 'TESTE';
        bodySinistroObj.DtEntradaSinistro = 'TESTE';
        bodySinistroObj.DtCriacaoSinistro = 'TESTE';
        bodySinistroObj.DtModificacaoSinistro = 'TESTE';
        bodySinistroObj.NumContrato = 'TESTE';
        bodySinistroObj.NmOperacao = 'TESTE';
        bodySinistroObj.NmCobertura = 'TESTE';
        bodySinistroObj.NmSeguradora = 'TESTE';
        bodySinistroObj.CnpjSeguradora = 'TESTE';
        bodySinistroObj.NmSegurado = 'TESTE';
        bodySinistroObj.NmSituacao = 'TESTE';
        bodySinistroObj.DsEnderecoSinistro = 'TESTE';
        bodySinistroObj.NmEstadoSinistro = 'TESTE';
        bodySinistroObj.UfSinistro = 'TESTE';
        bodySinistroObj.NmCidadeSinistro = 'TESTE';
        bodySinistroObj.CEPSinistro = 'TESTE';
        bodySinistroObj.NmEnderecoSinistro = 'TESTE';
        bodySinistroObj.NmBairroSinistro = 'TESTE';
        bodySinistroObj.NumEnderecoSinistro = 'TESTE';
        bodySinistroObj.DsComplementoEnderecoSinistro = 'TESTE';
        bodySinistroObj.DesEnderecoVistoria = 'TESTE';
        bodySinistroObj.NmEstadoVistoria = 'TESTE';
        bodySinistroObj.UfVistoria = 'TESTE';
        bodySinistroObj.NmCidadeVistoria = 'TESTE';
        bodySinistroObj.CEPVistoria = 'TESTE';
        bodySinistroObj.NmEnderecoVistoria = 'TESTE';
        bodySinistroObj.NmBairroVistoria = 'TESTE';
        bodySinistroObj.NumEnderecoVistoria = 'TESTE';
        bodySinistroObj.DsComplementoEnderecoVistoria = 'TESTE';
        bodySinistroObj.TelefoneSegurado = 'TESTE';
        bodySinistroObj.DtInicioVigencia = 'TESTE';
        bodySinistroObj.DtFimVigencia = 'TESTE';
        bodySinistroObj.DtUltimoDocumentoRecebido = 'TESTE';
        bodySinistroObj.EmailSegurado = 'TESTE';
        bodySinistroObj.EmailSolicitanteSinistro = 'TESTE';
        bodySinistroObj.NmRegulador = 'TESTE';
        // Test setting other properties...

        // Test the InformacoesEspecializadas object
        EventoTO.InformacoesEspecializadas informacoesEspecializadasObj = new EventoTO.InformacoesEspecializadas();
        informacoesEspecializadasObj.AreaTerreno = 'Test Area Terreno (InformacoesEspecializadas)';
        // Test setting other properties...

        // Test the Person object
        EventoTO.Person personObj = new EventoTO.Person();
        personObj.fullName = 'John Doe';
        personObj.identifier = 'TESTE';
        personObj.phone = 'TESTE';
        personObj.email = 'TESTE';

        // Test setting other properties...

        // Test the Opportunity object
        EventoTO.Opportunity opportunityObj = new EventoTO.Opportunity();
        opportunityObj.name = 'Test Opportunity';
        opportunityObj.accountId  = 'TESTE';
        opportunityObj.stageName  = 'TESTE';
        opportunityObj.name  = 'TESTE';
        opportunityObj.externalId  = 'TESTE';
        opportunityObj.insuredAmount = 'TESTE';
        // Test setting other properties...

        // Test the Quote object
        EventoTO.Quote quoteObj = new EventoTO.Quote();
        quoteObj.prizeAamount = 100.00;
        quoteObj.opportunityId  = 'TESTE';
        quoteObj.type = 'TESTE';
        quoteObj.externalId = 'TESTE';
        quoteObj.name = 'TESTE';

        // Test setting other properties...
    }
}