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
public class NazhongRen extends BaseModel {

	private static final long serialVersionUID = 1L;

	/**
	 * 用户的openid
	 */
	private String openid;
	/**
	 * 你喜欢哪种类型的电影
	 */
	private String dianying;
	/**
	 * 西游记里你最喜欢谁
	 */
	private String xiyouji;
	/**
	 * 你最怕
	 */
	private String nizuipa;
	/**
	 * 关注用户
	 */
	private SubscribeUser subscribeUser;
	/**
	 * 用户
	 */
	private User72 user72;

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

	public String getDianying() {
		return dianying;
	}

	public void setDianying(String dianying) {
		this.dianying = dianying;
	}

	public String getXiyouji() {
		return xiyouji;
	}

	public void setXiyouji(String xiyouji) {
		this.xiyouji = xiyouji;
	}

	public String getNizuipa() {
		return nizuipa;
	}

	public void setNizuipa(String nizuipa) {
		this.nizuipa = nizuipa;
	}

}
