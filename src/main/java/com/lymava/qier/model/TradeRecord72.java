package com.lymava.qier.model;

import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.bson.types.ObjectId;

import com.google.gson.JsonObject;
import com.lymava.base.model.SimpleDbCacheContent;
import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.pay.PayFinalVariable;
import com.lymava.commons.state.State;
import com.lymava.commons.state.StatusCode;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.HttpUtil;
import com.lymava.commons.util.JsonUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.commons.util.ThreadPoolContext;
import com.lymava.nosql.context.SerializContext;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.qier.business.BusinessIntIdConfigQier;
import com.lymava.qier.business.businessRecord.MerchantRedEnvelopePayRecord;
import com.lymava.trade.base.context.BusinessContext;
import com.lymava.trade.base.model.Business;
import com.lymava.trade.base.model.BusinessIntIdConfig;
import com.lymava.trade.business.model.Product;
import com.lymava.trade.business.model.TradeRecord;
import com.lymava.trade.pay.model.PaymentRecord;
import com.lymava.trade.pay.model.PaymentRecordOperationRecord;
import com.lymava.trade.pay.model.RefundRecord;
import com.lymava.wechat.gongzhonghao.Gongzonghao;
import com.lymava.wechat.gongzhonghao.GongzonghaoContent;
import com.lymava.wechat.gongzhonghao.MessageTemplateField;
import com.lymava.wechat.gongzhonghao.SubscribeUser;
import com.mongodb.BasicDBList;

public class TradeRecord72  extends TradeRecord{

	/**
	 * 
	 */
	private static final long serialVersionUID = -3384475485627304919L;
	/**
	 * 我们在商家预购的额度剩余	全偏移
	 */
	private Long merchant_balance;
	/**
	 * 用户的代金卷
	 */
	private UserVoucher userVoucher;
	/**
	 * 用户的代金卷编号
	 */
	private String userVoucher_id;
	/**
	 * 收银员
	 */
	private Cashier cashier;
	/**
	 * 收银员 系统编号
	 */
	private String cashier_id;
	/**
	 * 会员缓存
	 */
	private User72 user72;
	/**
	 * 定向红包
	 */
	private MerchantRedEnvelope merchantRedEnvelope;
	/**
	 * 定向红包系统编号
	 */
	private String merchantRedEnvelope_id;
	
	/**
	 * 餐位费
	 */
	private Long canweifei_fen_all;
	/**
	 * 72 用户
	 */
	@Override
	public User72 getUser_huiyuan() {
		if (user72 == null && MyUtil.isValid(this.getUserId_huiyuan())) {
			user72 = (User72) ContextUtil.getSerializContext().get(User72.class, this.getUserId_huiyuan());
		}
		return user72;
	}
	/**
	 * 是否已经打印
	 * 
	 * {@link State#STATE_OK}	已经打印
	 * {@link State#STATE_FALSE}	未打印
	 * 
	 */
	private Integer state_printed;
	
	public MerchantRedEnvelope getMerchantRedEnvelope() {
		if (merchantRedEnvelope == null && MyUtil.isValid(this.merchantRedEnvelope_id)) {
			merchantRedEnvelope = (MerchantRedEnvelope) ContextUtil.getSerializContext().get(MerchantRedEnvelope.class, merchantRedEnvelope_id);
		}
		return merchantRedEnvelope;
	}
	public void setMerchantRedEnvelope(MerchantRedEnvelope merchantRedEnvelope) {
		if(merchantRedEnvelope != null) {
			merchantRedEnvelope_id = merchantRedEnvelope.getId();
		}
		this.merchantRedEnvelope = merchantRedEnvelope;
	}
	public String getMerchantRedEnvelope_id() {
		return merchantRedEnvelope_id;
	}
	public void setMerchantRedEnvelope_id(String merchantRedEnvelope_id) {
		this.merchantRedEnvelope_id = merchantRedEnvelope_id;
	}
	public Integer getState_printed() {
		return state_printed;
	}
	public void setState_printed(Integer state_printed) {
		this.state_printed = state_printed;
	}
	public Long getCanweifei_fen_all() {
		return canweifei_fen_all;
	}
	public void setCanweifei_fen_all(Long canweifei_fen_all) {
		this.canweifei_fen_all = canweifei_fen_all;
	}
	/**
	 * 获取支付总金额
	 * @return
	 */
	@Override
	public Long getCountPayPrice_fen_all(){
		
		Long amount_payment_tmp = this.getAmount_payment();
		if(amount_payment_tmp == null){ amount_payment_tmp = 0l;}
		
		Long userVoucher_dikou = 0l;
		
		UserVoucher userVoucher_tmp = this.getUserVoucher();
		
		if(userVoucher_tmp != null){
			userVoucher_dikou = userVoucher_tmp.getVoucherValue_fen();
		}
		if(userVoucher_dikou == null){
			userVoucher_dikou = 0l;
		}
		
		Long price_fen_all = this.getPrice_fen_all();
		
		Long countPayPrice_fen_all = -(price_fen_all+userVoucher_dikou);
		
		return countPayPrice_fen_all;
	}
	
	@Override
	public void parseTradeRecord(Map parameterMap) {
		
			String cashier_id = HttpUtil.getParemater(parameterMap, "cashier_id");
			
			String userVoucher_id = HttpUtil.getParemater(parameterMap, "userVoucher_id");
			
			Cashier cashier = null;
			UserVoucher userVoucher = null;
			
			if(MyUtil.isValid(cashier_id)){
				cashier = (Cashier) ContextUtil.getSerializContext().get(Cashier.class, cashier_id);
			}
			if(MyUtil.isValid(userVoucher_id)){
				userVoucher = (UserVoucher) ContextUtil.getSerializContext().get(UserVoucher.class, userVoucher_id);
			}
			if(cashier != null){
				this.setCashier_id(cashier.getId());
			}
			if(userVoucher != null){
				this.setUserVoucher(userVoucher);
				this.check_userVoucher_can_use();
			}
	}
	
	/**
	 * 比如一笔订单 
	 * 	总金额	500 元	红包抵扣100元	微信支付300元 代金卷抵扣100元
	 * 		这时候有两种情况
	 * 			1，代金卷是平台自己发的 	代金卷的成本由我们平台自己出		那么回收总金额 就是500
	 * 			2, 代金卷是平台自己发的 代金卷的成本由商家出			那么回收总金额 就是400
	 * @return	获取我们实际收回的款项金额	单位分
	 */
	public Long getReclaimPrice_fen(){
		
		
		UserVoucher userVoucher_tmp = this.getUserVoucher();
		 
		
		String userId_merchant_tmp = this.getUserId_merchant();
		
		Long showPrice_fen_all = this.getShowPrice_fen_all();
		//如果使用了殆尽卷 并且 有商家爱 并且 是商家自己的代金卷  那么减少额度的时候就不减少我们的。
		if(
				userVoucher_tmp != null 
				&& userId_merchant_tmp != null 
				&& userId_merchant_tmp.equals(userVoucher_tmp.getUserId_merchant())
				){
			
			Long userVoucher_dikou_fen = userVoucher_tmp.getVoucherValue_fen();
			
			showPrice_fen_all = showPrice_fen_all-userVoucher_dikou_fen;
		}
		
		return showPrice_fen_all;
	}
	@Override
	public Long getPaymentRecordAvailableFen() {
		
		MerchantRedEnvelope merchantRedEnvelope_tmp = this.getMerchantRedEnvelope();
		
		if(merchantRedEnvelope_tmp == null) {
			
//			MerchantRedEnvelope merchantRedEnvelope_find = new MerchantRedEnvelope();
//			
//			merchantRedEnvelope_find.setState(State.STATE_OK);
//			merchantRedEnvelope_find.setUserId_huiyuan(this.getUserId_huiyuan());
//			merchantRedEnvelope_find.setUserId_merchant(this.getUserId_merchant());
//				
//			merchantRedEnvelope_find.addCommand(MongoCommand.dayuAndDengyu, "expiry_time", System.currentTimeMillis());
//				
//			merchantRedEnvelope_tmp = (MerchantRedEnvelope)ContextUtil.getSerializContext().get(merchantRedEnvelope_find);
//			
//			this.setMerchantRedEnvelope(merchantRedEnvelope_tmp);
		}
		
			
		if(merchantRedEnvelope_tmp != null) {
			return merchantRedEnvelope_tmp.getAmountFen();
		}
		return 0l;
	}
	
