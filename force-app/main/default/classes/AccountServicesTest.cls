@isTest
public with sharing class AccountServicesTest {
    private static String accountName = 'MyAccountName';
    private static String nameLike = 'accountName-%';
    private static String pricebookName = 'MyPricebookName';
    private static String productName = 'Bidule';
    
    @TestSetup
    static void setupForOrderServiceTest(){
        TestDataFactory.createAccount(accountName);
        Account accountForThisTest = AccountSelector.getAccount(accountName);
        List <Order> ordersList = TestDataFactory.createAccountWithOrders(20, accountForThisTest.Id);
        TestDataFactory.createPricebook(pricebookName);
        TestDataFactory.createProduct(productName);
    }
    
    
   	@isTest
    public static void getAccountTest(){
        
        Test.startTest();
        Account accountToTest = AccountSelector.getAccount(accountName);
        Test.stopTest();

        System.assertEquals(accountToTest.name, accountName, 'getAccount(accountName) from AccountDataFactory should return only one Account record by the name of :'+accountName+3+'.');
    }

    @isTest
    public static void getAccountsAllTest(){
        List<Account> accountsListToInsertForTest = TestDataFactory.createAccounts(5);
        
        Test.startTest();
        List<Account> accountsListToTest = AccountSelector.getAccountsAll();
        Test.stopTest();

        System.assertEquals(6, accountsListToTest.size(), 'AccountDataFactory.getAccountsAll() should return a list of five records.');
    }
    
    @isTest
    static void getAccountsWhereOrderStatusActivatedTest(){
   
        TestDataFactory.createAccount('New Account Test');
        Account accountTest = AccountSelector.getAccount('New Account Test');
        List <Order> ordersListForAccount = TestDataFactory.createAccountWithOrders(50, accountTest.Id);

        List<Order> orderListToTest = OrderSelector.getOrdersAll();
        OrderServices.updateOrdersListStatusToActivated(ordersListForAccount);
               
        Test.startTest();
        List<Account> accountsListToTest = AccountSelector.getAccountsWhereOrderStatusActivated();
        Test.stopTest();

        System.assertEquals(1, accountsListToTest.size(), 'AccountDataFactory.getAccountsWhereOrderSatusOrdered should return 1 Account records.');
    } 

    @isTest
    public static void createAccountTest(){
        String accountForTest = 'MyAccountTest';

        Test.startTest();
        TestDataFactory.createAccount(accountForTest);
        Test.stopTest();
        List<Account> accountsListToTest = [SELECT Id,
                                            Chiffre_affaire__c,
                                            Name
                                            FROM Account
                                            WHERE Name= :accountForTest 
                                           ];

        System.assertEquals(accountsListToTest.size(), 1, 'createAccount(accountForTest) from TestDataFactory should create one record named '+accountForTest+'.');
    }    
    
    @isTest
    public static void createAccountsListTest(){
        Test.startTest();
        TestDataFactory.createAccountsList(3);
        Test.stopTest();
        List<Account> accountsListToTest = [SELECT Id,
                                            Chiffre_affaire__c,
                                            Name
                                            FROM Account
                                            WHERE Name LIKE :nameLike
                                           ];
        System.assertEquals(3, accountsListToTest.size(), 'AccountDataFactory.createAccountsList should create 3 records of Accounts.');
    }
    
    @isTest
    public static void convertAccountsListIntoMapOfIdsAndRevenuesTest(){
        TestDataFactory.createAccountsList(5);
        List<Account> accountsListToTest = [SELECT Id,
                                                    Chiffre_affaire__c,
                                                    Name
                                            FROM Account
                                            WHERE Name LIKE :nameLike
                                           ];
        Test.startTest();
        Map<Id,Decimal> accountsMapIdAndRevenueForTest = AccountServices.convertAccountsListIntoMapOfIdsAndRevenues(accountsListToTest);
        Test.stopTest();

        System.assertEquals(accountsMapIdAndRevenueForTest.size(), 5, 'AccountDataFactory.convertAccountsListIntoMapOfIdsAndRevenues should return a Map of Account.Ids and Account.AccountRevenues__c.');
    }
    
    @isTest
    static void convertAccountListIntoSetTest(){
        // insert some accounts
        List<Account> accountsListToInsert = TestDataFactory.createAccounts(5);
        
        List<Account> accountsListForThisTest = [SELECT Id,
                                                        Chiffre_affaire__c,
                                                        Name
                                                 FROM Account
                                                 WHERE Name LIKE 'accountName%' ];
        

        Test.startTest();
        Set<Account> accountSetForTest = AccountServices.convertAccountListIntoSet(accountsListForThisTest);
        Test.stopTest();

        System.assertEquals(5, accountSetForTest.size(), 'AccountDataFactory.convertAccountListIntoSet should convert a list of 5 into a set of 5.');
    }

}