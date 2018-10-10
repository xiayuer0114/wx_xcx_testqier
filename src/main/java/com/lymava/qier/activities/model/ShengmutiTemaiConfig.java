package com.lymava.qier.activities.model;

import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;
import com.lymava.qier.model.Merchant72;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class ShengmutiTemaiConfig extends BaseModel{

    static{
        Class<?> classTmp = ShengmutiTemaiConfig.class;
        putConfig(classTmp, "st_"+ State.STATE_OK, "正常");
        putConfig(classTmp, "st_"+ State.STATE_DONOTKNOW, "已买完");
        putConfig(classTmp, "st_"+State.STATE_FALSE, "关闭");
    }

    /**
     * 状态
     */
    private Integer state;

    /**
     * 活动开始时间
     */
    private Long huodong_startTime;

    /**
     * 活动结束时间
     */
    private Long huodong_endTime;

    /**
     * 份数
     */
    private Integer fenshu;

    /**
     * 一个用户打开后的倒计时设置   (小时)
     */
    private Integer daojishi;

    /**
     * 展示的折扣
     */
    private String show_zhekou;

    public static Long zhkou_pianyi = 100L;
    /**
     * 折扣前  单位分
     */
    private Long zhekou_qian;

    /**
     * 折扣后  单位分
     */
    private Long zhekou_hou;

    /**
     * 需要几个好友
     */
    private Integer xuyao_haoyou;

    /**
     * 商家的系统编号
     */
    private String merchant_id;

    /**
     * 商家实体
     */
    private Merchant72 merchant72;

    /**
     * 已经购买了 好多份
     */
    private Integer yijing_goumei;

    /**
     * 这个活动的名字
     */
    private String huodong_name;

    /**
     * 这个活动的标题
     */
    private String huodong_title;












    // get/set
    public String getShowState() {
        String state = (String)getConfig("st_"+this.state);
        if(state == null){
            state = "未知";
        }
        return state;
    }

    SimpleDateFormat sdf = DateUtil.getSdfFull();

    public String getShowHuodong_startTime() {
        Long startTime = this.getHuodong_startTime();

        if(startTime != null){
            return sdf.format(new Date(startTime));
        }
        return "";
    }

    public void setInHuodong_startTime(String huodong_startTime) {
        try {
            Long strate_time = sdf.parse(huodong_startTime).getTime();
            this.huodong_startTime = strate_time;
        } catch (ParseException e) { }
    }

    public String getShowHuodong_endTime() {
        Long endTime = this.getHuodong_endTime();

        if(endTime != null){
            return sdf.format(new Date(endTime));
        }
        return "";
    }

    public void setInHuodong_endTime(String huodong_endTime) {
        try {
            Long end_time = sdf.parse(huodong_endTime).getTime();
            this.huodong_endTime = end_time;
        } catch (ParseException e) { }
    }


    public Merchant72 getMerchant72() {
        if(MyUtil.isValid(this.getMerchant_id())){
            Merchant72 merchant72 = new Merchant72();
            merchant72 = (Merchant72) ContextUtil.getSerializContext().get(Merchant72.class,this.getMerchant_id());
            if(merchant72 != null){
                return  merchant72;
            }
        }
        return merchant72;
    }

    public void setMerchant72(Merchant72 merchant72) {
        if(merchant72 != null && MyUtil.isValid(merchant72.getId())){
            this.merchant_id = merchant72.getId();
        }
        this.merchant72 = merchant72;
    }

    public Long getHuodong_startTime() {
        return huodong_startTime;
    }

    public void setHuodong_startTime(Long huodong_startTime) {
        this.huodong_startTime = huodong_startTime;
    }

    public Long getHuodong_endTime() {
        return huodong_endTime;
    }

    public void setHuodong_endTime(Long huodong_endTime) {
        this.huodong_endTime = huodong_endTime;
    }

    public Integer getFenshu() {
        return fenshu;
    }

    public void setFenshu(Integer fenshu) {
        this.fenshu = fenshu;
    }

    public Integer getDaojishi() {
        return daojishi;
    }

    public void setDaojishi(Integer daojishi) {
        this.daojishi = daojishi;
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

    public String getShow_zhekou() {
        return show_zhekou;
    }

    public void setShow_zhekou(String show_zhekou) {
        this.show_zhekou = show_zhekou;
    }

    public Long getZhekou_qian() {
        return zhekou_qian;
    }

    public void setZhekou_qian(Long zhekou_qian) {
        this.zhekou_qian = zhekou_qian;
    }

    public void setInZhekou_qian(Double zhekou_qian) {
        if (zhekou_qian != null) {
            this.zhekou_qian = (long)(zhekou_qian *zhkou_pianyi);
        }
    }

    public Long getZhekou_hou() {
        return zhekou_hou;
    }

    public void setZhekou_hou(Long zhekou_hou) {
        this.zhekou_hou = zhekou_hou;
    }

    public void setInZhekou_hou(Double zhekou_hou) {
        if (zhekou_hou != null) {
            this.zhekou_hou = (long)(zhekou_hou *zhkou_pianyi);
        }
    }

    public Integer getXuyao_haoyou() {
        return xuyao_haoyou;
    }

    public void setXuyao_haoyou(Integer xuyao_haoyou) {
        this.xuyao_haoyou = xuyao_haoyou;
    }

    public String getMerchant_id() {
        return merchant_id;
    }

    public void setMerchant_id(String merchant_id) {
        this.merchant_id = merchant_id;
    }

    public Integer getYijing_goumei() {
        return yijing_goumei;
    }

    public void setYijing_goumei(Integer yijing_goumei) {
        this.yijing_goumei = yijing_goumei;
    }

    public String getHuodong_name() {
        return huodong_name;
    }

    public void setHuodong_name(String huodong_name) {
        this.huodong_name = huodong_name;
    }

    public String getHuodong_title() {
        return huodong_title;
    }

    public void setHuodong_title(String huodong_title) {
        this.huodong_title = huodong_title;
    }
}
