public with sharing class OrderTriggerHelper {

    public static List<Account> getAccountsListToUpdate(Set<Order> orderSet, Set<Account> accountSet) {
        List<Account> accountsListToUpdate = new List<Account>();

        for (Account accountCurrent : accountSet) {
            for (Order orderCurrent : orderSet) {
                if (accountCurrent.Id == orderCurrent.AccountId) {

                    if (accountCurrent.Chiffre_affaire__c == null) {
                        accountCurrent.Chiffre_affaire__c = orderCurrent.TotalAmount;
                    } else {
                        accountCurrent.Chiffre_affaire__c = accountCurrent.Chiffre_affaire__c + orderCurrent.TotalAmount;
                    }
                }
            }
            accountsListToUpdate.add(accountCurrent);
        }
        return accountsListToUpdate;
    }


    public static List<Order> getOrdersListWithUpdatedNetAmounts(List<Order> orderListNew) {
        List<Order> ordersListToUpdate = new List<Order>();
        for (Order orderCurrent : orderListNew) {
            if (orderCurrent.Status == 'Activated') {
                if (orderCurrent.ShippingCost__c == null) {
                    orderCurrent.ShippingCost__c = 0;
                }
                try {
                    orderCurrent.NetAmount__c = orderCurrent.TotalAmount - orderCurrent.ShippingCost__c;
                } catch (Exception orderTotalAmount) {
                    System.debug('the Order TotalAmount should not be Null.');
                }
            }
        }
        return ordersListToUpdate;
    }


    public static void updateListOfAccountsRevenueWhenOrderStatusActivated(List<Order> orderListNew, Map<Id, Order> oldMap) {
        List<Order> updateOrderWithStatusActivated = new List<Order>();
        Set<Id> accountIds = new Set<Id>();
        for (Order orderNew : orderListNew) {
            if (oldMap.get(orderNew.Id).Status != 'Activated' && orderNew.Status == 'Activated') {
                updateOrderWithStatusActivated.add(orderNew);
            }
        }
        for (Order order : updateOrderWithStatusActivated) {
            accountIds.add(order.AccountId);
        }
        List<Account> accounts = AccountSelector.getAccountByIds(accountIds);
        accounts = calculateChiffreAffaireAccount(updateOrderWithStatusActivated, accounts);
        update accounts;
    }

    public static List<Account> calculateChiffreAffaireAccount(List<Order> updateOrderWithStatusActivated, List<Account> accounts) {
        for (Order order : updateOrderWithStatusActivated) {
            for (Account account : accounts) {
                if (order.AccountId == account.Id) {
                    if (account.Chiffre_affaire__c != null) {
                        account.Chiffre_affaire__c += order.NetAmount__c;
                    } else {
                        account.Chiffre_affaire__c = order.NetAmount__c;
                    }
                }
            }
        }
        return accounts;
    }

    public static void calculateNetAmountOrder(List<Order> orders){
        for (Order order : orders) {
            if (order.ShippingCost__c != null){
                order.NetAmount__c = order.TotalAmount  - order.ShippingCost__c;
            } else {
                order.ShippingCost__c = 0;
                order.NetAmount__c = order.TotalAmount  - order.ShippingCost__c;
            }
        }
    }
}