	@Override
	public  void parsePaymentRecord(Map parameterMap){
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		String merchantRedEnvelope_id = HttpUtil.getParemater(parameterMap,"merchantRedEnvelope_id");
		/**
		 * 使用了定向红包
		 */
		if(MyUtil.isValid(merchantRedEnvelope_id)) {
			
			MerchantRedEnvelope merchantRedEnvelope = (MerchantRedEnvelope) serializContext.get(MerchantRedEnvelope.class, merchantRedEnvelope_id);
			
			CheckException.checkIsTure(merchantRedEnvelope != null, "定向红包不存在!");
			//检查定向红包
			merchantRedEnvelope.check_can_use(this);
			
			this.setMerchantRedEnvelope(merchantRedEnvelope);
			
			TradeRecord72 tradeRecord72_update = new TradeRecord72();
			tradeRecord72_update.setMerchantRedEnvelope_id(merchantRedEnvelope_id);
			
			serializContext.updateObject(this.getId(), tradeRecord72_update);
		}
		
		UserVoucher userVoucher_tmp = this.getUserVoucher();
		
		Long price_fen_all = this.getPrice_fen_all();
		
		Long voucher_amount = 0l;
		
		//计算出代金卷金额
		if(userVoucher_tmp != null){
			voucher_amount = userVoucher_tmp.getVoucherValue_fen();
		}
		
		User user_huiyuan_tmp = this.getUser_huiyuan();
		
		Boolean wallet_pay = Boolean.TRUE.toString().equals(HttpUtil.getParemater(parameterMap,"wallet_pay"));
		
		//当前可用钱包余额 分
		Long availableBalance_fen = user_huiyuan_tmp.getAvailableBalanceFen();
		
		Long paymentRecordAvailableFen = this.getPaymentRecordAvailableFen();
			
		if(paymentRecordAvailableFen != null) {
			availableBalance_fen = availableBalance_fen+paymentRecordAvailableFen;
		}
		
		//拆分钱包支付的金额
		if(Boolean.TRUE.equals(wallet_pay) && availableBalance_fen > 0){
			//红包足够
			if(price_fen_all+availableBalance_fen+voucher_amount > 0){
				this.setInWallet_amount_payment_fen(-(price_fen_all+voucher_amount));
			}else{
				this.setInWallet_amount_payment_fen(availableBalance_fen);
			}
		}
	}
	
	public void check_userVoucher_can_use(){
		
		Long price_fen_all = this.getShowPrice_fen_all();
		
		UserVoucher userVoucher_tmp = this.getUserVoucher();
		
		if(userVoucher_tmp == null){
			return;
		}
		
		Voucher voucher = userVoucher_tmp.getVoucher();
		
		Long voucherValue = userVoucher_tmp.getVoucherValue_fen();
		 
		Long low_consumption_amount = userVoucher_tmp.getLow_consumption_amount();
		
		CheckException.checkIsTure(price_fen_all >= low_consumption_amount*100, "订单总额不足以使用此代金卷！");
		
//		System.out.println(DateUtil.getSdfFull().format(new Date(voucher.getStopTime())));
		
		CheckException.checkIsTure(System.currentTimeMillis() <= voucher.getStopTime(), "代金卷已经失效!");
		
		CheckException.checkIsTure(State.STATE_OK.equals(userVoucher_tmp.getUseState()), "代金卷已经使用！");
	}
	
	public Cashier getCashier() {
		if (cashier == null && MyUtil.isValid(this.cashier_id)) {
			cashier = (Cashier) ContextUtil.getSerializContext().get(Cashier.class, cashier_id);
		}
		return cashier;
	}
	public void setCashier(Cashier cashier) {
		if( cashier != null){
			cashier_id = cashier.getId();
		}
		this.cashier = cashier;
	}
	public String getCashier_id() {
		return cashier_id;
	}
	public void setCashier_id(String cashier_id) {
		this.cashier_id = cashier_id;
	}
	public String getUserVoucher_id() {
		return userVoucher_id;
	}
	public void setUserVoucher_id(String userVoucher_id) {
		this.userVoucher_id = userVoucher_id;
	}
	public UserVoucher getUserVoucher() {
		if (userVoucher == null && MyUtil.isValid(this.userVoucher_id)) {
			userVoucher = (UserVoucher) ContextUtil.getSerializContext().get(UserVoucher.class, userVoucher_id);
		}
		return userVoucher;
	}
	public void setUserVoucher(UserVoucher userVoucher) {
		if( userVoucher != null){
			userVoucher_id = userVoucher.getId();
		}
		this.userVoucher = userVoucher;
	}
	@Override
	public void check_can_buy() throws CheckException {
		
		this.check_amount_payment();
		
		this.check_merchant_balance();
	}
	/**
	 * 检查钱包余额
	 */
	public void check_amount_payment(){
		User user_huiyuan_tmp = this.getUser_huiyuan();
		Long user_huiyuan_availableBalanceFen = user_huiyuan_tmp.getAvailableBalanceFen();
		
		Long amount_payment_tmp = this.getAmount_payment();
		if(amount_payment_tmp == null){ amount_payment_tmp = 0l; }
		
		Long paymentRecordAvailableFen = this.getPaymentRecordAvailableFen();
		if(paymentRecordAvailableFen != null) {
			user_huiyuan_availableBalanceFen = user_huiyuan_availableBalanceFen+paymentRecordAvailableFen;
		}
		
		CheckException.checkIsTure(user_huiyuan_availableBalanceFen >= amount_payment_tmp, "余额不够钱包支付失败!");
	}
	/**
	 * 检查商户预付款
	 */
	public void check_merchant_balance(){
		Merchant72 user_merchant_tmp = this.getUser_merchant();
		
		Long price_fen_all = this.getShowPrice_fen_all(); 
		
		user_merchant_tmp.checkMerchantBalanceFen(price_fen_all);
	}
	
	public Long getMerchant_balance() {
		return merchant_balance;
	}
	public void setMerchant_balance(Long merchant_balance) {
		this.merchant_balance = merchant_balance;
	}
	
	private Merchant72 merchant72;
	
	public Merchant72 getUser_merchant() {
		if (merchant72 == null && MyUtil.isValid(this.getUserId_merchant())) {
			merchant72 = (Merchant72) ContextUtil.getSerializContext().get(Merchant72.class, this.getUserId_merchant());
		}
		return merchant72;
	}
	/**
	 * 显示用户余额 单位元
	 * @return
	 */
	public String getShowMerchant_balance() {
		return Double.toString(MathUtil.divide(this.getMerchant_balance(),User.pianyiYuan).doubleValue());
	}
	/**
	 * 显示用户余额 单位分
	 * @return
	 */
	public Long getMerchant_balanceFen() {
		return this.getMerchant_balance()/User.pianyiFen;
	}
	
	public String getCurrentDayStr(){
		
		Merchant72 user_merchant_tmp = (Merchant72) this.getUser_merchant();
		//商户不存在
		if(user_merchant_tmp == null){ 
			return DateUtil.getCurrentDayStr();
		}
		if(this.get_id_time_tmp() != null) {
			return user_merchant_tmp.getCurrentDayStr(this.get_id_time_tmp());
		}
		return user_merchant_tmp.getCurrentDayStr();
	}
	
	public String get_merchant_today_cash_total_key(){
		return this.getUserId_merchant()+"_"+this.getCurrentDayStr()+"_"+"merchant_today_cash_total_key";
	}
	public String get_merchant_today_cash_total_key_weixin(){
		return this.getUserId_merchant()+"_"+this.getCurrentDayStr()+"_"+"merchant_today_cash_total_key_weixin";
	}
	public String get_merchant_today_cash_total_key_alipay(){
		return this.getUserId_merchant()+"_"+this.getCurrentDayStr()+"_"+"merchant_today_cash_total_key_alipay";
	}
	public String get_merchant_today_cash_total_key_qianbao(){
		return this.getUserId_merchant()+"_"+this.getCurrentDayStr()+"_"+"merchant_today_cash_total_key_qianbao";
	}
	public String get_merchant_today_refund_total_key(){
		return this.getUserId_merchant()+"_"+this.getCurrentDayStr()+"_"+"merchant_today_refund_total_key";
	}
	/**
	 * 到第三方平台的支付总金额	
	 * 	去除代金卷，取出了红包抵扣等
	 * 	金额为正数	单位元
	 * @return
	 */
	public Double getThirdPayPrice_yuan(){
		
		Double thirdPayPrice_yuan = null;
		
		 Long thirdPayPrice_fen_all = this.getThirdPayPrice_fen_all();
		 
		 if(thirdPayPrice_fen_all != null) {
			 thirdPayPrice_yuan = MathUtil.divide(thirdPayPrice_fen_all, 100).doubleValue();
		 }
		
		return thirdPayPrice_yuan;
	}
	
