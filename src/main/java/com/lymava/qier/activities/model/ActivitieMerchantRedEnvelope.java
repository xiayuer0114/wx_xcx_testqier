package com.lymava.qier.activities.model;

import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.nosql.mongodb.vo.BaseModel;
import com.lymava.qier.activities.hongbaoliebian.HongbaoliebianPaymentRecord;
import com.lymava.qier.business.BusinessIntIdConfigQier;
import com.lymava.qier.model.Merchant72;
import com.lymava.qier.model.MerchantRedEnvelope;
import com.lymava.qier.model.TradeRecord72;
import com.lymava.qier.model.User72;
import com.lymava.qier.util.SunmingUtil;
import com.lymava.trade.pay.model.PaymentRecordOperationRecord;
import com.mongodb.BasicDBList;
import com.mongodb.BasicDBObject;

import java.text.ParseException;
import java.util.Date;

/**
 * 商家的活动红包
 * @author sunm
 *
 */
public class ActivitieMerchantRedEnvelope extends BaseModel {

	static{
		Class<?> classTmp = ActivitieMerchantRedEnvelope.class;
		putConfig(classTmp, "st_"+State.STATE_OK, "正常");
		putConfig(classTmp, "st_"+State.STATE_WAITE_CHANGE, "等待支付");
		putConfig(classTmp, "st_"+State.STATE_ALL_IN_ONE_PAY_SUCCESS, "等待好友支付");
		putConfig(classTmp, "st_"+State.STATE_PAY_SUCCESS, "付款成功");
		putConfig(classTmp, "st_"+State.STATE_FALSE, "异常");
	}


	/**
	 * 活动的红包名字
	 */
	private String activity_redEnvelope_name;

	/**
	 * 红包的系统编号
	 */
	private String redEnvelope_id;

	/**
	 * 红包的实体
	 */
	private MerchantRedEnvelope merchantRedEnvelope;

	/**
	 * 微信openid
	 */
	private String open_id;

	/**
	 * 用户的系统编号
	 */
	private String user_id;

	/**
	 * 用户的实体
	 */
	private User72 user72;

	/**
	 * 商家的系统编号
	 */
	private String merchant_user_id;

	/**
	 * 商家的实体
	 */
	private Merchant72 merchant72;

	/**
	 * 活动商家的系统编号
	 */
	private String activitie_merchant_user_id;

	/**
	 * 活动商家的实体
	 */
	private ActivitieMerchant activitieMerchant;

	/**
	 * 状态
	 */
	private Integer state;

	/**
	 * 上级订单 系统编号
	 */
	private String super_paymentRecord_id;

	/**
	 * 上级订单实体
	 */
	private HongbaoliebianPaymentRecord paymentRecord;

	/**
	 * 分享的时间
	 */
	private Long shareTime;

	/**
	 * 好有点开分享的时间
	 */
	private Long haoyouClickTime;



		// show状态
	public String getShowState(){
		String state = (String)getConfig("st_"+this.state);
		if(state == null){
			state = "未知";
		}
		return state;
	}





	// get / set


	public Long getShareTime() {
		return shareTime;
	}

	public void setShareTime(Long shareTime) {
		this.shareTime = shareTime;
	}

	public Long getHaoyouClickTime() {
		return haoyouClickTime;
	}

	public void setHaoyouClickTime(Long haoyouClickTime) {
		this.haoyouClickTime = haoyouClickTime;
	}

	public String getSuper_paymentRecord_id() {
		return super_paymentRecord_id;
	}

	public void setSuper_paymentRecord_id(String super_paymentRecord_id) {
		this.super_paymentRecord_id = super_paymentRecord_id;
	}

	public HongbaoliebianPaymentRecord getPaymentRecord() {

		if(MyUtil.isValid(this.getSuper_paymentRecord_id())){
			HongbaoliebianPaymentRecord hongbaoliebianPaymentRecord = (HongbaoliebianPaymentRecord )ContextUtil.getSerializContext().get(HongbaoliebianPaymentRecord.class, this.getSuper_paymentRecord_id());
			if(hongbaoliebianPaymentRecord != null){
				return  hongbaoliebianPaymentRecord;
			}
		}

		return paymentRecord;
	}

	public void setPaymentRecord(HongbaoliebianPaymentRecord paymentRecord) {
		if (paymentRecord != null && MyUtil.isValid(paymentRecord.getId())){
			this.super_paymentRecord_id = paymentRecord.getId();
		}

		this.paymentRecord = paymentRecord;
	}

	public String getRedEnvelope_id() {
		return redEnvelope_id;
	}

