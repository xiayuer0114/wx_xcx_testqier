<%@page import="com.lymava.base.model.User"%>
<%@page import="com.lymava.base.safecontroler.model.UserV2"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
     <script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
					function reloadPub(msg){
						var res = json2obj(msg);  
						 if(res.statusCode == "200" ){
							 alertMsg.correct(res.message); 
							reloadPubM("${rootPubConlumnId}");
						 }else{
							 alertMsg.warn(res.message)
						 }
					}
		</script> 
   <div class="pageContent"  >
	<form method="post" action="${basePath  }v2/pub/savePub.do"class="pageForm required-validate" onsubmit="return validateCallback(this, reloadPub);">
	<div class="tabs" currentIndex="0" eventType="click">
		<div class="tabsHeader">
			<div class="tabsHeaderContent">
				<ul>
					<li><a href="javascript:;"><span>基础</span></a></li>
					<li><a href="javascript:;"><span>展示</span></a></li>
					<li><a href="javascript:;"><span>详细</span></a></li>
				</ul>
			</div>
		</div>
		<div class="tabsContent pageFormContent"  >
			<div>
				<%@ include file="inc/edit_base.jsp"%>
			</div> 
			<div>
				<%@ include file="inc/edit_pic.jsp" %>
		</div>
		<div>
				<%@ include file="inc/edit_detail.jsp" %>
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