	/**
	 * 给前端显示的支付详情
	 * @return
	 */
	public String getShowPayInfo() {
		
		String showPayInfo = null;
		
		Long wallet_amount_payment_fen = this.getWallet_amount_payment_fen();

		if(wallet_amount_payment_fen == null || wallet_amount_payment_fen == 0 || PayFinalVariable.pay_method_balance.equals(this.getPay_method())) {
			showPayInfo = this.getShowPay_method();
			return showPayInfo;
		}
		
		showPayInfo = this.getShowPay_method()+"("+this.getThirdPayPrice_yuan()+")元 ";
		
		showPayInfo += ",红包支付("+this.getWallet_amount_payment_yuan()+")";
		
		return showPayInfo;
	}
	/**
	 * 交易记录统计
	 */
	public void trade_record_tongji(){
		//这里 如果是负数 那么 商家的统计就是增加 如果是正数 商家的统计酒减少
		/**
		 * 比如订单金额 为-100 那么商家的统计就要加100
		 */
		 Long price_fen_all = this.getPrice_fen_all()*-1; 
		 Long thirdPayPrice_fen_all = this.getThirdPayPrice_fen_all();
		 Long wallet_amount_payment_fen = this.getWallet_amount_payment_fen();
		 
		 String merchant_today_cash_total_key = this.get_merchant_today_cash_total_key();
		
		 Long today_total_fen  = (Long) SimpleDbCacheContent.get_object(merchant_today_cash_total_key);
		 if(today_total_fen == null){ today_total_fen = 0l;}
		 today_total_fen += price_fen_all;
		 SimpleDbCacheContent.cache_object(merchant_today_cash_total_key, today_total_fen);
		 
		 /**
		  * 微信支付统计
		  */
		 if(PayFinalVariable.pay_method_weipay.equals(this.getPay_method())){
			 
			 String merchant_today_cash_total_key_weixin = this.get_merchant_today_cash_total_key_weixin();
			 
			 Long today_total_fen_weixin  = (Long) SimpleDbCacheContent.get_object(merchant_today_cash_total_key_weixin);
			 if(today_total_fen_weixin == null){ today_total_fen_weixin = 0l;}
			 
			 today_total_fen_weixin += thirdPayPrice_fen_all;
			 SimpleDbCacheContent.cache_object(merchant_today_cash_total_key_weixin, today_total_fen_weixin);
		 }
		 /**
		  * 支付宝统计
		  */
		 if(PayFinalVariable.pay_method_alipay.equals(this.getPay_method())){
			 
			 String merchant_today_cash_total_key_alipay = this.get_merchant_today_cash_total_key_alipay();
			 
			 Long today_total_fen_alipay  = (Long) SimpleDbCacheContent.get_object(merchant_today_cash_total_key_alipay);
			 if(today_total_fen_alipay == null){ today_total_fen_alipay = 0l;}
			 
			 today_total_fen_alipay += thirdPayPrice_fen_all;
			 SimpleDbCacheContent.cache_object(merchant_today_cash_total_key_alipay, today_total_fen_alipay);
		 }
		 /**
		  * 红包统计
		  */
		 if(this.getAmount_payment() != null && this.getAmount_payment() > 0){
			 String merchant_today_cash_total_key_qianbao = this.get_merchant_today_cash_total_key_qianbao();
			 
			 Long today_total_fen_balance  =  (Long) SimpleDbCacheContent.get_object(merchant_today_cash_total_key_qianbao);
			 if(today_total_fen_balance == null){ today_total_fen_balance = 0l;}
			 
			 today_total_fen_balance += wallet_amount_payment_fen;
			 SimpleDbCacheContent.cache_object(merchant_today_cash_total_key_qianbao, today_total_fen_balance);
		 }
	}
	
	/**
	 * 是否能退款
	 * @return	能退款返回true 不能返回false
	 */
	@Override
	public boolean check_can_refund(RefundRecord refundRecord) {
		
		//消费后抽取的通用红包的记录
		List<PaymentRecordOperationRecord> paymentRecord_list = this.getRedenvelopePaymentRecordList();
		
		//领取定向红包的总金额
		Long sum_price_fen_all = 0l;
		//所有红包
		for (PaymentRecordOperationRecord paymentRecordOperationRecord : paymentRecord_list) {
			sum_price_fen_all += paymentRecordOperationRecord.getShowPrice_fen_all();
		}
		//当前订单退款的总金额
		Long refund_showPrice_fen_all = refundRecord.getShowPrice_fen_all();
		//主订单的总金额
		Long order_showPrice_fen_all = this.getShowPrice_fen_all();
		
		//实际应退的红包金额
		Long current_need_refund_fen = sum_price_fen_all*refund_showPrice_fen_all/order_showPrice_fen_all;
		
		/**
		 * 这个如果当前红包余额不足以退款 则不能退款
		 */
		
		
		CheckException.checkIsTure(State.STATE_PAY_SUCCESS.equals(this.getState()) || State.STATE_OK.equals(this.getState()), "订单状态异常不能退款!");
		
		return State.STATE_PAY_SUCCESS.equals(this.getState()) || State.STATE_OK.equals(this.getState());
	}
	
	@Override
	public Integer refund(RefundRecord refundRecord) {
		
		Integer refund = super.refund(refundRecord);
		
		if(State.STATE_OK.equals(refund)) {
			
			Long price_pianyi_all_refund_all_tmp = refundRecord.getPrice_fen_all_refund_all_tmp();
			
			Merchant72 user_merchant2 = this.getUser_merchant();
			user_merchant2.shareMerchant_balance_Change_fen(price_pianyi_all_refund_all_tmp);
			
			Long currentMerchant_balance = user_merchant2.getCurrentMerchant_balance();
			
			TradeRecord72RefundRecord refundRecord_update = new TradeRecord72RefundRecord();
			refundRecord_update.setMerchant_balance(currentMerchant_balance);
			
			ContextUtil.getSerializContext().updateObject(refundRecord.getId(), refundRecord_update);
			
			 /**
			  * 退款的统计
			  */
			String merchant_today_refund_total_key = this.get_merchant_today_refund_total_key();
				 
			Long refund_today_total_fen_balance  = (Long) SimpleDbCacheContent.get_object(merchant_today_refund_total_key);
			if(refund_today_total_fen_balance == null){ refund_today_total_fen_balance = 0l;}
				 
			refund_today_total_fen_balance += price_pianyi_all_refund_all_tmp;
			SimpleDbCacheContent.cache_object(merchant_today_refund_total_key, refund_today_total_fen_balance);
			//退订单消费领取的通用红包
			this.refund_redenvelope(refundRecord);
		}
		
		
		return refund;
	}
	/**
	 * 	消费后抽取的通用红包的记录 的临时缓存
	 */
	private List<PaymentRecordOperationRecord> redenvelopePaymentRecordList = null;
	/**
	 * 获取所有的 消费后抽取的通用红包的记录
	 * @return
	 */
	public List<PaymentRecordOperationRecord> getRedenvelopePaymentRecordList(){
		
		if(redenvelopePaymentRecordList != null){
			return redenvelopePaymentRecordList;
		}
		
		PaymentRecordOperationRecord paymentRecord = new PaymentRecordOperationRecord();
		
		paymentRecord.setPaymentRecord_id(this.getId());
		paymentRecord.addCommand(MongoCommand.in, "businessIntId", BusinessIntIdConfigQier.businessIntId_give_back);
		paymentRecord.addCommand(MongoCommand.in, "businessIntId", BusinessIntIdConfigQier.businessIntId_another_give_back);
		paymentRecord.addCommand(MongoCommand.in, "businessIntId", BusinessIntIdConfigQier.businessIntId_half_give_back);
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		redenvelopePaymentRecordList = serializContext.findAll(paymentRecord);
		
		return redenvelopePaymentRecordList;
	}
	
