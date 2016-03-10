package org.mybatis.jpetstore.persistence;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.mybatis.jpetstore.domain.Order;

public interface OrderMapper {

  List<Order> getOrdersByUsername(String username);

  Order getOrder(int orderId);
  
  void insertOrder(Order order);
  
  void insertOrderStatus(Order order);
  
  void deleteAllOrders();
  
  void deleteAllOrderStatus();
  
  int  getTotalOrderCount();

  int getOrdersNumByItemList(@Param("itemIds") ArrayList<String> itemIds,@Param("num") int num );
}
