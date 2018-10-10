package com.lymava.qier.activities.guaguaka;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.reflect.Array;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Random;
import java.util.Set;

import com.google.gson.JsonObject;
import com.lymava.base.model.User;
import com.lymava.base.model.WebConfig;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.pay.PayFinalVariable;
import com.lymava.commons.util.*;
import com.lymava.commons.vo.EntityKeyValue;
import com.lymava.qier.activities.model.RedEnvelopesKol200;
import com.lymava.qier.model.Merchant72;
import com.lymava.qier.model.MerchantRedEnvelope;
import com.lymava.qier.model.Product72;
import com.lymava.qier.model.User72;
import com.lymava.trade.base.model.Business;
import com.lymava.trade.pay.model.PaymentRecord;
import com.lymava.wechat.gongzhonghao.SubscribeUser;
import com.lymava.wechat.gongzhonghao.vo.MessageSendNews;
import com.lymava.wechat.opendevelop.WeixinCallBackMessageFilter;
import org.bson.types.ObjectId;
import org.dom4j.Element;

import com.lymava.base.util.ContextUtil;
import com.lymava.base.util.WebConfigContent;
import com.lymava.commons.state.State;
import com.lymava.nosql.context.SerializContext;
import com.lymava.nosql.model.SerializModel;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.nosql.util.PageSplit;
import com.lymava.nosql.util.QuerySort;
import com.lymava.qier.activities.model.RedEnvelopes618;
import com.lymava.qier.activities.model.SubscribeFirstRedEnvelope;
import com.lymava.qier.business.BusinessIntIdConfigQier;
import com.lymava.wechat.gongzhonghao.Gongzonghao;
import com.lymava.wechat.gongzhonghao.sharebusiness.GongzonghaoShareBusiness;

public class GuaguakaShareBusiness extends GongzonghaoShareBusiness{
	
