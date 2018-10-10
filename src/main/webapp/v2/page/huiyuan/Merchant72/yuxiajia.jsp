<%@page import="com.lymava.qier.model.SettlementBank"%>
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
    <form method="post" action="${basePath }v2/merchant72user/yuxiajiaConfirm.do" class="pageForm required-validate" onsubmit="return validateCallback(this, navTabAjaxDone);">
        <input hidden="hidden" type="text" name="merchantId" value="<c:out value="${merchantId}" escapeXml="true" />" readonly="readonly" >
        <div class="pageFormContent" layoutH="56">
            <fieldset  >
                <dl>
                    <dt>商家名称</dt>
                    <dd  >
                        <input type="text" value="<c:out value="${nickname }" escapeXml="true" />" readonly="readonly" >
                    </dd>
                </dl>
                <div class="divider"></div>
                <dl>
                    <dt>未领取定向红包数量</dt>
                    <dd  >
                        <input type="text" value="<c:out value="${STATE_WAITE_CHANGE_Size }" escapeXml="true" />" readonly="readonly" >
                    </dd>
                </dl>
                <div class="divider"></div>
                <dl>
                    <dt>已领取定向红包数量</dt>
                    <dd  >
                        <input type="text" value="<c:out value="${STATE_OK_Size }" escapeXml="true" />" readonly="readonly" >
                    </dd>
                </dl>
                <div class="divider"></div>
                <dl>
                    <dt>已使用定向红包数量</dt>
                    <dd  >
                        <input type="text" value="<c:out value="${STATE_FALSE_Size }" escapeXml="true" />" readonly="readonly" >
                    </dd>
                </dl>
                <div class="divider"></div>
                <dl>
                    <dt>已过期定向红包数量</dt>
                    <dd  >
                        <input type="text" value="<c:out value="${STATE_CLOSED_Size }" escapeXml="true" />" readonly="readonly" >
                    </dd>
                </dl>
                <div class="divider"></div>
                <dl>
                    <dt>未激活定向红包数量</dt>
                    <dd  >
                        <input type="text" value="<c:out value="${STATE_WAITE_WAITSENDGOODS_Size }" escapeXml="true" />" readonly="readonly" >
                    </dd>
                </dl>
            </fieldset>
        </div>
        <div class="formBar">
            <ul>
                <li><div class="buttonActive"><div class="buttonContent"><button type="submit">确定下架</button></div></div></li>
                <li>
                    <div class="button"><div class="buttonContent"><button type="button" class="close">取消</button></div></div>
                </li>
            </ul>
        </div>
    </form>
</div>
