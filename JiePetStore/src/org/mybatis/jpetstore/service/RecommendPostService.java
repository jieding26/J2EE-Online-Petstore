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
import org.mybatis.jpetstore.domain.Category;
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
public class RecommendPostService {

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
	
	void writeResult(List<ArrayList<String>> setList, int i) {   

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
	
	public List<Relationship> getRelationsByItemId(String itemId){
	    return relationshipMapper.getRelationsByItemId(itemId);
	  }

}
