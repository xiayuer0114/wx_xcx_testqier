<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.alipay.api.domain.Context"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.qier.model.Merchant72"%>
<%@page import="com.lymava.base.util.WebConfigContent"%>
<%@page import="com.lymava.qier.action.CashierAction"%>
<%@page import="com.lymava.base.model.User"%>
<%@page import="com.lymava.base.model.Pub"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<fieldset >
			<dl>
				<dt>活动开始</dt>
				<dd>
					<input type="hidden"  name="name"  value="activities_kol200_startTime" > 
					<input type="text" name="activities_kol200_startTime" value="<c:out value="${webConfig_activities_kol200_startTime }" escapeXml="true"/>"  class="date" dateFmt="yyyy-MM-dd HH:mm:ss"  >
				</dd>
			</dl>
			<dl>
				<dt>活动结束</dt>
				<dd>
					<input type="hidden"  name="name"  value="activities_kol200_endTime" > 
					<input type="text" name="activities_kol200_endTime" value="<c:out value="${webConfig_activities_kol200_endTime }" escapeXml="true"/>"  class="date" dateFmt="yyyy-MM-dd HH:mm:ss" >
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt style="font-size: 0.8rem;" >未开始提醒</dt>
				<dd>
					<input type="hidden"  name="name"  value="activities_kol200_not_start_msg" > 
					<input type="text" name="activities_kol200_not_start_msg" value="<c:out value="${webConfig_activities_kol200_not_start_msg }" escapeXml="true"/>"   >
				</dd>
			</dl>
			<dl>
				<dt style="font-size: 0.8rem;" >已结束提醒</dt>
				<dd>
					<input type="hidden"  name="name"  value="activities_kol200_had_end_msg" > 
					<input type="text" name="activities_kol200_had_end_msg" value="<c:out value="${webConfig_activities_kol200_had_end_msg }" escapeXml="true"/>"  >
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl class="nowrap">
				<dt>已领提醒</dt>
				<dd>
					<input type="hidden"  name="name"  value="activities_kol200_had_get_msg" > 
					<textarea name="activities_kol200_had_get_msg"  style="width: 300px;height: 100px;"><c:out value="${webConfig_activities_kol200_had_get_msg }" escapeXml="true"/></textarea>
				</dd>
			</dl> 
			<div class="divider"></div> 
			<dl>
				<dt>红包名称：</dt>
				<dd>
					<input type="hidden"  name="name"  value="activities_kol200_red_envolope_name" > 
					<input type="text" name="activities_kol200_red_envolope_name" value="<c:out value="${webConfig_activities_kol200_red_envolope_name }" escapeXml="true"/>">
				</dd>
			</dl> 
			<dl>
				<dt>红包金额：</dt>
				<dd>
					<input type="hidden"  name="name"  value="activities_kol200_amount_yuan" > 
					<input type="text" name="activities_kol200_amount_yuan" value="<c:out value="${webConfig_activities_kol200_amount_yuan }" escapeXml="true"/>"  class="number" >
				</dd>
			</dl> 
			<div class="divider"></div> 
			<dl>
				<dt>红包商家：</dt>
				<dd class="lookup_dd"> 
					<%
						String activities_kol200_userId_merchant = WebConfigContent.getConfig("activities_kol200_userId_merchant");
						Merchant72 merchant72 = null;
						if(MyUtil.isValid(activities_kol200_userId_merchant)){
							merchant72 = (Merchant72)ContextUtil.getSerializContext().get(Merchant72.class, activities_kol200_userId_merchant);						
						}
						request.setAttribute("merchant72", merchant72);
					%>
					<input type="text" 	 bringBack="user_merchant.showName"     value="<c:out value="${merchant72.nickname }" escapeXml="true"/>"   > 
					<input type="hidden"  name="name"  value="activities_kol200_userId_merchant" > 
					<input type="hidden" bringBack="user_merchant.userId" name="activities_kol200_userId_merchant" value="${webConfig_activities_kol200_userId_merchant }"    class="required"  readonly="readonly">
					<a  class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%=CashierAction.getMerchantUserGroutId() %>" lookupGroup="user_merchant"  rel="user_merchant_lookup">查找</a>
				</dd>
			</dl>
			<div class="divider"></div>  
			<dl>
				<dt>有效期至</dt>
				<dd>
					<input type="hidden"  name="name"  value="activities_kol200_RedEnvelope_end_time" > 
					<input type="text" name="activities_kol200_RedEnvelope_end_time" value="<c:out value="${webConfig_activities_kol200_RedEnvelope_end_time }" escapeXml="true"/>"  class="date" dateFmt="yyyy-MM-dd HH:mm:ss" >
				</dd>
			</dl> 
			<div class="divider"></div> 
			<dl class="nowrap">
				<dt style="font-size: 0.7rem;">发放成功消息：</dt>
				<dd>
					<input type="hidden"  name="name"  value="kol200_get_red_success_message" > 
					<textarea name="kol200_get_red_success_message"  style="width: 300px;height: 100px;"><c:out value="${webConfig_kol200_get_red_success_message }" escapeXml="true"/></textarea>
				</dd>
			</dl>
		</fieldset>