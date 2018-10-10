package com.lymava.qier.model;

import com.lymava.base.model.BalanceLog;
import com.lymava.base.model.User;
import com.lymava.base.safecontroler.model.UserV2;
import com.lymava.base.util.ContextUtil;
import com.lymava.qier.util.SunmingUtil;

/**
 * 孙M   创建时间不详  这个类用于显示商家预付款的详细变动情况
 *       6.14 修改了所有字段  原来的字段没有删再下面注释起的
 */
public class DuizhangEntity {

    // 用于显示的时间
    private String showTime;

    // 这一次的充值金额   count = balance + discount;
    private String count;

    // 这一次实际打的钱  balance = count -  discount;
    private String balance;

    // 折扣额度 (赚的钱)   discount = count - balance ;
    private String discount;

    // 操作人员姓名
    private String adminName;

    // 这个操作人员 添加的备注信息   用的是back_memo这个字段  (  balanceLog72.getBack_memo()  )
    private String memo;




    public String getShowTime() {
        return showTime;
    }

    public void setShowTime(String showTime) {
        this.showTime = showTime;
    }

    public String getCount() {
        return count;
    }

    public void setCount(String count) {
        this.count = count;
    }

    public String getBalance() {
        return balance;
    }

    public void setBalance(String balance) {
        this.balance = balance;
    }

    public String getDiscount() {
        return discount;
    }

    public void setDiscount(String discount) {
        this.discount = discount;
    }

    public String getAdminName() {
        return adminName;
    }

    public void setAdminName(String adminName) {
        this.adminName = adminName;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }






    //    // 商家id
//    private String merchartId;
//
//    // 商家的实体
//    private Merchant72 merchant72;
//
//    // 面值总余额
//    private Long balanceCount;
//
//    // 充值总余额
//    private Long topUpBalance;
//
//    // 折扣额
//    private Long discount;
//
//    // 支付总额
//    private Long price_all;
//
//    // 支付宝支付
//    private Long price_alipay;
//
//    // 微信支付
//    private Long price_wechatpay;
//
//    // 代金券/红包支付的钱
//    private Long redpay;
//
//    // 初始余额    开始时间前 最后一笔订单后的剩余余额
//    private Long start_remaining_balance ;
//
//    // 面值余额    结束时间前 最后一笔订单后的剩余余额
//    private Long end_remaining_balance;
//
//
//    // 备注
//    private String memo;
//
//    // 操作人员id
//    private String adminId;
//
//    // 操作人员id
//    private UserV2 adminUser;
//
//
//
//
//    // ↓  被重写的 get/set 方法
//
//    public Merchant72 getMerchant72() {
//        if (SunmingUtil.strIsNull(this.merchartId)){
//            return null;
//        }
//        return (Merchant72)ContextUtil.getSerializContext().get(Merchant72.class,this.merchartId);
//    }
//
//    public void setMerchant72(Merchant72 merchant72) {
//        this.merchant72 = merchant72;
//        this.merchartId = merchant72.getId();
//    }
//
//    public UserV2 getAdminUser() {
//        if (this.adminId != null ){
//            UserV2 admin = (UserV2) ContextUtil.getSerializContext().get(UserV2.class,this.adminId);
//            return admin;
//        }
//        return adminUser;
//    }
//
//    public void setAdminUser(UserV2 adminUser) {
//        if (adminUser != null){
//            this.adminId = adminUser.getId();
//        }
//        this.adminUser = adminUser;
//    }
//
//
//
//
//
//
//
//
//    // 原始的 get/set 方法
//    public String getMemo() {
//        return memo;
//    }
//
//    public void setMemo(String memo) {
//        this.memo = memo;
//    }
//
//    public String getAdminId() {
//        return adminId;
//    }
//
//    public void setAdminId(String adminId) {
//        this.adminId = adminId;
//    }
//
//    public String getMerchartId() {
//        return merchartId;
//    }
//
//    public void setMerchartId(String merchartId) {
//        this.merchartId = merchartId;
//    }
//
//    public Long getBalanceCount() {
//        return balanceCount;
//    }
//
//    public void setBalanceCount(Long balanceCount) {
//        this.balanceCount = balanceCount;
//    }
//
//    public Long getTopUpBalance() {
//        return topUpBalance;
//    }
//
//    public void setTopUpBalance(Long topUpBalance) {
//        this.topUpBalance = topUpBalance;
//    }
//
//    public Long getDiscount() {
//        return discount;
//    }
//
//    public void setDiscount(Long discount) {
//        this.discount = discount;
//    }
//
//    public Long getPrice_all() {
//        return price_all;
//    }
//
//    public void setPrice_all(Long price_all) {
//        this.price_all = price_all;
//    }
//
//    public Long getPrice_alipay() {
//        return price_alipay;
//    }
//
//    public void setPrice_alipay(Long price_alipay) {
//        this.price_alipay = price_alipay;
//    }
//
//    public Long getPrice_wechatpay() {
//        return price_wechatpay;
//    }
//
//    public void setPrice_wechatpay(Long price_wechatpay) {
//        this.price_wechatpay = price_wechatpay;
//    }
//
//    public Long getRedpay() {
//        return redpay;
//    }
//
//    public void setRedpay(Long redpay) {
//        this.redpay = redpay;
//    }
//
//    public Long getStart_remaining_balance() {
//        return start_remaining_balance;
//    }
//
//    public void setStart_remaining_balance(Long start_remaining_balance) {
//        this.start_remaining_balance = start_remaining_balance;
//    }
//
//    public Long getEnd_remaining_balance() {
//        return end_remaining_balance;
//    }
//
//    public void setEnd_remaining_balance(Long end_remaining_balance) {
//        this.end_remaining_balance = end_remaining_balance;
//    }
}
