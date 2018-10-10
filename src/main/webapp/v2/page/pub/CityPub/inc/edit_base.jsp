<%@page import="com.lymava.qier.model.MerchantPub"%>
<%@page import="com.lymava.base.model.Pub"%>
<%@ page import="com.lymava.qier.model.Cashier" %>
<%@ page import="com.lymava.qier.action.CashierAction" %>
<%@ page import="com.lymava.qier.action.MerchantShowAction" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<fieldset >
			<dl>
				<dt>名称：</dt>
				<dd>
					<input type="text"  name="pub.cityName"  value="<c:out value="${pub.cityName }" escapeXml="true" />"     class="required" >
					<input type="hidden" name="pubclass" value="<c:out value="${pubConlumn.finalPubclass }" escapeXml="true" />"   >
					<input type="hidden" name="pub.id" value="<c:out value="${pub.id }" escapeXml="true" />"   >
				</dd>
			</dl>
			<c:if test="${!empty pubConlumn.id ||  !empty pub.pubConlumnId }">
			<input type="hidden" name="pub.pubConlumnId" value="<c:if test="${empty pub }">${pubConlumn.id}</c:if><c:if test="${!empty pub }">${pub.pubConlumnId }</c:if>"   >
			</c:if>
			<c:if test="${empty pubConlumn.id &&  empty pub.pubConlumnId }">
			<div class="divider"></div> 
				<dl>
					<dt>主分类：</dt>
					<dd> 
						<input type="text"  name="mainpubConlumn.pubConlumnName"  value=""   class="required"  style="width: 100px;" readonly="readonly" > 
						<input type="hidden" id="mainpubConlumnId" name="mainpubConlumn.pubConlumnId" value=""    >
						<a mask='true' style="position: absolute;margin-left: 160px;"  class="btnLook" href="${basePath }v2/pub/listPubConlumn.do?return_mod=lookup&rootPubConlumnId=${pubConlumn.rootPubConlumnId }${rootPubConlumn.id }" lookupGroup="mainpubConlumn"  rel="mainpubConlumnLookup">查找主分类</a>
					</dd>
				</dl>  
			<dl>
					<dt>细分类：</dt>
					<dd> 
						<input type="text"  name="pub.pubConlumnName"  value=""     style="width: 100px;"  readonly="readonly"> 
						<input type="hidden" name="pub.pubConlumnId" value=""   autocomplete="off"  warn="主分类" >
						<a mask='true' style="position: absolute;margin-left: 160px;" warn="请选择主分类"  class="btnLook" href="${basePath }v2/pub/listPubConlumn.do?return_mod=lookup&rootPubConlumnId={mainpubConlumnId}" lookupGroup="pub"  rel="pubuLookup">查找细分类</a>
					</dd>
			</dl> 
			</c:if>
			<div class="divider"></div>

			<script type="text/javascript">
				jQuery(function(){
					uploadInitMy();
				});
			</script>

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
				<dt>经度：</dt>
				<dd>
					<input type="text"  name="pub.longitude"  value="<c:out value="${pub.longitude }" escapeXml="true" />"     class="required" >
				</dd>
			</dl>
			<div class="divider"></div>

			<dl  >
				<dt>纬度：</dt>
				<dd>
					<input type="text"  name="pub.latitude"  value="<c:out value="${pub.latitude }" escapeXml="true" />"     class="required" >
				</dd>
			</dl>
			<div class="divider"></div>

			<dl>
				<dt>标题：</dt>
				<dd>
					<input type="text"  name="pub.title"  value="<c:out value="${pub.title }" escapeXml="true" />" >
				</dd>
			</dl>
			<div class="divider"></div>

			<dl>
				<dt>副标题：</dt>
				<dd>
					<input type="text"  name="pub.subtitle"  value="<c:out value="${pub.subtitle }" escapeXml="true" />" >
				</dd>
			</dl>
			<div class="divider"></div>

			<dl>
				<dt>红包使用 :</dt>
				<dd>
					<input type="text" style="width: 50px;" name="pub.useRenshu" value="<c:out value="${pub.useRenshu }" escapeXml="true"/>"  >人使用了红包
				</dd>
			</dl>
			<div class="divider"></div>

			<dl style="height: 230px">
				<dt style="width: 150px">地区图片</dt>
				<dd>
					<input class="mydisupload"   fileNumLimit="1" name="pub.pic"  type="hidden"  value="<c:out value="${pub.pic}" escapeXml="true" />" />
				</dd>
			</dl>

		</fieldset>
