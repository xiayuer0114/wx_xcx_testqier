<%@page import="com.lymava.base.model.Pub"%>
<%@page import="com.lymava.commons.exception.CheckException"%>
<%@page import="com.lymava.trade.pay.model.PaymentRecord"%>
<%@page import="com.lymava.qier.activities.sharebusiness.SubscribeFirstRedEnvelopeShareBusiness"%>
<%@page import="com.lymava.commons.cache.SimpleCache"%>
<%@page import="com.lymava.qier.model.MerchantRedEnvelope"%>
<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.commons.util.HexM"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.qier.model.UserVoucher"%>
<%@page import="com.lymava.commons.pay.PayFinalVariable"%>
<%@page import="com.lymava.commons.util.MathUtil"%>
<%@page import="com.lymava.trade.business.model.Product"%>
<%@ page import="com.lymava.qier.model.Merchant72" %>
<%@ page import="com.lymava.qier.model.Product72" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="com.lymava.nosql.mongodb.util.MongoCommand" %>
<%@ page import="com.lymava.qier.action.MerchantShowAction" %>
<%@ page import="com.lymava.qier.model.Voucher" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String basePath_index = MyUtil.getBasePath(request);
	if( basePath_index.contains("http://tiesh.liebianzhe.com/") ){
		String fullRequestPath_last = HttpUtil.getFullRequestPath(request);
		String full_request_path = "https://tiesh.liebianzhe.com/"+fullRequestPath_last;
		response.sendRedirect(full_request_path);
		return;
	}
