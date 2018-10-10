package com.lymava.qier.manager.business;


import com.lymava.base.safecontroler.model.UserV2;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.util.HttpUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.nosql.context.SerializContext;
import com.lymava.qier.manager.model.ChangeRatioRecord;
import com.lymava.qier.manager.model.RedEnvelopeChangeRecord;
import com.lymava.qier.model.Merchant72;
import com.lymava.trade.base.model.Business;
import com.lymava.trade.base.model.BusinessRecord;
import com.lymava.trade.base.model.WriteBusiness;

import java.util.Map;

/***
 * 返利配置
 * @author lymava
 *
 */
public class ChangeRatioBusiness extends WriteBusiness<ChangeRatioRecord>{

	/**
	 * 
	 */
	private static final long serialVersionUID = 9191370854555747451L;

	@Override
	public ChangeRatioRecord initBusinessRecord() {
		return new ChangeRatioRecord();
	}

	@Override
	public Class<? extends BusinessRecord> getBusinessRecordClass() {
		return ChangeRatioRecord.class;
	}

	@Override
	public ChangeRatioRecord parseBusinessRecord(ChangeRatioRecord businessRecord, Map requestMap) {

		//获取参数
		Merchant72 merchant72 = (Merchant72) requestMap.get(Business.user_key);
		UserV2 userV2 = (UserV2) requestMap.get("userV2");
		String pinzheng = HttpUtil.getParemater(requestMap, "pinzheng");
		String ip = (String) requestMap.get(Business.ip_key);
		String requestFlow = (String) requestMap.get(Business.requestFlow_key);
		String transter_memo = HttpUtil.getParemater(requestMap, "transter_memo");

		String discount_ratio_str = HttpUtil.getParemater(requestMap, "user.inDiscount_ratio");
		String red_pack_ratio_max_str = HttpUtil.getParemater(requestMap, "user.inRed_pack_ratio_max");
		String red_pack_ratio_min_str = HttpUtil.getParemater(requestMap, "user.inRed_pack_ratio_min");
		String merchant_redenvelope_arrive_fen_str = HttpUtil.getParemater(requestMap, "user.inMerchant_redenvelope_arrive_yuan");
		String merchant_red_pack_ratio_str = HttpUtil.getParemater(requestMap, "user.merchant_red_pack_ratio");

		double discount_ratio_double = MathUtil.parseDouble(discount_ratio_str);
		discount_ratio_double = discount_ratio_double * ChangeRatioRecord.pianyi_5;
		double red_pack_ratio_max_double = MathUtil.parseDouble(red_pack_ratio_max_str);
		red_pack_ratio_max_double = red_pack_ratio_max_double * ChangeRatioRecord.pianyi_5;
		double red_pack_ratio_min_double = MathUtil.parseDouble(red_pack_ratio_min_str);
		red_pack_ratio_min_double = red_pack_ratio_min_double * ChangeRatioRecord.pianyi_5;
		double merchant_redenvelope_arrive_fen_double = MathUtil.parseDouble(merchant_redenvelope_arrive_fen_str);
		merchant_redenvelope_arrive_fen_double = merchant_redenvelope_arrive_fen_double *  ChangeRatioRecord.pianyi_2;
		double merchant_red_pack_ratio_double = MathUtil.parseDouble(merchant_red_pack_ratio_str);
		merchant_red_pack_ratio_double = merchant_red_pack_ratio_double * ChangeRatioRecord.pianyi_5;

		businessRecord.setDiscount_ratio((int) discount_ratio_double);
		businessRecord.setRed_pack_ratio_max((int) red_pack_ratio_max_double);
		businessRecord.setRed_pack_ratio_min((int) red_pack_ratio_min_double);
		businessRecord.setMerchant_redenvelope_arrive_fen((long) merchant_redenvelope_arrive_fen_double);
		businessRecord.setMerchant_red_pack_ratio((int) merchant_red_pack_ratio_double);

		//设置参数
		businessRecord.setMerchant72(merchant72);
		businessRecord.setMerchant72_id(merchant72.getId());
		businessRecord.setUserV2_submit(userV2);
		businessRecord.setIp(ip);
		businessRecord.setRequestFlow(requestFlow);
		businessRecord.setTranster_memo(transter_memo);
		businessRecord.setPinzheng(pinzheng);

		return businessRecord;
	}

	@Override
	public ChangeRatioRecord executeWriteBusiness(ChangeRatioRecord businessRecord) throws Exception{

		businessRecord.setState(ChangeRatioRecord.accept_shenhe_state_no);

		return businessRecord;
	}
	
	
}
