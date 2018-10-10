package com.lymava.qier.business;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.lymava.trade.base.annotation.BusinessIntId;

public final class BusinessIntIdConfigQier{
	
	protected static final Log logger = LogFactory.getLog(BusinessIntIdConfigQier.class);
	
	/**
	 * 翻倍返现
	 */
	@BusinessIntId(name="翻倍返现")
	public static final Integer businessIntId_give_back 	= 			31100;
	/**
	 * 红包返现
	 */
	@BusinessIntId(name="红包返现")
	public static final Integer businessIntId_half_give_back 	= 			31101;
	/**
	 * 红包翻倍
	 */
	@BusinessIntId(name="红包翻倍")
	public static final Integer businessIntId_another_give_back 	= 				31102;
	/**
	 * 618活动返利
	 */
	@BusinessIntId(name="618活动返利")
	public static final Integer businessIntId_618 	= 			31168;
	/**
	 * 定向红包充值
	 */
	@BusinessIntId(name="定向红包消费充值")
	public static final Integer businessIntId_dingxiang 	= 			31103;
	/**
	 * 商户转账
	 */
	@BusinessIntId(name="商户转账")
	public static final Integer businessIntId_transfer_to_merchant = 	31104;
	/**
	 * 商户预付款变动
	 */
	@BusinessIntId(name="商户预付款变动")
	public static final Integer businessIntId_transfer_to_merchant_change = 	31105;
	/**
	 * 商户手动转账
	 */
	@BusinessIntId(name="商户手动转账")
	public static final Integer businessIntId_manual_transfer_to_merchant = 	31106;
	/**
	 * JAY迷刮刮卡返利
	 */
	@BusinessIntId(name="JAY迷刮刮卡返利")
	public static final Integer businessIntId_720 	= 			31720;
	/**
	 * 用户合并红包转移
	 */
	@BusinessIntId(name="用户合并红包转移")
	public static final Integer businessIntId_user_hebing_hongbao 	= 				31721;
	/**
	 * 七日签到奖励
	 */
	@BusinessIntId(name="七日签到")
	public static final Integer businessIntId_qiri	= 33310;
	/**
	 * 体验官红包
	 */
	@BusinessIntId(name="体验官红包")
	public static final Integer businessIntId_tiyanguan	= 33320;
	/**
	 * 小程序新用户奖励
	 */
	@BusinessIntId(name="小程序新用户奖励")
	public static final Integer businessIntId_newUser	= 33330;
	/**
	 * 小程序新用户奖励
	 */
	@BusinessIntId(name="小程序七日签到")
	public static final Integer businessIntId_xiaochengxuQianDao = 33340;
	/**
	 * 清凉计划
	 */
	@BusinessIntId(name="清凉计划")
	public static final Integer businessIntId_qingliang = 33350;
	/**
	 * 老地点
	 */
	@BusinessIntId(name="老地点")
	public static final Integer businessIntId_didian = 33360;
	/**
	 *
	 */
	@BusinessIntId(name="红包裂变")
	public static final Integer businessIntId_liebian = 33370;
	/**
	 * 圣慕缇集卡活动
	 */
	@BusinessIntId(name="圣慕缇集卡")
	public static final Integer businessIntId_jika = 33380;
	/** 
	 * 比如某用户消费之后抽奖领取了通用红包
	 * 那么这里酒需要把抽取的通用红包按退款比例回退
	 * 如一个用户消费了1000  抽取了10元的通用红包
	 * 那么这里 如果用户退款500
	 * 订单通用红包回退
	 */
	@BusinessIntId(name="订单通用红包回退")
	public static final Integer businessIntId_refund_tongyong =	43001; 
	/** 
	 * 商户回调多支付回退
	 */ 
	@BusinessIntId(name="商户回调多支付回退")
	public static final Integer businessIntId_refund_pay_twice =	44001; 
	/**
	 * 
	 * 系统操作业务
	 * 
	 * 商家预下架
	 */
	@BusinessIntId(name="商家预下架")
	public static final Integer businessIntId_merchant_yuxiajia = 50000;
	/**
	 *
	 * 系统操作业务
	 *
	 * 商家红包转移
	 */
	@BusinessIntId(name="商家红包转移")
	public static final Integer businessIntId_merchant_hongbaozhuanyi = 50010;
	/**
	 *
	 * 系统操作业务
	 *
	 * 用户红包转移
	 */
	@BusinessIntId(name="用户红包转移")
	public static final Integer businessIntId_merchant_user_hongbaozhuanyi = 50020;


	/**
	 * 红包池变动
	 */
	@BusinessIntId(name="红包池变动")
	public static final Integer businessIntId_red_envelope_change = 50030;

	/**
	 * 银行卡变更
	 */
	@BusinessIntId(name="银行卡变更")
	public static final Integer businessIntId_bank_change = 50040;

	/**
	 * 返利配置请求
	 */
	@BusinessIntId(name="返利配置请求")
	public static final Integer businessIntId_change_ratio = 50050;
	
	/**
	 * 收银/点餐 相关的业务 60000-70000
	 */
	/**
	 * 账单项记录
	 */
	@BusinessIntId(name="账单项记录")
	public static final Integer businessIntId_bill_item = 60000;
	/**
	 * 账单主记录
	 */
	@BusinessIntId(name="账单主记录")
	public static final Integer businessIntId_bill_main = 60001;
	/**
	 * 中秋月饼活动
	 */
	@BusinessIntId(name="中秋月饼活动")
	public static final Integer businessIntId_zhongqiu_yuebing = 60002;
	/**
	 * 圣慕缇一点红68.8报名
	 */
	@BusinessIntId(name="圣慕缇一点红68.8报名")
	public static final Integer businessIntId_shengmuti_baoming = 60003;
}
