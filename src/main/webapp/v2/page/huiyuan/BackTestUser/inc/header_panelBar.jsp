<%@page import="com.lymava.base.model.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="auth" uri="http://tiesh.liebianzhe.com/tag/auth" %>
<div class="panelBar">
		<ul class="toolBar">
			
			<auth:if test="v2/huiyuan/delete.do">
				<li><a class="delete" rootPubConlumnId="${currentTimeMillis }" link="${basePath  }v2/huiyuan/delete.do"   title="确定要删除吗?"><span>删除</span></a></li>
				<li class="line">line</li>
			</auth:if>
			
			
			
			<auth:if test="v2/huiyuan/add.do">
				<li><a class="add" href="${basePath }v2/huiyuan/edit.do?return_mod=batchAdd&userGroup.id=${userGroup.id }" target="dialog"   title="批量增加"><span>批量增加</span></a></li>
				<li class="line">line</li>
			</auth:if>
				
			
			
		</ul>
	</div>