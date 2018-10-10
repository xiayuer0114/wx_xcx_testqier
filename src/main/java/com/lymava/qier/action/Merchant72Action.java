package com.lymava.qier.action;

import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import com.lymava.qier.cmbpay.model.TransferToMerchantRecord;
import org.bson.types.ObjectId;
import org.springframework.beans.factory.support.ManagedMap;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.lymava.base.action.BaseAction;
import com.lymava.base.model.BalanceLog;
import com.lymava.base.model.User;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlMethod;
import com.lymava.base.safecontroler.model.UserV2;
import com.lymava.base.util.ContextUtil;
import com.lymava.base.util.FinalVariable;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.pay.PayFinalVariable;
import com.lymava.commons.state.State;
import com.lymava.commons.state.StatusCode;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.qier.business.BusinessIntIdConfigQier;
import com.lymava.qier.manager.model.ChangeRatioRecord;
import com.lymava.qier.manager.model.RedEnvelopeChangeRecord;
import com.lymava.qier.model.BalanceLog72;
import com.lymava.qier.model.DuizhangEntity;
import com.lymava.qier.model.Merchant72;
import com.lymava.qier.model.TradeRecord72;
import com.lymava.qier.model.User72;
import com.lymava.qier.model.merchant.MerchantBankChangeRecord;
import com.lymava.qier.util.SunmingUtil;
import com.lymava.trade.base.context.BusinessContext;
import com.lymava.trade.base.model.Business;
import com.lymava.trade.base.model.BusinessIntIdConfig;
import com.lymava.trade.pay.model.PaymentRecord;


/**
 *
 * 72社圈商户 Action
 *
 * @author lymava
 *
 */
@AcceptUrlAction(path="v2/Merchant72/")
public class Merchant72Action extends BaseAction{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8595919025048181302L;


	// 得到'商户预付款' 的Memo标识
	public static String getBalanceLogMerchantMemo(){ return "商户预付款"; };


	/**
	 * 定向红包余额变动
	 * @return
	 */
	@AcceptUrlMethod( name="定向红包余额变动" )
	public String merchant_redenvelope_balance_change()	{

		//获取登录后台管理员
		UserV2 userv2 = (UserV2) request.getAttribute(FinalVariable.SESSION_LOGINUSER);

		//获取参数
		String id = request.getParameter("id");
		Merchant72 merchant72 = null;
		if(MyUtil.isValid(id)){
			merchant72 = (Merchant72) serializContext.get(Merchant72.class,id);
		}
		CheckException.checkNotNull(merchant72, "未找到您所要操作的记录");


		//BusinessContext用于WriteBusiness
		BusinessContext instance = BusinessContext.getInstance();
		Business<RedEnvelopeChangeRecord> business =
				instance.getBusiness(BusinessIntIdConfigQier.businessIntId_red_envelope_change);
		CheckException.checkIsTure(business != null, "转账业务未配置!");

		Map requestMap = new HashMap();
		requestMap.putAll(request.getParameterMap());
		requestMap.put(Business.user_key, merchant72);
		requestMap.put(Business.ip_key, MyUtil.getIpAddr(request));
		requestMap.put(Business.requestFlow_key, System.currentTimeMillis() + "");

		requestMap.put("userV2", userv2);

		RedEnvelopeChangeRecord ret = business.executeBusiness(requestMap);

		//设置返回值
		Integer state = ret.getState();

		if(State.STATE_OK.equals(state)) {

			this.setMessage("定向红包余额变动请求已提交，请等待审核！");
			this.setStatusCode(StatusCode.ACCEPT_OK);
		}else {

			this.setMessage("定向红包余额变动提交请求失败！");
			this.setStatusCode(StatusCode.ACCEPT_FALSE);
		}
		return SUCCESS;
	}

	@AcceptUrlMethod(name = "红包池变动审核")
	public String shenghe_RedEnvelopeChange() {

		//获取参数
		String id = this.getParameter("id");
		CheckException.isValid(id, "记录id无效！");

		//已变更的银行卡不能再改变状态
		RedEnvelopeChangeRecord redEnvelopeChangeRecord_find = (RedEnvelopeChangeRecord) serializContext.get(RedEnvelopeChangeRecord.class, id);
		CheckException.checkIsTure(
				!RedEnvelopeChangeRecord.accept_shenhe_state_complete.equals(redEnvelopeChangeRecord_find.getState()), "不能修改已变更的红包池");

		//修改状态
		String state_str = this.getParameter("state");
		Integer shenhe_state = Integer.valueOf(state_str);

		RedEnvelopeChangeRecord redEnvelopeChangeRecord_update = new RedEnvelopeChangeRecord();
		redEnvelopeChangeRecord_update.setState(shenhe_state);
		serializContext.updateObject(id, redEnvelopeChangeRecord_update);

		//红包池变动业务逻辑
		if (MerchantBankChangeRecord.accept_shenhe_state_complete.equals(shenhe_state)) {
			Double merchant_redenvelope_balance_change_yuan =//转账凭证
					MathUtil.parseDouble(
							(redEnvelopeChangeRecord_find.getMerchant_redenvelope_balance_change_Fen()/100) + "");

			CheckException.checkIsTure(merchant_redenvelope_balance_change_yuan>0, "余额变动 的值不能小于等于0");

			Long merchant_redenvelope_balance_change_fen =
					MathUtil.multiplyInteger(merchant_redenvelope_balance_change_yuan, 100).longValue();

			redEnvelopeChangeRecord_find.getMerchant72().merchant_redenvelope_balance_changeFen(
					merchant_redenvelope_balance_change_fen);
		}

		this.setMessage("修改成功！");
		this.setStatusCode(StatusCode.ACCEPT_OK);
		return SUCCESS;
	}




