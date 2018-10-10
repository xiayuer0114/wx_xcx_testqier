package com.lymava.qier.model;

import com.lymava.base.model.User;
import com.lymava.commons.util.HttpUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.trade.pay.model.RefundRecord;

import java.util.Map;

/**
 * 
 * 支付退款记录
 * 
 * @author lymava
 *
 */
public class TradeRecord72RefundRecord extends RefundRecord {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -8247533143742317152L;
	/**
	 * 我们在商家预购的额度剩余	全偏移
	 */
	private Long merchant_balance;
	
	
	public Long getMerchant_balance() {
		return merchant_balance;
	}
	public void setMerchant_balance(Long merchant_balance) {
		this.merchant_balance = merchant_balance;
	}
	/**
	 * 显示用户余额 单位元
	 * @return
	 */
	public String getShowMerchant_balance() {
		return Double.toString(MathUtil.divide(this.getMerchant_balance(),User.pianyiYuan).doubleValue());
	}
	/**
	 * 显示用户余额 单位分
	 * @return
	 */
	public Long getMerchant_balanceFen() {
		return this.getMerchant_balance()/User.pianyiFen;
	}


	@Override
	public void parseBeforeSearch(Map parameterMap)
	{
		super.parseBeforeSearch(parameterMap);
	}
}
