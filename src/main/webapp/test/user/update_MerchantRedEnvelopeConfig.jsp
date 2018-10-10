<%@page import="com.lymava.qier.model.User72"%>
<%@page import="com.lymava.qier.action.CashierAction"%>
<%@page import="com.lymava.wechat.gongzhonghao.SubscribeUser"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.base.model.User"%>
<%@page import="com.lymava.wechat.gongzhonghao.GongzonghaoContent"%>
<%@page import="com.lymava.wechat.gongzhonghao.Gongzonghao"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.mongodb.DBObject"%>
<%@page import="com.mongodb.BasicDBObject"%>
<%@page import="com.lymava.nosql.mongodb.util.MongoCommand"%>
<%@page import="com.lymava.qier.model.Voucher"%>
<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.commons.util.HexM"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.qier.model.UserVoucher"%>
<%@page import="com.lymava.commons.pay.PayFinalVariable"%>
<%@page import="com.lymava.commons.util.MathUtil"%>
<%@page import="com.lymava.trade.business.model.Product"%>
<%@ page import="com.lymava.qier.model.Merchant72" %>
<%@ page import="com.lymava.qier.model.Product72" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%  
		
		Merchant72 user_find = new Merchant72();
		user_find.setUserGroupId(CashierAction.getMerchantUserGroutId());

		Iterator<Merchant72> ite =  ContextUtil.getSerializContext().findIterable(user_find);
		
		while(ite.hasNext()){
			
			Merchant72 user_next = ite.next();
			
			Integer discount_ratio = user_next.getDiscount_ratio();
			
			Integer merchant_red_pack_ratio =  user_next.getMerchant_red_pack_ratio();
			
			if(discount_ratio == null || merchant_red_pack_ratio == null){
				continue;
			} 
			
			Double discount_ratio_double = MathUtil.divide(discount_ratio, User.pianyiYuan).doubleValue();
			
			Double discount_ratio_double_final = MathUtil.add(discount_ratio_double, 1).doubleValue();
			
			
			Integer final_merchant_red_pack_ratio = MathUtil.divide(merchant_red_pack_ratio, discount_ratio_double_final).intValue()/10000*10000;
			
			Merchant72 merchant72_update = new Merchant72();
			merchant72_update.setMerchant_red_pack_ratio(final_merchant_red_pack_ratio);
			
			ContextUtil.getSerializContext().updateObject(user_next.getId(), merchant72_update);
			
			out.println(user_next.getUsername()+" "+discount_ratio+" "+merchant_red_pack_ratio+" "+discount_ratio_double_final+" "+final_merchant_red_pack_ratio+"<br/>");
		}
 
	 
%>