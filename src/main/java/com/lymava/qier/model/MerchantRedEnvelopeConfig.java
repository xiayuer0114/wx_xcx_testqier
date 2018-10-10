package com.lymava.qier.model;

import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;

/**
 * 商家的定向红包配置
 * @author lymava
 *
 */
public class MerchantRedEnvelopeConfig extends BaseModel {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6740015494399402261L;
	
	/**
	 * 红包名称
	 */
	private String red_envolope_name;
	/**
	 * 商户
	 */
	private User user_merchant;
	/**
	 * 商户系统编号
	 */
	private String userId_merchant;  
	/**
	 * 商家类型
	 */
	private String merchant_type;
	/**
	 * 红包金额	单位偏移
	 * 
	 * 	当	amount_type 为	amount_type_guding 		这里就是红包金额		全偏移
	 * 	当	amount_type 为	amount_type_trade_bili 	这里就是红包金额的比例	全偏移	0.01 代表 %1 1 代表100%
	 */
	private Long amount; 
	/**
	 * 订单金额满多少减	单位偏移
	 */
	private Long amount_to_reach;
	/**
	 * 定向红包配置状态
	 */
	private Integer state;
	/**
	 * 出现几率
	 * 
	 * 	出现记录等于	
	 */
	private Integer probability;
	/**
	 * 星期几		开始使用 1 代表星期一
	 */
	private Integer week_start;
	/**
	 * 星期几		结束使用 1 代表星期一
	 */
	private Integer week_end;
	/**
	 * 	定向红包的过期时间	单位天
	 * 		
	 * 	领取红包的时间戳+这个时间 就是 过期的日期
	 * 	
	 * 	比如领取的时间是2018-06-01	这个时间戳是 15天的时间戳
	 */
	private Long expiry_time;

	/**
	 * 每天可以使用的开始时间
	 */
	private Long day_start;

