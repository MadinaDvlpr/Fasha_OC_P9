@isTest
public with sharing class PricebookServicesTest {
    
    // variables
    private static String accountName = 'Madina';
    private static String productName = 'Test';
    private static String pricebookName = 'Madina\'s Price Book';

    // set up
   @TestSetup
    static void setupFor_Pricebook2DataFactoryTest(){
        TestDataFactory.createAccount(accountName);
        Account accountForThisTest = AccountSelector.getAccount(accountName);
        TestDataFactory.createPricebook(pricebookName);
        
        TestDataFactory.createProduct(productName);
        Pricebook2 pricebookForThisTest = PricebookSelector.getPriceBookByName(pricebookName);
        Product2 productForThisTest = ProductSelector.getProduct(productName);
        
    }

     @isTest
    static void testUpdatePriceBookEntryList(){
        Pricebook2 pricebookForThisTest = PricebookSelector.getPriceBookByName(pricebookName);
        Product2 productForThisTest = ProductSelector.getProduct(productName);
        PricebookEntry priceBookEntryToInsert1 = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = productForThisTest.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert priceBookEntryToInsert1;
        PricebookEntry priceBookEntryToInsert2 = new PricebookEntry(
            Pricebook2Id = pricebookForThisTest.Id,
            Product2Id = productForThisTest.Id,
            UnitPrice = 100.00,
            IsActive = true,
            UseStandardPrice = false
        );
        insert priceBookEntryToInsert2;
        List<PricebookEntry> pricebookEntryListBeforeUpdate = PricebookSelector.getPricebookEntryAll();
        Test.startTest();
        PricebookServices.updadePriceBookEntryList(pricebookEntryListBeforeUpdate);
        Test.stopTest();

        List<PricebookEntry> pricebookEntryListForThisTest = PricebookSelector.getPricebookEntryAll();

        System.assertEquals(pricebookEntryListForThisTest[0].UnitPrice, 300, 'PricebookEntryDataFactory.updadePriceBookEntryList should update a List of PricebookEntries.');

    }
    
    @isTest
    static void testGetPriceBookByName(){
        List<PriceBook2> pricebookToInsertForTest = new List<PriceBook2>();
            pricebookToInsertForTest.add( new PriceBook2 (
                Name = pricebookName,
                IsActive = true
            ));
        insert pricebookToInsertForTest;

        Test.startTest();
        PriceBook2 pricebookToTest = PricebookSelector.getPriceBookByName(pricebookName);
        Test.stopTest();

        System.assertEquals(pricebookToTest.IsActive, true, 'Pricebook2DataFactory.getPriceBookByName should return one PriceBook2.');
    }
}