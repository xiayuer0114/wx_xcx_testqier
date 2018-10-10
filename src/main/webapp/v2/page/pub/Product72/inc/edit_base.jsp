<%@page import="com.lymava.trade.business.model.Product"%>
<%@page import="com.lymava.base.util.WebConfigContent"%>
<%@page import="com.lymava.base.model.Pub"%>
<%@ page import="com.lymava.qier.model.Product72" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<fieldset>
			<dl>
				<dt>商品名称：</dt>
				<dd>
					<input type="text"  name="pub.name"  value="<c:out value="${pub.name }" escapeXml="true" />"     class="required" > 
					<input type="hidden" name="pubclass" value="<c:out value="${pubConlumn.finalPubclass }" escapeXml="true" />"   >
					<input type="hidden" name="pub.id" value="<c:out value="${pub.id }" escapeXml="true" />"   >
					<input type="hidden" name="pub.pubConlumnId" value="<c:if test="${empty pub }">${pubConlumn.id}</c:if><c:if test="${!empty pub }">${pub.pubConlumnId }</c:if>"   >
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>商品编号：</dt>
				<dd>
					<c:if test="${empty pub.bianhao }">
						<input type="text" name="pub.bianhao" value="<%=Product.getNew_product_bianhao() %>" readonly="readonly"> 
					</c:if>
					<c:if test="${!empty pub.bianhao }">
						<input type="text" name="pub.bianhao" value="<c:out value="${pub.bianhao }" escapeXml="true" />" > 
					</c:if>
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>商家：</dt>
				<dd class="lookup_dd">
							<input type="text" bringBack="user_merchant.showName"     value="<c:out value="${pub.user_merchant.showName }" escapeXml="true"/>"   > 
							<input type="hidden" bringBack="user_merchant.userId" name="pub.userId_merchant" value="${pub.userId_merchant }"    >
							<a  class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup" lookupGroup="user_merchant"  rel="user_merchant_lookup">查找</a>
				</dd>
			</dl> 
			<div class="divider"></div> 
			<dl>
				<dt>商品价格：</dt>
				<dd>
					<input type="text" name="pub.inPrice_yuan" value="<c:out value="${pub.price_fen/100 }" escapeXml="true" />"    class="textInput required"> 
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>库存数量：</dt>
				<dd>
					<input type="text" name="pub.inStock_yuan" value="<c:out value="${pub.stock/100 }" escapeXml="true" />"    class="textInput required"> 
				</dd>
			</dl>
			<div class="divider"></div>

			<dl>
				<dt>开启预设：</dt>
				<dd>
					<select name="pub.yushe_state"  class="required combox" svalue="${pub.yushe_state}">
						<option  value="<%=Product72.yushe_state_guanbi %>" >关闭</option>
						<option  value="<%=Product72.yushe_state_kaiqi %>" >开启</option>
					</select>
				</dd>
			</dl>

			<dl>
				<dt>预置的扫码牌金额：</dt>
				<dd>
					<input type="text" name="pub.inPreset_amount_fen" value="<c:out value="${pub.preset_amount_fen/100 }" escapeXml="true" />" >
				</dd>
			</dl>


			<div class="divider"></div>

			<dl>
				<dt>预置餐位费：</dt>
				<dd>
					<input type="text" name="pub.inCanWeiFei_fen" value="<c:out value="${pub.canWeiFei_fen/100 }" escapeXml="true" />" >
				</dd>
			</dl>

			<dl>
				<dt>用餐人数：</dt>
				<dd>
					<input type="text" name="pub.renshu" value="<c:out value="${pub.renshu }" escapeXml="true" />" >
				</dd>
			</dl>
			<div class="divider"></div>

			<dl>
				<dt>收取餐位费：</dt>
				<dd>
					<select name="pub.canweifei_state"  class="required combox" svalue="${pub.canweifei_state}">
						<option  value="<%=Product72.yushe_state_guanbi %>" >不收取</option>
						<option  value="<%=Product72.yushe_state_kaiqi %>" >收取</option>
					</select>
				</dd>
			</dl>



			<div class="divider"></div> 
			<dl>
				<dt>排序时间：</dt>
				<dd>
					<input type="text" name="pub.orderTime" value="${pub.orderTime }"   datefmt="yyyy-MM-dd HH:mm:ss" class="date textInput readonly"> 
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl class="nowrap">
				<dt>状态：</dt>
				<dd>
					正常<input type="radio" <c:if test="${pub.state == 1 || empty pub.state}">checked="checked"</c:if> name="pub.state" value="<%=Pub.state_nomal%>">&nbsp; &nbsp;
					异常<input type="radio"  <c:if test="${pub.state== 2 && !empty pub.state }">checked="checked"</c:if> name="pub.state" value="<%=Pub.state_false %>">&nbsp; &nbsp;
					回收站<input type="radio" <c:if test="${pub.state== 3 && !empty pub.state }">checked="checked"</c:if> name="pub.state" value="<%=Pub.state_huishouzhan%>">
				</dd>
			</dl> 
		</fieldset>