%>
<%@ include file="header/check_openid.jsp"%>
<%@ include file="header/header_check_login.jsp"%>
<%
	//商户的id
	String 	product_id =  request.getParameter("pid");
	String 	bianhao_str =  request.getParameter("b");
	Long 	bianhao = MathUtil.parseLongNull(bianhao_str);
	
	String price_yuan =  request.getParameter("price_yuan");
	String orderId =  request.getParameter("orderId");
	String order_memo =  request.getParameter("order_memo");
	String user_bianhao_str =  request.getParameter("bianhao");
	
	if(MyUtil.isEmpty(price_yuan)){
		price_yuan = (String)session.getAttribute("price_yuan");
	}
	if(MyUtil.isEmpty(product_id)){
		product_id = (String)session.getAttribute("product_id");
	}
	if(MyUtil.isEmpty(orderId)){
		orderId = (String)session.getAttribute("orderId");
		if(!MyUtil.isEmpty(orderId)){
			//如果这个订单好已经付款就可以继续支付
			PaymentRecord paymentRecord_find = new PaymentRecord();
			paymentRecord_find.setRequestFlow(orderId);
			
			paymentRecord_find = (PaymentRecord) serializContext.get(paymentRecord_find);
			if(paymentRecord_find != null && 
					
					 (
							 State.STATE_PAY_SUCCESS.equals(paymentRecord_find.getState()) 
							 || State.STATE_OK.equals(paymentRecord_find.getState()) 
					)
					
					){
				session.removeAttribute("orderId");
				session.removeAttribute("product_id");
				session.removeAttribute("price_yuan");
			}
		}
	}
	if(!MyUtil.isEmpty(order_memo)){
		try{ order_memo = new String(HexM.decodeHex(order_memo.toCharArray()));}catch(Exception e){ }
	}
	
	Product72 product_find_out = null;
	Merchant72 user_merchant = null;
	if(MyUtil.isValid(product_id)){
		product_find_out = (Product72) serializContext.get(Product72.class, product_id);
	} 
	if(product_find_out == null && bianhao != null){
		
		Product72 product_find = new Product72();
		product_find.setBianhao(bianhao);
		
		product_find_out = (Product72) serializContext.get(product_find);
	}
	//收银员 或者 店长
	User user_cashier = null;
	
	if(!MyUtil.isEmpty(user_bianhao_str)){
		Long user_bianhao = MathUtil.parseLong(user_bianhao_str);
		
		if(user_bianhao > 0){
			User user_find = new User();
			user_find.setBianhao(user_bianhao);
			
			user_cashier = (User)serializContext.get(user_find);
		}
	}
	
	if(user_cashier != null){
		
		User top_user = user_cashier.getTopUser();
		if(top_user != null){
			user_cashier = top_user;
		} 
		
		Product72 product_find = new Product72();
		product_find.setUserId_merchant(user_cashier.getId());
		
		product_find_out = (Product72) serializContext.get(product_find);
	}
	
	Integer need_select_yongcanrenshu = State.STATE_FALSE;
	
	if(product_find_out != null){
		user_merchant = (Merchant72) product_find_out.getUser_merchant();
		product_id = product_find_out.getId();
		
		if(State.STATE_OK.equals(product_find_out.getYushe_state())){
			Double price_yushe_yuan = product_find_out.getXiaoJi();
			if(price_yushe_yuan != null && price_yushe_yuan > 0){ 
				price_yuan = price_yushe_yuan.toString();
			}
			
			if(MyUtil.isEmpty(order_memo) && product_find_out.getShowCanWeiFei_all_yuan() > 0){
				order_memo = "用餐人数:"+product_find_out.getRenshu()+"人 餐位费:"+product_find_out.getShowCanWeiFei_all_yuan()+"元";
			}
			//等于0 暂时定为用户自己设置
			if(product_find_out.getRenshu() == 0 && product_find_out.getCanWeiFei_fen() != null && product_find_out.getCanWeiFei_fen() > 0 && State.STATE_OK.equals(product_find_out.getCanweifei_state())){
				need_select_yongcanrenshu = State.STATE_OK;
			}
		}
	}
	
	User front_user = (User)request.getAttribute("front_user");
	
	if(			user_merchant == null 
			|| product_find_out == null 
			|| !Pub.state_nomal.equals(product_find_out.getState())
			|| !Pub.shenghe_tongguo.equals(product_find_out.getShenghe())
			){//必须状态正常  且声和通过的才可以
		response.sendRedirect(MyUtil.getBasePath(request)+"data_error.jsp");
		return;
	} 
	
	MerchantRedEnvelope merchantRedEnvelope = null;
	
	//关注过的才能使用定向红包
	if(subscribeUser != null){
		MerchantRedEnvelope merchantRedEnvelope_find = new MerchantRedEnvelope();
		
		merchantRedEnvelope_find.setState(State.STATE_OK);
		merchantRedEnvelope_find.setUserId_huiyuan(front_user.getId());
		merchantRedEnvelope_find.setUserId_merchant(user_merchant.getId());
		
		merchantRedEnvelope_find.addCommand(MongoCommand.dayuAndDengyu, "expiry_time", System.currentTimeMillis());
		
		merchantRedEnvelope = (MerchantRedEnvelope)serializContext.get(merchantRedEnvelope_find);
	}
	
	SubscribeUser subscribeUser_first = null;
	if(subscribeUser == null){
		SubscribeUser subscribeUser_find = new SubscribeUser();
		subscribeUser_find.setOpenid(openid_header);
		
		subscribeUser_first = (SubscribeUser)serializContext.get(subscribeUser_find);
	}else{
		subscribeUser_first = subscribeUser; 
	}
	
	boolean  is_on_activity = false;
	if(subscribeUser_first == null){
		SubscribeFirstRedEnvelopeShareBusiness subscribeFirstRedEnvelopeShareBusiness = new SubscribeFirstRedEnvelopeShareBusiness();
		is_on_activity = subscribeFirstRedEnvelopeShareBusiness.check_is_on_activity();
	}
	//这个活动不上线的商家
	List<Long> bianhao_list = new LinkedList<Long>();
	bianhao_list.add(7321l);// 	痴小鱼餐厅(江北区)
	bianhao_list.add(7322l);//	痴小鱼餐厅(南岸区)
	bianhao_list.add(43658l);//	蟹爱餐厅(两江新区)
	
	bianhao_list.add(9329l);//	80年代江湖菜
	bianhao_list.add(9596l);//	西大叔的厨房
	bianhao_list.add(9587l);//	战虎老火锅店
	bianhao_list.add(10069l);//	粟啡工坊
	bianhao_list.add(28252l);//	清风笑酒号
	bianhao_list.add(28270l);//	清风笑酒号-有贰
	bianhao_list.add(34276l);//	西半球欧洲江湖菜
	bianhao_list.add(36231l);//	鳗亭居酒屋
	bianhao_list.add(43654l);//	蓝带味牛扒家宴
	bianhao_list.add(54994l);//	铜元道重庆宴
	bianhao_list.add(54997l);//	堃记海鲜大酒楼
	bianhao_list.add(54998l);//	景婆婆
	bianhao_list.add(55000l);//	大象花园
	bianhao_list.add(55002l);//	牛煮艺
	bianhao_list.add(55007l);//	小龙虾
	bianhao_list.add(55009l);//	黄大汉加工码头
	bianhao_list.add(43656l);//	EACH(万象城店)
	
	boolean is_in_merchant_list = bianhao_list.contains(user_merchant.getBianhao());
	
	//新用户从未关注过
	request.setAttribute("is_first_user", subscribeUser_first == null && is_on_activity && isWeChatBrowser && !is_in_merchant_list);
	
	request.setAttribute("user_cashier", user_cashier);
	
	request.setAttribute("user_merchant", user_merchant);
	request.setAttribute("product_find_out", product_find_out);
	request.setAttribute("product_id", product_id);
	
	request.setAttribute("price_yuan", price_yuan);
	request.setAttribute("orderId", orderId);
	request.setAttribute("order_memo", order_memo);
	request.setAttribute("bianhao", bianhao);
	request.setAttribute("merchantRedEnvelope", merchantRedEnvelope);
	request.setAttribute("need_select_yongcanrenshu", need_select_yongcanrenshu);
	request.setAttribute("currentTimeMillis", System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en" style="font-size:36px;">
<head>
    <meta charset="UTF-8">
    <meta content="yes" name="apple-mobile-web-app-capable">
    <meta content="telephone=no,email=no" name="format-detection">
    <meta content="yes" name="apple-touch-fullscreen">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" /><!-- 屏蔽双击缩放 -->
    <title>悠择YORZ</title>
    <script type="text/javascript" >var basePath = '${basePath}';</script>
    <link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css?2.0">
    <link rel="stylesheet" href="${basePath }activities/qingliang/swiper/css/swiper.min.css">
	<script type="text/javascript" src="${basePath }plugin/js/layer_mobile/layer.js"></script>
	
	<script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js"></script>
	<script type="text/javascript" src="${basePath }plugin/js/lymava_common.js?r=2018-09-03"></script>
    
    <link rel="stylesheet" href="${basePath }css/reset.css">
    <link rel="stylesheet" href="${basePath }css/fontello.css">
    <link rel="stylesheet" href="${basePath }css/index.css">
	<script type="text/javascript" src="${basePath }js/project.js?r=2018-09-27"></script>
	<script type="text/javascript" src="${basePath }js/fastclick.js"></script>
	<script type="text/javascript">
		jQuery(function(){
			FastClick.attach(document.body);
		});
		
		var is_first_user = '${is_first_user}';
		var canWeiFei_yuan = ${product_find_out.canWeiFei_fen/100 };
		var merchantRedEnvelope_id = '${merchantRedEnvelope.id}';
		var amount_to_reach_yuan = '${merchantRedEnvelope.amount_to_reach_fen/100}';
	</script>
	<c:if test="${isWeChatBrowser }">
		<script type="text/javascript">
			 var default_pay_method = pay_method_weipay;
		</script>
	</c:if> 
	<c:if test="${!isWeChatBrowser }">
		<script type="text/javascript">
			 var default_pay_method = pay_method_alipay;
		</script>
	</c:if>
	<style type="text/css">
		#index_body .layui-m-layercont{
			padding: 0;
		}
		#index_body .layui-m-layerbtn{
		    background-color: #fe9700;
		    text-align: center;
		    color: #fff;
		}
		#index_body .layui-m-layerbtn span{
		    font-size: 16px;
		    color: #fff; 
		}
	</style>
