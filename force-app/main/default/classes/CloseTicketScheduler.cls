/**
 * @description       : Agenda quando deve ser executado a rotina que atualiza o a reabertura do Ticket
 * @author            : brunosousa.mirante@wizsolucoes.com.br
 * @group             :
 * @last modified on  :
 * @last modified by  :
 * Modifications Log
 * Ver   Date           Author              Modification
 * 1.0   28-03-2021     Bruno Sousa	        Initial Version
 **/
public class CloseTicketScheduler implements Schedulable{

    public static void schedule(String hour){

        String sch = '0 0 ' + hour + ' * * ? *';

        System.schedule(
            'Agendamento para atualização do campo Reabertura de Tickets ' + Datetime.now(),
            sch,
            new CloseTicketScheduler()
        );
    }

    public void execute(SchedulableContext ctx){
        CloseTicketBatch batch = new CloseTicketBatch();
        Database.executeBatch(batch);
    }

}