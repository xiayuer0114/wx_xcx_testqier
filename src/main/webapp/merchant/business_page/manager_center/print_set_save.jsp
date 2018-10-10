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
	CheckException.checkIsTure(front_user != null, "请先登录！");
	
	String state_auto_print_str = request.getParameter("state_auto_print");
	Integer state_auto_print = MathUtil.parseInteger(state_auto_print_str);
	
	String print_lianshu_str = request.getParameter("print_lianshu");
	Integer print_lianshu = MathUtil.parseInteger(print_lianshu_str);
	
	String default_printer_name = request.getParameter("default_printer_name");
	
	Merchant72 merchant72_update = new Merchant72();
	
	merchant72_update.setState_auto_print(state_auto_print);
	merchant72_update.setPrint_lianshu(print_lianshu);
	merchant72_update.setDefault_printer_name(default_printer_name);
	
	ContextUtil.getSerializContext().updateObject(front_user.getId(), merchant72_update);
%>