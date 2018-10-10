<%@page import="com.lymava.qier.model.MerchantPub"%>
<%@page import="com.lymava.base.model.Pub"%>
<%@ page import="com.lymava.qier.model.Cashier" %>
<%@ page import="com.lymava.qier.action.CashierAction" %>
<%@ page import="com.lymava.qier.action.MerchantShowAction" %>
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
			<dl>
				<dt>商户类型：</dt>
				<dd class="lookup_dd">
					<input type="text"  bringBack="merchant72_type.pubName"  name="pub.merchant72_type"  value='<c:out value="${pub.merchant72_type }" escapeXml="true"/>'   class="required"  readonly="readonly" >
					<a mask='true' class="btnLook" href="${basePath }v2/pub/listPub.do?return_mod=lookup&pubConlumnId=<%=MerchantShowAction.getShangPingLeixingId()%>" lookupGroup="merchant72_type" rel="merchant72_type">查找类型</a>
				</dd>
			</dl>
			<%--<dl>--%>
				<%--<dt>二级名称：</dt>--%>
				<%--<dd>--%>
					<%--<input type="text" name="pub.englishname" value="<c:out value="${pub.englishname }" escapeXml="true" />"      > --%>
				<%--</dd>--%>
			<%--</dl>--%>
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
			<dl>
				<dt>新店 :</dt>
				<dd>
					<input type="text" style="width: 50px;" name="pub.inXindian" value="<c:out value="${pub.showXindian }" escapeXml="true"/>"  >个月
				</dd>
			</dl>
			<div class="divider"></div> 
			
			<dt>小程序连接</dt>
				<dd>
					<%--/pages/infor_detail/infor_detail?id=' + id + '&mark=' + mark,--%>
					<input type="text" style="width: 350px"  value="/pages/infor_detail/infor_detail?id='<c:out value="${pub.id }" escapeXml="true"/>'&mark='5adad5cbd6c4593d38aa3787' "  >
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
			<dl>
				<dt>人均消费 :</dt>
				<dd>
					<input type="text" style="width: 50px;" name="pub.inAvg" value="<c:out value="${pub.showAvg }" escapeXml="true"/>"  >元
				</dd>
			</dl>
			<div class="divider"></div>
			<dl  >
				<dt>预约：</dt>
				<dd>
					<select class="combox" name="pub.yuyue" svalue="${pub.yuyue }">
						<option value="<%=MerchantPub.yuyue_no%>">免预约</option>
						<option value="<%=MerchantPub.yuyue_yes %>">需要预约</option>
					</select>
				</dd>
			</dl>
			<dl>
				<dt>节假日可用:</dt>
				<dd>
					<select class="combox" name="pub.jiari" svalue="${pub.jiari }">
						<option value="<%=MerchantPub.jiari_yes%>">可用</option>
						<option value="<%=MerchantPub.jiari_no %>">不可用</option>
					</select>
				</dd>
			</dl>
			<div class="divider"></div>
			<dl  >
				<dt>人气得分：</dt>
				<dd>
					<input type="text"  name="pub.renqi" value="<c:out value="${pub.renqi }" escapeXml="true"/>"  >
				</dd>
			</dl>
			<dl>
				<dt>好评得分:</dt>
				<dd>
					<input type="text"  name="pub.haoping" value="<c:out value="${pub.haoping }" escapeXml="true"/>"  >
				</dd>
			</dl>
			<div class="divider"></div>
			<dl  >
				<dt>商家：</dt>
				<dd class="lookup_dd">
					<input type="text"   bringBack="user_merchant.showName" value="${pub.merchant72.showName}"  class="required">
					<input type="hidden"  bringBack="user_merchant.userId"  name="pub.merchant72_Id" value="${pub.merchant72_Id}"    >
					<a class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%= CashierAction.getMerchantUserGroutId()%>" lookupGroup="user_merchant" rel="user_merchant_lookup">查找</a>
				</dd>
			</dl>
			<div class="divider"></div>
			<dl>
				<dt>商圈：</dt>
				<dd>

					<select class="combox" name="pub.shangQuanId" svalue="${pub.shangQuanId }">
						<c:forEach var="shangQuanPub" items="${shangQuanPubs }">
							<option value="${shangQuanPub.id}">${shangQuanPub.name}</option>
						</c:forEach>
					</select>
				</dd>
			</dl>
			<dl>
				<dt>商品类型：</dt>
				<dd>

					<select class="combox" name="pub.shangPinType" svalue="${pub.shangPinType }">
						<c:forEach var="shangQuanPub" items="${shangPingPubs }">
							<option value="${shangQuanPub.name}">${shangQuanPub.name}</option>
						</c:forEach>
					</select>
				</dd>
			</dl>
			<div class="divider"></div>
			<dl  >
				<dt>用餐时段：</dt>
				<dd>
					<c:forEach var="yongCanPubs" items="${yongCanPubs }">
						<lable><input class="inTagString" type="checkbox" name="pub.inTagString" value="${yongCanPubs.name}">${yongCanPubs.name}</lable>
						<br>
					</c:forEach>
				</dd>
			</dl>
			<dl  >
				<dt>消费类型：</dt>
				<dd>
					<c:forEach var="xiaoFeiPubs" items="${xiaoFeiPubs }">
						<%--<lable><input class="inTagString" type="checkbox" name="pub.inTagString" value="${yongCanPubs.name}">${yongCanPubs.name}</lable>--%>
						<lable><input class="inTagString" type="checkbox" name="pub.inTagString" value="${xiaoFeiPubs.name}" >${xiaoFeiPubs.name}</lable>
						<br>
					</c:forEach>
				</dd>
			</dl>

			<span id="tag" value="${pub.tag_string}"></span>
		</fieldset>


<script type="text/javascript">
	$(function () {
        var tag_str = $("#tag").attr("value");
        var tag_array =  tag_str.split("_");

        var tag_checkbok = document.getElementsByName("pub.inTagString");

        for(var i=0; i<tag_checkbok.length; i++){
            for (var j=0;j<tag_array.length; j++){
                if(tag_checkbok[i].value == tag_array[j] ){
                    tag_checkbok[i].checked = true;
				};
			}
		}
    });
</script>
