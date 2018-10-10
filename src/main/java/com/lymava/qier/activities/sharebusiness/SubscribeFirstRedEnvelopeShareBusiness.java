package com.lymava.qier.activities.sharebusiness;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.ParseException;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import com.google.gson.JsonObject;
import com.lymava.base.model.User;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.util.*;
import com.lymava.qier.activities.model.RedEnvelopesKol200;
import com.lymava.qier.model.Merchant72;
import com.lymava.qier.model.MerchantRedEnvelope;
import com.lymava.qier.model.Product72;
import com.lymava.qier.model.User72;
import com.lymava.wechat.gongzhonghao.SubscribeUser;
import com.lymava.wechat.gongzhonghao.vo.MessageSendNews;
import com.lymava.wechat.opendevelop.WeixinCallBackMessageFilter;
import org.bson.types.ObjectId;

import com.lymava.base.util.ContextUtil;
import com.lymava.base.util.WebConfigContent;
import com.lymava.commons.state.State;
import com.lymava.nosql.context.SerializContext;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.nosql.util.PageSplit;
import com.lymava.qier.activities.model.RedEnvelopes618;
import com.lymava.qier.activities.model.SubscribeFirstRedEnvelope;
import com.lymava.wechat.gongzhonghao.Gongzonghao;
import com.lymava.wechat.gongzhonghao.sharebusiness.GongzonghaoShareBusiness;

public class SubscribeFirstRedEnvelopeShareBusiness extends GongzonghaoShareBusiness{
	
