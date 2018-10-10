package com.lymava.qier.self_order.business;

import com.lymava.qier.self_order.model.BillMainRecord;
import com.lymava.trade.base.model.Business;
import com.lymava.trade.base.model.BusinessRecord;

/**
 *  账单的主订单
 * @author lymava
 *
 */
public class BillMainRecordBusiness extends Business<BillMainRecord>{
	/**
	 * 
	 */
	private static final long serialVersionUID = 4390268997749845437L;

	@Override
	public BillMainRecord initBusinessRecord() {
		return new BillMainRecord();
	}

	@Override
	public Class<? extends BusinessRecord> getBusinessRecordClass() {
		return BillMainRecord.class;
	}
	
}
