package com.lymava.qier.activities.qingliang;

import java.awt.Color;
import java.awt.Font;
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
import java.util.Map;
import java.util.Random;

import javax.imageio.ImageIO;

import org.bson.types.ObjectId;
import org.dom4j.Element;

import com.google.gson.JsonObject;
import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.base.util.WebConfigContent;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.ImageUtil;
import com.lymava.commons.util.JsonUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.commons.util.QrCodeUtil;
import com.lymava.nosql.context.SerializContext;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.nosql.util.PageSplit;
import com.lymava.qier.activities.model.SubscribeFirstRedEnvelope;
import com.lymava.qier.business.BusinessIntIdConfigQier;
import com.lymava.qier.model.Merchant72;
import com.lymava.trade.pay.model.PaymentRecord;
import com.lymava.trade.util.WebConfigContentTrade;
import com.lymava.wechat.gongzhonghao.Gongzonghao;
import com.lymava.wechat.gongzhonghao.SubscribeUser;
import com.lymava.wechat.gongzhonghao.sharebusiness.GongzonghaoShareBusiness;
import com.lymava.wechat.opendevelop.WeixinCallBackMessageFilter;

public class QingliangShareBusiness extends GongzonghaoShareBusiness{
	
	public static void main(String[] args) throws IOException {
		
		BufferedImage createQrBufferedImage;
		try {
			createQrBufferedImage = QrCodeUtil.createQrBufferedImage("http://weixin.qq.com/q/02ugLIBmx-cVk1AGwrhrct", 400);
			

			ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
			
			ImageUtil.write(createQrBufferedImage, byteArrayOutputStream);
			
			 FileOutputStream fileOutputStream = new FileOutputStream("/home/lymava/workhome/program/罗彪项目/营销活动/清凉计划设计页面及功能说明书/qr_code.jpg");
			 
			 fileOutputStream.write(byteArrayOutputStream.toByteArray());
			 fileOutputStream.flush();
			 fileOutputStream.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public String getBusinessName() {
		return "清凉计划";
	}

	@Override
	public String getBusinessId() {
		return "qingliang";
	}
  
	@Override
	public Integer executeCallBackMessage_text(Gongzonghao gongzonghao, Element rootElement, Map parameterMap) {
		return State.STATE_OK;
	}
	/**
	 * 获取参与总人数
	 * @return
	 */
	public Long canyu_zong_renshu() {
		
		PaymentRecord paymentRecord_find = new PaymentRecord();
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		paymentRecord_find.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_qingliang);
		paymentRecord_find.setState(State.STATE_PAY_SUCCESS);
		
		PageSplit pageSplit = new PageSplit();
		
		serializContext.findIterable(paymentRecord_find,pageSplit);
		
		String qingliang_init_count_person = WebConfigContent.getConfig("qingliang_init_count_person");
		Long qingliang_init_count_person_long = MathUtil.parseLong(qingliang_init_count_person);
		
		return qingliang_init_count_person_long+pageSplit.getCount();
	}
	/**
	 * 获取总金额	单位元
	 * @return
	 */
	public Long canyu_zong_price() {
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		MerchantQingliang merchantQingliang = new MerchantQingliang();
		merchantQingliang.setState(State.STATE_OK);
		
		
		Iterator<MerchantQingliang> merchantQingliang_ite =  serializContext.findIterable(merchantQingliang);
		
		Long price_fen_all = 0l;
		 
		while(merchantQingliang_ite.hasNext()) {
			
			MerchantQingliang merchantQingliang_next = merchantQingliang_ite.next();
			
			Long price_fen_all_tmp = merchantQingliang_next.getPrice_fen();
			if(price_fen_all_tmp == null){
				price_fen_all_tmp = 0l;
			}
			price_fen_all += price_fen_all_tmp;
		}
		
		Long price_yuan_all = MathUtil.divide(price_fen_all, 100).longValue();
		
		String qingliang_init_zong_price = WebConfigContent.getConfig("qingliang_init_zong_price");
		Long qingliang_init_zong_price_long = MathUtil.parseLong(qingliang_init_zong_price);
		
		return qingliang_init_zong_price_long+price_yuan_all;
	}
	/**
	 * 获取最近捐的钱	单位元
	 * @return
	 */
	public Double get_last_juanxian(SubscribeUser subscribeUser) {
		
		String openid = subscribeUser.getOpenid();
		String unionid = subscribeUser.getUnionid();
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		User user_find = null;
		
		String defaultUserGroupId = WebConfigContent.getInstance().getDefaultUserGroupId();
		
		if(user_find == null &&  !MyUtil.isEmpty(unionid)){
			user_find = new User();
			
			user_find.setUnionid(unionid);
			user_find.setUserGroupId(defaultUserGroupId);
			
			user_find = (User)serializContext.get(user_find);
		}
		
		if(user_find == null && !MyUtil.isEmpty(openid) ){
			user_find = new User();
			
			user_find.setThird_user_id(openid);
			user_find.setUserGroupId(defaultUserGroupId);
			
			user_find = (User)serializContext.get(user_find);
		}
		
		if(user_find == null) {
			return 0d;
		}
		
		MerchantQingliangPaymentRecord merchantQingliangPaymentRecord_find = new MerchantQingliangPaymentRecord();
		
		merchantQingliangPaymentRecord_find.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_qingliang);
		merchantQingliangPaymentRecord_find.setUserId_huiyuan(user_find.getId());
		
		merchantQingliangPaymentRecord_find = (MerchantQingliangPaymentRecord) serializContext.findOneInlist(merchantQingliangPaymentRecord_find);
		
		if(merchantQingliangPaymentRecord_find == null) {
			return 0d;
		}
		
		Long showPrice_fen_all = merchantQingliangPaymentRecord_find.getShowPrice_fen_all();
		
		Double price_all_yuan = MathUtil.divide(showPrice_fen_all, 100).doubleValue();
		
		return price_all_yuan;
	}

