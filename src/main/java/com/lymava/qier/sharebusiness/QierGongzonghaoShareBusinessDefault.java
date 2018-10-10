package com.lymava.qier.sharebusiness;

import java.util.Date;

import org.bson.types.ObjectId;

import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.nosql.context.SerializContext;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.qier.model.TradeRecord72;
import com.lymava.wechat.gongzhonghao.Gongzonghao;
import com.lymava.wechat.gongzhonghao.sharebusiness.GongzonghaoShareBusiness;

public class QierGongzonghaoShareBusinessDefault extends GongzonghaoShareBusiness{

	@Override
	public String getBusinessName() {
		return "默认无参数微信回调";
	}

	@Override
	public String getBusinessId() {
		return "-1";
	}

	@Override
	public String getDataId() {
		return null;
	}

	@Override
	public void subscribe_call_back(Gongzonghao gongzonghao, String data_id, String openid) {
		super.subscribe_call_back(gongzonghao, data_id, openid);
		
		this.check_traderecord72_notify_huiyuan(openid);
	} 
	/**
	 * 通知会员
	 */
	public void check_traderecord72_notify_huiyuan(String openid){
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		/**
		 * 检查这个用户的订单编号
		 */
		
		User user_find = new User();
		user_find.setThird_user_id(openid);
		
		user_find = (User) serializContext.get(user_find);
		
		if(user_find == null){ return;}
		
		TradeRecord72 tradeRecord72_find = new TradeRecord72();
		tradeRecord72_find.setUserId_huiyuan(user_find.getId());
		tradeRecord72_find.setState(State.STATE_PAY_SUCCESS);
		//20分钟内的
		ObjectId objectId = new ObjectId(new Date(System.currentTimeMillis()-DateUtil.one_minite*20));
		tradeRecord72_find.addCommand(MongoCommand.dayuAndDengyu, "id", objectId);
		
		TradeRecord72 tradeRecord72 = (TradeRecord72) serializContext.findOneInlist(tradeRecord72_find);
		if(tradeRecord72 == null){ return;}
		
		tradeRecord72.notify_huiyuan();
		/**
		 * 检查 红包金额
		 */
		tradeRecord72.red_package_x2();
	} 

}
