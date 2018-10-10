package com.lymava.qier.manager.business;


import com.lymava.base.safecontroler.model.UserV2;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.state.State;
import com.lymava.commons.util.HttpUtil;
import com.lymava.qier.manager.model.RedEnvelopeChangeRecord;

import com.lymava.qier.model.Merchant72;
import com.lymava.trade.base.model.Business;
import com.lymava.trade.base.model.BusinessRecord;
import com.lymava.trade.base.model.WriteBusiness;

import java.util.Map;

/***
 * 红包池变动
 * @author lymava
 *
 */
public class RedEnvelopeChangeBusiness extends WriteBusiness<RedEnvelopeChangeRecord>{

	/**
	 * 
	 */
	private static final long serialVersionUID = 9191370854555747451L;

	@Override
	public RedEnvelopeChangeRecord initBusinessRecord() {
		return new RedEnvelopeChangeRecord();
	}

	@Override
	public Class<? extends BusinessRecord> getBusinessRecordClass() {
		return RedEnvelopeChangeRecord.class;
	}

	@Override
	public RedEnvelopeChangeRecord parseBusinessRecord(RedEnvelopeChangeRecord businessRecord, Map requestMap) {

		//获取参数
		Merchant72 merchant72 = (Merchant72) requestMap.get(Business.user_key);

		UserV2 userV2 = (UserV2) requestMap.get("userV2");

		String pinzheng = HttpUtil.getParemater(requestMap, "pinzheng");

		String ip = (String) requestMap.get(Business.ip_key);

		String requestFlow = (String) requestMap.get(Business.requestFlow_key);

		String merchant_redenvelope_balance_change_str = HttpUtil.getParemater(requestMap, "merchant_redenvelope_balance_change");
		CheckException.checkNotEmpty(merchant_redenvelope_balance_change_str, "请选择变动金额");

		String transter_memo = HttpUtil.getParemater(requestMap, "transter_memo");

		CheckException.checkNotEmpty(pinzheng, "请选择上传的凭证图片");

		//设置参数
		businessRecord.setMerchant72(merchant72);
		businessRecord.setMerchant72_id(merchant72.getId());

		businessRecord.setUserV2_submit(userV2);

		businessRecord.setIp(ip);

		businessRecord.setRequestFlow(requestFlow);

		businessRecord.setMerchant_redenvelope_balance_change_Fen(
				(int) (Double.valueOf(merchant_redenvelope_balance_change_str) * 100));

		businessRecord.setTranster_memo(transter_memo);

		businessRecord.setPinzheng(pinzheng);

		return businessRecord;
	}

	@Override
	public RedEnvelopeChangeRecord executeWriteBusiness(RedEnvelopeChangeRecord businessRecord) throws Exception{

//		//业务逻辑
//		Double merchant_redenvelope_balance_change_yuan =//转账凭证
//				MathUtil.parseDouble(
//						(businessRecord.getMerchant_redenvelope_balance_change_Fen()/100) + "");
//
//		CheckException.checkIsTure(merchant_redenvelope_balance_change_yuan>0, "余额变动 的值不能小于等于0");
//
//		Long merchant_redenvelope_balance_change_fen = MathUtil.multiplyInteger(merchant_redenvelope_balance_change_yuan, 100).longValue();
//		businessRecord.getMerchant72().merchant_redenvelope_balance_changeFen(merchant_redenvelope_balance_change_fen);

		businessRecord.setState(RedEnvelopeChangeRecord.accept_shenhe_state_no);

		return businessRecord;
	}
	
	
}
