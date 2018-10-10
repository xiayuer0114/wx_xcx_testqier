package com.lymava.qier.activities.model;

import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;

import java.text.ParseException;
import java.util.Date;

/**
 * 探秘官
 */
public class Tanmiguan extends BaseModel{

    /**
	 * 
	 */
	private static final long serialVersionUID = 7455704586402893285L;

	/**
     * 用户的 openId
     */
    private String openId;

    /**
     * 领取时间
     */
    private Long lingquTime;

    /**
     * 打卡状态
     */
    private Integer state;

    public static Integer state_ok = State.STATE_OK;     // 正常
    public static Integer state_false = State.STATE_FALSE; //  异常,错误

    // lingquTime      show
    public String getShowLingquTime()
    {
    	return DateUtil.getSdfFull().format(new Date(lingquTime));
    }






    // getter setter
    public String getOpenId() {
        return openId;
    }

    public void setOpenId(String openId) {
        this.openId = openId;
    }

    public Long getLingquTime() {
        return lingquTime;
    }

    public void setLingquTime(Long lingquTime) {
        this.lingquTime = lingquTime;
    }

    public void setInLingquTime(String lingquTime_str) {

        try {
            this.lingquTime = DateUtil.getSdfFull().parse(lingquTime_str).getTime();

        } catch (ParseException ignored) {
        }

    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }
}
