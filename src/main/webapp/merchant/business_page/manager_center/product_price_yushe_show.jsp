<%@page import="com.lymava.commons.state.State"%>
<%@page import="java.util.Iterator" %>
<%@page import="com.lymava.base.util.ContextUtil" %>
<%@page import="com.lymava.nosql.util.PageSplit" %>
<%@page import="com.lymava.commons.exception.CheckException" %>
<%@page import="com.lymava.base.util.FinalVariable" %>
<%@page import="com.lymava.base.model.User" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.util.List" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.lymava.qier.model.Cashier" %>
<%@ page import="com.lymava.qier.model.Product72" %>
<%@ page import="com.lymava.base.model.Pub" %>
<%@ page import="com.lymava.commons.util.MyUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%
    User user = (User) request.getAttribute(FinalVariable.SESSION_FRONT_FULL_USER);
    String product72_id = request.getParameter("product72_id");
    if (MyUtil.isValid(product72_id)){
        Product72 product72_find = (Product72)ContextUtil.getSerializContext().get(Product72.class, product72_id);
        request.setAttribute("product72_find",product72_find);
    }
%>
<script type="text/javascript">
$(function(){
	$('#canweifei_state').val('${product72_find.canweifei_state}');
	$('#yushe_state').val('${product72_find.yushe_state}');
});
</script>
<div style="padding:30px;padding-top: 10px;padding-bottom: 10px;" >
 <form  role="form" class="form-horizontal" id="product_price_yushe_form">
 	<input type="hidden" name="product_72_id" value="${product72_find.id }" >
	<div class="form-group">
		<label class="col-sm-2 control-label" style="width:30%;">开启预设</label>
		<div class="col-sm-10"  style="width:70%;">
			 <select class="form-control"  name="yushe_state" id="yushe_state">
                <option value="<%= Product72.yushe_state_kaiqi%>">开启</option>
                <option value="<%= Product72.yushe_state_guanbi%>">关闭</option>
            </select>
		</div>
	</div> 
	<div class="form-group">
		<label class="col-sm-2 control-label" style="width:30%;padding-left: 0;">收取餐位费</label>
		<div class="col-sm-10"  style="width:70%;">
			 <select  class="form-control"  name="canweifei_state" id="canweifei_state" >
                <option value="<%= State.STATE_FALSE %>">不收取</option>
                <option value="<%= State.STATE_OK%>">收取</option>
            </select>
		</div>
	</div>
	<div class="form-group">
		<label  class="col-sm-2 control-label" style="width:30%;">餐位费/人</label>
		<div class="col-sm-10"  style="width:40%;">
			<input type="text" class="form-control" name="canweifei" id="canweifei" value="${product72_find.canWeiFei_fen/100}" placeholder="餐位费">
		</div>
	</div>  
	<div class="form-group">
		<label  class="col-sm-2 control-label" style="width:30%;">预设金额</label>
		<div class="col-sm-10"  style="width:40%;">
			<input  type="text" class="form-control" name="product72_price" id="product72_price" value="${product72_find.preset_amount_fen/100}" placeholder="预设金额">
		</div>
		<label  class="col-sm-2 control-label" style="width:10%;">元</label>
	</div>  
	<div class="form-group">
		<label class="col-sm-2 control-label" style="width:30%;">用餐人数</label>
		<div class="col-sm-10"  style="width:40%;">
			<input   type="text" class="form-control" name="renshu" id="renshu" value="${product72_find.renshu}" placeholder="用餐人数">
		</div>
	</div>    
    </form>
</div>