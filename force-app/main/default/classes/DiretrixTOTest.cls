@istest
public class DiretrixTOTest {


    @isTest
    static void intantiateDiretrixResponseFindByIndentificationNumber(){
        DiretrixTO.DiretrixResponseFindByIndentificationNumber responseDiretrix = new DiretrixTO.DiretrixResponseFindByIndentificationNumber();

        responseDiretrix.sucesso = true;
        responseDiretrix.msg = 'test';
        responseDiretrix.consulta = getConsulta();

        Integer expected;
        Integer actual;      
        System.assertEquals(expected, actual, 'nothing to expect');        
    }

    @isTest
    static void intantiateDiretrixBodyModel(){
        DiretrixTO.DiretrixBodyModel diretrixBodyModel = new DiretrixTO.DiretrixBodyModel('test','test','test','test','test');

        Integer expected;
        Integer actual;      
        System.assertEquals(expected, actual, 'nothing to expect');        
    }



    static DiretrixTO.Consulta getConsulta(){
        DiretrixTO.Consulta consult = new DiretrixTO.Consulta();
        consult.dadosGerais = getDadosGerais();
        consult.emails = getEmails();
        consult.enderecos = getEnderecos();
        consult.situacaoCadastral = getSituacaoCadastral();
        consult.telefones = getTelefones();

        return consult;        
    }

    static List<DiretrixTO.dadosGerais> getDadosGerais(){

        DiretrixTO.DadosGerais dadosGerais = new DiretrixTO.DadosGerais();
        dadosGerais.CNPJ = 'test';
        dadosGerais.CNPJOK = 'test';
        dadosGerais.RAZAO = 'test';
        dadosGerais.NOME_FANTASIA = 'test';
        dadosGerais.DATA_ABERTURA = 'test';
        dadosGerais.CNAE = 'test';
        dadosGerais.DESCRICAO_CNAE = 'test';
        dadosGerais.SETOR = 'test';
        dadosGerais.PORTE = 'test';
        dadosGerais.QTD_FUNCIONARIOS = 'test';
        dadosGerais.FATURAMENTO_PRESUMIDO_ANUAL = 'test';
        dadosGerais.FATURAMENTO_PRESUMIDO_ANUAL_GRUPO = 'test';
        dadosGerais.NJUR = 'test';
        dadosGerais.MATRIZ = 'test';

        List<DiretrixTO.dadosGerais> lstDadosGerais = new List<DiretrixTO.dadosGerais>();

        lstDadosGerais.add(dadosGerais);

        return lstDadosGerais;        
    }    

    static List<DiretrixTO.Emails> getEmails(){

        DiretrixTO.Emails emails = new DiretrixTO.Emails();
        emails.EMAIL = 'test';
        emails.QUALIFICACAO = 'test';

        List<DiretrixTO.Emails> lstEmails = new List<DiretrixTO.Emails>();

        lstEmails.add(emails);

        return lstEmails;        
    }

    static List<DiretrixTO.SituacaoCadastral> getSituacaoCadastral(){

        DiretrixTO.SituacaoCadastral situacaoCadastral = new DiretrixTO.SituacaoCadastral();

        situacaoCadastral.SITUACAO_CADASTRAL = 'test';
        situacaoCadastral.DIGITO_VERIFICARDOR = 'test';
        situacaoCadastral.DATA = 'test';
        situacaoCadastral.COD_CONTROLE = 'test';

        List<DiretrixTO.SituacaoCadastral> lstSituacaoCadastral = new List<DiretrixTO.SituacaoCadastral>();

        lstSituacaoCadastral.add(situacaoCadastral); 

        return lstSituacaoCadastral;

    }

    static List<DiretrixTO.Enderecos> getEnderecos(){

        DiretrixTO.Enderecos enderecos = new DiretrixTO.Enderecos();

        enderecos.ENDERECO = 'test';
        enderecos.TIPO_LOGRADOURO = 'test';
        enderecos.TITULO_LOGRADOURO = 'test';
        enderecos.LOGRADOURO = 'test';
        enderecos.NUMERO = 'test';
        enderecos.COMPLEMENTO = 'test';
        enderecos.BAIRRO = 'test';
        enderecos.CIDADE = 'test';
        enderecos.UF = 'test';
        enderecos.CEP = 'test';
        enderecos.CEPOK = 'test';
        enderecos.QUALIFICACAO = 'test';

        List<DiretrixTO.Enderecos> lstEnderecos = new List<DiretrixTO.Enderecos>();

        lstEnderecos.add(enderecos); 

        return lstEnderecos;

    }

    static List<DiretrixTO.Telefones> getTelefones(){

        DiretrixTO.Telefones telefones = new DiretrixTO.Telefones();

        telefones.DDD = 'test';
        telefones.TELEFONE = 'test';
        telefones.TELEFONEOK = 'test';
        telefones.TIPO_TELEFONE = 'test';
        telefones.QUALIFICACAO = 'test';

        List<DiretrixTO.Telefones> lstTelefones = new List<DiretrixTO.Telefones>();

        lstTelefones.add(telefones); 

        return lstTelefones;

    }

}