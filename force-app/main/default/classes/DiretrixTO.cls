@SuppressWarnings('PMD')
public without sharing class DiretrixTO {

    public class DiretrixResponseFindByIndentificationNumber {
        public Boolean sucesso {get; set;}
        public String msg {get; set;}
        public Consulta consulta {get; set;}        
    }
    
    public class Consulta{
        public DadosGerais[] dadosGerais;
        public SituacaoCadastral[] situacaoCadastral;
        public Enderecos[] enderecos;
        public Telefones[] telefones;
        public Emails[] emails;
    }
    
    public DadosGerais[] dadosGerais;
    public class DadosGerais{
        public String CNPJ {get; set;}
        public String CNPJOK {get; set;}
        public String RAZAO {get; set;}
        public String NOME_FANTASIA {get; set;}
        public String DATA_ABERTURA {get; set;}
        public String CNAE {get; set;}
        public String DESCRICAO_CNAE {get; set;}
        public String SETOR {get; set;}
        public String PORTE {get; set;}
        public String QTD_FUNCIONARIOS {get; set;}
        public String FATURAMENTO_PRESUMIDO_ANUAL {get; set;}
        public String FATURAMENTO_PRESUMIDO_ANUAL_GRUPO {get; set;}
        public String NJUR {get; set;}
        public String MATRIZ {get; set;}
    }

    public SituacaoCadastral[] situacaoCadastral;
    public class SituacaoCadastral{
        public String SITUACAO_CADASTRAL {get; set;}
        public String DIGITO_VERIFICARDOR {get; set;}
        public String DATA {get; set;}
        public String COD_CONTROLE {get; set;}
    }

    public MatrizFiliais[] matrizFiliais;
    public class MatrizFiliais{

    }

    public Enderecos[] enderecos;
    public class Enderecos{
        public String ENDERECO {get; set;}
        public String TIPO_LOGRADOURO {get; set;}
        public String TITULO_LOGRADOURO {get; set;}
        public String LOGRADOURO {get; set;}
        public String NUMERO {get; set;}
        public String COMPLEMENTO {get; set;}
        public String BAIRRO {get; set;}
        public String CIDADE {get; set;}
        public String UF {get; set;}
        public String CEP {get; set;}
        public String CEPOK {get; set;}
        public String QUALIFICACAO {get; set;}
    }

    public Telefones[] telefones;
    public class Telefones{
        public String DDD {get; set;}
        public String TELEFONE {get; set;}
        public String TELEFONEOK {get; set;}
        public String TIPO_TELEFONE {get; set;}
        public String QUALIFICACAO {get; set;}
    }
    
    public Emails[] emails;
    public class Emails{
        public String EMAIL {get; set;}
        public String QUALIFICACAO {get; set;}
    }

    

    public class DiretrixBodyModel{
        public Login login;
        public Parametros parametros;

        public DiretrixBodyModel(String usuario, String senha, String cliente, String cnpj, String idProduto){
            this.login = new Login(usuario, senha, cliente);
            this.parametros = new Parametros(cnpj, idProduto);
        }
        
    }

    public class Login {
        public String usuario;
        public String senha;
        public String cliente;

        public Login(String usuario, String senha, String cliente){
            this.usuario = usuario;
            this.senha = senha;
            this.cliente = cliente;
        }
    }

    public class Parametros {
        public String cnpj;
        public String idProduto;
        public Parametros(String cnpj, String idProduto){
            this.cnpj = cnpj;
            this.idProduto = idProduto;
        }
    }
}