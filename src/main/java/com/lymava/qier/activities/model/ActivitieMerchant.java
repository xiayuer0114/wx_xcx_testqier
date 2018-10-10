package com.lymava.qier.activities.model;

import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;
import com.lymava.qier.model.Merchant72;
import com.lymava.qier.util.SunmingUtil;

public class ActivitieMerchant extends BaseModel{

	static{
		Class<?> classTmp = ActivitieMerchant.class;
		putConfig(classTmp, "st_"+State.STATE_OK, "正常");
		putConfig(classTmp, "st_"+State.STATE_FALSE, "异常");
	}

	/**
	 * 商家的系统编号
	 */
	private String user_merchant_id;

	/**
	 * 商家实体
	 */
	private Merchant72 user_merchant72;

	/**
	 * 红包头像
	 */
	private String redEnvelope_headPic;

	/**
	 * 红包展示图片
	 */
	private String redEnvelope_pic;

	/**
	 * 标题
	 */
	private String redEnvelope_title;

	/**
	 * 简介
	 */
	private String redEnvelope_intro;

	/**
	 * 使用规则
	 */
	private String use_rule;

	/**
	 * 状态
	 */
	private Integer state;

	/**
	 * 活动的红包价格
	 */
	private Long activity_redEnvelope_price_fen;




		// show状态
	public String getShowState(){
		String state = (String)getConfig("st_"+this.state);
		if(state == null){
			state = "未知";
		}
		return state;
	}




	//  get/set

	public String getUser_merchant_id() {
		return user_merchant_id;
	}

	public void setUser_merchant_id(String user_merchant_id) {
		this.user_merchant_id = user_merchant_id;
	}

	public Merchant72 getUser_merchant72() {
		if(MyUtil.isValid(this.getUser_merchant_id())){
			Merchant72 merchant72_ret = (Merchant72) ContextUtil.getSerializContext().get(Merchant72.class, this.getUser_merchant_id());
			if(merchant72_ret != null){
				return merchant72_ret;
			}
		}
		return user_merchant72;
	}

	public void setUser_merchant72(Merchant72 user_merchant72) {

		if(user_merchant72 != null && MyUtil.isValid(user_merchant72.getId())){
			this.setUser_merchant_id(user_merchant72.getId());
		}

		this.user_merchant72 = user_merchant72;
	}

	public String getRedEnvelope_headPic() {
		return redEnvelope_headPic;
	}

	public void setRedEnvelope_headPic(String redEnvelope_headPic) {
		this.redEnvelope_headPic = redEnvelope_headPic;
	}

	public String getRedEnvelope_pic() {
		return redEnvelope_pic;
	}

	public void setRedEnvelope_pic(String redEnvelope_pic) {
		this.redEnvelope_pic = redEnvelope_pic;
	}

	public String getRedEnvelope_title() {
		return redEnvelope_title;
	}

	public void setRedEnvelope_title(String redEnvelope_title) {
		this.redEnvelope_title = redEnvelope_title;
	}

	public String getRedEnvelope_intro() {
		return redEnvelope_intro;
	}

	public void setRedEnvelope_intro(String redEnvelope_intro) {
		this.redEnvelope_intro = redEnvelope_intro;
	}

	public String getUse_rule() {
		return use_rule;
	}

	public void setUse_rule(String use_rule) {
		this.use_rule = use_rule;
	}

	public Integer getState() {
		return state;
	}

	public void setState(Integer state) {
		this.state = state;
	}

	public String getShowActivity_redEnvelope_price_yuan() {
		return SunmingUtil.longToStr_pianyi(activity_redEnvelope_price_fen,100L);
	}

	public void setInActivity_redEnvelope_price_yuan(Double activity_redEnvelope_price_fen) {
		this.activity_redEnvelope_price_fen = (long) (activity_redEnvelope_price_fen * 100);
	}
	public Long getActivity_redEnvelope_price_fen() {
		return activity_redEnvelope_price_fen;
	}

	public void setActivity_redEnvelope_price_fen(Long activity_redEnvelope_price_fen) {
		this.activity_redEnvelope_price_fen = activity_redEnvelope_price_fen;
	}
}