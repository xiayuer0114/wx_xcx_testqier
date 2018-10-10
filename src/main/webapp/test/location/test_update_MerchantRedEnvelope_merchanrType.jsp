<%@ page import="com.lymava.qier.model.MerchantRedEnvelope" %>
<%@ page import="com.lymava.commons.state.State" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="com.lymava.qier.model.Merchant72" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%

	// 全部红包
	MerchantRedEnvelope merchantRedEnvelope_find = new MerchantRedEnvelope();

	List<MerchantRedEnvelope> merchantRedEnvelopeList = ContextUtil.getSerializContext().findAll(merchantRedEnvelope_find);


	// 批量处理
	for (MerchantRedEnvelope merchantRedEnvelope_out : merchantRedEnvelopeList){

		// 得到一个红包 对应的商家
		String id = merchantRedEnvelope_out.getUserId_merchant();

		Merchant72 merchant72 = (Merchant72)ContextUtil.getSerializContext().get(Merchant72.class, id);

		if(merchant72 == null){ continue;}
		if(merchant72.getMerchant72_type() == null){ continue; }
		
		MerchantRedEnvelope merchantRedEnvelope_update = new MerchantRedEnvelope();
		// 更新
		merchantRedEnvelope_update.setMerchant_type( merchant72.getMerchant72_type() );

		ContextUtil.getSerializContext().updateObject(merchantRedEnvelope_out.getId(),merchantRedEnvelope_update);
	}
%>







