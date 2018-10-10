package com.lymava.qier.self_order.model;

import com.lymava.base.model.PubConlumn;
import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.util.MyUtil;

/**
 * 商家的菜品的类别
 * @author lymava
 *
 */
public class PubConlumnFood  extends PubConlumn{

	/**
	 * 
	 */
	private static final long serialVersionUID = -6342598015425079595L;

	/**
	 * 商户	这个在多商户的时候有用
	 */
	private User user_merchant;
	/**
	 * 商户系统编号	这个在多商户的时候有用
	 */
	private String userId_merchant;
	/**
	 * 折扣比例	
	 */
	private Long zhekou_bili;
	
	public String getUserId_merchant() {
		return userId_merchant;
	}
	public void setUserId_merchant(String userId_merchant) {
		this.userId_merchant = userId_merchant;
	}
	public User getUser_merchant() {
		if (user_merchant == null && MyUtil.isValid(this.userId_merchant)) {
			user_merchant = (User) ContextUtil.getSerializContext().get(User.class, userId_merchant);
		}
		return user_merchant;
	}
	public void setUser_merchant(User user_merchant) {
		if (user_merchant != null) {
			userId_merchant = user_merchant.getId();
		}
		this.user_merchant = user_merchant;
	}
	public Long getZhekou_bili() {
		return zhekou_bili;
	}
	public void setZhekou_bili(Long zhekou_bili) {
		this.zhekou_bili = zhekou_bili;
	}
	
}
