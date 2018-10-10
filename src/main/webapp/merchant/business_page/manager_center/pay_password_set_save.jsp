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
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	User front_user = FrontUtil.init_http_user(request);
	request.setAttribute("front_user", front_user);
	
	CheckException.checkIsTure(front_user != null, "登录超时,请重新登录!");
	
	Merchant72 merchant72 = QierUtil.getMerchant72User(front_user);
	request.setAttribute("merchant72", merchant72);
	
	CheckException.checkIsTure(merchant72 != null, "登录超时,请重新登录!");
	
	CheckException.checkIsTure(merchant72.getId().equals(front_user.getId()), "只有主账户才能修改支付密码!");
	
	String payPwdState_str = request.getParameter("payPwdState");
	
	Integer payPwdState = MathUtil.parseInteger(payPwdState_str);
	
	String old_payPass = request.getParameter("old_payPass");
	String new_payPass = request.getParameter("new_payPass");
	String new_payPass_re = request.getParameter("new_payPass_re");
	
	String old_payPass_md5 = Md5Util.MD5Normal(old_payPass);
	
	CheckException.checkIsTure(!MyUtil.isEmpty(old_payPass), "请输入支付密码！");
	CheckException.checkIsTure(old_payPass_md5.equals(merchant72.getPayPass()), "支付密码有误！");
		
	
	Merchant72 merchant72_update = new Merchant72();
	
	merchant72_update.setPayPwdState(payPwdState);
	
	if(!MyUtil.isEmpty(new_payPass)){
		CheckException.checkIsTure(new_payPass != null && new_payPass.equals(new_payPass_re), "支付密码和确认支付密码不符！");
		CheckException.checkIsTure(new_payPass != null &&  new_payPass.length() >= 6, "支付密码长度必须大于等于6！");
		merchant72_update.setPayPass(Md5Util.MD5Normal(new_payPass));
	}
	
	ContextUtil.getSerializContext().updateObject(front_user.getId(), merchant72_update);
	
	JsonObject jsonObject_return = new JsonObject();
	 
	jsonObject_return.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_OK);
	jsonObject_return.addProperty(StatusCode.statusCode_message_key, "修改成功！");
			 
	out.print(jsonObject_return.toString());
%>