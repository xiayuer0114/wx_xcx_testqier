<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
             <script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
		</script> 
<div class="pageContent" id="${currentTimeMillis }"  >
	<form method="post" action="${basePath }v2/huiyuan/resetUserName.do"class="pageForm required-validate" onsubmit="return validateCallback(this, navTabAjaxDone);">
		<div class="pageFormContent" layoutH="56">
			<fieldset  >
				<dl>
				<dt>登录名称：</dt>
				<dd>
					<c:out value="${user.username }" escapeXml="true" /> 
					<input type="hidden" name="user.id" value="${user.id }"   >
				</dd>
			</dl>   
				<div class="divider"></div>
				<dl>
				<dt>新登录名：</dt>
				<dd>
					<input type="text" name="new_username" value="" class="required" > 
				</dd>
			</dl>   
				<div class="divider"></div>
					<dl>
				<dt>确认名称：</dt>
				<dd>
					<input type="text" name="new_username_re" value="" class=""  autocomplete="off" > 
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
    