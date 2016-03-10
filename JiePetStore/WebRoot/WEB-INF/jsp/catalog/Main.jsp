<%@ include file="../common/IncludeTop.jsp"%>

<div id="Welcome">
<div id="WelcomeContent"><c:if
	test="${sessionScope.accountBean != null }">
	<c:if test="${sessionScope.accountBean.authenticated}">
        Welcome ${sessionScope.accountBean.account.firstName}!
    <stripes:link
		beanclass="org.mybatis.jpetstore.web.actions.AccountActionBean"
		event="Recommend">
          Find Recommend Products for You!
	    </stripes:link>
      </c:if>
</c:if></div>
</div>

<div id="Main">
<div id="Sidebar">
<div id="SidebarContent"><stripes:link
	beanclass="org.mybatis.jpetstore.web.actions.CatalogActionBean"
	event="viewCategory">
	<stripes:param name="categoryId" value="FISH" />
	<img src="../images/fish_icon.gif" />
</stripes:link> <br />
Saltwater, Freshwater <br />
<stripes:link
	beanclass="org.mybatis.jpetstore.web.actions.CatalogActionBean"
	event="viewCategory">
	<stripes:param name="categoryId" value="DOGS" />
	<img src="../images/dogs_icon.gif" />
</stripes:link> <br />
Various Breeds <br />
<stripes:link
	beanclass="org.mybatis.jpetstore.web.actions.CatalogActionBean"
	event="viewCategory">
	<stripes:param name="categoryId" value="CATS" />
	<img src="../images/cats_icon.gif" />
</stripes:link> <br />
Various Breeds, Exotic Varieties <br />
<stripes:link
	beanclass="org.mybatis.jpetstore.web.actions.CatalogActionBean"
	event="viewCategory">
	<stripes:param name="categoryId" value="REPTILES" />
	<img src="../images/reptiles_icon.gif" />
</stripes:link> <br />
Lizards, Turtles, Snakes <br />
<stripes:link
	beanclass="org.mybatis.jpetstore.web.actions.CatalogActionBean"
	event="viewCategory">
	<stripes:param name="categoryId" value="BIRDS" />
	<img src="../images/birds_icon.gif" />
</stripes:link> <br />
Exotic Varieties <br />

<!-- 添加代码2
 开始
 -->
<div id="GeneratingOrdersDiv">
<stripes:form beanclass="org.mybatis.jpetstore.web.actions.DataMiningActionBean">
<!-- org.mybatis.jpetstore.web.actions.DataMiningActionBean为程序用于生成商品频繁集将要调用的后台服务类名 -->
	   <div>initial data:</div><stripes:textarea name="initDataStr" style="width:300px;height:100px" value="EST-20:EST-44:0.3,EST-21:EST-43:EST-42:0.15,EST-32:EST-30:0.25,EST-18:EST-32:EST-30:0.25,EST-34:EST-35:0.2,EST-01:EST-02:0.2"/>
	   <!-- initDataStr是商品组合及支持度的初始化数据
	    amount是订单样本总数
	    在initDataStr中不同的商品组合之间用“，”隔开，同一组合的每种商品用“：”隔开，且最后一个“：”后是支持度数据
	    -->
	   <div>expect amount:</div><stripes:text name="amount" size="14" value="100" />
	<stripes:submit name="generatingOrders" value="Generating Orders" />
</stripes:form>
</div>
<!-- 添加代码2
 结束 -->

<!-- 添加代码1
 开始
 用于对JPetStore主界面的调整，通过在街面上添加按钮的方式来生成分析结果
 --> 
<div id="DataMiningOrderRelationsDiv">
<stripes:form beanclass="org.mybatis.jpetstore.web.actions.DataMiningActionBean">
	<div>minimum Support(%):</div><stripes:text name="minSupport" size="14" value="0.2"/>
	<stripes:submit name="DataMiningOrderRelations" value="Find Interested Products!" />
	<!-- DataMiningOrderRelations为需要调用的业务方法名称 -->
</stripes:form>
</div>
<div id="RecommendPostDiv">
<stripes:form beanclass="org.mybatis.jpetstore.web.actions.DataMiningActionBean">
	<stripes:submit name="RecommendPost" value="Post Recommend Products" />
	<!-- DataMiningOrderRelations为需要调用的业务方法名称 -->
</stripes:form>
</div>

<!-- 用于显示上述方法调用的结果反馈信息 -->
<div id="ResultDiv">
<stripes:form beanclass="org.mybatis.jpetstore.web.actions.DataMiningActionBean">
	   <div>Result:</div><stripes:textarea name="resultStr" style="width:400px;height:150px"/>
</stripes:form>
</div>

<!-- 添加代码1
 结束 -->

</div>
</div>

<div id="MainImage">
<div id="MainImageContent">
  <map name="estoremap">
	<area alt="Birds" coords="72,2,280,250"
		href="Catalog.action?viewCategory=&categoryId=BIRDS" shape="RECT" />
	<area alt="Fish" coords="2,180,72,250"
		href="Catalog.action?viewCategory=&categoryId=FISH" shape="RECT" />
	<area alt="Dogs" coords="60,250,130,320"
		href="Catalog.action?viewCategory=&categoryId=DOGS" shape="RECT" />
	<area alt="Reptiles" coords="140,270,210,340"
		href="Catalog.action?viewCategory=&categoryId=REPTILES" shape="RECT" />
	<area alt="Cats" coords="225,240,295,310"
		href="Catalog.action?viewCategory=&categoryId=CATS" shape="RECT" />
	<area alt="Birds" coords="280,180,350,250"
		href="Catalog.action?viewCategory=&categoryId=BIRDS" shape="RECT" />
  </map> 
  <img height="355" src="../images/splash.gif" align="middle"
	usemap="#estoremap" width="350" /></div>
</div>

<div id="DataMiningPost">
   
  
</div>

<div id="Separator">&nbsp;</div>
</div>

<%@ include file="../common/IncludeBottom.jsp"%>

