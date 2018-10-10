<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
</script> 
<div class="pageContent">
	<form method="post" action="${basePath }v2/huiyuan/balanceChange.do"class="pageForm required-validate" onsubmit="return validateCallback(this, navTabAjaxDone);">
		<div class="pageFormContent" >
		<fieldset  > 
			<dl>
				<dt>登录名称：</dt>
				<dd  >
					<input type="text" name="user.username" value="<c:out value="${user.username }" escapeXml="true" />" readonly="readonly" > 
					<input type="hidden" name="id" value="${user.id }"   >
					<input type="hidden" name="orderId" value="<%=(System.currentTimeMillis()+"").substring(1) %>"   >
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
					<input type="text" name="balance" value="" class="" style="width: 100px;"  >元 
				</dd>
			</dl> 
			<div class="divider"></div>
			<dl>
				<dt>备注说明：</dt>
				<dd  >
					<input type="text" name="memo" value="" class=""   > 
				</dd>
			</dl> 
			</fieldset>
		</div>
		<div class="formBar">
			<ul>
				<li><div class="buttonActive"><div class="buttonContent"><button type="submit">保存</button></div></div></li>
				<li>
					<div class="button"><div class="buttonContent"><button type="button" class="close">取消</button></div></div>
				</li>
			</ul>
		</div>
	</form>
</div>
    