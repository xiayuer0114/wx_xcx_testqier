<%--
	打开宝箱
 --%>

<%@ page import="com.lymava.commons.exception.CheckException" %>
<%@ page import="com.lymava.commons.state.StatusCode" %>
<%@ page import="java.util.Random" %>
<%@ page import="com.lymava.qier.activities.caididian.CaiDidianDaan" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.lymava.qier.activities.caididian.Didian" %>
<%@ page import="com.lymava.nosql.util.PageSplit" %>
<%@ page import="com.lymava.commons.util.*" %>
<%@ page import="com.lymava.nosql.mongodb.util.MongoCommand" %>
<%@ page import="com.lymava.qier.model.TradeRecord72" %>
<%@ page import="com.lymava.qier.util.SunmingUtil" %>
<%@ page import="com.lymava.trade.pay.model.PaymentRecord" %>
<%@ page import="com.lymava.trade.pay.model.PaymentRecordOperationRecord" %>
<%@ page import="com.lymava.trade.base.model.BusinessIntIdConfig" %>
<%@ page import="com.lymava.trade.base.model.Business" %>
<%@ page import="com.lymava.qier.business.BusinessIntIdConfigQier" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>

<%!
	/**
	 * 获取奖品类型
	 * @return CaiDidianDaan.XXX 奖品类型
	 */
	public Integer getPrize(String openid_header) {
		SerializContext serializContext = ContextUtil.getSerializContext();

		Integer caididian_666_count = Integer.valueOf(WebConfigContent.getConfig("caididian_666_count"));
		Integer caididian_166_count = Integer.valueOf(WebConfigContent.getConfig("caididian_166_count"));

		PageSplit pageSplit = new PageSplit();
		CaiDidianDaan caiDidianDaan_find = new CaiDidianDaan();
		//caiDidianDaan_find.setType_jiangpin(CaiDidianDaan.type_jiangpin_666);
		caiDidianDaan_find.setState(State.STATE_OK);
		caiDidianDaan_find.setOpenid(openid_header);

		//设置今天的红包
		Date currentDate = new Date();
		Date todayStart_date = new Date(DateUtil.getDayStartTime(currentDate.getTime()));
		Date todayEnd_date = new Date(DateUtil.getDayStartTime(currentDate.getTime() + DateUtil.one_day));
		caiDidianDaan_find.addCommand(MongoCommand.dayuAndDengyu, "lingqu_day", todayStart_date.getTime());
		caiDidianDaan_find.addCommand(MongoCommand.xiaoyu, "lingqu_day", todayEnd_date.getTime());

		serializContext.findIterable(caiDidianDaan_find, pageSplit);

		if (pageSplit.getCount() >= 2) {
			return CaiDidianDaan.type_jiangpin_weizhongjiang;
		}

		serializContext = ContextUtil.getSerializContext();

//		caididian_666_count = Integer.valueOf(WebConfigContent.getConfig("caididian_666_count"));
//		caididian_166_count = Integer.valueOf(WebConfigContent.getConfig("caididian_166_count"));

		pageSplit = new PageSplit();
		caiDidianDaan_find = new CaiDidianDaan();
		//caiDidianDaan_find.setType_jiangpin(CaiDidianDaan.type_jiangpin_666);
		caiDidianDaan_find.setState(State.STATE_OK);

		//设置今天的红包
		currentDate = new Date();
		todayStart_date = new Date(DateUtil.getDayStartTime(currentDate.getTime()));
		todayEnd_date = new Date(DateUtil.getDayStartTime(currentDate.getTime() + DateUtil.one_day));
		caiDidianDaan_find.addCommand(MongoCommand.dayuAndDengyu, "lingqu_day", todayStart_date.getTime());
		caiDidianDaan_find.addCommand(MongoCommand.xiaoyu, "lingqu_day", todayEnd_date.getTime());

		serializContext.findIterable(caiDidianDaan_find, pageSplit);

		if (pageSplit.getCount() >= caididian_666_count) {
			pageSplit = new PageSplit();
			caiDidianDaan_find = new CaiDidianDaan();
			caiDidianDaan_find.setType_jiangpin(CaiDidianDaan.type_jiangpin_166);
			caiDidianDaan_find.setState(State.STATE_OK);

			//设置今天的红包
			caiDidianDaan_find.addCommand(MongoCommand.dayuAndDengyu, "lingqu_day", todayStart_date.getTime());
			caiDidianDaan_find.addCommand(MongoCommand.xiaoyu, "lingqu_day", todayEnd_date.getTime());

			serializContext.findIterable(caiDidianDaan_find, pageSplit);

			if (pageSplit.getCount() >= caididian_166_count) {
				return CaiDidianDaan.type_jiangpin_weizhongjiang;
			}

			return CaiDidianDaan.type_jiangpin_166;
		}

		return CaiDidianDaan.type_jiangpin_666;
	}

	/**
	 * 获取指定奖品类型的金额（分）
	 * @return 奖品金额（分）
	 */
	public Integer getPrize_fen(Integer type_jiangpin) {

		if (type_jiangpin.equals(CaiDidianDaan.type_jiangpin_666)) {
			return 666;
		} else if (type_jiangpin.equals(CaiDidianDaan.type_jiangpin_166)) {
			return 166;
		}
		return null;
	}
%>

