<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
					jQuery(function(){
                        uploadInitMy();
						resetDialog();
					});
</script> 
<div class="pageContent">
	<form method="post" action="${basePath }v2/Merchant72/merchant_redenvelope_balance_change.do"class="pageForm required-validate" onsubmit="return validateCallback(this, navTabAjaxDone);">
		<div class="pageFormContent" layoutH="56">
		<fieldset  > 
			<dl>
				<dt>登录名称：</dt>
				<dd  >
					<input type="text" name="user.username" value="<c:out value="${user.username }" escapeXml="true" />" readonly="readonly" > 
					<input type="hidden" name="id" value="${user.id }"   >
				</dd>
			</dl> 
			<div class="divider"></div>
			<dl>
				<dt>昵称：</dt>
				<dd  >
					<input type="text" name="user.nickname" value="<c:out value="${user.nickname }" escapeXml="true" />"  readonly="readonly" > 
				</dd>
			</dl> 
			<div class="divider"></div>
				<dl>
				<dt>变动余额：</dt> 
				<dd  >
					<input type="text" name="merchant_redenvelope_balance_change" value="" class="" style="width: 100px;"  >元 
				</dd>
			</dl>
			<div class="divider"></div>
			<dl class="nowrap" >
				<dt>变动凭证</dt>
				<dd>
					<input class="mydisupload required"   fileNumLimit="1" name="pinzheng"  type="hidden"  value="" />
				</dd>
			</dl>
			<div class="divider"></div>
			<dl>
				<dt>备注：</dt>
				<dd>
					<input type="text" name="transter_memo" value=""  >
				</dd>
			</dl>
		</fieldset>
		</div>
		<div class="formBar">
			<ul>
				<li><div class="buttonActive"><div class="buttonContent"><button type="submit">提交审核</button></div></div></li>
				<li>
					<div class="button"><div class="buttonContent"><button type="button" class="close">取消</button></div></div>
				</li>
			</ul>
		</div>
	</form>
</div>
    