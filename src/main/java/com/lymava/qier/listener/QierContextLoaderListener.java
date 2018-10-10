package com.lymava.qier.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import com.lymava.qier.activities.guaguaka.GuaguakaShareBusiness;
import com.lymava.qier.activities.qingliang.QingliangShareBusiness;
import com.lymava.qier.activities.qixi.Qixi2018ShareBusiness;
import com.lymava.qier.activities.sharebusiness.GaokaoShareBusiness;
import com.lymava.qier.activities.sharebusiness.KOL200ShareBusiness;
import com.lymava.qier.activities.sharebusiness.LiuyibaShareBusiness;
import com.lymava.qier.activities.sharebusiness.NazhongrenShareBusiness;
import com.lymava.qier.activities.sharebusiness.SubscribeFirstRedEnvelopeShareBusiness;
import com.lymava.qier.activities.sharebusiness.WorldCupForecastShareBusiness;
import com.lymava.qier.activities.sharebusiness.ZhongqiuShareBusiness;
import com.lymava.qier.business.BusinessIntIdConfigQier;
import com.lymava.qier.cmbpay.model.CmbBankAccountPay;
import com.lymava.qier.sharebusiness.GaosanShareBusiness;
import com.lymava.qier.sharebusiness.QierGongzonghaoShareBusinessDefault;
import com.lymava.trade.base.model.BusinessIntIdConfig;
import com.lymava.wechat.gongzhonghao.sharebusiness.ShareBusinessContent;


/**
 * 启动72 应用
 * @author lymava
 *
 */
public class QierContextLoaderListener implements ServletContextListener{

	@Override
	public void contextInitialized(ServletContextEvent sce) {
		
		ShareBusinessContent instance = ShareBusinessContent.getInstance();
		
		QierGongzonghaoShareBusinessDefault qierGongzonghaoShareBusinessDefault = new QierGongzonghaoShareBusinessDefault();
		
		instance.setGongzonghaoShareBusiness_no_paremeter(qierGongzonghaoShareBusinessDefault);
		
		BusinessIntIdConfig.regiterBusinessIntIdConfigClass(BusinessIntIdConfigQier.class);
		
		//重返高三分享
		GaosanShareBusiness gaosanShareBusiness = new GaosanShareBusiness();
		instance.registerShareBusiness(gaosanShareBusiness);
		
		//注册世界杯活动
		WorldCupForecastShareBusiness worldCupForecastShareBusiness = new WorldCupForecastShareBusiness();
		instance.registerShareBusiness(worldCupForecastShareBusiness);
		
		//注册618分享活动
		LiuyibaShareBusiness liuyibaShareBusiness = new LiuyibaShareBusiness();
		instance.registerShareBusiness(liuyibaShareBusiness);
		
		//注册618分享活动
		NazhongrenShareBusiness nazhongrenShareBusiness = new NazhongrenShareBusiness();
		instance.registerShareBusiness(nazhongrenShareBusiness);
		
		//注册kol200分享活动
		KOL200ShareBusiness kol200ShareBusiness = new KOL200ShareBusiness();
		instance.registerShareBusiness(kol200ShareBusiness);
		
		//高考活动
		GaokaoShareBusiness gaokaoShareBusiness = new GaokaoShareBusiness();
		instance.registerShareBusiness(gaokaoShareBusiness);
		
		//关注立减
		SubscribeFirstRedEnvelopeShareBusiness subscribeFirstRedEnvelopeShareBusiness = new SubscribeFirstRedEnvelopeShareBusiness();
		instance.registerShareBusiness(subscribeFirstRedEnvelopeShareBusiness);
		
		//720打卡活动
		GuaguakaShareBusiness guaguakaShareBusiness = new GuaguakaShareBusiness();
		instance.registerShareBusiness(guaguakaShareBusiness);
		
		//招行直接支付
		CmbBankAccountPay.getInstance();
		
		//720打卡活动
		QingliangShareBusiness qingliangShareBusiness = new QingliangShareBusiness();
		instance.registerShareBusiness(qingliangShareBusiness);
		
		//七夕活动
		Qixi2018ShareBusiness qixi2018ShareBusiness = new Qixi2018ShareBusiness();
		instance.registerShareBusiness(qixi2018ShareBusiness);
		
		//2018中秋活动
		ZhongqiuShareBusiness zhongqiuShareBusiness = new ZhongqiuShareBusiness();
		instance.registerShareBusiness(zhongqiuShareBusiness);
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		
	}

}
