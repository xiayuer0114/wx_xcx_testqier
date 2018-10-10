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
   <form method="post" action="#"class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone);">
		<div class="pageFormContent" layoutH="56"> 
			<fieldset  >
				<dl >
					<dt>系统编号：</dt>
					<dd style="font-size: 0.8em;">
						<c:out value="${object.id }" escapeXml="true"/>
					</dd>
				</dl>
				<div class="divider"></div>
				<dl >
					<dt>业务名称：</dt>
					<dd style="font-size: 0.8em;">
						<c:out value="${object.business.businessName }" escapeXml="true"/>
					</dd>
				</dl>
				<div class="divider"></div>
				<dl >
					<dt>管理员名称：</dt>
					<dd style="font-size: 0.8em;">
						<c:out value="${object.userV2.userName }" escapeXml="true"/>
					</dd>
				</dl>
				<div class="divider"></div>
				<dl >
					<dt>用户登录名：</dt>
					<dd style="font-size: 0.8em;">
						<c:out value="${object.user_huiyuan.username }" escapeXml="true"/>
					</dd>
				</dl>
				<div class="divider"></div>
				<dl >
					<dt>用户名称：</dt>
					<dd style="font-size: 0.8em;">
						<c:out value="${object.user_huiyuan.nickname }" escapeXml="true"/>
					</dd>
				</dl>
				<div class="divider"></div>
				<dl >
					<dt>登录ip记录：</dt>
					<dd style="font-size: 0.8em;">
						<c:out value="${object.ip }" escapeXml="true"/>
					</dd>
				</dl>
				<div class="divider"></div>
				<dl >
					<dt>状态：</dt>
					<dd style="font-size: 0.8em;">
						<c:out value="${object.showState }" escapeXml="true"/>
					</dd>
				</dl>
				<div class="divider"></div>
				<dl >
					<dt>操作时间：</dt>
					<dd style="font-size: 0.8em;">
						<c:out value="${object.showTime }" escapeXml="true"/>
					</dd>
				</dl>
				<div class="divider"></div>
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