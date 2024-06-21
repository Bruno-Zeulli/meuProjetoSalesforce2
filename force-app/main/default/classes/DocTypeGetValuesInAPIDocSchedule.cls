/**
 * @description       : Agendamento para buscar os tipos de documentos disponíveis na API Documentos
 * @author            : Marcelo Martins
 * @email             : marcelomartins@wizsolucoes.com.br
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   02-11-2022   marcelomartins@wizsolucoes.com.br    Initial Version
 **/
public without sharing class DocTypeGetValuesInAPIDocSchedule implements Schedulable {
    
    private static final String CRON_EXP = '0 0 20 * * ?'; //Todos os dias às 8 horas da noite
    
     /**
    * @description método responsável por agendar a rotina
    */
    public static void schedule(){
        System.schedule(    
            'Agendamento para buscar os tipos de documentos disponíveis na API Documentos' + Datetime.now(),
            CRON_EXP,
            new DocTypeGetValuesInAPIDocSchedule()
        );
    }
    /**
    * @description método responsável por excutar a rotina
    * @param ctx recebe o contexto do agendamento
    */
    public void execute(SchedulableContext ctx){
        DocumentUploadService.getAllTypesFile();
    }
}