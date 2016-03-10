package org.mybatis.jpetstore.domain;

import java.io.Serializable;

public class Relationship implements Serializable {
	
	private String relation;
	
	public Relationship(){
		
	}
	
	public Relationship(String relation){
		this.relation = relation;
		
	}

	public void setRelation(String relation) {
		this.relation = relation;
	}

	public String getRelation() {
		return relation;
	}

}
