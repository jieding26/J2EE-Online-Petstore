package org.mybatis.jpetstore.web.actions;

import javax.servlet.http.HttpSession;

import net.sourceforge.stripes.action.ForwardResolution;
import net.sourceforge.stripes.action.Resolution;
import net.sourceforge.stripes.action.SessionScope;
import net.sourceforge.stripes.integration.spring.SpringBean;

import org.mybatis.jpetstore.domain.Account;
import org.mybatis.jpetstore.domain.Order;
import org.mybatis.jpetstore.service.DataMiningService;

/**
 * 添加代码1
 * 开始
 * 用于接收Main.jsp传来的请求，并调用后台的DataMiningService来完成相应业务处理
 * @author imac
 *
 */

@SessionScope
public class DataMiningActionBean extends AbstractActionBean {

	private static final long serialVersionUID = -4038684592582714735L;

	private static final String MAIN = "/WEB-INF/jsp/catalog/Main.jsp";
	private static final String CART="/WEB-INF/jsp/cart/Cart.jsp";
	@SpringBean
	private DataMiningService dataMiningService;

	private Order order = new Order();


	private String resultStr;
	private String resultStr1;

	private String minSupport;

	public String getMinSupport() { //获得最小支持度
		return minSupport;
	}

	public void setResultStr(String resultStr) { //设置结果项集并返回给本类中的resultStr
		this.resultStr = resultStr;
	}
	public void setResultStr1(String resultStr1) { //设置结果项集并返回给本类中的resultStr
		this.resultStr1 = resultStr1;
	}

	public String getResultStr() { //返回结果项集给前段界面
		return resultStr;
	}
	public String getResultStr1() { //返回结果项集给前段界面
		return resultStr1;
	}
	
/**
 * 添加代码1
 * 结束
 */
	
	
	private String amount;

	private String initDataStr;

	private String[][] initData;

	public String getInitDataStr() {
		return initDataStr;
	}

	public void setInitDataStr(String initDataStr) {
		this.initDataStr = initDataStr;

	}

	public String getAmount() {
		return amount;
	}

	public void setAmount(String amount) {
		this.amount = amount;
	}

	public void setMinSupport(String minSupport) {
		this.minSupport = minSupport;
	}

	public Resolution generatingOrders() {

		String[] lineData = initDataStr.split(",");

		initData = new String[lineData.length][];
		for (int i = 0; i < lineData.length; i++)
			initData[i] = lineData[i].split(":");

		dataMiningService.clearOrders();//清除所有商品订单

		HttpSession session = context.getRequest().getSession();
		AccountActionBean accountBean = (AccountActionBean) session
				.getAttribute("/actions/Account.action");
		if (accountBean == null || !accountBean.isAuthenticated()) {
			setMessage("You must sign on before attempting to generator orders.  Please sign on and try checking out again.");
			return new ForwardResolution(AccountActionBean.class);
		}

		Account acc = accountBean.getAccount();

		dataMiningService.setAccountInfo(acc);

		dataMiningService.GeneratingOrders(initData, amount);//生成商品订单

		resultStr = "Thank you, " + amount + " records has been loaded.";

		return new ForwardResolution(MAIN);

	}

	public Resolution DataMiningOrderRelations() {

		dataMiningService.setMinSupport(minSupport);
		dataMiningService.DataMiningOrderRelations();
		resultStr = dataMiningService.getResultStr();

		return new ForwardResolution(MAIN);
	}
	public Resolution RecommendPost(){
		dataMiningService.DataMiningOrderRelations();
		resultStr1=dataMiningService.getResultStr1();
		return new ForwardResolution(MAIN);
	}
}
