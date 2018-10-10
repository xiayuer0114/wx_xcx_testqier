package com.lymava.qier.activities.sharebusiness;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.text.ParseException;
import java.util.Date;
import java.util.List;

import org.bson.types.ObjectId;

import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.base.util.WebConfigContent;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.ImageUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.Md5Util;
import com.lymava.commons.util.MyUtil;
import com.lymava.commons.util.QrCodeUtil;
import com.lymava.nosql.context.SerializContext;
import com.lymava.qier.activities.model.RedEnvelopesKol200;
import com.lymava.qier.model.Merchant72;
import com.lymava.qier.model.MerchantRedEnvelope;
import com.lymava.qier.model.User72;
import com.lymava.wechat.gongzhonghao.Gongzonghao;
import com.lymava.wechat.gongzhonghao.SubscribeUser;
import com.lymava.wechat.gongzhonghao.sharebusiness.GongzonghaoShareBusiness;

public class KOL200ShareBusiness extends GongzonghaoShareBusiness{
	
	public static void main(String[] args) {
		BufferedImage createQrBufferedImage;
		try {
			createQrBufferedImage = QrCodeUtil.createQrBufferedImage("http://weixin.qq.com/q/02IFmdA0x-cVk1q3zdNrcs", 400);
			

			ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
			ImageUtil.write(createQrBufferedImage, byteArrayOutputStream);
			
			 FileOutputStream fileOutputStream = new FileOutputStream("/home/lymava/下载/世界杯/kol200_100.jpg");
			 
			 fileOutputStream.write(byteArrayOutputStream.toByteArray());
			 fileOutputStream.flush();
			 fileOutputStream.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public String getBusinessName() {
		return "kol200";
	}

	@Override
	public String getBusinessId() {
		return "kol200";
	}

	@Override
	public void subscribe_call_back(Gongzonghao gongzonghao, String data_id, String openid) {
		  this.kol_200_subscribe_call_back(gongzonghao,data_id,openid);
	}
	
	public void kol_200_subscribe_call_back(Gongzonghao gongzonghao, String data_id, String openid){
		
		boolean check_is_on_activity = this.check_is_on_activity(gongzonghao, openid);
		if(!check_is_on_activity) {
			return;
		}
		
		if(MyUtil.isEmpty(data_id)) {
			gongzonghao.send_text_message("领取失败!", openid);
			return;
		}
		
		
		this.send_redEnvelopesKol200(gongzonghao, data_id, openid);
		
	}
	
	public void send_redEnvelopesKol200(Gongzonghao gongzonghao, String data_id, String openid) {
		
		String activities_kol200_amount_yuan_str = WebConfigContent.getConfig("activities_kol200_amount_yuan");
		
		String activities_kol200_red_envolope_name = WebConfigContent.getConfig("activities_kol200_red_envolope_name");
		
		String activities_kol200_userId_merchant = WebConfigContent.getConfig("activities_kol200_userId_merchant");
		
		String activities_kol200_RedEnvelope_end_time = WebConfigContent.getConfig("activities_kol200_RedEnvelope_end_time");
		
		String kol200_get_red_success_message = WebConfigContent.getConfig("kol200_get_red_success_message");
		
		String activities_kol200_had_get_msg = WebConfigContent.getConfig("activities_kol200_had_get_msg");
		
		Date redEnvelope_end_time = null;
		try {
			redEnvelope_end_time = DateUtil.getSdfFull().parse(activities_kol200_RedEnvelope_end_time);
		} catch (ParseException e) {
			logger.error("定向红包截止日期未配置!", e);
			return;
		}
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		Merchant72 merchant72 = null;
		if(MyUtil.isValid(activities_kol200_userId_merchant)) {
			merchant72 = (Merchant72) serializContext.get(Merchant72.class,activities_kol200_userId_merchant);
		}
		
		if(merchant72 == null) {
			gongzonghao.send_text_message("定向红包商户未配置！", openid);
			logger.error("定向红包商户未配置！");
			return;
		}
		
		Double activities_kol200_amount_yuan = MathUtil.parseDouble(activities_kol200_amount_yuan_str);
		
		Integer activities_kol200_amount_fen = MathUtil.multiply(activities_kol200_amount_yuan, 100).intValue();
		
		RedEnvelopesKol200 redEnvelopesKol200 = new RedEnvelopesKol200();
		
		redEnvelopesKol200.setId(new ObjectId().toString());
		redEnvelopesKol200.setOpenid(openid);
		redEnvelopesKol200.setData_id(data_id);
		redEnvelopesKol200.setAmount_fen(activities_kol200_amount_fen);
		redEnvelopesKol200.setState(State.STATE_WAITE_PAY);
		
		
		serializContext.save(redEnvelopesKol200);
		
		boolean checkRequestFlow = this.checkRequestFlow(redEnvelopesKol200);
		if(!checkRequestFlow) {
			gongzonghao.send_text_message(activities_kol200_had_get_msg, openid);
			logger.error("data_id:"+data_id+" 重复请求!");
			return;
		}
		
		User72 user72 = redEnvelopesKol200.getUser72();
		
		if(user72 == null) {
				WebConfigContent instance = WebConfigContent.getInstance();
				String defaultUserGroupId = instance.getDefaultUserGroupId();
				
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
		
		
		MerchantRedEnvelope merchantRedEnvelope_save = new MerchantRedEnvelope();
		
		merchantRedEnvelope_save.setId(new ObjectId().toString());
		merchantRedEnvelope_save.setRed_envolope_name(activities_kol200_red_envolope_name);
		merchantRedEnvelope_save.setUserId_merchant(activities_kol200_userId_merchant);
		merchantRedEnvelope_save.setAmount(activities_kol200_amount_fen*User.pianyiFen);
		merchantRedEnvelope_save.setBalance(activities_kol200_amount_fen*User.pianyiFen);
		merchantRedEnvelope_save.setState(State.STATE_OK);
		merchantRedEnvelope_save.setMerchant_type(merchant72.getMerchant72_type());
		merchantRedEnvelope_save.setExpiry_time(redEnvelope_end_time.getTime());
		merchantRedEnvelope_save.setIndex_id(System.currentTimeMillis());
		merchantRedEnvelope_save.setUser_huiyuan(user72);
		
		serializContext.save(merchantRedEnvelope_save);
		
		//发送成功消息
		gongzonghao.send_text_message(kol200_get_red_success_message, openid);
	}
	
	/**
	 * 检查流水号是否重复
	 * @param businessRecord	交易记录
	 * @throws CheckException	交易失败的时候抛出
	 */
	public  boolean checkRequestFlow(RedEnvelopesKol200 redEnvelopesKol200) throws CheckException{
		
		RedEnvelopesKol200 redEnvelopesKol200_find = new RedEnvelopesKol200();
		redEnvelopesKol200_find.setData_id(redEnvelopesKol200.getData_id());
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		String orderId = redEnvelopesKol200.getId();
		
		//首先只要出现不是 本次生成的 object id 的项 这次请求丢弃。
		List<RedEnvelopesKol200> rechargeRecord_list = serializContext.findAll(redEnvelopesKol200_find); 
		
		if ( !(rechargeRecord_list.size() == 1 && orderId.equals(rechargeRecord_list.get(0).getId())) ) {
			serializContext.removeByKey(redEnvelopesKol200);
			return false;
		}
		return true;
	}
	
	public boolean check_is_on_activity(Gongzonghao gongzonghao,String openid) {
		
		String activities_kol200_startTime_str = WebConfigContent.getConfig("activities_kol200_startTime");
		String activities_kol200_endTime_str = WebConfigContent.getConfig("activities_kol200_endTime");
		
		String activities_not_start_kol200 = WebConfigContent.getConfig("activities_kol200_not_start_msg");
		String activities_had_end_kol200 = WebConfigContent.getConfig("activities_kol200_had_end_msg");
		
		// 活动领取 红包 开始时间
		Date startTime_date_do = null;
		// 活动领取 红包 结束时间
		Date endTime_date_do = null;
		

		try {
			//红包有效期
			startTime_date_do = DateUtil.getSdfFull().parse(activities_kol200_startTime_str);
			//红包有效期
			endTime_date_do = DateUtil.getSdfFull().parse(activities_kol200_endTime_str);
		} catch (ParseException e1) {
		}
		
		//检查活动是否开始
				if(startTime_date_do == null || System.currentTimeMillis() < startTime_date_do.getTime()) {
					gongzonghao.send_text_message(activities_not_start_kol200, openid);
					return false;
				}
				//检查活动是否已经结束
				if(endTime_date_do == null || System.currentTimeMillis() > endTime_date_do.getTime() ) {
					gongzonghao.send_text_message(activities_had_end_kol200, openid);
					return false;
				}
		return true;
	}
	 
	  
 
}
