<%@page import="com.lymava.qier.model.SettlementBank"%>
<%@page import="com.lymava.qier.cmbpay.model.CmbBankAccountPay"%>
<%@page import="com.lymava.base.action.UserAction"%>
<%@page import="java.util.UUID"%>
<%@page import="com.lymava.commons.util.Md5Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
CmbBankAccountPay cmbBankAccountPay = CmbBankAccountPay.getInstance();
request.setAttribute("cmbBankAccountPay", cmbBankAccountPay);
%>
         <script type="text/javascript">
					jQuery(function(){
						
						uploadInitMy();
						
						resetDialog();
						
						transter_price_yuan_change();
					});
					function transter_price_yuan_change(){
						var transter_price_yuan_value = parseFloat_m(getInputValue("transter_price_yuan"));
						var discount_ratio_value = parseFloat_m(getInputValue("discount_ratio"));
						
						if(!isNumber(discount_ratio_value)){
							 alertMsg.warn("营销比例未设置!");
							 return;
						}
						if(!isNumber(transter_price_yuan_value)){
							 return;
						}
						
						var discount_ratio_value_jia_1 = jia(discount_ratio_value,1);
						
						var transfer_yingxiao_all_value = sheng(transter_price_yuan_value,discount_ratio_value);
						var transfer_beifujin_all_value = sheng(transter_price_yuan_value,discount_ratio_value_jia_1);
						
						$('#transfer_yingxiao_all').html(transfer_yingxiao_all_value);
						$('#transfer_beifujin_all').html(transfer_beifujin_all_value);
						
					}
		</script> 
<div class="pageContent" id="${currentTimeMillis }"  >
	<form method="post" action="${basePath }v2/TransferToMerchantRecord/save_transferToMerchantRecord.do"class="pageForm required-validate" onsubmit="return validateCallback(this, navTabAjaxDone);">
		<input type="hidden" name="merchant72_id" value="${object.id }"   >
		<input type="hidden" name="id" value="${object.id }"   >
		<input type="hidden" name="requestFlow" value="<%=System.currentTimeMillis() %>"   >
		<input type="hidden" name="discount_ratio" value="${object.discount_ratio/1000000 }"   >
		<div class="pageFormContent" >
		 <fieldset >
		 	<dl>
				<dt>付款账户</dt>
				<dd> 
				${cmbBankAccountPay.ACCNBR }
				</dd>
			</dl>   
			<div class="divider"></div>
			<dl>
				<dt>商户名称：</dt>
				<dd> 
					<c:out value="${user.nickname }" escapeXml="true" /> 
				</dd>
			</dl>  
			<div class="divider"></div>
			<dl>
				<dt>日流水：</dt>
				<dd>
					<c:out value="${user.inOneDayLiuShui }" escapeXml="true"/>
				</dd>
			</dl>
			<dl>
				<dt style="font-size: 0.7rem;">营销比例</dt>
				<dd>
					<c:out value="${object.discount_ratio/10000 }" escapeXml="true"/>% 
				</dd>
			</dl>
			<div class="divider"></div>
			<dl>
				<dt>收款户名</dt>
				<dd> 
					<c:out value="${user.settlementBank.name }" escapeXml="true" /> 
				</dd>
			</dl>  
			<dl>
				<dt>收款账号</dt>
				<dd> 
					<c:out value="${user.settlementBank.account }" escapeXml="true" /> 
				</dd>
			</dl>  
			<div class="divider"></div>
			<dl>
				<dt>银行名称：</dt>
				<dd> 
					<c:out value="${user.settlementBank.showBank_type }" escapeXml="true" /> 
				</dd>
			</dl>  
			<dl >
				<dt>开户行</dt>
				<dd> 
					<c:out value="${user.settlementBank.depositary_bank }" escapeXml="true" /> 
				</dd>
			</dl>  
			<div class="divider"></div>
			<dl>
				<dt>转账金额：</dt>
				<dd> 
					 <input id="transter_price_yuan" onblur="transter_price_yuan_change(this)" type="text" name="transter_price_yuan" value="${user.inOneDayLiuShui*5 }" class="number required" >
				</dd>
			</dl>
			<div class="divider"></div>
			<dl>
				<dt>营销金额</dt>
				<dd id="transfer_yingxiao_all"> 
					  
				</dd>
			</dl>  
			<dl>
				<dt>预付款变动</dt>
				<dd id="transfer_beifujin_all"> 
					  
				</dd>
			</dl>  
			<div class="divider"></div>
			<dl class="nowrap" >
				<dt>打款凭证</dt>
				<dd>
					<input class="mydisupload required"   fileNumLimit="1" name="object.pinzheng"  type="hidden"  value="" />
				</dd>
			</dl>
			<div class="divider"></div>
			<dl>
				<dt>备注：</dt>
				<dd> 
					 <input type="text" name="transter_memo" value=""  >
				</dd>
			</dl>
		 </fieldset>
 		</div>
		<div class="formBar">
			<ul>
				<li><div class="buttonActive"><div class="buttonContent"><button type="submit">确认转账</button></div></div></li>
				<li>
					<div class="button"><div class="buttonContent"><button type="button" class="close">取消</button></div></div>
				</li>
			</ul>
		</div>
	</form>
</div>
    