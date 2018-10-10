package com.lymava.qier.activities.model;

import java.text.ParseException;
import java.util.Date;

import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;
import com.lymava.qier.model.User72;
import com.lymava.wechat.gongzhonghao.SubscribeUser;

/**
 * 618红包活动
 */
public class GaokaoChengji extends BaseModel {

	private static final long serialVersionUID = 1L;

	/**
	 * 用户的openid
	 */
	private String openid;
	/**
	 * 用户名称
	 */
	private String user_name = null;
	/**
	 * 性别
	 */
	private String sex = null;
	/**
	 * 科目
	 */
	private String kemu = null;
	/**
	 * 学校
	 */
	private String xuexiao = null;
	/**
	 * 关注用户
	 */
	private SubscribeUser subscribeUser;
	/**
	 * 用户
	 */
	private User72 user72;
	/**
	 * 状态
	 */
	private Integer state;
	
	 static{
			putConfig(GaokaoChengji.class, "state_"+State.STATE_WAITE_PROCESS, "等待出图");
			putConfig(GaokaoChengji.class, "state_"+State.STATE_OK, "已出图");
			
	}
	public String getShowState(){
		 return (String) getConfig("state_"+this.getState());
	} 
	
	public Integer getState() {
		return state;
	}

	public void setState(Integer state) {
		this.state = state;
	}

	public SubscribeUser getSubscribeUser() {
		if (subscribeUser == null && !MyUtil.isEmpty(openid)) {

			SubscribeUser subscribeUser_find = new SubscribeUser();
			subscribeUser_find.setOpenid(openid);

			subscribeUser = (SubscribeUser) ContextUtil.getSerializContext().get(subscribeUser_find);
		}
		return subscribeUser;
	}

	public User72 getUser72() {
		if (user72 == null && !MyUtil.isEmpty(openid)) {

			User72 user72_find = new User72();
			user72_find.setThird_user_id(openid);

			user72 = (User72) ContextUtil.getSerializContext().get(user72_find);
		}
		return user72;
	}

	public String getOpenid() {
		return openid;
	}

	public void setOpenid(String openid) {
		this.openid = openid;
	}

	public String getUser_name() {
		return user_name;
	}

	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}

	public String getSex() {
		return sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	public String getKemu() {
		return kemu;
	}

	public void setKemu(String kemu) {
		this.kemu = kemu;
	}

	public String getXuexiao() {
		return xuexiao;
	}

	public void setXuexiao(String xuexiao) {
		this.xuexiao = xuexiao;
	}
	

}