	/**
	 * 返利配置变动
	 * @return
	 */
	@AcceptUrlMethod( name="返利配置变动" )
	public String change_ratio()	{
		
		String id = request.getParameter("id");
		 
		UserV2 userv2 =	(UserV2) request.getAttribute("loginuser");
			
		Merchant72 merchant72 = null;
			
		if(MyUtil.isValid(id)){
			merchant72 = (Merchant72) serializContext.get(Merchant72.class,id);
		}
		
		CheckException.checkNotNull(merchant72, "未找到您所要操作的记录");
		
		String discount_ratio_str = request.getParameter("user.inDiscount_ratio");
		String red_pack_ratio_max_str = request.getParameter("user.inRed_pack_ratio_max");
		String red_pack_ratio_min_str = request.getParameter("user.inRed_pack_ratio_min");
		String merchant_redenvelope_arrive_fen_str = request.getParameter("user.inMerchant_redenvelope_arrive_yuan");
		String merchant_red_pack_ratio_str = request.getParameter("user.merchant_red_pack_ratio");
		String pinzheng = request.getParameter("pinzheng");

		CheckException.checkIsTure(MathUtil.parseDouble(merchant_red_pack_ratio_str) > 0D,"定向红包比例 配置不能小于等于0");
		CheckException.checkIsTure(MathUtil.parseDouble(discount_ratio_str) > 0D,"折扣总比例 配置不能小于等于0");
		CheckException.checkIsTure(MathUtil.parseDouble(red_pack_ratio_max_str) > 0D,"红包最大比例 配置不能小于等于0");
		CheckException.checkIsTure(MathUtil.parseDouble(red_pack_ratio_min_str) > 0D,"红包最小比例 配置不能小于等于0");
		CheckException.checkIsTure(MathUtil.parseDouble(merchant_redenvelope_arrive_fen_str) > 0D,"生成阀值 配置不能小于等于0");
		CheckException.checkNotEmpty(pinzheng, "请选择凭证！");

		//BusinessContext用于WriteBusiness
		BusinessContext instance = BusinessContext.getInstance();
		Business<ChangeRatioRecord> business =
				instance.getBusiness(BusinessIntIdConfigQier.businessIntId_change_ratio);
		CheckException.checkIsTure(business != null, "返利配置业务未配置!");

		Map requestMap = new HashMap();
		requestMap.putAll(request.getParameterMap());
		requestMap.put(Business.user_key, merchant72);
		requestMap.put(Business.ip_key, MyUtil.getIpAddr(request));
		requestMap.put(Business.requestFlow_key, System.currentTimeMillis() + "");

		requestMap.put("userV2", userv2);

		ChangeRatioRecord ret = business.executeBusiness(requestMap);

		//设置返回值
		Integer state = ret.getState();

		if(State.STATE_OK.equals(state)) {

			this.setMessage("返利配置变动请求已提交，请等待审核！");
			this.setStatusCode(StatusCode.ACCEPT_OK);
		}else {

			this.setMessage("返利配置变动提交请求失败！");
			this.setStatusCode(StatusCode.ACCEPT_FALSE);
		}
		return SUCCESS;
	}

