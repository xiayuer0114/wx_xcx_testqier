<%@page import="com.lymava.base.model.User"%>
<%@page import="com.lymava.base.safecontroler.model.UserV2"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
     <script type="text/javascript">
					jQuery(function(){
						uploadInitMy();
						resetDialog();
					}); 
					function submitWebconfigForm(formthis){
						return validateCallback(formthis, navTabAjaxDone);
					}
		</script> 
   <div class="pageContent"   >
	<form method="post" action="${basePath }v2/webconfig/save.do"class="pageForm required-validate" onsubmit="return submitWebconfigForm(this);">
	<div class="tabs"  >
		<div class="tabsHeader">
			<div class="tabsHeaderContent">
				<ul>
					<li><a href="javascript:;"><span>关注立返</span></a></li>
					<li><a href="javascript:;"><span>刮刮卡</span></a></li>
					<li><a href="javascript:;"><span>猜地点</span></a></li>
					<li><a href="javascript:;"><span>清凉计划</span></a></li>
					<li><a href="javascript:;"><span>圣慕缇集卡</span></a></li>
				</ul>
			</div>
		</div>
		<div class="tabsContent pageFormContent"  >
			<div>
				<%@ include file="activities/guanzhulijian.jsp" %>
			</div> 
			<div>
				<%@ include file="activities/guaguaka.jsp" %>
			</div>
			<div>
				<%@ include file="activities/caididian.jsp" %>
			</div>
			<div>
				<%@ include file="activities/qingliang.jsp" %>
			</div>
			<div>
				<%@ include file="activities/jika1.jsp" %>
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