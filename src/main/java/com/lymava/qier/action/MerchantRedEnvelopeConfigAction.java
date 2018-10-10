package com.lymava.qier.action;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.commons.exception.CheckException;
import com.lymava.nosql.model.SerializModel;
import com.lymava.qier.model.MerchantRedEnvelopeConfig;
/**
 * 定向红包配置
 * @author lymava
 *
 */
@AcceptUrlAction(path="v2/MerchantRedEnvelopeConfig/",name="定向红包配置")
public class MerchantRedEnvelopeConfigAction extends LazyBaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6285710434054344790L;

	@Override
	protected Class<? extends SerializModel> getObjectClass() {
		return MerchantRedEnvelopeConfig.class;
	}

	@Override
	protected void listParse(Object object_find) {
		MerchantRedEnvelopeConfig merchantRedEnvelopeConfig = (MerchantRedEnvelopeConfig) object_find;
		merchantRedEnvelopeConfig.setUserId_merchant(this.getParameter("object.userId_merchant"));
	}

	@Override
	protected void saveParse(Object object_find) {
		super.saveParse(object_find);
		
		MerchantRedEnvelopeConfig merchantRedEnvelopeConfig = (MerchantRedEnvelopeConfig) object_find;
		
		Long amount = merchantRedEnvelopeConfig.getAmount();
		
		CheckException.checkIsTure(amount != null && amount > 0, "红包配置金额必须大于0！");
		

	}
	
	
	
}
