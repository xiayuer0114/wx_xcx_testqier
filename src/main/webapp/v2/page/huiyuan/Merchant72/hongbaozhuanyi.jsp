<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    jQuery(function(){
        resetDialog();
    });
</script>

<div class="pageContent">
    <form method="post" action="${basePath }v2/merchant72user/hongbaozhuanyiConfirm.do" class="pageForm required-validate" onsubmit="return validateCallback(this, navTabAjaxDone);">
        <input hidden="hidden" type="text" name="merchantId" value="<c:out value="${merchantId}" escapeXml="true" />" readonly="readonly" >
        <input type="hidden" name="requestFlow" value="<%=System.currentTimeMillis() %>"   >
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
                    <dt>红包总数</dt>
                    <dd  >
                        <input name="hongbaozongshu" type="text" value="<c:out value="${hongbaozongshu }" escapeXml="true" />" readonly="readonly" >
                    </dd>
                </dl>
                <div class="divider"></div>
                <dl>
                    <dt>红包总金额</dt>
                    <dd  >
                        <input name="hongbaozongjine" type="text" value="<c:out value="${hongbaozongjine / offset }" escapeXml="true" />" readonly="readonly" >
                    </dd>
                </dl>
            </fieldset>
        </div>
        <div class="formBar">
            <ul>
                <li><div class="buttonActive"><div class="buttonContent"><button type="submit">确定转移</button></div></div></li>
                <li>
                    <div class="button"><div class="buttonContent"><button type="button" class="close">取消</button></div></div>
                </li>
            </ul>
        </div>
    </form>
</div>
