package com.lymava.qier.activities.model;

import java.util.Date;

import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;
import com.lymava.qier.model.Merchant72;

/**
 * 市场营销活动参与商家
 * @author lymava
 *
 */
public class MarketingActivitiesMerchant extends BaseModel{
 
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 4736422658424234682L;
	
	/**
	 * 营销活动的系统编号
	 */
	private String marketingActivities_id;
	/**
	 * 营销活动
	 */
	private MarketingActivities marketingActivities;
	/**
	 * 商家的系统编号
	 */
	private String user_merchant_id;

	/**
	 * 商家实体
	 */
	private Merchant72 user_merchant;
	/**
	 * 每日可参与活动总数
	 */
	private Integer every_day_count;
	/**
	 * 活动总数
	 */
	private Integer all_day_count;
	/**
	 * 活动开始日期
	 */
	private Long start_date;
	/**
	 * 活动结束日期
	 */
	private Long end_date;
	/**
	 * 	这个是一天中的开始时间	hh:mm:ss
	 * 	相对一天开始的 毫秒数
	 * 活动开始时间
	 */
	private Long day_start_time;
	/**
	 * 这个是一天中的开始时间	hh:mm:ss
	 * 	相对一天开始的 毫秒数
	 * 活动结束时间
	 */
	private Long day_end_time;
	/**
	 * 开始星期几	包含
	 */
	private Integer start_week;
	/**
	 * 结束星期几	包含
	 */
	private Integer end_week; 
	/**
	 * 状态
	 */
	private Integer state;
	
	 static{
			putConfig(MarketingActivitiesMerchant.class, "state_"+State.STATE_FALSE, "异常");
			putConfig(MarketingActivitiesMerchant.class, "state_"+State.STATE_OK, "正常");
			
	}
	 
	public String getMarketingActivities_id() {
		return marketingActivities_id;
	}
	public void setMarketingActivities_id(String marketingActivities_id) {
		this.marketingActivities_id = marketingActivities_id;
	}
	public MarketingActivities getMarketingActivities() {
		if(marketingActivities == null && MyUtil.isValid(this.getUser_merchant_id())){
			marketingActivities = (MarketingActivities) ContextUtil.getSerializContext().get(MarketingActivities.class, this.getMarketingActivities_id());
		}
		return marketingActivities;
	}
	public void setMarketingActivities(MarketingActivities marketingActivities) {
		if(marketingActivities != null) {
			marketingActivities_id = marketingActivities.getId();
		}
		this.marketingActivities = marketingActivities;
	}
	public String getUser_merchant_id() {
		return user_merchant_id;
	}
	public void setUser_merchant_id(String user_merchant_id) {
		this.user_merchant_id = user_merchant_id;
	}
	public Merchant72 getUser_merchant() {
		if(user_merchant == null && MyUtil.isValid(this.getUser_merchant_id())){
			user_merchant = (Merchant72) ContextUtil.getSerializContext().get(Merchant72.class, this.getUser_merchant_id());
		}
		return user_merchant;
	}
	public void setUser_merchant(Merchant72 user_merchant) {
		if(user_merchant != null) {
			user_merchant_id = user_merchant.getId();
		}
		this.user_merchant = user_merchant;
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
	public Integer getStart_week() {
		return start_week;
	}
	public Integer getEnd_week() {
		return end_week;
	}
	public Integer getEvery_day_count() {
		return every_day_count;
	}
	public void setEvery_day_count(Integer every_day_count) {
		this.every_day_count = every_day_count;
	}
	public Integer getAll_day_count() {
		return all_day_count;
	}
	public void setAll_day_count(Integer all_day_count) {
		this.all_day_count = all_day_count;
	}
	public String getShowStart_date() {
		if(start_date == null){
			return null;
		}
		return DateUtil.getSdfFull().format(new Date(start_date));
	}
	public void setInStart_date(String start_date) {
		Long date_str_to_timeMillis = DateUtil.date_str_to_timeMillis(start_date);
		this.start_date = date_str_to_timeMillis;
	} 
	public Long getStart_date() {
		return start_date;
	}
	public void setStart_date(Long start_date) {
		this.start_date = start_date;
	}
	public String getShowEnd_date() {
		if(end_date == null){
			return null;
		}
		return DateUtil.getSdfFull().format(new Date(end_date));
	}
	public void setInEnd_date(String end_date_str) {
		Long date_str_to_timeMillis = DateUtil.date_str_to_timeMillis(end_date_str);
		this.end_date = date_str_to_timeMillis;
	} 
	public Long getEnd_date() {
		return end_date;
	}
	public void setEnd_date(Long end_date) {
		this.end_date = end_date;
	}
	public String getShowDay_start_time() {
		if(day_start_time == null){
			return null;
		}
		return DateUtil.getSdfHm().format(new Date(day_start_time));
	}
	public void setInDay_start_time(String day_start_time_str) {
		try {
			Date parse = DateUtil.getSdfHm().parse(day_start_time_str);
			this.day_start_time = parse.getTime();
		} catch (Exception e) {
		}
	} 
	public Long getDay_start_time() {
		return day_start_time;
	}
	public void setDay_start_time(Long day_start_time) {
		this.day_start_time = day_start_time;
	}
	public String getShowDay_end_time() {
		if(day_end_time == null){
			return null;
		}
		return DateUtil.getSdfHm().format(new Date(day_end_time));
	}
	public void setInDay_end_time(String day_end_time_str) {
		try {
			Date parse = DateUtil.getSdfHm().parse(day_end_time_str);
			this.day_end_time = parse.getTime();
		} catch (Exception e) {
		}
	}
	public Long getDay_end_time() {
		return day_end_time;
	}
	public void setDay_end_time(Long day_end_time) {
		this.day_end_time = day_end_time;
	} 
	public void setStart_week(Integer start_week) {
		this.start_week = start_week;
	}
	public void setEnd_week(Integer end_week) {
		this.end_week = end_week;
	}
}
