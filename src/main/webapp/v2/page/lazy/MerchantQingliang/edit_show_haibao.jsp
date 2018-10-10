<%@page import="com.lymava.qier.action.CashierAction"%>
<%@page import="com.lymava.qier.action.MerchantShowAction"%>
<%@page import="com.lymava.trade.business.model.Address"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	
%>
     <script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
		</script>
   <div  class="pageContent" id="${currentTimeMillis }"  >
		<div class="pageFormContent" > 
			<fieldset  >
					<dl class="nowrap" >
						<dt>商户名称</dt>
						<dd >
							<c:out value="${object.user_merchant.showName }" escapeXml="true"/>
						</dd> 
					</dl> 
					<div class="divider"></div>
					<dl >
						<dt>商户编号</dt>
						<dd >
							<c:out value="${object.user_merchant.bianhao }" escapeXml="true"/>
						</dd> 
					</dl>  
					<div class="divider"></div>
					<dl >
						<dd style="width: 100%;" >
							
						</dd> 
					</dl>  
			</fieldset>
		</div>
		<div class="formBar">
			<ul>
				<li>
					<div class="button"><div class="buttonContent"><button type="button" class="close">关闭</button></div></div>
				</li>
			</ul>
		</div>
</div>