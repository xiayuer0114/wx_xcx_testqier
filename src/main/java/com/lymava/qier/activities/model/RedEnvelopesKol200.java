package com.lymava.qier.activities.model;

import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;
import com.lymava.qier.model.User72;
import com.lymava.wechat.gongzhonghao.SubscribeUser;

/**
 * Kol200 活动模型
 */
public class RedEnvelopesKol200 extends BaseModel {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1270985278931231353L;
	/**
	 * 唯一编号 一个二维码只能使用一次
	 */
	private String data_id;
	/**
	 * 用户的openid
	 */
	private String openid; 
	/**
	 * 红包金额
	 */
	private Integer amount_fen; 
	/**
	 * 红包状态
	 */
	private Integer state; 
	/**
	 * 关注用户
	 */
	private SubscribeUser subscribeUser;
	/**
	 * 用户
	 */
	private User72 user72;
	
	 static{
			putConfig(RedEnvelopesKol200.class, "state_"+State.STATE_WAITE_PAY, "已发放");
			putConfig(RedEnvelopesKol200.class, "state_"+State.STATE_PAY_SUCCESS, "已使用");
			
	}
	public String getShowState(){
		 return (String) getConfig("state_"+this.getState());
	} 
	public String getData_id() {
		return data_id;
	}

	public void setData_id(String data_id) {
		this.data_id = data_id;
	}

	public SubscribeUser getSubscribeUser() {
		if(subscribeUser == null && !MyUtil.isEmpty(openid)) {
			
			SubscribeUser subscribeUser_find = new SubscribeUser();
			subscribeUser_find.setOpenid(openid);
			
			subscribeUser = (SubscribeUser) ContextUtil.getSerializContext().get(subscribeUser_find);
		}
		return subscribeUser;
	}
	public User72 getUser72() {
		if(user72 == null && !MyUtil.isEmpty(openid)) {
			
			User72 user72_find = new User72();
			user72_find.setThird_user_id(openid);
			
			user72 = (User72) ContextUtil.getSerializContext().get(user72_find);
		}
		return user72;
	}
	public Integer getAmount_fen() {
		return amount_fen;
	}
	public void setAmount_fen(Integer amount_fen) {
		this.amount_fen = amount_fen;
	}
	public String getOpenid() {
		return openid;
	}
	public void setOpenid(String openid) {
		this.openid = openid;
	}   
	public Integer getState() {
		return state;
	}
	public void setState(Integer state) {
		this.state = state;
	} 
}