	/**
	 * 退 用户领取的通用红包
	 * 	没办法	如果用户在退单是如果这个用户剩余的通用红包不足 则会把会员的通用红包 退成负数
	 * @return
	 */
	public Integer refund_redenvelope(RefundRecord refundRecord) {
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		//消费后抽取的通用红包的记录
		List<PaymentRecordOperationRecord> paymentRecord_list = this.getRedenvelopePaymentRecordList();
		
		//领取定向红包的总金额
		Long sum_price_fen_all = 0l;
		//所有红包
		for (PaymentRecordOperationRecord paymentRecordOperationRecord : paymentRecord_list) {
			sum_price_fen_all += paymentRecordOperationRecord.getShowPrice_fen_all();
		}
		//当前订单退款的总金额				 
		Long refund_showPrice_fen_all = refundRecord.getPrice_fen_all_refund_all_tmp();
		//主订单的总金额
		Long order_showPrice_fen_all = this.getShowPrice_fen_all();
		
		//实际应退的红包金额
		Long current_need_refund_fen = sum_price_fen_all*refund_showPrice_fen_all/order_showPrice_fen_all;
		
		if(current_need_refund_fen <= 0) {
			return State.STATE_FALSE;
		}
		
		String requestFlow = refundRecord.getId()+"_bp_rd";
		
		User72 user_huiyuan_tmp = this.getUser_huiyuan();
		
		PaymentRecordOperationRecord wallet_amount_paymentRecord  = new PaymentRecordOperationRecord();
		
		wallet_amount_paymentRecord.setId(new ObjectId().toString());
		wallet_amount_paymentRecord.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_refund_tongyong);
		wallet_amount_paymentRecord.setPay_method(PayFinalVariable.pay_method_balance);
		wallet_amount_paymentRecord.setPrice_fen_all(-current_need_refund_fen);
		wallet_amount_paymentRecord.setUserId_huiyuan(this.getUserId_huiyuan());
		wallet_amount_paymentRecord.setState(State.STATE_OK);
		wallet_amount_paymentRecord.setRequestFlow(requestFlow);
		wallet_amount_paymentRecord.setPaymentRecord_id(this.getId());
		wallet_amount_paymentRecord.setUserId_merchant(this.getUserId_merchant());
		wallet_amount_paymentRecord.setWallet_amount_balance_pianyi(user_huiyuan_tmp.getCurrentBalance()-current_need_refund_fen*User.pianyiFen);
		
		serializContext.save(wallet_amount_paymentRecord);
		
		user_huiyuan_tmp.balanceChangeFen(-current_need_refund_fen);
		
