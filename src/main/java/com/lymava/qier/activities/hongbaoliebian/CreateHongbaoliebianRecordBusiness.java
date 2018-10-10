package com.lymava.qier.activities.hongbaoliebian;

import com.lymava.commons.exception.CheckException;
import com.lymava.commons.state.State;
import com.lymava.commons.util.HttpUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.qier.activities.qingliang.MerchantQingliangPaymentRecord;
import com.lymava.trade.base.model.BusinessRecord;
import com.lymava.trade.base.model.WriteBusiness;

import java.util.Map;

/**
 * 清凉计划业务类
 * @author lymava
 */
public class CreateHongbaoliebianRecordBusiness extends WriteBusiness<HongbaoliebianPaymentRecord>{


	/**
	 * 初始化一个交易记录
	 * @return
	 */
	@Override
	public HongbaoliebianPaymentRecord initBusinessRecord() {
		return new HongbaoliebianPaymentRecord();
	}
	/**
	 * 获取交易记录的类
	 * @return
	 */
	public Class<? extends BusinessRecord> getBusinessRecordClass() {
		return HongbaoliebianPaymentRecord.class;
	}  
	 
	@Override
	public HongbaoliebianPaymentRecord parseBusinessRecord(HongbaoliebianPaymentRecord businessRecord, Map requestMap) {
		
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

		String activitieRedEnvelope_id = HttpUtil.getParemater(requestMap,"activitieRedEnvelope_id");
		if(MyUtil.isValid(activitieRedEnvelope_id)) {
			businessRecord.setActivitie_redEnvelope_id(activitieRedEnvelope_id);
		}

		String source_paymentRecord_id = HttpUtil.getParemater(requestMap,"source_paymentRecord_id");
		if(MyUtil.isValid(source_paymentRecord_id)) {
			businessRecord.setSourceRecord_id(source_paymentRecord_id);
		}


		return businessRecord;
	}
	 
	@Override
	public HongbaoliebianPaymentRecord executeWriteBusiness(HongbaoliebianPaymentRecord businessRecord)
			throws Exception {



		return null;
	}  
}
