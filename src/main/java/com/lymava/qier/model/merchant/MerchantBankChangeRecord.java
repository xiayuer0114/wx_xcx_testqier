package com.lymava.qier.model.merchant;

import com.lymava.base.safecontroler.model.UserV2;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.MyUtil;
import com.lymava.qier.model.SettlementBank;
import com.lymava.trade.base.model.BusinessRecord;

import java.util.Map;


/**
 * 银行卡变更记录
 */
public class MerchantBankChangeRecord extends BusinessRecord{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8676389178771874829L;

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
	 * 如果手动打款就必须有凭证
	 */
	public String pinzheng = null;

	/**
	 * 银行卡类型
	 */
	private Integer accept_bank_type;
	/**
	 * 收款方 开户行
	 */
	private String accept_depositary_bank = null;
	/**
	 * 收方行地址
	 */
	private String accept_bank_addr = null;
	/**
	 * 卡号/账号（帐号 银行卡号 支付宝/微信账号）
	 */
	private String accept_account = null;
	/**
	 * 账户名称 公司名称/个人名称
	 */
	private String accept_name = null;
	/**
	 * 审核备注
	 */
	private String record_memo;
	/**
	 * 备注
	 */
	private String accept_memo;

	public static final Integer accept_shenhe_state_no = State.STATE_OK;			//审核状态 - 未审核
	public static final Integer accept_shenhe_state_fail = State.STATE_FALSE;		//审核状态 - 审核失败
	public static final Integer accept_shenhe_state_complete = State.STATE_INPROCESS;	//审核状态 - 已变更


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
	public String getPinzheng() {
		return pinzheng;
	}
	public void setPinzheng(String pinzheng) {
		this.pinzheng = pinzheng;
	}
	public String getAccept_account() {
		return accept_account;
	}
	public void setAccept_account(String accept_account) {
		this.accept_account = accept_account;
	}
	public Integer getAccept_bank_type() {
		return accept_bank_type;
	}
	public void setAccept_bank_type(Integer accept_bank_type) {
		this.accept_bank_type = accept_bank_type;
	}
	public String getAccept_name() {
		return accept_name;
	}
	public void setAccept_name(String accept_name) {
		this.accept_name = accept_name;
	}
	public String getAccept_depositary_bank() {
		return accept_depositary_bank;
	}
	public void setAccept_depositary_bank(String accept_depositary_bank) {
		this.accept_depositary_bank = accept_depositary_bank;
	}
	public String getAccept_bank_addr() {
		return accept_bank_addr;
	}
	public void setAccept_bank_addr(String accept_bank_addr) {
		this.accept_bank_addr = accept_bank_addr;
	}

	public String getAccept_memo()
	{
		return accept_memo;
	}

	public void setAccept_memo(String accept_memo)
	{
		this.accept_memo = accept_memo;
	}

	public String getRecord_memo()
	{
		return record_memo;
	}

	public void setRecord_memo(String record_memo)
	{
		this.record_memo = record_memo;
	}

	/**
	 * 获取银行卡类型名称
	 */
	public String getAccept_bank_type_name() {
		String accept_bank_type_name = (String) getConfig(SettlementBank.class, "bank_type_" + accept_bank_type);
		return accept_bank_type_name;
	}
}
