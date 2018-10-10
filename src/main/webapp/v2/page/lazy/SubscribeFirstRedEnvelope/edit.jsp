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
						<dt>系统编号：</dt>
						<dd>
							<c:out value="${object.id }" escapeXml="true"/>
							<input  type="hidden" name="object.id"  value="<c:out value="${object.id }" escapeXml="true"/>"  >
						</dd>
					</dl> 
				<div class="divider"></div> 
					<dl>
						<dt>用户名称：</dt>
						<dd>
							<c:out value="${object.user72.nickname }" escapeXml="true"/>
						</dd>
					</dl> 
				<div class="divider"></div> 
				<dl>
						<dt>用户openid：</dt>
						<dd>
							<c:out value="${object.openid }" escapeXml="true"/>
						</dd>
					</dl> 
						<div class="divider"></div> 
				<dl>
						<dt>红包金额：</dt>
						<dd>
							<c:out value="${object.amount_fen/100 }" escapeXml="true"/>
						</dd>
					</dl> 
						<div class="divider"></div> 
				<dl>
						<dt style="font-size: 0.7rem;">红包开始时间 </dt>
						<dd>
							<c:out value="${object.showStartTime }" escapeXml="true"/>
						</dd>
					</dl> 
						<div class="divider"></div> 
				<dl>
						<dt style="font-size: 0.7rem;">红包结束时间</dt>
						<dd>
							<c:out value="${object.showEndTime }" escapeXml="true"/>
						</dd>
					</dl> 
						<div class="divider"></div> 
				<dl>
						<dt>红包状态：</dt>
						<dd>
							<select class="combox" name="object.state" svalue="${object.state }">
								<option value="<%=State.STATE_WAITE_PROCESS %>">等待传图</option>
								<option value="<%=State.STATE_OK %>">已回传图</option>
								<option value="<%=State.STATE_WAITE_PAY %>">已发放</option>
								<option value="<%=State.STATE_PAY_SUCCESS %>">已使用</option>
							</select>
						</dd>
					</dl> 
					<div class="divider"></div> 
					<dl class="nowrap">
						<dt>图片地址：</dt>
						<dd>
							<input   class="mydisupload"   fileNumLimit="1" name="object.pictureAddress"  type="hidden"  value="<c:out value="${object.pictureAddress }" escapeXml="true" />" />
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