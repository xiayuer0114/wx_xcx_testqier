package com.lymava.qier.activities.sharebusiness;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URL;
import java.text.ParseException;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;

import org.bson.types.ObjectId;
import org.dom4j.Element;

import com.google.gson.JsonObject;
import com.lymava.alipay.util.AlipayCore;
import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.base.util.WebConfigContent;
import com.lymava.commons.pay.PayFinalVariable;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.ImageUtil;
import com.lymava.commons.util.JsonUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.Md5Util;
import com.lymava.commons.util.MyUtil;
import com.lymava.commons.util.QrCodeUtil;
import com.lymava.nosql.context.SerializContext;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.nosql.util.PageSplit;
import com.lymava.qier.activities.model.RedEnvelopes618;
import com.lymava.qier.business.BusinessIntIdConfigQier;
import com.lymava.qier.model.User72;
import com.lymava.trade.base.model.Business;
import com.lymava.trade.pay.model.PaymentRecord;
import com.lymava.wechat.gongzhonghao.Gongzonghao;
import com.lymava.wechat.gongzhonghao.GongzonghaoContent;
import com.lymava.wechat.gongzhonghao.SubscribeUser;
import com.lymava.wechat.gongzhonghao.sharebusiness.GongzonghaoShareBusiness;
import com.lymava.wechat.gongzhonghao.vo.MessageSendNews;
import com.lymava.wechat.opendevelop.WeixinCallBackMessageFilter;

