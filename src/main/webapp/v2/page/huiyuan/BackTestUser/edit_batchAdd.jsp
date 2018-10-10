<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
             <script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
		</script> 
<div class="pageContent" id="${currentTimeMillis }"  >
	<form method="post" action="${basePath }v2/BackTestUser/batch_save.do"class="pageForm required-validate" onsubmit="return validateCallback(this, navTabAjaxDone);">
		<div class="pageFormContent" layoutH="56">
			<fieldset  >
	
			
			
			<dl>
				<dt>增加个数</dt>
				<dd>
					<input type="text" name="number" value=""  > 
					<input type="hidden" name="userGroup.id"  value="<%=request.getParameter("userGroup.id") %>" >
				</dd>
			</dl> 
			
			<!-- 增加user -->
			
			
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
    