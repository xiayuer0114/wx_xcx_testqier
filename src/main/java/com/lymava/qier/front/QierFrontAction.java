package com.lymava.qier.front;

import java.math.BigDecimal;
import java.util.Date;
import java.util.Iterator;

import org.bson.types.ObjectId;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.lymava.base.action.BaseAction;
import com.lymava.base.model.User;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.state.State;
import com.lymava.commons.state.StatusCode;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.JsonUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.Md5Util;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.nosql.util.PageSplit;
import com.lymava.qier.action.MerchantShowAction;
import com.lymava.qier.model.Cashier;
import com.lymava.qier.model.Merchant72;
import com.lymava.qier.model.MerchantRedEnvelope;
import com.lymava.qier.model.Product72;
import com.lymava.qier.model.TradeRecord72;
import com.lymava.qier.util.QierUtil;
import com.lymava.trade.base.model.BusinessIntIdConfig;
import com.lymava.trade.business.model.TradeRecord;
import com.lymava.trade.pay.model.MmanualRefundRecord;
import com.lymava.trade.pay.model.PaymentRecord;
import com.lymava.trade.pay.model.RefundRecord;
import com.lymava.userfront.util.FrontUtil;

/**
 * @author lymava
 *
 */
public class QierFrontAction extends BaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3501027897103185937L;
	
	public  User check_login_user() {
		User init_http_user = FrontUtil.init_http_user(request);
		CheckException.checkIsTure(init_http_user != null, "请先登录!",StatusCode.USER_INFO_TIMEOUT);
		return init_http_user;
	}
	
	public  Merchant72 check_merchant72_user(User user) {
		return null;
	}
	
	/**
	 * 
	 * 查询会员自己的基础信息	红包余额等
	 * 
	 * @return
	 */
	public String query_user_info() {
		
		User init_http_user = this.check_login_user();
		
		this.setStatusCode(StatusCode.ACCEPT_OK);
    	this.setMessage("红包发放成功!");
		return SUCCESS;
	}
	
	/**
	 * 
	 * 支付成功后抽取红包
	 * 
	 * @return
	 */
	public String open_red_package_after_pay_success() {
		/**
		 * 抽取红包这个操作是 根据订单 给这个订单的人抽取红包
		 * 	从某种意义上来说 为了扩展可以不校验用户
		 * 	暂时不校验 是否是自己给自己开红包
		 * 	以后说不定 分享给朋友，由朋友帮我开红包.
		 */
		User init_http_user = this.check_login_user();
		
		String payFlow 	=   this.getParameter("payFlow");
		
		String tradeRecord_id 	=   this.getParameter("tradeRecord_id");
		
		TradeRecord72 tradeRecord  = null; 
		
		if(MyUtil.isValid(tradeRecord_id)){
			tradeRecord = (TradeRecord72) serializContext.get(TradeRecord72.class, tradeRecord_id);
			CheckException.checkIsTure(tradeRecord != null, "亲，买单成功后才能抽红包!");
//			CheckException.checkIsTure(init_http_user.getId().equals(tradeRecord.getUserId_huiyuan()), "亲，买单后才能抽红包!");
		}else if(!MyUtil.isEmpty(payFlow)){
			TradeRecord72  tradeRecord_find = new TradeRecord72();
			
			tradeRecord_find.setPayFlow(payFlow);
//			tradeRecord_find.setUser_huiyuan(init_http_user);
			
			tradeRecord = (TradeRecord72)serializContext.get(tradeRecord_find);
		}
		
		CheckException.checkIsTure(tradeRecord != null, "亲，买单成功后才能抽红包!");
		
		PaymentRecord open_red_package = tradeRecord.open_red_package();
		
		CheckException.checkIsTure(open_red_package != null, "亲，煮熟的红包飞啦，下次努力!");
		
		this.addDataField("balance_id", open_red_package.getId());
		this.addDataField("red_pack_fen", open_red_package.getWallet_amount_payment_fen());
		this.addDataField("balance", open_red_package.getWallet_amount_balance_fen());
		 
		this.setStatusCode(StatusCode.ACCEPT_OK);
    	this.setMessage("红包发放成功!");
		return SUCCESS;
	}
	
	/**
	 *  领取定向红包
	 * @return
	 */
	public String receive_red_envelopes() {
		 
		User init_http_user = this.check_login_user();
		
		String merchantRedEnvelope_id 	=   this.getParameter("merchantRedEnvelope_id");
		
		String tradeRecord_id 	=   this.getParameter("tradeRecord_id");
 
		MerchantRedEnvelope merchantRedEnvelope = null;
		
		TradeRecord72 tradeRecord  = null; 
		
		if(MyUtil.isValid(tradeRecord_id)){
			tradeRecord = (TradeRecord72) serializContext.get(TradeRecord72.class, tradeRecord_id);
		} 
		
		if(MyUtil.isValid(merchantRedEnvelope_id)){
			merchantRedEnvelope = (MerchantRedEnvelope) serializContext.get(MerchantRedEnvelope.class, merchantRedEnvelope_id);
		} 
		
		CheckException.checkIsTure(tradeRecord != null, "亲，未找到您的订单!");
		
		CheckException.checkIsTure(
				State.STATE_PAY_SUCCESS.equals(tradeRecord.getState())
				||State.STATE_OK.equals(tradeRecord.getState())
				, "亲，买单成功后才能抽红包!");
		
		CheckException.checkIsTure(
				merchantRedEnvelope != null && 
				State.STATE_WAITE_CHANGE.equals(merchantRedEnvelope.getState()
						), "领取红包失败!");
		 
		MerchantRedEnvelope merchantRedEnvelope_update = new MerchantRedEnvelope();
		
		merchantRedEnvelope_update.setState(State.STATE_OK);
		merchantRedEnvelope_update.setUserId_huiyuan(init_http_user.getId());
		merchantRedEnvelope_update.setTradeRecord72_id(tradeRecord_id);
		merchantRedEnvelope_update.setUserId_merchant_lingqu(tradeRecord.getUserId_merchant());
		merchantRedEnvelope_update.setLingqu_time(System.currentTimeMillis());
		
		serializContext.updateObject(merchantRedEnvelope.getId(), merchantRedEnvelope_update);
		 
		this.setStatusCode(StatusCode.ACCEPT_OK);
    	this.setMessage("领取成功!");
		return SUCCESS;
	}
	
	public static final String tradeRecord_last_printed_time_key = "tradeRecord_last_printed_key";
	
	/**
	 * 记录打印日志
	 */
	public String tradeRecord_printed() {
		
		User user_login = this.check_login_user();
		
		String tradeRecord_id = request.getParameter("tradeRecord_id");
		
		TradeRecord72 tradeRecord_find = null;
		
		if(MyUtil.isValid(tradeRecord_id)){
			tradeRecord_find = (TradeRecord72) serializContext.get(TradeRecord72.class, tradeRecord_id);
		}
		
		CheckException.checkIsTure(tradeRecord_find != null, "未找到打印的记录!");
		
		if(tradeRecord_find.get_id_time_tmp() < System.currentTimeMillis()-10*DateUtil.one_minite){
			this.setMessage("订单打印记录成功!");
			return SUCCESS;
		}
		
		TradeRecord72 tradeRecord72_update = new TradeRecord72();
		tradeRecord72_update.setState_printed(State.STATE_OK);
		
		serializContext.updateObject(tradeRecord_id,tradeRecord72_update);
		 
    	this.setMessage("订单打印记录成功!");
		return SUCCESS;
	}
	/**
	 * 获取收银牌
	 */
	public String list_product_shouyinpai() {

		User user_login = this.check_login_user();
		 
		Product72 product_shouyinpai_find = new Product72();
		
		product_shouyinpai_find.setUserId_merchant(user_login.getId());
		product_shouyinpai_find.setRootPubConlumnId(MerchantShowAction.getShouyinpai_pubConlumnId());
		product_shouyinpai_find.setState(Product72.state_nomal);
		product_shouyinpai_find.setShenghe(Product72.shenghe_tongguo);
		
		Iterator<Product72> product_shouyinpai_ite = serializContext.findIterable(product_shouyinpai_find,pageSplit);
		
		JsonArray jsonArray = new JsonArray();
		
		while(product_shouyinpai_ite.hasNext()){
			
			Product72 product_shouyinpai_next = product_shouyinpai_ite.next();
			
			JsonObject jsonObject = new JsonObject();
			
			JsonUtil.addProperty(jsonObject, "id", product_shouyinpai_next.getId());
			JsonUtil.addProperty(jsonObject, "product_name", product_shouyinpai_next.getName());
			
			jsonArray.add(jsonObject);
		}
		 
		this.setDataRoot(jsonArray);
		this.setStatusCode(StatusCode.ACCEPT_OK);
		return SUCCESS;
	}
	/**
	 * 获取未打印的交易记录
	 */
	public String list_print_tradeRecord() {

		User user_login = this.check_login_user();
		
		Merchant72 merchant72 = QierUtil.getMerchant72User(user_login);
		CheckException.checkIsTure(merchant72 != null, "商户不存在!");
		
		TradeRecord72 tradeRecord_find = new TradeRecord72();
		
//		//不是收银员
//		if(!(user_login instanceof Cashier)){
//			tradeRecord_find.setUser_merchant(user_login);
//		}
//		//是收银员
//		if(user_login instanceof Cashier){
//			
//			String topUserId = user_login.getTopUserId();
//			
//			if(MyUtil.isValid(topUserId)){
//				tradeRecord_find.setUserId_merchant(topUserId);
//			}else{
//				tradeRecord_find.setUserId_merchant(topUserId);
//			} 
//			
//			tradeRecord_find.setUserId_merchant(merchant72);
//		} 
		
		tradeRecord_find.setUser_merchant(merchant72);

		PageSplit pageSplit = this.getPageSplit();
		pageSplit.setPageSize(1);
		
		String state_str = this.getRequestParameter("state");
		
		String tradeRecord_id = this.getRequestParameter("tradeRecord_id");
		//订单状态 
		Integer state = MathUtil.parseIntegerNull(state_str);
		
		tradeRecord_find.setState(state);
		//收银牌号
		String[] product_id_array = request.getParameterValues("product_id");
		
		if(product_id_array != null) {
			for (String product_id_tmp : product_id_array) {
				 tradeRecord_find.addCommand(MongoCommand.in, "productId", product_id_tmp);
			}
		}

		if(MyUtil.isValid(tradeRecord_id)){
			tradeRecord_find.setId(tradeRecord_id); 
		}else{
			/**
			 * 10分钟以内的最新订单
			 */
			ObjectId startTimeObj = new ObjectId(new Date(System.currentTimeMillis()-10*DateUtil.one_minite));
			tradeRecord_find.addCommand(MongoCommand.dayu, "id", startTimeObj);
			
			tradeRecord_find.addCommand(MongoCommand.budengyu, "state_printed", State.STATE_OK);
		}
		
		//业务订单
		tradeRecord_find.setBusinessIntId(BusinessIntIdConfig.businessIntId_trade);
		
		
		Iterator<TradeRecord> findIterable = serializContext.findIterable(tradeRecord_find,pageSplit);
		
		JsonArray jsonArray = new JsonArray();
		
		while(findIterable.hasNext()){
			
			TradeRecord tradeRecord_next = findIterable.next();
			
			JsonObject jsonObject = new JsonObject();
			
			JsonUtil.addProperty(jsonObject, "id", tradeRecord_next.getId());
			JsonUtil.addProperty(jsonObject, "productId", tradeRecord_next.getProductId());
			JsonUtil.addProperty(jsonObject, "product_name", tradeRecord_next.getProduct().getName());
			
			JsonUtil.addProperty(jsonObject, "userId_merchant", tradeRecord_next.getUserId_merchant());
			JsonUtil.addProperty(jsonObject, "userId_merchant_name", tradeRecord_next.getUser_merchant().getNickname());
			
			JsonUtil.addProperty(jsonObject, "price_fen", tradeRecord_next.getPrice_fen());
			JsonUtil.addProperty(jsonObject, "price_fen_all", tradeRecord_next.getShowPrice_fen_all());
			JsonUtil.addProperty(jsonObject, "quantity", tradeRecord_next.getQuantity());
			
			JsonUtil.addProperty(jsonObject, "payTime", tradeRecord_next.getShowPayTime());
			JsonUtil.addProperty(jsonObject, "requestFlow", tradeRecord_next.getRequestFlow());
			JsonUtil.addProperty(jsonObject, "payFlow", tradeRecord_next.getShowPayFlow());
			JsonUtil.addProperty(jsonObject, "showPay_method", tradeRecord_next.getShowPay_method());
			
			String showState = tradeRecord_next.getShowState();
			
			JsonUtil.addProperty(jsonObject, "showState", showState);
			JsonUtil.addProperty(jsonObject, "state", tradeRecord_next.getState());
			JsonUtil.addProperty(jsonObject, "showTime", tradeRecord_next.getShowTime());
			
			String memo = tradeRecord_next.getMemo();
			if(memo == null){memo = "";}
			jsonObject.addProperty("memo", memo); 
			
			Long amount_payment = tradeRecord_next.getWallet_amount_payment_fen();
			if(amount_payment == null){amount_payment = 0l;} 
			JsonUtil.addProperty(jsonObject, "amount_payment", amount_payment);
			
			
			//查询到退款记录,计算所有的退款金额，然后通过转换成json带回
			Long had_refund_amout_fen_all = tradeRecord_next.getHad_refund_amout_fen();
			JsonUtil.addProperty(jsonObject, "had_refund_amout_fen_all", had_refund_amout_fen_all);
			
			//合计要去掉退款金额部分
			JsonUtil.addProperty(jsonObject, "payPrice_fen_all", tradeRecord_next.getPayPrice_fen_all()-had_refund_amout_fen_all);

			
			
			
			jsonArray.add(jsonObject);
		}
		 
		this.setDataRoot(jsonArray);
		this.setStatusCode(StatusCode.ACCEPT_OK);
		this.setMessage("查询成功");
		return SUCCESS;
	}
	/**
     * 查询订单
     * @return
     */
    public String query_tradeRecord(){
    	
		String payFlow 	=   this.getParameter("payFlow");
		
		String tradeRecord_id 	=   this.getParameter("tradeRecord_id");
		
		TradeRecord72 tradeRecord  = null; 
		
		if(MyUtil.isValid(tradeRecord_id)){
			tradeRecord = (TradeRecord72) serializContext.get(TradeRecord72.class, tradeRecord_id);
		}else if(!MyUtil.isEmpty(payFlow)){
			TradeRecord72  tradeRecord_find = new TradeRecord72();
			
			if(MyUtil.isValid(payFlow)){
				tradeRecord_find.setId(payFlow);
			}else {
				tradeRecord_find.setPayFlow(payFlow);
			}
			tradeRecord = (TradeRecord72)serializContext.get(tradeRecord_find);
		}
    	
		CheckException.checkIsTure(tradeRecord != null, "支付订单不存在!");
		
		if(State.STATE_WAITE_PAY.equals(tradeRecord.getState())) {
			tradeRecord.make_sure_paystate();
		}
		
		
		this.addDataField("id", tradeRecord.getId());
		this.addDataField("productId", tradeRecord.getProductId());
		this.addDataField("product_name", tradeRecord.getProduct().getName());
		
		this.addDataField("userId_merchant", tradeRecord.getUserId_merchant());
		this.addDataField("userId_merchant_name", tradeRecord.getUser_merchant().getNickname());
		
		this.addDataField("price_fen", tradeRecord.getPrice_fen());
		this.addDataField("price_fen_all", tradeRecord.getPrice_fen_all());
		this.addDataField("quantity", tradeRecord.getQuantity());
		
		this.addDataField("payTime", tradeRecord.getShowPayTime());
		this.addDataField("payFlow", tradeRecord.getShowPayFlow());
		this.addDataField("showPay_method", tradeRecord.getShowPay_method());
		
		this.addDataField("showState", tradeRecord.getShowState());
		this.addDataField("showTime", tradeRecord.getShowTime());
		
		CheckException.checkIsTure(State.STATE_PAY_SUCCESS.equals(tradeRecord.getState()), "订单支付中,请稍后!");
    	
    	this.setStatusCode(StatusCode.ACCEPT_OK);
		this.setMessage("查询成功");
		return SUCCESS;
    }

	/**
	 * 退款  商家端 打印后面的那个按钮
	 * 孙M  6.8
	 * @return
	 */
	public String refundById(){

		User user = check_login_user();

		// 订单id 和 退款备注
		String tradeRecord_id = this.getParameter("tradeRecord_id");
		String refund_memo = this.getParameter("refund_memo");
		String pay_password = this.getParameter("pay_password");
		String refundAmount_str = this.getParameter("refundAmount");
		Double refundAmount_yuan = MathUtil.parseDouble(refundAmount_str);
		
		BigDecimal refundAmount_bigDecimal = MathUtil.multiply(refundAmount_yuan, 100);
		
		Long refundAmount_fen = refundAmount_bigDecimal.longValue();

		CheckException.checkIsTure(MyUtil.isValid(tradeRecord_id),"退款订单不正确");
		
		CheckException.checkIsTure(refundAmount_fen > 0,"退款金额必须大于0!");
		
		TradeRecord72 tradeRecord72 = (TradeRecord72)serializContext.get(TradeRecord72.class,tradeRecord_id);

		CheckException.checkIsTure(tradeRecord72 != null,"退款订单不存在!");
		
		CheckException.checkIsTure(user.getId().equals(tradeRecord72.getUserId_merchant()),"退款订单不存在!");
		 
		CheckException.checkIsTure(refundAmount_fen <= tradeRecord72.getShowPrice_fen_all(),"退款金额必须小于订单总额!");
		
		Merchant72 user_merchant = tradeRecord72.getUser_merchant();
		
		if(Merchant72.payPwdState_STATE_OK.equals(user_merchant.getPayPwdState())) {
			
			CheckException.checkNotEmpty(pay_password, "请填写支付密码!");
			
			String payPass = user.getPayPass();
			
			CheckException.checkNotEmpty(payPass, "您还未设置支付密码!");
			
			CheckException.checkIsTure(payPass.equals(pay_password), "支付密码有误!");
		}

		String requestFlow = this.getParameter("requestFlow");
		
	    CheckException.checkIsTure(refundAmount_bigDecimal.doubleValue() == refundAmount_fen, "退款精度最高0.01!");
	     
	    Long pianyi =  refundAmount_fen*User.pianyiFen;
		
		CheckException.checkIsTure(State.STATE_OK.equals(tradeRecord72.getState()) || State.STATE_PAY_SUCCESS.equals(tradeRecord72.getState()), "该比订单不能退款！");
		
		MmanualRefundRecord refundRecord = new MmanualRefundRecord();
		
		refundRecord.setPrice_pianyi_all(pianyi);
		refundRecord.setMemo(refund_memo);
		refundRecord.setRequestFlow(requestFlow);
		refundRecord.setIp(MyUtil.getIpAddr(request));
		refundRecord.setPay_method(tradeRecord72.getPay_method());
		refundRecord.setPaymentRecord_id(tradeRecord72.getId());
		refundRecord.setMemo(refund_memo);
		
		Integer state_refund = tradeRecord72.refund(refundRecord);
		
		if(State.STATE_OK.equals(state_refund)) {
			 
			this.addField("state_refund",tradeRecord72.getState());
			this.setStatusCode(StatusCode.ACCEPT_OK);
			this.setMessage("退款成功！");
		}else {
			this.setStatusCode(StatusCode.ACCEPT_FALSE);
			this.setMessage("退款失败！");
		}
		return SUCCESS;
	}


}
