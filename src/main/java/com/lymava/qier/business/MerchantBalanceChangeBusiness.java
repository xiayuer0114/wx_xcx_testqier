package com.lymava.qier.business;

import java.util.Map;

import org.bson.types.ObjectId;

import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.pay.PayFinalVariable;
import com.lymava.commons.state.State;
import com.lymava.commons.util.HttpUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.context.SerializContext;
import com.lymava.qier.cmbpay.model.TransferToMerchantRecord;
import com.lymava.qier.model.Merchant72;
import com.lymava.trade.base.model.BusinessRecord;
import com.lymava.trade.base.model.WriteBusiness;
import com.lymava.trade.pay.model.PaymentRecordOperationRecord;
/**
 * 	商户备付金 变动
 * @author lymava
 *
 */
public class MerchantBalanceChangeBusiness extends WriteBusiness<PaymentRecordOperationRecord>{
 

	/**
	 * 
	 */
	private static final long serialVersionUID = -7062134236623093438L;

	@Override
	public PaymentRecordOperationRecord initBusinessRecord() {
		return new PaymentRecordOperationRecord();
	}

	@Override
	public Class<? extends BusinessRecord> getBusinessRecordClass() {
		return PaymentRecordOperationRecord.class;
	}

	@Override
	public PaymentRecordOperationRecord parseBusinessRecord(PaymentRecordOperationRecord businessRecord, Map requestMap) {
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		String paymentRecord_id = HttpUtil.getParemater(requestMap, "paymentRecord_id");
		
		TransferToMerchantRecord transferToMerchantRecord = (TransferToMerchantRecord) requestMap.get("paymentRecord");
		
		if(transferToMerchantRecord == null && MyUtil.isValid(paymentRecord_id)) {
			transferToMerchantRecord = (TransferToMerchantRecord) serializContext.get(TransferToMerchantRecord.class, paymentRecord_id);
		}
		
		CheckException.checkIsTure(transferToMerchantRecord != null, "转账记录凭证未找到!");
		
		CheckException.checkIsTure(State.STATE_PAY_SUCCESS.equals(transferToMerchantRecord.getState()), "转账未成功!");
		
		businessRecord.setPaymentRecord(transferToMerchantRecord);
		
		//这个交易金额为负数
		Long price_fen_all = transferToMerchantRecord.getYufukuan_price_fen();
		
		businessRecord.setId(new ObjectId().toString());
		businessRecord.setPay_method(PayFinalVariable.pay_method_balance);
		//金额转换成正数
		businessRecord.setPrice_fen_all(price_fen_all);
		businessRecord.setState(State.STATE_INPROCESS);
		
		return businessRecord;
	}

	@Override
	public PaymentRecordOperationRecord executeWriteBusiness(PaymentRecordOperationRecord businessRecord) throws Exception{
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		TransferToMerchantRecord transferToMerchantRecord = (TransferToMerchantRecord) businessRecord.getPaymentRecord();
		
		Merchant72 merchant72 = transferToMerchantRecord.getMerchant72();
		
		Long yufukuan_price_fen = transferToMerchantRecord.getYufukuan_price_fen();
		
		Long balance_int_pianyi = yufukuan_price_fen*User.pianyiFen;
		merchant72.merchant_balance_Change(balance_int_pianyi);
		
		businessRecord.setState(State.STATE_OK);
		
		PaymentRecordOperationRecord paymentRecordOperationRecord_update = new PaymentRecordOperationRecord();
		
		paymentRecordOperationRecord_update.setState(State.STATE_OK);
		paymentRecordOperationRecord_update.setWallet_amount_balance_fen(yufukuan_price_fen+merchant72.getMerchant_balance_fen());
		 
		return paymentRecordOperationRecord_update;
	}
	
}
