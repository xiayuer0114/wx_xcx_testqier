package com.lymava.qier.business;

import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.pay.PayFinalVariable;
import com.lymava.commons.state.State;
import com.lymava.commons.util.HttpUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.context.SerializContext;
import com.lymava.qier.business.businessRecord.MerchantRedEnvelopePayRecord;
import com.lymava.qier.cmbpay.model.TransferToMerchantRecord;
import com.lymava.qier.model.Merchant72;
import com.lymava.qier.model.MerchantRedEnvelope;
import com.lymava.qier.model.TradeRecord72;
import com.lymava.qier.model.User72;
import com.lymava.trade.base.model.Business;
import com.lymava.trade.base.model.BusinessRecord;
import com.lymava.trade.base.model.WriteBusiness;
import com.lymava.trade.pay.model.PaymentRecordOperationRecord;
import org.bson.types.ObjectId;

import java.util.Map;

/**
 * 胡金石	定向红包支付记录Business
 * @author lymava
 *
 */
public class MerchantRedEnvelopePayRecordBusiness extends WriteBusiness<MerchantRedEnvelopePayRecord>{
 

	/**
	 * 
	 */
	private static final long serialVersionUID = -7062134236623093438L;

	@Override
	public MerchantRedEnvelopePayRecord initBusinessRecord() {
		return new MerchantRedEnvelopePayRecord();
	}

	@Override
	public Class<? extends BusinessRecord> getBusinessRecordClass() {
		return MerchantRedEnvelopePayRecord.class;
	}
	
	@Override
	public MerchantRedEnvelopePayRecord parseBusinessRecord(MerchantRedEnvelopePayRecord businessRecord, Map requestMap) {
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		TradeRecord72 tradeRecord72 = null;
		MerchantRedEnvelope merchantRedEnvelope = null;
		
		tradeRecord72 = (TradeRecord72) requestMap.get("tradeRecord72");
		String tradeRecord72_id = (String) requestMap.get("tradeRecord72_id");
		
		if(tradeRecord72 == null && MyUtil.isValid(tradeRecord72_id)) {
			tradeRecord72  = (TradeRecord72) serializContext.get(TradeRecord72.class, tradeRecord72_id);
		}
		
		CheckException.checkIsTure(tradeRecord72 != null, "订单不存在!");
		//订单支付了才能使用定向红包
		CheckException.checkIsTure(State.STATE_OK.equals(tradeRecord72.getState()) 
				|| State.STATE_WAITE_PAY.equals(tradeRecord72.getState())
				|| State.STATE_PAY_SUCCESS.equals(tradeRecord72.getState())
				, "订单状态异常!不能使用红包!");
		
		merchantRedEnvelope = (MerchantRedEnvelope) requestMap.get("merchantRedEnvelope");
		String merchantRedEnvelope_id = (String) requestMap.get("merchantRedEnvelope_id");
		if(merchantRedEnvelope == null && MyUtil.isValid(merchantRedEnvelope_id)) {
			merchantRedEnvelope  = (MerchantRedEnvelope) serializContext.get(MerchantRedEnvelope.class, merchantRedEnvelope_id);
		}
		
		CheckException.checkIsTure(merchantRedEnvelope != null, "定向红包不存在!");
		CheckException.checkIsTure(State.STATE_OK.equals(merchantRedEnvelope.getState()), "定向红包状态异常!不能使用!");
		
		tradeRecord72_id = tradeRecord72.getId();
		merchantRedEnvelope_id = merchantRedEnvelope.getId();
		
		Merchant72 user_merchant = tradeRecord72.getUser_merchant();
		User72 user_huiyuan = tradeRecord72.getUser_huiyuan();
		
		CheckException.checkIsTure(user_huiyuan.getId().equals(merchantRedEnvelope.getUserId_huiyuan()), "这个红包不属于你!不能使用!");
		CheckException.checkIsTure(user_merchant.getId().equals(merchantRedEnvelope.getUserId_merchant()), "此红包不能在这个商户使用!");
		CheckException.checkIsTure(user_huiyuan.getId().equals(businessRecord.getUserId_huiyuan()), "订单用户与接口用户不匹配!");
		
		//订单的总金额
		Long showPrice_fen_all = tradeRecord72.getShowPrice_fen_all();
		//红包的总金额
		Long amountFen = merchantRedEnvelope.getAmountFen();
		//初始化抵扣的金额
		Long dikou_fen = amountFen;
		/**
		 * 定向红包 最大 抵扣订单金额   比如订单金额是 50  红包是100  那么这里 就向余额里充值50 元 
		 * 如果订单是 200 元  定向红包是100 元 那么就向余额里充值 100 元
		 */
		if(showPrice_fen_all < dikou_fen) {
			dikou_fen = showPrice_fen_all;
		}
		
		//todo 胡金石 整合的Business
		//抵扣金额的 偏移金额
		Long red_pack_final_pianyi = dikou_fen*User.pianyiFen;
		Long yue_balance = user_huiyuan.getBalance();
		if(yue_balance == null){ yue_balance = 0l; }
		
		Long wallet_amount_balance_pianyi = red_pack_final_pianyi+yue_balance;
		

		businessRecord.setId(new ObjectId().toString());
		businessRecord.setPrice_pianyi_all(red_pack_final_pianyi);
		businessRecord.setWallet_amount_balance_pianyi(wallet_amount_balance_pianyi);
		businessRecord.setState(State.STATE_INPROCESS);
		businessRecord.setPay_method(PayFinalVariable.pay_method_balance);
		businessRecord.setPaymentRecord_id(tradeRecord72_id);
		businessRecord.setUserId_merchant(user_merchant.getId());
		businessRecord.setMerchantRedEnvelope_id(merchantRedEnvelope_id);

		return businessRecord;
	}

	@Override
	public MerchantRedEnvelopePayRecord executeWriteBusiness(MerchantRedEnvelopePayRecord businessRecord) throws Exception{

		SerializContext serializContext = ContextUtil.getSerializContext();

		MerchantRedEnvelope merchantRedEnvelope_tmp = businessRecord.getMerchantRedEnvelope();
		User user_huiyuan = businessRecord.getUser_huiyuan();

		MerchantRedEnvelope merchantRedEnvelope_update = new MerchantRedEnvelope();
		merchantRedEnvelope_update.setState(State.STATE_FALSE);

		serializContext.updateObject(merchantRedEnvelope_tmp.getId(), merchantRedEnvelope_update);

		//把定向红包的金额充值进入 通用红包
		user_huiyuan.balanceChange(businessRecord.getPrice_pianyi_all());
		
		//业务操作成功
		businessRecord.setState(State.STATE_OK);
		
		//商户使用红包数量增加
		Merchant72 user_merchant_tmp = merchantRedEnvelope_tmp.getUser_merchant();
		user_merchant_tmp.useRedRenshu_znegjia(1);
		
		return null;
	}
	
}
