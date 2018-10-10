package com.lymava.qier.model;

import java.util.Map;

import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.context.SerializContext;

public class Cashier extends User {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7447358896355176431L;

	@Override
	public void parseBeforeSave(Map parameterMap) {

	}

	@Override
	public void parseBeforeSearch(Map parameterMap) {

	}

	private Merchant72 merchant72_tmp;

	public Merchant72 getMerchant72() {

		String topUserId_tmp = this.getTopUserId();

		if (merchant72_tmp == null && MyUtil.isValid(topUserId_tmp)) {
			SerializContext serializContext = ContextUtil.getSerializContext();
			merchant72_tmp = (Merchant72) serializContext.findOne(Merchant72.class, topUserId_tmp);
		}

		return merchant72_tmp;
	}

	public String getPicname() {

		String picname = null;

		Merchant72 merchant72 = getMerchant72();

		if (merchant72 != null) {
			picname = merchant72.getPicname();
		}

		return picname;
	}

	public Integer getQueryHour() {
		Integer queryHour = 0;

		Merchant72 merchant72 = getMerchant72();

		if (merchant72 != null) {
			queryHour = merchant72.getQueryHour();
		}

		return queryHour;
	}

	public Integer getPrint_count() {
		Integer print_count = 1;

		Merchant72 merchant72 = getMerchant72();

		if (merchant72 != null) {
			print_count = merchant72.getPrint_count();
		}

		return print_count;
	}

	public Merchant72 getMerchant72_tmp() {
		return merchant72_tmp;
	}

	public void setMerchant72_tmp(Merchant72 merchant72_tmp) {
		this.merchant72_tmp = merchant72_tmp;
	}

}
