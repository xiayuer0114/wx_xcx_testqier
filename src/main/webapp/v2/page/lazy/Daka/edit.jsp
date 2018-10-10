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
	   <input type="hidden" name="object.id"  value="<c:out value="${object.id }" escapeXml="true"/>" />
		<div class="pageFormContent" layoutH="56"> 
			<fieldset>
				<dl>
					<dt>签到时间：</dt>
					<dd>
						<input type="text" name="object.inDakaTime" value="<c:out value="${object.showDakaTime }" escapeXml="true"/>" class="date" dateFmt="yyyy-MM-dd HH:mm:ss" readonly="readonly" >
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
					<dt>时间：</dt>
					<dd>
						<input type="text" name="object.inDakaStartTime" value="<c:out value="${object.showDakaStartTime }" escapeXml="true"/>" class="date" dateFmt="yyyy-MM-dd HH:mm:ss" readonly="readonly" >
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
					<dt>状态：</dt>
					<dd>
						<select name="object.state">
							<option value="300" <c:if test="${object.state == 300}">selected="selected"</c:if>>异常</option>
							<option value="200" <c:if test="${object.state == 200}">selected="selected"</c:if>>正常</option>
						</select>
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
					<dt>奖励：</dt>
					<dd>
						<input type="text" name="object.inJiangLi" value="<c:out value="${object.jiangLi / 100}" escapeXml="true"/>"  class="number" >
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
					<dt>连续打卡标记：</dt>
					<dd>
						<input type="text" name="object.lianxuMark" value="<c:out value="${object.lianxuMark}" escapeXml="true"/>"  class="number" >
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