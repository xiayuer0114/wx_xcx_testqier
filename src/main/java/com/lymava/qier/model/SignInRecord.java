package com.lymava.qier.model;

import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;

public class SignInRecord extends BaseModel {

    // 用户id
    private String userId;

    // 用户
    private User72 user72;

    // 签到时间
    private Long signTime;

    // 签到当天开始的时间
    private Long signStartTime;

    // 签到状态
    private Integer state;

    public static Integer sign_state_normal = State.STATE_OK;   // 签到正常的状态

    // 这次签到  获取了多奖励   单位分 (偏移 100)
    private Long jifen;
    public static Long jifen_pianyi = 100L;

    // 连续打卡的标记
    private Integer lianxuMark;




    public User72 getUser72() {
        if(this.user72 != null && MyUtil.isValid(this.userId )){
            return (User72)ContextUtil.getSerializContext().get(User72.class,this.userId);
        }
        return user72;
    }

    public void setUser72(User72 user72) {
        if(user72 != null){
            this.userId = user72.getId();
        }
        this.user72 = user72;
    }

    public Integer getLianxuMark() {
        return lianxuMark;
    }

    public void setLianxuMark(Integer lianxuMark) {
        this.lianxuMark = lianxuMark;
    }

    public Long getSignStartTime() {
        return signStartTime;
    }

    public void setSignStartTime(Long signStartTime) {
        this.signStartTime = signStartTime;
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public Long getSignTime() {
        return signTime;
    }

    public void setSignTime(Long signTime) {
        this.signTime = signTime;
    }

    public Long getJifen() {
        return jifen;
    }

    public void setJifen(Long jifen) {
        this.jifen = jifen;
    }
}
