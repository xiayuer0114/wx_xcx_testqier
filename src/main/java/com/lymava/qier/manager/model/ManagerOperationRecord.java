package com.lymava.qier.manager.model;

import com.lymava.base.safecontroler.model.UserV2;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.trade.base.model.BusinessRecord;

/**
 * 商家预下架记录
 * @author lymava
 *
 */
public class ManagerOperationRecord extends BusinessRecord
{

	private static final long serialVersionUID = -7471942564266918535L;

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

	
//	/**
//	 * 支付成功回调
//	 */
//	public void pay_success_notify_back() {
//
//		BusinessContext instance = BusinessContext.getInstance();
//
//		Business<ManagerOperationRecord> business = instance.getBusiness(BusinessIntIdConfigQier.businessIntId_merchant_yuxiajia);
//
//		CheckException.checkIsTure(business != null, "商户备付金变动业务未配置!");
//
//		Map requestMap = new HashMap();
//
//		//requestMap.put(Business.user_key, this.getMerchant72());
//		requestMap.put(Business.requestFlow_key, this.getId());
//		requestMap.put("paymentRecord", this);
//
//		business.executeBusiness(requestMap);
//
//	}


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
	public String getUserV2Id() {
		return userV2_submit_id;
	}
	public UserV2 getUserV2() {
		return this.getUserV2_submit();
	}
}
