package com.lymava.qier.model;

import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;

import java.util.Date;

public class UserBrowseHistory extends BaseModel {

    // 浏览用户的id
    private String userId;

    // 浏览用户
    private User user;

    // 被浏览的pubId
    private String pubId;

    // 被浏览的pub
    private MerchantPub pub;

    // 这条浏览记录的状态  后期可能会用来做删除
    private Integer state;

    public static Integer browse_state_normal = 1;    // 正常的状态

    // 最后一次浏览时间
    private Long last_browse_time;




    public User getUser() {
        if (this.user == null && MyUtil.isValid(this.userId)){
            User user = new User();
            user.setId(this.userId);
            return (User) ContextUtil.getSerializContext().get(user);
        }
        return user;
    }

    public void setUser(User user) {
        if (user != null){
            this.userId = user.getId();
        }
        this.user = user;
    }

    public MerchantPub getPub() {
        if (this.pub == null && MyUtil.isValid(this.pubId)){
            MerchantPub pub = new MerchantPub();
            pub.setId(this.pubId);
            return (MerchantPub) ContextUtil.getSerializContext().get(pub);
        }
        return pub;
    }

    public void setPub(MerchantPub pub) {
        if(pub != null){
            this.pubId = pub.getId();
        }
        this.pub = pub;
    }


    public String getShowLastTime() {
        if(last_browse_time != null){
            return DateUtil.getSdfMonthDay().format(new Date(this.last_browse_time));
        }
        return "";
    }






    public Long getLast_browse_time() {
        return last_browse_time;
    }

    public void setLast_browse_time(Long last_browse_time) {
        this.last_browse_time = last_browse_time;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getPubId() {
        return pubId;
    }

    public void setPubId(String pubId) {
        this.pubId = pubId;
    }


    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }
}