	public void setRedEnvelope_id(String redEnvelope_id) {
		this.redEnvelope_id = redEnvelope_id;
	}

	public MerchantRedEnvelope getMerchantRedEnvelope() {
		if(MyUtil.isValid(this.getRedEnvelope_id())){
			MerchantRedEnvelope merchantRedEnvelope = (MerchantRedEnvelope )ContextUtil.getSerializContext().get(MerchantRedEnvelope.class, this.getRedEnvelope_id());
			if(merchantRedEnvelope != null){
				return  merchantRedEnvelope;
			}
		}
		return merchantRedEnvelope;
	}

	public void setMerchantRedEnvelope(MerchantRedEnvelope merchantRedEnvelope) {
		if (merchantRedEnvelope != null && MyUtil.isValid(merchantRedEnvelope.getId())){
			this.redEnvelope_id = merchantRedEnvelope.getId();
		}
		this.merchantRedEnvelope = merchantRedEnvelope;
	}

	public String getActivity_redEnvelope_name() {
		return activity_redEnvelope_name;
	}

	public void setActivity_redEnvelope_name(String activity_redEnvelope_name) {
		this.activity_redEnvelope_name = activity_redEnvelope_name;
	}

	public String getOpen_id() {
		return open_id;
	}

	public void setOpen_id(String open_id) {
		this.open_id = open_id;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public User72 getUser72() {
		User72 user72 = new User72();

		if(MyUtil.isValid(this.getUser_id()) ){
			user72.setId(this.getUser_id());
			user72 = (User72) ContextUtil.getSerializContext().get(user72);
			if(user72 == null && !MyUtil.isEmpty(this.getOpen_id())){
				user72 = new User72();
				user72.setThird_user_id(this.getOpen_id());
				user72 = (User72) ContextUtil.getSerializContext().get(user72);
			}
		}
		return user72;
	}

	public void setUser72(User72 user72) {
		if(user72 != null ){
			this.user_id = user72.getId();
			this.open_id = user72.getThird_user_id();
		}
		this.user72 = user72;
	}

	public String getMerchant_user_id() {
		return merchant_user_id;
	}

	public void setMerchant_user_id(String merchant_user_id) {
		this.merchant_user_id = merchant_user_id;
	}

	public void setInMerchant_user_id(String merchant_user_id) {
		if(MyUtil.isValid(merchant_user_id)){
			ActivitieMerchant activitieMerchat = new ActivitieMerchant();
			activitieMerchat.setUser_merchant_id(merchant_user_id);
			activitieMerchat = (ActivitieMerchant) ContextUtil.getSerializContext().get(activitieMerchat);

			CheckException.checkIsTure(activitieMerchat != null, "该商家不是活动商家");
			this.setActivitie_merchant_user_id(activitieMerchat.getId());
		}
		this.merchant_user_id = merchant_user_id;
	}

	public Merchant72 getMerchant72() {
		if(MyUtil.isValid(this.getMerchant_user_id())){
			Merchant72 merchant72 = (Merchant72)ContextUtil.getSerializContext().get(Merchant72.class, this.getMerchant_user_id());
			if(merchant72 != null){
				return merchant72;
			}
		}
		return merchant72;
	}

	public void setMerchant72(Merchant72 merchant72) {
		if(merchant72 != null && MyUtil.isValid(merchant72.getId())){
			this.merchant_user_id = merchant72.getId();
		}
		this.merchant72 = merchant72;
	}

	public Integer getState() {
		return state;
	}

	public void setState(Integer state) {
		this.state = state;
	}

	public String getActivitie_merchant_user_id() {
		return activitie_merchant_user_id;
	}

	public void setActivitie_merchant_user_id(String activitie_merchant_user_id) {
		this.activitie_merchant_user_id = activitie_merchant_user_id;
	}

	public ActivitieMerchant getActivitieMerchant() {
		if(MyUtil.isValid(this.getActivitie_merchant_user_id())){
			ActivitieMerchant activitieMerchant = (ActivitieMerchant) ContextUtil.getSerializContext().get(ActivitieMerchant.class, this.getActivitie_merchant_user_id());
			if(activitieMerchant!=null){
				return activitieMerchant;
			}
		}

		return activitieMerchant;
	}

	public void setActivitieMerchant(ActivitieMerchant activitieMerchant) {
		if(activitieMerchant != null && MyUtil.isValid(activitieMerchant.getId())){
			this.activitie_merchant_user_id = activitieMerchant.getId();
		}
		this.activitieMerchant = activitieMerchant;
	}
}
