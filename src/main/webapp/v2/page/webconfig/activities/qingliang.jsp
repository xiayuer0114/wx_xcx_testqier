<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.base.util.WebConfigContent"%>
<%@page import="com.lymava.wechat.gongzhonghao.vo.MessageSendNews"%>
<%@page import="com.lymava.base.model.User"%>
<%@page import="com.lymava.base.model.Pub"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<fieldset >
			<div class="divider"></div> 
			<dl>
				<dt>活动开始</dt>
				<dd>
					<input type="hidden"  name="name"  value="qingliang_startTime" > 
					<input type="text" name="qingliang_startTime" value="<c:out value="${webConfig_qingliang_startTime }" escapeXml="true"/>"  class="date" dateFmt="yyyy-MM-dd HH:mm:ss"  >
				</dd>
			</dl>
			<dl>
				<dt>活动结束</dt>
				<dd>
					<input type="hidden"  name="name"  value="qingliang_endTime" > 
					<input type="text" name="qingliang_endTime" value="<c:out value="${webConfig_qingliang_endTime }" escapeXml="true"/>"  class="date" dateFmt="yyyy-MM-dd HH:mm:ss" >
				</dd>
			</dl>  
			<div class="divider"></div> 
			<dl>
				<dt style="font-size: 0.6rem;" >活动未开始提醒</dt>
				<dd>
					<input type="hidden"  name="name"  value="qingliang_not_start_message" > 
					<input type="text" name="qingliang_not_start_message" value="<c:out value="${webConfig_qingliang_not_start_message }" escapeXml="true"/>"   >
				</dd>
			</dl> 
			<dl>
				<dt style="font-size: 0.6rem;" >活动已结束提醒</dt>
				<dd>
					<input type="hidden"  name="name"  value="qingliang_had_end_message" > 
					<input type="text" name="qingliang_had_end_message" value="<c:out value="${webConfig_qingliang_had_end_message }" escapeXml="true"/>"   >
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt style="font-size: 0.6rem;" >初始总人数</dt>
				<dd>
					<input type="hidden"  name="name"  value="qingliang_init_count_person" > 
					<input class="digits" type="text" name="qingliang_init_count_person" value="<c:out value="${webConfig_qingliang_init_count_person }" escapeXml="true"/>"   >
				</dd>
			</dl> 
			<dl>
				<dt style="font-size: 0.6rem;" >初始总金额</dt>
				<dd>
					<input type="hidden"  name="name"  value="qingliang_init_zong_price" > 
					<input class="digits" type="text" name="qingliang_init_zong_price" value="<c:out value="${webConfig_qingliang_init_zong_price }" escapeXml="true"/>"   >
				</dd>
			</dl>
		</fieldset>