		return State.STATE_OK;
	}
	/**
	 * 退 用户领取的通用红包
	 * @return
	 */
	public Integer refund_merchantRedEnvelope(RefundRecord refundRecord) {
		
		
		return State.STATE_OK;
	}
	
	@Override
	public Long getCant_refund_amount_fen() {
		
		PaymentRecordOperationRecord paymentRecord = new PaymentRecordOperationRecord();
		
		paymentRecord.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_dingxiang);
		paymentRecord.setPaymentRecord_id(this.getId());
		paymentRecord.setState(State.STATE_OK);
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		paymentRecord = (PaymentRecordOperationRecord) serializContext.get(paymentRecord);
		
		if(paymentRecord == null) {
			return 0l;
		}
		
		return paymentRecord.getPrice_fen_all();
	}
	/**
	 * 使用定向红包
	 */
	public void useMerchantRedEnvelope() {
		//检查定向红包 有定向红包优先使用
					MerchantRedEnvelope merchantRedEnvelope_tmp = this.getMerchantRedEnvelope();
					
					if(merchantRedEnvelope_tmp == null) {
						return;
					}
				
					//将定向红包的钱充值进去
					Long showPrice_fen_all = this.getShowPrice_fen_all();
					
					Long amountFen = merchantRedEnvelope_tmp.getAmountFen();
					
					Long dikou_fen = amountFen;
					
					/**
					 * 定向红包 最大 抵扣订单金额   比如订单金额是 50  红包是100  那么这里 就向余额里充值50 元 
					 * 如果订单是 200 元  定向红包是100 元 那么就向余额里充值 100 元
					 */
					if(showPrice_fen_all < dikou_fen) {
						dikou_fen = showPrice_fen_all;
					}
					
					CheckException.checkIsTure(State.STATE_OK.equals(merchantRedEnvelope_tmp.getState()), "定向红包状态异常!");
					
					CheckException.checkIsTure(merchantRedEnvelope_tmp.getExpiry_time() > System.currentTimeMillis(), "定向红包已过期!");
					
					SerializContext serializContext = ContextUtil.getSerializContext();
					
					User72 user_huiyuan_current = this.getUser_huiyuan();


					//todo 胡金石 整合的Business
					Long yue_balance = user_huiyuan_current.getBalance();
					if(yue_balance == null){
						yue_balance = 0l;
					}
					BusinessContext instance = BusinessContext.getInstance();
					Business<MerchantRedEnvelopePayRecord> business = instance.getBusiness(BusinessIntIdConfigQier.businessIntId_dingxiang);
					CheckException.checkIsTure(business != null, "定向红包业务未配置!");
					
					Map requestMap = new HashMap();
					
					requestMap.put("tradeRecord72", this);
					requestMap.put("userId_merchant", this.getUserId_merchant());
					requestMap.put("merchantRedEnvelope", merchantRedEnvelope_tmp);
					
					requestMap.put(Business.user_key, user_huiyuan_current);
					requestMap.put(Business.ip_key, getIp());
					requestMap.put(Business.requestFlow_key, this.getId());
					
					MerchantRedEnvelopePayRecord merchantRedEnvelopePayRecord_tmp = business.executeBusiness(requestMap);
					
					CheckException.checkIsTure(State.STATE_OK.equals(merchantRedEnvelopePayRecord_tmp.getState()), "使用定向红包失败");
	}
	/**
	 * 胡金石 返回定向红包充值记录
	 */
	public MerchantRedEnvelopePayRecord getMerchantRedEnvelopePayRecord() {
		SerializContext serializContext = ContextUtil.getSerializContext();

		MerchantRedEnvelopePayRecord merchantRedEnvelopePayRecord_find = new MerchantRedEnvelopePayRecord();

		merchantRedEnvelopePayRecord_find.setPaymentRecord_id(this.getId());
		merchantRedEnvelopePayRecord_find.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_dingxiang);

		return (MerchantRedEnvelopePayRecord) serializContext.get(merchantRedEnvelopePayRecord_find);
	}
	/**
	 * 胡金石 返回余额支付记录
	 */
	public PaymentRecordOperationRecord getBalancePayRecord() {
		SerializContext serializContext = ContextUtil.getSerializContext();

		String requestFlow = this.getId()+"_bp";

		PaymentRecordOperationRecord merchantRedEnvelopePayRecord_find = new PaymentRecordOperationRecord();

		merchantRedEnvelopePayRecord_find.setRequestFlow(requestFlow);

		return (PaymentRecordOperationRecord) serializContext.get(merchantRedEnvelopePayRecord_find);
	}
	/**
	 *  支付处理完成了回调
	 * 	订单处理自己的回调事件
	 */
	public void pay_success_notify_back() {
		
		//使用定向红包
		 this.useMerchantRedEnvelope();
		
		 super.pay_success_notify_back();
		 
		 SerializContext serializContext = ContextUtil.getSerializContext();
		 
//		 UserVoucher userVoucher_tmp = this.getUserVoucher();
//		 if(userVoucher_tmp != null){
//			 
//			 UserVoucher userVoucher_update = new UserVoucher();
//			 userVoucher_update.setUseState(com.lymava.commons.state.State.STATE_PAY_SUCCESS);
//			 
//			 serializContext.updateObject(userVoucher_tmp.getId(), userVoucher_update);
//		 } 
		//订单金额 我们在商家的额度要减少
		 Long reclaimPrice_fen = this.getReclaimPrice_fen();
		 
		 Merchant72 user_merchant_tmp = this.getUser_merchant();
		 user_merchant_tmp.shareMerchant_balance_Change_fen(-reclaimPrice_fen);
		 
		 Merchant72 user_merchant_now = (Merchant72) serializContext.get(Merchant72.class, this.getUserId_merchant());
		 
		 Long currentMerchant_balance = user_merchant_now.getCurrentMerchant_balance();
		 
		 this.setMerchant_balance(currentMerchant_balance);
		 
		 ThreadPoolContext.getExecutorService().execute(new Runnable() {
			@Override
			public void run() {
				
				//老客户营销	就没有新客户营销这种发放阀值
				if(Merchant72.amount_type_trade_bili_laokehu.equals(user_merchant_tmp.getReceive_red_envelope_lingqu_type()) ) {
					 //商家定向红包生成
					 TradeRecord72.this.merchant_red_pack_create_laokehu(); 
				}else {
					 //商家定向红包处理 计入此次的营销进了进入红包营销池
					 TradeRecord72.this.merchant_red_pack_process();
					 
					 if(Merchant72.receive_red_envelope_create_type_autocraete.equals(user_merchant_tmp.getReceive_red_envelope_create_type())) {
						 //商家定向红包生成
						 TradeRecord72.this.merchant_red_pack_create();
					 }
				}
				 //计入统计
				 TradeRecord72.this.trade_record_tongji();
				 //通知商家
				 TradeRecord72.this.notify_merchant();
				 //通知用户
				 TradeRecord72.this.notify_huiyuan();
				 //清除预设金额
				 TradeRecord72.this.clear_preset();
				 
			}
		});
	}
	
	/**
	 * 清除预设金额
	 */
	public void clear_preset(){
		
		Product72 product72 = TradeRecord72.this.getProduct();
		
		if(product72 != null) {
			product72.clear_preset();
		}
	}
	
	private Product72 product72;
	
	@Override
	public Product72 getProduct() {
			
			if (product72 != null || !MyUtil.isValid(this.getProductId())) {
				return product72;
			}
		
			SerializContext serializContext = ContextUtil.getSerializContext();
	
			product72 = (Product72) serializContext.get(Product72.class, this.getProductId());
			 
		return product72;
	}
	
	@Override
	public void update_to_success() {
		
		//更新状态
		TradeRecord72 paymentRecord_update = new TradeRecord72();
						
		paymentRecord_update.setState(State.STATE_PAY_SUCCESS);
		paymentRecord_update.setPay_method(this.getPay_method());
		paymentRecord_update.setPayTime(System.currentTimeMillis());
		paymentRecord_update.setMerchant_balance(this.getMerchant_balance());
						
		ContextUtil.getSerializContext().updateObject(this.getId(), paymentRecord_update);
	}
	
	/**
	 * 	生成老客户的营销红包
	 */
	private void merchant_red_pack_create_laokehu() {
		
		Merchant72 user_merchant_tmp = this.getUser_merchant();
		
		MerchantRedEnvelopeConfig merchantRedEnvelopeConfig_find = new MerchantRedEnvelopeConfig();
		
		merchantRedEnvelopeConfig_find.setUserId_merchant(user_merchant_tmp.getId());
		merchantRedEnvelopeConfig_find.setState(State.STATE_OK);
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		List<MerchantRedEnvelopeConfig> merchantRedEnvelopeConfig_list = serializContext.findAll(merchantRedEnvelopeConfig_find);
		
		/**
		 * 没有可以生成的红包	此商户没配置红包
		 */
		if(merchantRedEnvelopeConfig_list == null || merchantRedEnvelopeConfig_list.size() <= 0) {
			return;
		}
		
		int size = merchantRedEnvelopeConfig_list.size();
		
		Random random = new Random();
		
		int nextInt = random.nextInt(size);
			
		MerchantRedEnvelopeConfig merchantRedEnvelopeConfig = merchantRedEnvelopeConfig_list.get(nextInt);
		
		this.merchant_red_pack_create(merchantRedEnvelopeConfig);
	}
	
	/**
	 * 新客户定向红包生成
	 */
	private void merchant_red_pack_create() {
		
		Merchant72 user_merchant_tmp = this.getUser_merchant();
		
		Long merchant_redenvelope_balance_fen = user_merchant_tmp.getMerchant_redenvelope_balance_fen();
		if(merchant_redenvelope_balance_fen == null || merchant_redenvelope_balance_fen == 0) {
			return;
		}
		
		Long merchant_redenvelope_arrive_fen = user_merchant_tmp.getMerchant_redenvelope_arrive_fen();
		if(merchant_redenvelope_arrive_fen == null || merchant_redenvelope_arrive_fen == 0) {
			return;
		}
		
		/**
		 * 不到发放阀值
		 */
		if(merchant_redenvelope_arrive_fen > merchant_redenvelope_balance_fen) {
			return;
		}
		
		MerchantRedEnvelopeConfig merchantRedEnvelopeConfig_find = new MerchantRedEnvelopeConfig();
		
		merchantRedEnvelopeConfig_find.setUserId_merchant(user_merchant_tmp.getId());
		merchantRedEnvelopeConfig_find.setState(State.STATE_OK);
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		List<MerchantRedEnvelopeConfig> merchantRedEnvelopeConfig_list = serializContext.findAll(merchantRedEnvelopeConfig_find);
		
		/**
		 * 没有可以生成的红包
		 */
		if(merchantRedEnvelopeConfig_list == null || merchantRedEnvelopeConfig_list.size() <= 0) {
			return;
		}
		
		int size = merchantRedEnvelopeConfig_list.size();
		
		Random random = new Random();
		
		boolean is_go_one = true;
		
		while(is_go_one) {
			
			int nextInt = random.nextInt(size);
			
			MerchantRedEnvelopeConfig merchantRedEnvelopeConfig = merchantRedEnvelopeConfig_list.get(nextInt);
			
			Long amountFen = merchantRedEnvelopeConfig.getAmountFen();
			
			if(amountFen > merchant_redenvelope_arrive_fen || amountFen > merchant_redenvelope_balance_fen) {
				is_go_one = false;
				return;
			}
			
			this.merchant_red_pack_create(merchantRedEnvelopeConfig);
			
			user_merchant_tmp = (Merchant72) ContextUtil.getSerializContext().get(Merchant72.class, this.getUserId_merchant());
			
			merchant_redenvelope_balance_fen = user_merchant_tmp.getMerchant_redenvelope_balance_fen();
			merchant_redenvelope_arrive_fen = user_merchant_tmp.getMerchant_redenvelope_arrive_fen();
			
			//如果剩余的金额不够发红包了
			if(merchant_redenvelope_balance_fen < amountFen) {
				is_go_one = false;
				return;
			}
		}
	}
	
	/**
	 * 定向红包生成
	 */
	private void merchant_red_pack_create(MerchantRedEnvelopeConfig merchantRedEnvelopeConfig) {
		
		Merchant72 user_merchant_tmp = this.getUser_merchant();
		
		MerchantRedEnvelope merchantRedEnvelope_save = new MerchantRedEnvelope();
		
		merchantRedEnvelope_save.setId(new ObjectId().toString());
		merchantRedEnvelope_save.setRed_envolope_name(merchantRedEnvelopeConfig.getRed_envolope_name());
		merchantRedEnvelope_save.setUserId_merchant(merchantRedEnvelopeConfig.getUserId_merchant());
		merchantRedEnvelope_save.setExpiry_time(System.currentTimeMillis()+merchantRedEnvelopeConfig.getExpiry_time()*DateUtil.one_day);
		merchantRedEnvelope_save.setMerchant_type(merchantRedEnvelopeConfig.getMerchant_type());
		merchantRedEnvelope_save.setIndex_id(System.currentTimeMillis());
		merchantRedEnvelope_save.setLocation(user_merchant_tmp.getLocation());
		merchantRedEnvelope_save.setAmount_to_reach(merchantRedEnvelopeConfig.getAmount_to_reach());
		
		Long initMerchantRedEnvelopeAmount = merchantRedEnvelopeConfig.initMerchantRedEnvelopeAmount(this);
		
		//老客户营销
		merchantRedEnvelope_save.setTradeRecord72_id(this.getId());
		merchantRedEnvelope_save.setUserId_huiyuan(getUserId_huiyuan());
		merchantRedEnvelope_save.setState(State.STATE_OK);
		merchantRedEnvelope_save.setUserId_merchant_lingqu(this.getUserId_merchant());
		merchantRedEnvelope_save.setLingqu_time(System.currentTimeMillis());
			 
		
		merchantRedEnvelope_save.setAmount(initMerchantRedEnvelopeAmount);
		merchantRedEnvelope_save.setBalance(initMerchantRedEnvelopeAmount);
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		serializContext.save(merchantRedEnvelope_save);
		
		//不是老客户营销 才有资金池 老客户营销 一笔订单直接生成一个本店的定向红包
		if(!Merchant72.amount_type_trade_bili_laokehu.equals(user_merchant_tmp.getReceive_red_envelope_lingqu_type()) ) {
			user_merchant_tmp.share_merchant_redenvelope_balance_changeFen(-merchantRedEnvelopeConfig.getAmountFen());
		}
	}
	/**
	 * 商家的定向红包金额增加
	 */
	private void merchant_red_pack_process() {
		
		Long price_fen_all = this.getShowPrice_fen_all();
		
		Merchant72 user_merchant_tmp = this.getUser_merchant();
		
		
		Long merchant_red_pack_fen = user_merchant_tmp.get_merchant_red_pack_fen(price_fen_all);
		
		if(merchant_red_pack_fen <= 0){ 
			return;
		}
		
		user_merchant_tmp.share_merchant_redenvelope_balance_changeFen(merchant_red_pack_fen);
	}

	/**
	 * 通知会员
	 */
	public void notify_huiyuan(){
		User user_huiyuan_tmp = this.getUser_huiyuan();
		//会员不存在
		if(user_huiyuan_tmp == null){ return;}
		
		String third_user_id = user_huiyuan_tmp.getThird_user_id();
		
		SubscribeUser subscribeUser_find = new SubscribeUser();
		subscribeUser_find.setOpenid(third_user_id);
		
		subscribeUser_find = (SubscribeUser) ContextUtil.getSerializContext().get(subscribeUser_find);
		//未关注
		if(subscribeUser_find == null){ return;}
		
		//如果是10分钟内关注的 并且渠道为空  就把渠道设置成这个
		Long get_id_time_tmp = subscribeUser_find.get_id_time_tmp();
		if(System.currentTimeMillis()-get_id_time_tmp <= 10*DateUtil.one_minite && !MyUtil.isValid(subscribeUser_find.getQudao_user_id())) {
			
			SubscribeUser subscribeUser_update = new SubscribeUser();
			subscribeUser_update.setQudao_user_id(this.getUserId_merchant());
			
			ContextUtil.getSerializContext().updateObject(subscribeUser_find.getId(), subscribeUser_update);
		}
		
		GongzonghaoContent instance = GongzonghaoContent.getInstance();
		
		Gongzonghao defaultGongzonghao = instance.getDefaultGongzonghao();
		
		String template_id = "uD_YiAqC8bXD3316oX9LVsRbK1pXTzO1Iaf41Sx2QMg";
		
		
		String url_call_back = "https://tiesh.liebianzhe.com/pay_success_back.jsp?out_trade_no="+this.getShowPayFlow();
		/**
				{{first.DATA}}
				商品名称：{{keyword1.DATA}}
				订单编号：{{keyword2.DATA}}
				消费金额：{{keyword3.DATA}}
				支付金额：{{keyword4.DATA}}
				买单时间：{{keyword5.DATA}}
				{{remark.DATA}}
		 */
		
		List<MessageTemplateField> messageTemplateField_list = new LinkedList<MessageTemplateField>();
		
		User user_merchant_tmp = this.getUser_merchant();
		//商户不存在
		if(user_merchant_tmp == null){ return;}
		
		messageTemplateField_list.add(new MessageTemplateField("first", "您在 "+user_merchant_tmp.getNickname()+" 消费成功！", "#173177"));
		
		Double price_fen_all_yuan = MathUtil.divide(this.getShowPrice_fen_all(), 100).doubleValue();
		
		
		String showPayInfo = null;
		
		Long wallet_amount_payment_fen = this.getWallet_amount_payment_fen();

		if(wallet_amount_payment_fen == null || wallet_amount_payment_fen == 0 || PayFinalVariable.pay_method_balance.equals(this.getPay_method())) {
			showPayInfo = this.getShowPay_method();
		}else {
			showPayInfo = this.getShowPay_method()+"("+this.getThirdPayPrice_yuan()+")元 ";
			showPayInfo += ",红包支付("+this.getWallet_amount_payment_yuan()+")";
		}
		
		messageTemplateField_list.add(new MessageTemplateField("keyword1", "统一买单", "#173177"));
		messageTemplateField_list.add(new MessageTemplateField("keyword2", this.getRequestFlow(), "#173177"));
		messageTemplateField_list.add(new MessageTemplateField("keyword3", price_fen_all_yuan+"元", "#173177"));
		messageTemplateField_list.add(new MessageTemplateField("keyword4", showPayInfo, "#173177"));
		messageTemplateField_list.add(new MessageTemplateField("keyword5", this.getShowPayTime(), "#173177"));
		messageTemplateField_list.add(new MessageTemplateField("remark", "悠择YORZ生活提醒您:亲!买单成功后，记得领红包。", "#173177"));
		 
		String message_template_send = null;
		try {
			message_template_send = defaultGongzonghao.message_template_send(third_user_id,template_id,url_call_back,messageTemplateField_list);
			
			JsonObject jsonObject_root = JsonUtil.parseJsonObject(message_template_send);
			
			String errcode = JsonUtil.getString(jsonObject_root, "errcode");
			String errmsg = JsonUtil.getString(jsonObject_root, "errmsg");
			if(!"0".equals(errcode)){
				logger.error("通知会员失败: message_template_send:"+message_template_send);
			}
			
		} catch (Exception e) {
			logger.error("通知商家失败!", e);
		}
	}
	
	private Long getAmount_payment() {
		return this.getWallet_amount_payment_fen();
	}

	/**
	 * 红包翻倍
	 * @return
	 */
	public void red_package_x2(){
		
		SerializContext serializContext  = ContextUtil.getSerializContext();
		
		String red_package_x2_request_flow = this.getId()+"_x2";
		
		/**
		 * 检查是否已经翻倍了
		 */
		PaymentRecord balanceLog_find = new PaymentRecord();
		balanceLog_find.setRequestFlow(red_package_x2_request_flow);
		 
		PaymentRecord balanceLog_fanbei = (PaymentRecord) serializContext.findOneInlist(balanceLog_find);
		if(balanceLog_fanbei != null){ return;}
		
		User72 user_huiyuan = this.getUser_huiyuan();
		
		//检查是否关注如果没关注红包减半 关注之后再红包翻倍
		GongzonghaoContent instance = GongzonghaoContent.getInstance();
		SubscribeUser subscribeUser = instance.getSubscribeUser(user_huiyuan.getThird_user_id());
		//如果未关注 或者 如果关注状态不是已关注 返回
		if(subscribeUser == null || !State.STATE_OK.equals(subscribeUser.getState())){
			 return;
		}
		/**
		 * 关注后 20分钟之内的 折半红包才 翻倍
		 */
		balanceLog_find = new PaymentRecord();
		balanceLog_find.setRequestFlow(this.getId());
		/**
		 * 20分钟之内的订单 没翻倍的才翻倍
		 */
		ObjectId startTimeObj = new ObjectId(new Date(System.currentTimeMillis()-20*DateUtil.one_minite));
		balanceLog_find.addCommand(MongoCommand.dayu, "id", startTimeObj);
		 
		PaymentRecord balanceLog_fanxian = (PaymentRecord) serializContext.findOneInlist(balanceLog_find);
		/**
		 * 检查返现红包是否存在
		 */
		if(balanceLog_fanxian == null){ return;}
		
		Merchant72 user_merchant_tmp = this.getUser_merchant();
		
		Long get_red_pack_fen_max = user_merchant_tmp.get_red_pack_fen_max(this.getShowPrice_fen_all());
		
		Long count_fen = balanceLog_fanxian.getWallet_amount_balance_fen();
		//检验 元是的减半的红包后 发送的红包×2  是否小于最大红包值
		if(count_fen * 2 > get_red_pack_fen_max){
			return;
		}
		
		Long count_change_pianyi = count_fen*User.pianyiFen;
		
		String balance_log_id = new ObjectId().toString();
		
		PaymentRecordOperationRecord paymentRecord = new PaymentRecordOperationRecord();
		
		paymentRecord.setId(balance_log_id);
		paymentRecord.setRequestFlow(red_package_x2_request_flow);
		paymentRecord.setUser_huiyuan(user_huiyuan);
		paymentRecord.setPrice_pianyi_all(count_change_pianyi);
		paymentRecord.setWallet_amount_balance_pianyi(count_change_pianyi+user_huiyuan.getBalance());
		paymentRecord.setState(com.lymava.commons.state.State.STATE_OK);
		paymentRecord.setPay_method(PayFinalVariable.pay_method_balance);
		paymentRecord.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_another_give_back);
		paymentRecord.setPaymentRecord_id(this.getId());
		paymentRecord.setUserId_merchant(this.getUserId_merchant());
		
		serializContext.save(paymentRecord);
		
		Business.checkRequestFlow(paymentRecord);
		 
		user_huiyuan.balanceChange(count_change_pianyi);
		
		this.notify_red_package_x2(paymentRecord);
	}
	
	/**
	 * data添加字段
	 * @return
	 */
	public JsonObject addDataField(String key,String value){
		JsonObject data_root = new JsonObject();
		if(value != null && !value.trim().isEmpty()){
			data_root.addProperty(key, value);
		}  
		return data_root;
	}
	/**
	 * 获取红包的发放的交易记录
	 * @return
	 */
	public List<PaymentRecordOperationRecord> getRedPackagePaymentRecord() {
		
		CheckException.checkIsTure(!MyUtil.isEmpty(this.getId()), "不空查询空订单!");
		
		PaymentRecordOperationRecord paymentRecord_find = new PaymentRecordOperationRecord();
		
		paymentRecord_find.setPaymentRecord_id(this.getId());
		
		paymentRecord_find.addCommand(MongoCommand.or, "businessIntId", BusinessIntIdConfigQier.businessIntId_another_give_back);
		paymentRecord_find.addCommand(MongoCommand.or, "businessIntId", BusinessIntIdConfigQier.businessIntId_give_back);
		paymentRecord_find.addCommand(MongoCommand.or, "businessIntId", BusinessIntIdConfigQier.businessIntId_half_give_back);
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		List<PaymentRecordOperationRecord> findAll = serializContext.findAll(paymentRecord_find);
		
		return findAll;
	}
	
	public PaymentRecord open_red_package(){
		
		SerializContext serializContext  = ContextUtil.getSerializContext();
		
		CheckException.checkIsTure(State.STATE_PAY_SUCCESS.equals(this.getState()), "亲，买单后才能抽红包!");
		
		PaymentRecord balanceLog_find = new PaymentRecord();
		balanceLog_find.setRequestFlow(this.getId());
		
		List<PaymentRecord> balanceLog_list = serializContext.findAll(balanceLog_find);
		
		for (PaymentRecord balanceLog_tmp : balanceLog_list) {
			//只能有红包消费	如果有其他 就是已经抽取过红包了
			if(	BusinessIntIdConfigQier.businessIntId_give_back.equals( balanceLog_tmp.getMemo() )
					||	BusinessIntIdConfigQier.businessIntId_half_give_back.equals(balanceLog_tmp.getMemo() )
					||	BusinessIntIdConfigQier.businessIntId_another_give_back.equals(balanceLog_tmp.getMemo() )
					){
				CheckException checkException = new CheckException("您已经抽取过红包了!",StatusCode.USER_INFO_TIMEOUT);
				checkException.addDataField("balance_id", balanceLog_tmp.getId());
				throw checkException;
			}
		}
		
		User init_http_user = this.getUser_huiyuan();
		
		Merchant72 user_merchant = (Merchant72) this.getUser_merchant(); 
		
		Long price_fen_all = this.getShowPrice_fen_all();
		
		//利润
		Long profit_fen = user_merchant.get_profit_fen(price_fen_all);
		if(profit_fen <= 0){ profit_fen = 1l; }
		
		//红包发送金额 最大值
		Long red_pack_fen_max = user_merchant.get_red_pack_fen_max(price_fen_all);
		if(red_pack_fen_max <= 0){ red_pack_fen_max = 1l; }
		//红包发送金额 最小值
		Long red_pack_fen_min = user_merchant.get_red_pack_fen_min(price_fen_all);
		
		//没有利润就抽取不到红包
		CheckException.checkIsTure(red_pack_fen_max >=0 && red_pack_fen_min >= 0  && red_pack_fen_max > red_pack_fen_min, "没有抽取中红包!下次在来");
		
		Random random = new Random();
		
		Integer red_pack_fen_final = random.nextInt(red_pack_fen_max.intValue()-red_pack_fen_min.intValue())+red_pack_fen_min.intValue();
		
		PaymentRecordOperationRecord paymentRecord = new PaymentRecordOperationRecord();
		
		paymentRecord.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_give_back);
		
		if(MyUtil.isEmpty(init_http_user.getThird_user_id())){
			//红包金额减半
			red_pack_fen_final = red_pack_fen_final/2;
			paymentRecord.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_half_give_back);
		}
		if( !MyUtil.isEmpty( init_http_user.getThird_user_id() ) ){
			//检查是否关注如果没关注红包减半 关注之后再红包翻倍
			GongzonghaoContent instance = GongzonghaoContent.getInstance();
			SubscribeUser subscribeUser = instance.getSubscribeUser(init_http_user.getThird_user_id());
			//如果未关注 或者 如果关注状态不是 已关注 获取取消关注后
			if(subscribeUser == null || !State.STATE_OK.equals(subscribeUser.getState())){
				//红包金额减半
				red_pack_fen_final = red_pack_fen_final/2;
				paymentRecord.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_half_give_back);
			}
		}
		if(red_pack_fen_final <= 0){ red_pack_fen_final = 1; }
		
		Long red_pack_final_pianyi = red_pack_fen_final*User.pianyiFen;

		Long yue_balance = init_http_user.getBalance();
		if(yue_balance == null){
			yue_balance = 0l;
		}
		
		String requestFlow = this.getId()+"_x1";
		
		String balance_log_id = new ObjectId().toString();
		
		paymentRecord.setId(balance_log_id);
		paymentRecord.setUser_huiyuan(init_http_user);
		paymentRecord.setPrice_pianyi_all(red_pack_final_pianyi);
		paymentRecord.setWallet_amount_balance_pianyi(red_pack_final_pianyi+yue_balance);;
		paymentRecord.setState(com.lymava.commons.state.State.STATE_OK);
		paymentRecord.setPay_method(PayFinalVariable.pay_method_balance);
		paymentRecord.setRequestFlow(requestFlow);
		paymentRecord.setPaymentRecord_id(this.getId());
		paymentRecord.setUserId_merchant(this.getUserId_merchant());
		
		serializContext.save(paymentRecord);
		
		Business.checkRequestFlow(paymentRecord);
		
		init_http_user.balanceChange(red_pack_final_pianyi);
		
		return paymentRecord;
	}
	
	/**
	 * 通知商家
	 */
	public void notify_merchant(){
		
		Product product = this.getProduct();
		//产品不存在
		if(product == null){ return;}
		
		Merchant72 user_merchant_tmp = (Merchant72) this.getUser_merchant();
		//商户不存在
		if(user_merchant_tmp == null){ return;}
		
		 String merchant_today_cash_total_key = this.get_merchant_today_cash_total_key();
		 Long today_total_fen  = (Long) SimpleDbCacheContent.get_object(merchant_today_cash_total_key);
		 if(today_total_fen == null){ today_total_fen = 0l;}
		 
		 String merchant_today_cash_total_key_alipay = this.get_merchant_today_cash_total_key_alipay();
		 Long today_total_fen_alipay  = (Long) SimpleDbCacheContent.get_object(merchant_today_cash_total_key_alipay);
		 if(today_total_fen_alipay == null){ today_total_fen_alipay = 0l;}
		 
		 String merchant_today_cash_total_key_weixin = this.get_merchant_today_cash_total_key_weixin();
		 Long today_total_fen_weixin  = (Long) SimpleDbCacheContent.get_object(merchant_today_cash_total_key_weixin);
		 if(today_total_fen_weixin == null){ today_total_fen_weixin = 0l;}
		 
		String merchant_today_cash_total_key_qianbao = this.get_merchant_today_cash_total_key_qianbao();
		Long today_total_fen_balance  = (Long) SimpleDbCacheContent.get_object(merchant_today_cash_total_key_qianbao);
		if(today_total_fen_balance == null){ today_total_fen_balance = 0l;}
		
		 /**
		  * 退款的统计
		  */
		String merchant_today_refund_total_key = this.get_merchant_today_refund_total_key();
		Long refund_today_total_fen_balance  = (Long) SimpleDbCacheContent.get_object(merchant_today_refund_total_key);
		if(refund_today_total_fen_balance == null){ refund_today_total_fen_balance = 0l;}
		
		GongzonghaoContent instance = GongzonghaoContent.getInstance();
		
		Gongzonghao defaultGongzonghao = instance.getDefaultGongzonghao();
		
		
		String template_id = "96e8Mc9egXej8xMPBEKqZQ3jvQ1OXCvZeG1-0-FkwNU";
		/**
		 *  详细内容
			{{first.DATA}}
			到账金额：{{keyword1.DATA}}
			支付方式：{{keyword2.DATA}}
			支付时间：{{keyword3.DATA}}
			订单编号：{{keyword4.DATA}}
			{{remark.DATA}}

		 */
		
		List<MessageTemplateField> messageTemplateField_list = new LinkedList<MessageTemplateField>();
		
		messageTemplateField_list.add(new MessageTemplateField("first", "(悠择生活)用户买单成功！", "#173177"));
		
		Double price_fen_all_yuan = MathUtil.divide(this.getShowPrice_fen_all(), 100).doubleValue();
		Double today_total_yuan = MathUtil.divide(today_total_fen, 100).doubleValue();
		
		Double today_total_yuan_weixin = MathUtil.divide(today_total_fen_weixin, 100).doubleValue();
		Double today_total_yuan_alipay = MathUtil.divide(today_total_fen_alipay, 100).doubleValue();
		Double today_total_yuan_balance = MathUtil.divide(today_total_fen_balance, 100).doubleValue();
		//退款总金额
		Double refund_today_total_yuan_balance = MathUtil.divide(refund_today_total_fen_balance, 100).doubleValue();
		//减去了退款金额的实际总额
		Double today_total_yuan_shiji = MathUtil.divide(today_total_fen-refund_today_total_fen_balance, 100).doubleValue();
		
		messageTemplateField_list.add(new MessageTemplateField("keyword1", price_fen_all_yuan+"元", "#173177"));
		messageTemplateField_list.add(new MessageTemplateField("keyword2", this.getShowPay_method(), "#173177"));
		messageTemplateField_list.add(new MessageTemplateField("keyword3", this.getShowPayTime(), "#173177"));
		messageTemplateField_list.add(new MessageTemplateField("keyword4", this.getRequestFlow(), "#173177"));
		messageTemplateField_list.add(new MessageTemplateField("remark", "今日收款汇总\n"
						+ "总计:		"+today_total_yuan+"元\n"
						+ "红包支付:	"+today_total_yuan_balance+"元\n"
						+ "微信:		"+today_total_yuan_weixin+"元\n"
						+ "支付宝:		"+today_total_yuan_alipay+"元\n"
						+ "实际总收益:	"+today_total_yuan_shiji+"元\n"
						+ "退款总额:		"+refund_today_total_yuan_balance+"元\n"
						, "#173177"));
		
		String message_template_send = null;
		try {
			
			BasicDBList notify_openid_list = user_merchant_tmp.getNotify_openid_list();
			
			if(notify_openid_list == null) {
				return;
			}
			
			for (Object object : notify_openid_list) {
				
				String notify_openid = (String) object;
				
				SubscribeUser subscribeUser_find = new SubscribeUser();
				subscribeUser_find.setOpenid(notify_openid);
				
				subscribeUser_find = (SubscribeUser) ContextUtil.getSerializContext().get(subscribeUser_find);
				
				//未关注
				if(subscribeUser_find == null){ 
					continue;
				}
				
				message_template_send = defaultGongzonghao.message_template_send(notify_openid,template_id,null,messageTemplateField_list);
				
				JsonObject jsonObject_root = JsonUtil.parseJsonObject(message_template_send);
				
				String errcode = JsonUtil.getString(jsonObject_root, "errcode");
				String errmsg = JsonUtil.getString(jsonObject_root, "errmsg");
				
				if(!"0".equals(errcode)){
					logger.error("通知商家失败: message_template_send:"+message_template_send);
				}
			}
		} catch (Exception e) {
			logger.error("通知商家失败!", e);
		}
		
	}
	
	/**
	 * 钱包翻倍的通知
	 * @param balance_log 
	 */
	public void notify_red_package_x2(PaymentRecord balance_log){
		
		User user_huiyuan_tmp = this.getUser_huiyuan();
		//会员不存在
		if(user_huiyuan_tmp == null){ return;}
		
		String third_user_id = user_huiyuan_tmp.getThird_user_id();
		
		SubscribeUser subscribeUser_find = new SubscribeUser();
		subscribeUser_find.setOpenid(third_user_id);
		
		subscribeUser_find = (SubscribeUser) ContextUtil.getSerializContext().get(subscribeUser_find);
		//未关注
		if(subscribeUser_find == null || !State.STATE_OK.equals(subscribeUser_find.getState())){ return;}
		
		GongzonghaoContent instance = GongzonghaoContent.getInstance();
		
		Gongzonghao defaultGongzonghao = instance.getDefaultGongzonghao();
		
		String template_id = "z4R_mt_xeKEsxIzEoYvNByKI17fbhFx0wCcAjjvppBs";
		
		
		/**
				{{first.DATA}}
				付款方式：{{keyword1.DATA}}
				商户订单号：{{keyword2.DATA}}
				交易时间：{{keyword3.DATA}}
				{{remark.DATA}}
		 */
		
		List<MessageTemplateField> messageTemplateField_list = new LinkedList<MessageTemplateField>();
		
		User user_merchant_tmp = this.getUser_merchant();
		//商户不存在
		if(user_merchant_tmp == null){ return;}
		
		messageTemplateField_list.add(new MessageTemplateField("first", "感谢你关注悠择YORZ生活!", "#173177"));
		
		messageTemplateField_list.add(new MessageTemplateField("keyword1", "钱包关注翻倍", "#173177"));
		messageTemplateField_list.add(new MessageTemplateField("keyword2", this.getShowPayFlow(), "#173177"));
		messageTemplateField_list.add(new MessageTemplateField("keyword3", this.getShowPayTime(), "#173177"));
		
		messageTemplateField_list.add(new MessageTemplateField("remark", 
				"翻倍红包("+balance_log.getWallet_amount_payment_yuan()+"元)已到小主钱包啦~\n"+
				"钱包现在鼓到"+balance_log.getWallet_amount_balance_yuan()+"元了\n"+
				"等待主人再次光临!\n"
				, "#173177"));
		 
		String message_template_send = null;
		try {
			message_template_send = defaultGongzonghao.message_template_send(third_user_id,template_id,null,messageTemplateField_list);
		} catch (Exception e) {
			logger.error("通知商家失败!", e);
		}
		
	}
	/**
	 * 获取 订单的 红包 发放记录
	 * @return
	 */
	public List<PaymentRecordOperationRecord> getPaymentRecordOperationRecordList(){
		
		List<PaymentRecordOperationRecord> paymentRecordOperationRecordList = null; 
		
		PaymentRecordOperationRecord paymentRecordOperationRecord_find = new PaymentRecordOperationRecord();
		paymentRecordOperationRecord_find.setPaymentRecord_id(this.getId());
		
		//businessIntId=31102&businessIntId=31101&businessIntId=31100
		
		paymentRecordOperationRecord_find.addCommand(MongoCommand.or, "businessIntId", BusinessIntIdConfigQier.businessIntId_another_give_back);
		paymentRecordOperationRecord_find.addCommand(MongoCommand.or, "businessIntId", BusinessIntIdConfigQier.businessIntId_give_back);
		paymentRecordOperationRecord_find.addCommand(MongoCommand.or, "businessIntId", BusinessIntIdConfigQier.businessIntId_half_give_back);
		
		paymentRecordOperationRecordList = ContextUtil.getSerializContext().findAll(paymentRecordOperationRecord_find);
		
		return paymentRecordOperationRecordList;
	}


	@Override
	public void parseBeforeSearch(Map parameterMap)
	{
		//设置查找条件：系统编号
		String id = HttpUtil.getParemater(parameterMap, "id");
		if (id!=null && !id.equals("")) {
			setId(id);
		}

		super.parseBeforeSearch(parameterMap);
	}
}
