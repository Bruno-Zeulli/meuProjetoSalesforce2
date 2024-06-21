/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
@isTest
public class MockWebserviceCallsTest {
    public class UnauthorizedEndpointResponse implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request){
            CalloutException e = (CalloutException) CalloutException.class.newInstance();
            e.setMessage('Unauthorized endpoint, please check Setup -> Security -> Remote site settings.');
            throw e;
        }
    }

    public class CallSipreSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            string jsonresponse = '';
            res.setBody(jsonresponse);
            res.setStatusCode(201);
            return res;
        }
    }

    public class CallSipreFailure implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            string jsonresponse = '';
            res.setBody(jsonresponse);
            res.setStatusCode(500);
            return res;
        }
    }

    public class CallTarefasSipreSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            string jsonresponse = '"{\"Result\":[{\"Id\":309012,\"IdCliente\":30718,\"DataTrabalho\":\"2016-03-18T10:43:44.75\",\"IdUsuario\":3380665193,\"IdTarefa\":43,\"Observacao\":\"Mudança de status para encaminhado para arquivo Sit Ant=19 e Sit Atual=20\",\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Ana Machado\",\"Tarefa\":\"Encaminha ao Arquivo\"},{\"Id\":108327,\"IdCliente\":30718,\"DataTrabalho\":\"2015-09-18T14:47:52.822\",\"IdUsuario\":425407128,\"IdTarefa\":25,\"Observacao\":\"Atualização de sistema  Sit Ant=17 e Sit Atual=19\",\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Camila Melo\",\"Tarefa\":\"Altera Situação\"},{\"Id\":108326,\"IdCliente\":30718,\"DataTrabalho\":\"2015-09-18T14:45:31.458\",\"IdUsuario\":425407128,\"IdTarefa\":36,\"Observacao\":null,\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Camila Melo\",\"Tarefa\":\"Cancelamento Benef\"},{\"Id\":108325,\"IdCliente\":30718,\"DataTrabalho\":\"2015-09-18T14:45:31.458\",\"IdUsuario\":99999999999,\"IdTarefa\":25,\"Observacao\":\"ImpCan=> Sit Ant=14 e Sit Atual=17\",\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Rotina Automática\",\"Tarefa\":\"Altera Situação\"},{\"Id\":108324,\"IdCliente\":30718,\"DataTrabalho\":\"2015-09-18T14:45:22.927\",\"IdUsuario\":425407128,\"IdTarefa\":41,\"Observacao\":null,\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Camila Melo\",\"Tarefa\":\"Reiteração Benef 3\"},{\"Id\":108323,\"IdCliente\":30718,\"DataTrabalho\":\"2015-09-18T14:45:22.927\",\"IdUsuario\":99999999999,\"IdTarefa\":25,\"Observacao\":\"ImpReBen=> Sit Ant=13 e Sit Atual=14\",\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Rotina Automática\",\"Tarefa\":\"Altera Situação\"},{\"Id\":108322,\"IdCliente\":30718,\"DataTrabalho\":\"2015-09-18T14:45:07.911\",\"IdUsuario\":425407128,\"IdTarefa\":35,\"Observacao\":null,\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Camila Melo\",\"Tarefa\":\"Reiteração Benef 2\"},{\"Id\":108321,\"IdCliente\":30718,\"DataTrabalho\":\"2015-09-18T14:45:07.895\",\"IdUsuario\":99999999999,\"IdTarefa\":25,\"Observacao\":\"ImpReBen=> Sit Ant=12 e Sit Atual=13\",\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Rotina Automática\",\"Tarefa\":\"Altera Situação\"},{\"Id\":108320,\"IdCliente\":30718,\"DataTrabalho\":\"2015-09-18T14:45:01.098\",\"IdUsuario\":425407128,\"IdTarefa\":34,\"Observacao\":null,\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Camila Melo\",\"Tarefa\":\"Reiteração Benef 1\"},{\"Id\":108319,\"IdCliente\":30718,\"DataTrabalho\":\"2015-09-18T14:45:01.067\",\"IdUsuario\":99999999999,\"IdTarefa\":25,\"Observacao\":\"ImpReBen=> Sit Ant=11 e Sit Atual=12\",\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Rotina Automática\",\"Tarefa\":\"Altera Situação\"},{\"Id\":84433,\"IdCliente\":30718,\"DataTrabalho\":\"2015-07-30T10:16:25.712\",\"IdUsuario\":89940393172,\"IdTarefa\":21,\"Observacao\":null,\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Ana Jesus\",\"Tarefa\":\"Imprime Etiqueta\"},{\"Id\":77389,\"IdCliente\":30718,\"DataTrabalho\":\"2015-07-22T12:13:52.99\",\"IdUsuario\":1545149186,\"IdTarefa\":31,\"Observacao\":null,\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Priscila Pignata - Compline\",\"Tarefa\":\"Solicita documentos beneficiarios\"},{\"Id\":77388,\"IdCliente\":30718,\"DataTrabalho\":\"2015-07-22T12:13:52.974\",\"IdUsuario\":99999999999,\"IdTarefa\":25,\"Observacao\":\"ImSolBen=> Sit Ant=10 e Sit Atual=11\",\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Rotina Automática\",\"Tarefa\":\"Altera Situação\"},{\"Id\":77387,\"IdCliente\":30718,\"DataTrabalho\":\"2015-07-22T12:13:03.612\",\"IdUsuario\":1545149186,\"IdTarefa\":33,\"Observacao\":null,\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Priscila Pignata - Compline\",\"Tarefa\":\"Imprimir TRC\"},{\"Id\":77386,\"IdCliente\":30718,\"DataTrabalho\":\"2015-07-22T12:13:02.08\",\"IdUsuario\":99999999999,\"IdTarefa\":25,\"Observacao\":\"GrPgCX=> Sit Ant=9 e Sit Atual=10\",\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Rotina Automática\",\"Tarefa\":\"Altera Situação\"},{\"Id\":77385,\"IdCliente\":30718,\"DataTrabalho\":\"2015-07-22T12:13:02.033\",\"IdUsuario\":1545149186,\"IdTarefa\":28,\"Observacao\":null,\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Priscila Pignata - Compline\",\"Tarefa\":\"Registra Pagamento CAIXA\"},{\"Id\":77384,\"IdCliente\":30718,\"DataTrabalho\":\"2015-07-22T12:12:52.479\",\"IdUsuario\":99999999999,\"IdTarefa\":25,\"Observacao\":\"GrReg1=> Sit Ant=8 e Sit Atual=9\",\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Rotina Automática\",\"Tarefa\":\"Altera Situação\"},{\"Id\":77383,\"IdCliente\":30718,\"DataTrabalho\":\"2015-07-22T12:12:52.448\",\"IdUsuario\":1545149186,\"IdTarefa\":13,\"Observacao\":\"\",\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Priscila Pignata - Compline\",\"Tarefa\":\"Altera dados Certificado\"},{\"Id\":44935,\"IdCliente\":30718,\"DataTrabalho\":\"2015-05-21T10:28:51.159\",\"IdUsuario\":99435268153,\"IdTarefa\":25,\"Observacao\":\"ATUALIZAÇÃO DE SISTEMA Sit Ant=17 e Sit Atual=8\",\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Jennifer Nascimento\",\"Tarefa\":\"Altera Situação\"},{\"Id\":38526,\"IdCliente\":30718,\"DataTrabalho\":\"2015-05-11T14:30:32.467\",\"IdUsuario\":425407128,\"IdTarefa\":25,\"Observacao\":\"Atualização de sistema  Sit Ant=0 e Sit Atual=17\",\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Camila Melo\",\"Tarefa\":\"Altera Situação\"},{\"Id\":37628,\"IdCliente\":30718,\"DataTrabalho\":\"2015-05-08T15:36:57.184\",\"IdUsuario\":93120443115,\"IdTarefa\":12,\"Observacao\":null,\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Eduardo Araujo\",\"Tarefa\":\"Insere Certificado\"},{\"Id\":37607,\"IdCliente\":30718,\"DataTrabalho\":\"2015-05-08T15:29:50.33\",\"IdUsuario\":93120443115,\"IdTarefa\":14,\"Observacao\":null,\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Eduardo Araujo\",\"Tarefa\":\"Insere Endereço\"},{\"Id\":37605,\"IdCliente\":30718,\"DataTrabalho\":\"2015-05-08T15:28:57.407\",\"IdUsuario\":93120443115,\"IdTarefa\":18,\"Observacao\":null,\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Eduardo Araujo\",\"Tarefa\":\"Incluir Documentos\"},{\"Id\":37603,\"IdCliente\":30718,\"DataTrabalho\":\"2015-05-08T15:28:57.391\",\"IdUsuario\":93120443115,\"IdTarefa\":18,\"Observacao\":null,\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Eduardo Araujo\",\"Tarefa\":\"Incluir Documentos\"},{\"Id\":37604,\"IdCliente\":30718,\"DataTrabalho\":\"2015-05-08T15:28:57.391\",\"IdUsuario\":93120443115,\"IdTarefa\":18,\"Observacao\":null,\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Eduardo Araujo\",\"Tarefa\":\"Incluir Documentos\"},{\"Id\":37600,\"IdCliente\":30718,\"DataTrabalho\":\"2015-05-08T15:28:26.422\",\"IdUsuario\":93120443115,\"IdTarefa\":23,\"Observacao\":null,\"Descricao\":null,\"IdCertificado\":null,\"DataProtocolo\":null,\"IdUsuarioProtocolo\":null,\"FlagProtocolo\":true,\"Usuario\":\"Eduardo Araujo\",\"Tarefa\":\"Inclui Comunicado\"}]}"';
            res.setBody(jsonresponse);
            res.setStatusCode(200);
            return res;
        }
    }

    public class CallGenericSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            string jsonresponse = '';
            res.setBody(jsonresponse);
            res.setStatusCode(201);
            return res;
        }
    }

    public class CallMACSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            BPO_MacCallRest.LoginCredentials lc = new BPO_MacCallRest.LoginCredentials();
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            string jsonresponse = '{"sucesso": true,"Token": "token"}';
            if(req.getEndpoint().contains(BPO_MacCallRest.ENDPOINT_CADASTRAR_COMUNICADO)){
                jsonresponse = '{"status" : null,"mensagem" : null,"idComunicado" : 123456789,"CODSQL" : null,"codigo" : null}';
            }
            res.setBody(jsonresponse);
            res.setStatusCode(201);
            return res;
        }
    }

    public class CallMACFail implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            BPO_MacCallRest.LoginCredentials lc = new BPO_MacCallRest.LoginCredentials();
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            string jsonresponse = '{"sucesso": false,"Token": "token"}';
            if(req.getEndpoint().contains(BPO_MacCallRest.ENDPOINT_CADASTRAR_COMUNICADO)){
                jsonresponse = ' {"message":"The request is invalid.","modelState":{"model.MATRICULA":["The MATRICULA field is required."]}}';
            }
            res.setBody(jsonresponse);
            res.setStatusCode(300);
            return res;
        }
    }

    public class CallMACAuthFailure implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            BPO_MacCallRest.LoginCredentials lc = new BPO_MacCallRest.LoginCredentials();
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            string jsonresponse = '{"sucesso": false,"Token": null}';
            res.setBody(jsonresponse);
            res.setStatusCode(400);
            return res;
        }
    }

    public class CallMktCloudSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            System.debug('CallMktCloudSuccess req.getEndpoint(): ' + req.getEndpoint());
            if(req.getEndpoint().contains('sso')){
                return new CallSSOSuccess().respond(req);
            }
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            string jsonresponse = '{"refreshToken":"123","expiresIn": 3600,"accessToken":"123"}';
            res.setBody(jsonresponse);
            res.setStatusCode(200);
            return res;
        }
    }

    public class CallSSOSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            if(req.getEndpoint().contains('/api/v2/outbound/contactlists/')){
                res.setStatusCode(200);
                res.setHeader('Content-Type', 'application/json');
                res.setBody('[{"id":"responseReferenceId","contactListId":"contactlistid"}]');
            }else{
                res.setHeader('Content-Type', 'application/json;charset=UTF-8');
                string jsonresponse =
                    '{"accessToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjJBMTlCMDIzQkREQTAzRjQ3RjEzQTZENkFBRDUzQzMwMTgyMEIyMzgiLCJ0eXAiOiJKV1QiLCJ4NXQiOiJLaG13STczYUFfUl9F' +
                    'NmJXcXRVOE1CZ2dzamcifQ.eyJuYmYiOjE1NTk5NDE2NjcsImV4cCI6MTU1OTk0NTI2NywiaXNzIjoiaHR0cHM6Ly9zc28taG1sLmF6dXJld2Vic2l0ZXMubmV0IiwiYXVkIjpbImh0dHBzOi8vc3NvLWhtbC5henVyZ' +
                    'XdlYnNpdGVzLm5ldC9yZXNvdXJjZXMiLCJhcGktY3RpIl0sImNsaWVudF9pZCI6IlNhbGVzZm9yY2VDVEkiLCJzY29wZSI6WyJhcGktY3RpLnNhbGVzZm9yY2UiXX0.GhlEZNplxRbgh5dOseJr9OuVlZRgrrn4o-gXN' +
                    'mSE6FC_tlFbTw1ZcwUy57rINC3MXnQkHmgyCnsWH6rSKV8fQ6vPFw_jmBzYzXguHSzlBrXF-UQjv-Q_A38Y1K2YG1I53aj31T_P7fs5dWCt23R8INswqjcyaCckIHq-77BxOrN7AJkqCLf3GgxilJ9_g8s95dmYwv7ZxB' +
                    'HF1uqKbqO60AZcNLcN4zW8qty4SsGzPzNsYUaIlJRjH5f7TeB0ay5Dfusl0Tx06ugXpAoNyTQWIt-69qrjQ23gh42DjxFnG0ucziezTS8j46DFkHoXLJRQhHHzNBjbvHMj_jIZAGUS3g",' +
                    '"expiresIn": 3600, "tokenType": "Bearer"}';
                res.setBody(jsonresponse);
                res.setStatusCode(200);
            }
            return res;
        }
    }


    public class CallDiretrix implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            string jsonresponse =
                '{' +
                '    \"sucesso\": true,' +
                '    \"msg\": \"Consulta efetuada com sucesso.\",' +
                '    \"consulta\": {' +
                '        \"dadosGerais\": [' +
                '            {' +
                '                \"CNPJ\": \"14539125000107\",' +
                '                \"CNPJOK\": \"14.539.125/0001-07\",' +
                '                \"RAZAO\": \"DIRETRIX.ON INTELIGENCIA DA INFORMACAO LTDA\",' +
                '                \"NOME_FANTASIA\": \"DIRETRIX.ON\",' +
                '                \"DATA_ABERTURA\": \"24/08/2011\",' +
                '                \"CNAE\": \"6311900\",' +
                '                \"DESCRICAO_CNAE\": \"Tratamento de dados, provedores de serviços de aplicação e serviços de hospedagem na internet\",' +
                '                \"SETOR\": \"SERVICO\",' +
                '                \"PORTE\": \"MICRO\",' +
                '                \"QTD_FUNCIONARIOS\": \"4\",' +
                '                \"FATURAMENTO_PRESUMIDO_ANUAL\": \"160000.00\",' +
                '                \"FATURAMENTO_PRESUMIDO_ANUAL_GRUPO\": \"160000.00\",' +
                '                \"NJUR\": \"2062 - Sociedade Empresária Limitada \",' +
                '                \"MATRIZ\": \"1\"' +
                '            }' +
                '        ],' +
                '        \"situacaoCadastral\": [' +
                '            {' +
                '                \"SITUACAO_CADASTRAL\": \"ATIVA\",' +
                '                \"DIGITO_VERIFICARDOR\": \"\",' +
                '                \"DATA\": \"24/08/2011\",' +
                '                \"COD_CONTROLE\": \"\"' +
                '            }' +
                '        ],' +
                '        \"matrizFiliais\": [],' +
                '        \"enderecos\": [' +
                '            {' +
                '                \"ENDERECO\": \"R PE JUSTINO LOMBARDI 353 AND 2\",' +
                '                \"TIPO_LOGRADOURO\": \"R\",' +
                '                \"TITULO_LOGRADOURO\": \"PE\",' +
                '                \"LOGRADOURO\": \"JUSTINO LOMBARDI\",' +
                '                \"NUMERO\": \"353\",' +
                '                \"COMPLEMENTO\": \"AND 2\",' +
                '                \"BAIRRO\": \"VL PEREIRA CERCA\",' +
                '                \"CIDADE\": \"SAO PAULO\",' +
                '                \"UF\": \"SP\",' +
                '                \"CEP\": \"02931060\",' +
                '                \"CEPOK\": \"02931-060\",' +
                '                \"QUALIFICACAO\": \"1\"' +
                '            },' +
                '            {' +
                '                \"ENDERECO\": \"AV BRG FARIA LIMA 2391 CJ 131\",' +
                '                \"TIPO_LOGRADOURO\": \"AV\",' +
                '                \"TITULO_LOGRADOURO\": \"BRG\",' +
                '                \"LOGRADOURO\": \"FARIA LIMA\",' +
                '                \"NUMERO\": \"2391\",' +
                '                \"COMPLEMENTO\": \"CJ 131\",' +
                '                \"BAIRRO\": \"JD PAULISTANO\",' +
                '                \"CIDADE\": \"SAO PAULO\",' +
                '                \"UF\": \"SP\",' +
                '                \"CEP\": \"01452905\",' +
                '                \"CEPOK\": \"01452-905\",' +
                '                \"QUALIFICACAO\": \"2\"' +
                '            },' +
                '            {' +
                '                \"ENDERECO\": \"R CON EUGENIO LEITE 623 TER\",' +
                '                \"TIPO_LOGRADOURO\": \"R\",' +
                '                \"TITULO_LOGRADOURO\": \"CON\",' +
                '                \"LOGRADOURO\": \"EUGENIO LEITE\",' +
                '                \"NUMERO\": \"623\",' +
                '                \"COMPLEMENTO\": \"TER\",' +
                '                \"BAIRRO\": \"PINHEIROS\",' +
                '                \"CIDADE\": \"SAO PAULO\",' +
                '                \"UF\": \"SP\",' +
                '                \"CEP\": \"05414011\",' +
                '                \"CEPOK\": \"05414-011\",' +
                '                \"QUALIFICACAO\": \"3\"' +
                '            }' +
                '        ],' +
                '        \"telefones\": [' +
                '            {' +
                '                \"DDD\": \"11\",' +
                '                \"TELEFONE\": \"30645693\",' +
                '                \"TELEFONEOK\": \"(11) 3064-5693\",' +
                '                \"TIPO_TELEFONE\": \"Comercial\",' +
                '                \"RESTRICAO\": \"0\",' +
                '                \"QUALIFICACAO\": \"2\"' +
                '            }' +
                '        ],' +
                '        \"emails\": [' +
                '            {' +
                '                \"EMAIL\": \"OSEIASSOUZA@HOTMAIL.COM\",' +
                '                \"QUALIFICACAO\": \"1\"' +
                '            },' +
                '            {' +
                '                \"EMAIL\": \"BIANCA@DIRETRIXON.COM.BR\",' +
                '                \"QUALIFICACAO\": \"2\"' +
                '            }' +
                '        ],' +
                '        \"spc\": [],' +
                '        \"ccf\": [],' +
                '        \"protesto\": []' +
                '    }' +
                '}';
            res.setBody(jsonresponse);
            res.setStatusCode(200);
            return res;
        }
    }

    public class CallAPIDocumentSucess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            string jsonresponse = '';
            res.setBody(jsonresponse);
            res.setStatusCode(201);
            return res;
        }
    }

    public class CallAPIDocumentFailed implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            string jsonresponse = '';
            res.setBody(jsonresponse);
            res.setStatusCode(500);
            return res;
        }
    }

    public class CallSendDocumentAPIDocumentSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            string jsonresponse = '{"idArquivo":"825ed094-d73a-4fba-bfa3-676cbbee877e","idTipoArquivo":1,"desCaminho":"wflow/sinistros/apolice","snExcluido":false,"dtExclusao":null,"arquivo":"JVBE","pessoa":[{"documento":"28475201806","tipoPessoa":"PF","desCaminho":"https://wizcorphml001.blob.core.windows.net/documentos/28475201806%5Cwflow/sinistros/apolice/825ed094-d73a-4fba-bfa3-676cbbee877e.pdf"}]}';
            res.setBody(jsonresponse);
            res.setStatusCode(200);
            return res;
        }
    }

    public class CallGetDocumentAPIDocumentSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            string jsonresponse = '{"idArquivo":"f5eb48df-3e33-428a-8188-42040dd5fbd7","idTipoArquivo":25,"documento":null,"desCaminho":"CORPORATE/00163000014WtneAAC/0066300000GyDq6AAF  ","desCpf":null,"urlBlob":"https://wizcorphml001.blob.core.windows.net/documentos/47535470866/CORPORATE/00163000014WtneAAC/0066300000GyDq6AAF  /f5eb48df-3e33-428a-8sp=r","base64":"iVBORw0KG","isExcluido":false,"dtExclusao":"2021-11-09T19:48:26.543","tenant":null,"pessoas":[{"documento":"47535470866","tipoPessoa":null,"desCaminho":null}]}';
            res.setBody(jsonresponse);
            res.setStatusCode(200);
            return res;
        }
    }

    public class CallGetAllTypeSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            string jsonresponse = '{"idTipoArquivo":1,"descricaoTipoArquivo":"Cópia do Registro de identidade do segurado"}';
            res.setBody(jsonresponse);
            res.setStatusCode(200);
            return res;
        }
    }

    public class CallGetAllTypesSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            string jsonresponse = '[{"idTipoArquivo":1,"descricaoTipoArquivo":"Cópia do Registro de identidade do segurado"}]';
            res.setBody(jsonresponse);
            res.setStatusCode(200);
            return res;
        }
    }
    public class CallGetTypebyNameSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            string jsonresponse = '{"idTipoArquivo":2,"descricaoTipoArquivo":"CPF"}';
            res.setBody(jsonresponse);
            res.setStatusCode(200);
            return res;
        }
    }

    public class CallDeleteDocSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            res.setStatusCode(204);
            return res;
        }
    }

    public class CallWFlowSucess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            string jsonresponse = '';
            res.setBody(jsonresponse);
            res.setStatusCode(201);
            return res;
        }
    }

    public class CallBuscarEmpresasSucess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            string jsonresponse = '';
            res.setBody(jsonresponse);
            res.setStatusCode(201);
            return res;
        }
    }

    public class CallWFlowPostOppSalesSucess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            string jsonresponse = '{"opportunityId":"string","insuranceType":1,"insuranceTypeName":"string","modality":1,"modalityName":"string","operation":1,"totalItems":0,"insuredAmount":0,"valueOpportunity":0,"riskCheck":true,"commercialType":1,"gn":"string","wizCorporatePercentage":0,"wNetworkPercentage":0,"partnersPercentage":0,"partnerName":"string","partnerPercentage":0,"assignToId":"string","status":0,"statusDescription":"string","steps":[{"step":0,"description":"string","status":"string"}]}';
            res.setBody(jsonresponse);
            res.setStatusCode(201);
            return res;
        }
    }

    public class CallWFlowFailed implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json;charset=UTF-8');
            string jsonresponse = '';
            res.setBody(jsonresponse);
            res.setStatusCode(500);
            return res;
        }
    }

    public class MultiRequestMock implements HttpCalloutMock{
        public HttpResponse respond(HttpRequest request){
            if(request.getEndpoint().endsWith('completed')){
                HttpResponse response = new HttpResponse();
                response.setHeader('Content-Type', 'application/json');
                response.setBody('{"resultSetSize":"1","envelopes":[{"status":"completed","envelopeId":"123"}]}');
                response.setStatusCode(200);
                return response;
            }else if(request.getEndpoint().endsWith('base64')){
                HttpResponse response = new HttpResponse();
                response.setHeader('Content-Type', 'application/json');
                response.setBody('{"idArquivo":"f5eb48df-3e33-428a-8188-42040dd5fbd7","idTipoArquivo":25,"documento":null,"desCaminho":"CORPORATE/00163000014WtneAAC/0066300000GyDq6AAF  ","desCpf":null,"urlBlob":"https://wizcorphml001.blob.core.windows.net/documentos/47535470866/CORPORATE/00163000014WtneAAC/0066300000GyDq6AAF/f5eb48df-3e33-428a-8sp=r","base64":"iVBORw0KG","isExcluido":false,"tenant":null,"pessoa":[{"documento":"47535470866","tipoPessoa":null,"desCaminho":"https://wizcorp001.blob.core.windows.net/documentos/68211515000174/CORPORATE/0018800000OO2EAAA1/00688000009eKMDAA2/xxxxxxxxxxxx.pdf"}]}');
                response.setStatusCode(201);
                return response;
            }else if(request.getEndpoint().endsWith('combined')){
                HttpResponse response = new HttpResponse();
                response.setHeader('Content-Type', 'application/json');
                response.setBodyAsBlob(Blob.valueOf('asdasd'));
                response.setStatusCode(200);
                return response;
            }else if(request.getEndpoint().endsWith('token')){
                HttpResponse response = new HttpResponse();
                response.setHeader('Content-Type', 'application/json');
                String jsonresponse =
                    '{"accessToken": "eyJhbGciOiJSUzI1NiIsImtpZCI6IjJBMTlCMDIzQkREQTAzRjQ3RjEzQTZENkFBRDUzQzMwMTgyMEIyMzgiLCJ0eXAiOiJKV1QiLCJ4NXQiOiJLaG13STczYUFfUl9F' +
                    'NmJXcXRVOE1CZ2dzamcifQ.eyJuYmYiOjE1NTk5NDE2NjcsImV4cCI6MTU1OTk0NTI2NywiaXNzIjoiaHR0cHM6Ly9zc28taG1sLmF6dXJld2Vic2l0ZXMubmV0IiwiYXVkIjpbImh0dHBzOi8vc3NvLWhtbC5henVyZ' +
                    'XdlYnNpdGVzLm5ldC9yZXNvdXJjZXMiLCJhcGktY3RpIl0sImNsaWVudF9pZCI6IlNhbGVzZm9yY2VDVEkiLCJzY29wZSI6WyJhcGktY3RpLnNhbGVzZm9yY2UiXX0.GhlEZNplxRbgh5dOseJr9OuVlZRgrrn4o-gXN' +
                    'mSE6FC_tlFbTw1ZcwUy57rINC3MXnQkHmgyCnsWH6rSKV8fQ6vPFw_jmBzYzXguHSzlBrXF-UQjv-Q_A38Y1K2YG1I53aj31T_P7fs5dWCt23R8INswqjcyaCckIHq-77BxOrN7AJkqCLf3GgxilJ9_g8s95dmYwv7ZxB' +
                    'HF1uqKbqO60AZcNLcN4zW8qty4SsGzPzNsYUaIlJRjH5f7TeB0ay5Dfusl0Tx06ugXpAoNyTQWIt-69qrjQ23gh42DjxFnG0ucziezTS8j46DFkHoXLJRQhHHzNBjbvHMj_jIZAGUS3g",' +
                    '"expiresIn": 3600, "tokenType": "Bearer"}';
                response.setBody(jsonresponse);
                response.setStatusCode(200);
                return response;
            }else{
                return null;
            }
        }
    }
}