<%@page import="com.lymava.qier.action.MerchantShowAction"%>
<%@page import="com.lymava.trade.business.model.Address"%>
<%@page import="com.lymava.base.vo.State"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
     <script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
		</script>
   <div  class="pageContent" id="${currentTimeMillis }"  >
   <form method="post" action="${basePath }${baseRequestPath }save.do"class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone);">
		<div class="pageFormContent" layoutH="56"> 
			<fieldset  >
					<dl>
						<dt>领取时间：</dt>
						<dd>
							<input readonly="readonly" type="text" name="object.inLingquTime" value="<c:out value="${object.showLingquTime}" escapeXml="true"/>"  class="date required" dateFmt="yyyy-MM-dd HH:mm:ss">
							<input type="text" hidden="hidden" name="object.id"  value="<c:out value="${object.id}" escapeXml="true"/>">
						</dd>
					</dl>
					<div class="divider"></div>
					<dl>
						<dt>打卡状态：</dt>
						<dd>
							<select name="object.state">
								<option value="300" <c:if test="${object.state == 300}">selected="selected"</c:if>>异常</option>
								<option value="200" <c:if test="${object.state == 200}">selected="selected"</c:if>>正常</option>
							</select>
						</dd>
					</dl>
			</fieldset>
		</div>
		<div class="formBar">
			<ul>
				<%--<li><div class="buttonActive"><div class="buttonContent"><button type="submit">保存</button></div></div></li>--%>
				<li>
					<div class="button"><div class="buttonContent"><button type="button" class="close">关闭</button></div></div>
				</li>
			</ul>
		</div>
	</form>
</div>