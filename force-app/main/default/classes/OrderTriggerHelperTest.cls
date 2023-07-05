@isTest
public class OrderTriggerHelperTest {
    // init class variables
    private static String productName = 'Test';
    private static String pricebookName = 'accountName-1\'s Price Book';
    private static String orderName = 'accountName-1\'s Order';
    private static String accountName = 'accountName-1';


    // set up
    @TestSetup
    static void setupFor_OrderTriggerHelperTest() {
        TestDataFactory.createAccounts(5);
        TestDataFactory.createPricebook(pricebookName);
        TestDataFactory.createProduct(productName);
        TestDataFactory.createAccount(accountName);

        //créer un compte unitairement
        // METTRE LA CREATION DES PRICEBOOK + PRODUCT + ORDER ITEM ICI


    }

    //Test Method get acc list to update
    @isTest
    public static void testUpdateListOfAccountsRevenueWhenOrderStatusActivated() {

        Pricebook2 pricebookForThisTest = PricebookSelector.getPriceBookByName(pricebookName);
        Product2 productForThisTest = ProductSelector.getProduct(productName);
        TestDataFactory.createPriceBookEntryForPricebookStandard(productForThisTest);
        TestDataFactory.createPriceBookEntry(pricebookForThisTest, productForThisTest);

        List<Order> orderList = OrderSelector.getOrdersAll();
        List<OrderItem> orderItemsList = new List<OrderItem>();
        PricebookEntry pricebookEntryForThisTest = PricebookSelector.getPricebookEntry(pricebookForThisTest, productForThisTest);
        for (Order orderCurent : orderList) {
            orderItemsList.add(TestDataFactory.createOneOrderItem(orderCurent, productForThisTest, pricebookEntryForThisTest));
        }
        insert orderItemsList;

        List<Order> orderListForTest = OrderSelector.getOrdersAll();

        Test.startTest();
        OrderServices.updateOrdersListStatusToActivated(orderListForTest);
        Test.stopTest();

        List<Order> orderListToTest = OrderSelector.getOrdersAll();

        System.assertNotEquals(orderListToTest.size(), 1, 'OrderTriggerHelper.updateListOfAccountsRevenueWhenOrderStatusActivated should update a list of Orders.');
    }


    //Test Method get acc list to update
    @isTest
    static void testGetAccountsListToUpdate() {
        List<Account> accountsListToTest = AccountSelector.getAccountsAll();
        Pricebook2 pricebookForThisTest = PricebookSelector.getPriceBookByName(pricebookName);
        Account account = [SELECT Id from Account Where Name = 'accountName-0' LIMIT 1];

        List<Order> ordersList = new List<Order>();
        Order orderForThisTest = TestDataFactory.createOrder(orderName, account.Id, pricebookForThisTest);
        ordersList.add(orderForThisTest);


        Set<Order> ordersSetNew = OrderServices.convertOrderListIntoSet(ordersList);
        Set<Account> accountsSetAll = AccountServices.convertAccountListIntoSet(accountsListToTest);

        Test.startTest();
        List<Account> accountListToTest = OrderTriggerHelper.getAccountsListToUpdate(ordersSetNew, accountsSetAll);
        Test.stopTest();

        System.assertEquals(6, accountListToTest.size(), 'OrderTriggerHelper.getAccountsListToUpdate should return a list of 6.');
    }


    @isTest
    public static void testGetOrdersListWithUpdatedNetAmounts() {
        Pricebook2 pricebookForThisTest = PricebookSelector.getPriceBookByName(pricebookName);
        Product2 productForThisTest = ProductSelector.getProduct(productName);
        TestDataFactory.createPriceBookEntryForPricebookStandard(productForThisTest);
        TestDataFactory.createPriceBookEntry(pricebookForThisTest, productForThisTest);
        Account account = [SELECT Id from Account Where Name = 'accountName-0' LIMIT 1];
        List<Order> ordersList = new List<Order>();
        Order orderForThisTest = TestDataFactory.createOrder(orderName, account.Id, pricebookForThisTest);
        ordersList.add(orderForThisTest);

        List<OrderItem> orderItemsList = new List<OrderItem>();

        PricebookEntry pricebookEntryForThisTest = PricebookSelector.getPricebookEntry(pricebookForThisTest, productForThisTest);
        for (Order orderCurrent : ordersList) {
            orderItemsList.add(TestDataFactory.createOneOrderItem(orderCurrent, productForThisTest, pricebookEntryForThisTest));
        }
        insert orderItemsList;
        OrderServices.updateOrdersListStatusToActivated(ordersList);
        Test.startTest();
        ordersList = OrderServices.updateOrdersListStatusToActivated(ordersList);
        Test.stopTest();
        List<Order> orderListToTest = [SELECT Id, NetAmount__c, TotalAmount, ShippingCost__c FROM Order WHERE Id = :ordersList.get(0).Id];

        System.debug('-------------------DESSSSS------------------');
        System.debug(orderListToTest.get(0));
        System.assertEquals(orderListToTest.size(), 1, 'OrderTriggerHelper.getOrdersListWithUpdatedNetAmounts should return a list of 5.');
        System.assertEquals(90, orderListToTest.get(0).NetAmount__c, 'OrderTriggerHelper.getOrdersListWithUpdatedNetAmounts should return a list of 5.');
    }


}