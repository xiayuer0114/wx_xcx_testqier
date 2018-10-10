<%@page import="com.lymava.base.vo.StatusCode"%>
<%@page import="com.lymava.trade.base.model.Business"%>
<%@page import="com.lymava.qier.model.TradeRecord72"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="java.io.File"%>
<%@page import="com.lymava.commons.util.MathUtil"%>
<%@page import="com.lymava.base.model.User"%>
<%@page import="jxl.write.WritableSheet"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="com.lymava.commons.util.JExcelUtils"%>
<%@page import="java.util.Iterator"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	Iterator<TradeRecord72> object_ite = (Iterator<TradeRecord72>) request.getAttribute("object_ite");

	JExcelUtils jExcelUtils = new JExcelUtils();
	
	String[] titles = { 
			"订单编号",
			"业务类型", 
			"订单金额", 
			"支付时间", 
			"支付方式",
			"实际支付",
			"钱包支付", 
			"商户",
			"商户余额",
			"状态",
			"系统时间" };
	
	ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
	jExcelUtils.createExcelFile(byteArrayOutputStream);
	WritableSheet createSheet = jExcelUtils.createSheet(0, "导出数据", titles);
	
	int row = 0;
	jExcelUtils.insertRowData(createSheet,row++,titles);
	
	while(object_ite.hasNext()){
		TradeRecord72 tradeRecord72_next = object_ite.next();
		
		User user_huiyuan = tradeRecord72_next.getUser_huiyuan();
		Business business = tradeRecord72_next.getBusiness();
		User user_merchant = tradeRecord72_next.getUser_merchant();
		
		String requestFlow = tradeRecord72_next.getRequestFlow();
		String businessName = null;
		if(business != null){ businessName = business.getName();}
		Double price_fen_yuan = tradeRecord72_next.getPrice_all_yuan();
		String showPayTime = tradeRecord72_next.getShowPayTime();
		String showPay_method = tradeRecord72_next.getShowPay_method();
		
		Double thirdPayPrice_yuan = tradeRecord72_next.getThirdPayPrice_yuan();
		
		Double wallet_amount_payment_yuan = tradeRecord72_next.getWallet_amount_payment_yuan();
		Double wallet_amount_balance_yuan = tradeRecord72_next.getWallet_amount_balance_yuan();
		String user_merchant_nickname = null;
		if(user_merchant != null){ user_merchant_nickname = user_merchant.getUsername();}
		String showMerchant_balance = tradeRecord72_next.getShowMerchant_balance();
		String showState = tradeRecord72_next.getShowState();
		String showTime = tradeRecord72_next.getShowTime();
		
		Object[] row_data = {
								requestFlow,
								businessName,
								price_fen_yuan,
								showPayTime,
								showPay_method,
								thirdPayPrice_yuan,
								wallet_amount_payment_yuan,
								user_merchant_nickname,
								showMerchant_balance,
								showState,
								showTime
						};
		jExcelUtils.insertRowData(createSheet,row++,row_data);
	}
	jExcelUtils.close();
	
	byte[] file_byte_array = byteArrayOutputStream.toByteArray();
	
	String fileName = MyUtil.save_file("exeport.xls", file_byte_array, application);
	
	JsonObject jsonObject_root = new JsonObject();
	
	JsonObject jsonObject_data = new JsonObject();
	jsonObject_data.addProperty("fileName", fileName);
	
	jsonObject_root.add("data", jsonObject_data);
	jsonObject_root.addProperty("statusCode", StatusCode.ACCEPT_OK);
	jsonObject_root.addProperty("message", "生成成功");
	
	out.print(jsonObject_root);
%>