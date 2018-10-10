<%@ page import="com.lymava.qier.model.MerchantRedEnvelope" %>
<%@ page import="com.lymava.commons.state.State" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="com.lymava.qier.model.Merchant72" %>
<%@ page import="com.lymava.qier.model.MerchantRedEnvelopeConfig" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%

	// 全部红包配置
	MerchantRedEnvelopeConfig merchantRedEnvelopeConfig_find = new MerchantRedEnvelopeConfig();

	List<MerchantRedEnvelopeConfig> merchantRedEnvelopeConfigList = ContextUtil.getSerializContext().findAll(merchantRedEnvelopeConfig_find);


	// 批量处理
	for (MerchantRedEnvelopeConfig merchantRedEnvelopeConfig_out : merchantRedEnvelopeConfigList){

		// 得到一个红包 对应的商家
		String id = merchantRedEnvelopeConfig_out.getUserId_merchant();

		Merchant72 merchant72 = (Merchant72)ContextUtil.getSerializContext().get(Merchant72.class, id);

		if(merchant72 == null){ continue;}
		if(merchant72.getMerchant72_type() == null){ continue; }

		// 更新
		MerchantRedEnvelopeConfig merchantRedEnvelopeConfig_update = new MerchantRedEnvelopeConfig();
		merchantRedEnvelopeConfig_update.setMerchant_type( merchant72.getMerchant72_type() );

		ContextUtil.getSerializContext().updateObject(merchantRedEnvelopeConfig_out.getId(),merchantRedEnvelopeConfig_update);
	}
%>







