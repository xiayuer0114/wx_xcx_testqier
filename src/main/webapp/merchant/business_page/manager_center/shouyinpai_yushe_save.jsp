<%@page import="com.lymava.commons.cache.SimpleCache"%>
<%@page import="com.lymava.base.model.SimpleDbCacheContent"%>
<%@page import="com.lymava.base.model.SimpleDbCache"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.qier.model.Product72"%>
<%@page import="com.lymava.commons.state.StatusCode"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.lymava.commons.util.Md5Util"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.qier.util.QierUtil"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.qier.model.Merchant72"%>
<%@page import="com.lymava.commons.util.MathUtil"%>
<%@page import="com.lymava.commons.exception.CheckException"%>
<%@page import="com.lymava.userfront.util.FrontUtil"%>
<%@page import="com.lymava.base.model.User"%>
<%@page import="com.lymava.commons.state.State"%>
<%@ page import="java.util.Date" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	User front_user = FrontUtil.init_http_user(request);
	request.setAttribute("front_user", front_user);
	
	CheckException.checkIsTure(front_user != null, "登录超时,请重新登录!");
	
	String product_72_id = request.getParameter("product_72_id");
	String price_yushe = request.getParameter("product72_price");
	String canweifei = request.getParameter("canweifei");   // 餐位费
	String renshu = request.getParameter("renshu");			// 用餐人数
	String yushe_state_str = request.getParameter("yushe_state");	 // 是否开启预设
	Integer yushe_state =  MathUtil.parseIntegerNull(yushe_state_str);
	Boolean state_ok = Product72.yushe_state_kaiqi.equals(yushe_state) || Product72.yushe_state_guanbi.equals(yushe_state);
	CheckException.checkIsTure(state_ok, "修改状态不正确!");
	
	String canweifei_state_str = request.getParameter("canweifei_state");	 // 是否收取餐位费
	Integer canweifei_state =  MathUtil.parseIntegerNull(canweifei_state_str);
	

	Double price_yushe_yuan = MathUtil.parseDouble(price_yushe);
	Double canweifei_yuan = MathUtil.parseDouble(canweifei);
	
	CheckException.checkIsTure(MyUtil.isValid(product_72_id), "收银牌编号有误!");
	
	CheckException.checkIsTure(price_yushe_yuan >= 0, "预设金额需大于0!");
	
	Long price_yushe_fen =  MathUtil.multiply(price_yushe_yuan, 100).longValue();
	
	double price_yushe_yuan_check = MathUtil.divide(price_yushe_fen, 100).doubleValue();
	
	CheckException.checkIsTure(price_yushe_yuan_check == price_yushe_yuan, "预设金额最大精度为0.01!");
	
    Product72 product72_find = new Product72();
    
    product72_find.setId(product_72_id);
    product72_find.setUserId_merchant(front_user.getId());
    
    SerializContext serializContext = ContextUtil.getSerializContext();
    
    product72_find = (Product72)serializContext.get(product72_find);
    CheckException.checkIsTure(product72_find != null, "收银牌不存在!");


    // 更新预设值
	Double preset_amount_fen_double = price_yushe_yuan * Product72.preset_amount_pianyi;
	Long preset_amount_fen_long = Math.round(preset_amount_fen_double);

	// 餐位费
	Double canweifei_yuan_fen_double = canweifei_yuan * Product72.preset_amount_pianyi;
	Long canweifei_yuan_fen_long = Math.round(canweifei_yuan_fen_double);

	// 用餐人数
	Integer renshu_int = MathUtil.parseInteger(renshu);

	// 修改
	Product72 product72_update = new Product72();
	
	product72_update.setPreset_amount_fen(preset_amount_fen_long);
	product72_update.setUpdate_amount_time(System.currentTimeMillis());
	product72_update.setCanWeiFei_fen(canweifei_yuan_fen_long);
	product72_update.setRenshu(renshu_int);
	product72_update.setYushe_state(yushe_state);
	product72_update.setCanweifei_state(canweifei_state);

	ContextUtil.getSerializContext().updateObject(product72_find.getId(), product72_update);

	// 设置缓存

	JsonObject jsonObject_return = new JsonObject();
	 
	jsonObject_return.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_OK);
	jsonObject_return.addProperty(StatusCode.statusCode_message_key, "收银牌金额预设成功！");
			 
	out.print(jsonObject_return.toString());
%>