package com.lymava.qier.activities.model;

import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;
import com.lymava.qier.activities.guaguaka.GuaguakaJiangPin;
import com.lymava.wechat.gongzhonghao.SubscribeUser;

import java.text.ParseException;
import java.util.Date;

/**
 * 集卡活动
 */
public class JiKaHuoDong extends BaseModel {

	private static final long serialVersionUID = 1L;

	/**
	 * 用户的openid
	 */
	private String openid;
	/**
	 * 抽中通用金额
	 */
	private Integer choujiang_jine ;
	/**
	 * 集卡排名
	 */
	private Integer jika_paiming;
	/**
	 *活动的具体哪天
	 */
	private Long lingqu_day;
	/**
	 * 是否集齐状态
	 */
	private Integer state;
	
	 static{
			putConfig(JiKaHuoDong.class, "state_"+State.STATE_WAITE_PROCESS, "未集满");
			putConfig(JiKaHuoDong.class, "state_"+State.STATE_OK, "以集满");

	}

	/**
	 * 奖品发放
	 */
	public void jiangpin_fafang(){

	}


	public String getShowLingqu_day() {
		return DateUtil.getSdfFull().format(new Date(lingqu_day));
	}
	public void setInLingqu_day(String dakaTime_str) {
		try {
			this.lingqu_day = DateUtil.getSdfFull().parse(dakaTime_str).getTime();

		} catch (ParseException ignored) {
		}
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

	public String getOpenid() {
		return openid;
	}

	public void setOpenid(String openid) {
		this.openid = openid;
	}

	public Integer getChoujiang_jine()
	{
		return choujiang_jine;
	}

	public void setChoujiang_jine(Integer choujiang_jine)
	{
		this.choujiang_jine = choujiang_jine;
	}

	public Integer getJika_paiming()
	{
		return jika_paiming;
	}

	public void setJika_paiming(Integer jika_paiming)
	{
		this.jika_paiming = jika_paiming;
	}

	public Long getLingqu_day()
	{
		return lingqu_day;
	}

	public void setLingqu_day(Long lingqu_day)
	{
		this.lingqu_day = lingqu_day;
	}

	public static long getSerialVersionUID()
	{
		return serialVersionUID;
	}

	}
