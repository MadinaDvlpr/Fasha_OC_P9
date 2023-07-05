public with sharing class AccountSelector {

    //get one account
    public static Account getAccount(String accountName) {
        Account accountToReturn = [
                SELECT Id,
                        Chiffre_affaire__c,
                        Name
                FROM Account
                WHERE Name = :accountName
                LIMIT 1
        ];
        return accountToReturn;
    }

    //get all accounts
    public static List<Account> getAccountsAll() {
        List<Account> accList = [
                SELECT Id,
                        Chiffre_affaire__c,
                        Name
                FROM Account
        ];
        return accList;
    }

    //get list of account with orders
    public static List<Account> getAccountsWhereOrderStatusActivated() {
        List<Account> accountsList = [
                SELECT Id, Chiffre_affaire__c, Name
                FROM Account
                WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Activated')
        ];
        return accountsList;
    }

    public static List<Account> getAccountByIds(Set<Id> ids) {
        return  [SELECT Id, Chiffre_affaire__c, Name FROM Account WHERE Id IN :ids];
    }

}