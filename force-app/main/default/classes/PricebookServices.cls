public with sharing class PricebookServices {
	    
     public static void updadePriceBookEntryList(List<PriceBookEntry> pricebookEntryList){
        List<PriceBookEntry> pricebookEntryListToUpdate = new List<PriceBookEntry>();
        for(PriceBookEntry pricebookEntryCurent : pricebookEntryList){
            pricebookEntryCurent.UnitPrice = 300;
            pricebookEntryListToUpdate.add(pricebookEntryCurent);
        }
        update pricebookEntryListToUpdate;
    }
    
}