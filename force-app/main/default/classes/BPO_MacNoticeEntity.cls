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

global class BPO_MacNoticeEntity {
  global class InputCreate {
    global Long comunicado { get; set; }
    global Long numContratoCEF { get; set; }
    global Long cPFCNPJSinistrado { get; set; }
    global String nomeSinistrado { get; set; }
    global String dataOcorrencia { get; set; }
    global Integer numAgCont { get; set; }
    global Integer idCobertura { get; set; }
    global Integer idTipoSinistro { get; set; }
    global Integer idCausa { get; set; }
    global String descricaoCausaEvento { get; set; }
    global String idhoraVistoria { get; set; }
    global Long vistoriaCEP { get; set; }
    global String vistoriaEndereco { get; set; }
    global String vistoriaBairro { get; set; }
    global String vistoriaCidade { get; set; }
    global String vistoriaUF { get; set; }
    global String vistoriaRef { get; set; }
    global String vistoriaObs { get; set; }
    global Integer idParentescoCom { get; set; }
    global Long cpfCNPJComunicante { get; set; }
    global String nomeComunicante { get; set; }
    global Long foneResidencialCom { get; set; }
    global Long foneCelularCom { get; set; }
    global Long foneComercialCom { get; set; }
    global String emailPesComunicante { get; set; }
    global String emailComComunicante { get; set; }
    global Long cepComunicante { get; set; }
    global String enderecoComunicante { get; set; }
    global String bairroComunicante { get; set; }
    global String cidadeComunicante { get; set; }
    global String ufComunicante { get; set; }
    global Integer comunicanteContatosAoMesmo { get; set; }
    global Integer idParentescoCont { get; set; }
    global Long cpfCNPJContato { get; set; }
    global String nomeContato { get; set; }
    global String melhorFormaCom1 { get; set; }
    global String melhorFormaCom2 { get; set; }
    global String melhorFormaCom3 { get; set; }
    global Integer fonePrincipalCont { get; set; }
    global Long foneResidencialCont { get; set; }
    global Long foneCelularCont { get; set; }
    global Long foneComercialCont { get; set; }
    global String emailPesContato { get; set; }
    global String emailComContato { get; set; }
    global Long cepContato { get; set; }
    global String enderecoContato { get; set; }
    global String bairroContato { get; set; }
    global String cidadeContato { get; set; }
    global String ufContato { get; set; }
    global Integer tipoOrig { get; set; }
    global String matricula { get; set; }
    global String nomeOrig { get; set; }
    global String emailOrig { get; set; }
    global String obsAtendimento { get; set; }
    global String numFila { get; set; }
    global Decimal valoR_ORC_COMUNIC { get; set; }
  }

  global class InputMacCreate {
    global String codSF { get; set; }
    global Long numContratoCEF { get; set; }
    global String cPFCNPJSinistrado { get; set; }
    global String nomeSinistrado { get; set; }
    global String dataOcorrencia { get; set; }
    global Integer idCobertura { get; set; }
    global Integer idTipoSinistro { get; set; }
    global Integer idCausa { get; set; }
    global String descricaoCausaEvento { get; set; }
    global String idhoraVistoria { get; set; }
    global Long vistoriaCEP { get; set; }
    global String vistoriaEndereco { get; set; }
    global String vistoriaBairro { get; set; }
    global String vistoriaCidade { get; set; }
    global String vistoriaUF { get; set; }
    global String vistoriaRef { get; set; }
    global String vistoriaObs { get; set; }
    global Integer idParentescoCom { get; set; }
    global String cpfCNPJComunicante { get; set; }
    global String nomeComunicante { get; set; }
    global Long foneResidencialCom { get; set; }
    global Long foneCelularCom { get; set; }
    global Long foneComercialCom { get; set; }
    global String emailPesComunicante { get; set; }
    global String emailComComunicante { get; set; }
    global Long cepComunicante { get; set; }
    global String enderecoComunicante { get; set; }
    global String bairroComunicante { get; set; }
    global String cidadeComunicante { get; set; }
    global String ufComunicante { get; set; }
    global Integer comunicanteContatosAoMesmo { get; set; }
    global Integer idParentescoCont { get; set; }
    global String cpfCNPJContato { get; set; }
    global String nomeContato { get; set; }
    global String melhorFormaCom1 { get; set; }
    global String melhorFormaCom2 { get; set; }
    global String melhorFormaCom3 { get; set; }
    global Integer fonePrincipalCont { get; set; }
    global Long foneResidencialCont { get; set; }
    global Long foneCelularCont { get; set; }
    global Long foneComercialCont { get; set; }
    global String emailPesContato { get; set; }
    global String emailComContato { get; set; }
    global Long cepContato { get; set; }
    global String enderecoContato { get; set; }
    global String bairroContato { get; set; }
    global String cidadeContato { get; set; }
    global String ufContato { get; set; }
    global Integer tipoOrig { get; set; }
    global String matricula { get; set; }
    global String nomeOrig { get; set; }
    global String emailOrig { get; set; }
    global String obsAtendimento { get; set; }
    global Decimal valoR_ORC_COMUNIC { get; set; }
  }

  global class InputUpdate {
    global Long comunicado { get; set; }
    global String comunicadora { get; set; }
    global String codSF { get; set; }
    global Long numProtocolo { get; set; }
    global Long numSinistro { get; set; }
    global Long cPFCNPJSinistrado { get; set; }
    global String nomeSinistrado { get; set; }
    global String dataOcorrencia { get; set; }
    global String dataVistoria { get; set; }
    global String horaVistoria { get; set; }
    global Integer tipoSinistro { get; set; }
    global Long numContratoCEF { get; set; }
    global Integer numAgCont { get; set; }
    global String desatividade { get; set; }
    global String numFila { get; set; }
  }

  global class InputTask {
    global Long comunicado { get; set; }
    global String codSF { get; set; }
    global String dataContato { get; set; }
    global String reclamante { get; set; }
    global String dataHoraContato { get; set; }
    global String nomeOperador { get; set; }
    global String tabulacao { get; set; }
    global String desatividade { get; set; }
  }

  global class InputTed {
    global Long comunicado { get; set; }
    global String comunicadora { get; set; }
    global String codSF { get; set; }
    global String dataTed { get; set; }
    global Integer tpTed { get; set; }
    global String docTedPend { get; set; }
    global String docTedRec { get; set; }
    global String numFila { get; set; }
  }

  global class InputParecer {
    global Long comunicado { get; set; }
    global String comunicadora { get; set; }
    global String codSF { get; set; }
    global Integer resultadoSinistro { get; set; }
    global Integer tipoSinistro { get; set; }
    global String descricao { get; set; }
    global Integer seqPagamento { get; set; }
    global String dataPagamento { get; set; }
    global Double valorIndenizado { get; set; }
    global String dataInicioPagEncargo { get; set; }
    global String dataFimPagEncargo { get; set; }
    global Double valorParcelaEncargo { get; set; }
    global String dataParcelaEncargo { get; set; }
    global Double percentualSinistrado { get; set; }
    global String numFila { get; set; }
  }

  global class Response {
    //global Integer CODMSG {get; set;}
    //global Integer codSQL {get; set;}
    //global String DESCMSG {get; set;}
    //global String MSGSQL {get; set;}
    //global String SQLSTA {get; set;}
    global String codSF { get; set; }
    global String msgErro { get; set; }
    global Boolean sucesso { get; set; }
  }

  global class ResponseMAC {
    global String codigo { get; set; }
    global Integer codSQL { get; set; }
    global String mensagem { get; set; }
    global String status { get; set; }
    global String idComunicado { get; set; }
  }

  global static String mapearFilaWorkflow(String numFila){
    // Situação da fila do workflow | Concierge_IncidentWorkflowStatus__c
    Map<String, String> filaWorkflow = new Map<String, String>{
      '1' => 'BPO - Habitacional MIP – Novas',
      '2' => 'BPO - Habitacional DFI – Novas',
      '3' => 'BPO - Prestamista MIP',
      '4' => 'BPO - Prestamista DFI',
      '5' => 'BPO - Pago',
      '6' => 'BPO - Negado',
      '7' => 'BPO - Cancelado',
      '8' => 'BPO - Não É Cliente da Caixa Seguradora',
      '9' => 'BPO - Anexos',
      '10' => 'BPO - Pedidos Médicos em Atendimento',
      '11' => 'BPO - Pedidos de Perícia/Junta Médica',
      '12' => 'BPO - LVI Pendente',
      '13' => 'BPO - Pedidos de Sindicância',
      '14' => 'BPO - Para Sugestão de parecer',
      '15' => 'BPO - Regulação Seguradora',
      '16' => 'BPO - Demandas Devolvidas',
      '17' => 'BPO - Regulação Seguradora',
      '18' => 'BPO - TED',
      '19' => 'BPO - TED Complementar',
      '20' => 'BPO - Regulação Seguradora Recurso',
      '21' => 'BPO - Habitacional MIP – Novas C',
      '22' => 'BPO - Habitacional DFI – Novas C',
      '23' => 'BPO - Prestamista MIP – Novas C',
      '24' => 'BPO - Prestamista DFI – Novas C',
      '25' => 'BPO - Habitacional MIP – Novas R',
      '26' => 'BPO - Habitacional DFI – Novas R',
      '27' => 'BPO - Prestamista MIP – Novas R',
      '28' => 'BPO - Prestamista DFI – Novas R'
    };

    return filaWorkflow.get(numFila);
  }

  global static String mapearMacroStatus(String numFila){
    // Status padrão do caso
    Map<String, String> macroStatus = new Map<String, String>{
      '1' => 'BPO - Comunicado Aberto',
      '2' => 'BPO - Comunicado Aberto',
      '3' => 'BPO - Comunicado Aberto',
      '4' => 'BPO - Comunicado Aberto',
      '5' => 'BPO - Finalizado',
      '6' => 'BPO - Finalizado',
      '7' => 'BPO - Finalizado',
      '8' => 'BPO - Finalizado',
      '9' => 'BPO - Documentação Básica Pendente',
      '10' => 'BPO - Em Análise',
      '11' => 'BPO - Em Análise',
      '12' => 'BPO - Vistoria',
      '13' => 'BPO - Em Análise',
      '14' => 'BPO - Em Análise',
      '15' => 'BPO - Em Análise',
      '16' => 'BPO - Em Análise',
      '17' => 'BPO - Em Análise',
      '18' => 'BPO - Documentação Básica Pendente',
      '19' => 'BPO - Documentação Complementar Pendente',
      '20' => 'BPO - Em Análise',
      '21' => 'BPO - Em Análise',
      '22' => 'BPO - Em Análise',
      '23' => 'BPO - Em Análise',
      '24' => 'BPO - Em Análise',
      '25' => 'BPO - Em Análise',
      '26' => 'BPO - Em Análise',
      '27' => 'BPO - Em Análise',
      '28' => 'BPO - Em Análise'
    };

    return macroStatus.get(numFila);
  }
}