	public static void main(String[] args) throws IOException {
		
		BufferedImage createQrBufferedImage;
		try {
			createQrBufferedImage = QrCodeUtil.createQrBufferedImage("http://weixin.qq.com/q/02KVw9ABx-cVk1gkTb1rcM", 400);
			

			ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
			
			ImageUtil.write(createQrBufferedImage, byteArrayOutputStream);
			
			 FileOutputStream fileOutputStream = new FileOutputStream("/home/lymava/下载/世界杯/LiuyibaShareBusiness.jpg");
			 
			 fileOutputStream.write(byteArrayOutputStream.toByteArray());
			 fileOutputStream.flush();
			 fileOutputStream.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public String getBusinessName() {
		return "刮刮卡活动";
	}

	@Override
	public String getBusinessId() {
		return "guaguaka";
	}
  
	@Override
	public Integer executeCallBackMessage_text(Gongzonghao gongzonghao, Element rootElement, Map parameterMap) {
		
		String FromUserName = rootElement.elementTextTrim("FromUserName");
		String CreateTime = rootElement.elementTextTrim("CreateTime");
		String Content = rootElement.elementTextTrim("Content");
		if(Content != null) {
			Content = Content.trim();
		}
		String MsgId = rootElement.elementTextTrim("MsgId");
		
		String guaguaka_text_kouling = WebConfigContent.getConfig("guaguaka_text_kouling");
		
		if(MyUtil.isEmpty(guaguaka_text_kouling) || !guaguaka_text_kouling.equals(Content)) {
			return State.STATE_OK;
		}
		
		//检查是否在活动中
		boolean check_is_on_activity = check_is_on_activity();
		if(!check_is_on_activity) { 
			return State.STATE_OK;
		}
		
		String guaguaka_text_send_message = WebConfigContent.getConfig("guaguaka_text_send_message");
		
		MessageSendNews messageSendNews = null;
		String guaguaka_tuiwen_id = WebConfigContent.getConfig("guaguaka_tuiwen_id");
		if(MyUtil.isValid(guaguaka_tuiwen_id)){
			messageSendNews = (MessageSendNews)ContextUtil.getSerializContext().get(MessageSendNews.class, guaguaka_tuiwen_id);
		}
		
		if(messageSendNews != null) {
			try {
				
				String basePath = WeixinCallBackMessageFilter.threadLocal_basePath.get();
				
				String tuiwen_link = messageSendNews.getUrl();
				String tuiwen_pic = messageSendNews.getPicurl();
				
				if(!tuiwen_link.contains("http")) {
					tuiwen_link = basePath+tuiwen_link;
					messageSendNews.setUrl(tuiwen_link);
				}
				if(!tuiwen_pic.contains("http")) {
					tuiwen_pic = basePath+tuiwen_pic;
					messageSendNews.setPicurl(tuiwen_pic);
				}
				
				gongzonghao.send_news_message(FromUserName, messageSendNews);

			} catch (IOException e) {
				logger.error("刮刮卡 发送消息失败 FromUserName:"+FromUserName+" messageSendNews:"+messageSendNews.toJsonObject(), e);
			}
		}
		
		if(!MyUtil.isEmpty(guaguaka_text_send_message)) {
			gongzonghao.send_text_message(guaguaka_text_send_message, FromUserName);
		}
		
		return State.STATE_FALSE;
	}

	@Override
	public void subscribe_call_back(Gongzonghao gongzonghao, String data_id, String openid) {
		//检查是否在活动中
		boolean check_is_on_activity = check_is_on_activity();
		if(!check_is_on_activity) { return; }
		//检查今日数量是否达到
		boolean check_today_count_finish = this.check_today_count_finish(gongzonghao, openid);
		if(!check_today_count_finish) { 
			return; 
		}
		//检查活动总数量是否达到
		boolean check_all_count_finish = this.check_all_count_finish(gongzonghao, openid);
		if(!check_all_count_finish) { return; }
		

	}
	public boolean check_all_count_finish(Gongzonghao gongzonghao,String openid) {
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		String guanzhulijian_all_is_finish_message = WebConfigContent.getConfig("guanzhulijian_all_is_finish_message");
		String guanzhulijian_all_day_count_str = WebConfigContent.getConfig("guanzhulijian_all_day_count");
		Integer guanzhulijian_all_day_count = MathUtil.parseInteger(guanzhulijian_all_day_count_str);
		
		
		//检查每天的红包领取总数
		SubscribeFirstRedEnvelope subscribeFirstRedEnvelope_tongji = new SubscribeFirstRedEnvelope();
		subscribeFirstRedEnvelope_tongji.setState(State.STATE_OK);
		
		PageSplit pageSplit = new PageSplit();
		pageSplit.setPageSize(1);
		
		serializContext.findIterable(subscribeFirstRedEnvelope_tongji, pageSplit);
		 
		if(pageSplit.getCount() >= guanzhulijian_all_day_count) {
			gongzonghao.send_text_message(guanzhulijian_all_is_finish_message, openid);
			return false;
		}
		
		return true;
	}
	public boolean check_today_count_finish(Gongzonghao gongzonghao,String openid) {
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		String today_is_finish_guanzhulijian_message = WebConfigContent.getConfig(this.getBusinessId()+"_today_is_finish_message");
		String guanzhulijian_every_day_count_str = WebConfigContent.getConfig(this.getBusinessId()+"_every_day_count");
		Integer guanzhulijian_every_day_count = MathUtil.parseInteger(guanzhulijian_every_day_count_str);
		
		
		//检查每天的红包领取总数
		SubscribeFirstRedEnvelope subscribeFirstRedEnvelope_tongji = new SubscribeFirstRedEnvelope();
		subscribeFirstRedEnvelope_tongji.setState(State.STATE_OK);
		
		Long currentDayStartTime = DateUtil.getCurrentDayStartTime();
		Long currentDayEndTime = currentDayStartTime+DateUtil.one_day;
		
		if(currentDayStartTime !=null ){
			ObjectId startTimeObj = new ObjectId(new Date(currentDayStartTime));
			subscribeFirstRedEnvelope_tongji.addCommand(MongoCommand.dayuAndDengyu, "id", startTimeObj);
		}
		if(currentDayEndTime !=null ){
			ObjectId endTimeObj = new ObjectId(new Date(currentDayEndTime));
			subscribeFirstRedEnvelope_tongji.addCommand(MongoCommand.xiaoyu, "id", endTimeObj);
		}
		
		PageSplit pageSplit = new PageSplit();
		pageSplit.setPageSize(1);
		
		serializContext.findIterable(subscribeFirstRedEnvelope_tongji, pageSplit);
		 
		if(pageSplit.getCount() >= guanzhulijian_every_day_count) {
			gongzonghao.send_text_message(today_is_finish_guanzhulijian_message, openid);
			return false;
		}
		
		return true;
	}
	/**
	 * 定向红包的商家
	 */
	private List<Merchant72> merchant72_list;
	
	public List<Merchant72> getMerchant72_list() {
		return merchant72_list;
	}
	public void setMerchant72_list(List<Merchant72> merchant72_list) {
		this.merchant72_list = merchant72_list;
	}
	/**
	 * 抽奖
	 * @return
	 */
	public GuaguakaJiangPin choujiang(SubscribeUser subscribeUser) {
		
		String tag = "other_day";
		
		String guaguaka_dangtianTime = WebConfigContent.getConfig("guaguaka_dangtianTime");
		try {
			Date parse = DateUtil.getSdfShort().parse(guaguaka_dangtianTime);
			
			if(DateUtil.getCurrentDayStartTime().equals(parse.getTime())) {
				tag = "current_day";
			}
		} catch (ParseException e) {
		}
		
		String tongyong1_from = WebConfigContent.getConfig("guaguaka_"+tag+"_tongyong1_from");
		String tongyong1_to = WebConfigContent.getConfig("guaguaka_"+tag+"_tongyong1_to");
		String tongyong1_jilv = WebConfigContent.getConfig("guaguaka_"+tag+"_tongyong1_jilv");
		String dingxiang_jilv = WebConfigContent.getConfig("guaguaka_"+tag+"_dingxiang_jilv");
		String iphonex_jilv = WebConfigContent.getConfig("guaguaka_"+tag+"_iphonex_jilv");
		String hongbao_8888_jilv = WebConfigContent.getConfig("guaguaka_"+tag+"_8888_jilv");
		String tongyong2_from = WebConfigContent.getConfig("guaguaka_"+tag+"_tongyong2_from");
		String tongyong2_to = WebConfigContent.getConfig("guaguaka_"+tag+"_tongyong2_to");
		String tongyong2_jilv = WebConfigContent.getConfig("guaguaka_"+tag+"_tongyong2_jilv");
		
		String guaguaka_other_weizhongjiang_jilv = WebConfigContent.getConfig("guaguaka_"+tag+"_weizhongjiang_jilv");
		String guaguaka_other_evry_day_dingxiang_count = WebConfigContent.getConfig("guaguaka_"+tag+"_evry_day_dingxiang_count");
		String guaguaka_other_zhongjiang_tianshu = WebConfigContent.getConfig("guaguaka_"+tag+"_zhongjiang_tianshu");
		
		Integer tongyong1_from_int = MathUtil.parseInteger(tongyong1_from);
		Integer tongyong1_to_int = MathUtil.parseInteger(tongyong1_to);
		Integer tongyong1_jilv_int = MathUtil.parseInteger(tongyong1_jilv);
		
		Integer dingxiang_jilv_int = MathUtil.parseInteger(dingxiang_jilv);
		Integer iphonex_jilv_int = MathUtil.parseInteger(iphonex_jilv);
		
		Integer hongbao_8888_jilv_int = MathUtil.parseInteger(hongbao_8888_jilv);
		
		Integer tongyong2_from_int = MathUtil.parseInteger(tongyong2_from);
		Integer tongyong2_to_int = MathUtil.parseInteger(tongyong2_to);
		Integer tongyong2_jilv_int = MathUtil.parseInteger(tongyong2_jilv);
		
		Integer guaguaka_other_weizhongjiang_jilv_int = MathUtil.parseInteger(guaguaka_other_weizhongjiang_jilv);
		Integer guaguaka_other_evry_day_dingxiang_count_int = MathUtil.parseInteger(guaguaka_other_evry_day_dingxiang_count);
		Integer guaguaka_other_zhongjiang_tianshu_int = MathUtil.parseInteger(guaguaka_other_zhongjiang_tianshu);
		
		int start_jilv = 0;
		int end_jilv = 0;
		 
		LinkedHashMap<Integer, int[]> jilv = new LinkedHashMap<>();
		
		jilv.put(GuaguakaJiangPin.type_jiangpin_tongyong, new int[]{start_jilv,end_jilv += tongyong1_jilv_int});
		jilv.put(GuaguakaJiangPin.type_jiangpin_dingxiang, new int[]{end_jilv,end_jilv += dingxiang_jilv_int});
		jilv.put(GuaguakaJiangPin.type_jiangpin_tongyong_2, new int[]{end_jilv,end_jilv += tongyong2_jilv_int});
		jilv.put(GuaguakaJiangPin.type_jiangpin_iPhone_x, new int[]{end_jilv,end_jilv += iphonex_jilv_int});
		jilv.put(GuaguakaJiangPin.type_jiangpin_tongyong_3, new int[]{end_jilv,end_jilv += hongbao_8888_jilv_int});
		jilv.put(GuaguakaJiangPin.type_jiangpin_weizhongjiang, new int[]{end_jilv,end_jilv += guaguaka_other_weizhongjiang_jilv_int});
		
		Random random = new Random();
		
		Integer type_jiangpin_final = null;
		
		int nextInt = random.nextInt(end_jilv);
		
		Set<Entry<Integer, int[]>> entrySet = jilv.entrySet();
		for (Entry<Integer, int[]> entry : entrySet) {
			
			Integer type_jiangpin_tmp = entry.getKey();
			
			int[] value = entry.getValue();
			
			int start_jilv_tmp = value[0];
			int end_jilv_tmp = value[1];
			
			if(nextInt >= start_jilv_tmp && nextInt < end_jilv_tmp) {
				type_jiangpin_final = type_jiangpin_tmp;
				break;
			}
		}
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		User user72 = new User();
		user72.setThird_user_id(subscribeUser.getOpenid());
		
		user72 = (User) serializContext.get(user72);

		if(user72 == null) {
			user72 = User.createDefaultUser();

			user72.setUsername(subscribeUser.getOpenid());
			user72.setUserpwd(Md5Util.MD5Normal(subscribeUser.getOpenid()));
			user72.setRealname("微信用户");
			user72.setThird_user_id(subscribeUser.getOpenid());
			user72.setNickname(subscribeUser.getNickname());
			
			Integer init_userpwd_level = User.init_userpwd_level(subscribeUser.getOpenid());
			user72.setUserpwd_level(init_userpwd_level);
			
			serializContext.save(user72);
		}
		
		/***
		 * 检测 用户 几天可中奖一次
		 * 0为不限制
		 */
		if(guaguaka_other_zhongjiang_tianshu_int > 0) {
			
			Date date_start_time = new Date(System.currentTimeMillis()-guaguaka_other_zhongjiang_tianshu_int*DateUtil.one_day);
			
			GuaguakaJiangPin guaguakaJiangPin_find = new GuaguakaJiangPin();
			guaguakaJiangPin_find.setUser_huiyuan(user72);
			guaguakaJiangPin_find.setState(State.STATE_OK);
			
			ObjectId startTimeObj = new ObjectId(date_start_time);
			guaguakaJiangPin_find.addCommand(MongoCommand.dayuAndDengyu, "id", startTimeObj);
			
			PageSplit pageSplit = new PageSplit();
			pageSplit.setPageSize(1);
			serializContext.findIterable(guaguakaJiangPin_find,pageSplit);
			
			//如果超过中奖次数设置为未中奖
			if(pageSplit.getCount() > 0) {
				type_jiangpin_final = GuaguakaJiangPin.type_jiangpin_weizhongjiang;
			}
		}
		
		
		GuaguakaJiangPin guaguakaJiangPin = new GuaguakaJiangPin();
		
		guaguakaJiangPin.setId(new ObjectId().toString());
		guaguakaJiangPin.setUser_huiyuan(user72);
		guaguakaJiangPin.setLingqu_day(DateUtil.getCurrentDayStartTime());
		guaguakaJiangPin.setRand_number(nextInt);
		guaguakaJiangPin.setType_jiangpin(type_jiangpin_final);
		guaguakaJiangPin.setOpenid(subscribeUser.getOpenid());
		
		
		if(GuaguakaJiangPin.type_jiangpin_weizhongjiang.equals(type_jiangpin_final)) {
			guaguakaJiangPin.setState(State.STATE_FALSE);
		}if(GuaguakaJiangPin.type_jiangpin_tongyong.equals(type_jiangpin_final)) {
			//通用红包1
			this.send_tongyong_hongbao(guaguakaJiangPin,tongyong1_from_int, tongyong1_to_int);
		}else if(GuaguakaJiangPin.type_jiangpin_dingxiang.equals(type_jiangpin_final)) {
			
			/**
			 * 检查定向红包发送的数量
			 */
			if(guaguaka_other_evry_day_dingxiang_count_int > 0) {
				
				Date date_start_time = new Date(DateUtil.getCurrentDayStartTime());
				
				GuaguakaJiangPin guaguakaJiangPin_find = new GuaguakaJiangPin();
				guaguakaJiangPin_find.setType_jiangpin(GuaguakaJiangPin.type_jiangpin_dingxiang);
				guaguakaJiangPin_find.setState(State.STATE_OK);
				
				ObjectId startTimeObj = new ObjectId(date_start_time);
				guaguakaJiangPin_find.addCommand(MongoCommand.dayuAndDengyu, "id", startTimeObj);
				
				PageSplit pageSplit = new PageSplit();
				pageSplit.setPageSize(1);
				
				serializContext.findIterable(guaguakaJiangPin_find,pageSplit);
				//如果超过中奖次数设置为未中奖
				if(pageSplit.getCount() >= guaguaka_other_evry_day_dingxiang_count_int) {
					type_jiangpin_final = GuaguakaJiangPin.type_jiangpin_weizhongjiang;
				}else {
					//定向红包
					this.send_dingxiang_hongbao(guaguakaJiangPin);
				}
			}
		}else  if(GuaguakaJiangPin.type_jiangpin_tongyong_2.equals(type_jiangpin_final)) {
			//通用红包2
			this.send_tongyong_hongbao(guaguakaJiangPin,tongyong2_from_int, tongyong2_to_int);
		} 
		
		serializContext.save(guaguakaJiangPin);
		
		return guaguakaJiangPin;
	}
	
	public GuaguakaJiangPin send_tongyong_hongbao(GuaguakaJiangPin guaguakaJiangPin,Integer tongyong_from_int,Integer tongyong_to_int) {
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		User user_huiyuan = guaguakaJiangPin.getUser_huiyuan();
		
		Random random = new Random();
		
		int hongba_yuan = random.nextInt(tongyong_to_int-tongyong_from_int)+tongyong_from_int;
		
		guaguakaJiangPin.setPrice_fen(hongba_yuan*100);
		
		PaymentRecord paymentRecord = new PaymentRecord();
		
		paymentRecord.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_720);
		  
		Long red_pack_final_pianyi = hongba_yuan*User.pianyiYuan;

		Long yue_balance = user_huiyuan.getBalance();
		if(yue_balance == null){
			yue_balance = 0l;
		}
		
		String requestFlow = guaguakaJiangPin.getId();
		guaguakaJiangPin.setState(State.STATE_OK);
		
		String balance_log_id = new ObjectId().toString();
		
		paymentRecord.setId(balance_log_id);
		paymentRecord.setUser_huiyuan(user_huiyuan);
		paymentRecord.setPrice_pianyi_all(red_pack_final_pianyi);
		paymentRecord.setWallet_amount_balance_pianyi(red_pack_final_pianyi+yue_balance);;
		paymentRecord.setState(com.lymava.commons.state.State.STATE_OK);
		paymentRecord.setPay_method(PayFinalVariable.pay_method_balance);
		paymentRecord.setRequestFlow(requestFlow);
		
		serializContext.save(paymentRecord);
		
		user_huiyuan.balanceChange(red_pack_final_pianyi);
		
		guaguakaJiangPin.setState(State.STATE_OK);
		
		return guaguakaJiangPin;
	}
	/**
	 * 发送定向红包
	 * @param guaguakaJiangPin
	 * @return
	 */
	public GuaguakaJiangPin send_dingxiang_hongbao(GuaguakaJiangPin guaguakaJiangPin) {
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		User user_huiyuan = guaguakaJiangPin.getUser_huiyuan();
		
		
		// 发送一个定向红包
		MerchantRedEnvelope merchantRedEnvelope_find = new MerchantRedEnvelope();
		merchantRedEnvelope_find.setState(State.STATE_WAITE_CHANGE); 
		merchantRedEnvelope_find.initQuerySort("index_id", QuerySort.desc);
		
		if(merchant72_list != null) {
			for (Merchant72 merchant72_tmp : merchant72_list) {
				merchantRedEnvelope_find.addCommand(MongoCommand.or, "userId_merchant", merchant72_tmp.getId());
			}
		}
		
		MerchantRedEnvelope merchantRedEnvelope_had_find = new MerchantRedEnvelope();
		
		merchantRedEnvelope_had_find.setUserId_huiyuan(user_huiyuan.getId());
		merchantRedEnvelope_had_find.setState(State.STATE_OK);
		
		List<MerchantRedEnvelope> merchantRedEnvelope_had_list = serializContext.findAll(merchantRedEnvelope_had_find);
		
		LinkedHashMap<String,String> merchantRedEnvelope_had_map = new LinkedHashMap<String,String>();
		
		for(MerchantRedEnvelope merchantRedEnvelope_had_tmp:merchantRedEnvelope_had_list){
			merchantRedEnvelope_had_map.put(merchantRedEnvelope_had_tmp.getUserId_merchant(), merchantRedEnvelope_had_tmp.getUserId_merchant());
		}
		 
		Set<String> userId_merchant_keyset = merchantRedEnvelope_had_map.keySet();
		for(String userId_merchant_had:userId_merchant_keyset){
			merchantRedEnvelope_find.addCommand(MongoCommand.not_in, "userId_merchant", userId_merchant_had);
		}
		
		merchantRedEnvelope_find = (MerchantRedEnvelope) serializContext.findOneInlist(merchantRedEnvelope_find);
		
		if(merchantRedEnvelope_find == null) {
			guaguakaJiangPin.setState(State.STATE_FALSE);
		}else {
			guaguakaJiangPin.setState(State.STATE_OK);
			
			MerchantRedEnvelope merchantRedEnvelope_update = new MerchantRedEnvelope();
			
			merchantRedEnvelope_update.setState(State.STATE_OK); 
			merchantRedEnvelope_update.setUser_huiyuan(user_huiyuan);
			
			serializContext.updateObject(merchantRedEnvelope_find.getId(), merchantRedEnvelope_update);
			
			guaguakaJiangPin.setMerchantRedEnvelope(merchantRedEnvelope_find);
			guaguakaJiangPin.setMerchant72(merchantRedEnvelope_find.getUser_merchant());
			guaguakaJiangPin.setPrice_fen(merchantRedEnvelope_find.getAmountFen().intValue());
		}
		
		return guaguakaJiangPin;
	}

	public boolean check_is_start() {
		
		String startTime_618_do_str = WebConfigContent.getConfig(this.getBusinessId()+"_startTime");
		
		// 活动领取 红包 开始时间
		Date startTime_date_do = null;
		
		try {
			//红包有效期
			startTime_date_do = DateUtil.getSdfFull().parse(startTime_618_do_str);
		} catch (ParseException e1) {
		}
		
		//检查活动是否开始
		if(startTime_date_do == null || System.currentTimeMillis() < startTime_date_do.getTime()) {
			return false;
		} 
		
		return true;
	}
	
	public boolean check_is_end() {
		
		String endTime_618_do_str = WebConfigContent.getConfig(this.getBusinessId()+"_endTime");
		
		// 活动领取 红包 结束时间
		Date endTime_date_do = null;
		
		try {
			//红包有效期
			endTime_date_do = DateUtil.getSdfFull().parse(endTime_618_do_str);
		} catch (ParseException e1) {
		}
		 
		//检查活动是否已经结束
		if(endTime_date_do == null || System.currentTimeMillis() > endTime_date_do.getTime() ) {
			return false;
		}
		
		return true;
	}



	public boolean check_is_on_activity() {
		
		String startTime_618_do_str = WebConfigContent.getConfig(this.getBusinessId()+"_startTime");
		String endTime_618_do_str = WebConfigContent.getConfig(this.getBusinessId()+"_endTime");
		
		// 活动领取 红包 开始时间
		Date startTime_date_do = null;
		// 活动领取 红包 结束时间
		Date endTime_date_do = null;
		
		try {
			//红包有效期
			startTime_date_do = DateUtil.getSdfFull().parse(startTime_618_do_str);
			//红包有效期
			endTime_date_do = DateUtil.getSdfFull().parse(endTime_618_do_str);
		} catch (ParseException e1) {
		}
		
		//检查活动是否开始
		if(startTime_date_do == null || System.currentTimeMillis() < startTime_date_do.getTime()) {
			return false;
		}
		//检查活动是否已经结束
		if(endTime_date_do == null || System.currentTimeMillis() > endTime_date_do.getTime() ) {
			return false;
		}
		
		return true;
	}



}
