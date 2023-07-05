@isTest
public class OrderTriggerTest {
    // init class variables
    private static String accountName = 'Madina';
    private static String productName = 'Test';
    private static String pricebookName = 'Madina\'s Price Book';
    private static String orderName = 'Madina\'s Order';
    
    
    //Setting up a revoir pour s'assurer que les tests passent ?????
    @TestSetup
    static void setupForTestAccountUpdateTrigger(){
        // Create Some Accounts
        TestDataFactory.createAccounts(1);
        List<Account> accountList1ToCompare = AccountSelector.getAccountsAll();
        Set<Account> accountSet1ToCompare = AccountServices.convertAccountListIntoSet(accountList1ToCompare);
        TestDataFactory.createPricebook(pricebookName);
        TestDataFactory.createProduct(productName);
        Pricebook2 pricebookForThisTest = PricebookSelector.getPriceBookByName(pricebookName);
        Product2 productForThisTest = ProductSelector.getProduct(productName);
        TestDataFactory.createPriceBookEntryForPricebookStandard(productForThisTest);
        TestDataFactory.createPriceBookEntry(pricebookForThisTest, productForThisTest);
        
       
        Account accountForTest = AccountSelector.getAccount('accountName-0');
       
        List<Order> listOfOrdersToInsert = new List<Order>();
        listOfOrdersToInsert.add(TestDataFactory.createOrder('String orderName', accountForTest.Id, pricebookForThisTest));

        List<Order> orderList = OrderSelector.getOrdersAll();

        List<OrderItem> orderItemsList = new List<OrderItem>();
        PricebookEntry pricebookEntryForThisTest = PricebookSelector.getPricebookEntry(pricebookForThisTest, productForThisTest);
        for(Order orderCurent : orderList){
            orderItemsList.add(TestDataFactory.createOneOrderItem(orderCurent, productForThisTest, pricebookEntryForThisTest));
        }
        insert orderItemsList;
        List<Order> orderListForTest = OrderSelector.getOrdersAll();

        OrderServices.updateOrdersListStatusToActivated(orderListForTest);
    }

   
    @isTest
    static void testBeforeUpdateTrigger(){
        List<Order> orderListBeforeTrigger = OrderSelector.getOrdersStatusActivated();

        Order orderToUpdate = orderListBeforeTrigger[0];
        orderToUpdate.Name = 'forTestUpdate';
        orderToUpdate.ShippingCost__c = 10;

        Test.startTest();
        if(orderListBeforeTrigger.size() > 0) {
        update orderToUpdate;
        }
        Test.stopTest();
        
        Order orderForTest = [SELECT Id, NetAmount__c, TotalAmount, Name, ShippingCost__c FROM ORDER WHERE Name = 'forTestUpdate'];
        System.assertEquals(90, orderForTest.NetAmount__c, 'before updating Order, the field NetAmount__c on one of the records of Order should  equal 5750.00.');
    }

}