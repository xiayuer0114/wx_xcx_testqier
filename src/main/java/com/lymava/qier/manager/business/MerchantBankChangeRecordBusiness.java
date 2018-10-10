package com.lymava.qier.manager.business;

import com.lymava.base.model.Pub;
import com.lymava.base.model.User;
import com.lymava.base.safecontroler.model.UserV2;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.HttpUtil;
import com.lymava.nosql.context.SerializContext;
import com.lymava.qier.manager.model.ManagerOperationRecord;
import com.lymava.qier.model.*;
import com.lymava.qier.model.merchant.MerchantBankChangeRecord;
import com.lymava.trade.base.model.Business;
import com.lymava.trade.base.model.BusinessRecord;
import com.lymava.trade.base.model.WriteBusiness;

import java.util.Iterator;
import java.util.Map;

/**
 *  银行卡变更
 * @author lymava
 *
 */
public class MerchantBankChangeRecordBusiness extends WriteBusiness<MerchantBankChangeRecord>{

	/**
	 * 
	 */
	private static final long serialVersionUID = 9191370854555747451L;

	@Override
	public MerchantBankChangeRecord initBusinessRecord() {
		return new MerchantBankChangeRecord();
	}

	@Override
	public Class<? extends BusinessRecord> getBusinessRecordClass() {
		return MerchantBankChangeRecord.class;
	}

	@Override
	public MerchantBankChangeRecord parseBusinessRecord(MerchantBankChangeRecord businessRecord, Map requestMap) {

		//获取参数
		SettlementBank settBank = (SettlementBank) requestMap.get("settBank");
		UserV2 userV2 = (UserV2) requestMap.get("userV2");
		String pinzheng = HttpUtil.getParemater(requestMap, "object.pinzheng");
		Merchant72 merchant72 = (Merchant72) requestMap.get(Business.user_key);
		String ip = HttpUtil.getParemater(requestMap, Business.ip_key);
		String requestFlow = HttpUtil.getParemater(requestMap, Business.requestFlow_key);

		//设置参数
		businessRecord.setUserV2_submit(userV2);
		businessRecord.setUserV2_submit_id(userV2.getId());
		businessRecord.setPinzheng(pinzheng);
		businessRecord.setAccept_bank_type(settBank.getBank_type());
		businessRecord.setAccept_depositary_bank(settBank.getDepositary_bank());
		businessRecord.setAccept_bank_addr(settBank.getBank_addr());
		businessRecord.setAccept_account(settBank.getAccount());
		businessRecord.setAccept_name(settBank.getName());
		businessRecord.setState(MerchantBankChangeRecord.accept_shenhe_state_no);//未审核
		businessRecord.setAccept_memo(settBank.getMemo());

		businessRecord.setUser_huiyuan(merchant72);
		businessRecord.setUserId_huiyuan(merchant72.getId());

		businessRecord.setIp(ip);

		businessRecord.setRequestFlow(requestFlow);

		return businessRecord;
	}

	@Override
	public MerchantBankChangeRecord executeWriteBusiness(MerchantBankChangeRecord businessRecord) throws Exception{

		SerializContext serializContext = ContextUtil.getSerializContext();
		serializContext.save(businessRecord);

		return businessRecord;
	}
	
	
}
