<%@page import="com.lymava.qier.model.MerchantPub"%>
<%@page import="com.lymava.base.model.Pub"%>
<%@ page import="com.lymava.qier.model.Cashier" %>
<%@ page import="com.lymava.qier.action.CashierAction" %>
<%@ page import="com.lymava.qier.action.MerchantShowAction" %>
<%@ page import="com.lymava.qier.model.xiaoChengXuModel.CityPub" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="com.lymava.qier.model.xiaoChengXuModel.ConfigPub" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
	$.post("${basePath}applet/loadShangQuan.do");
	$.post("${basePath}applet/loadYongCan.do");
	$.post("${basePath}applet/loadXiaoFei.do");
	$.post("${basePath}applet/loadShangPing.do");
</script>

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

			<dl  >
				<dt>商家文章：</dt>
				<dd class="lookup_dd">
					<%--<input type="text"    bringBack="city.pubName"     name="pub.cityName"  value="${pub.cityName}"  class="required">--%>
					<input type="text"    bringBack="pubLink.pubName"   value="${pub.pub_link.name}" >
					<input type="hidden"  bringBack="pubLink.pubId"  name="pub.pub_link_id"    value="${pub.pub_link_id}"    >
					<a class="btnLook" href="${basePath }v2/pub/listPub.do?return_mod=lookup&pubConlumnId=<%=ConfigPub.getQuyu()%>" lookupGroup="pubLink" rel="pubLink">查找</a>
				</dd>
			</dl>

			<div class="divider"></div>


			<dl style="height: 230px">
				<dt style="width: 150px">展示图片</dt>
				<dd>
					<input class="mydisupload"   fileNumLimit="1" name="pub.headBg"  type="hidden"  value="<c:out value="${pub.headBg}" escapeXml="true" />" />
				</dd>
			</dl>

			<div class="divider"></div>


			<dl style="height: 230px">
				<dt style="width: 150px">推荐卡下面三张小图片</dt>
				<dd>
					<input class="mydisupload"   fileNumLimit="3" name="pub.inHeadPics"  type="hidden"  value="<c:out value="${pub.headPics}" escapeXml="true" />" />
				</dd>
			</dl>

			<span id="tag" value="${pub.tag_string}"></span>
		</fieldset>

