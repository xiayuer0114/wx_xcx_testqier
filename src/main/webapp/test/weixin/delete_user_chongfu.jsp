<%@page import="com.lymava.trade.base.model.Business"%>
<%@page import="org.bson.types.ObjectId"%>
<%@page import="com.lymava.trade.pay.model.PaymentRecordOperationRecord"%>
<%@page import="com.lymava.trade.pay.model.PaymentRecord"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.qier.model.MerchantRedEnvelope"%>
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
		
		User user_find = new User();
		user_find.setUserGroupId(CashierAction.getCommonUserGroutId());

		Iterator<User> ite =  ContextUtil.getSerializContext().findIterable(user_find);
		
		while(ite.hasNext()){
			
			User user_next = ite.next();
			
			String third_user_id = user_next.getThird_user_id();
			String unionid = user_next.getUnionid();
			
			if(MyUtil.isEmpty(third_user_id)){
				continue;
			}
			if(MyUtil.isEmpty(unionid)){
				continue;
			}
				
				
			User user_find_chongfu = new User();
			user_find_chongfu.setUnionid(unionid);
				
			List<User> user_chongfu_list = ContextUtil.getSerializContext().findAll(user_find_chongfu);
			
			if(user_chongfu_list == null || user_chongfu_list.size() <= 1){
				continue;
			}
				 
			for(User user_chongfu_tmp : user_chongfu_list){
				out.println(user_chongfu_tmp.getThird_user_id()+" "+user_chongfu_tmp.getUnionid()+" "+user_chongfu_tmp.getShowBalance()+"<br/>");
			}
			
			user_next = user_next.getFinalUser();
			//检查并合并账户
			user_next.check_repeat_and_all_in_one();
		} 
%>