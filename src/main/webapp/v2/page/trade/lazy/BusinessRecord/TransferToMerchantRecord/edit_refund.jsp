<%@page import="com.lymava.commons.state.State"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
     <script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
		</script> 
   <div class="pageContent" id="${currentTimeMillis }"   >
   	<form method="post" action="${basePath }v2/paymentRecord/refund.do"class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone);">
		<div class="pageFormContent" > 
			<fieldset >
					<%@ include file="inc/edit_show_base.jsp" %>
					<div class="divider"></div>  
					<dl>
						<dt>当前状态：</dt>
						<dd>
							<c:out value="${object.showState }" escapeXml="true" />
							<input type="hidden" name="requestFlow"  value="${currentTimeMillis }">
						</dd>
					</dl> 
					<dl>
						<dt>变更到：</dt>
						<dd>
							<select name="state" class="combox"  >
			                    <option  value="<%=State.STATE_REFUND_OK %>" >已退款</option>
							</select>
						</dd>
					</dl> 
					<div class="divider"></div>  
					<dl>
						<dt>退款金额：</dt>
						<dd>
							<input style="width:60px;" type="text" name="refundAmount"  value="<c:out value="${-object.price_fen_all/100 }" escapeXml="true"/>"    class="required">
						</dd>
					</dl> 
					<dl>
						<dt>备注：</dt>
						<dd>
							 <input style="width:100px;" type="text" name="refundAmountMemo"  value=""  >
						</dd>
					</dl> 
			</fieldset>
		</div>
		<div class="formBar">
			<ul>
				<li><div class="buttonActive"><div class="buttonContent"><button type="submit">确认退款</button></div></div></li>
				<li>
					<div class="button"><div class="buttonContent"><button type="button" class="close">取消</button></div></div>
				</li>
			</ul>
		</div>
	</form>
</div>