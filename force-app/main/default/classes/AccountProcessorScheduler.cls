global with sharing class AccountProcessorScheduler implements Schedulable{

  global void execute (SchedulableContext sc) {

    AccountProcessorBatch sAccountTurnoverToUpdate = new AccountProcessorBatch();
    Id batchId = database.executeBatch(sAccountTurnoverToUpdate);

}
}