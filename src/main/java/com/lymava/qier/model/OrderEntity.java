package com.lymava.qier.model;

public class OrderEntity {
    // 订单在商户端的公众号只用到了 几个字段  订单名在一个关联表中

    private String payFlow;
    private String tradeRecord72Name;
    private Long price_fen_all;
    private String payTime;
    private String memo;
    private String payMethed;
    private Integer payMethedInteger;
    private String picName;


    public String getPayFlow() {
        return payFlow;
    }

    public void setPayFlow(String payFlow) {
        this.payFlow = payFlow;
    }

    public String getPicName() {
        return picName;
    }

    public void setPicName(String picName) {
        this.picName = picName;
    }

    public Integer getPayMethedInteger() {
        return payMethedInteger;
    }

    public void setPayMethedInteger(Integer payMethedInteger) {
        this.payMethedInteger = payMethedInteger;
    }

    public String getPayMethed() {
        return payMethed;
    }

    public void setPayMethed(String payMethed) {
        this.payMethed = payMethed;
    }

    public String getTradeRecord72Name() {
        return tradeRecord72Name;
    }

    public void setTradeRecord72Name(String tradeRecord72Name) {
        this.tradeRecord72Name = tradeRecord72Name;
    }

    public Long getPrice_fen_all() {
        return price_fen_all;
    }

    public void setPrice_fen_all(Long price_fen_all) {
        this.price_fen_all = price_fen_all;
    }

    public String getPayTime() {
        return payTime;
    }

    public void setPayTime(String payTime) {
        this.payTime = payTime;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }
}
