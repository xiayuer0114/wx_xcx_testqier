<%@page import="com.lymava.base.vo.State"%>
<%@ page import="com.lymava.qier.action.CashierAction" %>
<%@ page import="com.lymava.qier.model.SettlementBank" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<form id="pagerForm" method="post" action="${basePath }${baseRequestPath }list.do">
		<input type="hidden" name="page" value="${pageSplit.page }" />
		<input type="hidden" name="pageSize" value="${pageSplit.pageSize }" />
</form>
<div class="pageHeader">
	<form name="${currentTimeMillis }searchform" id="${currentTimeMillis }searchform"  onsubmit="return navTabSearch(this);" action="${basePath }${baseRequestPath }list.do" method="post">
	<div class="searchBar">
		<table class="searchContent">
			<tr>
				<td>
					银行名称
				</td>
				<td>
					<select class="combox" name="bank_type" svalue="${object.bank_type }">
						<option value="">（不限）</option>
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
				</td>
				<td>
					备注
				</td>
				<td>
					<input name="memo" value="${object.memo }"  type="text">
				</td>
			</tr>
			<tr>
				<td  >
					商户
				</td>
				<td class="lookup_td">
					<input type="text"  bringBack="user_merchant.userShowName" value="<c:out value="${object.merchant72.showName }" escapeXml="true"/>"   readonly="readonly" >
					<input type="hidden" name="merchant72_id" bringBack="user_merchant.userId" value="${object.merchant72_id }"    >
					<a class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%=CashierAction.getMerchantUserGroutId() %>" lookupGroup="user_merchant" rel="user_merchant_lookup">查找</a>
				</td>
			</tr>
			<tr>
				<td>
					<div class="buttonActive" style="cursor: pointer;"><div class="buttonContent"><button type="submit">检索</button></div></div>
				</td>
			</tr>
		</table>
	</div>
	</form> 
</div>