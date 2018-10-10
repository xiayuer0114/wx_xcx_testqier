package com.lymava.qier.activities.model;

import java.text.ParseException;
import java.util.Date;

import com.lymava.base.util.ContextUtil;
import com.lymava.base.util.WebConfigContent;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;
import com.lymava.qier.model.User72;
import com.lymava.wechat.gongzhonghao.SubscribeUser;

/**
 * 首次关注买单立减活动
 *  首次买单赠送8.8的定向红包
 * @author lymava
 *
 */
public class SubscribeFirstRedEnvelope extends BaseModel{

	/**
	 * 
	 */
	private static final long serialVersionUID = 3922340200535004184L;

	/**
	 * 用户的openid
	 */
	private String openid; 
	/**
	 * 红包金额
	 */
	private Integer amount_fen;
	/**
	 * 红包有效开始时间
	 */
	private Long startTime;
	/**
	 * 红包有效结束时间
	 */
	private Long endTime;
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
		putConfig(SubscribeFirstRedEnvelope.class, "state_"+State.STATE_OK, "已发放");
	}
	public String getShowState(){
		 return (String) getConfig("state_"+this.getState());
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
			
			WebConfigContent instance = WebConfigContent.getInstance();
			String defaultUserGroupId = instance.getDefaultUserGroupId();
			
			User72 user72_find = new User72();
			
			user72_find.setUserGroupId(defaultUserGroupId);
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
	public Long getStartTime() {
		return startTime;
	}
	public void setStartTime(Long startTime) {
		this.startTime = startTime;
	}
	public void setInStartTime(String time_str) {
		try {
			Date parse = DateUtil.getSdfShort().parse(time_str);
			this.startTime = parse.getTime();
		} catch (ParseException e) {
		}
	}
	public String getShowStartTime() {
		if(startTime == null){
			return null;
		}
		return DateUtil.getSdfShort().format(new Date(startTime));
	}
	
	public Long getEndTime() {
		return endTime;
	}
	
	public void setEndTime(Long endTime) {
		this.endTime = endTime;
	}
	
	public void setInEndTime(String time_str) {
		try {
			Date parse = DateUtil.getSdfShort().parse(time_str);
			this.endTime = parse.getTime();
		} catch (ParseException e) {
		}
	}
	public String getShowEndTime() {
		if(endTime == null){
			return null;
		}
		return DateUtil.getSdfShort().format(new Date(endTime));
	}
	public Integer getState() {
		return state;
	}
	public void setState(Integer state) {
		this.state = state;
	} 
}
