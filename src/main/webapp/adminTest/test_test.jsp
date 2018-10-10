<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="com.lymava.nosql.context.SerializContext" %>
<%@ page import="com.lymava.qier.model.MerchantRedEnvelope" %>
<%@ page import="org.bson.types.ObjectId" %>
<%@ page import="com.lymava.commons.state.State" %>
<%@ page import="com.lymava.commons.util.DateUtil" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
	SerializContext serializContext =ContextUtil.getSerializContext();


	SimpleDateFormat sdf =  DateUtil.getSdfFull();
	String shi_date = "2018-10-30 00:00:00";
	Long a = sdf.parse(shi_date).getTime();

	MerchantRedEnvelope  merchantRedEnvelope_send = new MerchantRedEnvelope();
	String mer_red_id = new ObjectId().toString();
	merchantRedEnvelope_send.setId(mer_red_id);
	merchantRedEnvelope_send.setInAmount(138+"");
	merchantRedEnvelope_send.setState(State.STATE_OK);
	merchantRedEnvelope_send.setUserId_merchant("5b309e497d170b366d56a674");
	merchantRedEnvelope_send.setRed_envolope_name("圣慕缇集卡");
	merchantRedEnvelope_send.setExpiry_time(a);
	serializContext.save(merchantRedEnvelope_send);


	// 测试分支

	// dasdasd
	// asjdkj
	// sdajskjhd

%>
