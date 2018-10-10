<%@page import="com.lymava.commons.state.State"%>
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
						<dt>考生姓名：</dt>
						<dd>
							<c:out value="${object.id }" escapeXml="true"/>
							<input  type="hidden" name="object.name"  value="<c:out value="${object.name }" escapeXml="true"/>"  >
						</dd>
					</dl> 
				<div class="divider"></div> 
					<dl>
						<dt>身份证号：</dt>
						<dd>
							<c:out value="${object.idNumber}" escapeXml="true"/>
						</dd>
					</dl> 
				<div class="divider"></div> 
				<dl>
						<dt>考生证：</dt>
						<dd>
							<c:out value="${object.examineeCard }" escapeXml="true"/>
						</dd>
					</dl> 
						<div class="divider"></div> 
				<dl>
						<dt>报名序号：</dt>
						<dd>
							<c:out value="${object.signUpSerialNumber}" escapeXml="true"/>
						</dd>
					</dl> 
						<div class="divider"></div> 
				<dl>
						<dt >性别</dt>
						<dd>
							<c:out value="${object.sex }" escapeXml="true"/>
						</dd>
					</dl> 
						<div class="divider"></div> 
				<dl>
						<dt >科类型</dt>
						<dd>
							<c:out value="${object.artsAndScience }" escapeXml="true"/>
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