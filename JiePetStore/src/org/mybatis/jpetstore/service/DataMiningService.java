package org.mybatis.jpetstore.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Random;
import java.math.BigDecimal;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.client.HTable;
import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.util.Bytes;
import org.mybatis.jpetstore.domain.Account;
import org.mybatis.jpetstore.domain.Item;
import org.mybatis.jpetstore.domain.LineItem;
import org.mybatis.jpetstore.domain.Order;
import org.mybatis.jpetstore.domain.Relationship;
import org.mybatis.jpetstore.domain.Sequence;
import org.mybatis.jpetstore.persistence.ItemMapper;
import org.mybatis.jpetstore.persistence.LineItemMapper;
import org.mybatis.jpetstore.persistence.OrderMapper;
import org.mybatis.jpetstore.persistence.RelationshipMapper;
import org.mybatis.jpetstore.persistence.SequenceMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class DataMiningService {

	@Autowired
	private ItemMapper itemMapper;
	@Autowired
	private OrderMapper orderMapper;
	@Autowired
	private SequenceMapper sequenceMapper;
	@Autowired
	private LineItemMapper lineItemMapper;
	@Autowired
	private RelationshipMapper relationshipMapper;
	

	private String resultStr="";
	private String resultStr1="";
	

	public String getResultStr() {
		return resultStr;
	} //返回商品频繁项集结果
	public String getResultStr1() {
		return resultStr1;
	}

	private Account account;
	
	/**
	 * 设置用户信息
	 * @param acc 用户信息
	 */
	public void setAccountInfo(Account acc) {
		account = acc;
	}
		
	int maxNum = 100; //默认最大订单生成数
	final int genDataBegin=100000; //自动生成数据的起始订单号
	
	/**
	 * 生成订单主函数
	 * @param initData 商品组合及支持度条件
	 * @param amount 订单样本总数
	 */
	public void GeneratingOrders(String[][] initData,String amount){

		if (amount != null)
			maxNum = Integer.parseInt(amount);

		for(int i=0;i<initData.length;i++){
			String[] currentList=Arrays.copyOf(initData[i],initData[i].length - 1);
			float minSupport = Float.parseFloat(initData[i][initData[i].length-1]);
			putData(currentList, minSupport);
		}
		
		String[] vStr;

		vStr = new String[] { "EST-20", "EST-44"};

		List<Item> itemList = itemMapper.getItemList(); //循环所有订单，为每个订单随机设置商品
		
		for(int orderId=genDataBegin;orderId<maxNum+genDataBegin;orderId++){
			//当前订单随机生成的商品数量，该数量在1和6之间
			int currentRandomItemCount = new Random().nextInt(6)+1;
			
			System.out.println("订单编号"+orderId+"当前生成的"+currentRandomItemCount);
			
			String[] randomItemIdList=new String[currentRandomItemCount];//随机商品列表
			for(int i=0;i<currentRandomItemCount;i++){
				//当前加入的随机商品
				Item randomItem=itemList.get(new Random().nextInt(itemList.size()));
				randomItemIdList[i]= randomItem.getItemId();
			}
			
			
			processOrder(randomItemIdList,orderId);
		}
	}

	/**
	 * 清除所有样本订单
	 */
	public void clearOrders() {
		
		orderMapper.deleteAllOrders();
		orderMapper.deleteAllOrderStatus();
		lineItemMapper.deleteAllLineItems();
	}

	/**
	 * 生成满足支持度的特定商品组合数据
	 * @param vStr 订单组合
	 * @param supportRate 支持度
	 */
	public void putData(String[] vStr, float supportRate) {
		
		HashMap hmSelectOrders = new HashMap();
		while(hmSelectOrders.keySet().size()!=Math.round(supportRate*maxNum)){				
			int orderId = new Random().nextInt(maxNum)+genDataBegin;
			if(!hmSelectOrders.keySet().contains(orderId)){
				hmSelectOrders.put(orderId, "");
				processOrder(vStr, orderId);
			}

		}
		
	}

	/**
	 * 将订单号为orderId的订单组合保存
	 * @param itemIdList
	 * @param orderId
	 */
	public void processOrder(String[] itemIdList, int orderId) {

		if (orderMapper.getOrder(orderId) == null) {
			Order order = new Order();
			order.initOrderWithAccount(account);
			order.setOrderId(orderId);
			orderMapper.insertOrder(order);
		    orderMapper.insertOrderStatus(order);
		}
		for (int i = 0; i < itemIdList.length; i++) {
			LineItem litem = new LineItem();
			litem.setItemId(itemIdList[i]);
			litem.setOrderId(orderId);
			if (lineItemMapper.getLineItemsByItemId(litem) == null) {
				LineItem lineItem = new LineItem();
				lineItem.setLineNumber(getNextId("linenum"));
				lineItem.setOrderId(orderId);
				lineItem.setItemId(itemIdList[i]);
				Item item = itemMapper.getItem(litem.getItemId());
				lineItem.setUnitPrice(item.getListPrice());
				lineItem.setQuantity(new Random().nextInt(200));// 随机生成小于200的数量
				lineItemMapper.insertLineItem(lineItem);
			}
		}

	}
	

	HTable hLineItemTable;

	//////////////////////
	//����HBase���붩�����
	//////////////////////
	public void processOrderByHBase(String[] itemIdList, int orderId)throws Exception {

		Configuration hbaseConfig = HBaseConfiguration.create();
		hLineItemTable = new HTable(hbaseConfig, "LineItem");
		hLineItemTable.setAutoFlush(false);
		hLineItemTable.setWriteBufferSize(1024 * 1024 * 12);
		
		if (orderMapper.getOrder(orderId) == null) {
			Order order = new Order();
			order.initOrderWithAccount(account);
			order.setOrderId(orderId);
			orderMapper.insertOrder(order);
		    orderMapper.insertOrderStatus(order);
		}
		for (int i = 0; i < itemIdList.length; i++) {
			LineItem litem = new LineItem();
			litem.setItemId(itemIdList[i]);
			litem.setOrderId(orderId);
			if (lineItemMapper.getLineItemsByItemId(litem) == null) {
				int linenum= getNextId("linenum");
			     Put put = new Put(Bytes.toBytes( Integer.toString(orderId) + Integer.toString(linenum)));
		         put.add(Bytes.toBytes("details"), Bytes.toBytes("orderid"), Bytes.toBytes(orderId));
		         put.add(Bytes.toBytes("details"), Bytes.toBytes("linenum"), Bytes.toBytes(getNextId("linenum")));
		         put.add(Bytes.toBytes("details"), Bytes.toBytes("itemid"), Bytes.toBytes(itemIdList[i]));
		         put.add(Bytes.toBytes("details"), Bytes.toBytes("quantity"), Bytes.toBytes(new Random().nextInt(200)));// ������С��200������
				 Item item = itemMapper.getItem(litem.getItemId());
		         put.add(Bytes.toBytes("details"), Bytes.toBytes("unitprice"), Bytes.toBytes(String.valueOf(item.getListPrice())));
		         hLineItemTable.put(put);
			}
		}
		
		hLineItemTable.flushCommits();
		hLineItemTable.close();

	}
	
	/**
	 * 获取名字为name的下一个Sequence值
	 * @param name
	 * @return
	 */
	public int getNextId(String name) {
		Sequence sequence = new Sequence(name, -1);
		sequence = (Sequence) sequenceMapper.getSequence(sequence);
		if (sequence == null) {
			throw new RuntimeException(
					"Error: A null sequence was returned from the database (could not get next "
							+ name + " sequence).");
		}
		Sequence parameterObject = new Sequence(name, sequence.getNextId() + 1);
		sequenceMapper.updateSequence(parameterObject);
		return sequence.getNextId();
	}

/**
 * 添加代码1
 * 开始
 * 功能：主要完成Apriori算法
 * @author imac
 */
////////////////////////////////////////	
    /**
     * 
     * Apriori算法主体
     * 
     */
///////////////////////////////////////	
	 private float minSupport;
     
	    public void setMinSupport(String minSupport) {   
	        this.minSupport = Float.parseFloat(minSupport);   
	    }  //设置最小支持度 
	    
	    /**
	     * 获得商品频繁项集的主函数
	     */
		public void DataMiningOrderRelations(){ 
			
			resultStr="";
			resultStr1="";
			relationshipMapper.deleteAllRelationships(); //每次挖掘都将上次的记录全部删除
			long startTime = System.currentTimeMillis(); //记录算法的开始时间 
			
				/**
				 * 每一个ArrayList<String>都是一个项集
				 * 每一个List<ArrayList<String>>都是一个CandidateItemSet/FrequentItemSet
				 */
			    List<ArrayList<String>> l1= new ArrayList<ArrayList<String>>(); //构造频繁1项集l1  
		        List<Item> itemList = itemMapper.getItemList();//订单
		        Iterator<Item> items = itemList.iterator();//订单中的每个商品(遍历，iterator)
		        while(items.hasNext()){
		        	/**
		        	 * 将订单中的每个商品的ID添加到l1中
		        	 * 按照Apriori算法，应该是添加到c1中，但由于我们在生成订单时就已经满足minSup,所以省略了c1这一步
		        	 * 直接生成l1
		        	 */
		        	ArrayList<String> itemSet = new ArrayList<String>();   
		        	itemSet.add((items.next().getItemId()));//添加商品ID到每一个itemSet中
		        	l1.add(itemSet);
		        }
		        List<ArrayList<String>> ln=l1;
		        int i = 2;   
		        do{   
		        	ln = dataMiningByApriori(ln);//the join step (A) 
		        	ln =checkSupport(ln);//the prune step
		        	if(ln.size()>0)writeResult(ln, i);
		            i++;   
		        }while(ln.size() != 0);
		        
		        long endTime = System.currentTimeMillis();   
		        resultStr+= "共用时：" + (endTime - startTime) + "ms";
		        System.out.println(resultStr);
		        System.out.println(resultStr1);
			
		}
	  
	    /**  
	     * 利用dataMiningByApriori方法由k-1商品项集生成k商品项集  
	     * the join step (A)
	     * @param initialList  
	     * @return  
	     */  
	List<ArrayList<String>> dataMiningByApriori(List<ArrayList<String>> initialList) {

		List<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
		int preSetSize = initialList.size();//itemSet的个数
		for (int i = 0; i < preSetSize - 1; i++) {
			for (int j = i + 1; j < preSetSize; j++) {
				String[] strA1 = initialList.get(i).toArray(new String[0]);//将第i个项集提取出来
				String[] strA2 = initialList.get(j).toArray(new String[0]);//将第j个项集提取出来
				if (isCanLink(strA1, strA2)) { //如果i，j两个k-1项集可以连接成k项集
					ArrayList<String> arr = new ArrayList<String>();
					for (String str : strA1) {//将i项集的每一个元素添加到新的k项集中
						arr.add(str);
					}
					arr.add((String) strA2[strA2.length - 1]); //将j的最后一个元素添加，连接成k项集
					//判断k项集是否需要剪切掉，如果不需要被剪切掉，则加入到k项集列表中
					if (!isNeedCut(initialList, arr)) {
						result.add(arr);
					}
				}

			}
		}
		return result;
	}
	
	/**
	 * 获得候选商品N项集setList中满足minSupport的频繁项集列表
	 * @param setList
	 * @return
	 */
	List<ArrayList<String>> checkSupport(List<ArrayList<String>> setList) {

		List<ArrayList<String>> result = new ArrayList<ArrayList<String>>();

		Iterator<ArrayList<String>> items = setList.iterator();
		while (items.hasNext()) {
			ArrayList<String> currentItemSet =items.next();
			
			int orderNum = orderMapper
					.getOrdersNumByItemList(currentItemSet,currentItemSet.size());
			if (orderNum >= Math.round(minSupport*orderMapper.getTotalOrderCount())) {
				result.add(currentItemSet);
			}

		}
		return result;
	}
	    
	    /**  
	     * 判断两个项集能否执行连接操作  
	     * @param s1 第一个项集 
	     * @param s2 第二个项集
	     * @return  
	     */  
	    boolean isCanLink(String[] s1, String[] s2) {   
	  
	        boolean flag = true;   
	        if (s1.length == s2.length) {   
	            for (int i = 0; i < s1.length - 1; i++) {   
	                if (!s1[i].equals(s2[i])) {   
	                    flag = false;   
	                    break;   
	                }   
	            }   
	            if (s1[s1.length - 1].equals(s2[s2.length - 1])) {   
	                flag = false;   
	            }   
	        } else {   
	            flag = false;   
	        }   
	  
	        return flag;   
	    }   
	  
	    /**  
	     * 判断set是否需要被剪切 
	     * @param setList 候选项集ck 
	     * @param set  k项集
	     * @return  
	     */  
	    boolean isNeedCut(List<ArrayList<String>> setList, ArrayList<String> set) {  
	        boolean flag = false;   
	        List<ArrayList<String>> subSets = getSubset(set); // 获得k项集的所有k－1项集  
	        for (ArrayList<String> subSet : subSets) {   
	            // 判断当前的k－1项集set是否在频繁k－1项集中出现，如出现，则不需要剪切   
	            // 如没有出现，则需要被剪切
	            if (!isContained(setList, subSet)) {   
	                flag = true;   
	                break;   
	            }   
	        }   
	        return flag;   
	    }   
	  
	    /**  
	     * 判断k项集的某k－1项集是否包含在频繁k－1项集列表中   
	     * i.e. subSet testing
	     * @param setList  
	     * @param set  
	     * @return  
	     */  
	    boolean isContained(List<ArrayList<String>> setList, ArrayList<String> set) {   
	  
	        boolean flag = false;   
	        int position = 0;   
	        for (ArrayList<String> s : setList) { //遍历l(k-1)中的每一个项集  
	            String[] sArr = s.toArray(new String[0]); //l(k-1)的每一个项集  
	            String[] setArr = set.toArray(new String[0]);   
	            
	            for (int i = 0; i < sArr.length; i++) { //遍历l(k-1)每一个项集的每一个项目  
	                if (sArr[i].equals(setArr[i])) {    
	                    position = i;//如果对应位置的元素相同，则置position为当前位置的值   
	                } 
	                else {   
	                    break;//否则跳出loop   
	                }   
	            } 
	            
	            if (position == sArr.length - 1) {
	            	// 如果position等于了数组的长度，则说明已找到某个setList中的项集与set项集相同了，退出循环，返回包含   
	                flag = true;   
	                break;   
	            } 
	            else { // 否则，把position置为0进入下一个项集比较     
	                flag = false;   
	                position = 0;   
	            }   
	  
	        }   
	        return flag;   
	    }   
	  
	    /**  
	     * 获得k项集所有的k－1项集    
	     * @param set  
	     * @return  
	     */  
	    List<ArrayList<String>> getSubset(ArrayList<String> set) {   
	  
	        List<ArrayList<String>> result = new ArrayList<ArrayList<String>>();   
	        String[] setArr = set.toArray(new String[0]);   
	        for (int i = 0; i < setArr.length; i++) {   
	        	ArrayList<String> subSet = new ArrayList<String>();   
	            for (int j = 0; j < setArr.length; j++) {   
	                if (i != j) {   
	                    subSet.add((String) setArr[j]);   
	                }   
	            }   
	            result.add(subSet);   
	        }   
	        return result;   
	    }   
	  
	    /**
	     * 将商品频繁项集分析结果存储在Relationship表中
	     * @param setList
	     * @param i
	     * @return
	     */
	    void writeResult(List<ArrayList<String>> setList, int i) {   

	    	resultStr+="频繁"+i+"项集：共" +  setList.size()+"项：\n";
	    	resultStr1+="推荐"+i+"组合商品：共" +  setList.size()+"项：\n";
	        for (ArrayList<String> set : setList) {   
	        	String list="";
	            for (String str : set) {   
	            	list+=str+",";
	            	resultStr+= str + " ";
	            	resultStr1+= str + " ";
	            }   
	            Relationship r=new Relationship(list);
	            relationshipMapper.insertRelationShip(r);
	            resultStr+=", ";
	            resultStr1+=", ";
	        }   
	        resultStr+="\n";
	        resultStr1+="\n";
	       
	    }   

/**
 * 添加代码1
 * 结束	
 * @param order
 * @return
 */
	
	    public ArrayList<Item> getInterestedItems(Order order) {
			ArrayList<Item> itemResultList =new ArrayList<Item>();
			HashMap<String, String> hmItems = new HashMap<String, String>();
			//循环每一个订单条目，找到相关联的商品
			for (int i = 0; i < order.getLineItems().size(); i++) {
				List<Relationship> rList = relationshipMapper
						.getRelationsByItemId("%"+order.getLineItems().get(i).getItemId()+",%");
				if (rList.size() > 0) {
					for (int j = 0; j < rList.size(); j++) {
						String[] items = rList.get(j).getRelation().split(",");
						for (int k = 0; k < items.length; k++) {
							if (!hmItems.containsKey(items[k]))
								hmItems.put(items[k], "");
						}
					}
				}
			}
			
			//去掉订单中重复的商品
			for (int i = 0; i < order.getLineItems().size(); i++) {
				String  itemId= order.getLineItems().get(i).getItemId();
					if(hmItems.containsKey(itemId)){
						hmItems.remove(itemId);
					}
			}

			Object[] interestedItems;
			if (hmItems.keySet().size() > 0) {
				interestedItems =hmItems.keySet().toArray();
				for (int i = 0; i < interestedItems.length; i++) {
					itemResultList.add(itemMapper.getItem(interestedItems[i].toString()));
				}
			}
			return itemResultList;
		}

}