public class LiuyibaShareBusiness extends GongzonghaoShareBusiness{
	
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
		return "618活动";
	}

	@Override
	public String getBusinessId() {
		return "618";
	}

	@Override
	public Integer executeCallBackMessage_image(Gongzonghao gongzonghao,Element rootElement, Map parameterMap) {
		
		String FromUserName = rootElement.elementTextTrim("FromUserName");
		String CreateTime = rootElement.elementTextTrim("CreateTime");
		String PicUrl = rootElement.elementTextTrim("PicUrl");
		String MediaId = rootElement.elementTextTrim("MediaId");
		String MsgId = rootElement.elementTextTrim("MsgId");
		
		
		
		return State.STATE_FALSE;
	}
	/**
	 * 发送红包
	 * @param gongzonghao
	 * @param openid
	 */
	public void send_redEnvelopes618(Gongzonghao gongzonghao,String openid) {
		
		RedEnvelopes618 redEnvelopes618_find = new RedEnvelopes618();
		redEnvelopes618_find.setOpenid(openid);
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		redEnvelopes618_find = (RedEnvelopes618) serializContext.get(redEnvelopes618_find);
		
		
		if(redEnvelopes618_find == null) {
			gongzonghao.send_text_message("未找到红包记录！", openid);
			logger.error(openid+" 未找到红包记录！");
			return;
		}
		
		WebConfigContent instance = WebConfigContent.getInstance();
		String defaultUserGroupId = instance.getDefaultUserGroupId();
		
		User72 user72 = redEnvelopes618_find.getUser72();
		
		if(user72 == null) {
			
			SubscribeUser subscribeUser_find = new SubscribeUser();
			subscribeUser_find.setOpenid(openid);

			SubscribeUser subscribeUser = (SubscribeUser)serializContext.get(subscribeUser_find);
			
			user72 = new User72();

			user72.setId(new ObjectId().toString());
			user72.setUsername(openid);
			
			user72.setUserpwd(Md5Util.MD5Normal(openid));
			user72.setState(User.STATE_OK);
			user72.setPayPwdState(User.payPwdState_STATE_NOTOK);
			user72.setIntegral(0l);
			user72.setBalance(0l);
			user72.setKey(Md5Util.MD5Normal(openid));
			user72.setShare_balance(User.share_balance_no);
			user72.setUserGroupId(defaultUserGroupId);
			user72.setRealname("微信用户");
			user72.setThird_user_id(openid);
			user72.setNickname(subscribeUser.getNickname());

			Integer init_userpwd_level = User.init_userpwd_level(openid);
			user72.setUserpwd_level(init_userpwd_level);
			
			Long newUser_huiyuan_last_id = instance.getNewUser_huiyuan_last_id();
			user72.setBianhao(newUser_huiyuan_last_id);

			serializContext.save(user72);
		}
		
		boolean check_is_on_activity = this.check_is_on_activity(gongzonghao, openid);
		if(!check_is_on_activity) {
			return;
		}
		
		boolean check_today_count_finish = this.check_today_count_finish(gongzonghao, openid);
		if(!check_today_count_finish) {
			return;
		}
		 
		try { 
			RedEnvelopes618 redEnvelopes618_update = new RedEnvelopes618();
			redEnvelopes618_update.setState(State.STATE_OK);
			
			serializContext.updateObject(redEnvelopes618_find.getId(), redEnvelopes618_update);
			
			
			PaymentRecord paymentRecord = new PaymentRecord();
			
			paymentRecord.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_618);
			  
			
			Long red_pack_final_pianyi = redEnvelopes618_find.getAmount_fen()*User.pianyiFen;

			Long yue_balance = user72.getBalance();
			if(yue_balance == null){
				yue_balance = 0l;
			}
			
			String requestFlow = redEnvelopes618_find.getId()+"_x1";
			
			String balance_log_id = new ObjectId().toString();
			
			paymentRecord.setId(balance_log_id);
			paymentRecord.setUser_huiyuan(user72);
			paymentRecord.setPrice_pianyi_all(red_pack_final_pianyi);
			paymentRecord.setWallet_amount_balance_pianyi(red_pack_final_pianyi+yue_balance);;
			paymentRecord.setState(com.lymava.commons.state.State.STATE_OK);
			paymentRecord.setPay_method(PayFinalVariable.pay_method_balance);
			paymentRecord.setRequestFlow(requestFlow);
			
			serializContext.save(paymentRecord);
			
			
				Business.checkRequestFlow(paymentRecord);
				
				user72.balanceChange(red_pack_final_pianyi);
				
				redEnvelopes618_update = new RedEnvelopes618();
				redEnvelopes618_update.setState(State.STATE_WAITE_PAY); 
				serializContext.updateObject(redEnvelopes618_find.getId(), redEnvelopes618_update);
				
				String get_red_success_message = WebConfigContent.getConfig("618_get_red_success_message");
				if(MyUtil.isEmpty(get_red_success_message)) {
					get_red_success_message = "您的红包已经发放成功!";
				}
				
				//可以活动
				
				this.send_image(gongzonghao, openid);
				
				gongzonghao.send_text_message(get_red_success_message, openid);
		} catch (Exception e) {
			logger.error("关注回调业务处理失败!", e);
		}
	}

	@Override
	public void subscribe_call_back(Gongzonghao gongzonghao, String data_id, String openid) {
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		String amount_yuan_str = WebConfigContent.getConfig("618_amount_yuan"); 
		
		String startTime_618_str = WebConfigContent.getConfig("startTime_618");
		String endTime_618_str = WebConfigContent.getConfig("endTime_618");
		
		//红包使用开始时间
		Date startTime_date = null;
		//红包使用 过期时间
		Date endTime_date = null;
		
		try {
			//红包有效期
			startTime_date = DateUtil.getSdfFull().parse(startTime_618_str);
			//红包有效期
			endTime_date = DateUtil.getSdfFull().parse(endTime_618_str);
		} catch (ParseException e1) {
		}
		
		Double amount_yuan = MathUtil.parseDouble(amount_yuan_str);
		
		Integer amount_fen = MathUtil.multiplyInteger(amount_yuan, 100).intValue();
		
		RedEnvelopes618 redEnvelopes618_find = new RedEnvelopes618();
		redEnvelopes618_find.setOpenid(openid);
		
		redEnvelopes618_find = (RedEnvelopes618) serializContext.get(redEnvelopes618_find);
		
		if(redEnvelopes618_find != null) {
			gongzonghao.send_text_message("每人只能领取一次哦.", openid);
			return;
		}
		
			
		redEnvelopes618_find = new RedEnvelopes618();
			
		redEnvelopes618_find.setId(new ObjectId().toString());
		redEnvelopes618_find.setOpenid(openid);
		redEnvelopes618_find.setAmount_fen(amount_fen);
		if(startTime_date != null) {
				redEnvelopes618_find.setStartTime(startTime_date.getTime());
		}
		if(endTime_date != null) {
				redEnvelopes618_find.setEndTime(endTime_date.getTime());
		}
		redEnvelopes618_find.setState(State.STATE_WAITE_PROCESS);
			
		serializContext.save(redEnvelopes618_find);
		
		
		this.send_redEnvelopes618(gongzonghao, openid);
	}
	
	public void send_image(Gongzonghao gongzonghao,String openid) throws IOException {
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		SubscribeUser subscribeUser_find = new SubscribeUser();
		subscribeUser_find.setOpenid(openid);

		SubscribeUser subscribeUser = (SubscribeUser)serializContext.get(subscribeUser_find);
		
		String realPath = WeixinCallBackMessageFilter.threadLocal_realPath.get();
		String basePath = WeixinCallBackMessageFilter.threadLocal_basePath.get();
		
		
		BufferedImage bufferedImage_base_img = ImageIO.read(new File(realPath+"activities/618/image_qr_code/base_img.jpg"));
		
		BufferedImage bufferedImage_qr_code = ImageIO.read(new File(realPath+"activities/618/image_qr_code/LiuyibaShareBusiness.jpg"));
		
		URL head_image_url = new URL( subscribeUser.getHeadimgurl() );
		
		BufferedImage bufferedImage_head = ImageIO.read(head_image_url);
		
		bufferedImage_head= ImageUtil.scaledBufferedImage(bufferedImage_head, 300, 300);
		
		bufferedImage_head = ImageUtil.setRadius(bufferedImage_head);
		
		bufferedImage_base_img =  ImageUtil.synthesisBufferedImage(bufferedImage_base_img, bufferedImage_qr_code, 605, 2206);
		
		bufferedImage_base_img =  ImageUtil.synthesisBufferedImage(bufferedImage_base_img, bufferedImage_head, 587, 318);
		
		String nickname = subscribeUser.getNickname();
		if(nickname == null){
			nickname = ""; 
		} 
		
		Graphics graphics = bufferedImage_base_img.getGraphics();
		
		int font_size = 68;
		
		Font font = new Font("微软雅黑",Font.PLAIN,font_size);
		graphics.setColor(Color.WHITE);
		graphics.setFont(font);
		
		int strWidth = graphics.getFontMetrics().stringWidth(nickname);
		graphics.drawString(nickname, 734 - strWidth / 2, 698); 
		graphics.dispose();
		
		
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		ImageUtil.write(bufferedImage_base_img, baos);
		
		ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(baos.toByteArray());
		
		String worldCupForecast_resul_media_id = gongzonghao.upload_media(byteArrayInputStream,"tmp.jpg","image/jpeg","image");
		String send_result_image_message = gongzonghao.send_image_message(openid,worldCupForecast_resul_media_id);
		
		JsonObject send_result_image_JsonObject = JsonUtil.parseJsonObject(send_result_image_message);
		String send_result_image_errcode = JsonUtil.getString(send_result_image_JsonObject, "errcode");
		if(!"0".equals(send_result_image_errcode) ){
			logger.error("send_result_image_message:"+send_result_image_message);
		}
	}
	
	public void send_activity_news(Gongzonghao gongzonghao, String data_id, String openid) {
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		String amount_yuan_str = WebConfigContent.getConfig("618_amount_yuan"); 
		
		String startTime_618_str = WebConfigContent.getConfig("startTime_618");
		String endTime_618_str = WebConfigContent.getConfig("endTime_618");
		
		//红包使用开始时间
		Date startTime_date = null;
		//红包使用 过期时间
		Date endTime_date = null;
		
		try {
			//红包有效期
			startTime_date = DateUtil.getSdfFull().parse(startTime_618_str);
			//红包有效期
			endTime_date = DateUtil.getSdfFull().parse(endTime_618_str);
		} catch (ParseException e1) {
		}
		
		Double amount_yuan = MathUtil.parseDouble(amount_yuan_str);
		
		Integer amount_fen = MathUtil.multiplyInteger(amount_yuan, 100).intValue();
		
		RedEnvelopes618 redEnvelopes618_find = new RedEnvelopes618();
		redEnvelopes618_find.setOpenid(openid);
		
		redEnvelopes618_find = (RedEnvelopes618) serializContext.get(redEnvelopes618_find);
		
		if(redEnvelopes618_find == null) {
			
			redEnvelopes618_find = new RedEnvelopes618();
			
			redEnvelopes618_find.setId(new ObjectId().toString());
			redEnvelopes618_find.setOpenid(openid);
			redEnvelopes618_find.setAmount_fen(amount_fen);
			if(startTime_date != null) {
				redEnvelopes618_find.setStartTime(startTime_date.getTime());
			}
			if(endTime_date != null) {
				redEnvelopes618_find.setEndTime(endTime_date.getTime());
			}
			redEnvelopes618_find.setState(State.STATE_WAITE_PROCESS);
			
			serializContext.save(redEnvelopes618_find);
		}
		
		String basePath = WeixinCallBackMessageFilter.threadLocal_basePath.get();
		
		String tuiwen_title = WebConfigContent.getConfig("618_tuiwen_title"); 
		String tuiwen_content = WebConfigContent.getConfig("618_tuiwen_content");
		String tuiwen_link = WebConfigContent.getConfig("618_tuiwen_link");
		String tuiwen_pic = WebConfigContent.getConfig("618_tuiwen_pic");
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
	
	public boolean check_today_count_finish(Gongzonghao gongzonghao,String openid) {
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		String every_day_count_618_str = WebConfigContent.getConfig("618_every_day_count");
		Integer every_day_count_618 = MathUtil.parseInteger(every_day_count_618_str);
		
		
		//检查每天的红包领取总数
		RedEnvelopes618 redEnvelopes618_tongji = new RedEnvelopes618();
		
		redEnvelopes618_tongji.addCommand(MongoCommand.or, "state", State.STATE_WAITE_PAY);
		redEnvelopes618_tongji.addCommand(MongoCommand.or, "state", State.STATE_PAY_SUCCESS);
		
		Long currentDayStartTime = DateUtil.getCurrentDayStartTime();
		Long currentDayEndTime = currentDayStartTime+DateUtil.one_day;
		
		if(currentDayStartTime !=null ){
			ObjectId startTimeObj = new ObjectId(new Date(currentDayStartTime));
			redEnvelopes618_tongji.addCommand(MongoCommand.dayuAndDengyu, "id", startTimeObj);
		}
		if(currentDayEndTime !=null ){
			ObjectId endTimeObj = new ObjectId(new Date(currentDayEndTime));
			redEnvelopes618_tongji.addCommand(MongoCommand.xiaoyu, "id", endTimeObj);
		}
		
		PageSplit pageSplit = new PageSplit();
		pageSplit.setPageSize(1);
		
		Iterator<RedEnvelopes618> findIterable = serializContext.findIterable(redEnvelopes618_tongji, pageSplit);
		 
		if(every_day_count_618 == null || pageSplit.getCount() >= every_day_count_618) {
			return false;
		}
		
		return true;
	}
	
	public boolean check_is_on_activity(Gongzonghao gongzonghao,String openid) {
		
		String startTime_618_do_str = WebConfigContent.getConfig("startTime_618_do");
		String endTime_618_do_str = WebConfigContent.getConfig("endTime_618_do");
		
		String activities_not_start_618 = WebConfigContent.getConfig("activities_not_start_618");
		String activities_had_end_618 = WebConfigContent.getConfig("activities_had_end_618");
		
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
						gongzonghao.send_text_message(activities_not_start_618, openid);
					return false;
				}
				//检查活动是否已经结束
				if(endTime_date_do == null || System.currentTimeMillis() > endTime_date_do.getTime() ) {
					gongzonghao.send_text_message(activities_had_end_618, openid);
					return false;
				}
		return true;
	}
	  
 
}
