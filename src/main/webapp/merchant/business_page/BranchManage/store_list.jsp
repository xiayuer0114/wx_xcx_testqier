<%@ page import="com.lymava.qier.model.Merchant72" %>
<%@ page import="com.lymava.base.model.User" %>
<%@ page import="com.lymava.userfront.util.FrontUtil" %>
<%@ page import="com.lymava.commons.exception.CheckException" %>
<%@ page import="com.lymava.commons.state.StatusCode" %>
<%@ page import="com.lymava.nosql.util.PageSplit" %>
<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lymava.trade.util.WebConfigContentTrade" %>
<%@ page import="com.lymava.commons.util.MyUtil" %><%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018\6\4 0004
  Time: 11:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    User init_http_user = FrontUtil.init_http_user(request);
    CheckException.checkIsTure(init_http_user != null, "请先登录!", StatusCode.USER_INFO_TIMEOUT);

    // 检查登录
    Merchant72 merchant72 = (Merchant72) init_http_user;

    //一页的数量
    String page_temp = request.getParameter("page");
    String pageSize_temp = request.getParameter("pageSize");

    //商家名称
    String selNickname_str = request.getParameter("selNickname");

    PageSplit pageSplit = new PageSplit(page_temp,pageSize_temp);
    pageSplit.setPageSize(10); 

    Merchant72 merchant72_find = new Merchant72();
    merchant72_find.setTopUserId(merchant72.getId());
    merchant72_find.setUserGroupId(WebConfigContentTrade.getInstance().getMerchantUserGroupId());
    if (!MyUtil.isEmpty(selNickname_str))
    {
        merchant72_find.setNickname(selNickname_str);
        request.setAttribute("selNickname", selNickname_str);
    }

    List<Merchant72> object_ite = ContextUtil.getSerializContext().findAll(merchant72_find, pageSplit);

    request.setAttribute("object_ite", object_ite);
    request.setAttribute("pageSplit", pageSplit);
%>
<div >
<table class="table table-striped table-hover table-bordered" data-search="true">
    <thead>
    <tr>
        <th><input type="checkbox" id="merchantId_checkbox_select_all"></th>
        <th align="center">编号</th>
        <th >用户名</th>
        <th >商家名称</th>
        <th >余额</th>
        <th >联系人</th>
        <th >联系电话</th>
    </tr>
    </thead>
    <tbody>
    <!--数据循环-->
    <c:forEach var="merchant72" items="${object_ite}">
        <tr>
            <th><input class="merchantId_checkbox" type="checkbox" name="merchantId" value="${merchant72.id}"></th>
            <td>${merchant72.bianhao}</td>
            <td>${merchant72.username }</td>
            <td>${merchant72.nickname }</td>
            <td>${merchant72.merchant_balance_fen/100 }</td>
            <td>${merchant72.realname }</td>
            <td>${merchant72.phone }</td>
        </tr>
    </c:forEach>
    </tbody>
</table>
<ul class="pager_store" >
    <li  page="1"><a href="javascript:void(0)" > 首页</a></li>
    <li  page="${pageSplit.prePage }"><a href="javascript:void(0)"  >上一页</a></li>
    <c:forEach var="current_page" begin="${pageSplit.fenyeFirstPage }" end="${pageSplit.fenyeLastPage }" >
        <li   page="${current_page}"><a <c:if test="${current_page == pageSplit.page }">style="background-color: #eee;"</c:if>  href="javascript:void(0)"     >${current_page}</a></li>
    </c:forEach>
    <li  page="${pageSplit.nextPage }"><a href="javascript:void(0)"   >下一页</a></li>
</ul>
</div>