	@AcceptUrlMethod(name = "返利配置变动审核")
	public String shenghe_change_ratio() {

		//获取参数
		String id = this.getParameter("id");
		CheckException.isValid(id, "记录id无效！");

		//已变更不能再改变状态
		ChangeRatioRecord changeRatioRecord_find = (ChangeRatioRecord) serializContext.get(ChangeRatioRecord.class, id);
		
		CheckException.checkIsTure(changeRatioRecord_find != null , "未找到此业务记录!");
		
		CheckException.checkIsTure(
				!ChangeRatioRecord.accept_shenhe_state_complete.equals(changeRatioRecord_find.getState()), "不能修改已变更的返利");

		//修改状态
		String state_str = this.getParameter("state");
		Integer shenhe_state = Integer.valueOf(state_str);

		ChangeRatioRecord changeRatioRecord_update = new ChangeRatioRecord();
		changeRatioRecord_update.setState(shenhe_state);
		serializContext.updateObject(id, changeRatioRecord_update);
		
		//业务逻辑
		if (MerchantBankChangeRecord.accept_shenhe_state_complete.equals(shenhe_state)) {

			//从Business中获取参数
			Integer merchant_red_pack_ratio = changeRatioRecord_find.getMerchant_red_pack_ratio();
			merchant_red_pack_ratio /= 10000;

			Integer discount_ratio = changeRatioRecord_find.getDiscount_ratio();
			discount_ratio /= 10000;

			Integer red_pack_ratio_max = changeRatioRecord_find.getRed_pack_ratio_max();
			red_pack_ratio_max /= 10000;

			Integer red_pack_ratio_min = changeRatioRecord_find.getRed_pack_ratio_min();
			red_pack_ratio_min /= 10000;

			Long merchant_redenvelope_arrive_fen = changeRatioRecord_find.getMerchant_redenvelope_arrive_fen();
			merchant_redenvelope_arrive_fen /= 100;

			//设置参数，执行业务
			Merchant72 merchant72_update = new Merchant72();
			
			merchant72_update.setInMerchant_red_pack_ratio(String.valueOf(merchant_red_pack_ratio));
			merchant72_update.setInDiscount_ratio(String.valueOf(discount_ratio));
			merchant72_update.setInRed_pack_ratio_max(String.valueOf(red_pack_ratio_max));
			merchant72_update.setInRed_pack_ratio_min(String.valueOf(red_pack_ratio_min));
			merchant72_update.setInMerchant_redenvelope_arrive_yuan(String.valueOf(merchant_redenvelope_arrive_fen));
			
			serializContext.updateObject(changeRatioRecord_find.getMerchant72_id(), merchant72_update);
		}

		this.setMessage("修改成功！");
		this.setStatusCode(StatusCode.ACCEPT_OK);
		return SUCCESS;
	}



	
	/**
	 * 余额变动（已被去掉）
	 * @return
	 */
//	@AcceptUrlMethod( name="商户预付款变动" )
	public String merchant_balance_change()	{
		String id = request.getParameter("id");
		 
		 UserV2 userv2 =	(UserV2) request.getAttribute("loginuser");
			
		Merchant72 merchant72 = null;
			
		if(MyUtil.isValid(id)){
			merchant72 = (Merchant72) serializContext.get(Merchant72.class,id);
		}
		
		CheckException.checkNotNull(merchant72, "未找到您所要操作的记录");
		
			String balance_str = request.getParameter("balance"); 
			String memo = request.getParameter("memo"); 
			String orderId = request.getParameter("orderId");

			Double balance_int_yuan = MathUtil.parseDouble(balance_str);
			
			Long balance_int_pianyi = User.getPianyi(balance_int_yuan);


			
			CheckException.checkIsTure(balance_int_pianyi != 0, "操作余额不能为零!请输入大于0的数字");
			
			CheckException.checkIsTure(orderId != null && !orderId.trim().isEmpty(), "流水号不能为空!");

			// 孙M    5.4  修改添加模式
            BalanceLog72 balance_log = new BalanceLog72();
//			BalanceLog balance_log = new BalanceLog();

			String yue_log_id = new ObjectId().toString();
			
			Long merchant_balance = merchant72.getMerchant_balance();
			if(merchant_balance == null){
				merchant_balance = 0l;
			}
			 
			balance_log.setId(yue_log_id);
			balance_log.setCount(balance_int_pianyi);
			balance_log.setBalance(balance_int_pianyi+merchant_balance);
			balance_log.setMemo("商户预付款");
			balance_log.setBack_memo(memo);
			balance_log.setUserv2(userv2);
			balance_log.setUser(merchant72);
			balance_log.setOrderId(orderId);


            // 孙M   5.4   添加字段
            String topUpBalance_str = request.getParameter("topUpBalance");
            String discount_str = request.getParameter("discount");

			// 孙M   5.4    添加新字段
            Long topUp = User.getPianyi(MathUtil.parseDouble(topUpBalance_str));
//            CheckException.checkIsTure(topUp != 0, "实际支付请输入大于0的数字");
            balance_log.setTopUpBalance(topUp);

            Long dis =  User.getPianyi(MathUtil.parseDouble(discount_str));
//            CheckException.checkIsTure(dis != 0, "折扣额错误");
            balance_log.setDiscount(dis);
			
			serializContext.save(balance_log);
			
			BalanceLog balanceLog_find = new BalanceLog();
			balanceLog_find.setOrderId(orderId);
			
			List<BalanceLog> findAll = serializContext.findAll(balanceLog_find);
			
			boolean order_right =  findAll  !=  null  && findAll.size() == 1  && yue_log_id.equals(findAll.get(0).getId());
			try{
				CheckException.checkIsTure(order_right , "重复操作!");
			}catch(CheckException e){
				serializContext.removeByKey(balance_log);
				throw e;
			}
			
				merchant72.merchant_balance_Change(balance_int_pianyi);
			
				JsonObject jo = new JsonObject();
				jo.addProperty("statusCode", "200");
				jo.addProperty("message", "预付款变动成功！");
				
		this.setStrutsOutString(jo.toString());
		return SUCCESS;
	}


	/**
	 * 孙M
	 * 跳转到 展示每个商家的详细信息的页面  ( 商家详情页 )
	 * @return
	 */
	public String merchartDetailShow(){
		this.setSuccessResultValue("/v2/inc/showMerchantDuiZhangData.jsp");
		return SUCCESS;
	}
	/**
	 * 孙M   6.13
	 * 跳转到 所有商家的订单信息汇总页面  ( 商家汇总 )
	 * @return
	 */
	public String merchartCollectShow(){
		this.setSuccessResultValue("/v2/inc/showMerchantCollect.jsp");
		return SUCCESS;
	}
	/**
	 * 孙M   6.13
	 * 跳转到 商家的余额变动页面  ( 余额变动 )
	 * @return
	 */
	public String merchartBalanceChangeShow(){
//		this.setSuccessResultValue("/v2/inc/showMerchantYuFuKuan.jsp");
		this.setSuccessResultValue("/v2/inc/yuebiandong.jsp");
		return SUCCESS;
	}
	/**
	 * 孙M   7.6
	 * 跳转到 流水对比展示页面 ( 流水分析 )
	 * @return
	 */
	public String showDataFenxi(){
		this.setSuccessResultValue("/v2/inc/showDataFenxi.jsp");
		return SUCCESS;
	}
	/**
	 * 孙M   8.15
	 * 跳转到 业务员 对饮的商家商家信息表
	 * @return
	 */
	public String showYeWuYuanMerchantInfo(){
		this.setSuccessResultValue("/v2/inc/showYeWuYuanMerchantInfo.jsp");
		return SUCCESS;
	}


	/**
	 * 孙M  6.13
	 * 获取商家列表   商家名 和 商家id
	 * @return
	 */
	public String getMerchantList(){
		Merchant72 merchant72_find = new Merchant72();
		merchant72_find.setState(User.STATE_OK);
		merchant72_find.setUserGroupId(CashierAction.getMerchantUserGroutId());

		List<Merchant72> merchant72List = serializContext.findAll(merchant72_find);

		JsonArray jsonArray = new JsonArray();
		for (Merchant72 merchant72_out : merchant72List){
			JsonObject jsonObject = new JsonObject();
			jsonObject.addProperty("merchantId",merchant72_out.getId());
			jsonObject.addProperty("nickName",merchant72_out.getNickname());
			jsonArray.add(jsonObject);
		}

		this.setStatusCode(StatusCode.ACCEPT_OK);
		this.setMessage("已返回商家列表");
		this.setDataRoot(jsonArray);
		return SUCCESS;
	}



