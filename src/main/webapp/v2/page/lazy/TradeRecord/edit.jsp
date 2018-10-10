<%@page import="com.lymava.trade.business.model.TradeRecord"%>
<%@page import="com.lymava.base.vo.State"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
     <script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
		</script> 
   <div  class="pageContent" id="${currentTimeMillis }"  >
   <form method="post" action="${basePath }${baseRequestPath }save.do"class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone);">
		<div class="pageFormContent" layoutH="56"> 
			<fieldset  > 
					<dl>
						<dt>订单编号：</dt>
						<dd  >
							${object.id }
							<input type="hidden" name="object.id"  value="<c:out value="${object.id }" escapeXml="true"/>">
						</dd>
					</dl>  
					<div class="divider"></div> 
					<dl>
						<dt>支付单号：</dt>
						<dd  >
							<c:out value="${object.payFlow }" escapeXml="true"/>
						</dd>
					</dl>  
					<div class="divider"></div>  
					<dl>
						<dt>商户：</dt>
						<dd>
							<c:out value="${object.user_merchant.nickname }" escapeXml="true"/> 
						</dd>
					</dl>  
					<div class="divider"></div>  
					<dl>
						<dt>会员：</dt>
						<dd>
							<c:out value="${object.user_huiyuan.showName }" escapeXml="true"/> 
						</dd>
					</dl>  
					<div class="divider"></div>  
					<dl>
						<dt>购买数量：</dt>
						<dd>
							<c:out value="${object.quantity/100 }" escapeXml="true"/> 
						</dd>
					</dl>  
					<div class="divider"></div>  
					<dl>
						<dt>单价：</dt>
						<dd>
							<c:out value="${object.price_fen/100 }" escapeXml="true"/> 
						</dd>
					</dl>  
					<div class="divider"></div>  
					<dl>
						<dt>总价：</dt>
						<dd>
							<c:out value="${object.price_fen_all/100 }" escapeXml="true"/> 
						</dd>
					</dl>   
					<div class="divider"></div>  
					<dl>
						<dt>总价：</dt>
						<dd>
							<c:out value="${object.price_fen_all/100 }" escapeXml="true"/> 
						</dd>
					</dl>   
					<div class="divider"></div> 
					<dl  >
						<dt>状态：</dt>
						<dd>
							<select class="combox" name="object.state" svalue="${object.state }">
								<option value="<%=State.STATE_WAITE_PAY %>">等待付款</option>							
								<option value="<%=State.STATE_PAY_SUCCESS %>">付款成功</option>
								<option value="<%=State.STATE_FALSE %>">支付失败</option>
								<option value="<%=State.STATE_CLOSED %>">交易关闭</option>
							</select>
						</dd>
					</dl>
			</fieldset>
		</div>
		<div class="formBar">
			<ul>
				<li><div class="buttonActive"><div class="buttonContent"><button type="submit">保存</button></div></div></li>
				<li>
					<div class="button"><div class="buttonContent"><button type="button" class="close">关闭</button></div></div>
				</li>
			</ul>
		</div>
	</form>
</div>