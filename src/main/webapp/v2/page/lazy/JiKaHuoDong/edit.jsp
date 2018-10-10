<%@page import="com.lymava.qier.action.CashierAction"%>
<%@page import="com.lymava.qier.action.MerchantShowAction"%>
<%@page import="com.lymava.trade.business.model.Address"%>
<%@page import="com.lymava.base.vo.State"%>
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
		<div class="pageFormContent" > 
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
						<dt>商户：</dt>
						<dd class="lookup_dd">
							<input type="text" bringBack="user_merchant.showName"     value="<c:out value="${object.user_merchant.showName }" escapeXml="true"/>"   > 
							<input type="hidden" bringBack="user_merchant.userId" name="object.userId_merchant" value="${object.userId_merchant }"    >
							<a  class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%=CashierAction.getMerchantUserGroutId() %>" lookupGroup="user_merchant"  rel="user_merchant_lookup">查找</a>
						</dd> 
					</dl> 
					<div class="divider"></div>
					<dl>
						<dt>清凉金额：</dt>
						<dd>
							<input type="text"  name="object.inPrice_fen"  value="<c:out value="${object.price_fen/100 }" escapeXml="true"/>"   class="required number"   >
						</dd>
					</dl>  
					<div class="divider"></div>
					<dl  class="nowrap">
						<dt>清凉图：</dt>
						<dd>
							<input class="mydisupload required"   fileNumLimit="1" name="object.pic"  type="hidden"  value="${object.pic }" />
						</dd>
					</dl>  
					<div class="divider"></div>
					<dl  class="nowrap">
						<dt>关注图：</dt>
						<dd>
							<img class="upload_img" alt="" src="${basePath }${object.subscribe_pic}" style="width: 150px;height: 150px;">
						</dd>
					</dl>  
					<div class="divider"></div> 
					<dl >
						<dt>状态：</dt>
						<dd> 
							<select class="combox" name="object.state" svalue="${object.state }">
										<option value="<%=State.STATE_OK %>">正常活动</option>
										<option value="<%=State.STATE_FALSE %>">关闭活动</option>							
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