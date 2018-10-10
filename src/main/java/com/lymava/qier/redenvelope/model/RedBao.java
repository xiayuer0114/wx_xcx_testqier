package com.lymava.qier.redenvelope.model;

import com.lymava.qier.model.merchant.MerchantBankChangeRecord;

public class RedBao extends MerchantBankChangeRecord {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -1447276560720460253L;

	
	/**
	 * 会员
	 */
	private String huiyuan;
	/**
	 * 备注
	 */
	private String beizhu;
	
	
	
	public String getHuiyuan() {
		return huiyuan;
	}
	public void setHuiyuan(String huiyuan) {
		this.huiyuan = huiyuan;
	}
	public String getBeizhu() {
		return beizhu;
	}
	public void setBeizhu(String beizhu) {
		this.beizhu = beizhu;
	}
	
	
}
