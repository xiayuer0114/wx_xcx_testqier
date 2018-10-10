package com.lymava.qier.model.qianduanModel;

import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;

import java.sql.Time;
import java.text.ParseException;
import java.text.SimpleDateFormat;

public class Liuyan extends BaseModel {

    /**
     * 用户的id地址
     */
    private String ipAddr;

    /**
     * 提交的当天开始的时间
     */
    private Long subTimeDay;

    /**
     * 姓名
     */
    private String name;

    /**
     * 邮箱地址
     */
    private String email;

    /**
     * 留言类容
     */
    private String leaveMessage;

    /**
     * 状态
     */
    private Integer state;
    public static Integer state_ok = State.STATE_OK;
    public static Integer state_false = State.STATE_FALSE;

    /**
     * 备注
     */
    private String memo;






        // in/show 时间
    public String getShowSubTimeDay() {

        if(this.getSubTimeDay() != null){
            SimpleDateFormat sdf  = DateUtil.getSdfFull();
            return  sdf.format(this.getSubTimeDay());
        }
        return "";
    }
    public void setInSubTimeDay(String subTimeDay) {

        SimpleDateFormat sdf  = DateUtil.getSdfFull();

        if(!MyUtil.isEmpty(subTimeDay)){

            try {
                Long now_time = sdf.parse(subTimeDay).getTime();
                this.subTimeDay  = DateUtil.getDayStartTime(now_time);
            } catch (ParseException e) { }
        }
    }








    // get / set


    public String getIpAddr() {
        return ipAddr;
    }

    public void setIpAddr(String ipAddr) {
        this.ipAddr = ipAddr;
    }

    public Long getSubTimeDay() {
        return subTimeDay;
    }

    public void setSubTimeDay(Long subTimeDay) {
        this.subTimeDay = subTimeDay;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getLeaveMessage() {
        return leaveMessage;
    }

    public void setLeaveMessage(String leaveMessage) {
        this.leaveMessage = leaveMessage;
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }
}
