public with sharing class  ProductSelector {
	public static Product2 getProduct(String productName){
        Product2 productToReturn = [SELECT Id,
                                    Name,
                                    IsActive
                                    FROM Product2
                                    WHERE Name = :productName
                                    LIMIT 1];
        return productToReturn;
    }
}