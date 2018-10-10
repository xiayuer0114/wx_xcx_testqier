<%@page import="com.lymava.base.model.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<form id="pagerForm" method="post" action="${basePath }v2/huiyuan/listintegralLog.do">
		<input type="hidden" name="page" value="${pageSplit.page }" />
		<input type="hidden" name="pageSize" value="${pageSplit.pageSize }" />
		<input type="hidden" name="integralLog.userId" value="${user.id }" />
</form>
<div class="pageHeader">
	<form onsubmit="return navTabSearch(this);" action="${basePath }v2/huiyuan/listIntegralLog.do" method="post">
	<div class="searchBar">
		<table class="searchContent">
			<tr>
				<td style="width: 50px;">
					订单编号
				</td>
				<td>
					<input type="text" name="orderId" value="${orderId }"  />
				</td> 
				<td style="width: 50px;">
					用户
				</td>
				<td class="lookup_td">
								<input type="text"  name="integralLog.userShowName"  value="<c:out value="${user.showName }" escapeXml="true"/>"   style="float: left;"> 
								<input type="hidden" name="integralLog.userId" value="${user.id }"    >
					 			<a   class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup" lookupGroup="integralLog"  rel="integralLog">查找</a>
				</td>
			</tr>
			<tr>
			<td style="width: 50px;">
					起始日期
				</td>
				<td>
					<input type="text" readonly="readonly" class="required date textInput readonly valid" value="${startTime }" name="startTime">
				</td> 
				<td style="width: 50px;">
					结束日期
				</td>
				<td>
					<input type="text" readonly="readonly" class="required date textInput readonly valid" value="${endTime }" name="endTime">
				</td> 
				<td  >
					<div class="buttonActive"><div class="buttonContent"><button type="submit">检索</button></div></div>
				</td>
			</tr>
		</table>
	</div>
	</form> 
</div>
<div class="pageContent">
	<div class="panelBar">
		<ul class="toolBar">
			<li><a class="delete" link="${basePath  }v2/huiyuan/deleteIntegralLog.do" sucess="navTabSearch(this)""  rel="${currentTimeMillis }"  rootPubConlumnId="${currentTimeMillis }"  href="javascript:void(0)"  ><span>删除</span></a></li>
		</ul>
	</div>
	<table class="table" width="100%" layoutH="138">
		<thead>
			<tr>
														<th width="30"><input type="checkbox" class="checkboxCtrl" group="${currentTimeMillis }checkbox" /></th>
														<th>系统编号</th>
									    				<th>用户</th>
									    				<th>操作人员</th>
									    				<th>交易类型</th>
									    				<th>变动积分</th>
									    				<th>积分余额</th>
									    				<th>时间</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="integralLog" varStatus="i" items="${integralLog_list }">
				<tr target="id" rel="${integralLog.id }" id="${integralLog.id }delete">
					<td><input type="checkbox" name="${currentTimeMillis }checkbox" value="${integralLog.id }" /></td>
					<td><c:out value="${integralLog.orderId }" escapeXml="true"/></td>
					<td><c:out value="${integralLog.user.nickname }" escapeXml="true"/>/<c:out value="${integralLog.user.username }" escapeXml="true"/></td>
					<td><c:out value="${integralLog.userv2.userName }" escapeXml="true"/></td>
					<td><c:out value="${integralLog.yewu }" escapeXml="true"/></td>
					<td><c:out value="${integralLog.count/1000000 }" escapeXml="true"/></td>
					<td><c:out value="${integralLog.balance/1000000 }" escapeXml="true"/></td>
					<td><c:out value="${integralLog.showTime }" escapeXml="true"/></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>