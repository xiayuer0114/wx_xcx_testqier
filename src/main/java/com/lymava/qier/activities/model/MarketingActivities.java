package com.lymava.qier.activities.model;

import java.util.Calendar;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;

/**
 * 市场营销活动
 * @author lymava
 *
 */
public class MarketingActivities extends BaseModel{

	/**
	 * 
	 */
	private static final long serialVersionUID = -7698274499121419184L;
	
	/**
	 * 活动名称
	 */
	private String name;
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
	 * 活动未开始提醒
	 */
	private String not_start_message;
	
	/**
	 * 活动已结束提醒
	 */
	private String had_end_message;
	/**
	 * 其他配置
	 */
	private List<MarketingActivitiesConfig> marketingActivitiesConfig_list;
	/**
	 * 状态
	 */
	private Integer state;
	
	 static{
			putConfig(MarketingActivities.class, "state_"+State.STATE_FALSE, "异常");
			putConfig(MarketingActivities.class, "state_"+State.STATE_OK, "正常");
			
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
	/**
	 * 添加新的配置值	如果原来的key值已经存在 把 name与值覆盖就行
	 * @param name
	 * @param key
	 * @param value
	 */
	public void addMarketingActivitiesConfig(String name,String key,String value) {
		
		if(marketingActivitiesConfig_list == null) {
			marketingActivitiesConfig_list = new LinkedList<MarketingActivitiesConfig>();
		}
		
		MarketingActivitiesConfig marketingActivitiesConfig = getMarketingActivitiesConfig(key);
		
		if(marketingActivitiesConfig != null){
			marketingActivitiesConfig.setName(name);
			marketingActivitiesConfig.setValue(value);
		}else {
			
			marketingActivitiesConfig = new MarketingActivitiesConfig();
			
			marketingActivitiesConfig.setName(name);
			marketingActivitiesConfig.setValue(value);
			marketingActivitiesConfig.setKey(key);
			
			marketingActivitiesConfig_list.add(marketingActivitiesConfig);
		}
		
	}
	
	public String getConfigotherValue(String key){
		MarketingActivitiesConfig marketingActivitiesConfig = getMarketingActivitiesConfig(key);
		
		if(marketingActivitiesConfig != null){
			return marketingActivitiesConfig.getValue();
		}
		return null;
	}
	
	public MarketingActivitiesConfig getMarketingActivitiesConfig(String key) {
		if(marketingActivitiesConfig_list == null || MyUtil.isEmpty(key)) {
			return null;
		}
		for (MarketingActivitiesConfig marketingActivitiesConfig : marketingActivitiesConfig_list) {
			if(key.equals(marketingActivitiesConfig.getKey())) {
				return marketingActivitiesConfig;
			}
		}
		return null;
	}
	
	public List<MarketingActivitiesConfig> getMarketingActivitiesConfig_list() {
		return marketingActivitiesConfig_list;
	}
	public void setMarketingActivitiesConfig_list(List<MarketingActivitiesConfig> marketingActivitiesConfig_list) {
		this.marketingActivitiesConfig_list = marketingActivitiesConfig_list;
	}
	public Integer getStart_week() {
		return start_week;
	}
	public Integer getEnd_week() {
		return end_week;
	}

	/**
	 * 	
	 * @return	此活动是否在活动中
	 */
	public boolean getIs_on_activities() {
		
		long currentTimeMillis = System.currentTimeMillis();
		//未开始
		if(start_date != null && currentTimeMillis < start_date) {
			return false;
		}
		//已结束
		if(end_date != null && currentTimeMillis > end_date) {
			return false;
		}
		
		Long dayStartTime = DateUtil.getDayStartTime(currentTimeMillis);
		Long day_past_time = currentTimeMillis-dayStartTime;
		//未开始
		if(day_start_time != null && day_past_time < day_start_time) {
			return false;
		}
		//已结束
		if(day_end_time != null && day_past_time > day_end_time) {
			return false;
		}
		//星期一是第一天 所以要处理 这个算法 星期1 是第二天
		int DAY_OF_WEEK = Calendar.getInstance().get(Calendar.DAY_OF_WEEK);
		DAY_OF_WEEK = DAY_OF_WEEK-1;
		if(DAY_OF_WEEK == 0) {
			DAY_OF_WEEK = 7;
		}
		//未开始
		if(start_week != null && DAY_OF_WEEK < start_week) {
			return false;
		}
		//已结束
		if(end_week != null && DAY_OF_WEEK > end_week) {
			return false;
		}
		if(!State.STATE_OK.equals(this.getState())) {
			return false;
		}
		
		return true;
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
	public Long getDay_start_time() {
		return day_start_time;
	}
	public void setDay_start_time(Long day_start_time) {
		this.day_start_time = day_start_time;
	}
	public String getShowDay_start_time() {
		if(day_start_time == null){
			return null;
		}
		return DateUtil.getSdfHm().format(new Date(DateUtil.getDayStartTime()+day_start_time));
	}
	public void setInDay_start_time(String day_start_time_str) {
		this.day_start_time = DateUtil.getFromDayStartTime(day_start_time_str);
	} 
	public Long getDay_end_time() {
		return day_end_time;
	}
	public void setDay_end_time(Long day_end_time) {
		this.day_end_time = day_end_time;
	}
	public String getShowDay_end_time() {
		if(day_end_time == null){
			return null;
		}
		return DateUtil.getSdfHm().format(new Date(DateUtil.getDayStartTime()+day_end_time));
	}
	public void setInDay_end_time(String day_end_time_str) {
		this.day_end_time = DateUtil.getFromDayStartTime(day_end_time_str);
			
		if(day_end_time != null && day_end_time == 0) {
			this.day_end_time = DateUtil.one_day;
		} 
	} 
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public void setStart_week(Integer start_week) {
		this.start_week = start_week;
	}
	public void setEnd_week(Integer end_week) {
		this.end_week = end_week;
	}

	public String getNot_start_message() {
		return not_start_message;
	}

	public void setNot_start_message(String not_start_message) {
		this.not_start_message = not_start_message;
	}

	public String getHad_end_message() {
		return had_end_message;
	}
	public void setHad_end_message(String had_end_message) {
		this.had_end_message = had_end_message;
	}
	
	
}
