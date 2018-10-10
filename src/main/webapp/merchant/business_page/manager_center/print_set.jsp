<%@page import="com.lymava.userfront.util.FrontUtil"%>
<%@page import="com.lymava.base.model.User"%>
<%@page import="com.lymava.commons.state.State"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	User front_user = FrontUtil.init_http_user(request);
	request.setAttribute("front_user", front_user);
%>
<div class="form-horizontal" style="width: 300px;"  >
<form id="print_set_form">
		<div class="form-body" >
	          <div class="form-group"  style="margin: 0;margin-top: 5px;width: 100%;"> 
	            <label class="col-md-4 control-label"  >自动打印</label>
	             <div class="col-md-8">
	               <select class="form-control" name="state_auto_print" >
			          <option <c:if test="${front_user.state_auto_print == 200 }">selected="selected"</c:if>   value="<%=State.STATE_OK %>">是</option>
			          <option <c:if test="${front_user.state_auto_print == 300 }">selected="selected"</c:if>  value="<%=State.STATE_FALSE %>">否</option>
			       </select>
	             </div>
	        </div>
	        <div class="form-group"  style="margin: 0;margin-top: 1rem;width: 100%;"> 
	            <label class="col-md-4 control-label"  >打印联数</label>
	             <div class="col-md-8">
	               <select class="form-control" name="print_lianshu">
	               	  <c:forEach begin="1" end="4" varStatus="i">
			          	<option <c:if test="${front_user.print_lianshu == i.count }">selected="selected"</c:if> value="${i.count }">${i.count }</option>
			          </c:forEach>
			       </select>
	             </div>
	        </div>
	        <div class="form-group"  style="margin: 0;margin-top: 1rem;width: 100%;"> 
	            <label class="col-md-4 control-label"  >打印机</label>
	             <div class="col-md-8">
		               <select svalue="${front_user.default_printer_name }" id="default_printer_name" class="form-control" name="default_printer_name">
				       </select>
	             </div>
	        </div>
	   </div>
	</form>
	 </div>