package com.lymava.qier.activities.qingliang;

import java.util.Map;

import com.lymava.commons.exception.CheckException;
import com.lymava.commons.state.State;
import com.lymava.commons.util.HttpUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.trade.base.model.BusinessRecord;
import com.lymava.trade.base.model.WriteBusiness;

/**
 * 清凉计划业务类
 * @author lymava
 */
public class MerchantQingliangPaymentBusiness  extends WriteBusiness<MerchantQingliangPaymentRecord>{ 
	/**
	 * 
	 */
	private static final long serialVersionUID = 1522629618403400292L;

	/**
	 * 初始化一个交易记录
	 * @return
	 */
	@Override
	public MerchantQingliangPaymentRecord initBusinessRecord() {
		return new MerchantQingliangPaymentRecord();
	}
	/**
	 * 获取交易记录的类
	 * @return
	 */
	public Class<? extends BusinessRecord> getBusinessRecordClass() {
		return MerchantQingliangPaymentRecord.class;
	}  
	 
	@Override
	public MerchantQingliangPaymentRecord parseBusinessRecord(MerchantQingliangPaymentRecord businessRecord, Map requestMap) {
		
		//创建支付订单
		String price_fen_str = HttpUtil.getParemater(requestMap,"price_fen");
		Long price_fen = MathUtil.parseLongNull(price_fen_str);
		
		CheckException.checkIsTure(price_fen != null && price_fen > 0, "支付金额必须大于0");
		
		//商户编号
		String userId_merchant = HttpUtil.getParemater(requestMap,"userId_merchant");
		
		businessRecord.setState(State.STATE_WAITE_PAY);
		
		businessRecord.setPrice_fen_all(-price_fen);
		if(MyUtil.isValid(userId_merchant)) {
			businessRecord.setUserId_merchant(userId_merchant);
		}
		
		
		return businessRecord;
	}
	 
	@Override
	public MerchantQingliangPaymentRecord executeWriteBusiness(MerchantQingliangPaymentRecord businessRecord)
			throws Exception {
		return null;
	}  
}
