/**
 * @description       :
 * @author            : Windson Santos
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
@isTest
public class BPO_IncidentNoticeSipreTest {
    @isTest
    public static void instanciarClasse(){
        BPO_IncidentNoticeSipre comunicado = new BPO_IncidentNoticeSipre();
        BPO_IncidentNoticeSipre.EstruturaContrato contrato = new BPO_IncidentNoticeSipre.EstruturaContrato();

        comunicado.Segurado = new BPO_IncidentNoticeSipre.EstruturaSegurado();
        comunicado.Reclamante = new BPO_IncidentNoticeSipre.EstruturaReclamante();
        comunicado.Endereco = new BPO_IncidentNoticeSipre.EstruturaEndereco();

        contrato.Apolice = 'Teste';
        contrato.Certificado = 'Teste';
        contrato.Status = 'Teste';
        contrato.InicioVigencia = 'Teste';
        contrato.FimVigencia = 'Teste';
        contrato.ValorSegurado = 'Teste';
        contrato.TipoBeneficiario = 'Teste';
        contrato.PerceitualPagoBeneficiario = 'Teste';

        System.assertEquals('Teste', contrato.Apolice, 'Apolice it is not the same');
        System.assertEquals('Teste', contrato.Certificado, 'Certificado it is not the same');
        System.assertEquals('Teste', contrato.Status, 'Status it is not the same');
        System.assertEquals('Teste', contrato.InicioVigencia, 'Inicio da Vigência it is not the same');
        System.assertEquals('Teste', contrato.FimVigencia, 'Fim da Vigência it is not the same');
        System.assertEquals('Teste', contrato.ValorSegurado, 'Valor Segurado it is not the same');
        System.assertEquals('Teste', contrato.TipoBeneficiario, 'Tipo Beneficiário it is not the same');
        System.assertEquals('Teste', contrato.PerceitualPagoBeneficiario, 'Perceitual pago ao Beneficiário it is not the same');

        comunicado.ProtocoloSF = 'Teste';
        comunicado.Segurado.Cpfcnpj = 'Teste';
        comunicado.Segurado.Nome = 'Teste';
        comunicado.Segurado.Sexo = 1;
        comunicado.Segurado.DataNascimento = 'Teste';
        comunicado.Segurado.TipoInclusao = 1;
        comunicado.Segurado.Usuario = 'Teste';
        comunicado.Reclamante.Cpf = 'Teste';
        comunicado.Reclamante.Nome = 'Teste';
        comunicado.Reclamante.Parentesco = 1;
        comunicado.Reclamante.NomeAgente = 'Teste';
        comunicado.Reclamante.Email = 'Teste';
        comunicado.Reclamante.Email1 = 'Teste';
        comunicado.Reclamante.TelResidencial = 'Teste';
        comunicado.Reclamante.TelComercial = 'Teste';
        comunicado.Reclamante.Celular = 'Teste';
        comunicado.Endereco.Descricao = 'Teste';
        comunicado.Endereco.Bairro = 'Teste';
        comunicado.Endereco.Cidade = 'Teste';
        comunicado.Endereco.UF = 'Teste';
        comunicado.Endereco.CEP = 'Teste';
        comunicado.Contratos = new List<BPO_IncidentNoticeSipre.EstruturaContrato>();
        comunicado.Contratos.add(contrato);
        comunicado.TipoDemanda = 'Teste';
        comunicado.Flag = 'Teste';
        comunicado.DataComunicado = 'Teste';
        comunicado.DataSinistro = 'Teste';
        comunicado.TipoSinistro = 1;
        comunicado.HistoricoSinistro = 'Teste';

        System.assertEquals('Teste', comunicado.ProtocoloSF, 'Numero Protocolo SF it is not the same');
        System.assertEquals('Teste', comunicado.Segurado.Cpfcnpj, 'CNPJ ou CPF do Segurado it is not the same');
        System.assertEquals('Teste', comunicado.Segurado.Nome, 'Nome do segurado it is not the same');
        System.assertEquals(1, comunicado.Segurado.Sexo, 'Sexo do segurado it is not the same');
        System.assertEquals('Teste', comunicado.Segurado.DataNascimento, 'Data de nascimento do segurado it is not the same');
        System.assertEquals(1, comunicado.Segurado.TipoInclusao, 'Campo tipo de inclusão do segurado it is not the same');
        System.assertEquals('Teste', comunicado.Segurado.Usuario, 'Campo usuário do segurado it is not the same');
        System.assertEquals('Teste', comunicado.Reclamante.Cpf, 'CPF do reclamante it is not the same');
        System.assertEquals('Teste', comunicado.Reclamante.Nome, 'Nome do reclamante it is not the same');
        System.assertEquals(1, comunicado.Reclamante.Parentesco, 'Parentesco do reclamante it is not the same');
        System.assertEquals('Teste', comunicado.Reclamante.NomeAgente, 'Campo NomeAgente it is not the same');
        System.assertEquals('Teste', comunicado.Reclamante.Email, 'Email do reclamante it is not the same');
        System.assertEquals('Teste', comunicado.Reclamante.Email1, 'Email1 do reclamante it is not the same');
        System.assertEquals('Teste', comunicado.Reclamante.TelResidencial, 'Telefone residencial do reclamante it is not the same');
        System.assertEquals('Teste', comunicado.Reclamante.TelComercial, 'Telefone Comercial do reclamante it is not the same');
        System.assertEquals('Teste', comunicado.Reclamante.Celular, 'Celular do reclamante it is not the same');
        System.assertEquals('Teste', comunicado.Endereco.Descricao, 'Descrição do endereço it is not the same');
        System.assertEquals('Teste', comunicado.Endereco.Bairro, 'Bairro do endereço it is not the same');
        System.assertEquals('Teste', comunicado.Endereco.Cidade, 'Cidade do endereço it is not the same');
        System.assertEquals('Teste', comunicado.Endereco.UF, 'Uf do endereço it is not the same');
        System.assertEquals('Teste', comunicado.Endereco.CEP, 'CEP do endereço it is not the same');
        System.assertEquals('Teste', comunicado.TipoDemanda, 'Campo tipo de demanda it is not the same');
        System.assertEquals('Teste', comunicado.Flag, 'Flag it is not the same');
        System.assertEquals('Teste', comunicado.DataComunicado, 'Data do comunicado it is not the same');
        System.assertEquals('Teste', comunicado.DataSinistro, 'Data do sinistro it is not the same');
        System.assertEquals(1, comunicado.TipoSinistro, 'Tipo do sinistro it is not the same');
        System.assertEquals('Teste', comunicado.HistoricoSinistro, 'Historico do sinistro it is not the same');
    }
}