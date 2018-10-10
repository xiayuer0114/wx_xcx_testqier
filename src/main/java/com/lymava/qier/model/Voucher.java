package com.lymava.qier.model;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import com.alipay.api.domain.Data;
import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;
import com.lymava.qier.util.SunmingUtil;
import com.mongodb.BasicDBList;
import com.mongodb.connection.ConnectionId;

public class Voucher extends BaseModel {

    /**
	 * 
	 */
	private static final long serialVersionUID = 2437588507079082841L;

    public static final Integer voucherState_editing = 0;       // 商家编辑中
    public static final Integer voucherState_now = 1;           // 发布中
    public static final Integer voucherState_stop = 2;          // 已结束
    public static final Integer voucherState_timeout = 3;       // 已过期
    public static final Integer voucherState_wait = 4;          // 待审核

    public static Integer use_And_get_default_time = -1;            // 领取和使用为 全天领取,全天使用

        //所属商家	如果这个为空就是通用代金卷
	private User user_merchant;

	    // 存在 topUserId   平台也是一个商家(平台这个商家的id固定)       (以前的设计理论)过时:存在:自定商家使用   不存在:通用(就是平台发放)
    private String topUserId;

        // 代金券名称   类似: XX豪华代金券
    private String voucherName;

        // 代金券描述   如: "全场满100立马减30"
    private String voucherMiaoSu;

        // 代金券价值	单位元
    private Long voucherValue_fen;

    	// 最低消费额	单位元
    private Long low_consumption_amount;

        //最高消费金额
    private Long hight_consumption_amount;

        // 代金券总数量  商户发布出来的代金券的数量
    private Integer voucherCount;

        // 已经发出的数量
    private Integer voucherOutCount;

        // 发布时间
    private Long releaseTime;

        // 代金券有效时间
    private Long stopTime;

         // 商家端的代金券状态  只有state为1的时候,用户才能领取
    private Integer state;

        // 代金券的图片
    private String logo;

        // 用户可以使用的开始时间
    private Long useReleaseTime;

        // 用户可以使用的最后时间
    private Long useStopTime;
        // 用于展示的字段
    private String showNickName;
    private String showState;
    private String showUseTime;
    private String showGetTime;




    //所有被重写的get/set方法
	public User getUser_merchant() {
		if (user_merchant == null && MyUtil.isValid(this.topUserId)) {
			user_merchant = (User) ContextUtil.getSerializContext().get(User.class, topUserId);
		}
		return user_merchant;
	}

	public void setUser_merchant(User user_merchant) {
		if (user_merchant != null) {
			topUserId = user_merchant.getId();
		}
		this.user_merchant = user_merchant;
	}

    public void setInStopTime(String stopTime) {
        Date date = null;
        try {
            date = DateUtil.getSdfShort().parse(stopTime);
            this.stopTime = date.getTime();
        } catch (ParseException e) {
        }
    } 

    public void setInReleaseTime(String releaseTime_str){
         try {
            Date date = DateUtil.getSdfFull().parse(releaseTime_str);
            this.releaseTime = date.getTime();
        } catch (ParseException e) {
        }
    }

    public String getShowInReleaseTime(){
        if (this.getReleaseTime() == null){
            return "";
        }
        Date date = new Date(this.getReleaseTime());
        return DateUtil.getSdfShort().format(date);
    }

    public String getShowInStopTime(){
        if (this.getStopTime()==null || "".equals(this.getStopTime())){
            return "长期有效";
        }else {
            Date date= new Date(this.getStopTime());
            return DateUtil.getSdfShort().format(date);
        }
    }

    public String getShowInNickName(){
    	User user_merchant_tmp = this.getUser_merchant();
        if (user_merchant_tmp == null){
            return "";
        }
        return user_merchant_tmp.getNickname();
    }

    public String getShowInAddress(){
    	User user_merchant_tmp = this.getUser_merchant();
        if (user_merchant_tmp == null){
            return "";
        }
        return user_merchant_tmp.getAddr();
    }

    public String getShowInState(){
        if(this.state == voucherState_now){
            return "发布中";
        }
        if(this.state == voucherState_stop){
            return "已结束";
        }
        if(this.state == voucherState_timeout){
            return "已过期";
        }
        if(this.stopTime !=null){
            if(this.stopTime < System.currentTimeMillis()){
                Voucher voucher = new Voucher();
                voucher.setState(voucherState_timeout);
                ContextUtil.getSerializContext().updateObject(this.id,voucher);
                return "已过期";
            }
        }
        if(this.state == voucherState_wait){
            return "待审核";
        }
        if(this.state == voucherState_editing){
            return "商家编辑中";
        }
        return "";
    }


    public String getShowUseReleaseTime() {
    	if(useReleaseTime == null){
    		return "";
    	}
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH");
        Date out_date= new Date(useReleaseTime);
        return simpleDateFormat.format(out_date);
//    	return DateUtil.getSdfShort().format(new Date(releaseTime));
    }

    public String getShowUseStopTime(){
        if(useStopTime == null){
            return "";
        }
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH");
        Date out_date= new Date(useStopTime);
        return simpleDateFormat.format(out_date);
    }

    public String getShowReleaseTime() {

        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH");
        Date out_date= new Date(releaseTime);
        return simpleDateFormat.format(out_date);
    }

