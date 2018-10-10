<%@page import="com.lymava.qier.self_order.model.BillItemRecord"%>
<%@page import="com.lymava.qier.model.Merchant72"%>
<%@page import="com.lymava.qier.model.Product72"%>
<%@page import="org.bson.types.ObjectId"%>
<%@page import="com.lymava.qier.self_order.model.BillMainRecord"%>
<%@page import="com.lymava.qier.business.BusinessIntIdConfigQier"%>
<%@page import="com.lymava.trade.business.model.TradeRecord"%>
<%@page import="com.lymava.trade.business.business_impl.TradeBusiness"%>
<%@page import="java.util.Map"%>
<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.userfront.util.FrontUtil"%>
<%@page import="com.lymava.base.model.User"%>
<%@page import="com.lymava.commons.util.HttpUtil"%>
<%@page import="com.lymava.commons.state.StatusCode"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.lymava.commons.exception.CheckException"%>
<%@page import="com.lymava.trade.business.model.ProductItem"%>
<%@page import="com.lymava.trade.business.model.ShoppingCart"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="java.awt.image.renderable.ContextualRenderedImageFactory"%>
<%@page import="com.lymava.trade.business.model.Product"%>
<%@page import="java.util.List"%>
<%@page import="com.lymava.base.model.PubConlumn"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%

	ShoppingCart shoppingCart =   	ShoppingCart.getGouwuche(session);

	List<ProductItem> product_item_list = shoppingCart.getProduct_item_list();
	
	JsonObject jsonObject_return = new JsonObject();
	
	Map parameterMap = request.getParameterMap();

	try{
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
	    //点餐的会员
	    User user_huiyuan = FrontUtil.init_http_user(request);
		//校验用户
	    CheckException.checkIsTure(user_huiyuan != null && User.STATE_OK.equals(user_huiyuan.getState()), "餐车里空空如也!");
	    
		CheckException.checkIsTure(product_item_list != null && product_item_list.size() > 0, "餐车里空空如也!");
		
		String zhuohao_id = HttpUtil.getParemater(parameterMap, "zhuohao_id");
		String requestFlow = HttpUtil.getParemater(parameterMap, "requestFlow");
		
		
		CheckException.checkIsTure(MyUtil.isValid(zhuohao_id), "当前桌号不存在!");
		Product72 zhuohao_find_out = (Product72) serializContext.get(Product72.class,zhuohao_id);
		
		CheckException.checkIsTure(zhuohao_find_out != null && Product72.state_nomal.equals(zhuohao_find_out.getState()), "当前桌号不存在!");
		
		Merchant72 merchant72 = (Merchant72)zhuohao_find_out.getUser_merchant();
		CheckException.checkIsTure(merchant72 != null && User.STATE_OK.equals(merchant72.getState()), "当前商户不存在!");
		
		BillMainRecord billMainRecord = new BillMainRecord();
		
		billMainRecord.setProductId(zhuohao_id);
		billMainRecord.setState(State.STATE_INPROCESS);
		/**
			先找出用餐中的订单
		*/
		billMainRecord = (BillMainRecord)serializContext.get(billMainRecord);
		/**	如果为空新开一个 **/
		if(billMainRecord == null){
			billMainRecord = new BillMainRecord();
			
			billMainRecord.setId(new ObjectId().toString());
			billMainRecord.setProductId(zhuohao_id);
			billMainRecord.setState(State.STATE_INPROCESS);
			billMainRecord.setRequestFlow(requestFlow);
			billMainRecord.setUser_merchant(merchant72);
			billMainRecord.setUser_huiyuan(user_huiyuan);
			billMainRecord.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_bill_main);
			
			billMainRecord.parseTradeRecord(parameterMap);
			zhuohao_find_out.parseTradeRecord(billMainRecord,parameterMap);
			
			
			serializContext.save(billMainRecord);
		}
		
		for(ProductItem productItem:product_item_list){
			
			String product_id =  productItem.getProductId();
			
			Integer count = productItem.getCount();
			
			BillItemRecord create_tradeRecord = (BillItemRecord)TradeBusiness.create_tradeRecord(parameterMap,product_id, count+"");
			
			create_tradeRecord.setUser_merchant(merchant72);
			create_tradeRecord.setUser_huiyuan(user_huiyuan);
			create_tradeRecord.setState(State.STATE_WAITE_PROCESS);
			create_tradeRecord.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_bill_item);
			create_tradeRecord.setPaymentRecord_id(billMainRecord.getId());
			
			serializContext.save(create_tradeRecord);
		}
		
		//添加完成后清空
		shoppingCart.clear();
		
		jsonObject_return.addProperty(StatusCode.statusCode_message_key, "下单成功!");
		jsonObject_return.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_OK);
	}catch(CheckException e){
		jsonObject_return.addProperty(StatusCode.statusCode_message_key, e.getMessage());
		jsonObject_return.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_FALSE);
	}catch(Exception e){
		e.printStackTrace();
		jsonObject_return.addProperty(StatusCode.statusCode_message_key, "网络异常,下单失败!");
		jsonObject_return.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_FALSE);
	}
	out.print(jsonObject_return);
%>