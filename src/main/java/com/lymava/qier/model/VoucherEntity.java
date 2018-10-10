package com.lymava.qier.model;

public class VoucherEntity {

    // 代金券id
    private String id;

    // 商家名
    private String userName;

    // 代金券名
    private String voucherName;

    // 地址
    private String address;

    // 图片 (暂留 可能是一个url地址)
    private String voucherPicture;

    // 代金券的总数量
    private Integer voucherCount;

    // 已发出的代金券的数量
    private Integer voucherOutCount;

    // 代金券的价值,面额  单位元
    private Double voucherValue;

    //  最低消费额度  (满low_consumption_amount减voucherValue)
    private Long low_consumption_amount;

    // 用于展示的开始时间
    private String showReleaseTime;

    // 用于展示的结束时间
    private String showStopTime;

    // 代金券图片路径
    private String logo;

    // 代金券发出数量和总数量的比例
    private Integer countRatio;

    // 用于展示的可以使用的开始时间
    private String showUseReleaseTime;

    // 用于展示的可以使用的结束时间
    private String showUseStopTime;







    public String getShowUseReleaseTime() {
        return showUseReleaseTime;
    }

    public void setShowUseReleaseTime(String showUseReleaseTime) {
        this.showUseReleaseTime = showUseReleaseTime;
    }

    public String getShowUseStopTime() {
        return showUseStopTime;
    }

    public void setShowUseStopTime(String showUseStopTime) {
        this.showUseStopTime = showUseStopTime;
    }

    public float getShowCountRatio() {
        return ((float) this.voucherOutCount/(float)this.voucherCount)*100;
    }

    public Integer getCountRatio() {
        return countRatio;
    }

    public void setCountRatio(Integer countRatio) {
        this.countRatio = countRatio;
    }

    public String getLogo() {
        return logo;
    }

    public void setLogo(String logo) {
        this.logo = logo;
    }

    public String getShowReleaseTime() {
        return showReleaseTime;
    }

    public void setShowReleaseTime(String showReleaseTime) {
        this.showReleaseTime = showReleaseTime;
    }

    public String getShowStopTime() {
        return showStopTime;
    }

    public void setShowStopTime(String showStopTime) {
        this.showStopTime = showStopTime;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Integer getVoucherCount() {
        return voucherCount;
    }

    public void setVoucherCount(Integer voucherCount) {
        this.voucherCount = voucherCount;
    }

    public Integer getVoucherOutCount() {
        return voucherOutCount;
    }

    public void setVoucherOutCount(Integer voucherOutCount) {
        this.voucherOutCount = voucherOutCount;
    }

    public Double getVoucherValue() {
        return voucherValue;
    }

    public void setVoucherValue(Double voucherValue) {
        this.voucherValue = voucherValue;
    }

    public Long getLow_consumption_amount() {
        return low_consumption_amount;
    }

    public void setLow_consumption_amount(Long low_consumption_amount) {
        this.low_consumption_amount = low_consumption_amount;
    }

    public String getVoucherName() {
        return voucherName;
    }

    public void setVoucherName(String voucherName) {
        this.voucherName = voucherName;
    }
}
