<%@page import="com.lymava.trade.util.WebConfigContentTrade"%>
<%@page import="com.lymava.qier.model.Merchant72"%>
<%@page import="java.util.Random"%>
<%@page import="java.util.List"%>
<%@page import="com.lymava.commons.util.MathUtil"%>
<%@page import="com.lymava.qier.activities.qingliang.MerchantQingliang"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/header/check_openid.jsp"%>
<%@ include file="/header/header_check_login.jsp"%>
<%

	String userId_merchant = request.getParameter("userId_merchant");

	String user_merchant_bianhao_str = request.getParameter("b");
	Long user_merchant_bianhao = MathUtil.parseLongNull(user_merchant_bianhao_str);
	
	Merchant72 merchant72  = null;
	
	if(user_merchant_bianhao != null){
		
		merchant72 = new Merchant72();
		
		merchant72.setBianhao(user_merchant_bianhao);
		merchant72.setUserGroupId(WebConfigContentTrade.getInstance().getMerchantUserGroupId());
		
		merchant72 = (Merchant72)serializContext.get(merchant72);
		if(merchant72 != null){
			userId_merchant = merchant72.getId();
		}
	}
	
	MerchantQingliang merchantQingliang_current = null;

	MerchantQingliang merchantQingliang = new MerchantQingliang();
	merchantQingliang.setState(State.STATE_OK);
	
	List<MerchantQingliang> merchantQingliang_ite =  serializContext.findAll(merchantQingliang);
	
	if(!MyUtil.isValid(userId_merchant) && merchantQingliang_ite.size() > 0){
		Random random = new Random();
		int userId_merchant_index = random.nextInt(merchantQingliang_ite.size());
		userId_merchant = merchantQingliang_ite.get(userId_merchant_index).getUserId_merchant();
	}
	
	Long price_fen_all = 0l;
	
	for(MerchantQingliang merchantQingliang_next:merchantQingliang_ite){
		
		if(MyUtil.isValid(userId_merchant) && userId_merchant.equals(merchantQingliang_next.getUserId_merchant()) ){
			merchantQingliang_current = merchantQingliang_next;
		}
		
		Long price_fen_all_tmp = merchantQingliang_next.getPrice_fen();
		if(price_fen_all_tmp == null){
			price_fen_all_tmp = 0l;
		}
		price_fen_all += price_fen_all_tmp;
	}
	
	Long price_yuan_all = MathUtil.divide(price_fen_all, 100).longValue();
	String qingliang_init_zong_price = WebConfigContent.getConfig("qingliang_init_zong_price");
	Long qingliang_init_zong_price_long = MathUtil.parseLong(qingliang_init_zong_price);
	price_yuan_all = price_yuan_all+qingliang_init_zong_price_long;
	
	request.setAttribute("merchantQingliang_ite", merchantQingliang_ite);
	request.setAttribute("price_fen_all", price_fen_all);
	request.setAttribute("price_yuan_all", price_yuan_all);
	request.setAttribute("userId_merchant", userId_merchant);
	request.setAttribute("merchantQingliang_current", merchantQingliang_current);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
		<title>一元清凉计划</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <meta content="yes" name="apple-mobile-web-app-capable">
	    <meta content="telephone=no,email=no" name="format-detection">
	    <meta content="yes" name="apple-touch-fullscreen">
	    <meta http-equiv="X-UA-Compatible" content="ie=edge">
	    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" /><!-- 屏蔽双击缩放 -->
		<link rel="stylesheet" type="text/css" href="${basePath }activities/qingliang/css/cool.css"/>
		<script type="text/javascript" >var basePath = '${basePath}';</script>
	    <link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
		<script type="text/javascript" src="${basePath }plugin/js/layer_mobile/layer.js"></script>
		
		<script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js"></script>
		<script type="text/javascript" src="${basePath }plugin/js/lymava_common.js?r=2018-08-15"></script>
		<script type="text/javascript" src="${basePath }activities/qingliang/js/project.js?r=2018-08-15"></script>
  		<!-- Link Swiper's CSS -->
		  <link rel="stylesheet" href="swiper/css/swiper.min.css">
		
		  <!-- Demo styles -->
		  <style> 
		    html, body {
		      position: relative;
		      height: 100%;
		    }
		    body {
		      background: #eee;
		      font-family: Helvetica Neue, Helvetica, Arial, sans-serif;
		      font-size: 14px;
		      color:#000;
		      margin: 0;
		      padding: 0;
		    }
		  </style>
		  <script type="text/javascript">
		
			var pay_method = '<%=PayFinalVariable.pay_method_weipay%>';
			var userId_merchant = '${userId_merchant}';
			
			$(function(){
			 	ajax_get(basePath+"activities/qingliang/load_merchant_qingliang.jsp",function(message){
			 		$('.cool_cash1').html(message);
			 	});
			 	$('.qingliang_price_btn').bind('click',function(){
			 		create_paymentrecord();
			 	});
			}); 
		</script>
