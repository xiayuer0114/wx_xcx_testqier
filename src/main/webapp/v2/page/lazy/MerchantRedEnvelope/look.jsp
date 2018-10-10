<%@page import="com.lymava.qier.action.CashierAction"%>
<%@page import="com.lymava.qier.action.MerchantShowAction"%>
<%@page import="com.lymava.trade.business.model.Address"%>
<%@page import="com.lymava.base.vo.State"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
     <script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
		</script>
   <div  class="pageContent" id="${currentTimeMillis }"  >
   <form method="post" action=""class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone);">
		<div class="pageFormContent" layoutH="56"> 
			<fieldset  >
				<dl >
					<dt>系统编号：</dt>
					<dd style="font-size: 0.8em;">
						<c:out value="${merchantRedEnvelope.id }" escapeXml="true"/>
					</dd>
				</dl>
				<div class="divider"></div>
				<dl >
					<dt>所属会员：</dt>
					<dd style="font-size: 0.8em;">
						<c:out value="${merchantRedEnvelope.user_huiyuan.showName }" escapeXml="true"/>
					</dd>
				</dl>
				<div class="divider"></div>
				<dl >
					<dt>红包名称：</dt>
					<dd style="font-size: 0.8em;">
						<c:out value="${merchantRedEnvelope.red_envolope_name}" escapeXml="true"/>
					</dd>
				</dl>
				<div class="divider"></div>
				<dl >
					<dt>商户：</dt>
					<dd style="font-size: 0.8em;">
						<c:out value="${merchantRedEnvelope.user_merchant.showName}" escapeXml="true"/>
					</dd>
				</dl>
				<div class="divider"></div>
				<dl >
					<dt>红包总额：</dt>
					<dd style="font-size: 0.8em;">
						<c:out value="${merchantRedEnvelope.amount / 1000000}" escapeXml="true"/>
					</dd>
				</dl>
				<div class="divider"></div>
				<dl >
					<dt>红包余额：</dt>
					<dd style="font-size: 0.8em;">
						<c:out value="${merchantRedEnvelope.balance / 1000000}" escapeXml="true"/>
					</dd>
				</dl>
				<div class="divider"></div>
				<dl >
					<dt>红包状态：</dt>
					<dd style="font-size: 0.8em;">
						<c:out value="${merchantRedEnvelope.showState}" escapeXml="true"/>
					</dd>
				</dl>
				<div class="divider"></div>
				<dl >
					<dt>获得时间：</dt>
					<dd style="font-size: 0.8em;">
						<c:out value="${merchantRedEnvelope.showTime }" escapeXml="true"/>
					</dd>
				</dl>
				<div class="divider"></div>
				<dl >
					<dt>有效期：</dt>
					<dd style="font-size: 0.8em;">
						<c:out value="${merchantRedEnvelope.showExpiry_time}" escapeXml="true"/>
					</dd>
				</dl>
				<div class="divider"></div>
				<c:if test="${consumeTradeRecord72 != null}">
					<dl class="nowrap">
						<dt>消费订单号</dt>
						<dd>
							<c:out value="${consumeTradeRecord72.id }" escapeXml="true"/>
							<input type="hidden" name="object.id"  value="<c:out value="${object.id }" escapeXml="true"/>">
						</dd>
					</dl>
					<div class="divider"></div>
					<dl class="nowrap">
						<dt>商户流水：</dt>
						<dd>
							<c:out value="${consumeTradeRecord72.requestFlow }" escapeXml="true"/>
						</dd>
					</dl>
					<div class="divider"></div>
					<dl class="nowrap">
						<dt>支付流水：</dt>
						<dd>
							<c:out value="${consumeTradeRecord72.id}" escapeXml="true"/>
						</dd>
					</dl>
					<div class="divider"></div>
					<dl class="nowrap">
						<dt>创建时间：</dt>
						<dd>
							<c:out value="${consumeTradeRecord72.showTime }" escapeXml="true"/>
						</dd>
					</dl>
					<div class="divider"></div>
					<dl class="nowrap">
						<dt>状态</dt>
						<dd>
							${consumeTradeRecord72.merchantRedEnvelopePayRecord.showState}
						</dd>
					</dl>
					<div class="divider"></div>
					<dl class="nowrap">
						<dt style="font-size: 0.8rem;" >红包支付单号</dt>
						<dd>
								${consumeTradeRecord72.balancePayRecord.id }
						</dd>
					</dl>
				</c:if>
			</fieldset>
		</div>
		<div class="formBar">
			<ul>
				<%--<li><div class="buttonActive"><div class="buttonContent"><button type="submit">保存</button></div></div></li>--%>
				<li>
					<div class="button"><div class="buttonContent"><button type="button" class="close">关闭</button></div></div>
				</li>
			</ul>
		</div>
	</form>
</div>