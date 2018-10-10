<%@page import="com.lymava.qier.activities.model.MarketingActivities"%>
<%@page import="com.lymava.qier.business.BusinessIntIdConfigQier"%>
<%@page import="com.lymava.qier.activities.guaguaka.GuaguakaShareBusiness"%>
<%@page import="com.lymava.qier.util.DiLiUtil"%>
<%@page import="com.lymava.trade.pay.model.PaymentRecord"%>
<%@page import="com.lymava.nosql.mongodb.util.MongoCommand"%>
<%@page import="com.lymava.qier.model.Merchant72"%>
<%@page import="com.lymava.nosql.util.QuerySort"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.qier.model.MerchantRedEnvelope"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@page import="com.lymava.qier.model.TradeRecord72"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.trade.business.model.Product"%>
<%@page import="com.lymava.trade.business.model.TradeRecord"%>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="header/check_openid.jsp"%>
<%@ include file="header/header_check_login.jsp"%>
<%
	Long currentTimeMillis =  System.currentTimeMillis();
	//获取红包的记录
	String balance_id = request.getParameter("balance_id");

	String tradeRecord_id = request.getParameter("tradeRecord_id");
	
	TradeRecord72 tradeRecord  = null;
	
	if(MyUtil.isValid(tradeRecord_id)){
		tradeRecord = (TradeRecord72) serializContext.get(TradeRecord72.class, tradeRecord_id);
	}
	
	currentTimeMillis =  System.currentTimeMillis();
	
	PaymentRecord paymentRecord  = null;
	 
	if(MyUtil.isValid(balance_id)){
		paymentRecord = (PaymentRecord) serializContext.get(PaymentRecord.class, balance_id);
	}
	
	currentTimeMillis =  System.currentTimeMillis();
	
	if(paymentRecord == null || tradeRecord == null){
		response.sendRedirect(MyUtil.getBasePath(request)+"user_center/my-red.jsp");
		return;
	}
	
	Merchant72 user_merchant = tradeRecord.getUser_merchant();
	
	User user_huiyuan = tradeRecord.getUser_huiyuan();
	
	//检查是否关注如果没关注红包减半 关注之后再红包翻倍
	GongzonghaoContent gongzonghaoContent_instance = GongzonghaoContent.getInstance();
	
	Integer subscribeUser_state = null;
	if(subscribeUser != null){
		subscribeUser_state = subscribeUser.getState();
	}
	
	String merchant72_type = user_merchant.getMerchant72_type();
	
	MerchantRedEnvelope merchantRedEnvelope_find = new MerchantRedEnvelope();
	//石全食美要发本店的红包
	String shiquanshimei_user_id = "5b91d8ded6c4591a1668d953"; 
	
	//如果不是石全食美
	if(!shiquanshimei_user_id.equals(user_merchant.getId())){
		//不能收到本店的红包
		merchantRedEnvelope_find.addCommand(MongoCommand.not_in, "userId_merchant", user_merchant.getId());
		//不收石全食美的红包
		merchantRedEnvelope_find.addCommand(MongoCommand.not_in, "userId_merchant", shiquanshimei_user_id);
	}
	
	merchantRedEnvelope_find.setState(State.STATE_WAITE_CHANGE);
	merchantRedEnvelope_find.initQuerySort("index_id", QuerySort.asc);
	if(!MyUtil.isEmpty(merchant72_type)){
		merchantRedEnvelope_find.addCommand(MongoCommand.budengyu, "merchant_type", merchant72_type);
	}
	
	MerchantRedEnvelope merchantRedEnvelope_had_find = new MerchantRedEnvelope();
	
	merchantRedEnvelope_had_find.setUserId_huiyuan(user_huiyuan.getId());
	merchantRedEnvelope_had_find.setState(State.STATE_OK);
	
	List<MerchantRedEnvelope> merchantRedEnvelope_had_list = serializContext.findAll(merchantRedEnvelope_had_find);
	
	currentTimeMillis =  System.currentTimeMillis();
	
	LinkedHashMap<String,String> merchantRedEnvelope_had_map = new LinkedHashMap<String,String>();
	
	for(MerchantRedEnvelope merchantRedEnvelope_had_tmp:merchantRedEnvelope_had_list){
		merchantRedEnvelope_had_map.put(merchantRedEnvelope_had_tmp.getUserId_merchant(), merchantRedEnvelope_had_tmp.getUserId_merchant());
	}
	 
	Set<String> userId_merchant_keyset = merchantRedEnvelope_had_map.keySet();
	for(String userId_merchant_had:userId_merchant_keyset){
		merchantRedEnvelope_find.addCommand(MongoCommand.not_in, "userId_merchant", userId_merchant_had);
	}
	
	Double longitude = user_merchant.getLongitude();
	if(longitude == null){ longitude = 0d;}
	Double latitude = user_merchant.getLatitude();
	if(latitude == null){ latitude = 0d;}
	
	//添加查询条件 
	MongoCommand.nearSphere(merchantRedEnvelope_find, longitude, latitude);
	//默认就是采用距离排序	把id 排序这些去掉
	merchantRedEnvelope_find.setIs_sort(false);
	
	List<MerchantRedEnvelope> merchantRedEnvelope_list = new ArrayList<MerchantRedEnvelope>();
	
	Integer receive_red_envelope_order_price_fen = user_merchant.getFinalReceive_red_envelope_order_price_fen();
	 
	//新增个规则 消费**元以上的 才能领红包
	if(tradeRecord.getThirdPayPrice_fen_all() >= receive_red_envelope_order_price_fen ){
			//汉虾王需要在这两个商家消费成功后能够领取商家的红包
			String hanxiawang_user_id = "5b599641d6c4596828d8e0cc"; 
			
			List<String> id_list = new ArrayList<String>();
			id_list.add("5ac08beb7d170b1b2abb8c85");//fl 鎏嘉码头
			id_list.add("5b1a25677d170b0b565d1292");//动物园咖啡
			
			//是否领取策略的红包
			Boolean create_oneRed = false;
		
			if(id_list.contains(user_merchant.getId())){
				
				Random rand = new Random();
				Integer randNumber =rand.nextInt(100);
				if(randNumber<50){
					//50%的记录领取汉虾王的红包
					create_oneRed = true;
				}
				
				MerchantRedEnvelope merchantRedEnvelope_hanxia_had = new MerchantRedEnvelope();
				
				merchantRedEnvelope_hanxia_had.setUserId_merchant(hanxiawang_user_id);
				merchantRedEnvelope_hanxia_had.setUserId_huiyuan(user_huiyuan.getId());
				merchantRedEnvelope_hanxia_had.setState(State.STATE_OK);
		
				merchantRedEnvelope_hanxia_had = (MerchantRedEnvelope)serializContext.findOneInlist(merchantRedEnvelope_hanxia_had);
				//如果已经有了不能再领取 汉虾王的
				if(merchantRedEnvelope_hanxia_had != null){
					//只能有一个这个的红包
					create_oneRed = false;
				}
				
			}else{
				merchantRedEnvelope_find.addCommand(MongoCommand.not_in, "userId_merchant", hanxiawang_user_id);
			}
			//如果已经有这个店的红包了 那么就按照默认规则领取
			if(create_oneRed){
				MerchantRedEnvelope merchantRedEnvelope_create = new MerchantRedEnvelope();
				merchantRedEnvelope_create.setUserId_merchant(hanxiawang_user_id);
				merchantRedEnvelope_create.setState(State.STATE_WAITE_CHANGE);
		
				merchantRedEnvelope_create = (MerchantRedEnvelope)serializContext.findOneInlist(merchantRedEnvelope_create);
				
				if(merchantRedEnvelope_create != null){
					
					Double longitude_red = merchantRedEnvelope_create.getLongitude();
					Double latitude_red = merchantRedEnvelope_create.getLatitude();
					if(longitude_red == null){ longitude_red = 0d;}
					if(latitude_red == null){ latitude_red = 0d;}
					
					Double distance = DiLiUtil.getDistance(latitude_red, longitude_red,latitude, longitude);
					
					merchantRedEnvelope_list.add(merchantRedEnvelope_create);
				}
			}
			
			/**
				将这个订单已经领取的红包加进去
			*/
			MerchantRedEnvelope merchantRedEnvelope_had_lingqu_find = new MerchantRedEnvelope();
			merchantRedEnvelope_had_lingqu_find.setTradeRecord72_id(tradeRecord_id);
			merchantRedEnvelope_had_lingqu_find.setUserId_huiyuan(user_huiyuan.getId());
			
			List<MerchantRedEnvelope> merchantRedEnvelope_had_lingqu_list =  serializContext.findAll(merchantRedEnvelope_had_lingqu_find);
			merchantRedEnvelope_list.addAll(merchantRedEnvelope_had_lingqu_list);
			
			currentTimeMillis =  System.currentTimeMillis();
			 
			while(merchantRedEnvelope_list.size() <= 1){
				
				//如果是 石全食美 收到本店的红包其他条件都去掉
				if(shiquanshimei_user_id.equals(user_merchant.getId())){
					merchantRedEnvelope_find.setUserId_merchant(user_merchant.getId());
					merchantRedEnvelope_find.removeCommand(MongoCommand.not_in);
					merchantRedEnvelope_find.removeCommand(MongoCommand.budengyu);
				}
				
				//如果是老客户营销 那么
				if(Merchant72.amount_type_trade_bili_laokehu.equals(user_merchant.getReceive_red_envelope_lingqu_type()) && merchantRedEnvelope_list.size() > 0){
					break;
				}
				
				MerchantRedEnvelope merchantRedEnvelope_tmp = (MerchantRedEnvelope)serializContext.findOneInlist(merchantRedEnvelope_find);
						
				if(merchantRedEnvelope_tmp == null){
					break;	
				}
				
				currentTimeMillis =  System.currentTimeMillis();
				
				Double longitude_red = merchantRedEnvelope_tmp.getLongitude();
				Double latitude_red = merchantRedEnvelope_tmp.getLatitude();
				
				Double distance = DiLiUtil.getDistance(latitude_red, longitude_red,user_merchant.getLatitude(), user_merchant.getLongitude());
				
				merchantRedEnvelope_tmp.setDistance(distance);
				
				merchantRedEnvelope_find.addCommand(MongoCommand.not_in, "userId_merchant", merchantRedEnvelope_tmp.getUserId_merchant());
				
				merchantRedEnvelope_list.add(merchantRedEnvelope_tmp);
				
				//石全食美 出现一个红包就退出
				if(shiquanshimei_user_id.equals(user_merchant.getId())){
					 break;
				}
				
			}
	}
	
	String zhongqiu_huodong_id = "5ba73786d6c4595897c5b976";
	MarketingActivities marketingActivities = (MarketingActivities)serializContext.get(MarketingActivities.class, zhongqiu_huodong_id);
	 
	if(marketingActivities != null &&  marketingActivities.getIs_on_activities() ){
		
		/**
		 * 一个用户只能抽取一次
		 */
		PaymentRecord paymentRecord_zhongqiu_had_chouqu_find = new PaymentRecord();
		
		paymentRecord_zhongqiu_had_chouqu_find.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_zhongqiu_yuebing);
		paymentRecord_zhongqiu_had_chouqu_find.setUserId_huiyuan(user_huiyuan.getId());
		
		PaymentRecord paymentRecord_zhongqiu_had_chouqu_find_out  = (PaymentRecord) serializContext.findOneInlist(paymentRecord_zhongqiu_had_chouqu_find);
		
		if(paymentRecord_zhongqiu_had_chouqu_find_out == null) {
			
			/**
			 * 找出有没有未领取月饼的记录
			 */
			
			PaymentRecord paymentRecord_zhongqiu_find = new PaymentRecord();
			
			paymentRecord_zhongqiu_find.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_zhongqiu_yuebing);
			paymentRecord_zhongqiu_find.setUserId_merchant(user_merchant.getId());
			paymentRecord_zhongqiu_find.setState(State.STATE_WAITE_PROCESS);
			paymentRecord_zhongqiu_find.addCommand(MongoCommand.xiaoyuAndDengyu, "id", new ObjectId());
			
			PaymentRecord paymentRecord_zhongqiu_find_out  = (PaymentRecord) serializContext.findOneInlist(paymentRecord_zhongqiu_find);
			request.setAttribute("paymentRecord_zhongqiu_find_out", paymentRecord_zhongqiu_find_out);
			
		}
	}
	
	boolean show_qrcode = isWeChatBrowser && !State.STATE_OK.equals(subscribeUser_state);
	 
	request.setAttribute("merchantRedEnvelope_list", merchantRedEnvelope_list);
	request.setAttribute("show_qrcode", show_qrcode);
	request.setAttribute("subscribeUser", subscribeUser);
	request.setAttribute("tradeRecord", tradeRecord);
	request.setAttribute("user_merchant", user_merchant);
	request.setAttribute("user_huiyuan", user_huiyuan);
	request.setAttribute("paymentRecord", paymentRecord);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
    <title>悠择YORZ-红包领取成功</title>
    <script src="${basePath }js/mui.min.js"></script>
    <link href="${basePath }css/mui.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${basePath }css/zaocan.css" />
   	<script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js" ></script>
   	
   	    <link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
	<script type="text/javascript" src="${basePath }plugin/js/layer_mobile/layer.js"></script>
    <script type="text/javascript" >var basePath = '${basePath}';</script>
    <link rel="stylesheet" type="text/css" href="${basePath }layui-v2.2.5/layui/css/layui.css"/>
    <script type="text/javascript" src="${basePath }plugin/js/lymava_common.js?r=<%=System.currentTimeMillis()%>"></script>
    <script type="text/javascript" src="${basePath }js/project.js" ></script>
    
    <link rel="stylesheet" href="${basePath }plugin_front/mui/css/mui.min.css">
    <script src="${basePath }plugin_front/mui/js/mui.min.js?r=2018-08-25"></script>
    
    <script type="text/javascript" charset="utf-8">
    	$(function(){
    		mui.init();
        });
    	
    	function show_zhongqiu_zhongjiang(){
    		  //页面层
    		mui('#zhongqiu_pop').popover('show');
    	}
    </script>
    <c:if test="${!empty paymentRecord_zhongqiu_find_out}">
	    <script type="text/javascript">
			$(function(){
				show_zhongqiu_zhongjiang();
        	});
	    </script>
    </c:if>
    <style type="text/css">
    	.lingqu{
    		background-color: #fe7e01;border-radius: 0.2rem;color: #fff;width: 4rem;text-align: center ;float: right;
    	}
    	.yi_lingqu{
    		background-color: #9f9f9f;border-radius: 0.2rem;color: #fff;width: 4rem;text-align: center ;float: right;
    	}
    </style>
