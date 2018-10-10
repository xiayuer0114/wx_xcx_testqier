<%@page import="com.lymava.base.model.User"%>
<%@page import="com.lymava.base.safecontroler.model.UserV2"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
     <script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
		</script> 
   <div class="pageContent" id="${currentTimeMillis }"  >
	<form method="post" action="${basePath }v2/huiyuan/save.do"class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone);">
	<div class="tabs" currentIndex="0" eventType="click">
		<div class="tabsHeader">
			<div class="tabsHeaderContent">
				<ul>
					<li><a href="javascript:;"><span>系统资料</span></a></li>
					<li><a href="javascript:;"><span>基础资料</span></a></li>
					<li><a href="javascript:;"><span>通讯资料</span></a></li>
					<li><a href="javascript:;"><span>头像</span></a></li>
				</ul>
			</div>
		</div>
		<div class="tabsContent pageFormContent"   >
			<div>
				<%@ include file="inc/edit_base.jsp"%>
			</div> 
			<div>
				<%@ include file="inc/edit_detail.jsp" %>
			</div>
			<div>
				<%@ include file="inc/edit_tongxun.jsp" %>
			</div>
			<div>
				<%@ include file="inc/edit_pic.jsp" %>
			</div>
		<div class="tabsFooter">
			<div class="tabsFooterContent"></div>
		</div>
	</div>
		<div class="formBar">
			<ul>
				<li><div class="buttonActive"><div class="buttonContent"><button type="submit">保存</button></div></div></li>
				<li>
					<div class="button"><div class="buttonContent"><button type="button" class="close">取消</button></div></div>
				</li>
			</ul>
		</div>
		</div>
	</form>
</div>