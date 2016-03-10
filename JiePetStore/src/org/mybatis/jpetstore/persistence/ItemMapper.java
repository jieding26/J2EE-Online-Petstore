package org.mybatis.jpetstore.persistence;

import java.util.List;
import java.util.Map;

import org.mybatis.jpetstore.domain.Item;

public interface ItemMapper {

  void updateInventoryQuantity(Map<String, Object> param);

  int getInventoryQuantity(String itemId);

  List<Item> getItemListByProduct(String productId);
  
  List<Item> getItemList();

  Item getItem(String itemId);
  
  //Item getItemById(String itemId); 
}
