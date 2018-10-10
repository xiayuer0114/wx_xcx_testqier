package com.lymava.qier.self_order.model;

import com.lymava.trade.business.model.Product;
import com.lymava.trade.business.model.TradeRecord;

/**
 * 菜品/食物
 * @author lymava
 *
 */
public class ProductFood extends Product{

	/**
	 * 
	 */
	private static final long serialVersionUID = -5620854668718551599L;

	@Override
	public TradeRecord createNewTradeRecord() {
		return new BillItemRecord();
	}
	
}
