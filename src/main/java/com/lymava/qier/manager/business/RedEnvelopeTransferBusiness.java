package com.lymava.qier.manager.business;

import com.lymava.base.model.User;
import com.lymava.base.safecontroler.model.UserV2;
import com.lymava.base.util.ContextUtil;
import com.lymava.base.util.FinalVariable;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.state.State;
import com.lymava.commons.util.HttpUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.context.SerializContext;
import com.lymava.qier.business.BusinessIntIdConfigQier;
import com.lymava.qier.manager.model.ManagerOperationRecord;
import com.lymava.qier.manager.model.RedEnvelopeTransfer;
import com.lymava.qier.manager.model.UserRedEnvelopeTransfer;
import com.lymava.qier.model.Merchant72;
import com.lymava.qier.model.MerchantRedEnvelope;
import com.lymava.trade.base.context.BusinessContext;
import com.lymava.trade.base.model.Business;
import com.lymava.trade.base.model.BusinessRecord;
import com.lymava.trade.base.model.WriteBusiness;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

/***
 *  商家红包转移
 * @author lymava
 *
 */
public class RedEnvelopeTransferBusiness extends WriteBusiness<RedEnvelopeTransfer>
{

	/**
	 *
	 */
	private static final long serialVersionUID = 2099863903444308555L;


	@Override
	public RedEnvelopeTransfer initBusinessRecord() {
		return new RedEnvelopeTransfer();
	}

	@Override
	public Class<? extends BusinessRecord> getBusinessRecordClass() {
		return ManagerOperationRecord.class;
	}

	@Override
	public RedEnvelopeTransfer parseBusinessRecord(RedEnvelopeTransfer businessRecord, Map requestMap) {
		//解析数据
		//businessRecord.setState(State.STATE_INPROCESS);

		Merchant72 merchant72 = (Merchant72) requestMap.get(Business.user_key);
		
		UserV2 userV2 = (UserV2) requestMap.get("userV2");

		//设置Business数据成员
		businessRecord.setUserV2_submit(userV2);

		businessRecord.setUserId_merchant(merchant72.getId());

		String amount_string = HttpUtil.getParemater(requestMap, "hongbaozongjine");
		double amount_double = (Double.parseDouble(amount_string) * 1000000);
		businessRecord.setAmount((long) amount_double);

		businessRecord.setNickname(merchant72.getNickname());
		businessRecord.setRedEnvelopeSCount(Integer.parseInt(HttpUtil.getParemater(requestMap, "hongbaozongshu")));

		businessRecord.setState(State.STATE_INPROCESS);

		//返回值request
		return businessRecord;
	}

	@Override
	public RedEnvelopeTransfer executeWriteBusiness(RedEnvelopeTransfer businessRecord) throws Exception{
		//处理业务逻辑，要保存记录日志，则业务处理应写在此处，不应该写在Action中
		businessRecord.setState(State.STATE_OK);

		UserV2 userV2 = businessRecord.getUserV2_submit();

		User user = businessRecord.getUser_huiyuan();

		//获取SerializContext
		SerializContext serializContext = ContextUtil.getSerializContext();

		//查找指定商家红包，修改红包状态：已领取 -> 已转移
		MerchantRedEnvelope merchantRedEnvelope_find = new MerchantRedEnvelope();
		
		merchantRedEnvelope_find.setUserId_merchant(user.getId());
		merchantRedEnvelope_find.setState(State.STATE_OK);

		Iterator<MerchantRedEnvelope> merchantRedEnvelope_ite = serializContext.findIterable(merchantRedEnvelope_find);

		//BusinessContext用于WriteBusiness
		BusinessContext instance = BusinessContext.getInstance();
		Business<UserRedEnvelopeTransfer> business = instance.getBusiness(BusinessIntIdConfigQier.businessIntId_merchant_user_hongbaozhuanyi);
		CheckException.checkIsTure(business != null, "转账业务未配置!");


		//设置业务参数
		Map requestMap = new HashMap();
		requestMap.put("userV2", userV2);

		String request_flow = businessRecord.getId();

		Integer index = 1;

		while (merchantRedEnvelope_ite.hasNext()) {

			MerchantRedEnvelope merchantRedEnvelope =merchantRedEnvelope_ite.next();

			requestMap.put("merchantRedEnvelope", merchantRedEnvelope);
			requestMap.put(Business.user_key, merchantRedEnvelope.getUser_huiyuan() );
			requestMap.put(Business.requestFlow_key, request_flow+index );


			business.executeBusiness(requestMap);

			index ++;
		}

		return businessRecord;
	}
}
