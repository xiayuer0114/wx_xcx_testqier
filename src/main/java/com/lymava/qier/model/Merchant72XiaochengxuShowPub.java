package com.lymava.qier.model;

public class Merchant72XiaochengxuShowPub  implements Comparable<Merchant72XiaochengxuShowPub>{

    // 一个商家
    private MerchantPub merchantPub;

    // 当前位置离这个商家的临时距离
    private Double distance_temp;



    public Double getDistance_temp() {
        return distance_temp;
    }

    public void setDistance_temp(Double distance_temp) {
        this.distance_temp = distance_temp;
    }

    public MerchantPub getMerchantPub() {
        return merchantPub;
    }

    public void setMerchantPub(MerchantPub merchantPub) {
        this.merchantPub = merchantPub;
    }


    @Override
    public int compareTo(Merchant72XiaochengxuShowPub m) {
        // 按临时距离 由近到远排序
        Integer i = (int)(this.getDistance_temp() - m.getDistance_temp());
        return i;
    }
}
