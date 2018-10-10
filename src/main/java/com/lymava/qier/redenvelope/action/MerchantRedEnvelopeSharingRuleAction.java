package com.lymava.qier.redenvelope.action;

import java.text.ParseException;
import java.util.Date;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.base.safecontroler.model.UserV2;
import com.lymava.base.util.FinalVariable;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.model.SerializModel;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.qier.redenvelope.model.MerchantRedEnvelopeSharingRule;

/**
 * 红包发放规则action
 * @author 黄诗晴
 *
 */
@AcceptUrlAction(path="v2/MerchantRedEnvelopeSharingRule/", name="红包共享规则")
public class MerchantRedEnvelopeSharingRuleAction extends LazyBaseAction{
	/**
	 * 
	 */
	private static final long serialVersionUID = 6105270834155575576L;
	
	
	@Override
	protected Class<? extends SerializModel> getObjectClass() {
		return MerchantRedEnvelopeSharingRule.class; 
	}
	/**
	 * 查找之前的条件设置
	 */
	@Override
	protected void listParse(Object object_find) {
		
		MerchantRedEnvelopeSharingRule merchantRedEnvelopeSharingRule_find=(MerchantRedEnvelopeSharingRule) object_find;
		
		String user_merchant_xiaofei_id=this.getParameter("object.user_merchant_xiaofei_id");
		String user_merchant_gongxiang_id=this.getParameter("object.user_merchant_gongxiang_id");
		String state=this.getParameter("object.state");
		
		String start_time_shengxiao_str=this.getParameter("object.start_time_shengxiao_str");
		String end_time_shengxiao_str=this.getParameter("object.end_time_shengxiao_str");

		if(!MyUtil.isEmpty(user_merchant_xiaofei_id)) {
			merchantRedEnvelopeSharingRule_find.setUser_merchant_xiaofei_id(user_merchant_xiaofei_id);
		}
		/*if(!MyUtil.isEmpty(user_merchant_gongxiang_id)) {
			MerchantRedEnvelopeSharingRule.setUser_merchant_gongxiang_id(user_merchant_gongxiang_id);
		}*/
		
		//如果查找的时候不限就不设置state
		if(!MyUtil.isEmpty(state) && !state.equals("-1")) {
			merchantRedEnvelopeSharingRule_find.setState(MathUtil.parseIntegerNull(state));;
		}
		
		/** 
		 * 根据时间搜索
		 * 
		 * */
		if(!MyUtil.isEmpty(start_time_shengxiao_str)) {
			 Long start_time_shengxiao = null ;
			 Date date = null;
		        try {
		            date = DateUtil.getSdfFull().parse(start_time_shengxiao_str);
		           start_time_shengxiao = date.getTime();
		        } catch (ParseException e) {
		        }
		    merchantRedEnvelopeSharingRule_find.addCommand(MongoCommand.dayuAndDengyu,"start_time_shengxiao", start_time_shengxiao.longValue());
		}
		
		if(!MyUtil.isEmpty(end_time_shengxiao_str)) {
			 Long end_time_shengxiao = null ;
			 Date date = null;
		        try {
		        	
		            date = DateUtil.getSdfFull().parse(end_time_shengxiao_str);
		            end_time_shengxiao = date.getTime();
		        } catch (ParseException e) {
		        }
		        merchantRedEnvelopeSharingRule_find.addCommand(MongoCommand.xiaoyuAndDengyu,"end_time_shengxiao", end_time_shengxiao.longValue());
		}
	}
	
}

