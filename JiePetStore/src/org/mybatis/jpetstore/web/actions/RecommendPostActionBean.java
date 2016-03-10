package org.mybatis.jpetstore.web.actions;
import javax.servlet.http.HttpSession;
import java.util.List;

import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.SessionScope;
import net.sourceforge.stripes.integration.spring.SpringBean;

import org.mybatis.jpetstore.domain.Account;
import org.mybatis.jpetstore.domain.Order;
import org.mybatis.jpetstore.domain.Item;
import org.mybatis.jpetstore.domain.Relationship;
import org.mybatis.jpetstore.service.RecommendPostService;

public class RecommendPostActionBean extends AbstractActionBean{
	
	private static final long serialVersionUID = -4038684592582714735L;

	private static final String VIEW_RECOMMEND = "/WEB-INF/jsp/catalog/Cart.jsp";
	@SpringBean
	private RecommendPostService recommendPostService;
	
	private Item item;
	private List<Relationship> relationshipList;
	private String itemId;
	
	public String getItemId() {
	    return itemId;
	  }

	  public void setItemId(String itemId) {
	    this.itemId = itemId;
	  }

	public ForwardResolution viewRecommend() {
	   
	      relationshipList = recommendPostService.getRelationsByItemId(itemId);
	    
	    return new ForwardResolution(VIEW_RECOMMEND);
	  }
	public Resolution RecommendPost(){
		dataMiningService.DataMiningOrderRelations();
		resultStr1=dataMiningService.getResultStr1();
		return new ForwardResolution(MAIN);
	}


}