	@Override
	public void subscribe_call_back(Gongzonghao gongzonghao, String data_id, String openid) {
		//检查是否在活动中
		boolean check_is_on_activity = check_is_on_activity();
		if(!check_is_on_activity) { return; }
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		SubscribeUser subscribeUser_find = new SubscribeUser();
		subscribeUser_find.setOpenid(openid);

		SubscribeUser subscribeUser = (SubscribeUser)serializContext.get(subscribeUser_find);
		
		if(subscribeUser == null) {
			logger.error("openid:"+openid+" 关注用户不存在!");
			return;
		}
		
		subscribeUser.refresh_info();
		
		Merchant72 merchant72 = null;
		 
		Long user_merchant_bianhao = MathUtil.parseLongNull(data_id);
		if(user_merchant_bianhao != null){
			
			merchant72 = new Merchant72();
			
			merchant72.setBianhao(user_merchant_bianhao);
			merchant72.setUserGroupId(WebConfigContentTrade.getInstance().getMerchantUserGroupId());
			
			merchant72 = (Merchant72)serializContext.get(merchant72);
		}
		
		if(merchant72 == null) {
			logger.error("data_id:"+data_id+" 未找到商户!");
			return;
		}
		
		MerchantQingliang merchantQingliang = new MerchantQingliang();
		
		merchantQingliang.setState(State.STATE_OK);
		merchantQingliang.setUserId_merchant(merchant72.getId());
		
		merchantQingliang =  (MerchantQingliang) serializContext.get(merchantQingliang);
		
		if(merchantQingliang == null) {
			logger.error("userId_merchant_tmp:"+merchant72.getId()+" 未参与清凉计划!");
			return;
		}
		
		
		String realPath = WeixinCallBackMessageFilter.threadLocal_realPath.get();
		String basePath = WeixinCallBackMessageFilter.threadLocal_basePath.get();
		
		File tuiguang_pic_file = new File(realPath+merchantQingliang.getPic());
		if(!tuiguang_pic_file.exists()) {
			logger.error("userId_merchant_tmp:"+merchant72.getId()+" 推广图未设置!");
			return;
		}

		Random random = new Random();
		int nextInt = random.nextInt(3)+1;
		
		
		String res_base_pic = "/com/lymava/qier/activities/qingliang/source/person_share_"+nextInt+".jpg";
		
		try {
			 
			BufferedImage bufferedImage_base_img = ImageIO.read(this.getClass().getResourceAsStream(res_base_pic));
			if(bufferedImage_base_img == null) {
				return;
			}
			
			URL head_image_url = new URL( subscribeUser.getHeadimgurl() );
			
			BufferedImage bufferedImage_head = ImageIO.read(head_image_url);
			bufferedImage_head= ImageUtil.scaledBufferedImage(bufferedImage_head, 108, 108);
			bufferedImage_head = ImageUtil.setRadius(bufferedImage_head);
			
			bufferedImage_base_img =  ImageUtil.synthesisBufferedImage(bufferedImage_base_img, bufferedImage_head, 9, 790);
			
			String nickname = subscribeUser.getNickname();
			Font font = new Font("微软雅黑",Font.PLAIN,37);
			ImageUtil.drawString(bufferedImage_base_img, nickname, font, Color.BLACK, 154, 862);
			String get_last_juanxian = this.get_last_juanxian(subscribeUser)+"";
			if(get_last_juanxian.endsWith(".0")) {
				get_last_juanxian = get_last_juanxian.substring(0, get_last_juanxian.length()-2);
			}
			
			ImageUtil.drawString(bufferedImage_base_img,get_last_juanxian, font, Color.BLACK, 560, 912);
			
			Font font_content = new Font("微软雅黑",Font.PLAIN,23);
			ImageUtil.drawString(bufferedImage_base_img,this.canyu_zong_price()+"", font_content, Color.BLACK, 176, 1088);
			ImageUtil.drawString(bufferedImage_base_img,this.canyu_zong_renshu()+"", font_content, Color.BLACK, 494, 980);
			  
			String share_url = basePath+"activities/qingliang/?b="+merchant72.getBianhao();
			
				
			BufferedImage  createQrBufferedImage = QrCodeUtil.createQrBufferedImage(share_url, 400);
			BufferedImage scaledBufferedImage_156 = ImageUtil.getScaledBufferedImage(createQrBufferedImage, 78, 78);
			
			bufferedImage_base_img = ImageUtil.synthesisBufferedImage(bufferedImage_base_img, scaledBufferedImage_156, 76, 1189);
			
//			ImageUtil.write(bufferedImage_base_img, new FileOutputStream("/home/lymava/workhome/program/罗彪项目/营销活动/清凉计划设计页面及功能说明书/person_share_final.jpg"));
			
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			ImageUtil.write(bufferedImage_base_img, baos);
			ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(baos.toByteArray());
			String nazhongren_resul_media_id = gongzonghao.upload_media(byteArrayInputStream,"tmp.jpg","image/jpeg","image");
			
			String send_result_image_message = gongzonghao.send_image_message(openid,nazhongren_resul_media_id);
			
			JsonObject send_result_image_JsonObject = JsonUtil.parseJsonObject(send_result_image_message);
			
			String send_result_image_errcode = JsonUtil.getString(send_result_image_JsonObject, "errcode");
			if(!"0".equals(send_result_image_errcode) ){
				logger.error("send_result_image_message:"+send_result_image_message);
			}
			
		} catch (Exception e) {
			logger.error("userId_merchant_tmp:"+merchant72.getId()+" 发送推广图未失败!",e);
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
