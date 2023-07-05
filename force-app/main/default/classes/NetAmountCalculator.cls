public with sharing class NetAmountCalculator {
public static void calculateAmount(Set<Id> sAccountToRecalculate) {
       
        List<Account> accounts = [ SELECT Id, Chiffre_affaire__c , (SELECT TotalAmount FROM Orders WHERE Status = 'Activated') 
                                  FROM Account WHERE Id IN :sAccountToRecalculate ];
       
        for (Account account : accounts) {
            account.Chiffre_affaire__c = 0;
            if (account.Orders != null && account.Orders.size() > 0) {
                for (Order order : account.Orders) {
                    account.Chiffre_affaire__c += order.TotalAmount;
                    System.debug(order.TotalAmount);
                }
            }
        }
       
        update accounts;
    }
}