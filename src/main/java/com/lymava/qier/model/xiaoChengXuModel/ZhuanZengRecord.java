package com.lymava.qier.model.xiaoChengXuModel;

import com.lymava.commons.state.State;
import com.lymava.nosql.mongodb.vo.BaseModel;

public class ZhuanZengRecord extends BaseModel{

    /**
     * 红包id
     */
    private String redId;

    /**
     * 红包现在的用户openid
     */
    private String oldOpenId;

    /**
     * 转赠的时间
     */
    private Long zhuanzengTime;

    /**
     * 转赠后用户的openid
     */
    private String newOpenId;

    /**
     * 得到的时间
     */
    private Long takeTime;

    /**
     * 状态
     */
    private Integer state;

    public static Integer state_wait = State.STATE_DONOTKNOW;       // 转赠中
    public static Integer state_yes = State.STATE_OK;       // 转赠成功











    // get/set


    public String getRedId() {
        return redId;
    }

    public void setRedId(String redId) {
        this.redId = redId;
    }

    public String getOldOpenId() {
        return oldOpenId;
    }

    public void setOldOpenId(String oldOpenId) {
        this.oldOpenId = oldOpenId;
    }



    public String getNewOpenId() {
        return newOpenId;
    }

    public void setNewOpenId(String newOpenId) {
        this.newOpenId = newOpenId;
    }


    public Long getZhuanzengTime() {
        return zhuanzengTime;
    }

    public void setZhuanzengTime(Long zhuanzengTime) {
        this.zhuanzengTime = zhuanzengTime;
    }

    public Long getTakeTime() {
        return takeTime;
    }

    public void setTakeTime(Long takeTime) {
        this.takeTime = takeTime;
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }
}
