<%--
	获取当前显示的老地点图片 ，并对应处理
 --%>

<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@ page import="java.util.List" %>
<%@ page import="com.lymava.qier.activities.caididian.Didian" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>

<%
//分页获取猜地点图片=========================================================================================
	String page_tmp= request.getParameter("page");
	String pageSize_tmp= "1";

	//构造分页Bean
	PageSplit pageSplit_tmp = new PageSplit(page_tmp,pageSize_tmp);

	Didian didian_find = new Didian();
	List<Didian> didian_list = serializContext.findAll(didian_find, pageSplit_tmp);

	Didian diadian_currnet = didian_list.get(0);

	request.setAttribute("pageSplit", pageSplit_tmp);
	request.setAttribute("diadian_currnet", diadian_currnet);

//根据业务处理跳转=========================================================================================
	//用户对该地点的状态
	boolean is_share = false;
	if (!MyUtil.isEmpty(request.getParameter("is_share"))) {
		is_share = true;
	}
	Integer didian_state = diadian_currnet.getUserDidianStatus(openid_header, is_share);
	request.setAttribute("userState", didian_state);

	if(didian_state.equals(State.STATE_ORDER_NOT_EXIST)) {//未猜中
		request.getRequestDispatcher("/activities/caididian/guess_not.jsp").forward(request, response);
	} else  if (didian_state.equals(State.STATE_OK)) {//中奖
		request.getRequestDispatcher("/activities/caididian/guess_complete.jsp").forward(request, response);
	} else {//未中奖 || 未开宝箱 | 分享
		request.getRequestDispatcher("/activities/caididian/guess_ok.jsp").forward(request, response);
	}

%>