<%
	//校验 - 用户id是否有效 + 用户是否未打开宝箱
	String diadian_id = request.getParameter("diadian_id");
	CheckException.isValid(diadian_id, "找不到指定地点！");
	Didian didian = (Didian) serializContext.get(Didian.class, diadian_id);
	Integer didianStatus = didian.getUserDidianStatus(openid_header, false);
	CheckException.checkEquals(didianStatus, State.STATE_WAITE_PROCESS, "不能打开宝箱");
	
	Integer businessIntId_didian = 33360;

	JsonObject jsonObject = new JsonObject();
	try{
		int rand_number = new Random().nextInt(101);

		//查询该用户所有记录
		CaiDidianDaan caiDidianDaan_find = new CaiDidianDaan();
		caiDidianDaan_find.setDidian_id(diadian_id);
		caiDidianDaan_find.setOpenid(openid_header);
		CaiDidianDaan caiDidianDaan_update = (CaiDidianDaan)serializContext.get(caiDidianDaan_find);
		CheckException.checkNotNull(caiDidianDaan_update, "没有记录");

		//更新记录
		caiDidianDaan_update.setRand_number(rand_number);

		//获取奖品
		Integer prize = getPrize(openid_header);
		caiDidianDaan_update.setType_jiangpin(prize);
		caiDidianDaan_update.setPrice_fen(getPrize_fen(prize));

		if (rand_number <= 49 || prize.equals(CaiDidianDaan.type_jiangpin_weizhongjiang)) {
			caiDidianDaan_update.setState(State.STATE_FALSE);//未中奖（死亡）
			jsonObject.addProperty("result", false);

			if (caiDidianDaan_update.getRelife_count() != null && caiDidianDaan_update.getRelife_count() >=0) {
				caiDidianDaan_update.setRelife_count(caiDidianDaan_update.getRelife_count());
			} else {
				caiDidianDaan_update.setRelife_count(0);
			}

			if (caiDidianDaan_update.getRelife_day() != null){
				caiDidianDaan_update.setRelife_day(caiDidianDaan_update.getRelife_day());
			}
			else {
				caiDidianDaan_update.setRelife_day(new Date().getTime());
			}

		} else {
			caiDidianDaan_update.setState(State.STATE_OK);//中奖
			jsonObject.addProperty("result", true);

			//奖品图片
			if (prize.equals(CaiDidianDaan.type_jiangpin_666)) {
				Long yue_balance = 0L;
				Long jiangli_fen = 666L;
				if(user.getBalance() != null){
					yue_balance =  user.getBalance();
				}



				PaymentRecord wallet_amount_paymentRecord  = new PaymentRecordOperationRecord();

				wallet_amount_paymentRecord.setId(new ObjectId().toString());
			    wallet_amount_paymentRecord.setBusinessIntId(businessIntId_didian);
				wallet_amount_paymentRecord.setPay_method(PayFinalVariable.pay_method_balance);
				wallet_amount_paymentRecord.setPrice_fen_all( jiangli_fen);
				wallet_amount_paymentRecord.setUserId_huiyuan(user.getId());
				wallet_amount_paymentRecord.setState(State.STATE_PAY_SUCCESS);
				wallet_amount_paymentRecord.setRequestFlow(caiDidianDaan_update.getId());

				Long balance_piayi = wallet_amount_paymentRecord.getPrice_pianyi_all() + yue_balance;

				wallet_amount_paymentRecord.setWallet_amount_balance_pianyi(balance_piayi);
				wallet_amount_paymentRecord.setMemo("老地点");

				// 保存这次业务交易
				serializContext.save(wallet_amount_paymentRecord);
				Business.checkRequestFlow(wallet_amount_paymentRecord);

				// 用户余额变动
				user.balanceChangeFen(jiangli_fen);

				jsonObject.addProperty("img", "ticket.png");

			} else if (prize.equals(CaiDidianDaan.type_jiangpin_166)) {
				Long yue_balance = 0L;
				Long jiangli_fen = 166L;
				if(user.getBalance() != null){
					yue_balance =  user.getBalance();
				}

				PaymentRecord wallet_amount_paymentRecord  = new PaymentRecordOperationRecord();
				wallet_amount_paymentRecord.setId(new ObjectId().toString());
				wallet_amount_paymentRecord.setBusinessIntId(businessIntId_didian);
				wallet_amount_paymentRecord.setPay_method(PayFinalVariable.pay_method_balance);
				wallet_amount_paymentRecord.setPrice_fen_all( jiangli_fen);
				wallet_amount_paymentRecord.setUserId_huiyuan(user.getId());
				wallet_amount_paymentRecord.setState(State.STATE_PAY_SUCCESS);
				wallet_amount_paymentRecord.setRequestFlow(caiDidianDaan_update.getId());
				wallet_amount_paymentRecord.setWallet_amount_balance_pianyi(wallet_amount_paymentRecord.getPrice_pianyi_all() + yue_balance);
				wallet_amount_paymentRecord.setMemo("老地点");

				// 保存这次业务交易
				serializContext.save(wallet_amount_paymentRecord);
				Business.checkRequestFlow(wallet_amount_paymentRecord);

				// 用户余额变动
				user.balanceChangeFen(jiangli_fen);

				jsonObject.addProperty("img", "ticket2.png");

			}

			if (caiDidianDaan_update.getRelife_count() != null && caiDidianDaan_update.getRelife_count() >=0 ) {
				caiDidianDaan_update.setRelife_count(caiDidianDaan_update.getRelife_count());
			} else {
				caiDidianDaan_update.setRelife_count(0);
			}

			caiDidianDaan_update.setRelife_day(null);
		}

		serializContext.updateObject(caiDidianDaan_update.getId(), caiDidianDaan_update);

	}catch(CheckException checkException){
		jsonObject.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_FALSE);
		jsonObject.addProperty(StatusCode.statusCode_message_key, checkException.getMessage());
	}catch(Exception e){
		jsonObject.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_FALSE);
		jsonObject.addProperty(StatusCode.statusCode_message_key, "操作!");
	}
	out.print(jsonObject);
%>
