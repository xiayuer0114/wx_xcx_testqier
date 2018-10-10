package com.lymava.qier.manager.model;

import com.lymava.base.model.User;
import com.lymava.base.safecontroler.model.UserV2;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.util.HttpUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.qier.model.MerchantRedEnvelope;
import com.lymava.trade.pay.model.PaymentRecord;

import java.util.Map;

/**
 * 用户红包转移记录
 * @author lymava
 *
 */
public class UserRedEnvelopeTransfer extends PaymentRecord
{

	private static final long serialVersionUID = 2349095223711565827L;

	/**
	 * 提交管理员
	 */
	private UserV2 userV2_submit;
	/**
	 * 提交管理员
	 */
	private String userV2_submit_id;
	/**
	 * 审核管理员
	 */
	private UserV2 userV2_shenghe;
	/**
	 * 审核管理员
	 */
	private String userV2_shenghe_id;
	/**
	 * 定向红包
	 */
	private MerchantRedEnvelope merchantRedEnvelope;
	/**
	 * 定向红包 系统编号
	 */
	private String merchantRedEnvelopeId;

	/**
	 * 用户
	 */
	private User user;
	/**
	 * 用户ID
	 */
	private String userId;

	public String getUserV2Id() {
		return userV2_submit_id;
	}
	public UserV2 getUserV2() {
		return this.getUserV2_submit();
	}
	public UserV2 getUserV2_submit() {
		if (userV2_submit == null && MyUtil.isValid(this.userV2_submit_id)) {
			userV2_submit = (UserV2) ContextUtil.getSerializContext().get(UserV2.class, userV2_submit_id);
		}
		return userV2_submit;
	}
	public void setUserV2_submit(UserV2 userV2_submit) {
		if (userV2_submit != null) {
			userV2_submit_id = userV2_submit.getId();
		}
		this.userV2_submit = userV2_submit;
	}
	public String getUserV2_submit_id() {
		return userV2_submit_id;
	}
	public void setUserV2_submit_id(String userV2_submit_id) {
		this.userV2_submit_id = userV2_submit_id;
	}
	public UserV2 getUserV2_shenghe() {
		if (userV2_shenghe == null && MyUtil.isValid(this.userV2_shenghe_id)) {
			userV2_shenghe = (UserV2) ContextUtil.getSerializContext().get(UserV2.class, userV2_shenghe_id);
		}
		return userV2_shenghe;
	}
	public void setUserV2_shenghe(UserV2 userV2_shenghe) {
		if (userV2_shenghe != null) {
			userV2_shenghe_id = userV2_shenghe.getId();
		} 
		this.userV2_shenghe = userV2_shenghe;
	}
	public String getUserV2_shenghe_id() {
		return userV2_shenghe_id;
	}
	public void setUserV2_shenghe_id(String userV2_shenghe_id) {
		this.userV2_shenghe_id = userV2_shenghe_id;
	}

	public User getUser()
	{
		if (MyUtil.isValid(this.userId)){
			return (User) ContextUtil.getSerializContext().get(User.class, userId);
		}
		return user;
	}

	public void setUser(User user)
	{
		if(user != null && MyUtil.isValid(user.getId()) ){
			this.setUserId(user.getId());
		}
		this.user = user;
	}

	public String getUserId()
	{
		return userId;
	}

	public void setUserId(String userId)
	{
		this.userId = userId;
	}

	public MerchantRedEnvelope getMerchantRedEnvelope()
	{
		if (MyUtil.isValid(this.userId)){
			return (MerchantRedEnvelope) ContextUtil.getSerializContext().get(MerchantRedEnvelope.class, merchantRedEnvelopeId);
		}
		return merchantRedEnvelope;
	}

	public void setMerchantRedEnvelope(MerchantRedEnvelope merchantRedEnvelope)
	{
		if(merchantRedEnvelope != null && MyUtil.isValid(merchantRedEnvelope.getId()) ){
			this.setMerchantRedEnvelopeId(merchantRedEnvelope.getId());
		}
		this.merchantRedEnvelope = merchantRedEnvelope;
	}

	public String getMerchantRedEnvelopeId()
	{
		return merchantRedEnvelopeId;
	}

	public void setMerchantRedEnvelopeId(String merchantRedEnvelopeId)
	{
		this.merchantRedEnvelopeId = merchantRedEnvelopeId;
	}

	@Override
	public void parseBeforeSearch(Map parameterMap)
	{
		//设置查找条件：系统编号
		String id = HttpUtil.getParemater(parameterMap, "id");
		if (id!=null && !id.equals(""))
			setId(id);

		super.parseBeforeSearch(parameterMap);
	}
}
