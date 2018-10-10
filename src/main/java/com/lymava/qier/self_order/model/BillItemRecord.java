package com.lymava.qier.self_order.model;

import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.MyUtil;
import com.lymava.trade.business.model.TradeRecord;
import com.lymava.trade.pay.model.PaymentRecord;

/**
 * 	账单单项记录
 * @author lymava
 *
 */
public class BillItemRecord extends TradeRecord{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1721812766000439737L;
	/**
	 * 主订单记录
	 */
	private PaymentRecord paymentRecord;
	/**
	 * 主订单记录	系统编号
	 */
	private String paymentRecord_id;
	
	public PaymentRecord getPaymentRecord() {
		if(paymentRecord == null && MyUtil.isValid(this.paymentRecord_id)) {
			paymentRecord = (PaymentRecord) ContextUtil.getSerializContext().get(PaymentRecord.class, paymentRecord_id);
		}
		return paymentRecord;
	}
	public void setPaymentRecord(PaymentRecord paymentRecord) {
		if(paymentRecord != null) {
			paymentRecord_id = paymentRecord.getId();
		}
		this.paymentRecord = paymentRecord;
	}
	public String getPaymentRecord_id() {
		return paymentRecord_id;
	}
	public void setPaymentRecord_id(String paymentRecord_id) {
		this.paymentRecord_id = paymentRecord_id;
	}   

	static{
		putConfig(BillItemRecord.class, "state_"+State.STATE_OK, "已上菜");
		putConfig(BillItemRecord.class, "state_"+State.STATE_WAITE_PROCESS, "等待确认");
		putConfig(BillItemRecord.class, "state_"+State.STATE_INPROCESS, "已下厨");
		putConfig(BillItemRecord.class, "state_"+State.STATE_CLOSED, "已取消");
	}
	
	@Override
	public Class<?> getConfigClass() {
		return BillItemRecord.class;
	} 
	
}
