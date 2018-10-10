<%@page import="java.util.Date"%>
<%@page import="org.bson.types.ObjectId"%>
<%@page import="com.lymava.qier.model.Merchant72"%>
<%@page import="com.lymava.qier.business.BusinessIntIdConfigQier"%>
<%@page import="com.lymava.trade.pay.model.PaymentRecord"%>
<%@page import="com.lymava.trade.base.model.BusinessRecord"%>
<%@page import="java.util.List"%>
<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.qier.activities.model.MarketingActivitiesMerchant"%>
<%@page import="com.lymava.qier.activities.model.MarketingActivities"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String zhongqiu_huodong_id = "5ba73786d6c4595897c5b976";

	SerializContext serializContext = ContextUtil.getSerializContext();

	MarketingActivities marketingActivities = (MarketingActivities)serializContext.get(MarketingActivities.class, zhongqiu_huodong_id);
	
	MarketingActivitiesMerchant marketingActivitiesMerchant_find = new MarketingActivitiesMerchant();
	
	marketingActivitiesMerchant_find.setState(State.STATE_OK);
	marketingActivitiesMerchant_find.setMarketingActivities_id(zhongqiu_huodong_id);
	
	List<MarketingActivitiesMerchant> marketingActivities_list =  serializContext.findAll(marketingActivitiesMerchant_find);
	
	for(MarketingActivitiesMerchant marketingActivitiesMerchant_tmp:marketingActivities_list){
		
		Integer all_day_count = marketingActivitiesMerchant_tmp.getAll_day_count();
		
		if(all_day_count == null || all_day_count <= 0){
			continue;
		}
		
		Long start_date = marketingActivitiesMerchant_tmp.getStart_date();
		Long end_date = marketingActivitiesMerchant_tmp.getEnd_date();
		
		if(start_date == null || end_date == null){
			continue;
		}
		//时间段的时间
		Long shjian_duan = end_date-start_date;
		
		//时间段小于0
		if(shjian_duan < 0){
			continue;
		}
		
		Merchant72 user_merchant = marketingActivitiesMerchant_tmp.getUser_merchant();
		
		if(user_merchant == null){
			continue;
		}
		
		PaymentRecord paymentRecord_find = new PaymentRecord();
		
		paymentRecord_find.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_zhongqiu_yuebing);
		paymentRecord_find.setUser_merchant(user_merchant);
		
		List<PaymentRecord> paymentRecord_list_had = serializContext.findAll(paymentRecord_find);
		
		//如果已经生成足够的记录
		if(paymentRecord_list_had.size() >= all_day_count){
			continue;
		}
		
		Integer shengyu_shengcheng = all_day_count-paymentRecord_list_had.size();
		
		for(int i=0;i<shengyu_shengcheng;i++){
			
			Long rand_shjian_duan = (long)(Math.random()*shjian_duan);
			
			Long object_id_time = start_date+rand_shjian_duan;
			
			ObjectId objectId = new ObjectId(new Date(object_id_time));
			
			
			PaymentRecord paymentRecord = new PaymentRecord();
			
			paymentRecord.setId(objectId.toString());
			paymentRecord.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_zhongqiu_yuebing);
			paymentRecord.setUser_merchant(user_merchant);
			paymentRecord.setState(State.STATE_WAITE_PROCESS);
			
			serializContext.save(paymentRecord);
		}
		
	}
	
	
%>