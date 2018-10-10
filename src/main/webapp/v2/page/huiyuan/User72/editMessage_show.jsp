<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<form id="pagerForm" method="post" action="${basePath }v2/huiyuan/listMessage.do">
	<input type="hidden" name="page" value="1" />
	<input type="hidden" name="pageSize" value="20" />
</form>
<div class="pageHeader">
	<form onsubmit="return navTabSearch(this);" action="${basePath }v2/huiyuan/listMessage.do" method="post">
	<div class="searchBar">
		<table class="searchContent">
			<tr>
				<td>
					标题：<input type="text" name="name" value="<c:out value="${name }" escapeXml="true"/>"  size="15"  />
				</td> 
			</tr>
		</table>
		<div class="subBar">
			<ul>
				<li><div class="buttonActive"><div class="buttonContent"><button type="submit">检索</button></div></div></li>
			</ul>
		</div>
	</div>
	</form> 
</div>
<div class="pageContent">
	<div class="panelBar">
		<ul class="toolBar">
			<li class="line">line</li>
			<li><a class="edit" href="${basePath  }v2/huiyuan/edit.do?id={id}" target="navTab" title="会员资料编辑"><span>资料编辑</span></a></li>
			<li class="line">line</li>
			<li><a class="delete" href="${basePath  }v2/huiyuan/editMessage.do?id={id}"  target="dialog"   ><span>查看内容</span></a></li>
			<li class="line">line</li>
			<li><a  class="delete" href="${basePath  }v2/huiyuan/deleteMessage.do?id={id}" target="ajaxTodo" title="确定要删除吗?"><span>查看内容</span></a></li>
		</ul>
	</div>
	<table class="table" width="100%" layoutH="138">
		<thead>
			<tr>
									    				<th>姓名</th>
									    				<th>联系电话</th>
									    				<th>内容</th>
									    				<th>状态</th>
									    				<th>时间</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="user" varStatus="i" items="${user_list }">
				<tr target="id" rel="${user.id }">
					<td><c:out value="${user.username }" escapeXml="true"/></td>
					<td><c:out value="${user.nickname }" escapeXml="true"/></td>
					<td><c:out value="${user.sex }" escapeXml="true"/></td>
					<td><c:out value="${user.phone }" escapeXml="true"/></td>
					<td><c:out value="${user.email }" escapeXml="true"/></td>
					<td><c:out value="${user.showBirthDate }" escapeXml="true"/></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>