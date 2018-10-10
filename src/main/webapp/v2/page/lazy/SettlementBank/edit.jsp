<%@page import="com.lymava.trade.business.model.Address"%>
<%@page import="com.lymava.base.vo.State"%>
<%@ page import="com.lymava.qier.model.SettlementBank" %>
<%@ page import="com.lymava.qier.action.CashierAction" %>
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
					<dt>商家ID：</dt>
					<dd class="lookup_dd">
						${object.id }
					</dd>
				</dl>
				<div class="divider"></div>
					<dl >
						<dt>商家名：</dt>
						<dd class="lookup_dd">
							<c:if test="${empty object.merchant72}">
								<td>
									商户
								</td>
								<td class="lookup_td">
									<input type="text"  bringBack="user_merchant.userShowName" value="<c:out value="${object.merchant72.showName }" escapeXml="true"/>"   readonly="readonly" >
									<input type="hidden" name="object.merchant72_id" bringBack="user_merchant.userId" value="${object.merchant72_id }"    >
									<a class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%=CashierAction.getMerchantUserGroutId() %>" lookupGroup="user_merchant" rel="user_merchant_lookup">查找</a>
								</td>
							</c:if>
							<c:if test="${not empty object.merchant72}">
								<c:out value="${object.merchant72.nickname }" escapeXml="true"/>
							</c:if>
							<input type="hidden" name="object.id"  value="<c:out value="${object.id }" escapeXml="true"/>" />
						</dd>
					</dl>
					<div class="divider"></div>
					<dl>
						<dt>银行名称：</dt>
						<dd>
							${object.showBankName }
						</dd>
					</dl>
					<div class="divider"></div>
					<dl >
						<dt>开户行：</dt>
						<dd class="lookup_dd">
							<input type="text" name="object.depositary_bank"  value="<c:out value="${object.depositary_bank }" escapeXml="true"/>">
						</dd>
					</dl>
					<div class="divider"></div>
					<dl>
						<dt>开户行地址：</dt>
						<dd>
							<input type="text" name="object.bank_addr"  value="<c:out value="${object.bank_addr }" escapeXml="true"/>">
						</dd>
					</dl>
					<div class="divider"></div>
					<dl>
						<dt>帐号：</dt>
						<dd>
							<input type="text" name="object.account"  value="<c:out value="${object.account }" escapeXml="true"/>">
						</dd>
					</dl> 
					<div class="divider"></div>
					<dl>
						<dt>账户名称：</dt>
						<dd>
							<input type="text" name="object.name"  value="<c:out value="${object.name }" escapeXml="true"/>">
						</dd>
					</dl>
					<div class="divider"></div>
					<dl >
						<dt>状态：</dt>
						<dd> 
							<select class="combox" name="object.state" svalue="${object.state }">
										<option value="<%=State.STATE_OK %>">正常使用</option>
										<option value="<%=State.STATE_FALSE %>">暂停使用</option>
							</select>
						</dd>
					</dl>
					<div class="divider"></div>
					<dl>
						<dt>备注：</dt>
						<dd>
							<input type="text" name="object.memo"  value="<c:out value="${object.memo }" escapeXml="true"/>">
						</dd>
					</dl>
					<div class="divider"></div>
					<dl >
						<dt>银行卡类型</dt>
						<dd>
							<select class="combox" name="object.bank_type" svalue="${object.bank_type }">
								<option value="<%=SettlementBank.bank_type_gongshang %>">工商银行</option>
								<option value="<%=SettlementBank.bank_type_zhaoshang %>">招商银行</option>
								<option value="<%=SettlementBank.bank_type_nongye %>">农业银行</option>
								<option value="<%=SettlementBank.bank_type_jianshe %>">建设银行</option>
								<option value="<%=SettlementBank.bank_type_zhongguo %>">中国银行</option>
								<option value="<%=SettlementBank.bank_type_guangda %>">光大银行</option>
								<option value="<%=SettlementBank.bank_type_xingye %>">兴业银行</option>
								<option value="<%=SettlementBank.bank_type_minsheng %>">民生银行</option>
								<option value="<%=SettlementBank.bank_type_huaxia %>">华夏银行</option>
								<option value="<%=SettlementBank.bank_type_cq_nongshanghang %>">重庆农村商业银行</option>
								<option value="<%=SettlementBank.bank_type_guangfa %>">广发银行</option>
								<option value="<%=SettlementBank.bank_type_jiaotong %>">交通银行</option>
								<option value="<%=SettlementBank.bank_type_pingan %>">平安银行</option>
								<option value="<%=SettlementBank.bank_type_shanghaipudongfazhan %>">上海浦东发展银行</option>
								<option value="<%=SettlementBank.bank_type_chongqingyinhang %>">重庆银行</option>
								<option value="<%=SettlementBank.bank_type_hengfeng %>">恒丰银行</option>
								<option value="<%=SettlementBank.bank_type_ningbo %>">宁波银行</option>
								<option value="<%=SettlementBank.bank_type_haerbing %>">哈尔滨银行</option>
								<option value="<%=SettlementBank.bank_type_weizhi %>">未知</option>
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