	/**
	 * 每天可以使用的结束时间
	 */
	private Long day_end;
	/**
	 * 金额类型	固定金额/订单金额比例
	 * 
	 * 	为空/默认	是固定金额
	 */
	private Integer amount_type;
	/**
	 * 固定金额	默认值
	 */
	public static final Integer amount_type_guding = State.STATE_OK;
	/**
	 * 订单金额比例
	 */
	public static final Integer amount_type_trade_bili = State.STATE_FALSE;
	
	
	static{
		putConfig(MerchantRedEnvelopeConfig.class, "state_"+State.STATE_OK, "正常");
		putConfig(MerchantRedEnvelopeConfig.class, "state_"+State.STATE_FALSE, "异常");
		
		
		putConfig(MerchantRedEnvelopeConfig.class, "amount_type_"+State.STATE_OK, "固定金额");
		putConfig(MerchantRedEnvelopeConfig.class, "amount_type_"+State.STATE_FALSE, "订单折扣");
	}
	
	
	public Integer getAmount_type() {
		return amount_type;
	}
	public void setAmount_type(Integer amount_type) {
		this.amount_type = amount_type;
	}
	public Integer getAmount_type_guding() {
		return amount_type_guding;
	}
	public Integer getAmount_type_trade_bili() {
		return amount_type_trade_bili;
	}
	public Long getDay_start() {
		return day_start;
	}
	public Integer getShowDay_start() {
		if(this.day_start != null){
			return MathUtil.parseInteger(  (this.day_start/DateUtil.one_hour)+""  );

		}
		return null;
	}
	public void setDay_start(Long day_start) {
		this.day_start = day_start;
	}
	public void setInDay_start(Integer day_start) {
		if(day_start != null){
			this.day_start = day_start* DateUtil.one_hour;
		}
	}
	public Long getDay_end() {
		return day_end;
	}
	public Integer getShowDay_end() {
		if(this.day_end != null){
			return MathUtil.parseInteger(  (this.day_end/DateUtil.one_hour)+""  );

		}
		return null;
	}
	public void setDay_end(Long day_end) {
		this.day_end = day_end;
	}
	public void setInDay_end(Integer day_end) {
		if(day_end != null){
			this.day_end = day_end* DateUtil.one_hour;
		}
	}
	public String getMerchant_type() {
		return merchant_type;
	}
	public void setMerchant_type(String merchant_type) {
		this.merchant_type = merchant_type;
	}
	public Long getExpiry_time() {
		return expiry_time;
	}
	public void setExpiry_time(Long expiry_time) {
		this.expiry_time = expiry_time;
	} 
	public String getRed_envolope_name() {
		return red_envolope_name;
	}
	public void setRed_envolope_name(String red_envolope_name) {
		this.red_envolope_name = red_envolope_name;
	}
	public Integer getProbability() {
		return probability;
	}
	public void setProbability(Integer probability) {
		this.probability = probability;
	}
	public Integer getWeek_start() {
		return week_start;
	}
	public void setWeek_start(Integer week_start) {
		this.week_start = week_start;
	}
	public Integer getWeek_end() {
		return week_end;
	}
	public void setWeek_end(Integer week_end) {
		this.week_end = week_end;
	}
	public Long getAmount() {
		return amount;
	}
	public void setInAmount(String amount_yuan) {
		Double parseDoubleNull = MathUtil.parseDoubleNull(amount_yuan);
		if(parseDoubleNull == null){
			return;
		}
		Long amount_fen = MathUtil.multiply(parseDoubleNull, 100).longValue();
		this.amount = amount_fen*User.pianyiFen;
	}
	public void setAmount(Long amount) {
		this.amount = amount;
	}
	public Long getAmount_to_reach_fen() {
		if(amount_to_reach == null) {
			return null;
		}
		return amount_to_reach/User.pianyiFen;
	}
	public Long getAmount_to_reach() {
		return amount_to_reach;
	}
	public void setAmount_to_reach(Long amount_to_reach) {
		this.amount_to_reach = amount_to_reach;
	}
	public void setInAmount_to_reach(String amount_to_reach_yuan) {
		Double parseDoubleNull = MathUtil.parseDoubleNull(amount_to_reach_yuan);
		if(parseDoubleNull == null){
			return;
		}
		Long amount_to_reach_fen = MathUtil.multiply(parseDoubleNull, 100).longValue();
		this.amount_to_reach = amount_to_reach_fen*User.pianyiFen;
	}
	public String getShowState(){
		 return (String) getConfig("state_"+this.getState());
	}
	public Integer getState() {
		return state;
	}
	public void setState(Integer state) {
		this.state = state;
	}  
	public Long getAmountFen() {
		if(amount == null){
			return null;
		}
		return amount/User.pianyiFen;
	}
	public User getUser_merchant() {
		if (user_merchant == null && MyUtil.isValid(this.userId_merchant)) {
			user_merchant = (User) ContextUtil.getSerializContext().get(User.class, userId_merchant);
		}
		return user_merchant;
	}
	public void setUser_merchant(User user_merchant) {
		if (user_merchant != null) {
			userId_merchant = user_merchant.getId();
		}
		this.user_merchant = user_merchant;
	}
	public String getUserId_merchant() {
		return userId_merchant;
	}
	public void setUserId_merchant(String userId_merchant) {
		this.userId_merchant = userId_merchant;
	}
	public Long initMerchantRedEnvelopeAmount(TradeRecord72 tradeRecord72) {
		
		Long merchantRedEnvelopeAmount = null;
		
		if(amount_type_trade_bili.equals(amount_type)) {
			
			Long price_fen_all = tradeRecord72.getShowPrice_fen_all();
			
			Merchant72 user_merchant_tmp = tradeRecord72.getUser_merchant();
			
			Long merchant_red_pack_fen = user_merchant_tmp.get_merchant_red_pack_fen(price_fen_all);
			
			return merchant_red_pack_fen*User.pianyiFen;
		}else {
			merchantRedEnvelopeAmount = this.getAmount();
		}
		
		return merchantRedEnvelopeAmount;
	}  
}
