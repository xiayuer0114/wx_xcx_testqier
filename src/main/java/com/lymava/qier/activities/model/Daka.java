package com.lymava.qier.activities.model;

import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;

import java.text.ParseException;
import java.util.Date;

public class Daka extends BaseModel{

    /**
	 * 
	 */
	private static final long serialVersionUID = 7455704586402893285L;

	/**
     * 用户的 openId 分支
     */
    private String openId;

    /**
     * 签到的具体时间
     */
    private Long dakaTime;

    /**
     * 签到的那一天 开始的时间
     */
    private Long dakaStartTime;

    /**
     * 打卡状态
     */
	private Integer state;

    public static Integer state_ok = State.STATE_OK;     // 正常
    public static Integer state_false = State.STATE_FALSE; //  异常,错误

    /**
     * 奖励   打卡的奖励  单位:分  (pianyi)
     */
    private Long jiangLi;

    public static Integer pianyi= 100;


    /**
     * 连续标记   是否连续打卡的标识
     */
    private Integer lianxuMark;




    // JiangLi(奖励)    in
	public void setInJiangLi(Double jiangLi_double)
	{
		this.jiangLi = new Double(jiangLi_double * pianyi).longValue();
	}

	// dakaTime()   show/in
    public String getShowDakaTime() {
        return DateUtil.getSdfFull().format(new Date(dakaTime));
    }
	public void setInDakaTime(String dakaTime_str) {
		try {
			this.dakaTime = DateUtil.getSdfFull().parse(dakaTime_str).getTime();

		} catch (ParseException ignored) {
		}
	}


	// dakaStartTime()   show/in
    public String getShowDakaStartTime() {
		return DateUtil.getSdfFull().format(new Date(dakaStartTime));
    }
	public void setInDakaStartTime(String dakaStartTime_str) {
		try {
			this.dakaStartTime = DateUtil.getSdfFull().parse(dakaStartTime_str).getTime();

		} catch (ParseException ignored) {
		}
	}









	//    get/set

    public Integer getLianxuMark() {
        return lianxuMark;
    }

    public void setLianxuMark(Integer lianxuMark) {
        this.lianxuMark = lianxuMark;
    }

    public Long getDakaStartTime() {
        return dakaStartTime;
    }

    public void setDakaStartTime(Long dakaStartTime) {
        this.dakaStartTime = dakaStartTime;
    }

    public String getOpenId() {
        return openId;
    }

    public void setOpenId(String openId) {
        this.openId = openId;
    }

    public Long getDakaTime() {
        return dakaTime;
    }

    public void setDakaTime(Long dakaTime) {
        this.dakaTime = dakaTime;
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

    public Long getJiangLi() {
        return jiangLi;
    }

    public void setJiangLi(Long jiangLi) {
        this.jiangLi = jiangLi;
    }

    public Long getShowJiangLi() {
        return this.jiangLi / pianyi;
    }

    public void setInJiangLi(Long jiangLi) {
        this.jiangLi = jiangLi*pianyi;
    }
}
