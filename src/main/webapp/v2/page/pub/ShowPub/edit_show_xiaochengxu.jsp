<%@ page language="java" contentType="text/html; charset=UTF-8"
		pageEncoding="UTF-8"%><%@ taglib prefix="c"
		uri="http://java.sun.com/jsp/jstl/core"%>
	<script type="text/javascript">
		jQuery(function() {
			resetDialog();
		});
	</script>
	<div class="pageContent" id="${currentTimeMillis }">
		<form method="post" action="${basePath }v2/webconfig/save.do"
			class="pageForm required-validate"
			onsubmit="return validateCallback(this,navTabAjaxDone)">
			<div class="pageFormContent" layoutH="56">
				<fieldset>
					<dl>
						<dt>商家展示连接</dt>
						<dd>
							<input type="text" style="width: 450px"
								value="/pages/mylive/detail?id=<c:out value="${pub.id }" escapeXml="true"/>" >
						</dd>
					</dl>


					<div class="divider"></div>

					<dl>
						<dt>专题展示连接</dt>
						<dd>
							<input type="text" style="width: 450px"
								   value="/pages/recommend/detail?id=<c:out value="${pub.id }" escapeXml="true"/> ">
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