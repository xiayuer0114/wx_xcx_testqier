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
					<dt>系统编号：</dt>
					<dd style="font-size: 0.8em;">
						<c:out value="${object.id }" escapeXml="true"/>
						<input type="hidden" name="object.id"  value="<c:out value="${object.id }" escapeXml="true"/>" />
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
						<dt>留言姓名：</dt>
						<dd>
							<input type="text"  name="object.name"  value="<c:out value="${object.name }" escapeXml="true"/>"   class="required"   >
						</dd>
					</dl> 
				<div class="divider"></div> 
					<dl>
						<dt>邮箱：</dt>
						<dd>
							<input type="text"  name="object.email"  value="<c:out value="${object.email }" escapeXml="true"/>"   class="required"   >
						</dd>
					</dl> 
				<div class="divider"></div> 
				<dl>
						<dt>内容：</dt>
						<dd>
							<input type="text"  name="object.leaveMessage"  value="<c:out value="${object.leaveMessage }" escapeXml="true"/>"   class="required"   >
						</dd>
					</dl> 
						<div class="divider"></div> 
				<dl>
						<dt>ip地址：</dt>
						<dd>
							<input type="text"  name="object.ipAddr"  value="<c:out value="${object.ipAddr }" escapeXml="true"/>"   class="required"   >
						</dd>
					</dl> 
						<div class="divider"></div> 
				<dl>
						<dt >提交时间</dt>
						<dd>
							<input type="text" class="date" dateFmt="yyyy-MM-dd HH:mm:ss"    name="object.inSubTimeDay"  value="<c:out value="${object.showSubTimeDay }" escapeXml="true"/>"   class="required"   >
						</dd>
					</dl> 
						<div class="divider"></div> 
				<dl>
						<dt >备注</dt>
						<dd>
							<input type="text"  name="object.memo"  value="<c:out value="${object.memo }" escapeXml="true"/>"  >
						</dd>
					</dl>
				<div class="divider"></div>
				<dl>
					<dt>状态：</dt>
					<dd>
						<select name="object.state" style="width: 155px;" class="required combox" svalue="${object.state }">
							<option  value="<%=Liuyan.state_ok %>" >正常</option>
							<option value="<%=Liuyan.state_false %>">  异常</option>
						</select>
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