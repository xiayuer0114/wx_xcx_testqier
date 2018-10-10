<%@ page import="com.lymava.qier.activities.model.JiKaHuoDong" %>
<%@ page import="com.lymava.userfront.util.FrontUtil" %>
<%@ page import="com.lymava.base.model.User" %>
<%@ page import="com.lymava.commons.exception.CheckException" %>
<%@ page import="com.lymava.commons.util.DateUtil" %>
<%@ page import="com.lymava.commons.state.State" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.lymava.commons.state.StatusCode" %>
<%@ page import="java.util.Random" %>
<%@ page import="com.lymava.trade.pay.model.PaymentRecord" %>
<%@ page import="com.lymava.trade.pay.model.PaymentRecordOperationRecord" %>
<%@ page import="com.lymava.qier.activities.model.Daka" %>
<%@ page import="com.lymava.qier.business.BusinessIntIdConfigQier" %>
<%@ page import="com.lymava.trade.base.model.Business" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lymava.qier.model.MerchantRedEnvelope" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="../../../header/check_openid.jsp"%>
<%@ include file="../../../header/header_check_login.jsp"%>

<%

	JsonObject jsonObject = new JsonObject();

	try{

		User user_huiyuan =  FrontUtil.init_http_user(request);
		CheckException.checkIsTure(user_huiyuan != null,"用户登录超时！请刷新！");


		// 现在的时间
		Long nowTime = System.currentTimeMillis();
		// 今天开始的时间
		Long nowStartTime = DateUtil.getDayStartTime(nowTime);

		//校验今日集卡是否已经完成
		JiKaHuoDong jiKaHuoDong_find = new JiKaHuoDong();

		jiKaHuoDong_find.setLingqu_day(nowStartTime);
		jiKaHuoDong_find.setState(State.STATE_OK);

		JiKaHuoDong jiKaHuoDong_find_out = (JiKaHuoDong)serializContext.get(jiKaHuoDong_find);
		CheckException.checkIsTure(jiKaHuoDong_find_out != null,"请检查你的卡片是否集齐");

		Random r = new Random();

		Integer jiangjin=r.nextInt(3)+1;

		JiKaHuoDong jiKaHuoDong_update	=	new JiKaHuoDong();

		String jiKaHuoDong_id = new ObjectId().toString();
		jiKaHuoDong_update.setId(jiKaHuoDong_id);
		jiKaHuoDong_update.setOpenid(user_huiyuan.getThird_user_id());
		jiKaHuoDong_update.setLingqu_day(nowStartTime);
		if(jiKaHuoDong_find_out.getJika_paiming()%500!=0){
			jiKaHuoDong_update.setChoujiang_jine(jiangjin);
		}else {
			jiangjin=138;
			jiKaHuoDong_update.setChoujiang_jine(jiangjin);
		}
		jiKaHuoDong_update.setState(State.STATE_OK);

		serializContext.updateObject(jiKaHuoDong_find_out.getId(),jiKaHuoDong_update);

		//发放奖品
		jiKaHuoDong_find_out.jiangpin_fafang();

		jsonObject.addProperty("jiangjin", jiangjin);


		if(jiKaHuoDong_find_out.getJika_paiming()%500!=0||jiKaHuoDong_find_out.getJika_paiming()>5000) {
			Long yue_balance = 0L;
			if (user.getBalance() != null){
					yue_balance= user.getBalance();
			}

			PaymentRecord wallet_amount_paymentRecord = new PaymentRecordOperationRecord();

			String paymentRecord_save_id = new ObjectId().toString();

			wallet_amount_paymentRecord.setId(paymentRecord_save_id);
			wallet_amount_paymentRecord.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_jika);
			wallet_amount_paymentRecord.setPay_method(PayFinalVariable.pay_method_balance);
			wallet_amount_paymentRecord.setPrice_fen_all(((long) jiangjin) * Daka.pianyi);
			wallet_amount_paymentRecord.setUserId_huiyuan(user.getId());
			wallet_amount_paymentRecord.setState(State.STATE_PAY_SUCCESS);
			wallet_amount_paymentRecord.setRequestFlow(jiKaHuoDong_id);
			wallet_amount_paymentRecord.setWallet_amount_balance_pianyi(((long) jiangjin) * User.pianyiFen + yue_balance);
			wallet_amount_paymentRecord.setMemo("圣慕缇集卡普通奖励");

			// 保存这次业务交易
			serializContext.save(wallet_amount_paymentRecord);
			Business.checkRequestFlow(wallet_amount_paymentRecord);

			// 用户余额变动
			user.balanceChangeFen(((long) jiangjin) * Daka.pianyi);

		}else {
			MerchantRedEnvelope merchantRedEnvelope_send = new MerchantRedEnvelope();

			MerchantRedEnvelope merchantRedEnvelope_find = new MerchantRedEnvelope();
			merchantRedEnvelope_find.setUserId_merchant("5b309e497d170b366d56a674");
			merchantRedEnvelope_find.setState(State.STATE_WAITE_CHANGE);
			merchantRedEnvelope_find = (MerchantRedEnvelope)serializContext.get(merchantRedEnvelope_find);

			if(merchantRedEnvelope_find != null){
				merchantRedEnvelope_send = merchantRedEnvelope_find;
			};

			SimpleDateFormat sdf =  DateUtil.getSdfFull();
			String shi_date = "2018-10-30 00:00:00";
			Long a = sdf.parse(shi_date).getTime();
			String mer_red_id = new ObjectId().toString();
			merchantRedEnvelope_send.setId(mer_red_id);
			merchantRedEnvelope_send.setInAmount(138+"");
			merchantRedEnvelope_send.setUser_huiyuan(user);
			merchantRedEnvelope_send.setState(State.STATE_OK);
			merchantRedEnvelope_send.setRed_envolope_name("圣慕缇集卡");
			merchantRedEnvelope_send.setExpiry_time(a);
			serializContext.save(merchantRedEnvelope_send);
		}









	}catch(CheckException checkException){
		jsonObject.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_FALSE);
		jsonObject.addProperty(StatusCode.statusCode_message_key, checkException.getMessage());
	}catch(Exception e){
		jsonObject.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_FALSE);
		jsonObject.addProperty(StatusCode.statusCode_message_key, "领取失败!");
	}
	out.print(jsonObject);
%>