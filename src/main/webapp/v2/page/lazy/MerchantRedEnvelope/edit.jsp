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
						<dt>所属会员：</dt>
						<dd class="lookup_dd">
							<input type="text" bringBack="user_huiyuan.showName"     value="<c:out value="${object.user_huiyuan.showName }" escapeXml="true"/>"   > 
							<input type="hidden" bringBack="user_huiyuan.userId" name="object.userId_huiyuan" value="${object.userId_huiyuan }"    >
							<input type="hidden"  value="${object.user_huiyuan.username }"    >
							<a  class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%=CashierAction.getCommonUserGroutId() %>" lookupGroup="user_huiyuan"  rel="user_huiyuan_lookup">查找</a>
						</dd> 
					</dl>
					<dl >
						<dt>发放商家：</dt>
						<dd class="lookup_dd">
							<input type="text" bringBack="user_merchant.showName"     value="<c:out value="${object.user_merchant.showName }" escapeXml="true"/>"   > 
							<input type="hidden" bringBack="user_merchant.userId" name="object.userId_merchant" value="${object.userId_merchant }"    >
							<a  class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%=CashierAction.getMerchantUserGroutId() %>" lookupGroup="user_merchant"  rel="user_merchant_lookup">查找</a>
						</dd> 
					</dl> 
					<div class="divider"></div>
					<dl>
						<dt>红包总额：</dt>
						<dd>
							<input type="text"  name="object.inAmount"  value="<c:out value="${object.amountFen/100 }" escapeXml="true"/>"   class="required number"   >
						</dd>
					</dl>
					<dl>
						<dt>满减金额</dt>
						<dd>
							<input type="text"  name="object.inAmount_to_reach"  value="<c:out value="${object.amount_to_reach_fen/100 }" escapeXml="true"/>"   class="required number"   >
						</dd>
					</dl> 
					<div class="divider"></div> 
					<dl>
						<dt>红包剩余：</dt>
						<dd>
							<input type="text"  name="object.inBalance"  value="<c:out value="${object.balanceFen/100 }" escapeXml="true"/>"   class="required number"   >
						</dd>
					</dl>
					<div class="divider"></div> 
					<dl>
						<dt>有效时间：</dt>
						<dd>
							<input type="text" name="object.inExpiry_time"    value="${object.showExpiry_time }"   class="required date"   datefmt="yyyy-MM-dd HH:mm:ss">
						</dd>
					</dl>
					<dl>
						<dt>排序时间：</dt>
						<dd>
							<input type="text" name="object.inIndex_id"    value="${object.showIndex_id }"   class="required date"   datefmt="yyyy-MM-dd HH:mm:ss">
						</dd>
					</dl>
					<div class="divider"></div> 
					<dl>
						<dt>商家类型：</dt>
						<dd>
							<input type="text"  bringBack="merchant_type.pubName"  name="object.merchant_type"  value='<c:out value="${object.merchant_type }" escapeXml="true"/>'   class="required"  readonly="readonly" >
                    		<a mask='true'   class="btnLook" href="${basePath }v2/pub/listPub.do?return_mod=lookup&pubConlumnId=<%=MerchantShowAction.getShangPingLeixingId()%>" lookupGroup="merchant_type"  rel="merchant_type">查找类型</a>
						</dd>
					</dl>
					<div class="divider"></div> 
					<dl >
						<dt>状态：</dt>
						<dd> 
							<select class="combox" name="object.state" svalue="${object.state }">
										<option value="<%=State.STATE_WAITE_CHANGE %>">未领取</option>
										<option value="<%=State.STATE_OK %>">已领取</option>							
										<option value="<%=State.STATE_FALSE %>">已使用</option>
										<option value="<%=State.STATE_CLOSED %>">已过期</option>
										<option value="<%=State.STATE_WAITE_WAITSENDGOODS %>">未激活</option>
										<option value="<%=State.STATE_WAITE_CODWAITRECEIPTCONFIRM %>">已转移</option>
										<option value="<%=State.STATE_ORDER_NOT_EXIST %>">小黑屋</option>
							</select>
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