<%@page import="com.lymava.qier.action.CashierAction"%>
<%@ page import="com.lymava.commons.state.State" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
     <script type="text/javascript">
					jQuery(function(){
                        uploadInitMy();
						resetDialog();
					});
		</script>
   <div  class="pageContent" id="${currentTimeMillis }"  >
   <form method="post" action="${basePath }${baseRequestPath }save.do"class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone);">
		<div class="pageFormContent" layoutH="56"> 
			<fieldset  >
					<dl >
						<dt>系统编号：</dt>
						<dd style="font-size: 0.8em;">
							<c:out value="${object.id }" escapeXml="true"/>
							<input type="hidden" name="object.id"  value="<c:out value="${object.id }" escapeXml="true"/>" />
						</dd>
					</dl>

					<div class="divider"></div>

					<dl>
						<dt>红包名称：</dt>
						<dd>
							<input type="text"  name="object.activity_redEnvelope_name"  value="<c:out value="${object.activity_redEnvelope_name }" escapeXml="true"/>"  >
						</dd>
					</dl>
					<div class="divider"></div>
					<dl >
						<dt>商家：</dt>
						<dd class="lookup_dd">
							<input type="text" bringBack="user_merchant.showName"     value="<c:out value="${object.merchant72.showName }" escapeXml="true"/>"   >
							<input type="hidden" bringBack="user_merchant.inMerchant_user_id" name="object.user_merchant_id" value="${object.merchant_user_id }"    >
							<a  class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%=CashierAction.getMerchantUserGroutId() %>" lookupGroup="user_merchant"  rel="user_merchant_lookup">查找</a>
						</dd>
					</dl>

					<div class="divider"></div>


					<div class="divider"></div>

					<dl >
						<dt>状态：</dt>
						<dd> 
							<select class="combox" name="object.state" svalue="${object.state }">
								<option value="<%=State.STATE_OK %>">正常</option>
								<option value="<%=State.STATE_WAITE_CHANGE %>">等待支付</option>
								<option value="<%=State.STATE_ALL_IN_ONE_PAY_SUCCESS %>">等待好友支付</option>
								<option value="<%=State.STATE_PAY_SUCCESS %>">付款成功</option>
								<option value="<%=State.STATE_FALSE %>">异常</option>
							</select>
						</dd>
					</dl>

				<div class="divider"></div>

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