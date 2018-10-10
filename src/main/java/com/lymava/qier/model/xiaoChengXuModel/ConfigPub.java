package com.lymava.qier.model.xiaoChengXuModel;

import com.lymava.base.model.Pub;

public class ConfigPub extends Pub {

    // 得到 小程序 的根节点
    public static String getXiaochengxu(){ return "5b5acdb3d6c45965a5c2e9bb"; }

    // 得到 类型配置 的根节点
    public static String getLeixingpeizhi(){ return "5b5acee9d6c45965a5c2fc6b"; }

    // 得到 小程序配置 的根节点
    public static String getXiaochengxupeizhi(){ return "5b5acedfd6c45965a5c2fbd4"; }

    // 得到 专题 的根节点
    public static String getZhuanti(){ return "5b5aced8d6c45965a5c2fb5b"; }

    // 得到 区域 的根节点
    public static String getQuyu(){ return "5b5aced0d6c45965a5c2fadb"; }

    // 得到 推荐卡 的根节点
    public static String getTuijianka(){ return "5b5acecbd6c45965a5c2fa8d"; }

    // 得到 区域下重庆 的根节点
    public static String getChongqing(){ return "5b5ad062d6c45965a5c31355"; }












    /**
     * 配置名
     */
    private String name;

    /**
     * 键
     */
    private String key;

    /**
     * 值
     */
    private String value;

    /**
     * 备注
     */
    private String memo;



    @Override
    public String getName() {
        return name;
    }

    @Override
    public void setName(String name) {
        this.name = name;
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }
}