</head>   
<body style="background-color: <c:if test="${!show_qrcode}">#eee</c:if><c:if test="${show_qrcode}">#fff</c:if>;" class="layui-col-xs12"> 
	<div id="zhongqiu_pop" class="box mui-popover mui-popover-action mui-popover-top" style="display: none;width: 80%;left: 10%;top: 50%;" >
		<img alt="" src="${basePath }activities/zhongqiulingyuebing/image/zhongjiang_tu.png" style="width: 100%;" >
	</div> 
	<div class="container layui-col-xs12"> 
		<!--顶部-->
			<div class="layui-col-xs12 top1" style="height: 5px;">
				<div class="layui-col-xs4 top1_left" >
					&nbsp;
             	</div> 
             	<div class="layui-col-xs4 top1_middle">&nbsp;</div>
             	<div class="layui-col-xs4 top1_right" >
             		&nbsp;
             	</div> 
			</div>
			<div class="clear"></div>
			
		<!--内容部分	-->
		<div class="hongbao layui-col-xs12"> 
			<div class="h_bg layui-col-xs12">
				<img src="img/1_red_31_2.jpg" style="width: 100%;"/> 
			</div>
			<div class="h_dian layui-col-xs12" style="position: relative;">
				<div class="h_d_font layui-col-xs12" style="background-color: #eee;">
					<div class="r_d_font3">
						恭喜发财，大吉大利
					</div>
					<div class="r_d_font4">
						${paymentRecord.price_all_yuan }元
					</div>
					<div class="r_d_font5">
						已存入钱包(余额:${user_huiyuan.showBalance })
					</div>
				</div>
				<c:forEach var="merchantRedEnvelope" items="${merchantRedEnvelope_list }">
					<div class="layui-col-xs12" style="background-color: #eee;height: 0.2rem;">
						&nbsp;
					</div>
					<div class="layui-col-xs12" style="height: 6.1rem;background-color: #fff;padding: 0.4rem;position: relative;">
						<div  style="height: 5.3rem;width: 5.3rem;position: absolute;left: 0.4rem;top: 0.4rem;">
							 <img alt="" src="<c:out value="${merchantRedEnvelope.user_merchant.picname }" escapeXml="true"/>" style="height: 100%;width: 100%;">
						</div> 
						<div class="layui-col-xs12" style="padding-left: 5.7rem;color: #6e6d6d;height: 100%;">
							  <div class="layui-row">
							    <div class="layui-col-xs6" style="height: 1.25rem;line-height: 1.25rem;overflow: hidden;">
									<c:out value="${merchantRedEnvelope.red_envolope_name }" escapeXml="true"/>
								</div> 
								<div class="layui-col-xs6" style="text-align: right;">
									<img src="imgs/biao.png" style="padding-right: 0.5rem;height: 1rem;">
									<c:out value="${merchantRedEnvelope.merchant_type }" escapeXml="true"/>
								</div>
							 </div>
							 <div class="layui-row">
							    <div class="layui-col-xs4" style="height: 2rem;line-height: 2rem;">
									<font style="font-size: 0.7rem;">金额:${merchantRedEnvelope.amountFen/100 } 元</font> 
								</div>  
								<div class="layui-col-xs4" style="height: 2rem;line-height: 2rem;">
									<font style="font-size: 0.7rem;">距离:${merchantRedEnvelope.showDistance }</font> 
								</div>   
								<div class="layui-col-xs4" style="height: 2rem;line-height: 2rem;text-align: right;">
									<font style="font-size: 0.6rem;">有效期:${merchantRedEnvelope.showExpiryMonthDay }</font> 
								</div>
							 </div>
							 <div class="layui-row">
							    <div class="layui-col-xs9" style="padding-top: 0.3rem;height: 1.55rem;line-height: 1.55rem;overflow: hidden;">
									<img src="imgs/dao.png" style="padding-right: 0.5rem;height: 1rem;width: 1.25rem;">
									<c:out value="${merchantRedEnvelope.user_merchant.showAddress }" escapeXml="true"/>
								</div>    
								<div class="layui-col-xs3" style="padding-top: 0.3rem;text-align: center ;padding-right: 0.2rem;">
									<c:if test="${merchantRedEnvelope.state == 209 }">
									<div onclick="receive_red_envelopes('${merchantRedEnvelope.id }','${tradeRecord.id}')"   class="lingqu ${merchantRedEnvelope.id }">领取</div>
									<div style="display: none;" class="yi_lingqu">已领取</div>
									</c:if>
									<c:if test="${merchantRedEnvelope.state != 209 }">
									<div  class="yi_lingqu">已领取</div>
									</c:if>
								</div> 
							 </div>
						</div> 
					</div> 
				</c:forEach> 
				<c:if test="${show_qrcode}"> 
					<div class="layui-col-xs12" style="background-color: #eee;height: 0.2rem;">
						&nbsp; 
					</div>   
					<div class="h_d_font11 layui-col-xs12" style="background-color: #fff;">
							<div class="r_d_font6" style="padding-top: 0;">
								<div class="r_d_f1 layui-col-xs12">
									<img src="img/red_all_in_one.jpg" />
								</div> 
							</div>  
							<div class="r_d_font7 layui-col-xs12" style="padding-top: 0;font-size: 1rem;line-height: 1rem;">
								关注公众号，红包立马翻倍!
							</div>
					</div>
				</c:if>
			</div>
		</div>
	</div>
</body>
</html>