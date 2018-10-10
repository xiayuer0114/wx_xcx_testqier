<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%><%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">
	jQuery(function() {
		resetDialog();
	});
</script>
<div class="pageContent" id="${currentTimeMillis }">
<form method="post" action="${basePath }v2/webconfig/save.do"class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone)">
		<div class="pageFormContent" layoutH="56">
			<fieldset>
				<dl>
					<dt>登录名称：</dt>
					<dd>
						<input type="hidden"  name="name"  value="cmb_pay_login_name" > 
						<input type="text" name="cmb_pay_login_name" value="<c:out value="${webConfig_cmb_pay_login_name }" escapeXml="true"/>"  class="requied" >
					</dd>
				</dl>
				<div class="divider"></div> 
				<dl>
					<dt>分行号：</dt>
					<dd>
						<input type="hidden"  name="name"  value="cmb_pay_BBKNBR" > 
						<input type="text" name="cmb_pay_BBKNBR" value="<c:out value="${webConfig_cmb_pay_BBKNBR }" escapeXml="true"/>"  class="requied" >
					</dd>
				</dl>
				<div class="divider"></div> 
				<dl>
					<dt>银行帐号：</dt>
					<dd>
						<input type="hidden"  name="name"  value="cmb_pay_ACCNBR" > 
						<input type="text" name="cmb_pay_ACCNBR" value="<c:out value="${webConfig_cmb_pay_ACCNBR }" escapeXml="true"/>"  class="requied" >
					</dd>
				</dl>
				<div class="divider"></div> 
				<dl>
					<dt>前置机地址</dt>
					<dd>
						<input type="hidden"  name="name"  value="cmb_pay_hostname" > 
						<input type="text" name="cmb_pay_hostname" value="<c:out value="${webConfig_cmb_pay_hostname }" escapeXml="true"/>"  class="requied" >
					</dd>
				</dl>
				<div class="divider"></div> 
				<dl>
					<dt>前置机端口</dt>
					<dd>
						<input type="hidden"  name="name"  value="cmb_pay_port" > 
						<input type="text" name="cmb_pay_port" value="<c:out value="${webConfig_cmb_pay_port }" escapeXml="true"/>"  class="digits" >
					</dd>
				</dl>
			</fieldset>
		</div>
		<div class="formBar">
			<ul>
				<li><div class="buttonActive">
						<div class="buttonContent">
							<button type="submit">保存</button>
						</div>
					</div></li>
				<li>
					<div class="button">
						<div class="buttonContent">
							<button type="button" class="close">取消</button>
						</div>
					</div>
				</li>
			</ul>
		</div>
	</form>
</div>