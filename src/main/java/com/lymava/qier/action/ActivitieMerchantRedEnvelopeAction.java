package com.lymava.qier.action;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.nosql.model.SerializModel;
import com.lymava.qier.activities.model.ActivitieMerchant;
import com.lymava.qier.activities.model.ActivitieMerchantRedEnvelope;

/**
 * 定向红包管理
 * @author lymava
 *
 */
@AcceptUrlAction(path="v2/ActivitieMerchantRedEnvelope/",name="活动红包")
public class ActivitieMerchantRedEnvelopeAction extends LazyBaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6285710434054344790L;

	@Override
	protected Class<? extends SerializModel> getObjectClass() {
		return ActivitieMerchantRedEnvelope.class;
	}

}
