@isTest 
public with sharing class OrderServicesTest {
    private static String accountName = 'Madina';
    private static String accountOneOrder = 'AccountTest';
    private static String productName = 'Bidule';
    private static String pricebookName = 'Madina\'s Price Book';
    private static String orderName = 'MyOrderTest';
    
    @TestSetup
    static void setupForOrderServiceTest(){
        TestDataFactory.createAccount(accountName);
        TestDataFactory.createAccount(accountOneOrder);
        Account accountForThisTest = AccountSelector.getAccount(accountName);
        List <Order> ordersList = TestDataFactory.createAccountWithOrders(20, accountForThisTest.Id);
        TestDataFactory.createPricebook(pricebookName);
        TestDataFactory.createProduct(productName);
    }
    
    
    @isTest
    static void updateStatusToActivatedTest(){
        Account accountTest = AccountSelector.getAccount(accountName);
        List <Order> orderListForTest = OrderSelector.getOrdersListForOneAccount(accountTest);
 
        Test.startTest();
        OrderServices.updateOrdersListStatusToActivated(orderListForTest);
        Test.stopTest();
        
        List<Order> ordersListToTest = [SELECT Id,
                                          AccountId,
                                          TotalAmount,
                                          ShippingCost__c,
                                          NetAmount__c,
                                          status
                                          FROM Order
                                          WHERE Status = 'Activated'
                                          LIMIT 20];

        System.assertEquals( 20, ordersListToTest.size(), 'OrderServices.updateOrdersListStatusToActivated should return a list of 20.');
    }    
    
    @isTest
    static void updateOrdersStatusToActivatedTest(){
        Account accountTest = AccountSelector.getAccount(accountName);
        Order orderForThisTest = OrderSelector.getOrdersListForOneAccount(accountTest).get(0);
      
        Test.startTest();
        OrderServices.updateOrdersStatusToActivated(orderForThisTest);
        Test.stopTest();
        
        orderForThisTest = [SELECT Id, AccountId, Status FROM Order WHERE Id = :orderForThisTest.Id];
      
        System.assertEquals('Activated', orderForThisTest.Status, 'should return a status Activated.');
        
    }
    
    @isTest
    static void convertOrderListIntoSetTest(){
        Account accountTest = AccountSelector.getAccount(accountName);
        List <Order> orderListForTest = OrderSelector.getOrdersListForOneAccount(accountTest);
        
        Test.startTest();
        Set<Order> orderSetForTest = OrderServices.convertOrderListIntoSet(orderListForTest);
        Test.stopTest();
		System.debug(orderSetForTest);

        System.assertEquals(20, orderSetForTest.size(), 'OrderDataFactory.convertOrderListIntoSet should convert a list of into a set of 20.');
    }
    
}