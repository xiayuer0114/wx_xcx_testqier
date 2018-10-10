package com.lymava.qier.model;

import java.util.List;
import java.util.Map;

import org.bson.types.ObjectId;

import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.pay.PayFinalVariable;
import com.lymava.commons.state.StatusCode;
import com.lymava.commons.util.HttpUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.context.SerializContext;
import com.lymava.nosql.util.QuerySort;
import com.lymava.qier.business.BusinessIntIdConfigQier;
import com.lymava.trade.base.model.Business;
import com.lymava.trade.pay.model.PaymentRecord;
import com.lymava.trade.pay.model.PaymentRecordOperationRecord;

public class User72 extends User{


	/**
	 * 是不是新用户     微信号和小程序不好直接以是不是第一次进入小程序判断,  独立一个字段来处理
	 */
	private Integer newUser;
	public static Integer newUser_true = StatusCode.ACCEPT_OK;   // 是新用户
	public static Integer newUser_false = StatusCode.ACCEPT_FALSE;  // 不是


	public Integer getNewUser() {
		return newUser;
	}

	public void setNewUser(Integer newUser) {
		this.newUser = newUser;
	}


	/**
	 * 改变自己为老用户
	 */
	public void chang_to_oldUser() {

		if(MyUtil.isValid(this.id)){

			User72 user72_update = new User72();
			user72_update.setNewUser(newUser_false);

			ContextUtil.getSerializContext().updateObject(id, user72_update);
		}
	}


	/**
	 * 由于奇葩原因 小程序的用户会和公众号的用户重复
	 *  重复原因
	 *  	用户先使用小程序	这时候获得了这个用户的  小程序的openid 和	unionid
	 *  	unionid用户 使用公众号	并且并未关注	这时候通过公众号的openid 创建了一个用户  并且没有openid
	 *  	
	 *  	如果用户关注之后 问题酒出来了。 两个unionid 相同的用户
	 */
	@Override
	public void check_repeat_and_all_in_one() {
		
			SerializContext serializContext = ContextUtil.getSerializContext();
			
			String third_user_id = this.getThird_user_id();
			String unionid = this.getUnionid();
			
			if(MyUtil.isEmpty(third_user_id)){
				return;
			}
			if(MyUtil.isEmpty(unionid)){
				return;
			}
				
			User user_find_chongfu = new User();
			user_find_chongfu.setUnionid(unionid);
				
			List<User> user_chongfu_list = serializContext.findAll(user_find_chongfu);
			
			if(user_chongfu_list == null || user_chongfu_list.size() <= 1){
				return;
			}
			//第一个是主账户
			User user_first = null;
			//找出主合并账户
			for (User user_tmp : user_chongfu_list) {
				if(this.getId().equals(user_tmp.getId())) {
					user_first = user_tmp;
					break;
				}
			}
			if(user_first == null) {
				//如果没有主合并用户返回
				return;
			}
			//移除主用户
			user_chongfu_list.remove(user_first);
				 
			for (User user_bei_hebing : user_chongfu_list) {
				//红包迁移
				MerchantRedEnvelope merchantRedEnvelope_find = new MerchantRedEnvelope();
				merchantRedEnvelope_find.setUserId_huiyuan(user_bei_hebing.getId());
				
				List<MerchantRedEnvelope> merchantRedEnvelope_list =  serializContext.findAll(merchantRedEnvelope_find);
				for(MerchantRedEnvelope merchantRedEnvelope_tmp:merchantRedEnvelope_list){
					
					MerchantRedEnvelope merchantRedEnvelope_update = new MerchantRedEnvelope();
					merchantRedEnvelope_update.setUserId_huiyuan(user_first.getId());
					
					serializContext.updateObject(merchantRedEnvelope_tmp.getId(), merchantRedEnvelope_update);
				}
				
				//交易记录迁移
				PaymentRecord paymentRecord_find = new PaymentRecord();
				paymentRecord_find.setUserId_huiyuan(user_bei_hebing.getId());
				
				List<PaymentRecord> paymentRecord_list =  serializContext.findAll(paymentRecord_find);
				for(PaymentRecord paymentRecord_tmp:paymentRecord_list){
					
					PaymentRecord paymentRecord_update = new PaymentRecord();
					paymentRecord_update.setUserId_huiyuan(user_first.getId());
					
					serializContext.updateObject(paymentRecord_tmp.getId(), paymentRecord_update);
				}
				
				Long user_first_balance = user_first.getBalance();
				if(user_first_balance == null) { user_first_balance =0l; }
				
				Long user_bei_hebing_balance = user_bei_hebing.getBalance();
				if(user_bei_hebing_balance == null) { user_bei_hebing_balance =0l; }
				
				if(user_bei_hebing_balance > 0) {
					//如果被合并的余额大于0 余额合并	并添加一条操作记录
					PaymentRecordOperationRecord paymentRecord = new PaymentRecordOperationRecord();
					
					paymentRecord.setId(new ObjectId().toString());
					paymentRecord.setRequestFlow(user_bei_hebing.getId());
					paymentRecord.setUser_huiyuan(user_first);
					paymentRecord.setPrice_pianyi_all(user_bei_hebing.getBalance());
					
					paymentRecord.setWallet_amount_balance_pianyi(user_bei_hebing_balance+user_first_balance);
					paymentRecord.setState(com.lymava.commons.state.State.STATE_OK);
					paymentRecord.setPay_method(PayFinalVariable.pay_method_balance);
					paymentRecord.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_user_hebing_hongbao);
					 
					serializContext.save(paymentRecord);
					
					Business.checkRequestFlow(paymentRecord);
					 
					user_first.balanceChange(user_bei_hebing_balance);
					
				}
				serializContext.removeByKey(user_bei_hebing);
			}
		
	}
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -4659115390545193013L;
	
	@Override
	public void parseBeforeSave(Map parameterMap) {
		
	}
	@Override
	public void parseBeforeSearch(Map parameterMap) {
		
		String sort_filed = HttpUtil.getParemater(parameterMap, "sort_filed");
		String sort_type_str = HttpUtil.getParemater(parameterMap, "sort_type");
		Integer sort_type = MathUtil.parseIntegerNull(sort_type_str);
		
		if(sort_type == null) {
			sort_type = QuerySort.desc;
		}
		if(!MyUtil.isEmpty(sort_filed) && !"-1".equals(sort_filed) ) {
			this.initQuerySort(sort_filed, sort_type);
		}
		
		String unionid = HttpUtil.getParemater(parameterMap, "unionid");
		
		if(!MyUtil.isEmpty(unionid)) {
			this.setUnionid(unionid);
		}
		
		String third_user_id = HttpUtil.getParemater(parameterMap, "third_user_id");
		
		if(!MyUtil.isEmpty(third_user_id)) {
			this.setThird_user_id(third_user_id);
		}
		
	}

}