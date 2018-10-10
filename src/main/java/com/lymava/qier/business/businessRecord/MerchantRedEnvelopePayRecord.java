package com.lymava.qier.business.businessRecord;

import com.lymava.base.util.ContextUtil;
import com.lymava.commons.util.HttpUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.qier.model.MerchantRedEnvelope;
import com.lymava.trade.pay.model.PaymentRecordOperationRecord;

import java.util.Map;

/**
 * 定向红包支付记录
 * @author lymava
 *
 */
public class MerchantRedEnvelopePayRecord extends PaymentRecordOperationRecord {
	 
	/**
	 * 
	 */
	private static final long serialVersionUID = -8464187847906259377L;
	
	private MerchantRedEnvelope merchantRedEnvelope;
	
	private String merchantRedEnvelope_id;
 
	public MerchantRedEnvelope getMerchantRedEnvelope() {
		if(merchantRedEnvelope == null && MyUtil.isValid(this.getMerchantRedEnvelope_id())) {
			merchantRedEnvelope = (MerchantRedEnvelope) ContextUtil.getSerializContext().get(MerchantRedEnvelope.class, this.getMerchantRedEnvelope_id());
		}
		return merchantRedEnvelope;
	}
	public String getMerchantRedEnvelope_id() {
		return merchantRedEnvelope_id;
	}
	public void setMerchantRedEnvelope_id(String merchantRedEnvelope_id) {
		this.merchantRedEnvelope_id = merchantRedEnvelope_id;
	}
	public void setMerchantRedEnvelope(MerchantRedEnvelope merchantRedEnvelope) {
		if(merchantRedEnvelope != null) {
			this.merchantRedEnvelope_id = merchantRedEnvelope.getId();
		}
		this.merchantRedEnvelope = merchantRedEnvelope;
	}

	@Override
	public void parseBeforeSearch(Map parameterMap)
	{
		super.parseBeforeSearch(parameterMap);
	}
}
