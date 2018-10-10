<%@page import="com.lymava.base.model.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
         <script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
		</script> 
<div class="pageContent" id="${currentTimeMillis }" >
	<form method="post" action="${basePath }v2/huiyuan/resetPayPass.do"class="pageForm required-validate" onsubmit="return validateCallback(this, navTabAjaxDone);">
		<div class="pageFormContent" layoutH="56">
		<fieldset  >
			<dl>
				<dt>登录名称：</dt>
				<dd> 
								<input type="text" name="user.username" value="<c:out value="${user.username }" escapeXml="true" />" readonly="readonly" > 
								<input type="hidden" name="id" value="${user.id }"   >
				</dd>
			</dl>  
			<div class="divider"></div>
			<dl>
				<dt>昵称：</dt>
				<dd> 
					<input type="text" name="user.nickname" value="<c:out value="${user.nickname }" escapeXml="true" />"  readonly="readonly" > 
				</dd>
			</dl>  
			<div class="divider"></div> 
			<dl>
				<dt>支付状态</dt>
				<dd>
						<select name="user.payPwdState" style="width: 155px;" class="required combox" svalue="${user.payPwdState }">
								<option  value="<%=User.payPwdState_STATE_OK %>" >启用支付密码</option>
								<option value="<%=User.payPwdState_STATE_NOTOK %>"  >停用支付密码</option>
						</select> 
				</dd>
			</dl>
			<div class="divider"></div>
				<dl>
				<dt>支付密码：</dt>
				<dd> 
				<input type="password" name="payPass" value="" class="" autocomplete="off" > 
			</dd>
			</dl>  
			<div class="divider"></div>
			<dl>
				<dt>密码确认：</dt>
				<dd> 
				<input type="password" name="payPassRe" value="" class="" autocomplete="off" > 
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
    