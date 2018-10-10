<%--
	判断用户输入的答案
 --%>

<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@ page import="com.lymava.qier.activities.caididian.CaiDidianDaan" %>
<%@ page import="com.lymava.commons.exception.CheckException" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.lymava.qier.activities.caididian.Didian" %>
<%@ page import="com.lymava.commons.state.StatusCode" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>

<%
	String didianming_tmp = request.getParameter("didianming");

	JsonObject jsonObject = new JsonObject();
	try{
		if (didianming_tmp != null) {
			String id = request.getParameter("id");//获取Didian id
			CheckException.checkNotEmpty(id, "传入参数有误");

			Didian didian = (Didian) serializContext.get(Didian.class, id);
			if (didian != null && didian.getDidianming().equals(didianming_tmp)) {//猜中图片

				CaiDidianDaan caiDidianDaan_save = new CaiDidianDaan();
				caiDidianDaan_save.setId(new ObjectId().toString());
				caiDidianDaan_save.setDidian_id(id);
				caiDidianDaan_save.setLingqu_day(new Date().getTime());
				caiDidianDaan_save.setOpenid(openid_header);
				caiDidianDaan_save.setUserId_huiyuan(user.getId());
				caiDidianDaan_save.setRand_number(null);
				caiDidianDaan_save.setType_jiangpin(CaiDidianDaan.type_jiangpin_weizhongjiang);
				caiDidianDaan_save.setState(State.STATE_WAITE_PROCESS);
				caiDidianDaan_save.setPrice_fen(null);
				caiDidianDaan_save.setRelife_count(0);
				caiDidianDaan_save.setRelife_day(null);

				serializContext.save(caiDidianDaan_save);

				jsonObject.addProperty("hint", true);

			} else {//未猜中
				jsonObject.addProperty("hint", "不对哟，再试试吧");
			}
		}

	}catch(CheckException checkException){
		jsonObject.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_FALSE);
		jsonObject.addProperty(StatusCode.statusCode_message_key, checkException.getMessage());
	}catch(Exception e){
		jsonObject.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_FALSE);
		jsonObject.addProperty(StatusCode.statusCode_message_key, "操作!");
	}
	out.print(jsonObject);
%>
