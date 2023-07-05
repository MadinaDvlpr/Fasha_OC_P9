@isTest
public with sharing class ProductDataFactoryTest {

    private static String productName = 'Bidule';
    @TestSetup

    static void setupFor_ProductDataFactoryTest(){
        List<Product2> productsToInsertFortTest = new List<Product2>();
        productsToInsertFortTest.add(new Product2 (
            Name = productName,
            IsActive = true
        ));
        insert productsToInsertFortTest;
    }

    @isTest
    static void testGetProduct(){
        Test.startTest();
        Product2 productToTest = ProductSelector.getProduct(productName);
        Test.stopTest();
        System.assertEquals(productToTest.Name, productName, 'ProductDataFactory.getProduct should get at least one record of Product.'); 
    }

    @isTest
    static void testCreateProduct(){
        String productName2 = 'Machin';
        Test.startTest();
        TestDataFactory.createProduct(productName2);
        Test.stopTest();
        Product2 productToTest = ProductSelector.getProduct(productName);
        System.assertEquals(productToTest.Name, productName, 'ProductDataFactory.createProduct should crete at least one record of Product.'); 
    }
}