package com.lymava.qier.cmbpay.model;

import java.util.HashMap;
import java.util.Map;

import com.lymava.base.safecontroler.model.UserV2;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.util.HttpUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.qier.business.BusinessIntIdConfigQier;
import com.lymava.qier.model.Merchant72;
import com.lymava.qier.model.SettlementBank;
import com.lymava.trade.base.context.BusinessContext;
import com.lymava.trade.base.model.Business;
import com.lymava.trade.pay.model.PaymentRecord;
/**
 * 转款给商户的转款记录
 * @author lymava
 *
 */
public class TransferToMerchantRecord extends PaymentRecord {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6938646403893422127L;
	
	/**
	 * 处理管理员
	 */
	private UserV2 userV2;
	/**
	 * 处理管理员
	 */
	private String userV2Id;

	public String getUserV2Id() {
		return userV2Id;
	}

	public void setUserV2Id(String userV2Id) {
		this.userV2Id = userV2Id;
	}

	public UserV2 getUserV2() {
		if (userV2 == null && MyUtil.isValid(this.userV2Id)) {
			userV2 = (UserV2) ContextUtil.getSerializContext().get(UserV2.class, userV2Id);
		}
		return userV2;
	}

	public void setUserV2(UserV2 userV2) {
		if (userV2 != null) {
			userV2Id = userV2.getId();
		}
		this.userV2 = userV2;
	}
	/**
	 * 付款银行帐号
	 */
	private String pay_account_no = null;
	/**
	 * 帐号 银行卡号 支付宝/微信账号
	 */
	private String accept_account = null;
	/**
	 * 银行卡类型
	 */
	private Integer accept_bank_type;
	/**
	 * 账户名称 公司名称/个人名称
	 */
	private String accept_name = null;
	/**
	 * 收款方 开户行
	 */
	private String accept_depositary_bank = null;
	/**
	 * 收款方 开户行地址
	 */
	private String accept_bank_addr = null;
	/**
	 * 如果手动打款就必须有凭证
	 */
	public String pinzheng = null;
	/**
	 * 营销金额
	 */
	public Long yingxiao_price_fen;
	/**
	 * 预付款变动金额
	 */
	public Long yufukuan_price_fen;
	
	public String getShowBank_type() {
		String config_key =  "bank_type_"+this.getAccept_bank_type();
		return (String) getConfig(SettlementBank.class, config_key);
	}


	public Long getYingxiao_price_fen() {
		return yingxiao_price_fen;
	}
	public void setYingxiao_price_fen(Long yingxiao_price_fen) {
		this.yingxiao_price_fen = yingxiao_price_fen;
	}
	public Long getYufukuan_price_fen() {
		return yufukuan_price_fen;
	}
	public void setYufukuan_price_fen(Long yufukuan_price_fen) {
		this.yufukuan_price_fen = yufukuan_price_fen;
	}
	public Integer getAccept_bank_type() {
		return accept_bank_type;
	}
	public void setAccept_bank_type(Integer accept_bank_type) {
		this.accept_bank_type = accept_bank_type;
	}

	public String getPay_account_no() {
		return pay_account_no;
	}

	public void setPay_account_no(String pay_account_no) {
		this.pay_account_no = pay_account_no;
	}

	public String getAccept_account() {
		return accept_account;
	}

	public void setAccept_account(String accept_account) {
		this.accept_account = accept_account;
	}

	public String getAccept_name() {
		return accept_name;
	}

	public void setAccept_name(String accept_name) {
		this.accept_name = accept_name;
	}
	public String getPinzheng() {
		return pinzheng;
	}

	public void setPinzheng(String pinzheng) {
		this.pinzheng = pinzheng;
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
	
	private Merchant72 merchant72;
	
	public Merchant72 getMerchant72() {
		if (merchant72 == null && MyUtil.isValid(this.getUserId_huiyuan())) {
			merchant72 = (Merchant72) ContextUtil.getSerializContext().get(Merchant72.class, this.getUserId_huiyuan());
		}
		return merchant72;
	}
	
	/**
	 * 支付成功回调
	 */
	public void pay_success_notify_back() {
		
		BusinessContext instance = BusinessContext.getInstance();
		
		Business<TransferToMerchantRecord> business = instance.getBusiness(BusinessIntIdConfigQier.businessIntId_transfer_to_merchant_change);
		
		CheckException.checkIsTure(business != null, "商户备付金变动业务未配置!");
		
		Map requestMap = new HashMap();
		
		requestMap.put(Business.user_key, this.getMerchant72());
		requestMap.put(Business.requestFlow_key, this.getId());
		requestMap.put("paymentRecord", this);
		
		business.executeBusiness(requestMap);
		
	}


	@Override
	public void parseBeforeSearch(Map parameterMap)
	{
		//设置查找条件：系统编号
		String id = HttpUtil.getParemater(parameterMap, "id");
		
		if (!MyUtil.isEmpty(id)) {
			this.setId(id);
		}

		super.parseBeforeSearch(parameterMap);
	}
}
