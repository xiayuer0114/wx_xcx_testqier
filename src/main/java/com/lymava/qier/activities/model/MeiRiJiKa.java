package com.lymava.qier.activities.model;

import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;

import java.text.ParseException;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

/**
 *  集卡记录
 */
public class MeiRiJiKa extends BaseModel {

	private static final long serialVersionUID = 1L;

	/**
	 * 我的openid
	 */
	private String  my_openid;
	/**
	 * 朋友的openid
	 */
	private String  friend_openid;
	/**
	 * 集卡种类
	 */
	private String jika_lei;
	/**
	 *集卡的时间具体时间
	 */
	private Long jika_day;
	/**
	 *集卡的时间当天开始时间
	 */
	private Long jika_kaishi_day;
	/**
	 * 卡片类型
	 */
	private Integer card_type;

	public static final Integer card_type_1 = 1;
	public static final Integer card_type_2= 2;
	public static final Integer card_type_3 = 3;
	public static final Integer card_type_4 = 4;
	public static final Integer card_type_5 = 5;
	public static final Integer card_type_6 = 6;
	public static final Integer card_type_7 = 7;
	public static final Integer card_type_8 = 8;

	public static final List<Integer> card_type_list = new LinkedList<Integer>();
	static{
		card_type_list.add(card_type_1);
		card_type_list.add(card_type_2);
		card_type_list.add(card_type_3);
		card_type_list.add(card_type_4);
		card_type_list.add(card_type_5);
		card_type_list.add(card_type_6);
		card_type_list.add(card_type_7);
		card_type_list.add(card_type_8);
	}

	/**
	 * 状态
	 */
	private Integer state;
	static{
		putConfig(MeiRiJiKa.class, "state_"+MeiRiJiKa.state_inprocess, "集卡中");
		putConfig(MeiRiJiKa.class, "state_"+MeiRiJiKa.state_chongfu, "重复卡");
		putConfig(MeiRiJiKa.class, "state_"+MeiRiJiKa.state_ok, "集卡完成");

	}
	/**
	 * 集卡中的
	 */
	public static final Integer state_inprocess = State.STATE_INPROCESS;
	/**
	 * 集中重复的卡
	 */
	public static final Integer state_chongfu = State.STATE_FALSE;
	/**
	 * 兑换完毕
	 */
	public static final Integer state_ok = State.STATE_OK;

	public Integer getCard_type()
	{
		return card_type;
	}

	public void setCard_type(Integer card_type)
	{
		this.card_type = card_type;
	}

	public Integer getState()
	{
		return state;
	}

	public void setState(Integer state) {
		this.state = state;
	}

	public String getShowJika_day() {
		return DateUtil.getSdfFull().format(new Date(jika_day));
	}
	public void setInJika_day(String dakaTime_str) {
		try {
			this.jika_day = DateUtil.getSdfFull().parse(dakaTime_str).getTime();

		} catch (ParseException ignored) {
		}
	}
	public String getShowJika_kaishi_day() {
		return DateUtil.getSdfFull().format(new Date(jika_kaishi_day));
	}
	public void setInJika_kaishi_day(String dakaTime_str) {
		try {
			this.jika_kaishi_day = DateUtil.getSdfFull().parse(dakaTime_str).getTime();

		} catch (ParseException ignored) {
		}
	}

	public String getShowState(){
		String a = null;
		if(this.state.equals(state_ok)){
			a="集卡完成";
		}
		if(this.state.equals(state_inprocess)){
			a="集卡中";
		}
		if(this.state.equals(state_chongfu)){
			a="重复卡";
		}
		return a;
	}

//	public String getShowState(){
//		String state = (String)getConfig("st_"+this.state);
//		if(state == null){
//			state = "未知";
//		}
//		return state;
//	}


	public String getMy_openid()
	{
		return my_openid;
	}

	public void setMy_openid(String my_openid)
	{
		this.my_openid = my_openid;
	}

	public String getFriend_openid()
	{
		return friend_openid;
	}

	public void setFriend_openid(String friend_openid)
	{
		this.friend_openid = friend_openid;
	}

	public String getJika_lei()
	{
		return jika_lei;
	}

	public void setJika_lei(String jika_lei)
	{
		this.jika_lei = jika_lei;
	}

	public Long getJika_day()
	{
		return jika_day;
	}

	public void setJika_day(Long jika_day)
	{
		this.jika_day = jika_day;
	}

	public Long getJika_kaishi_day()
	{
		return jika_kaishi_day;
	}

	public void setJika_kaishi_day(Long jika_kaishi_day)
	{
		this.jika_kaishi_day = jika_kaishi_day;
	}

	public static long getSerialVersionUID()
	{
		return serialVersionUID;
	}

	}
