<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018\6\4 0004
  Time: 11:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div >
<table class="table table-striped table-hover table-bordered" data-search="true">
    <thead>
    <tr>
        <th >分店名称</th>
        <th align="center">商品名称</th>
        <th >总价</th>
        <th >付款时间</th>
        <th >付款方式</th>
        <th >付款状态</th>
    </tr>
    </thead>
    <tbody>
    <!--数据循环-->
    <c:forEach var="tradeRecord" items="${object_ite}">
        <tr>
            <td>${tradeRecord.user_merchant.nickname}</td>
            <td>${tradeRecord.product.name}</td>
            <td>${tradeRecord.showPrice_fen_all/100 }</td>
            <td>${tradeRecord.showPayTime }</td>
            <td>${tradeRecord.showPayInfo }</td>
            <td class="${tradeRecord.id }state">${tradeRecord.showState }</td>
        </tr>
    </c:forEach>
    </tbody>
</table>
<ul class="pager_store_list" >
    <li  page="1"><a href="javascript:void(0)" > 首页</a></li>
    <li  page="${pageSplit.prePage }"><a href="javascript:void(0)"  >上一页</a></li>
    <c:forEach var="current_page" begin="${pageSplit.fenyeFirstPage }" end="${pageSplit.fenyeLastPage }" >
        <li   page="${current_page}"><a <c:if test="${current_page == pageSplit.page }">style="background-color: #eee;"</c:if>  href="javascript:void(0)"     >${current_page}</a></li>
    </c:forEach>
    <li  page="${pageSplit.nextPage }"><a href="javascript:void(0)"   >下一页</a></li>
</ul>
</div> 