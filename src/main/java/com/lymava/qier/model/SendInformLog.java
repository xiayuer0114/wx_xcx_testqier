package com.lymava.qier.model;

import com.lymava.base.safecontroler.model.UserV2;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;

public class SendInformLog extends BaseModel {

    /**
	 * 
	 */
	private static final long serialVersionUID = -325733134730481189L;

	/**
     * 商家的id
     */
    private String merchantId;

    /**
     * 商家
     */
    private Merchant72 merchant;

    /**
     * 发送信息提示的时间
     */
    private Long sendTime;

    /**
     * 商家的如阅读的时间
     */
    private Long readTime;

    /**
     * 发送的管理员id
     */
    private String adminId;

    /**
     * 发送的管理员
     */
    private UserV2 admin;

    /**
     * 信息的状态
     */
    private Integer start;

    public static Integer start_send = State.STATE_WAITE_PAY;  // 已发送
    public static Integer start_read = State.STATE_PAY_SUCCESS ;  // 已阅读



    public void setAdminId(String adminId) {
        this.adminId = adminId;
    }

    public String getMerchantId() {
        return merchantId;
    }

    public void setMerchantId(String merchantId) {
        this.merchantId = merchantId;
    }

    public Merchant72 getMerchant() {
        if (MyUtil.isValid(merchantId)){
            return (Merchant72) ContextUtil.getSerializContext().get(Merchant72.class,merchantId);
        }
        return merchant;
    }

    public void setMerchant(Merchant72 merchant) {
        if (merchant != null && MyUtil.isValid(merchant.getId())){
            this.merchantId = merchant.getId();
        }
        this.merchant = merchant;
    }

    public Long getSendTime() {
        return sendTime;
    }

    public void setSendTime(Long sendTime) {
        this.sendTime = sendTime;
    }

    public Long getReadTime() {
        return readTime;
    }

    public void setReadTime(Long readTime) {
        this.readTime = readTime;
    }


    public UserV2 getAdmin() {
        if(MyUtil.isValid(adminId)){
            return (UserV2) ContextUtil.getSerializContext().get(UserV2.class,adminId);
        }

        return admin;
    }

    public void setAdmin(UserV2 admin) {
        if(admin != null && MyUtil.isValid(admin.getId()) ){
            this.adminId = admin.getId();
        }

        this.admin = admin;
    }

    public Integer getStart() {
        return start;
    }

    public void setStart(Integer start) {
        this.start = start;
    }

    public String getAdminId() {
        return adminId;
    }
}
