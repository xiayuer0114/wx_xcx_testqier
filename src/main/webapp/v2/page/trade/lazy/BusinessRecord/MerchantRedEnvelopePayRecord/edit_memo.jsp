<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
     <script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
		</script> 
   <div class="pageContent" id="${currentTimeMillis }"  >
   	<form method="post" action="${basePath }${baseRequestPath }save.do"class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone);">
		<div class="pageFormContent" layoutH="56"> 
			<fieldset  >
					<%@ include file="inc/edit_show_base.jsp" %>
					<div class="divider"></div> 
					<dl>
						<dt>业务状态：</dt>
						<dd>
							${object.showState }
						</dd>
					</dl> 
					<div class="divider"></div>
					<dl  class="nowrap">
							<dt>备注：</dt>
							<dd>
								<textarea name="object.back_memo"  style="width: 200px;height: 100px;"  ><c:out value="${object.back_memo }" escapeXml="true"/></textarea>
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