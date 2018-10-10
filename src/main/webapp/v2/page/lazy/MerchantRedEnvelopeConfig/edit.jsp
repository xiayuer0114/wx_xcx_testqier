<%@page import="com.lymava.qier.model.MerchantRedEnvelopeConfig"%>
<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.qier.action.CashierAction"%>
<%@page import="com.lymava.qier.action.MerchantShowAction"%>
<%@page import="com.lymava.trade.business.model.Address"%> 
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
     <script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
		</script>
   <div  class="pageContent" id="${currentTimeMillis }"  >
   <form method="post" action="${basePath }${baseRequestPath }save.do"class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone);">
		<div class="pageFormContent" layoutH="56"> 
			<fieldset  >
					<dl >
						<dt>系统编号：</dt>
						<dd style="font-size: 0.8em;">
							<c:out value="${object.id }" escapeXml="true"/>
							<input type="hidden" name="object.id"  value="<c:out value="${object.id }" escapeXml="true"/>" />
						</dd>
					</dl>
					<div class="divider"></div>
					<dl>
						<dt>红包名称：</dt>
						<dd>
							<input type="text"  name="object.red_envolope_name"  value="<c:out value="${object.red_envolope_name }" escapeXml="true"/>"   class="required"   >
						</dd>
					</dl>
					<div class="divider"></div> 
					<dl >
						<dt>商家：</dt>
						<dd class="lookup_dd">
							<input type="text" bringBack="user_merchant.showName"     value="<c:out value="${object.user_merchant.showName }" escapeXml="true"/>"   > 
							<input type="hidden" bringBack="user_merchant.userId" name="object.userId_merchant" value="${object.userId_merchant }"    class="required"  readonly="readonly">
							<a  class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%=CashierAction.getMerchantUserGroutId() %>" lookupGroup="user_merchant"  rel="user_merchant_lookup">查找</a>
						</dd> 
					</dl> 
					<div class="divider"></div> 
					<dl>
						<dt>商家类型：</dt>
						<dd>
							<input type="text"  bringBack="merchant_type.pubName"  name="object.merchant_type"  value='<c:out value="${object.merchant_type }" escapeXml="true"/>'   class="required"  readonly="readonly" >
                    		<a   class="btnLook" href="${basePath }v2/pub/listPub.do?return_mod=lookup&pubConlumnId=<%=MerchantShowAction.getShangPingLeixingId()%>" lookupGroup="merchant_type"  rel="merchant_type_edit">查找类型</a>
						</dd>
					</dl>
					<div class="divider"></div>
					<dl >
						<dt>金额类型</dt>
						<dd> 
							<select class="combox" name="object.amount_type" svalue="${object.amount_type }">
										<option value="<%=MerchantRedEnvelopeConfig.amount_type_guding %>">固定金额</option>							
										<option value="<%=MerchantRedEnvelopeConfig.amount_type_trade_bili %>">订单折扣</option>
							</select>
						</dd>
					</dl>
					<dl>
						<dt>红包金额</dt>
						<dd>
							<input type="text"  name="object.inAmount"  value="<c:out value="${object.amountFen/100 }" escapeXml="true"/>"   class="required number"   >
						</dd>
					</dl> 
					<div class="divider"></div>
					<dl>
						<dt>满减金额</dt>
						<dd>
							<input type="text"  name="object.inAmount_to_reach"  value="<c:out value="${object.amount_to_reach_fen/100 }" escapeXml="true"/>"   class="required number"   >
						</dd>
					</dl> 
					<div class="divider"></div> 
					<dl>
						<dt>有效期：</dt>
						<dd>
							<input style="width: 50px;" type="text" name="object.expiry_time"    value="${object.expiry_time }"   class="required digits"   datefmt="dd" >天
						</dd>
					</dl> 
					<div class="divider"></div> 
					<dl >
						<dt>状态：</dt>
						<dd> 
							<select class="combox" name="object.state" svalue="${object.state }">
										<option value="<%=State.STATE_OK %>">正常发放</option>							
										<option value="<%=State.STATE_FALSE %>">停止发放</option>
							</select>
						</dd>
					</dl>
					<div class="divider"></div>
					<dl >
						<dt>每天可用：</dt>
						<dd>
							<input style="width: 23px;" type="text" name="object.inDay_start"    value="${object.showDay_start }">

							<input style="width: 35px;" type="text" value="点-至-" readonly="readonly">

							<input style="width: 23px;" type="text" name="object.inDay_end"    value="${object.showDay_end }" >

							<input style="width: 23px;" type="text" value="点" readonly="readonly">
						</dd>
					</dl>


					<div class="divider"></div>
					<dl >
						<dt>每周可用：</dt>
						<dd>
							<input style="width: 23px;" type="text" value="星期" readonly="readonly">
							<input style="width: 19px;" type="text" name="object.week_start"    value="${object.week_start }">

							<input style="width: 52px;" type="text" value=" -至- 星期" readonly="readonly">

							<input style="width: 19px;" type="text" name="object.week_end"    value="${object.week_end }" >
						</dd>
					</dl>

			</fieldset>
		</div>
		<div class="formBar">
			<ul>
				<li><div class="buttonActive"><div class="buttonContent"><button type="submit">保存</button></div></div></li>
				<li>
					<div class="button"><div class="buttonContent"><button type="button" class="close">关闭</button></div></div>
				</li>
			</ul>
		</div>
	</form>
</div>