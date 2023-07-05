public without sharing class MyTeamOrdersController {
    
    public decimal SumOders{
        get{
            Id accountId = ApexPages.currentPage().getParameters().get('id');
            AggregateResult groupedResults = OrderSelector.getTotalSumOrdersByAccountId(accountId);
            return (decimal)groupedResults.get('total');
        }
        set; 
    }
    
    
    public  MyTeamOrdersController(ApexPages.StandardController controller){
        
    }
    
}