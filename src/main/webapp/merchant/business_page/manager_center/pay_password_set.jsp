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
	            <label class="col-md-4 control-label"  >启用密码</label>
	             <div class="col-md-8">
	               <select class="form-control" name="payPwdState" >
			          <option <c:if test="${front_user.payPwdState == 200 }">selected="selected"</c:if>   value="<%=State.STATE_OK %>">是</option>
			          <option <c:if test="${front_user.payPwdState == 300 }">selected="selected"</c:if>  value="<%=State.STATE_FALSE %>">否</option>
			       </select>
	             </div>
	        </div>
	        <div class="form-group"  style="margin: 0;margin-top: 5px;width: 100%;"> 
	            <label class="col-md-4 control-label"  >支付密码</label>
	             <div class="col-md-8">
	                <input type="password" class="form-control" name="old_payPass" autocomplete="off"" />
	             </div>
	        </div>
	        <div class="form-group"  style="margin: 0;margin-top: 5px;width: 100%;"> 
	            <label class="col-md-4 control-label"  >新密码</label>
	             <div class="col-md-8">
	                <input type="password" class="form-control" name="new_payPass" autocomplete="off"" />
	             </div>
	        </div>
	        <div class="form-group"  style="margin: 0;margin-top: 5px;width: 100%;"> 
	            <label class="col-md-4 control-label"  >密码确认</label>
	             <div class="col-md-8">
	                <input type="password" class="form-control" name="new_payPass_re" autocomplete="off"" />
	             </div>
	        </div>
	   </div>
	</form>
	 </div>