<%@page import="com.lymava.commons.util.MathUtil"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.qier.model.UserVoucher"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@ page import="com.lymava.qier.model.Product72" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="com.lymava.qier.model.Voucher" %>
<%@ page import="com.lymava.qier.util.SunmingUtil" %>
<%@ page import="com.lymava.nosql.mongodb.util.MongoCommand" %>
<%@ page import="com.lymava.qier.action.MerchantShowAction" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="header/check_openid.jsp"%>
<%@ include file="header/header_check_login.jsp"%>
<%
	User front_user_tmp = (User)request.getAttribute(FinalVariable.SESSION_FRONT_FULL_USER);

	String payMoney_str = request.getParameter("payMoney");
	String product_id = request.getParameter("product_id");
	Double payMoney_double = MathUtil.parseDoubleNull(payMoney_str);

	// 孙M  用于判断
	Long payMoney_panduan = Math.round((MathUtil.parseDouble(payMoney_str)*100));
	
	PageSplit pageSplit = new PageSplit();
	pageSplit.setPageSize(5);
	  
	UserVoucher userVoucher_find = new UserVoucher();
	userVoucher_find.setUserId_huiyuan(front_user_tmp.getId());
	userVoucher_find.setUseState(State.STATE_OK);

	// ↓孙M  4.26 添加代金券的搜索条件
 
	// 得到商家的id
	Product72 product72_find = new Product72();
	product72_find.setId(product_id);
	product72_find = (Product72)ContextUtil.getSerializContext().get(product72_find);
	String merchant_id =  product72_find.getUserId_merchant();

	userVoucher_find.addCommand(MongoCommand.in, "userId_merchant", merchant_id);
	userVoucher_find.addCommand(MongoCommand.in, "userId_merchant", MerchantShowAction.getSysMerchantId());

	Iterator<UserVoucher> userVoucher_list = ContextUtil.getSerializContext().findIterable(userVoucher_find,pageSplit);

	Long sysTime = System.currentTimeMillis();
	List<UserVoucher> userVoucher_list_read = new LinkedList<UserVoucher>();
	while (userVoucher_list.hasNext()){
		UserVoucher bijiao =  userVoucher_list.next();
		// 使用时间在有效时间内
		Voucher voucher_panduan = bijiao.getVoucher();

		// 可以使用的开始时间和可以使用的结束时间的判断
		if(voucher_panduan.getUseReleaseTime() != null ){
			if(voucher_panduan.getUseReleaseTime() > sysTime){
				continue;
			}
		}
		if(voucher_panduan.getUseStopTime() != null ){
			if(voucher_panduan.getUseStopTime() < sysTime){
				continue;
			}
		}
		if (payMoney_panduan<(voucher_panduan.getUseWhere()*100)){
			continue;
		}

		userVoucher_list_read.add(bijiao);
	}

	request.getSession().setAttribute("check_user_id",front_user_tmp.getId());
	request.getSession().setAttribute("check_merchant_id",merchant_id);
	request.setAttribute("userVoucher_size", userVoucher_list_read.size());
	request.setAttribute("userVoucher_list", userVoucher_list_read);
%>
<script type="text/javascript">
	$(function(){
		$('.voucher_count').html('${userVoucher_size }');
	});
</script>
<c:forEach var="userVoucher" items="${userVoucher_list }">
	            	<div class="voucher_content"  > 
	            		<div onclick="voucher_content_click(this);" class="voucher_content_inner" userVoucher_id="${userVoucher.id }" voucherValue="${userVoucher.voucher.voucherValue }" low_consumption_amount="${userVoucher.voucher.low_consumption_amount }">
			            	<div class="voucher_content_left">
			                	<img alt="" src="${basePath }img/voucher/juse_left.png" style="display: block;width: 100%;height: 100%;">
			                </div>
			                <div class="voucher_content_left2">
			                	<div class="top">
			                		代金卷
			                	</div>
			                	<div class="buttom">
			                		<font style="font-weight: bold;font-size: 0.5rem;">¥</font>
			                		<font style="font-weight: bold;font-size: 0.7rem;">${userVoucher.voucher.voucherValue }</font>
			                	</div> 
			                </div>
			                <div class="voucher_content_right">  
			                	<div class="voucher_right_name"> 
			                		<c:out value="${userVoucher.user_merchant.nickname!=null?userVoucher.user_merchant.nickname:'悠择生活' }" escapeXml="true" />
			                	</div>
			                	<div class="voucher_right_middel">
			                		<span style="background-color: #fef0e6;"><c:out value="${userVoucher.voucher.voucherMiaoSu }" escapeXml="true" /></span>
			                	</div>  
			                	<div class="voucher_right_foot">
			                		有效期：<c:out value="${userVoucher.voucher.inShowStopTime }" escapeXml="true" />
			                	</div> 
			                </div>
		            	</div>
	            	</div>
            	</c:forEach>