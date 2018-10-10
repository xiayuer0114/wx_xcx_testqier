<%@page import="com.lymava.commons.state.State"%>
<%@ page import="com.lymava.qier.model.qianduanModel.Liuyan" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
       <script type="text/javascript">
					jQuery(function(){
						uploadInitMy();
						resetDialog();
					});
		</script> 
  
   <div  class="pageContent" id="${currentTimeMillis }"  >
   <form method="post" action="${basePath }${baseRequestPath }save.do"class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone);">
		<div class="pageFormContent"  > 
			<fieldset class="fieldset_tmp" >
				<dl>
					<dt>系统编号:</dt>
					<dd style="font-size: 0.8em;">
						<c:out value="${object.id }" escapeXml="true"/>
						<input type="hidden" name="object.id"  value="<c:out value="${object.id }" escapeXml="true"/>" />
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
						<dt>openid:</dt>
						<dd>
							<c:out value="${object.openid }" escapeXml="true"/>
						</dd>
					</dl> 
				<div class="divider"></div> 
					<dl>
						<dt>测试名:</dt>
						<dd>
							<c:out value="${object.test_name }" escapeXml="true"/>
						</dd>
					</dl> 
				<div class="divider"></div> 
				<dl>
						<dt>所选答案分:</dt>
						<dd>
							<c:out value="${object.da_an }" escapeXml="true"/>
						</dd>
					</dl> 
						<div class="divider"></div> 
				<dl>
						<dt>图片名称:</dt>
						<dd>
							<c:out value="${object.result_img }" escapeXml="true"/>
						</dd>
					</dl> 
						<div class="divider"></div> 
				<dl>
						<dt >状态:</dt>
						<dd>
							<c:out value="${object.showState }" escapeXml="true"/>
						</dd>
					</dl>
			</fieldset> 
																						
		</div>
		<div class="formBar">
			<ul>
				<li>
					<div class="button"><div class="buttonContent"><button type="button" class="close">关闭</button></div></div>
				</li>
			</ul>
		</div>
	</form>
</div>