	/**
	 * 孙M
	 * 获取详细的订单详情
	 * @return
	 */
	public String getTradeRecord72Detail(){
		// 获取参数 & 检查
		String startTime = request.getParameter("startTime");
		String endTime = request.getParameter("endTime");
		String merchantId = request.getParameter("merchantId");
		String payState = request.getParameter("payState");


		Long start_time = SunmingUtil.dateStrToLongYMD_hms(startTime);
		Long end_time = SunmingUtil.dateStrToLongYMD_hms(endTime);
		CheckException.checkIsTure(start_time!=null,"开始时间不正确");
		CheckException.checkIsTure(end_time!=null,"结束时间不正确");
		CheckException.checkIsTure(start_time<end_time,"结束时间大于了开始时间");
//		CheckException.checkIsTure(((end_time-start_time)<(DateUtil.one_day*90)),"结束时间和开始时间相差了 93天!");

		// 设置查询条件
		TradeRecord72 tradeRecord72_find = new TradeRecord72();
			if (!SunmingUtil.strIsNull(merchantId)){
				CheckException.checkIsTure(MyUtil.isValid(merchantId),"商家的id错误");
				tradeRecord72_find.setUserId_merchant(merchantId);
			}
		tradeRecord72_find.setBusinessIntId(BusinessIntIdConfig.businessIntId_trade);
		tradeRecord72_find = (TradeRecord72) SunmingUtil.setQueryWhere_time(tradeRecord72_find,start_time,end_time);
		if(!SunmingUtil.strIsNull(payState)){
			tradeRecord72_find.setState(MathUtil.parseInteger(payState));
		}

		List<TradeRecord72> tradeRecord72List = serializContext.findAll(tradeRecord72_find);

		Long orderPrice = 0L;
		Long realPrice = 0L;
		Long aliPay = 0L;
		Long wechatPay = 0L;
		Long redPay = 0L;


		JsonArray jsonArray = new JsonArray();
		for (TradeRecord72 tradeRecord72_out : tradeRecord72List){
			JsonObject jsonObject = new JsonObject();
			jsonObject.addProperty("payFlow",tradeRecord72_out.getRequestFlow());   // 订单编号
			jsonObject.addProperty("orderTime",tradeRecord72_out.getShowTime());  // 创建时间
			jsonObject.addProperty("payMethod",tradeRecord72_out.getShowPay_method());  // 付款方式
			jsonObject.addProperty("order_price",tradeRecord72_out.getShowPrice_fen_all());   // 订单金额
			jsonObject.addProperty("real_pay",tradeRecord72_out.getThirdPayPrice_fen_all());  // 实际支付
			jsonObject.addProperty("wallet_pay",tradeRecord72_out.getWallet_amount_payment_fen()); // 钱包支付

			jsonArray.add(jsonObject);

			Long order_price = Math.abs(tradeRecord72_out.getShowPrice_fen_all());    // 每笔订单的金额
			Long thirdPayPrice_fen_all = tradeRecord72_out.getThirdPayPrice_fen_all(); // 每笔订单的实际支付
			Long wallet_amount_payment_fen = tradeRecord72_out.getWallet_amount_payment_fen(); // 每笔订单的红包支付

			orderPrice += order_price;  // 订单金额累加
			realPrice += thirdPayPrice_fen_all; // 实际支付累加

			// 红包支付
			if(wallet_amount_payment_fen != null && wallet_amount_payment_fen > 0L) {
				redPay += wallet_amount_payment_fen;
			}
			// 支付宝支付
			if (PayFinalVariable.pay_method_alipay.equals(tradeRecord72_out.getPay_method())) {
				aliPay += thirdPayPrice_fen_all;
			}
			// 微信支付
			if (PayFinalVariable.pay_method_weipay.equals(tradeRecord72_out.getPay_method())) {
				wechatPay += thirdPayPrice_fen_all;
			}
		}

		Merchant72 merchant72 = null;
		if (!SunmingUtil.strIsNull(merchantId)){
			merchant72 = (Merchant72)serializContext.get(Merchant72.class,merchantId);
		}

		this.setStatusCode(StatusCode.ACCEPT_OK);
		this.setMessage("all data by time");
		this.addField("startTime_str",SunmingUtil.longDateToStrDate_tall(start_time));
		this.addField("endTime_str",SunmingUtil.longDateToStrDate_tall(end_time));
		this.addField("showPayState",tradeRecord72_find.getShowState()==null?"全部状态":tradeRecord72_find.getShowState());
		this.addField("nickName",merchant72!=null?merchant72.getNickname():"全部商家");

		this.addField("orderPrice",orderPrice);
		this.addField("realPrice",realPrice);
		this.addField("aliPay",aliPay);
		this.addField("wechatPay",wechatPay);
		this.addField("redPay",redPay);
		this.setDataRoot(jsonArray);
		return  SUCCESS;
	}



