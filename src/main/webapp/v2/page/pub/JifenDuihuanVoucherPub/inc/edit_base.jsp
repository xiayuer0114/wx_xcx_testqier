<%@page import="com.lymava.base.model.Pub"%>
<%@ page import="com.lymava.qier.model.Cashier" %>
<%@ page import="com.lymava.qier.action.CashierAction" %>
<%@ page import="com.lymava.qier.model.JifenDuihuanPub" %>
<%@ page import="com.lymava.qier.action.MerchantShowAction" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<fieldset >
			<dl>
				<dt>名称：</dt>
				<dd>
					<input type="text"  name="pub.name"  value="<c:out value="${pub.name }" escapeXml="true" />"     class="required" >
					<input type="hidden" name="pubclass" value="<c:out value="${pubConlumn.finalPubclass }" escapeXml="true" />"   >
					<input type="hidden" name="pub.id" value="<c:out value="${pub.id }" escapeXml="true" />"   >
				</dd>
			</dl>
			<c:if test="${!empty pubConlumn.id ||  !empty pub.pubConlumnId }">
			<input type="hidden" name="pub.pubConlumnId" value="<c:if test="${empty pub }">${pubConlumn.id}</c:if><c:if test="${!empty pub }">${pub.pubConlumnId }</c:if>"   >
			</c:if>
			<div class="divider"></div>
			<script type="text/javascript">
				jQuery(function(){
					uploadInitMy();
				});
			</script>
			<div class="divider"></div>
			<dl>
				<dt>排序时间：</dt>
				<dd>
					<input type="text" name="pub.orderTime" value="${pub.orderTime }"   datefmt="yyyy-MM-dd HH:mm:ss" class="date textInput readonly">
				</dd>
			</dl>
			<div class="divider"></div>
			<dl  >
				<dt>状态：</dt>
				<dd>
					<select class="combox" name="pub.state" svalue="${pub.state }">
						<option value="<%=Pub.state_nomal %>">正常</option>
						<option value="<%=Pub.state_false %>">异常</option>
						<option value="<%=Pub.state_huishouzhan %>">回收站</option>
					</select>
				</dd>
			</dl>
			<div class="divider"></div>
			<dl  >
				<dt>积分：</dt>
				<dd >
					<input type="text" name="pub.jifen" value="${pub.jifen}"  class="required">
				</dd>
			</dl>
			<div class="divider"></div>
			<dl  >
				<dt>代金券：</dt>
				<dd class="lookup_dd">
					<input type="text"   bringBack="voucher.voucherName" value="${pub.voucher.voucherName}"  class="required">

					<input type="hidden"  bringBack="voucher.id"  name="pub.voucherId" value="${pub.voucherId}"    >
					<a class="btnLook" href="${basePath }v2/voucherManage/list.do?return_mod=lookup&userGroup_id=<%= CashierAction.getMerchantUserGroutId()%>" lookupGroup="voucher" rel="user_merchant_lookup">查找</a>
					<%--<a class="btnLook" href="${basePath }v2/voucherManage/list.do" lookupGroup="voucher" rel="user_merchant_lookup">查找</a>--%>

				</dd>
			</dl>
			<dl  >
				<dt>商家：</dt>
				<dd class="lookup_dd">
					<input type="text"   bringBack="voucher.showMerchantName" value="${pub.voucher.user_merchant.nickname}"  class="required" readonly="readonly">
				</dd>
			</dl>
			<div class="divider"></div>



		</fieldset>
