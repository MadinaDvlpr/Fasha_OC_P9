@isTest
public with sharing class TestDataFactory {
    
    public static Account createAccount(String accountName) {
        Account account = new Account( Name = accountName);
        insert account;
        return account;
    }
    //Verifier si c'est bien ce que william voulait 
    //créer une liste de compte ICI poubelle pas bon ! (batch a faire dans une test data factory et mettre ds attributs de la classe) rappeler juste methode unitaire dans une boucle
    /**public static void createAccounts(Integer numberOfAccounts){
        List<Account> accountsListToInsertForTest = new List<Account>();
        for(Integer i = 0 ; i < numberOfAccounts ; i++){
            AccountServices.createAccount();
        }
        insert accountsListToInsertForTest;
    }
    
    public static void createAccount(){
        Account accountCreated = new Account(Name = 'accountName');
        insert accountCreated;
    }
    **/
    public static void createAccount(){
        Account accountCreated = new Account(Name = 'accountName');
        insert accountCreated;
    }
    
    public static List<Account> createAccounts(Integer numberOfaccounts) {
        List<Account> accounts = new List<Account>();
        
        for (Integer i = 0 ; i < numberOfaccounts; i++) {
            accounts.add(new Account(Name = 'accountName-'+i));
        }
        insert accounts;
        return accounts;
    }
   
    public static void createAccountsList(Integer numberOfAccounts){
        List<Account> accountsListToInsertForTest = new List<Account>();
        for(Integer i = 0 ; i < numberOfAccounts ; i++){
            accountsListToInsertForTest.add(new Account(Name = 'accountName-'+i));
        }
        insert accountsListToInsertForTest;
    }

    
    public static Product2 createProduct() {
        Product2 product = new Product2(
            IsActive =true,
            Name = 'ProductTest'
        );
        insert product;
        return product;
    }
    
            
    public static Order createOrder(Id accountId){         
        Order order = New Order (
            AccountId = accountId,
            Status ='Draft',
            EffectiveDate = Date.today(),
            Pricebook2Id = Test.getStandardPricebookId()
        );       
        insert order;
        return order;   
    }
    
    
    public static List<Order> createOrders(Account account, PricebookEntry pricebookEntry, Integer numberOrder) {
        List<Order> orders = new List<Order>();
        for(Integer i = 0; i < numberOrder; i++){
            Order order = TestDataFactory.createOrder(account.Id);
            order.Name='OrdersTest'+i;
            orders.add(order);
        }
        update orders;
        return orders;
    }     
    
    public static List<Order> createAccountWithOrders(Integer numberOrders, Id accountId){
        List<Order> orders = new List<Order>();
        for(Integer i=0; i<numberOrders; i++) {
            Order order = new Order(
                AccountId = accountId,
                Pricebook2Id = Test.getStandardPricebookId(),
                status = 'Draft',
                effectiveDate = Date.today()
            );
            orders.add(order);
        }
        insert orders;
        
        
        Product2 product2 = TestDataFactory.createProduct();
        PricebookEntry pricebookEntry = TestDataFactory.createPricebookEntry(product2.Id, 100);
        
        List<OrderItem> items = new List<OrderItem>();
        for(Order order: orders) {
            OrderItem item = new OrderItem (OrderId = order.Id, PricebookEntryId = pricebookEntry.Id, Quantity=1, UnitPrice = 100);
            items.add(item);
        }
        insert items;     
        update orders;
        return orders;
    }   
    
    public static OrderItem createOrderItem(Id orderId, Id productId, Integer quantity, Decimal unitPrice,  Id pricebookEntryId) {
        OrderItem orderItem = new OrderItem(
            OrderId = orderId,
            Product2Id= productId,
            Quantity = quantity,
            UnitPrice = unitPrice,
            PricebookEntryId= pricebookEntryId
        );
        insert orderItem;
        return orderItem;
    } 
    
    
    public static List<OrderItem> createOrderItems(Integer quantity, List<Order> orders, PricebookEntry pricebookEntry) {
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Order order : orders){
            OrderItem orderItem = new OrderItem(
                OrderId = order.Id,
                PricebookEntryId = pricebookEntry.Id,
                UnitPrice = pricebookEntry.UnitPrice,
                Quantity = quantity
            );
            orderItems.add(orderItem);
        }
        insert orderItems;
        return orderItems;
    }
    
    public static Order createOrder(String orderName, Id accountID, PriceBook2 pricebookForThisTest){
        Order orderCreated = new Order(
            Name = orderName,
            AccountId = accountID,
            Status = 'Draft',
            EffectiveDate = Date.today(),
            ShippingCost__c = 10,
            Pricebook2Id =  pricebookForThisTest.Id
        );
        insert orderCreated;
        return orderCreated;
    }
        
    public static Order createOrder(Id accountID, PriceBook2 pricebookForThisTest){
        Order orderCreated = new Order(
            AccountId = accountID,
            Status = 'Draft',
            EffectiveDate = Date.today(),
            ShippingCost__c = 10,
            Pricebook2Id =  pricebookForThisTest.Id
        );
        insert orderCreated;
        return orderCreated;
    }
    

    public static OrderItem createOneOrderItem(Order orderForThisTest, Product2 productForThisTest, PricebookEntry pricebookEntryForThisTest){
        OrderItem orderItemToInsert = new OrderItem(
            OrderId = orderForThisTest.id,
            Quantity = 1,
            UnitPrice = 100,
            Product2Id = productForThisTest.id,
            PricebookEntryId = pricebookEntryForThisTest.id
        );
        return orderItemToInsert;
    }
    

	public static void createOrdersListForAccounts(List<Account> accountsListForThisTest, PriceBook2 pricebookForThisTest){
        List<Order> ordersList = new List<Order>();
        String orderName = 'Order-';
        for(Account accountCurrent : accountsListForThisTest){
            ordersList.add(createOrder(orderName+accountCurrent.Name, accountCurrent.Id, pricebookForThisTest));
        }
        insert ordersList;
    }
    
    public static void createPricebook(String pricebookName){
        List<PriceBook2> pricebookToInsertForTest = new List<PriceBook2>();
        pricebookToInsertForTest.add( new PriceBook2 (
            Name = pricebookName,
            IsActive = true
        ));
        insert pricebookToInsertForTest;
    }
    
    public static PricebookEntry createPricebookEntry(Id productId, Decimal amount) {
        PricebookEntry pricebookEntry = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = productId,
            UnitPrice = amount,
            IsActive = false
        );
        insert priceBookEntry;
        return priceBookEntry;     
    }    
    
    public static PricebookEntry createPriceBookEntry(PriceBook2 pricebookForThisTest, Product2 productForThisTest){
        PricebookEntry priceBookEntryToInsert = new PricebookEntry(
            Pricebook2Id = pricebookForThisTest.Id,
            Product2Id = productForThisTest.Id,
            UnitPrice = 100.00,
            IsActive = true,
            UseStandardPrice = false);
        
        insert priceBookEntryToInsert;
        return priceBookEntryToInsert;
    }
    
    public static void createPriceBookEntryForPricebookStandard(Product2 product2ForThisTest){
        PricebookEntry priceBookEntryToInsert = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = product2ForThisTest.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert priceBookEntryToInsert;
    }
    
    public static void createProduct(String productName){
        List<Product2> productsToInsertFortTest = new List<Product2>();
        productsToInsertFortTest.add(new Product2 (
            Name = productName,
            IsActive = true
        ));
        insert productsToInsertFortTest;
    }
}