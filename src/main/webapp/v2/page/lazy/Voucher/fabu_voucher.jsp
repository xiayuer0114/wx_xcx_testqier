<%@page import="com.lymava.trade.business.model.Address"%>
<%@page import="com.lymava.base.vo.State"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    jQuery(function(){
        resetDialog();
    });
</script>

<%


%>


<div  class="pageContent" id="${currentTimeMillis }"  >
    <form method="post" action="${basePath }${baseRequestPath }save.do"class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone);">
        <div class="pageFormContent" layoutH="56">
            <fieldset  >
                <dl >
                    <dt>商家：</dt>
                    <dd class="lookup_dd">
                        <input type="text"    value="<c:out value="${object.showInNickName}" escapeXml="true"/>"  readonly >
                        <input type="hidden" name="object.id"  value="<c:out value="${object.id }" escapeXml="true"/>">
                    </dd>
                </dl>
                <div class="divider"></div>
                <dl>
                    <dt>代金券名称：</dt>
                    <dd>
                        <input type="text"  name="object.voucherName"  value="<c:out value="${object.voucherName }" escapeXml="true"/>"   class="required"   >
                    </dd>
                </dl>

                <div class="divider"></div>

                </dl>
            </fieldset>
        </div>
        <div class="formBar">
            <ul>
                <c:if test="${object.state == 4}">
                    <input type="hidden" name="object.state"  value="<c:out value="1" escapeXml="true"/>">
                    <li><div class="buttonActive"><div class="buttonContent"><button type="submit">发布</button></div></div></li>
                </c:if>
                <c:if test="${object.state == 1}">
                    <input type="hidden" name="object.state"  value="<c:out value="2" escapeXml="true"/>">
                    <li><div class="buttonActive"><div class="buttonContent"><button type="submit" class="danger">结束</button></div></div></li>
                </c:if>

                <li><div class="buttonActive"><div class="buttonContent"><button type="submit">保存</button></div></div></li>
                <li>
                    <div class="button"><div class="buttonContent"><button type="button" class="close">关闭</button></div></div>
                </li>
            </ul>
        </div>
    </form>
</div>