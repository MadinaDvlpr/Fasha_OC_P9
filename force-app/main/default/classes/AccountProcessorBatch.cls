global class AccountProcessorBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            [  SELECT Id, Chiffre_affaire__c FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Activated')]);
    }

    global void execute(Database.BatchableContext bc, List<Account> scope) {
        Set<Id> sAccountTurnoverToUpdate = (new Map<Id, SObject>(scope)).keySet();
        NetAmountCalculator.calculateAmount(sAccountTurnoverToUpdate);
    }

    global void finish(Database.BatchableContext bc) {
    }
    
    
}