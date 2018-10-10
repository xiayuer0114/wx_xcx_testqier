package com.lymava.qier.activities.sharebusiness;

import java.io.IOException;
import java.util.Date;

import org.bson.types.ObjectId;

import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.nosql.context.SerializContext;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.qier.business.BusinessIntIdConfigQier;
import com.lymava.trade.base.model.BusinessIntIdConfig;
import com.lymava.trade.pay.model.PaymentRecord;
import com.lymava.wechat.gongzhonghao.Gongzonghao;
import com.lymava.wechat.gongzhonghao.SubscribeUser;
import com.lymava.wechat.gongzhonghao.sharebusiness.GongzonghaoShareBusiness;

public class ZhongqiuShareBusiness extends GongzonghaoShareBusiness{
	
	public static void main(String[] args) throws IOException {
		
	}

	@Override
	public String getBusinessName() {
		return "2018中秋活动";
	}

	@Override
	public String getBusinessId() {
		return "20180923zq";
	}
  
	@Override
	public void subscribe_call_back(Gongzonghao gongzonghao, String data_id, String openid) {
		try {
			this.subscribe_call_back_process(gongzonghao, data_id, openid);
		} catch (Exception e) {
			logger.error("回调异常!",e);
		}
	}

	private void subscribe_call_back_process(Gongzonghao gongzonghao, String data_id, String openid)  throws Exception{
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		SubscribeUser subscribeUser_find = new SubscribeUser();
		subscribeUser_find.setOpenid(openid);
		
		SubscribeUser subscribeUser = (SubscribeUser) serializContext.get(subscribeUser_find);
		
		if(subscribeUser == null) {
			logger.error("中秋活动 未找到SubscribeUser openid:"+openid);
			return;
		}
		
		User user_huiyuan = subscribeUser.getUser_huiyuan();
		
		if(user_huiyuan == null) {
			logger.error("中秋活动未找到user_huiyuan openid:"+openid);
			return;
		}
		
		
		PaymentRecord paymentRecord_find = new PaymentRecord();
		
		paymentRecord_find.setBusinessIntId(BusinessIntIdConfig.businessIntId_trade);
		paymentRecord_find.setUserId_huiyuan(user_huiyuan.getId());
		
		//30分钟内的订单扫码有效
		Long time_dayu = System.currentTimeMillis()-DateUtil.one_minite*10 ;
		
		ObjectId start_timeObj = new ObjectId(new Date(time_dayu));
		
		paymentRecord_find.addCommand(MongoCommand.dayuAndDengyu, "id", start_timeObj);
		
		PaymentRecord paymentRecord_find_out = (PaymentRecord) serializContext.findOneInlist(paymentRecord_find);
		
		if(paymentRecord_find_out == null) {
			gongzonghao.send_text_message("亲,订单支付后30分钟内识别二维码才能领取哦!", openid);
			return;
		}
		
		/**
		 * 一个用户只能抽取一次
		 */
		PaymentRecord paymentRecord_zhongqiu_had_chouqu_find = new PaymentRecord();
		
		paymentRecord_zhongqiu_had_chouqu_find.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_zhongqiu_yuebing);
		paymentRecord_zhongqiu_had_chouqu_find.setUserId_huiyuan(user_huiyuan.getId());
		
		PaymentRecord paymentRecord_zhongqiu_had_chouqu_find_out  = (PaymentRecord) serializContext.findOneInlist(paymentRecord_zhongqiu_had_chouqu_find);
		
		if(paymentRecord_zhongqiu_had_chouqu_find_out != null) {
			gongzonghao.send_text_message("亲,美人只能领取一次哦!", openid);
			return;
		}
		
		
		String userId_merchant = paymentRecord_find_out.getUserId_merchant();
		
		synchronized (ZhongqiuShareBusiness.class) {
			/**
			 * 找出有没有未领取月饼的记录
			 */
			
			PaymentRecord paymentRecord_zhongqiu_find = new PaymentRecord();
			
			paymentRecord_zhongqiu_find.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_zhongqiu_yuebing);
			paymentRecord_zhongqiu_find.setUserId_merchant(userId_merchant);
			paymentRecord_zhongqiu_find.setState(State.STATE_WAITE_PROCESS);
			paymentRecord_zhongqiu_find.addCommand(MongoCommand.xiaoyuAndDengyu, "id", new ObjectId());
			
			PaymentRecord paymentRecord_zhongqiu_find_out  = (PaymentRecord) serializContext.findOneInlist(paymentRecord_zhongqiu_find);
			
			if(paymentRecord_zhongqiu_find_out == null) {
				gongzonghao.send_text_message("亲,抱歉,您未抽取到月饼!", openid);
				return;
			}
			
			/**
			 * 领取月饼
			 */
			PaymentRecord paymentRecord_zhongqiu_update = new PaymentRecord();
			
			paymentRecord_zhongqiu_update.setState(State.STATE_OK);
			paymentRecord_zhongqiu_update.setUserId_huiyuan(user_huiyuan.getId());
			paymentRecord_zhongqiu_update.setPayTime(System.currentTimeMillis());
			paymentRecord_zhongqiu_update.setRequestFlow(paymentRecord_find_out.getId());
			
			serializContext.updateObject(paymentRecord_zhongqiu_find_out.getId(), paymentRecord_zhongqiu_update);
		}
		
		gongzonghao.send_text_message("亲,恭喜您获得价值399元的悠择月饼大礼包一份!请凭此消息找服务员免费领取!", openid);
	}
}
