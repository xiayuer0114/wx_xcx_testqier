<%@page import="com.lymava.qier.action.CashierAction"%>
<%@page import="com.lymava.qier.action.MerchantShowAction"%>
<%@page import="com.lymava.trade.business.model.Address"%>
<%@page import="com.lymava.base.vo.State"%>
<%@ page import="com.lymava.commons.util.MyUtil" %>
<%@ page import="com.lymava.qier.model.MerchantRedEnvelope" %>
<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
     <script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
		</script>
   <div  class="pageContent" id="${currentTimeMillis }"  >


	   <%
		   String merchantRedId = (String)request.getAttribute("merchantRedId");

		   if(MyUtil.isValid(merchantRedId)){

			   MerchantRedEnvelope merchantRed_find = (MerchantRedEnvelope)ContextUtil.getSerializContext().get(MerchantRedEnvelope.class, merchantRedId);

			   if(merchantRed_find !=null){
			       request.setAttribute("update_merchantRed_find",merchantRed_find);
			   }
		   }
	   %>


   <form method="post" action="${basePath }${baseRequestPath }batch_updateHongBaoName_ok.do"class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone);">
		<div class="pageFormContent" layoutH="56"> 
			<fieldset  >
					<dl>
						<dt>商家：</dt>
						<dd>
							<input type="text" bringBack="user_merchant.showName" value="<c:out value="${update_merchantRed_find.user_merchant.nickname }" escapeXml="true"/>" readonly="readonly" >
							<input type="hidden" bringBack="user_merchant.userId" name="object.userId_merchant" value="${update_merchantRed_find.userId_merchant }"    >
							<a  class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%=CashierAction.getMerchantUserGroutId() %>" lookupGroup="user_merchant"  rel="user_merchant_lookup">查找</a>
						</dd>
					</dl>

					<div class="divider"></div>
					<dl>
						<dt>原红包名：</dt>
						<dd>
							<input type="text" value="<c:out value="${update_merchantRed_find.red_envolope_name }" escapeXml="true"/>" readonly="readonly"  >
						</dd>
					</dl>

					<div class="divider"></div>
					<dl>
						<dt>新红包名：</dt>
						<dd>
							<input type="text" name="object.new_red_envolope_name" value="" escapeXml="true"/>"   >
						</dd>
					</dl>
			</fieldset>
		</div>
		<div class="formBar">
			<ul>
				<li><div class="buttonActive"><div class="buttonContent"><button type="submit">确定</button></div></div></li>
				<li>
					<div class="button"><div class="buttonContent"><button type="button" class="close">关闭</button></div></div>
				</li>
			</ul>
		</div>
	</form>
</div>