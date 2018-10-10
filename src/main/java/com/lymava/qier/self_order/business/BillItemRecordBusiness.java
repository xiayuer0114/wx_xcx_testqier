package com.lymava.qier.self_order.business;

import com.lymava.qier.self_order.model.BillItemRecord;
import com.lymava.trade.base.model.Business;
import com.lymava.trade.base.model.BusinessRecord;

/**
 *  	账单单项记录
 * @author lymava
 *
 */
public class BillItemRecordBusiness extends Business<BillItemRecord>{ 

	/**
	 * 
	 */
	private static final long serialVersionUID = -3708801558173513884L;

	@Override
	public BillItemRecord initBusinessRecord() {
		return new BillItemRecord();
	}

	@Override
	public Class<? extends BusinessRecord> getBusinessRecordClass() {
		return BillItemRecord.class;
	}
	
}
