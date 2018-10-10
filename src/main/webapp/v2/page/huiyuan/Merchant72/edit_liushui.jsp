<%@page import="com.lymava.qier.action.Merchant72UserAction"%>
<%@page import="com.lymava.qier.model.Merchant72"%>
<%@ page import="com.lymava.commons.state.State" %>
<%@ page import="com.lymava.qier.action.Merchant72UserAction" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    jQuery(function(){
        resetDialog();
    });
</script>

<div class="pageContent">


    <%-- 数据来源于 : Merchant72UserAction-->checkLiuShui.do --%>

    <form method="post" action="${basePath }v2/merchant72user/sendInform.do"class="pageForm required-validate" onsubmit="return validateCallback(this, navTabAjaxDone);">

        <input type="hidden" id="id" name="id" value="<c:out value="${user.id }" escapeXml="true" />">

        <div class="pageFormContent" >
            <fieldset  >
                <dl>
                    <dd style="width: 75%">
                        商家: <c:out value="${user.nickname }" escapeXml="true" />
                    <dd >
                </dl>
                <dl>
                    <dd style="width: 75%">
                        日流水:<c:out value="${oneDayLiuShui }" escapeXml="true" />元
                    <dd >
                </dl>
                <div class="divider"></div>
                <dl>
                    <dt style="width: 40%">日期</dt>
                    <dd  style="width: 40%">
                        日流水
                    </dd>
                </dl>
                <div class="divider"></div>
                <c:forEach var="liuShuiByTime" items="${liuShuiByTime }" varStatus="i" >
                    <dl>
                        <dt style="width: 40%"><c:out value="${liuShuiByTime.key}" escapeXml="true" /></dt>
                        <dd  style="width: 40%">
                            <c:out value="${liuShuiByTime.value}" escapeXml="true" />元
                        </dd>
                    </dl>

                    <c:if test="${i.count%2 == 0}">
                        <div class="divider"></div>
                    </c:if>
                </c:forEach>
            </fieldset>
        </div>
        <div class="formBar">
            <ul>
                <li><div class="buttonActive"><div class="buttonContent"><button type="submit">发送流水提示信息</button></div></div></li>
                <li>
                    <div class="button"><div class="buttonContent"><button type="button" class="close">取消</button></div></div>
                </li>
            </ul>
        </div>
    </form>

</div>
