package com.lymava.qier.activities.hongbaoliebian;

import com.lymava.base.util.ContextUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.qier.activities.model.ActivitieMerchantRedEnvelope;
import com.lymava.trade.pay.model.PaymentRecord;

public class HongbaoliebianPaymentRecord extends PaymentRecord {

    /**
     * 源订单 系统编号
     */
    private String sourceRecord_id;

    /**
     * 源订单 实体
     */
    private HongbaoliebianPaymentRecord sourceRecord;

    /**
     * 活动红包 系统编号
     */
    private String activitie_redEnvelope_id;

    /**
     * 活动红包 实体
     */
    private ActivitieMerchantRedEnvelope activitie_redEnvelope;






    // get/set


    public String getActivitie_redEnvelope_id() {
        return activitie_redEnvelope_id;
    }

    public void setActivitie_redEnvelope_id(String activitie_redEnvelope_id) {
        this.activitie_redEnvelope_id = activitie_redEnvelope_id;
    }

    public ActivitieMerchantRedEnvelope getActivitie_redEnvelope() {
        if(MyUtil.isValid(this.getActivitie_redEnvelope_id())){
            ActivitieMerchantRedEnvelope activitieMerchantRedEnvelope = (ActivitieMerchantRedEnvelope)ContextUtil.getSerializContext().get(ActivitieMerchantRedEnvelope.class,this.getActivitie_redEnvelope_id());
            if(activitieMerchantRedEnvelope != null){
                return activitieMerchantRedEnvelope;
            }
        }
        return activitie_redEnvelope;
    }

    public void setActivitie_redEnvelope(ActivitieMerchantRedEnvelope activitie_redEnvelope) {
        if(activitie_redEnvelope != null && MyUtil.isValid(activitie_redEnvelope.getId())){
            this.activitie_redEnvelope_id = activitie_redEnvelope.getId();
        }

        this.activitie_redEnvelope = activitie_redEnvelope;
    }

    public String getSourceRecord_id() {
        return sourceRecord_id;
    }

    public void setSourceRecord_id(String sourceRecord_id) {
        this.sourceRecord_id = sourceRecord_id;
    }

    public HongbaoliebianPaymentRecord getSourceRecord() {
        if(MyUtil.isValid(this.getSourceRecord_id())){
            HongbaoliebianPaymentRecord hongbaoliebianPaymentRecord = (HongbaoliebianPaymentRecord)ContextUtil.getSerializContext().get(HongbaoliebianPaymentRecord.class,this.getSourceRecord_id());
            if(hongbaoliebianPaymentRecord != null){
                return hongbaoliebianPaymentRecord;
            }
        }
        return sourceRecord;
    }

    public void setSourceRecord(HongbaoliebianPaymentRecord sourceRecord) {
        if(sourceRecord != null && MyUtil.isValid(sourceRecord.getId())){
            this.sourceRecord_id = sourceRecord.getId();
        }

        this.sourceRecord = sourceRecord;
    }
}
