public with sharing class OrderServices {

    public static void updateOrdersStatusToActivated(Order order){
        Order orderUpdated = order;
        
        if(orderUpdated.Status != 'Activated'){
           orderUpdated.Status = 'Activated';
           }
        
        update orderUpdated;
    }

    public static List<Order> updateOrdersListStatusToActivated(List<Order> orderList){

        for(Order orderCurrent : orderList){
            orderCurrent.Status = 'Activated';
        }
        update orderList;
        return orderList;
    }

    public static Set<Order> convertOrderListIntoSet(List<Order> ordersList){
        Set<Order> ordersSet = new Set<Order>();
        for(Order orderCurrent : ordersList){
            ordersSet.add(orderCurrent);
        }
        return ordersSet;
    }
}