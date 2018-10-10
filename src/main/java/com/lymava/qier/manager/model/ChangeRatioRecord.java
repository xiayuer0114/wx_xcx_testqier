package com.lymava.qier.manager.model;

import com.lymava.base.safecontroler.model.UserV2;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.MyUtil;
import com.lymava.qier.model.Merchant72;
import com.lymava.trade.base.model.BusinessRecord;

import java.util.Map;

/**
 * 转款给商户的转款记录
 * @author lymava
 *
 */
public class ChangeRatioRecord extends BusinessRecord
{
	/**
	 *
	 */
	private static final long serialVersionUID = -6938646403893422127L;
	
	/**
	 * 提交管理员
	 */
	private UserV2 userV2_submit;
	/**
	 * 提交管理员
	 */
	private String userV2_submit_id;
	/**
	 * 审核管理员
	 */
	private UserV2 userV2_shenghe;
	/**
	 * 审核管理员
	 */
	private String userV2_shenghe_id;
	/**
	 * 返利的商家
	 */
	private Merchant72 merchant72;
	/**
	 * 返利的商家id
	 */
	private String merchant72_id;
	/**
	 * 转账凭证图片String
	 */
	private String pinzheng;
	/**
	 * 备注
	 */
	private String transter_memo;

	/**
	 * 商户折扣比例	偏移分
	 *
	 * 1 代表0.01%
	 */
	private Integer discount_ratio;
	/**
	 * 红包最大发放比例	偏移4位
	 * 1 代表0.01%
	 */
	private Integer red_pack_ratio_max;
	/**
	 * 红包最小发放比例	偏移4位
	 * 1 代表0.01%
	 */
	private Integer red_pack_ratio_min;
	/**
	 * 通用红包最大发放比例	偏移4位
	 * 1 代表0.01%
	 */
	private Integer merchant_red_pack_ratio;
	/**
	 * 比如商家红包到达这个之后就开始检测并生成红包
	 * 	放在红包库里
	 * 		单位分
	 */
	private Long merchant_redenvelope_arrive_fen;

	public static final int pianyi_5 = 10000;
	public static final int pianyi_2 = 100;


	public static final Integer accept_shenhe_state_no = State.STATE_OK;			//审核状态 - 未审核
	public static final Integer accept_shenhe_state_fail = State.STATE_FALSE;		//审核状态 - 审核失败
	public static final Integer accept_shenhe_state_complete = State.STATE_INPROCESS;	//审核状态 - 已变更


	public UserV2 getUserV2_submit() {
		if (userV2_submit == null && MyUtil.isValid(this.userV2_submit_id)) {
			userV2_submit = (UserV2) ContextUtil.getSerializContext().get(UserV2.class, userV2_submit_id);
		}
		return userV2_submit;
	}
	public void setUserV2_submit(UserV2 userV2_submit) {
		if (userV2_submit != null) {
			userV2_submit_id = userV2_submit.getId();
		}
		this.userV2_submit = userV2_submit;
	}
	public String getUserV2_submit_id() {
		return userV2_submit_id;
	}
	public void setUserV2_submit_id(String userV2_submit_id) {
		this.userV2_submit_id = userV2_submit_id;
	}
	public UserV2 getUserV2_shenghe() {
		if (userV2_shenghe == null && MyUtil.isValid(this.userV2_shenghe_id)) {
			userV2_shenghe = (UserV2) ContextUtil.getSerializContext().get(UserV2.class, userV2_shenghe_id);
		}
		return userV2_shenghe;
	}
	public void setUserV2_shenghe(UserV2 userV2_shenghe) {
		if (userV2_shenghe != null) {
			userV2_shenghe_id = userV2_shenghe.getId();
		} 
		this.userV2_shenghe = userV2_shenghe;
	}
	public String getUserV2_shenghe_id() {
		return userV2_shenghe_id;
	}
	public void setUserV2_shenghe_id(String userV2_shenghe_id) {
		this.userV2_shenghe_id = userV2_shenghe_id;
	}
	public String getUserV2Id() {
		return userV2_submit_id;
	}
	public UserV2 getUserV2() {
		return this.getUserV2_submit();
	}
	public Merchant72 getMerchant72() {
		if (merchant72 == null && MyUtil.isValid(this.merchant72_id)) {
			merchant72 = (Merchant72) ContextUtil.getSerializContext().get(Merchant72.class, merchant72_id);
		}
		return merchant72;
	}
	public void setMerchant72(Merchant72 merchant72) {
		if (merchant72!=null && merchant72.getId()!=null){
			this.setMerchant72_id(merchant72.getId());
		}
		this.merchant72 = merchant72;
	}

	public String getMerchant72_id()
	{
		return merchant72_id;
	}

	public void setMerchant72_id(String merchant72_id)
	{
		this.merchant72_id = merchant72_id;
	}

	public String getPinzheng()
	{
		return pinzheng;
	}

	public void setPinzheng(String pinzheng)
	{
		this.pinzheng = pinzheng;
	}

	public String getTranster_memo()
	{
		return transter_memo;
	}

	public void setTranster_memo(String transter_memo)
	{
		this.transter_memo = transter_memo;
	}

	public Integer getDiscount_ratio()
	{
		return discount_ratio;
	}

	public void setDiscount_ratio(Integer discount_ratio)
	{
		this.discount_ratio = discount_ratio;
	}

	public Integer getRed_pack_ratio_max()
	{
		return red_pack_ratio_max;
	}

	public void setRed_pack_ratio_max(Integer red_pack_ratio_max)
	{
		this.red_pack_ratio_max = red_pack_ratio_max;
	}

	public Integer getRed_pack_ratio_min()
	{
		return red_pack_ratio_min;
	}

	public void setRed_pack_ratio_min(Integer red_pack_ratio_min)
	{
		this.red_pack_ratio_min = red_pack_ratio_min;
	}

	public Integer getMerchant_red_pack_ratio()
	{
		return merchant_red_pack_ratio;
	}

	public void setMerchant_red_pack_ratio(Integer merchant_red_pack_ratio)
	{
		this.merchant_red_pack_ratio = merchant_red_pack_ratio;
	}

	public Long getMerchant_redenvelope_arrive_fen()
	{
		return merchant_redenvelope_arrive_fen;
	}

	public void setMerchant_redenvelope_arrive_fen(Long merchant_redenvelope_arrive_fen)
	{
		this.merchant_redenvelope_arrive_fen = merchant_redenvelope_arrive_fen;
	}

	@Override
	public void parseBeforeSearch(Map parameterMap)
	{
		super.parseBeforeSearch(parameterMap);
	}
}
