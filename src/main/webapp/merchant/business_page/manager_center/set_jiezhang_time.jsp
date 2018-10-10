<%@page import="com.lymava.qier.util.QierUtil"%>
<%@page import="com.lymava.qier.model.Merchant72"%>
<%@page import="com.lymava.userfront.util.FrontUtil"%>
<%@page import="com.lymava.base.model.User"%>
<%@page import="com.lymava.commons.state.State"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	User front_user = FrontUtil.init_http_user(request);
	request.setAttribute("front_user", front_user);
	
	Merchant72 merchant72 = QierUtil.getMerchant72User(front_user);
	request.setAttribute("merchant72", merchant72);
%>
<div class="form-horizontal" style="width: 300px;"  >
<form id="pay_password_set">
		<div class="form-body" >
	          <div class="form-group"  style="margin: 0;margin-top: 5px;width: 100%;"> 
	            <label class="col-md-4 control-label"  >结帐时间</label>
	             <div class="col-md-8">
		              <select class="form-control selHour" >
								<c:forEach begin="0" end="23" varStatus="i">
				                  <option <c:if test="${front_user.queryHour == i.count-1 }">selected="selected"</c:if>  value="${i.count-1 }">每日${i.count-1 }点</option>
				                </c:forEach>  
				      </select>
	             </div>
	        </div>
	        <div class="form-group"  style="margin: 0;margin-top: 5px;width: 100%;"> 
	            <label class="col-md-4 control-label"  >语音播报</label>
	             <div class="col-md-8">
	                <select class="form-control state_auto_voice" >
			            <option <c:if test="${front_user.state_auto_voice == 300 }">selected="selected"</c:if>  value="<%=State.STATE_FALSE %>">关闭</option>
			            <option <c:if test="${front_user.state_auto_voice == 200 }">selected="selected"</c:if>  value="<%=State.STATE_OK %>">开启</option>
			     	</select>
	             </div>
	        </div>
	        <div class="form-group"  style="margin: 0;margin-top: 5px;width: 100%;"> 
	            <label class="col-md-4 control-label"  >收银牌预置</label>
	             <div class="col-md-8">
	                <select class="form-control state_shaoma_yuzhi" >
			        	<option <c:if test="${front_user.state_shaoma_yuzhi == 300 }">selected="selected"</c:if>  value="<%=State.STATE_FALSE %>">关闭</option>
			            <option <c:if test="${front_user.state_shaoma_yuzhi == 200 }">selected="selected"</c:if>  value="<%=State.STATE_OK %>">开启</option>
			      </select>
	             </div>
	        </div>
	   </div>
	</form>
	 </div>