	/**
	 * 孙M
	 * 获取所有商家的消费信息(订单信息汇总)
	 * @return
	 */
	public String getAllMerchantCollect() {

		// 时间获取
		String startTime_str = request.getParameter("start_time");
		String endTime_str = request.getParameter("end_time");
		Long startTime = SunmingUtil.dateStrToLongYMD_hms(startTime_str);
		Long endTime = SunmingUtil.dateStrToLongYMD_hms(endTime_str);
		CheckException.checkIsTure(startTime != null, "开始时间不正确");
		CheckException.checkIsTure(endTime != null, "结束时间不正确");
		CheckException.checkIsTure(startTime<endTime, "开始时间大于结束时间");

		// 所有商家
		Merchant72 merchant72_find = new Merchant72();
		merchant72_find.setUserGroupId(CashierAction.getMerchantUserGroutId());
		merchant72_find.setState(User.STATE_OK);
		List<Merchant72> merchant72List = serializContext.findAll(merchant72_find);
		Merchant72 merchant72_find_2 = new Merchant72();
		merchant72_find_2.setUserGroupId(CashierAction.getMerchantUserGroutId());
		merchant72_find_2.addCommand(MongoCommand.budengyu,"state",User.STATE_OK);
		List<Merchant72> merchant72List_2 = serializContext.findAll(merchant72_find_2);
		merchant72List.addAll(merchant72List_2);

		// 退款
		Long orderPrice_refund = 0L;
		Long aliPay_all_refund = 0L;
		Long wechatPay_all_refund = 0L;
		Long otherPay_all_refund = 0L;
		// 汇总数据
		Long orderPrice_all = 0L;
		Long realPrice_all = 0L;
		Long aliPay_all = 0L;
		Long wechatPay_all = 0L;
		Long redPay_all = 0L;

		JsonArray jsonArray = new JsonArray();
		for (Merchant72 merchant72_out : merchant72List) {

			// 一个商家的汇总数据
			Long orderPrice = 0L;
			Long realPrice = 0L;
			Long aliPay = 0L;
			Long wechatPay = 0L;
			Long redPay = 0L;

			TradeRecord72 paymentRecord_find = new TradeRecord72();
			paymentRecord_find = (TradeRecord72) SunmingUtil.setQueryWhere_time(paymentRecord_find, startTime, endTime);
			paymentRecord_find.setUserId_merchant(merchant72_out.getId());
			paymentRecord_find.setBusinessIntId(BusinessIntIdConfig.businessIntId_trade);  // 业务订单
			paymentRecord_find.setState(State.STATE_PAY_SUCCESS);  //  支付成功

			// 业务订单
			Iterator<TradeRecord72> recordIterator_all = serializContext.findIterable(paymentRecord_find);

			while (recordIterator_all.hasNext()){
				TradeRecord72 paymentRecord_temp = recordIterator_all.next();
				Long order_price = Math.abs(paymentRecord_temp.getShowPrice_fen_all());    // 每笔订单的金额
				Long thirdPayPrice_fen_all = Math.abs(paymentRecord_temp.getThirdPayPrice_fen_all()); // 每笔订单的实际支付
				Long wallet_amount_payment_fen = 0L; // 每笔订单的红包支付
				if(paymentRecord_temp.getWallet_amount_payment_fen() != null){
					wallet_amount_payment_fen = paymentRecord_temp.getWallet_amount_payment_fen(); // 每笔订单的红包支付
				}

				orderPrice      += order_price;  // 这个商家订单金额
				orderPrice_all  += order_price;  // 所有商家订单金额

				realPrice      += thirdPayPrice_fen_all; // 这个商家的实际支付
				realPrice_all  += thirdPayPrice_fen_all; // 所有商家的实际支付

				redPay     +=  wallet_amount_payment_fen;  // 这个商家红包支付
				redPay_all +=  wallet_amount_payment_fen;  // 所有商家红包支付

				if( PayFinalVariable.pay_method_weipay.equals(paymentRecord_temp.getPay_method())  ||  PayFinalVariable.pay_method_weipay == paymentRecord_temp.getPay_method()  ){
					wechatPay      +=  thirdPayPrice_fen_all;  // 这个商家的微信实际支付
					wechatPay_all  +=  thirdPayPrice_fen_all;  // 所有商家的微信实际支付
				}
				if( PayFinalVariable.pay_method_alipay.equals(paymentRecord_temp.getPay_method())  ||  PayFinalVariable.pay_method_alipay == paymentRecord_temp.getPay_method()  ){
					aliPay      +=  thirdPayPrice_fen_all;  // 这个商家的支付宝实际支付
					aliPay_all  +=  thirdPayPrice_fen_all;   //所有商家的支付宝实际支付
				}
			}


			Long all_refund_price = 0L;
			Long alipay_refund_price =0L;
			Long wechat_refund_price =0L;
			Long otherPay_refund_price = 0L;

//			Long otherPay_all_refund = 0L;

			paymentRecord_find.setBusinessIntId(BusinessIntIdConfig.businessIntId_refund);  // 退款
			paymentRecord_find.setState(State.STATE_OK);  // 交易成功

			// 退款
			recordIterator_all = serializContext.findIterable(paymentRecord_find);
			while (recordIterator_all.hasNext()){
				TradeRecord72 paymentRecord_temp = recordIterator_all.next();
				Long order_price_refund = Math.abs(paymentRecord_temp.getShowPrice_fen_all());    // 每笔订单的金额

				all_refund_price   += order_price_refund;  // 这个商家的所有退款
				orderPrice_refund  += order_price_refund;  // 所有商家的所有退款

				if( PayFinalVariable.pay_method_weipay.equals(paymentRecord_temp.getPay_method())  ||  PayFinalVariable.pay_method_weipay == paymentRecord_temp.getPay_method()  ){
					wechat_refund_price    +=  order_price_refund;  // 这个商家的微信退款
					wechatPay_all_refund   +=  order_price_refund;  // 所有商家的微信实际退款
				}else if( PayFinalVariable.pay_method_alipay.equals(paymentRecord_temp.getPay_method())  ||  PayFinalVariable.pay_method_alipay == paymentRecord_temp.getPay_method()  ){
					alipay_refund_price  +=  order_price_refund;  // 这个商家的支付宝实际退款
					aliPay_all_refund    +=  order_price_refund;   //所有商家的支付宝实际退款
				}else{
					otherPay_refund_price +=  order_price_refund;
					otherPay_all_refund   +=  order_price_refund;
				}
			}






			JsonObject jsonObject = new JsonObject();
			jsonObject.addProperty("bianhao", merchant72_out.getBianhao());
			jsonObject.addProperty("nickName", merchant72_out.getNickname() );
			jsonObject.addProperty("merchantBalance", merchant72_out.getShowMerchant_balance() );

			jsonObject.addProperty("orderPrice", orderPrice );
			jsonObject.addProperty("realPrice", realPrice );
			jsonObject.addProperty("aliPay", aliPay );
			jsonObject.addProperty("wechatPay", wechatPay );
			jsonObject.addProperty("redPay", redPay );

			jsonObject.addProperty("all_refund_price", all_refund_price );
			jsonObject.addProperty("alipay_refund_price", alipay_refund_price );
			jsonObject.addProperty("wechat_refund_price", wechat_refund_price );
			jsonObject.addProperty("otherPay_refund_price", otherPay_refund_price );

			TradeRecord72 paymentRecord_yewu_last_one = new TradeRecord72();
			paymentRecord_yewu_last_one = (TradeRecord72) SunmingUtil.setQueryWhere_time(paymentRecord_yewu_last_one, startTime, endTime);
			paymentRecord_yewu_last_one.setUserId_merchant(merchant72_out.getId());
			paymentRecord_yewu_last_one.setBusinessIntId(BusinessIntIdConfig.businessIntId_trade);  // 业务订单
			paymentRecord_yewu_last_one.setState(State.STATE_PAY_SUCCESS);  //  支付成功
			// 最后一笔业务订单
			paymentRecord_yewu_last_one = (TradeRecord72)serializContext.findOne(paymentRecord_yewu_last_one);

			TradeRecord72 paymentRecord_yufukuan_last_one = new TradeRecord72();
			paymentRecord_yufukuan_last_one = (TradeRecord72) SunmingUtil.setQueryWhere_time(paymentRecord_yufukuan_last_one, startTime, endTime);
			paymentRecord_yufukuan_last_one.setUserId_merchant(merchant72_out.getId());
			paymentRecord_yufukuan_last_one.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_manual_transfer_to_merchant);  // 业务订单
			paymentRecord_yufukuan_last_one.setState(State.STATE_PAY_SUCCESS);  //  支付成功
			// 最后一笔预付款
			paymentRecord_yufukuan_last_one = (TradeRecord72)serializContext.findOne(paymentRecord_yufukuan_last_one);

			// 当时商家余额
			String then_merchant_balance = "0";
			if(paymentRecord_yewu_last_one != null){
				then_merchant_balance = paymentRecord_yewu_last_one.getShowMerchant_balance();
				if(paymentRecord_yufukuan_last_one != null){
					Long yewu_last_one_time = SunmingUtil.getlongTimeById(paymentRecord_yewu_last_one.getId());
					Long yufukuan_last_one_time = SunmingUtil.getlongTimeById(paymentRecord_yufukuan_last_one.getId());

					if(yufukuan_last_one_time > yewu_last_one_time){
						then_merchant_balance = paymentRecord_yufukuan_last_one.getShowMerchant_balance();
					}
				}
			}
			jsonObject.addProperty("then_merchant_balance", then_merchant_balance);

			jsonArray.add(jsonObject);
		}