	public static void main(String[] args) throws IOException {
		
		BufferedImage createQrBufferedImage;
		try {
			createQrBufferedImage = QrCodeUtil.createQrBufferedImage("http://weixin.qq.com/q/02jSkdBYx-cVk1VBqeNrcK", 400);
			

			ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
			
			ImageUtil.write(createQrBufferedImage, byteArrayOutputStream);
			
			 FileOutputStream fileOutputStream = new FileOutputStream("/home/lymava/workhome/program/罗彪项目/营销活动/2018中秋节/zhongqiuhuodong.jpg");
			 
			 fileOutputStream.write(byteArrayOutputStream.toByteArray());
			 fileOutputStream.flush();
			 fileOutputStream.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public String getBusinessName() {
		return "关注立减活动";
	}

	@Override
	public String getBusinessId() {
		return "guanzhulijian";
	}
  
	@Override
	public void subscribe_call_back(Gongzonghao gongzonghao, String data_id, String openid) {
		
		SerializContext serializContext = ContextUtil.getSerializContext();
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
		
		SubscribeFirstRedEnvelope subscribeFirstRedEnvelope_find = new SubscribeFirstRedEnvelope();
		subscribeFirstRedEnvelope_find.setOpenid(openid);
		
		subscribeFirstRedEnvelope_find = (SubscribeFirstRedEnvelope) serializContext.get(subscribeFirstRedEnvelope_find);
		
		if(subscribeFirstRedEnvelope_find != null) {
			gongzonghao.send_text_message("每人只能参与一次活动", openid);
			return;
		}


		String amount_yuan_str = WebConfigContent.getConfig("guanzhulijian_amount_yuan");

		String startTime_guanzhulijian_str = WebConfigContent.getConfig("startTime_guanzhulijian");
		String endTime_guanzhulijian_str = WebConfigContent.getConfig("endTime_guanzhulijian");

		//红包使用开始时间
		Date startTime_date = null;
		//红包使用 过期时间
		Date endTime_date = null;

		try {
			//红包有效期
			startTime_date = DateUtil.getSdfFull().parse(startTime_guanzhulijian_str);
			//红包有效期
			endTime_date = DateUtil.getSdfFull().parse(endTime_guanzhulijian_str);
		} catch (ParseException e1) {
		}

		Double amount_yuan = MathUtil.parseDouble(amount_yuan_str);

		Integer amount_fen = MathUtil.multiplyInteger(amount_yuan, 100).intValue();


		subscribeFirstRedEnvelope_find = new SubscribeFirstRedEnvelope();

		subscribeFirstRedEnvelope_find.setId(new ObjectId().toString());
		subscribeFirstRedEnvelope_find.setOpenid(openid);
		subscribeFirstRedEnvelope_find.setAmount_fen(amount_fen);
		if(startTime_date != null) {
			subscribeFirstRedEnvelope_find.setStartTime(startTime_date.getTime());
		}
		if(endTime_date != null) {
			subscribeFirstRedEnvelope_find.setEndTime(endTime_date.getTime());
		}
		subscribeFirstRedEnvelope_find.setState(State.STATE_OK);

		serializContext.save(subscribeFirstRedEnvelope_find);



		User user72 = subscribeFirstRedEnvelope_find.getUser72();

		if(user72 == null) {
			SubscribeUser subscribeUser_find = new SubscribeUser();
			subscribeUser_find.setOpenid(openid);
			SubscribeUser subscribeUser = (SubscribeUser)serializContext.get(subscribeUser_find);
			
			user72 = User.createDefaultUser();

			user72.setUsername(openid);
			user72.setUserpwd(Md5Util.MD5Normal(openid));
			user72.setRealname("微信用户");
			user72.setThird_user_id(openid);
			user72.setNickname(subscribeUser.getNickname());
			
			Integer init_userpwd_level = User.init_userpwd_level(openid);
			user72.setUserpwd_level(init_userpwd_level);
			
			serializContext.save(user72);
		}


		if( MyUtil.isEmpty(data_id) && MathUtil.parseLongNull(data_id) == null) {
			logger.error("data_id 为空");
			return;
		}
		
		Product72 product72 = null;
		if(MyUtil.isValid(data_id)){
			product72 = (Product72)ContextUtil.getSerializContext().get(Product72.class, data_id);
		}
		

		if(product72 == null) {
			logger.error(data_id+"产品编号不存在!");
			return;
		}
		
		Merchant72 merchant72 = (Merchant72) product72.getUser_merchant();
		
		if(merchant72 == null) {
			logger.error(data_id+"(编号): 得到了一个空商户");
			return;
		}

		Date endTime_guanzhulijian = null;
		try {
			endTime_guanzhulijian = DateUtil.getSdfFull().parse(endTime_guanzhulijian_str);
		} catch (ParseException e) {
			logger.error("定向红包截止日期未配置!", e);
			return;
		}

		// 发送一个定向红包
		MerchantRedEnvelope merchantRedEnvelope_save = new MerchantRedEnvelope();

		merchantRedEnvelope_save.setId(new ObjectId().toString());
		merchantRedEnvelope_save.setRed_envolope_name("关注立减");
		merchantRedEnvelope_save.setUserId_merchant(merchant72.getId());
		merchantRedEnvelope_save.setAmount(amount_fen*User.pianyiFen);
		merchantRedEnvelope_save.setBalance(amount_fen*User.pianyiFen);
		merchantRedEnvelope_save.setState(State.STATE_OK); 
		merchantRedEnvelope_save.setMerchant_type(merchant72.getMerchant72_type());
		merchantRedEnvelope_save.setExpiry_time(endTime_guanzhulijian.getTime());
		merchantRedEnvelope_save.setIndex_id(System.currentTimeMillis());
		merchantRedEnvelope_save.setUser_huiyuan(user72);

		serializContext.save(merchantRedEnvelope_save);


		// 发送推文
		String basePath = WeixinCallBackMessageFilter.threadLocal_basePath.get();

		String tuiwen_title = WebConfigContent.getConfig("guanzhulijian_tuiwen_title");
		String tuiwen_content = WebConfigContent.getConfig("guanzhulijian_tuiwen_content");
		String tuiwen_link =basePath+"?b="+product72.getBianhao();
		String tuiwen_pic = WebConfigContent.getConfig("guanzhulijian_tuiwen_pic");
		if(!tuiwen_link.contains("http")) {
			tuiwen_link = basePath+tuiwen_link;
		}
		if(!tuiwen_pic.contains("http")) {
			tuiwen_pic = basePath+tuiwen_pic;
		}

		List<MessageSendNews> messageSendNews_list = new LinkedList<MessageSendNews>();

		MessageSendNews messageSendNews_tmp = new MessageSendNews();

		messageSendNews_tmp.setTitle(tuiwen_title);
		messageSendNews_tmp.setDescription(tuiwen_content);
		messageSendNews_tmp.setUrl(tuiwen_link);
		messageSendNews_tmp.setPicurl(tuiwen_pic);

		messageSendNews_list.add(messageSendNews_tmp);

		String send_news_message;
		try {
			send_news_message = gongzonghao.send_news_message(openid, messageSendNews_list);

			JsonObject parseJsonObject = JsonUtil.parseJsonObject(send_news_message);
			String errcode = JsonUtil.getString(parseJsonObject, "errcode");
			if(!"0".equals(errcode) ){
				logger.error("send_news_message:"+send_news_message);
			}
		} catch (IOException e) {
			logger.error("关注回调业务处理失败!", e);
		}



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
		
		String today_is_finish_guanzhulijian_message = WebConfigContent.getConfig("today_is_finish_guanzhulijian_message");
		String guanzhulijian_every_day_count_str = WebConfigContent.getConfig("guanzhulijian_every_day_count");
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
	 
	public void send_activity_news(Gongzonghao gongzonghao, String data_id, String openid) {
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		String amount_yuan_str = WebConfigContent.getConfig("618_amount_yuan"); 
		
		String startTime_618_str = WebConfigContent.getConfig("startTime_guanzhulijian_do");
		String endTime_618_str = WebConfigContent.getConfig("endTime_guanzhulijian");
		 
	}





	public boolean check_is_on_activity() {
		
		String startTime_618_do_str = WebConfigContent.getConfig("startTime_guanzhulijian");
		String endTime_618_do_str = WebConfigContent.getConfig("endTime_guanzhulijian");
		
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


//	public void send_redEnvelopesSubscribeFirstRedEnvelope(Gongzonghao gongzonghao, String data_id, String openid) {
//
//		User72 user72 = subscribeFirstRedEnvelope.getUser72();
//
//		if(user72 == null) {
//			WebConfigContent instance = WebConfigContent.getInstance();
//			String defaultUserGroupId = instance.getDefaultUserGroupId();
//
//			SubscribeUser subscribeUser_find = new SubscribeUser();
//			subscribeUser_find.setOpenid(openid);
//
//			SubscribeUser subscribeUser = (SubscribeUser)serializContext.get(subscribeUser_find);
//
//			user72 = new User72();
//
//			user72.setId(new ObjectId().toString());
//			user72.setUsername(openid);
//
//			user72.setUserpwd(Md5Util.MD5Normal(openid));
//			user72.setState(User.STATE_OK);
//			user72.setPayPwdState(User.payPwdState_STATE_NOTOK);
//			user72.setIntegral(0l);
//			user72.setBalance(0l);
//			user72.setKey(Md5Util.MD5Normal(openid));
//			user72.setShare_balance(User.share_balance_no);
//			user72.setUserGroupId(defaultUserGroupId);
//			user72.setRealname("微信用户");
//			user72.setThird_user_id(openid);
//			user72.setNickname(subscribeUser.getNickname());
//
//			Integer init_userpwd_level = User.init_userpwd_level(openid);
//			user72.setUserpwd_level(init_userpwd_level);
//
//			Long newUser_huiyuan_last_id = instance.getNewUser_huiyuan_last_id();
//			user72.setBianhao(newUser_huiyuan_last_id);
//
//			serializContext.save(user72);
//		}
//
//
//		MerchantRedEnvelope merchantRedEnvelope_save = new MerchantRedEnvelope();
//
//		merchantRedEnvelope_save.setId(new ObjectId().toString());
//		merchantRedEnvelope_save.setRed_envolope_name("关注立减");
//		merchantRedEnvelope_save.setUserId_merchant(activities_kol200_userId_merchant);
//		merchantRedEnvelope_save.setAmount(activities_kol200_amount_fen*User.pianyiFen);
//		merchantRedEnvelope_save.setBalance(activities_kol200_amount_fen*User.pianyiFen);
//		merchantRedEnvelope_save.setState(State.STATE_OK);
//		merchantRedEnvelope_save.setMerchant_type(merchant72.getMerchant72_type());
//		merchantRedEnvelope_save.setExpiry_time(redEnvelope_end_time.getTime());
//		merchantRedEnvelope_save.setIndex_id(System.currentTimeMillis());
//		merchantRedEnvelope_save.setUser_huiyuan(user72);
//
//		serializContext.save(merchantRedEnvelope_save);
//
//		//发送成功消息
////		gongzonghao.send_text_message(kol200_get_red_success_message, openid);
//	}


}
