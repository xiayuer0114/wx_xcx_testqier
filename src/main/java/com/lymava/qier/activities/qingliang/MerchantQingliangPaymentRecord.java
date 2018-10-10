package com.lymava.qier.activities.qingliang;

import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.context.SerializContext;
import com.lymava.trade.pay.model.PaymentRecord;

/**
 * 清凉计划支付记录
 * @author lymava
 */
public class MerchantQingliangPaymentRecord  extends PaymentRecord{

	/**
	 * 
	 */
	private static final long serialVersionUID = 7483507762304567437L;

	@Override
	public void pay_success_notify_back() {
		String userId_merchant_tmp = this.getUserId_merchant();
		
		if(!MyUtil.isValid(userId_merchant_tmp)) {
			return;
		}
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		MerchantQingliang merchantQingliang = new MerchantQingliang();
		
		merchantQingliang.setState(State.STATE_OK);
		merchantQingliang.setUserId_merchant(userId_merchant_tmp);
		
		
		merchantQingliang =  (MerchantQingliang) serializContext.get(merchantQingliang);
		
		if(merchantQingliang == null) {
			logger.error("userId_merchant_tmp:"+userId_merchant_tmp+" 未参与清凉计划!");
			return;
		}
		
		Long showPrice_fen_all = this.getShowPrice_fen_all();
		
		Long price_fen_current = merchantQingliang.getPrice_fen();
		
		merchantQingliang.price_fen_change(showPrice_fen_all.intValue());
		
		this.setWallet_amount_balance_fen(price_fen_current+showPrice_fen_all);
	} 
	
	/**
	 * 更新到成功
	 */
	public void update_to_success() {
		//更新状态
		PaymentRecord paymentRecord_update = new PaymentRecord();
				
		paymentRecord_update.setState(State.STATE_PAY_SUCCESS);
		paymentRecord_update.setPay_method(this.getPay_method());
		paymentRecord_update.setPayTime(System.currentTimeMillis());
		paymentRecord_update.setWallet_amount_balance_fen(this.getWallet_amount_balance_fen());
				
		ContextUtil.getSerializContext().updateObject(this.getId(), paymentRecord_update);
	}
	 
	
}