</head>
<body id="index_body">
    <div id="app">
        <div class="header">
            <div class="store-box">
                <p class="store-name" > 
                	<img alt="" src="images/icon_shangjia.png" style="height: 0.6rem;vertical-align:middle;margin-top: -0.15rem;" >
                	<c:out value="${user_merchant.nickname }"></c:out>
                	<input type="hidden" name="product_id"  value="${product_id}" autocomplete="off">
                	<input type="hidden" name="showBalance"  value="${(front_user.availableBalanceFen+merchantRedEnvelope.balanceFen)/100 }" autocomplete="off">
                	<input type="hidden" name="price_yuan"  value="${price_yuan}" autocomplete="off">
                	<input type="hidden" name="orderId"  value="${orderId}" autocomplete="off">
                	<input type="hidden" name="order_memo"  value="${order_memo}" autocomplete="off">
                	<input type="hidden" name="cashier_id"  value="${user_cashier.id}" autocomplete="off">
                	<input type="hidden" id="merchantRedEnvelope_id" name="merchantRedEnvelope_id"  value="" autocomplete="off">
                </p>
            </div>
        </div>

        <div class="content">
            <!-- 金额输入框 -->
            <div class="price-input">
                <div class="input-box">
                    <div class="input-item <c:if test="${empty orderId }">input-item_bind</c:if>">
                        <span class="title" style="height: 0.8rem;line-height: 1rem;">消费金额</span>
                        <span id="sum" class="pay-money" style="line-height: 31px;" >${price_yuan }</span>
                        <span class="cursor"></span>
                    </div>
                </div> 
            </div>  
            <div id="coupon-box" class="discount-group">
                <p class="title">重要的事说三遍 看下面~~看下~~看~</p>
                <ul class="discount-list">
                    <li class="discount-item"> 
                        <label>
	                        	<div class="left" style="height: 1.1rem;line-height: 1.1rem;width: 100%;">
	                                <span class="choose-count"  style="height: 0.8rem;line-height: 0.8rem;font-size: 0.35rem;overflow: hidden;margin-left: 0;width: 100%;">
	                                <c:if test="${currentTimeMillis%3 == 0 }">小哥哥,</c:if>
	                                <c:if test="${currentTimeMillis%3 == 1 }">小姐姐,</c:if>
	                                <c:if test="${currentTimeMillis%3 == 2 }">小主人,</c:if>
                        			<c:if test="${empty merchantRedEnvelope }">
	                                	兜兜里空空如也~~,买单后别忘了领红包^_^
                        			</c:if>
                        			<c:if test="${!empty merchantRedEnvelope }">
	                                	兜兜里有嘿大的红包,
	                                	<c:if test="${empty merchantRedEnvelope.amount_to_reach || merchantRedEnvelope.amount_to_reach == 0}">记到用哈</c:if>
	                                	<c:if test="${merchantRedEnvelope.amount_to_reach > 0}">满<font style="color: red;font-size: 0.5rem;">${merchantRedEnvelope.amount_to_reach_yuan }</font>可用哦</c:if>
	                                	^_^
                        			</c:if> 
	                                </span>
	                            </div> 
                            
                        </label>
                    </li>
                </ul>
            </div>
        </div>
        <div class="btn-box ">
            <div class="btn-wrap">
                <button id="buy-btn" class="unpay">
                    <span>确认买单</span>
                    <span class="rmb" id="price"></span>
                </button>
            </div>
        </div>
    </div>
    <div id="mask1" class="mask1"></div>
    <div id="mask2" class="mask2"></div>
    <div id="mask3" class="mask3"></div>
    <div id="keyboard" class="keyboard" style="transform: translate3d(0px, 100%, 0px);">
        <div class="left">
            <div class="line-item">
                <div class="key-item" data-value="1">1</div>
                <div class="key-item" data-value="2">2</div>
                <div class="key-item" data-value="3">3</div>
            </div>
            <div class="line-item">
                <div class="key-item" data-value="4">4</div>
                <div class="key-item" data-value="5">5</div>
                <div class="key-item" data-value="6">6</div>
            </div>
            <div class="line-item">
                <div class="key-item" data-value="7">7</div>
                <div class="key-item" data-value="8">8</div>
                <div class="key-item" data-value="9">9</div>
            </div>
            <div class="line-item">
                <div class="key-item" data-value="cancel"><i class="icon-keyboard"></i></div>
                <div class="key-item" data-value="0">0</div>
                <div class="key-item" data-value="." style="line-height: 1rem;">.</div>
            </div>
        </div>
        <div class="right">
            <div class="line-item">
                <div class="key-item" data-value="x"><i class="icon-cancel-alt"></i></div>
            </div>
            <div class="line-item" style="flex: 1;">
                <div class="key-item done" data-value="done">完成</div>
            </div>
        </div>
    </div>
    <!-- 优惠券&代金券 -->
    <div id="coupon-mask">
        <div class="coupons">
        	<div class="alipay_form_div" style="display: none;">
            </div> 
            <form action="${basePath }pay_success_back.jsp" name="pay_success_back_form">
                	<input  type="hidden" id="pay_success_out_trade_no" name="tradeRecord_id" value="">
            </form>
            <div class="content coupon_content" style="max-height: 14.5rem;" >
            	
            </div>
            <div class="foot">
                <div class="notice"></div>
                <div class="btn-wrap">
                    <button id="coupon_select_ok">确定</button>
                </div>
            </div>
        </div>
    </div>
    <!-- 确认买单 -->
    <div id="buy-order" class="buy-oder" style="transform: translate3d(0px, 100%, 0px);">
        <div class="order-header">
            <span class="close" id="close-buy-order">&nbsp;</span>
            <span>确认支付</span>
        </div>
        <div class="order-body radio-beauty-container" style="padding-bottom: 2px;">
            <div class="wallet radio-beauty-out" data_type="balance" id="isMerchant72_type">
                <label class="wallet-item">
                    <span class="radio-pay">
                        <span class="icon-font">储</span>
                        <span>
                        |红包余额:<span id="money">${(front_user.availableBalanceFen+merchantRedEnvelope.balanceFen)/100 }</span>
	                        <font id="show_merchantRedEnvelope_font">
		                        <c:if test="${!empty merchantRedEnvelope && merchantRedEnvelope.red_envolope_name == '关注立减' }">
		                        	&nbsp;&nbsp;含关注立减:${merchantRedEnvelope.balanceFen/100 }
		                        </c:if>
		                        <c:if test="${!empty merchantRedEnvelope && merchantRedEnvelope.red_envolope_name != '关注立减'  }">
		                        	&nbsp;&nbsp;含定向红包:${merchantRedEnvelope.balanceFen/100 }
		                        </c:if>
	                        </font>
                        </span>
                    </span>
	                <label  class="radio-beauty" ></label>
                </label>
            </div>
            <div class="pay" style="margin-top: 2px;">
	                 <label class="pay-item radio-beauty-out" data_type="pay_method">
	                 	<c:if test="${isWeChatBrowser }">
	                    	<span class="radio-pay"><img src="./img/wepay.png" class="wepay-icon" style="padding-right: 0.1rem;">微信支付</span>
	                    </c:if>
                		<c:if test="${!isWeChatBrowser }">
	                    	<span class="radio-pay"><img src="./img/alipay.jpg" class="wepay-icon" style="padding-right: 0.1rem;width: 0.7rem;margin-top: -0.1rem;">支付宝支付</span>
               			</c:if>
	                    <label  class="radio-beauty radio_beauty_check" data_select="true"></label>
	                </label>
            </div>
            <c:if test="${need_select_yongcanrenshu == 200 }">
	            <div class="pay" style="margin-top: 2px;">
		                 <label class="pay-item radio-beauty-out">
		                    <span class="radio-pay" style="padding-left: 0.7rem;height: 1.2rem;line-height: 1.3rem;">
		                    	用餐人数
		                    </span>
		                      <span  style="padding-left: 0.7rem;height: 1.2rem;width:4rem;overflow: hidden;" class="swiper-container">
							    <div class="swiper-wrapper" style="height: 1.2rem;width:4rem;">
		                    		<c:forEach begin="1" end="30" varStatus="i">
							       		  <div style="text-align: center;" data="${i.count }" class="swiper-slide">${i.count }人</div>
		                     		</c:forEach>
							    </div>
		                    </span> 
		                </label>
	            </div>
			      <!-- Swiper JS -->
				  <script src="${basePath }activities/qingliang/swiper/js/swiper.min.js"></script>
				  <!-- Initialize Swiper -->
				  <script>
				    var swiper = new Swiper('.swiper-container', {
				    	direction: 'vertical',
				    	on: {
				    		slideChangeTransitionEnd: function(){
				    			refresh_pay_money();
				    		}
				    	}
				      });
				  </script>
            </c:if>
        </div>
        <button id="payment" class="btn create_tradeorder">确认支付 <span>￥<span id="pay-price"></span></span></button>
    </div>
    <div  id="pay_stand" style="display: none;">
    	<div class="pay_23" >
			<div class="pay1_23">
				<div class="pay1_1_23" onclick="close_and_repay()">
					<img alt="" src="img/xxx.png">
				</div>
				<div class="pay1_2_23">
					<font>支付</font>
				</div>
				<div class="pay1_3_23" onclick="close_and_repay()">
					<font>重新支付</font>
				</div>
			</div> 
			<div class="pay2_23">
				<font>悠择生活</font>
			</div>
			<div class="pay2_23_1">
				<font class="left">￥</font><font class="right waite_back_payment">0.01</font> 
			</div>
			<div class="pay3_23">
			    <div class="pay3_1_23" onclick="user_click_pay_success()">
			    	<font>已完成支付</font> 
			    </div> 
			</div>
		</div>
    </div>
    <script src="${basePath }js/index.js?r=2018-08-25"></script>
</body>
</html>