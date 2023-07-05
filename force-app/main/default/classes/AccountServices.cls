public with sharing class AccountServices {

    public static Map<Id, Decimal> convertAccountsListIntoMapOfIdsAndRevenues(List<Account> accountsList) {
        Map<Id, Decimal> accountsMapIdAndRevenue = new Map<Id, Decimal>();
        for (Account accountCurent : accountsList) {
            accountsMapIdAndRevenue.put(accountCurent.Id, accountCurent.Chiffre_affaire__c);
        }
        return accountsMapIdAndRevenue;
    }


    public static Set<Account> convertAccountListIntoSet(List<Account> accountsList) {
        Set<Account> accountsSet = new Set<Account>();
        for (Account accountCurrent : accountsList) {
            accountsSet.add(accountCurrent);
        }
        return accountsSet;
    }

}