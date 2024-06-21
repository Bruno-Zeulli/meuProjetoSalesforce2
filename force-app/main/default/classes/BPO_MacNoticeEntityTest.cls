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
public class BPO_MacNoticeEntityTest {
    static void instanciarClasse(){
        // InputCreate
        BPO_MacNoticeEntity.InputCreate reqCreate = new BPO_MacNoticeEntity.InputCreate();
        reqCreate.COMUNICADO = 123456L;
        reqCreate.NUMCONTRATOCEF = 123456L;
        reqCreate.CPFCNPJSINISTRADO = 123456L;
        reqCreate.NOMESINISTRADO = 'Teste';
        reqCreate.DATAOCORRENCIA = 'Teste';
        reqCreate.NUMAGCONT = 1;
        reqCreate.IDCOBERTURA = 1;
        reqCreate.IDTIPOSINISTRO = 1;
        reqCreate.IDCAUSA = 1;
        reqCreate.DESCRICAOCAUSAEVENTO = 'Teste';
        reqCreate.IDHORAVISTORIA = 'Teste';
        reqCreate.VISTORIACEP = 123456L;
        reqCreate.VISTORIAENDERECO = 'Teste';
        reqCreate.VISTORIABAIRRO = 'Teste';
        reqCreate.VISTORIACIDADE = 'Teste';
        reqCreate.VISTORIAUF = 'Teste';
        reqCreate.VISTORIAREF = 'Teste';
        reqCreate.VISTORIAOBS = 'Teste';
        reqCreate.IDPARENTESCOCOM = 1;
        reqCreate.CPFCNPJCOMUNICANTE = 123456L;
        reqCreate.NOMECOMUNICANTE = 'Teste';
        reqCreate.FONERESIDENCIALCOM = 123456L;
        reqCreate.FONECELULARCOM = 123456L;
        reqCreate.FONECOMERCIALCOM = 123456L;
        reqCreate.EMAILPESCOMUNICANTE = 'Teste';
        reqCreate.EMAILCOMCOMUNICANTE = 'Teste';
        reqCreate.CEPCOMUNICANTE = 123456L;
        reqCreate.ENDERECOCOMUNICANTE = 'Teste';
        reqCreate.BAIRROCOMUNICANTE = 'Teste';
        reqCreate.CIDADECOMUNICANTE = 'Teste';
        reqCreate.UFCOMUNICANTE = 'Teste';
        reqCreate.COMUNICANTECONTATOSAOMESMO = 1;
        reqCreate.IDPARENTESCOCONT = 1;
        reqCreate.CPFCNPJCONTATO = 123456L;
        reqCreate.NOMECONTATO = 'Teste';
        reqCreate.MELHORFORMACOM1 = 'Teste';
        reqCreate.MELHORFORMACOM2 = 'Teste';
        reqCreate.MELHORFORMACOM3 = 'Teste';
        reqCreate.FONEPRINCIPALCONT = 1;
        reqCreate.FONERESIDENCIALCONT = 123456L;
        reqCreate.FONECELULARCONT = 123456L;
        reqCreate.FONECOMERCIALCONT = 123456L;
        reqCreate.EMAILPESCONTATO = 'Teste';
        reqCreate.EMAILCOMCONTATO = 'Teste';
        reqCreate.CEPCONTATO = 123456L;
        reqCreate.ENDERECOCONTATO = 'Teste';
        reqCreate.BAIRROCONTATO = 'Teste';
        reqCreate.CIDADECONTATO = 'Teste';
        reqCreate.UFCONTATO = 'Teste';
        reqCreate.TIPOORIG = 6;
        reqCreate.MATRICULA = 'Teste';
        reqCreate.NOMEORIG = 'Teste';
        reqCreate.EMAILORIG = 'Teste';
        reqCreate.OBSATENDIMENTO = 'Teste';
        reqCreate.NUMFILA = 'Teste';
        reqCreate.valoR_ORC_COMUNIC = 2;
        // InputMacCreate

        BPO_MacNoticeEntity.InputMacCreate reqMACCreate = new BPO_MacNoticeEntity.InputMacCreate();
        reqMACCreate.CODSF = '00199999999AAA';
        reqMACCreate.NUMCONTRATOCEF = 123456L;
        reqMACCreate.CPFCNPJSINISTRADO = '123456';
        reqMACCreate.NOMESINISTRADO = 'Teste';
        reqMACCreate.DATAOCORRENCIA = 'Teste';
        reqMACCreate.IDCOBERTURA = 1;
        reqMACCreate.IDTIPOSINISTRO = 1;
        reqMACCreate.IDCAUSA = 1;
        reqMACCreate.DESCRICAOCAUSAEVENTO = 'Teste';
        reqMACCreate.IDHORAVISTORIA = 'Teste';
        reqMACCreate.VISTORIACEP = 123456L;
        reqMACCreate.VISTORIAENDERECO = 'Teste';
        reqMACCreate.VISTORIABAIRRO = 'Teste';
        reqMACCreate.VISTORIACIDADE = 'Teste';
        reqMACCreate.VISTORIAUF = 'Teste';
        reqMACCreate.VISTORIAREF = 'Teste';
        reqMACCreate.VISTORIAOBS = 'Teste';
        reqMACCreate.IDPARENTESCOCOM = 1;
        reqMACCreate.CPFCNPJCOMUNICANTE = '123456';
        reqMACCreate.NOMECOMUNICANTE = 'Teste';
        reqMACCreate.FONERESIDENCIALCOM = 123456L;
        reqMACCreate.FONECELULARCOM = 123456L;
        reqMACCreate.FONECOMERCIALCOM = 123456L;
        reqMACCreate.EMAILPESCOMUNICANTE = 'Teste';
        reqMACCreate.EMAILCOMCOMUNICANTE = 'Teste';
        reqMACCreate.CEPCOMUNICANTE = 123456L;
        reqMACCreate.ENDERECOCOMUNICANTE = 'Teste';
        reqMACCreate.BAIRROCOMUNICANTE = 'Teste';
        reqMACCreate.CIDADECOMUNICANTE = 'Teste';
        reqMACCreate.UFCOMUNICANTE = 'Teste';
        reqMACCreate.COMUNICANTECONTATOSAOMESMO = 1;
        reqMACCreate.IDPARENTESCOCONT = 1;
        reqMACCreate.CPFCNPJCONTATO = '123456';
        reqMACCreate.NOMECONTATO = 'Teste';
        reqMACCreate.MELHORFORMACOM1 = 'Teste';
        reqMACCreate.MELHORFORMACOM2 = 'Teste';
        reqMACCreate.MELHORFORMACOM3 = 'Teste';
        reqMACCreate.FONEPRINCIPALCONT = 1;
        reqMACCreate.FONERESIDENCIALCONT = 123456L;
        reqMACCreate.FONECELULARCONT = 123456L;
        reqMACCreate.FONECOMERCIALCONT = 123456L;
        reqMACCreate.EMAILPESCONTATO = 'Teste';
        reqMACCreate.EMAILCOMCONTATO = 'Teste';
        reqMACCreate.CEPCONTATO = 123456L;
        reqMACCreate.ENDERECOCONTATO = 'Teste';
        reqMACCreate.BAIRROCONTATO = 'Teste';
        reqMACCreate.CIDADECONTATO = 'Teste';
        reqMACCreate.UFCONTATO = 'Teste';
        reqMACCreate.TIPOORIG = 6;
        reqMACCreate.MATRICULA = 'Teste';
        reqMACCreate.NOMEORIG = 'Teste';
        reqMACCreate.EMAILORIG = 'Teste';
        reqMACCreate.OBSATENDIMENTO = 'Teste';
        reqMacCreate.valoR_ORC_COMUNIC = 1;

        // InputUpdate
        BPO_MacNoticeEntity.InputUpdate reqUpdate = new BPO_MacNoticeEntity.InputUpdate();

        reqUpdate.COMUNICADO = 123456L;
        reqUpdate.COMUNICADORA = 'Teste';
        reqUpdate.CODSF = '00199999999AAA';
        reqUpdate.NUMPROTOCOLO = 123456L;
        reqUpdate.NUMSINISTRO = 123456L;
        reqUpdate.CPFCNPJSINISTRADO = 123456L;
        reqUpdate.NOMESINISTRADO = 'Teste';
        reqUpdate.DATAOCORRENCIA = 'Teste';
        reqUpdate.DATAVISTORIA = 'Teste';
        reqUpdate.HORAVISTORIA = 'Teste';
        reqUpdate.TIPOSINISTRO = 1;
        reqUpdate.NUMCONTRATOCEF = 123567;
        reqUpdate.NUMAGCONT = 2;
        reqUpdate.DESATIVIDADE = 'Teste';
        reqUpdate.NUMFILA = 'Teste';

        // InputTask
        BPO_MacNoticeEntity.InputTask reqTask = new BPO_MacNoticeEntity.InputTask();

        reqTask.COMUNICADO = 123456L;
        reqTask.CODSF = '00199999999AAA';
        reqTask.DATACONTATO = DateUtil.datetimeToString(Datetime.now());
        reqTask.RECLAMANTE = 'Teste';
        reqTask.DATAHORACONTATO = DateUtil.datetimeToString(Datetime.now());
        reqTask.NOMEOPERADOR = 'Teste';
        reqTask.TABULACAO = 'Teste';
        reqTask.DESATIVIDADE = 'Teste';

        // InputTed
        BPO_MacNoticeEntity.InputTed reqTed = new BPO_MacNoticeEntity.InputTed();

        reqTed.COMUNICADO = 123456L;
        reqTed.COMUNICADORA = 'Teste';
        reqTed.CODSF = '00199999999AAA';
        reqTed.DATATED = 'Teste';
        reqTed.TPTED = 1;
        reqTed.DOCTEDPEND = 'Certidão de óbito;Comprovante de Residência';
        reqTed.DOCTEDREC = 'Procuração;Termo de Curatela';
        reqTed.NUMFILA = 'Teste';

        // InputParecer
        BPO_MacNoticeEntity.InputParecer reqParecer = new BPO_MacNoticeEntity.InputParecer();

        reqParecer.COMUNICADO = 123456L;
        reqParecer.COMUNICADORA = 'Teste';
        reqParecer.CODSF = 'asdfasdf';
        reqParecer.RESULTADOSINISTRO = 0;
        reqParecer.TIPOSINISTRO = 1;
        reqParecer.DESCRICAO = 'Teste';
        reqParecer.SEQPAGAMENTO = 12345;
        reqParecer.DATAPAGAMENTO = 'Teste';
        reqParecer.valorIndenizado = 150.00;
        reqParecer.dataInicioPagEncargo = 'Teste';
        reqParecer.dataFimPagEncargo = 'Teste';
        reqParecer.valorParcelaEncargo = 350.00;
        reqParecer.DATAPARCELAENCARGO = 'Teste';
        reqParecer.PERCENTUALSINISTRADO = 50.00;
        reqParecer.NUMFILA = '6';

        // Response
        BPO_MacNoticeEntity.Response resp = new BPO_MacNoticeEntity.Response();
        resp.CODSF = '00199999999AAA';
        resp.MSGERRO = 'Teste';
        resp.SUCESSO = false;

        BPO_MacNoticeEntity.ResponseMAC respMAC = new BPO_MacNoticeEntity.ResponseMAC();
        respMAC.codigo = '00199999999AAA';
        respMAC.CODSQL = 1;
        respMAC.mensagem = 'tsetes';
        respMAC.status = 'false';
        respMAC.idComunicado = 'MAC_1';

        BPO_MacNoticeEntity.mapearFilaWorkflow('1');
        BPO_MacNoticeEntity.mapearMacroStatus('1');
    }
}