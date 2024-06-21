public with sharing class EventoTO {
    public class Event {
        public String RecordtypeName { get; set; }
    }

    public class Lead {
        public String LeadSource { get; set; }
        public String RecordTypeId { get; set; }
        public String RecordTypeName { get; set; }
        public String LastName { get; set; }
    }

    public class Task {
        public String Subject { get; set; }
        public String Status { get; set; }
        public String Priority { get; set; }
        public String RecordTypeId { get; set; }
        public String RecordTypeName { get; set; }
    }

    public class Account {
        public String LastName { get; set; }
        public String RecordtypeId { get; set; }
        public String RecordtypeName { get; set; }
        public String IdentificationNumber { get; set; }
    }

    public class EventoAgro {
        public String Origem { get; set; }
        public Datetime DataEnvio { get; set; }
        public String Evento { get; set; }
        public List<BodyAgro> Registros {get;set;}
    }

    public class BodyAgro {
        public String IdentificadorUnicoInteressado { get; set; }
        public String NomeInteressado { get; set; }
        public String Telefone { get; set; }
        public String Email { get; set; }
        public String Endereco { get; set; }
        public String Bairro { get; set; }
        public String CEP { get; set; }
        public String DataEnvio { get; set; }
        public String UF { get; set; }
        public String Cidade { get; set; }
        public String NumeroCalculoCotacao { get; set; }
        public String NumeroIdentificadorProposta { get; set; }
        public String NumeroIdentificadorApolice { get; set; }
        public String DataHoraCalculo { get; set; }
        public String SituacaoCalculo { get; set; }
        public String DataInicioVigencia { get; set; }
        public String DataFimVigencia { get; set; }
        public String TipoCotacao { get; set; }
        public String CodigoProduto { get; set; }
        public String NomeProdutoCotado { get; set; }
        public String ImportanciaSegurada { get; set; }
        public String TotalImposto { get; set; }
        public String ValorCotacao { get; set; }
        public String PremioBruto { get; set; }
        public String EnderecoIP { get; set; }
        public String CodigoFuncionario { get; set; }
        public String CodigoUnidadeAgenciaCotacao { get; set; }
        public String CodigoEmpresaGestorContrato { get; set; }
        public String CanalVenda { get; set; }
        public String CodigoUnidadeVenda { get; set; }
        public String MotivoDesistencia { get; set; }
        public InformacaoEspecificaAgro InformacoesEspecializadas { get; set; }
    }


    public class InformacaoEspecificaAgro {
        public String AreaTerreno { get; set; }
        public String CodigoSifec { get; set; }
        public String TipoPagamento { get; set; }
        public String ObjetivoSolicitacao { get; set; }
        public String ClassificacaoProduto { get; set; }
        public String AtividadeRural { get; set; }
        public String ObjetivoOperacao { get; set; }
        public String NumeroPropostaCredito { get; set; }
    }

	public class BodySinistro {
        public String CdSinistro {get;set;}
        public String DtOcorrenciaSinistro {get;set;}
        public String DtAvisoSeguradora {get;set;}
        public String DtEntradaSinistro {get;set;}
        public String DtCriacaoSinistro {get;set;}
        public String DtModificacaoSinistro {get;set;}
        public String NumContrato {get;set;}
        public Integer NumOperacao {get;set;}
        public String NmOperacao {get;set;}
        public Integer NumCobertura {get;set;}
        public String NmCobertura {get;set;}
        public String NmSeguradora {get;set;}
        public Integer IdSeguradora {get;set;}
        public String CnpjSeguradora {get;set;}
        public String NmSegurado {get;set;}
        public Object NumCorretor {get;set;}
        public Object NmCorretor {get;set;}
        public Integer NumSituacao {get;set;}
        public String NmSituacao {get;set;}
        public Object DtConclusaoVistoria {get;set;}
        public String DsEnderecoSinistro {get;set;}
        public String NmEstadoSinistro {get;set;}
        public String UfSinistro {get;set;}
        public String NmCidadeSinistro {get;set;}
        public String CEPSinistro {get;set;}
        public String NmEnderecoSinistro {get;set;}
        public String NmBairroSinistro {get;set;}
        public String NumEnderecoSinistro {get;set;}
        public String DsComplementoEnderecoSinistro {get;set;}
        public Object DsAdicionalEnderecoSinistro {get;set;}
        public String DesEnderecoVistoria {get;set;}
        public String NmEstadoVistoria {get;set;}
        public String UfVistoria {get;set;}
        public String NmCidadeVistoria {get;set;}
        public String CEPVistoria {get;set;}
        public String NmEnderecoVistoria {get;set;}
        public String NmBairroVistoria {get;set;}
        public String NumEnderecoVistoria {get;set;}
        public String DsComplementoEnderecoVistoria {get;set;}
        public Object DsAdicionalEnderecoVistoria {get;set;}
        public String TelefoneSegurado {get;set;}
        public Integer ValorIndenizacao {get;set;}
        public Integer ValorReclamado {get;set;}
        public String DtInicioVigencia {get;set;}
        public String DtFimVigencia {get;set;}
        public Integer ValorImportanciaSegurada {get;set;}
        public Boolean FlgDocumentosPendentes {get;set;}
        public String DtUltimoDocumentoRecebido {get;set;}
        public String EmailSegurado {get;set;}
        public String EmailSolicitanteSinistro {get;set;}
        public Integer NumRazaoRejeicao {get;set;}
        public String NmRazaoRejeicao {get;set;}
        public Integer IdRegulador {get;set;}
        public String NmRegulador {get;set;}
        public Object AreaTotal {get;set;}
        public Object AreaDeColheita {get;set;}
        public Object PrevisaoColheita {get;set;}
        public Object AgroNomeColheita {get;set;}
    
    }

 

	public class InformacoesEspecializadas {
		public String AreaTerreno { get; set; }
		public String AgroCropArea { get; set; }
	}

    public class Person {
		public List<String> lstSeparateName { get; set; }
        public String fullName { get; set; }
		public String identifier { get; set; }
        public String phone { get; set; }
        public String email { get; set; }
        public Id recordType  { get; set; }
	}

    public class Opportunity {
        public Id recordType  { get; set; }
        public String accountId { get; set; }
        public Date closeDate { get; set; }
        public String stageName {get; set;}
        public String name {get; set;}
        public String externalId {get; set;}
        public String insuredAmount{get; set;}
    }

    public class Quote {
        public Decimal prizeAamount  { get; set; }
        public String opportunityId { get; set; }
        public String type { get; set; }
        public String quotationNumber{get; set;}
        public String externalId {get; set;}
        public String name {get; set;}
        public Id recordType  { get; set; }
    }

}