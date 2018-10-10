<%@page import="com.lymava.trade.business.model.Address"%>
<%@page import="com.lymava.base.vo.State"%>
<%@ page import="com.lymava.base.model.User" %>
<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
     <script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
		</script>
   <div  class="pageContent" id="${currentTimeMillis }"  >
   <form method="post" action="${basePath }${baseRequestPath }fabu_voucher.do"class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone);">
		<div class="pageFormContent" >
			<fieldset  > 
					<dl >
						<dt>商家：</dt>
						<dd class="lookup_dd">
							<c:out value="${object.showInNickName}" escapeXml="true"/>
							<input type="hidden" name="object.topUserId"  value="<c:out value="${object.topUserId }" escapeXml="true"/>">
						</dd>
					</dl>
					<div class="divider"></div>
					<dl>
						<dt>代金券名称：</dt>
						<dd>
							<c:out value="${object.voucherName }" escapeXml="true"/>
							<input type="hidden" name="voucherId"  value="<c:out value="${object.id }" escapeXml="true"/>">
							<input type="hidden" name="shangjiaId"  value="<c:out value="${object.topUserId }" escapeXml="true"/>">
							<input type="hidden" name="voucherCount"  value="<c:out value="${object.voucherCount }" escapeXml="true"/>">
							<input type="hidden" name="voucherOutCount"  value="<c:out value="${object.voucherOutCount }" escapeXml="true"/>">
						</dd>
					</dl>
					<div class="divider"></div>
					<dl>
						<dt>面额：</dt>
						<dd>
							<c:out value="${object.voucherValue }" escapeXml="true"/>

						</dd>
					</dl>
				<div class="divider"></div>
					<dl  class="nowrap">
						<dt>发放数量：</dt>
						<dd>
							<input type="text"  name="fabuCount"  value="1"  />
						</dd>
					</dl>
				<div class="divider"></div> 
				<dl >
					<dt>发送用户：</dt>
					<dd class="lookup_dd">
						<input type="text"   bringBack="user_merchant.showName" value=""     > 
						<input type="hidden"  bringBack="user_merchant.userId"  name="userId" value=""    >
						<a  class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup" lookupGroup="user_merchant"  rel="topuser_lookup">查找</a>
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