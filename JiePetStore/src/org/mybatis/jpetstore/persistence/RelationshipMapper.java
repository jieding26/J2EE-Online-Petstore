package org.mybatis.jpetstore.persistence;

import java.util.List;

import org.mybatis.jpetstore.domain.Relationship;

public interface RelationshipMapper {

	  List<Relationship> getRelationsByItemId(String itemId);
	  
	  void insertRelationShip(Relationship relation);
	  
	  void deleteAllRelationships();
	}
