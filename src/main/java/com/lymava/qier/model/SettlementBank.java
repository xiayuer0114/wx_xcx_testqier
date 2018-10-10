package com.lymava.qier.model;

import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;

/**
 * 结算账户绑定
 * @author lymava
 *
 */
public class SettlementBank extends BaseModel{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 6581357864577583912L;


	/**
	 * 银行名称    农业银行,工商银行等   支付宝/微信
	 */
	private String bankName;
	/**
	 * 开户行		如农业银行下的支行    null(支付宝)
	 */
	private String depositary_bank;
	/**
	 * 开户行地址
	 */
	private String bank_addr;
	/**
	 * 帐号			银行卡号            支付宝/微信账号
	 */
	private String account;
	/**
	 * 账户名称		公司名称/个人名称
	 */
	private String name;
	/**
	 * 状态
	 */
	private Integer state;
	/**
	 * 备注
	 */
	private String memo; 
	/**
	 * 商户用户
	 */
	private Merchant72 merchant72;
	/**
	 * 商户用户编号
	 */
	private String merchant72_id; 
	/**
	 * 工商银行
	 */
	public static final Integer  bank_type_gongshang = 201;
	/**
	 * 招商银行
	 */
	public static final Integer  bank_type_zhaoshang = 202;
	/**
	 * 农业银行
	 */
	public static final Integer  bank_type_nongye = 203;
	/**
	 * 建设银行
	 */
	public static final Integer  bank_type_jianshe = 204;
	/**
	 * 中国银行
	 */
	public static final Integer  bank_type_zhongguo = 205;
	/**
	 * 光大银行
	 */
	public static final Integer  bank_type_guangda = 206;
	/**
	 * 兴业银行
	 */
	public static final Integer  bank_type_xingye = 207;
	/**
	 * 民生银行
	 */
	public static final Integer  bank_type_minsheng = 208;
	/**
	 * 华夏银行
	 */
	public static final Integer  bank_type_huaxia = 209;
	/**
	 * 重庆农村商业银行
	 */
	public static final Integer  bank_type_cq_nongshanghang = 210;
	/**
	 * 广发银行
	 */
	public static final Integer  bank_type_guangfa = 211;
	/**
	 * 交通银行
	 */
	public static final Integer  bank_type_jiaotong = 212;
	/**
	 * 平安银行
	 */
	public static final Integer  bank_type_pingan = 213;
	/**
	 * 上海浦东发展银行
	 */
	public static final Integer  bank_type_shanghaipudongfazhan = 214;
	/**
	 * 重庆银行
	 */
	public static final Integer  bank_type_chongqingyinhang = 215;
	/**
	 * 恒丰银行
	 */
	public static final Integer  bank_type_hengfeng = 216;
	/**
	 * 宁波银行
	 */
	public static final Integer  bank_type_ningbo = 217; 
	/**
	 * 哈尔滨银行
	 */
	public static final Integer  bank_type_haerbing = 218; 
	
	/**
	 * 未知
	 */
	public static final Integer  bank_type_weizhi = 317; 
	/**
	 * 银行卡类型
	 */
	private Integer bank_type;
	
	static{
		putConfig(SettlementBank.class, "state_"+State.STATE_OK, "正常使用");
		putConfig(SettlementBank.class, "state_"+State.STATE_FALSE, "暂停使用");
		
		putConfig(SettlementBank.class, "bank_type_"+bank_type_gongshang, "工商银行");
		putConfig(SettlementBank.class, "bank_type_"+bank_type_zhaoshang, "招商银行");
		putConfig(SettlementBank.class, "bank_type_"+bank_type_nongye, "农业银行");
		putConfig(SettlementBank.class, "bank_type_"+bank_type_jianshe, "建设银行");
		putConfig(SettlementBank.class, "bank_type_"+bank_type_zhongguo, "中国银行");
		putConfig(SettlementBank.class, "bank_type_"+bank_type_guangda, "光大银行");
		putConfig(SettlementBank.class, "bank_type_"+bank_type_xingye, "兴业银行");
		putConfig(SettlementBank.class, "bank_type_"+bank_type_minsheng, "民生银行");
		putConfig(SettlementBank.class, "bank_type_"+bank_type_huaxia, "华夏银行");
		putConfig(SettlementBank.class, "bank_type_"+bank_type_cq_nongshanghang, "重庆农村商业银行");
		
		putConfig(SettlementBank.class, "bank_type_"+bank_type_guangfa, "广发银行");
		putConfig(SettlementBank.class, "bank_type_"+bank_type_jiaotong, "交通银行");
		putConfig(SettlementBank.class, "bank_type_"+bank_type_pingan, "平安银行");
		putConfig(SettlementBank.class, "bank_type_"+bank_type_shanghaipudongfazhan, "上海浦东发展银行");
		putConfig(SettlementBank.class, "bank_type_"+bank_type_chongqingyinhang, "重庆银行");
		putConfig(SettlementBank.class, "bank_type_"+bank_type_hengfeng, "恒丰银行");
		putConfig(SettlementBank.class, "bank_type_"+bank_type_ningbo, "宁波银行");
		putConfig(SettlementBank.class, "bank_type_"+bank_type_haerbing, "哈尔滨银行");
		putConfig(SettlementBank.class, "bank_type_"+bank_type_weizhi, "未知");
	}
	public Merchant72 getMerchant72() {
		if(this.merchant72 == null && MyUtil.isValid(this.getMerchant72_id()) ){
			this.merchant72 =  (Merchant72) ContextUtil.getSerializContext().get(Merchant72.class, this.getMerchant72_id());
		}
		return merchant72;
	}
	public void setMerchant72(Merchant72 merchant72) {
		if(merchant72 != null){
			this.merchant72_id = merchant72.getId();
		}
		this.merchant72 = merchant72;
	}
	public String getMerchant72_id() {
		return merchant72_id;
	}
	public void setMerchant72_id(String merchant72_id) {
		this.merchant72_id = merchant72_id;
	} 
	public String getShowState(){
		 return (String) getConfig("state_"+this.getState());
	}
	public String getShowBank_type() {
		return (String) getConfig("bank_type_"+this.getBank_type());
	}
	public String getDepositary_bank() {
		return depositary_bank;
	}
	public void setDepositary_bank(String depositary_bank) {
		this.depositary_bank = depositary_bank;
	} 
	public String getBankName() {
		return bankName;
	}
	public void setBankName(String bankName) {
		this.bankName = bankName;
	}
	public String getAccount() {
		return account;
	}
	public void setAccount(String account) {
		this.account = account;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Integer getState() {
		return state;
	}
	public void setState(Integer state) {
		this.state = state;
	}
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
	public Integer getBank_type() {
		return bank_type;
	}
	public void setBank_type(Integer bank_type) {
		this.bank_type = bank_type;
	}
	public String getBank_addr() {
		return bank_addr;
	}
	public void setBank_addr(String bank_addr) {
		this.bank_addr = bank_addr;
	}

	/**
	 * 显示银行名称
	 * @return
	 */
	public String getShowBankName() {
		return (String) getConfig("bank_type_" + bank_type);
	}
}
