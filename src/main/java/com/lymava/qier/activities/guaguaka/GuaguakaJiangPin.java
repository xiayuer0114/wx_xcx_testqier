package com.lymava.qier.activities.guaguaka;

import java.util.List;

import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.base.util.WebConfigContent;
import com.lymava.commons.state.State;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;
import com.lymava.qier.model.Merchant72;
import com.lymava.qier.model.MerchantRedEnvelope;
import com.lymava.qier.model.User72;
import com.lymava.wechat.gongzhonghao.SubscribeUser;

/**
 * JAY迷刮刮卡
 * @author lymava
 *
 */
public class GuaguakaJiangPin extends BaseModel{ 

	/**
	 * 
	 */
	private static final long serialVersionUID = 3754837632537770431L;
	/**
	 * 用户的openid
	 */
	private String openid;  
	/**
	 * 通用红包1
	 */
	public static final Integer type_jiangpin_tongyong = 1;
	/**
	 * 定向红包
	 */
	public static final Integer type_jiangpin_dingxiang = 2;
	/**
	 * 通用红包2
	 */
	public static final Integer type_jiangpin_tongyong_2 = 3;
	/**
	 * iPhone x
	 */
	public static final Integer type_jiangpin_iPhone_x = 4;
	/**
	 * 8888元通用红包
	 */
	public static final Integer type_jiangpin_tongyong_3 = 5;
	/**
	 * 未中奖
	 */
	public static final Integer type_jiangpin_weizhongjiang = 6;
	
	/**
	 * 奖品类型
	 */
	private Integer type_jiangpin;
	/**
	 * 红包状态
	 */
	private Integer state;
	/**
	 * 关注用户
	 */
	private SubscribeUser subscribeUser;
	/**
	 * 会员
	 */
	private User user_huiyuan;
	/**
	 * 会员系统编号
	 */
	private String userId_huiyuan;
	/**
	 * 生成的几率数
	 */
	private Integer rand_number;
	/**
	 * 领取的 某一天的时间戳
	 * 比如 2018-07-20 的时间戳
	 */
	private Long lingqu_day;
	/**
	 * 如果是定向红包就有商家
	 */
	private Merchant72 merchant72;
	/**
	 * 定向红包
	 */
	private MerchantRedEnvelope merchantRedEnvelope;
	/**
	 * 定向红包系统编号
	 */
	private String merchantRedEnvelope_id;
	/**
	 * 抽中的红包金额
	 * 	通用红包的时候有用
	 */
	private Integer price_fen;
	
	static{
		putConfig(GuaguakaJiangPin.class, "state_"+State.STATE_OK, "已发放");
		putConfig(GuaguakaJiangPin.class, "state_"+State.STATE_FALSE, "未中奖");
		putConfig(GuaguakaJiangPin.class, "state_"+State.STATE_FALSE, "未中奖");
		
		putConfig(GuaguakaJiangPin.class, "type_jiangpin_"+type_jiangpin_tongyong , "通用红包1");
		putConfig(GuaguakaJiangPin.class, "type_jiangpin_"+type_jiangpin_dingxiang , "定向红包");
		putConfig(GuaguakaJiangPin.class, "type_jiangpin_"+type_jiangpin_tongyong_2 , "通用红包2");
		putConfig(GuaguakaJiangPin.class, "type_jiangpin_"+type_jiangpin_iPhone_x , "iPhone x");
		putConfig(GuaguakaJiangPin.class, "type_jiangpin_"+type_jiangpin_tongyong_3 , "8888元通用红包");
	}
	
	public Integer getPrice_fen() {
		return price_fen;
	}
	public void setPrice_fen(Integer price_fen) {
		this.price_fen = price_fen;
	}
	public MerchantRedEnvelope getMerchantRedEnvelope() {
		if (merchantRedEnvelope == null && MyUtil.isValid(this.merchantRedEnvelope_id)) {
			merchantRedEnvelope = (MerchantRedEnvelope) ContextUtil.getSerializContext().get(MerchantRedEnvelope.class, merchantRedEnvelope_id);
		}
		return merchantRedEnvelope;
	}
	public void setMerchantRedEnvelope(MerchantRedEnvelope merchantRedEnvelope) {
		if(merchantRedEnvelope != null) {
			merchantRedEnvelope_id = merchantRedEnvelope.getId();
		}
		this.merchantRedEnvelope = merchantRedEnvelope;
	}
	public String getMerchantRedEnvelope_id() {
		return merchantRedEnvelope_id;
	}
	public void setMerchantRedEnvelope_id(String merchantRedEnvelope_id) {
		this.merchantRedEnvelope_id = merchantRedEnvelope_id;
	} 
	public Merchant72 getMerchant72() {
		return merchant72;
	}
	public void setMerchant72(Merchant72 merchant72) {
		this.merchant72 = merchant72;
	}
	public Long getLingqu_day() {
		return lingqu_day;
	}
	public void setLingqu_day(Long lingqu_day) {
		this.lingqu_day = lingqu_day;
	}
	public String getShowType_jiangpin(){
		 return (String) getConfig("type_jiangpin_"+this.getType_jiangpin());
	} 
	public String getShowState(){
		 return (String) getConfig("state_"+this.getState());
	} 
	public Integer getType_jiangpin() {
		return type_jiangpin;
	}

	public void setType_jiangpin(Integer type_jiangpin) {
		this.type_jiangpin = type_jiangpin;
	}

	public Integer getRand_number() {
		return rand_number;
	}

	public void setRand_number(Integer rand_number) {
		this.rand_number = rand_number;
	}

	public SubscribeUser getSubscribeUser() {
		if(subscribeUser == null && !MyUtil.isEmpty(openid)) {
			
			SubscribeUser subscribeUser_find = new SubscribeUser();
			subscribeUser_find.setOpenid(openid);
			
			subscribeUser = (SubscribeUser) ContextUtil.getSerializContext().get(subscribeUser_find);
		}
		return subscribeUser;
	} 
	public User getUser_huiyuan() {
		if (user_huiyuan == null && MyUtil.isValid(this.userId_huiyuan)) {
			user_huiyuan = (User) ContextUtil.getSerializContext().get(User.class, userId_huiyuan);
		}
		if(user_huiyuan == null && !MyUtil.isEmpty(openid)) {
			WebConfigContent instance = WebConfigContent.getInstance();
			String defaultUserGroupId = instance.getDefaultUserGroupId();
			
			User72 user72_find = new User72();
			
			user72_find.setUserGroupId(defaultUserGroupId);
			user72_find.setThird_user_id(openid);
			
			user_huiyuan = (User72) ContextUtil.getSerializContext().get(user72_find);
		}
		return user_huiyuan;
	}

	public void setUser_huiyuan(User user_huiyuan) {
		if (user_huiyuan != null) {
			userId_huiyuan = user_huiyuan.getId();
		}
		this.user_huiyuan = user_huiyuan;
	}

	public String getUserId_huiyuan() {
		return userId_huiyuan;
	}

	public void setUserId_huiyuan(String userId_huiyuan) {
		this.userId_huiyuan = userId_huiyuan;
	}
	public String getOpenid() {
		return openid;
	}
	public void setOpenid(String openid) {
		this.openid = openid;
	}     
	public Integer getState() {
		return state;
	}
	public void setState(Integer state) {
		this.state = state;
	} 
}