		this.setStatusCode(StatusCode.ACCEPT_OK);
		this.setMessage("success");
		this.addField("startTime_str",SunmingUtil.longDateToStrDate_tall(startTime));
		this.addField("endTime_str",SunmingUtil.longDateToStrDate_tall(endTime));

		this.addField("orderPrice_all",orderPrice_all );
		this.addField("realPrice_all",realPrice_all );
		this.addField("aliPay_all",aliPay_all );
		this.addField("wechatPay_all",wechatPay_all );
		this.addField("redPay_all",redPay_all );

		this.addField("orderPrice_refund",orderPrice_refund );
		this.addField("aliPay_all_refund",aliPay_all_refund );
		this.addField("wechatPay_all_refund",wechatPay_all_refund );
		this.addField("otherPay_all_refund",otherPay_all_refund );

		this.setDataRoot(jsonArray);
		return SUCCESS;
	}
	@AcceptUrlMethod( name="商家交易汇总" )
	public String getAllMerchantCollect_huizhong() {
		String startTime_str = request.getParameter("start_time");
		String endTime_str = request.getParameter("end_time");
		
		Long startTime = SunmingUtil.dateStrToLongYMD_hms(startTime_str);
		Long endTime = SunmingUtil.dateStrToLongYMD_hms(endTime_str);
		CheckException.checkIsTure(startTime != null, "开始时间不正确");
		CheckException.checkIsTure(endTime != null, "结束时间不正确");
		CheckException.checkIsTure(startTime<endTime, "开始时间大于结束时间");



		TradeRecord72 tradeRecord72_find = new TradeRecord72();
		tradeRecord72_find.setBusinessIntId(BusinessIntIdConfig.businessIntId_trade);
		tradeRecord72_find = (TradeRecord72) SunmingUtil.setQueryWhere_time(tradeRecord72_find, startTime, endTime);

		// 付款成功
		tradeRecord72_find.setState(State.STATE_PAY_SUCCESS);
        Iterator<TradeRecord72> tradeRecord72List = serializContext.findIterable(tradeRecord72_find);

		Map<String,Long> huizhong= getHuizhong(tradeRecord72List);
		this.addField("orderPrice",huizhong.get("orderPrice"));
		this.addField("realPrice",huizhong.get("realPrice"));
		this.addField("aliPay",huizhong.get("aliPay"));
		this.addField("wechatPay",huizhong.get("wechatPay"));
		this.addField("redPay",huizhong.get("redPay"));

		// 已退款
		tradeRecord72_find.setState(State.STATE_REFUND_OK);
		tradeRecord72List = serializContext.findIterable(tradeRecord72_find);

		huizhong= getHuizhong(tradeRecord72List);
		this.addField("orderPrice_D1",huizhong.get("orderPrice"));
		this.addField("realPrice_D1",huizhong.get("realPrice"));
		this.addField("aliPay_D1",huizhong.get("aliPay"));
		this.addField("wechatPay_D1",huizhong.get("wechatPay"));
		this.addField("redPay_D1",huizhong.get("redPay"));


		// 交易成功
		tradeRecord72_find.setState(State.STATE_OK);
		tradeRecord72List = serializContext.findIterable(tradeRecord72_find);

		huizhong= getHuizhong(tradeRecord72List);
		this.addField("orderPrice_D2",huizhong.get("orderPrice"));
		this.addField("realPrice_D2",huizhong.get("realPrice"));
		this.addField("aliPay_D2",huizhong.get("aliPay"));
		this.addField("wechatPay_D2",huizhong.get("wechatPay"));
		this.addField("redPay_D2",huizhong.get("redPay"));



		this.setStatusCode(StatusCode.ACCEPT_OK);
		this.setMessage("success");
		return SUCCESS;
	}



	private Map<String,Long> getHuizhong(Iterator<TradeRecord72> tradeRecord72List){
		Long orderPrice = 0L;
		Long realPrice = 0L;
		Long aliPay = 0L;
		Long wechatPay = 0L;
		Long redPay = 0L;
		Long refund = 0L;

		while (tradeRecord72List.hasNext()){
            TradeRecord72 tradeRecord72_out =tradeRecord72List.next();
            
			if(!MyUtil.isValid(tradeRecord72_out.getUserId_merchant())){continue;}

			Long order_price = Math.abs(tradeRecord72_out.getShowPrice_fen_all());    // 每笔订单的金额
			Long thirdPayPrice_fen_all = tradeRecord72_out.getThirdPayPrice_fen_all(); // 每笔订单的实际支付
			Long wallet_amount_payment_fen = tradeRecord72_out.getWallet_amount_payment_fen(); // 每笔订单的红包支付

			orderPrice += order_price;  // 订单金额累加
			realPrice += thirdPayPrice_fen_all; // 实际支付累加
			// 红包支付
			if(wallet_amount_payment_fen != null && wallet_amount_payment_fen > 0L) {
				redPay += wallet_amount_payment_fen;
			}
			// 支付宝支付
			if (PayFinalVariable.pay_method_alipay.equals(tradeRecord72_out.getPay_method())) {
				aliPay += thirdPayPrice_fen_all;
			}
			// 微信支付
			if (PayFinalVariable.pay_method_weipay.equals(tradeRecord72_out.getPay_method())) {
				wechatPay += thirdPayPrice_fen_all;
			}
			// 退款订单
			if (State.STATE_REFUND_OK.equals(tradeRecord72_out.getState())) {
				refund += thirdPayPrice_fen_all;
			}

		}

		Map<String,Long> map = new ManagedMap<>();
		map.put("orderPrice",orderPrice);
		map.put("realPrice",realPrice);
		map.put("aliPay",aliPay);
		map.put("wechatPay",wechatPay);
		map.put("redPay",redPay);
		map.put("refund",refund);

		return map;
	}






	/**
	 * 孙M
	 * 获取所有商家的在一定时间内的预付款变动信息
	 * @return
	 */
	public String getAllMerchantBalanceByTime(){

		String startTime_str = this.getParameter("startTime_str");
		String endTime_str = this.getParameter("endTime_str");

		// 开始时间和结束时间 默认为这个月月初的00点00分00秒 和 明天早上的00点00分00秒
		Long start_time = SunmingUtil.getCurrentStartMonth(System.currentTimeMillis());
		Long end_time = DateUtil.getDayStartTime()+DateUtil.one_day;

		if(!MyUtil.isEmpty(startTime_str) || !MyUtil.isEmpty(endTime_str)){
			start_time = SunmingUtil.dateStrToLongYMD(startTime_str);
			end_time = SunmingUtil.dateStrToLongYMD(endTime_str);
			CheckException.checkIsTure(start_time != null ,"开始时间错误" );
			CheckException.checkIsTure(end_time != null ,"结束时间错误" );
		};

		Merchant72 merchant72_find = new Merchant72();
		merchant72_find.setUserGroupId(CashierAction.getMerchantUserGroutId());

		Iterator<Merchant72> merchant72Iterator = serializContext.findIterable(merchant72_find);

		Long price_all = 0L;         // 所有商家的 实际打款 总金额
		Long yufukuan_all = 0L;      // 所有商家的 预付款 总金额
		Long zhekoue_all = 0L;       // 所有商家的 折扣 总金额

		JsonArray jsonArray = new JsonArray();

		while (merchant72Iterator.hasNext()){
			Merchant72 merchant72_tmp = merchant72Iterator.next();

			TransferToMerchantRecord transferToMerchantRecord_find = new TransferToMerchantRecord();
			transferToMerchantRecord_find.setUser_huiyuan(merchant72_tmp);
			transferToMerchantRecord_find = (TransferToMerchantRecord)SunmingUtil.setQueryWhere_time(transferToMerchantRecord_find, start_time, end_time);
			transferToMerchantRecord_find.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_manual_transfer_to_merchant); // 06  实际打款
			transferToMerchantRecord_find.setState(State.STATE_PAY_SUCCESS);

			List<TransferToMerchantRecord>  transferToMerchantRecordList = serializContext.findAll(transferToMerchantRecord_find);

			Long merchant_price_all = 0L;         // 某个商家的 实际打款 总金额
			Long merchant_yufukuan_all = 0L;      // 某个商家的 预付款 总金额
			Long merchant_zhekoue_all = 0L;       // 某个商家的 折扣 总金额

			Long lastYufukuan = 0L;       		  // 某个商家的 最后一次 的预付款
			TransferToMerchantRecord transferToMerchantRecord_last = (TransferToMerchantRecord)serializContext.findOneInlist(transferToMerchantRecord_find);
			if(transferToMerchantRecord_last != null){
				lastYufukuan = transferToMerchantRecord_last.getYufukuan_price_fen();
			}

			for(TransferToMerchantRecord transferToMerchantRecord_tmp : transferToMerchantRecordList){
				merchant_price_all    +=  transferToMerchantRecord_tmp.getPrice_fen_all();
				merchant_yufukuan_all +=  transferToMerchantRecord_tmp.getYufukuan_price_fen();
				merchant_zhekoue_all  +=  transferToMerchantRecord_tmp.getYingxiao_price_fen();
			}


			price_all    += merchant_price_all;
			yufukuan_all += merchant_yufukuan_all;
			zhekoue_all  += merchant_zhekoue_all;

			JsonObject jsonObject = new JsonObject();
			jsonObject.addProperty("id",merchant72_tmp.getId());
			jsonObject.addProperty("bianhao",merchant72_tmp.getBianhao());
			jsonObject.addProperty("nickName",merchant72_tmp.getNickname());
			jsonObject.addProperty("userName",merchant72_tmp.getUsername());
			jsonObject.addProperty("balance",merchant72_tmp.getShowMerchant_balance());
			jsonObject.addProperty("all_dakuan",merchant_price_all);  // 打款总金额
			jsonObject.addProperty("lastYufukuan",lastYufukuan);  // 最后一次预付款
			jsonArray.add(jsonObject);
		}


		this.setStatusCode(StatusCode.ACCEPT_OK);
		this.setMessage("SUCCESS");
		this.addField("startTimeStr",SunmingUtil.longDateToStrDate_tall(start_time));
		this.addField("endTimeStr",SunmingUtil.longDateToStrDate_tall(end_time));
		this.addField("count",yufukuan_all);
		this.addField("topUpBalance",price_all);
		this.addField("discount",zhekoue_all);
		this.setDataRoot(jsonArray);
		return SUCCESS;
	}



	/**
	 * 孙M
	 * 获取一个商家的在时间段内的预付款变动信息
	 * @return
	 */
	public String getMerchantBalanceChangById(){

		String merchantId = request.getParameter("merchantId");
		CheckException.checkIsTure(MyUtil.isValid(merchantId),"商家id不正确");

		String startTime_str = request.getParameter("startTime_str");
		String endTime_str = request.getParameter("endTime_str");
		// 开始时间和结束时间 默认为这个月月初的00点00分00秒 和 明天早上的00点00分00秒
		Long start_time = SunmingUtil.getCurrentStartMonth(System.currentTimeMillis());
		Long end_time = DateUtil.getDayStartTime()+DateUtil.one_day;
		if(!SunmingUtil.strIsNull(startTime_str) || !SunmingUtil.strIsNull(endTime_str)){
			start_time = SunmingUtil.dateStrToLongYMD(startTime_str);
			end_time = SunmingUtil.dateStrToLongYMD(endTime_str);
			CheckException.checkIsTure(start_time != null ,"开始时间错误" );
			CheckException.checkIsTure(end_time != null ,"结束时间错误" );
		};


		TransferToMerchantRecord transferToMerchantRecord_find = new TransferToMerchantRecord();
		transferToMerchantRecord_find.setUserId_huiyuan(merchantId);
		transferToMerchantRecord_find = (TransferToMerchantRecord)SunmingUtil.setQueryWhere_time(transferToMerchantRecord_find, start_time, end_time);
		transferToMerchantRecord_find.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_manual_transfer_to_merchant); // 06  实际打款
		transferToMerchantRecord_find.setState(State.STATE_PAY_SUCCESS);

		List<TransferToMerchantRecord>  transferToMerchantRecordList = serializContext.findAll(transferToMerchantRecord_find);

		List<DuizhangEntity> duizhangEntityList = new LinkedList<>();

		for (TransferToMerchantRecord transferToMerchantRecord_tmp : transferToMerchantRecordList){

			DuizhangEntity duizhangEntity = new DuizhangEntity();
			duizhangEntity.setShowTime(transferToMerchantRecord_tmp.getShowTime());
			duizhangEntity.setAdminName(transferToMerchantRecord_tmp.getUserV2().getRealName());
			duizhangEntity.setMemo(transferToMerchantRecord_tmp.getBack_memo());
			duizhangEntity.setCount(SunmingUtil.longToStr_pianyi(transferToMerchantRecord_tmp.getPrice_fen_all(),100L));
			duizhangEntity.setBalance(SunmingUtil.longToStr_pianyi(transferToMerchantRecord_tmp.getYufukuan_price_fen(),100L));
			duizhangEntity.setDiscount(SunmingUtil.longToStr_pianyi(transferToMerchantRecord_tmp.getYingxiao_price_fen(),100L));
			duizhangEntityList.add(duizhangEntity);
		}

		Merchant72 merchant72_out = (Merchant72)serializContext.get(Merchant72.class, merchantId);
		request.setAttribute("startTimeStr",SunmingUtil.longDateToStrDate_tall(start_time));
		request.setAttribute("endTimeStr",SunmingUtil.longDateToStrDate_tall(end_time));

		request.setAttribute("bianHao",merchant72_out.getBianhao());
		request.setAttribute("nickName",merchant72_out.getNickname());
		request.setAttribute("userName",merchant72_out.getUsername());
		request.setAttribute("duizhangEntityList",duizhangEntityList);

		this.setSuccessResultValue("/v2/inc/showOneMerchantBalanceInfo.jsp");
		return SUCCESS;
	}


}
