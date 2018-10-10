package com.lymava.qier.manager.business;

import com.lymava.base.model.User;
import com.lymava.base.safecontroler.model.UserV2;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.pay.PayFinalVariable;
import com.lymava.commons.state.State;
import com.lymava.qier.manager.model.UserRedEnvelopeTransfer;
import com.lymava.qier.model.MerchantRedEnvelope;
import com.lymava.trade.base.model.BusinessRecord;
import com.lymava.trade.base.model.WriteBusiness;
import com.lymava.wechat.gongzhonghao.SubscribeUser;
import org.bson.types.ObjectId;

import java.util.Map;

/***
 *  用户红包转移
 * @author lymava
 *
 */
public class UserRedEnvelopeTransferBusiness extends WriteBusiness<UserRedEnvelopeTransfer>
{
	/**
	 *
	 */
	private static final long serialVersionUID = -1633540701334244557L;


	@Override
	public UserRedEnvelopeTransfer initBusinessRecord() {
		return new UserRedEnvelopeTransfer();
	}

	@Override
	public Class<? extends BusinessRecord> getBusinessRecordClass() {
		return UserRedEnvelopeTransfer.class;
	}

	@Override
	public UserRedEnvelopeTransfer parseBusinessRecord(UserRedEnvelopeTransfer businessRecord, Map requestMap) {
		//解析数据

		MerchantRedEnvelope merchantRedEnvelope = (MerchantRedEnvelope)requestMap.get("merchantRedEnvelope");


		UserV2 userV2 = (UserV2) requestMap.get("userV2");

		businessRecord.setId(new ObjectId().toString());
		//设置Business数据成员
		businessRecord.setUserV2_submit(userV2);
		businessRecord.setMerchantRedEnvelopeId(merchantRedEnvelope.getId());
		businessRecord.setUserId(merchantRedEnvelope.getUserId_huiyuan());
		businessRecord.setUserId_merchant(merchantRedEnvelope.getUserId_merchant());
		businessRecord.setPay_method(PayFinalVariable.pay_method_balance);
		//往外付的都是负数
		businessRecord.setPrice_fen_all(merchantRedEnvelope.getAmountFen());

		businessRecord.setState(State.STATE_INPROCESS);

		//返回值request
		return businessRecord;
	}

	@Override
	public UserRedEnvelopeTransfer executeWriteBusiness(UserRedEnvelopeTransfer businessRecord) throws Exception{
		//todo 胡金石 检测BUG

		MerchantRedEnvelope merchantRedEnvelope = businessRecord.getMerchantRedEnvelope();

		//修改红包状态：已领取 -> 已转移
		MerchantRedEnvelope merchantRedEnvelope_update = new MerchantRedEnvelope();
		merchantRedEnvelope_update.setState(State.STATE_WAITE_CODWAITRECEIPTCONFIRM);
		ContextUtil.getSerializContext().updateObject(merchantRedEnvelope.getId(), merchantRedEnvelope_update);

		//转移金额，用户关注了公众号才转移
		User user = businessRecord.getUser();
		UserRedEnvelopeTransfer userRedEnvelopeTransfer_update = new UserRedEnvelopeTransfer();
		if (user.getThird_user_id() == null) {

			SubscribeUser subscribeUser_find = new SubscribeUser();
			subscribeUser_find.setOpenid(user.getThird_user_id());
			SubscribeUser subscribeUser = (SubscribeUser) ContextUtil.getSerializContext().get(subscribeUser_find);

			//用户关注了公众号
			if (subscribeUser != null && State.STATE_OK.equals(subscribeUser.getState())) {
				user.balanceChangeFen(businessRecord.getPrice_fen_all());
				Long balance = user.getBalance()+businessRecord.getPrice_pianyi_all();
				userRedEnvelopeTransfer_update.setWallet_amount_balance_pianyi(balance);
			}

		}

		//改变当前订单在内存中的状态
		businessRecord.setState(State.STATE_OK);
		
		return businessRecord;
	}
}
