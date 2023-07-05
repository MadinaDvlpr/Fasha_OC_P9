@isTest
private class AccountProcessorBatchTest {
    
    
    @TestSetup
    static void setupFor_AccountProcessorBatchTest(){
        
        Account account1 = TestDataFactory.createAccount('Account1');
        List <Order> ordersList = TestDataFactory.createAccountWithOrders(20, account1.Id);
        
        for( Order order : ordersList){
            order.Status = 'Activated';
        }
        update ordersList;
        Account account2 = TestDataFactory.createAccount('Account2');
        List <Order> ordersList2 = TestDataFactory.createAccountWithOrders(40, account2.Id);
        
        for( Order order : ordersList2){
            order.Status = 'Activated';
        }
        update ordersList2;
        
        system.debug('list2'+ordersList2);
        system.debug('list1'+ordersList);
    }
    
    @isTest 
    static void UpdateAllAccountsBatchTest() {
                
        Test.startTest();
        List<Account> accs =[SELECT Id, Chiffre_affaire__c, (SELECT Id, Status, TotalAmount FROM Orders 
                                                               WHERE Status = 'Activated') FROM Account 
                             WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Activated')];
        
        AccountProcessorBatch updateAccounts = new AccountProcessorBatch();
        Id batchId = Database.executeBatch(updateAccounts);
        
        List<Account> batchList = [SELECT ID, Chiffre_affaire__c FROM Account WHERE ID IN (SELECT AccountID FROM Order WHERE Status = 'Activated')];
        
        Test.stopTest();
        
        Account accountBatch1 = [SELECT Id, Chiffre_affaire__c FROM Account WHERE Name = 'Account1'];
        Account accountBatch2 = [SELECT Id, Chiffre_affaire__c FROM Account WHERE Name = 'Account2'];

        //acc2 :  40 orders *100 unitPrice  = 4000
        //acc1 :  20 orders *100 unitPrice  = 2000
        System.assertEquals(2000, accountBatch1.Chiffre_affaire__c);
        System.assertEquals(4000, accountBatch2.Chiffre_affaire__c);
        
    } 
}