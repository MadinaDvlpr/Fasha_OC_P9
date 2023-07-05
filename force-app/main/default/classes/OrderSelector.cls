public with sharing class OrderSelector {
    
    public static AggregateResult getTotalSumOrdersByAccountId(Id accountId){
        AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order WHERE accountId = :accountId];
        return groupedResults;
    }
    
    public static Order getOrder(Account accountForThisTest){
        Order orderToReturn = [SELECT Id, AccountId, TotalAmount, ShippingCost__c, NetAmount__c
                               FROM Order
                               WHERE AccountId = :accountForThisTest.Id
                               LIMIT 1];
        return orderToReturn;
    }
    
    public static Order getOrderByName(String orderName){
        Order orderToReturn = [SELECT Id, AccountId, TotalAmount, ShippingCost__c, NetAmount__c
                               FROM Order
                               WHERE Name = :orderName
                               LIMIT 1];
        return orderToReturn;
    }
    
    
    public static List<Order> getOrdersAll(){
        List<Order> orderList = [SELECT Id, 
                                        AccountId, 
                                        TotalAmount, 
                                        ShippingCost__c,
                                        NetAmount__c,
                                        Status
                                  FROM Order];
        return orderList;
    }
    
    public static List<Order> getOrdersStatusActivated(){
        List<Order> orderList = [SELECT Id, 
                                        AccountId, 
                                        TotalAmount, 
                                        ShippingCost__c,
                                        NetAmount__c
                                  FROM Order
                                  WHERE Status ='Activated'];
        return orderList;
    }
    
    public static List<Order> getOrdersListForOneAccount(Account accountForThisTest){
        List<Order> orderList = [SELECT Id, AccountId, TotalAmount, ShippingCost__c, NetAmount__c, Status
                               FROM Order
                               WHERE AccountId = :accountForThisTest.Id];
        return orderList;
    }
	
}