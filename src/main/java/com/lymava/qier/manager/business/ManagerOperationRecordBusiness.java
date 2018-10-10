package com.lymava.qier.manager.business;

import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.lymava.base.model.Pub;
import com.lymava.base.model.User;
import com.lymava.base.safecontroler.model.UserV2;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.nosql.context.SerializContext;
import com.lymava.qier.manager.model.ManagerOperationRecord;
import com.lymava.qier.model.Merchant72;
import com.lymava.qier.model.MerchantRedEnvelope;
import com.lymava.qier.model.MerchantRedEnvelopeConfig;
import com.lymava.qier.model.Product72;
import com.lymava.trade.base.model.Business;
import com.lymava.trade.base.model.BusinessRecord;
import com.lymava.trade.base.model.WriteBusiness;
/***
 *  商家预下架
 * @author lymava
 *
 */
public class ManagerOperationRecordBusiness extends WriteBusiness<ManagerOperationRecord>{

	/**
	 * 
	 */
	private static final long serialVersionUID = 9191370854555747451L;

	@Override
	public ManagerOperationRecord initBusinessRecord() {
		return new ManagerOperationRecord();
	}

	@Override
	public Class<? extends BusinessRecord> getBusinessRecordClass() {
		return ManagerOperationRecord.class;
	}

	@Override
	public ManagerOperationRecord parseBusinessRecord(ManagerOperationRecord businessRecord, Map requestMap) {
		//解析数据
		//businessRecord.setState(State.STATE_INPROCESS);
		Merchant72 merchant72 = (Merchant72) requestMap.get(Business.user_key);
		
		UserV2 userV2 = (UserV2) requestMap.get("userV2");

		businessRecord.setUserV2_submit(userV2);
		businessRecord.setUser_huiyuan(merchant72);
		businessRecord.setState(State.STATE_INPROCESS);

		//返回值request
		return businessRecord;
	}

	@Override
	public ManagerOperationRecord executeWriteBusiness(ManagerOperationRecord businessRecord) throws Exception{
		//处理业务逻辑，要保存记录日志，则业务处理应写在此处，不应该写在Action中
		businessRecord.setState(State.STATE_OK);

		User user = businessRecord.getUser_huiyuan();

		//获取SerializContext
		SerializContext serializContext = ContextUtil.getSerializContext();

		//修改指定商家的定向红包配置，状态为：异常
		MerchantRedEnvelopeConfig merchantRedEnvelopeConfig_find = new MerchantRedEnvelopeConfig();
		merchantRedEnvelopeConfig_find.setUserId_merchant(user.getId());
		MerchantRedEnvelopeConfig merchantRedEnvelopeConfig = (MerchantRedEnvelopeConfig) serializContext.get(merchantRedEnvelopeConfig_find);
		MerchantRedEnvelopeConfig merchantRedEnvelopeConfig_update = new MerchantRedEnvelopeConfig();
		merchantRedEnvelopeConfig_update.setState(State.STATE_FALSE);
		serializContext.updateObject(merchantRedEnvelopeConfig.getId(), merchantRedEnvelopeConfig_update);

		//查找指定商家产品，修改收银牌
		Product72 product72_find = new Product72();
		product72_find.setUserId_merchant(user.getId());
		Iterator<Product72> product72_ite = serializContext.findIterable(product72_find);
		while (product72_ite.hasNext()) {
			Product72 product72_tmp = product72_ite.next();
			Product72 product72_update = new Product72();
			product72_update.setState(Pub.state_false);

			serializContext.updateObject(product72_tmp.getId(), product72_update);
		}

		//查找指定商家红包，修改状态未领取状态为未激活
		MerchantRedEnvelope merchantRedEnvelope_find = new MerchantRedEnvelope();
		merchantRedEnvelope_find.setUserId_merchant(user.getId());
		merchantRedEnvelope_find.setState(State.STATE_WAITE_CHANGE);
		Iterator<MerchantRedEnvelope> merchantRedEnvelope_ite = serializContext.findIterable(merchantRedEnvelope_find);
		while (merchantRedEnvelope_ite.hasNext()) {
			MerchantRedEnvelope merchantRedEnvelope_tmp = merchantRedEnvelope_ite.next();
			MerchantRedEnvelope merchantRedEnvelope_update = new MerchantRedEnvelope();
			merchantRedEnvelope_update.setState(State.STATE_WAITE_WAITSENDGOODS);
			serializContext.updateObject(merchantRedEnvelope_tmp.getId(), merchantRedEnvelope_update);
		}

		return null;
	}
	
	
}
