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
	Voucher voucher_find = new Voucher();


	voucher_find.addCommand(MongoCommand.in, "topUserId", "5aa0adf3ef722c157280a317");
	voucher_find.addCommand(MongoCommand.in, "topUserId", "5ae2ccd7ef722c1741549958");
	   
	Iterator<Voucher> voucher_ite =  ContextUtil.getSerializContext().findIterable(voucher_find);
	 
	while(voucher_ite.hasNext()){
		
		Voucher voucher_next = voucher_ite.next();
		
		System.out.println(voucher_next.getVoucherName()+" "+voucher_next.getTopUserId());
	}
	
	
	
%>