package com.lymava.qier.self_order.model;

import java.util.List;

import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.context.SerializContext;
import com.lymava.trade.business.model.Product;
import com.lymava.trade.business.model.TradeRecord;

/**
 * 	账单的主订单
 * @author lymava
 *
 */
public class BillMainRecord extends TradeRecord{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1721812766000439737L;
	
	static{
		putConfig(BillMainRecord.class, "state_"+State.STATE_OK, "已清台");
		putConfig(BillMainRecord.class, "state_"+State.STATE_INPROCESS, "用餐中");
	}
	
	@Override
	public Class<?> getConfigClass() {
		return BillMainRecord.class;
	}
	/**
	 * 已经支付的金额
	 * 	正数为收入
	 * 	负数为支出
	 */
	private Integer price_fen_had_pay;
	/**
	 * 用餐人数
	 */
	private Integer yongcan_renshu;
	
	public Integer getPrice_fen_had_pay() {
		return price_fen_had_pay;
	}
	public void setPrice_fen_had_pay(Integer price_fen_had_pay) {
		this.price_fen_had_pay = price_fen_had_pay;
	}
	
	public Integer getYongcan_renshu() {
		return yongcan_renshu;
	}
	public void setYongcan_renshu(Integer yongcan_renshu) {
		this.yongcan_renshu = yongcan_renshu;
	}
	@Override
	public TradeRecord getFinalBusinessRecord(){
		return this;
	}
	
	private List<BillItemRecord> billItemRecords_list = null;
	
	public List<BillItemRecord> getBillItemRecordList(){
		
		if(!MyUtil.isValid(this.getId())) {
			return null;
		}
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		BillItemRecord billItemRecord_find = new BillItemRecord();
		billItemRecord_find.setPaymentRecord(this);
		
		billItemRecords_list = serializContext.findAll(billItemRecord_find);
		
		return billItemRecords_list;
	}
	/**
	 * 
	 * @return
	 */
	public Long getBill_item_count_fen() {
		
		Long bill_item_count_fen = 0l;
		
		List<BillItemRecord> billItemRecords_list_tmp = getBillItemRecordList();
		
		if(billItemRecords_list != null) {
			
			for (BillItemRecord billItemRecord : billItemRecords_list_tmp) {
				
				Long quantity_fen = billItemRecord.getQuantity();
				
				if(quantity_fen == null) { quantity_fen = 0l; }
				
				bill_item_count_fen += quantity_fen;
			}
		}
		
		return bill_item_count_fen;
	}
	public Long getBill_price_fen_all() {
		
		List<BillItemRecord> billItemRecords_list_tmp = getBillItemRecordList();
		
		Long bill_price_fen_all = 0l;
		
		for (BillItemRecord billItemRecord_tmp : billItemRecords_list_tmp) {
			bill_price_fen_all += billItemRecord_tmp.getPrice_fen_all();
		}
		
		return Math.abs(bill_price_fen_all);
	}
	
	
}
