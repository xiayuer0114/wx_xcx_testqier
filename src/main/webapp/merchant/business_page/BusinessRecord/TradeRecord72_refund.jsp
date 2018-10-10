<%@page import="com.lymava.qier.model.Merchant72"%>
<%@page import="com.lymava.qier.util.QierUtil"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.qier.model.TradeRecord72"%>
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
	
	String tradeRecord_id = request.getParameter("tradeRecord_id");
	
	TradeRecord72 tradeRecord72 = null;
	
	if(MyUtil.isValid(tradeRecord_id)){
		tradeRecord72 = (TradeRecord72)ContextUtil.getSerializContext().get(TradeRecord72.class, tradeRecord_id);
	}
	
	request.setAttribute("tradeRecord72", tradeRecord72);
%>
<div class="form-horizontal" style="width: 350px;" >
	<form id="print_set_form">
			<div class="form-body" >
		          <div class="form-group"  style="margin: 0;margin-top: 5px;width: 100%;"> 
		            <label class="col-md-4 control-label"  >订单编号</label>
		             <div class="col-md-8">
		             	<h4 class="font-blue">${tradeRecord72.requestFlow }</h4>
		             	<input id="refund_requestFlow"  type="hidden"  class="form-control" value="<%=System.currentTimeMillis() %>" >
		             </div>
		        </div>
		        <div class="form-group"  style="margin: 0;margin-top: 5px;width: 100%;"> 
		            <label class="col-md-4 control-label"  >订单总价</label>
		             <div class="col-md-8">
		                <h4 class="font-blue">${tradeRecord72.showPrice_fen_all/100 }元</h4>
		             </div>
		        </div>
		        <div class="form-group"  style="margin: 0;margin-top: 5px;width: 100%;"> 
		            <label class="col-md-4 control-label"  >已退款</label>
		             <div class="col-md-8">
		                <h4 class="font-blue">${tradeRecord72.had_refund_amout_fen/100 }元</h4>
		             </div>
		        </div>
		        <div class="form-group"  style="margin: 0;margin-top: 5px;width: 100%;"> 
		            <label class="col-md-4 control-label"  >退款金额</label>
		             <div class="col-md-8">
		                <input  style="width: 8rem;" id="refundAmount" name="refundAmount"  type="text"  class="form-control"   value="${(tradeRecord72.showPrice_fen_all-tradeRecord72.had_refund_amout_fen)/100 }" >
		             </div>
		        </div>
		         <div class="form-group"  style="margin: 0;margin-top: 5px;width: 100%;"> 
		            <label class="col-md-4 control-label"  >退款说明</label>
		             <div class="col-md-8">
		                <input id="refund_memo" name="refund_memo"  type="text"  class="form-control" placeholder="记点什么" autocomplete="off">
		             </div>
		        </div>
		        <div class="form-group"  style="margin: 0;margin-top: 5px;width: 100%;"> 
		        	<label class="col-md-4 control-label"  >温馨提示</label>
		             <div class="col-md-8">
		             	 <h4 class="font-blue">定向红包不能退</h4>
		             </div>
		        </div>
		        <c:if test="${merchant72.payPwdState == 200}">
		        <div class="form-group"  style="margin: 0;margin-top: 5px;width: 100%;"> 
		            <label class="col-md-4 control-label"  >支付密码</label>
		             <div class="col-md-8">
		                <input id="pay_password" name="pay_password"  type="password"  class="form-control" placeholder="请输入支付密码" autocomplete="off" >
		             </div>
		        </div>
		        </c:if>
		   </div>
	</form>
	 </div>