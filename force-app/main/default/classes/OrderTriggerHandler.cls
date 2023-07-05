public with sharing class OrderTriggerHandler {


    public OrderTriggerHandler(){

    }

    public void run() {
        List<Order> newOrders = Trigger.new ;
        
        if (Trigger.isBefore && Trigger.isUpdate) {
            OrderTriggerHelper.calculateNetAmountOrder(newOrders);
        } else if (Trigger.isAfter && Trigger.isUpdate) {
            OrderTriggerHelper.updateListOfAccountsRevenueWhenOrderStatusActivated(newOrders, (Map<Id, Order>) Trigger.oldMap);
        }
    }
}