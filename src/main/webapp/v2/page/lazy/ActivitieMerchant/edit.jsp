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
					<dl >
						<dt>商家：</dt>
						<dd class="lookup_dd">
							<input type="text" bringBack="user_merchant.showName"     value="<c:out value="${object.user_merchant72.showName }" escapeXml="true"/>"   >
							<input type="hidden" bringBack="user_merchant.userId" name="object.user_merchant_id" value="${object.user_merchant_id }"    >
							<a  class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%=CashierAction.getMerchantUserGroutId() %>" lookupGroup="user_merchant"  rel="user_merchant_lookup">查找</a>
						</dd>
					</dl>

					<div class="divider"></div>

					<dl >
						<dt>标题：</dt>
						<dd class="lookup_dd">
							<input type="text"  style="width: 200px" name="object.redEnvelope_title"  value="<c:out value="${object.redEnvelope_title }" escapeXml="true"/>" >
						</dd>
					</dl>

					<div class="divider"></div>

					<dl >
						<dt>状态：</dt>
						<dd> 
							<select class="combox" name="object.state" svalue="${object.state }">
								<option value="<%=State.STATE_OK %>">正常</option>
								<option value="<%=State.STATE_FALSE %>">异常</option>
							</select>
						</dd>
					</dl>

				<dl>
					<dt>活动金额</dt>
					<dd>
						<input type="text"  name="object.inActivity_redEnvelope_price_yuan" value="<c:out value="${object.showActivity_redEnvelope_price_yuan }" escapeXml="true" />" class="required">
					</dd>
				</dl>

				<div class="divider"></div>

				<dl class="nowrap">
					<dt>红包头像：</dt>
					<dd>
						<input class="mydisupload"   fileNumLimit="1" name="object.redEnvelope_headPic"  type="hidden"  value="<c:out value="${object.redEnvelope_headPic }" escapeXml="true" />" />
					</dd>
				</dl>

				<dl class="nowrap">
					<dt>展示图片：</dt>
					<dd>
						<input class="mydisupload"   fileNumLimit="1" name="object.redEnvelope_pic"  type="hidden"  value="<c:out value="${object.redEnvelope_pic }" escapeXml="true" />" />
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