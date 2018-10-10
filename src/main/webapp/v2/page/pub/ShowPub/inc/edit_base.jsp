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
					<input type="text"  name="pub.name"  value="<c:out value="${pub.name }" escapeXml="true" />"     class="required" > 
					<input type="hidden" name="pubclass" value="<c:out value="${pubConlumn.finalPubclass }" escapeXml="true" />"   >
					<input type="hidden" name="pub.id" value="<c:out value="${pub.id }" escapeXml="true" />"   >
				</dd>
			</dl>

			<dl>
				<dt>所在城市：</dt>
				<dd>
					<input type="text"  name="pub.suozaiCity"  value="<c:out value="${pub.suozaiCity }" escapeXml="true" />" >
				</dd>
			</dl>
			<%--<dl>--%>
				<%--<dt>商户类型：</dt>--%>
				<%--<dd class="lookup_dd">--%>
					<%--<input type="text"  bringBack="merchant72_type.pubName"  name="pub.merchant72_type"  value='<c:out value="${pub.merchant72_type }" escapeXml="true"/>'   class="required"  readonly="readonly" >--%>
					<%--<a mask='true' class="btnLook" href="${basePath }v2/pub/listPub.do?return_mod=lookup&pubConlumnId=<%=MerchantShowAction.getShangPingLeixingId()%>" lookupGroup="merchant72_type" rel="merchant72_type">查找类型</a>--%>
				<%--</dd>--%>
			<%--</dl>--%>
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
			<%--<dl>--%>
				<%--<dt>新店 :</dt>--%>
				<%--<dd>--%>
					<%--<input type="text" style="width: 50px;" name="pub.inXindian" value="<c:out value="${pub.showXindian }" escapeXml="true"/>"  >个月--%>
				<%--</dd>--%>
			<%--</dl>--%>
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
				<dt>商家：</dt>
				<dd class="lookup_dd">
					<input type="text"   bringBack="user_merchant.showName" value="${pub.merchant72.nickname}"  class="required">
					<input type="hidden"  bringBack="user_merchant.userId"  name="pub.inMerchant72_Id" value="${pub.merchant72_Id}"    >
					<a class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%= CashierAction.getMerchantUserGroutId()%>" lookupGroup="user_merchant" rel="user_merchant_lookup">查找</a>
				</dd>
			</dl>
			<div class="divider"></div>

			<dl>
				<dt>人均消费 :</dt>
				<dd>
					<input type="text" style="width: 50px;" name="pub.inAvg" value="<c:out value="${pub.showAvg }" escapeXml="true"/>"  >元
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

			<dl style="padding: 0;margin: 0;">
				<dt style="width: 200px;">使用规则描述:</dt>
			</dl>
			<dl class="nowrap intro_dl" >
				<dd  >
					<textarea name="pub.usageRule" class="textInput"><c:out value="${pub.usageRule }" escapeXml="true" /></textarea>
				</dd>
			</dl>

			<div class="divider"></div>

			<dl>
				<dt>商家类型 :</dt>
				<dd id="merchantType">
					<%--<label><input class="inTagString" type="checkbox" name="pub.inTagString" value="${xiaoFeiPubs.name}" >${xiaoFeiPubs.name}</label>--%>
						<input type='hidden' name='pub.inTagString' value=''>
				</dd>
			</dl>


			<dl>
				<dt>置顶 :</dt>
				<dd id="zhiDing">
					<input type='hidden' name='pub.inZhiDing' value=''>
				</dd>
			</dl>


			<span id="tag" value="${pub.tag_string}"></span>
			<span id="tag_zhiding" value="${pub.zhiDing}"></span>

			<script type="text/javascript">
                $(function () {
                    $.post("${basePath}appletV2/loadMerchantType.do",function (msg) {
						msg = JSON.parse(msg);

						if(msg.statusCode == 200){
                            var data = msg.data;

                            // 加载商家类型标签
                            for (var i = 0; i<data.length; i++){

                                $in = $("<label>" +
                                    " <input class='inTagString'  type='checkbox' name='pub.inTagString' " +
                                    "value='"+data[i].labelName+"'>"+data[i].labelName+"" +
                                    "</label>");

                                $in2 = $("<label>" +
                                    " <input class='inTagString'  type='checkbox' name='pub.inZhiDing' " +
                                    "value='"+data[i].labelName+"'>"+data[i].labelName+"" +
                                    "</label>");


                                $("#merchantType").append($in);
                                $("#zhiDing").append($in2);
							}

							// 勾选被选中的商家标签
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


                            // 勾选置顶项
                            var tag_str = $("#tag_zhiding").attr("value");
                            var tag_array =  tag_str.split("_");

                            var tag_checkbok = document.getElementsByName("pub.inZhiDing");

                            for(var i=0; i<tag_checkbok.length; i++){
                                for (var j=0;j<tag_array.length; j++){
                                    if(tag_checkbok[i].value == tag_array[j] ){
                                        tag_checkbok[i].checked = true;
                                    };
                                }
                            }

						}

                    });
                });
			</script>

		</fieldset>