    public String getShowStopTime() {
    	if(stopTime == null){
    		return "";
    	}
    	if(SunmingUtil.dateStrToLongYMD("2999-12-12").equals(stopTime)){
            return "";
        }

        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH");
        Date out_date= new Date(releaseTime);
        return simpleDateFormat.format(out_date);
//    	return DateUtil.getSdfShort().format(new Date(stopTime));
    }

    public void setShowUseReleaseTime(String date_str){
        this.useReleaseTime = SunmingUtil.dateStrToLongYMD_h(date_str);
    }

    public void setShowUseStopTime(String date_str){
        this.useStopTime = SunmingUtil.dateStrToLongYMD_h(date_str);
    }

    public String getInShowStopTime() {
        if(stopTime == null){
            return "";
        }
        if(SunmingUtil.dateStrToLongYMD("2999-12-12").equals(stopTime)){
            return "";
        }
        return DateUtil.getSdfShort().format(new Date(stopTime));
    }

    public void setVoucherValue(Double voucherValue) {
        voucherValue_fen = MathUtil.multiply(voucherValue, 100).longValue();
    }

    public Long getUseWhere() {
        if (low_consumption_amount==null){
            return 0L;
        }
        return low_consumption_amount;
    }









    // 所有原始的get/set方法
    public Long getUseReleaseTime() {
        return useReleaseTime;
    }

    public void setUseReleaseTime(Long useReleaseTime) {
        this.useReleaseTime = useReleaseTime;
    }

    public Long getUseStopTime() {
        return useStopTime;
    }

    public void setUseStopTime(Long useStopTime) {
        this.useStopTime = useStopTime;
    }

    public String getVoucherMiaoSu() {
        return voucherMiaoSu;
    }

    public Long getHight_consumption_amount() {
        return hight_consumption_amount;
    }

    public void setHight_consumption_amount(Long hight_consumption_amount) {
        this.hight_consumption_amount = hight_consumption_amount;
    }

    public void setLow_consumption_amount(Long low_consumption_amount) {
        this.low_consumption_amount = low_consumption_amount;
    }

    public String getLogo() {
        return logo;
    }

    public void setLogo(String logo) {
        this.logo = logo;
    }

    public Long getLow_consumption_amount() {
        return low_consumption_amount;
    }

    public String getShowNickName() {
        return showNickName;
    }

    public String getShowState() {
        return showState;
    }

    public void setShowState(String showState) {
        this.showState = showState;
    }

    public void setShowNickName(String showNickName) {
        this.showNickName = showNickName;
    }

    public Integer getVoucherOutCount() {
        return voucherOutCount;
    }

    public void setVoucherOutCount(Integer voucherOutCount) {
        this.voucherOutCount = voucherOutCount;
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

    public Long getStopTime() {
        return stopTime;
    }

    public void setStopTime(Long stopTime) {
        this.stopTime = stopTime;
    }

    public Long getReleaseTime() {
        return releaseTime;
    }

    public void setReleaseTime(Long releaseTime) {
        this.releaseTime = releaseTime;
    }

    public String getTopUserId() {
        return topUserId;
    }

    public void setTopUserId(String topUserId) {
        this.topUserId = topUserId;
    }

    public String getVoucherName() {
        return voucherName;
    }

    public void setVoucherName(String voucherName) {
        this.voucherName = voucherName;
    }

    public void setVoucherMiaoSu(String voucherMiaoSu) {
        this.voucherMiaoSu = voucherMiaoSu;
    }
    
    public Long getVoucherValue_fen() {
		return voucherValue_fen;
	}

	public void setVoucherValue_fen(Long voucherValue_fen) {
		this.voucherValue_fen = voucherValue_fen;
	}

	public Double getVoucherValue() {
        return MathUtil.divide(voucherValue_fen, 100).doubleValue();
    }

    public Integer getVoucherCount() {
        return voucherCount;
    }

    public void setVoucherCount(Integer voucherCount) {
        this.voucherCount = voucherCount;
    }

    public void setUseWhere(Long useWhere) {
        this.low_consumption_amount = useWhere;
    }

    public void setShowUseTime(String showUseTime) {
        this.showUseTime = showUseTime;
    }

    public void setShowGetTime(String showGetTime) {
        this.showGetTime = showGetTime;
    }




    public static final Integer fubu_state_success = 1;   // 发布代金券成功
    public static final Integer fubu_state_error = 2;   // 发布代金券失败

    public Integer fabuOneVoucher(){
        // voucherCount;  代金券总数量
        // voucherOutCount; 代金券已发出的数量

        Integer result = fubu_state_success;

        if (this.voucherOutCount >= this.voucherCount ){   // 已经发放完了
            this.state = voucherState_stop;
            result = fubu_state_error;
        };
        if (this.state != voucherState_now){ result = fubu_state_error;};   // 状态不在发布中
        if (this.stopTime < System.currentTimeMillis()){        // 过期
            this.state = voucherState_timeout;
            result = fubu_state_error;
        }

        if (result.equals(fubu_state_success) ){
            this.voucherOutCount = this.voucherOutCount+1;
        }

        ContextUtil.getSerializContext().updateObject(this.id,this);

        return result;
    }



}