</head>
<body>
		  <!-- Swiper -->
		  <div class="swiper-container" style="z-index: 0;">
		    <div class="swiper-wrapper">
		       		  <div class="swiper-slide"><img src="img/h5_01.jpg" style="width: 100%;"/></div>
				      <div class="swiper-slide"><img src="img/h5_02.jpg" style="width: 100%;"/></div>
				      <div class="swiper-slide"><img src="img/h5_03.jpg" style="width: 100%;"/></div> 
		    </div>
		  </div> 
		<!--内容一-->
		<div class="cool_both">
		<!--banner-->
		<!--人物部分-->
		<div class="cool_people">
			<img src="img/pople.png"/>
		</div>
		<!--输入金额框-->
		<div class="cool_enter" style="margin-top: 1.8rem;width: 85%;">
			<input style="padding-left: 0;"  name="qingliang_price_yuan" type="number" min="1" max="99" value="" placeholder="    请输入捐助金额1~99元"/>
		</div>
		<div class="cool_botton" style="margin-top: 0.5rem;">
			<img class="qingliang_price_btn" src="img/botton.png"/>
		</div>
		<!--活动简介-->
		<div class="cool_introduction">
			<img src="img/jianjie.png"/>
		</div>
		<!--筹款详情-->
		<div class="cool_cash">
			<img src="img/title1.png"/>
		</div>
		<div class="cool_cash1" >
			 
		</div>
		
		<!--筹款总金额-->
			<div class="cool_total">
				<div class="cool_total1">
					<div class="cool_t1">
						<img src="img/bi.png"/>
						筹款总金额：${price_yuan_all }
					</div>
					
				</div>
				<div class="cool_cc1">
					<img src="img/cash2.png"/>
				</div>
			</div>
		<!--主办单位-->
		<div class="cool_host">
			<img src="img/title2.png"/>
		</div>
		<div class="cool_concur">
			公益合作商家 
		</div>
		<div class="cool_logo">
			<div class="cool_l">
				<img src="${basePath }activities/qingliang/img/merchant_index_logo/1.jpg"/>
			</div>
			<div class="cool_l">
				<img src="${basePath }activities/qingliang/img/merchant_index_logo/2.jpg"/>
			</div>
			<div class="cool_l">
				<img src="${basePath }activities/qingliang/img/merchant_index_logo/3.jpg"/>
			</div>
			<div class="cool_l">
				<img src="${basePath }activities/qingliang/img/merchant_index_logo/4.jpg"/>
			</div>
		</div>
		<div class="cool_logo">
			<div class="cool_l">
				<img src="${basePath }activities/qingliang/img/merchant_index_logo/5.jpg"/>
			</div>
			<div class="cool_l">
				<img src="${basePath }activities/qingliang/img/merchant_index_logo/6.jpg"/>
			</div>
			<div class="cool_l">
				<img src="${basePath }activities/qingliang/img/merchant_index_logo/7.jpg"/>
			</div>
			<div class="cool_l">
				<img src="${basePath }activities/qingliang/img/merchant_index_logo/8.jpg"/>
			</div>
		</div>
		<div class="cool_logo">
			<div class="cool_l">
				<img src="${basePath }activities/qingliang/img/merchant_index_logo/9.jpg"/>
			</div>
			<div class="cool_l">
				<img src="${basePath }activities/qingliang/img/merchant_index_logo/10.jpg"/>
			</div>
			<div class="cool_l">
				<img src="${basePath }activities/qingliang/img/merchant_index_logo/11.jpg"/>
			</div>
			<div class="cool_l">
				<img src="${basePath }activities/qingliang/img/merchant_index_logo/12.jpg"/>
			</div>
		</div>
		<div class="cool_logo">
			<div class="cool_l">
				<img src="${basePath }activities/qingliang/img/merchant_index_logo/13.jpg"/>
			</div>
			<div class="cool_l">
				<img src="${basePath }activities/qingliang/img/merchant_index_logo/14.jpg"/>
			</div>
			<div class="cool_l">
				<img src="${basePath }activities/qingliang/img/merchant_index_logo/15.jpg"/>
			</div>
			<div class="cool_l">
				<img src="${basePath }activities/qingliang/img/merchant_index_logo/16.jpg"/>
			</div>
		</div>
		<div class="cool_logo" style="display: none;">
			<div class="cool_l">
				<img src="${basePath }activities/qingliang/img/merchant_index_logo/17.jpg"/>
			</div>
			<div class="cool_l"> 
				<img src="${basePath }activities/qingliang/img/merchant_index_logo/18.jpg"/>
			</div> 
		</div>
		<div class="cool_sign">
			<img src="img/logo.png"/>
		</div>
		<!--弹窗-->
		<div class="Pop-ups_3" style="display: none;">
			<div class="Pop1_u">
				<img src="img/cuo.png" onclick="layer.closeAll()"/>
			</div>
			<div class="Pop2_u">
				<img src="${basePath }${merchantQingliang_current.subscribe_pic}"/>
			</div>
		</div> 
		</div>
  <!-- Swiper JS -->
  <script src="swiper/js/swiper.min.js"></script>

  <!-- Initialize Swiper -->
  <script>
    var swiper = new Swiper('.swiper-container', {
        autoplay: {
          delay: 2500,
          disableOnInteraction: false,
        }
      });
  </script>
</body>
</html>
