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
		<div class="pageFormContent">
			<fieldset>
				<dl class="nowrap"> 
					<dt>关注成功消息</dt>
					<dd>
						<input type="hidden" name="name" value=subscribe_return_message>
						<textarea name="subscribe_return_message" style="width: 300px;height: 200px;">${webConfig_subscribe_return_message }</textarea>
					</dd>
				</dl>
				<div class="divider"></div> 
				<dl>
					<dt style="width: 160px;">领取红包订单金额(大于)</dt>
					<dd style="width: 50px;">
						<input type="hidden"  name="name"  value="receive_red_envelope_order_price_yuan" > 
						<input style="width: 30px;" type="text" name="receive_red_envelope_order_price_yuan" value="<c:out value="${webConfig_receive_red_envelope_order_price_yuan }" escapeXml="true"/>"  class="required number" >元
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