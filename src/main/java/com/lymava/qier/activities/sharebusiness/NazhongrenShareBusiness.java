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
import java.util.Random;

import javax.imageio.ImageIO;

import com.alipay.api.domain.QRcode;
import com.google.gson.JsonObject;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.util.ImageUtil;
import com.lymava.commons.util.JsonUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.commons.util.QrCodeUtil;
import com.lymava.nosql.context.SerializContext;
import com.lymava.wechat.gongzhonghao.Gongzonghao;
import com.lymava.wechat.gongzhonghao.SubscribeUser;
import com.lymava.wechat.gongzhonghao.sharebusiness.GongzonghaoShareBusiness;
import com.lymava.wechat.opendevelop.WeixinCallBackMessageFilter;

public class NazhongrenShareBusiness extends GongzonghaoShareBusiness{
	
	public static void main(String[] args) throws IOException {
		
		BufferedImage createQrBufferedImage;
		try {
			createQrBufferedImage = QrCodeUtil.createQrBufferedImage("http://weixin.qq.com/q/02yER0Akx-cVk1kwMd1rcX", 400);
			

			ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
			
			ImageUtil.write(createQrBufferedImage, byteArrayOutputStream);
			
			 FileOutputStream fileOutputStream = new FileOutputStream("/home/lymava/下载/世界杯/哪粽人ShareBusiness.jpg");
			 
			 fileOutputStream.write(byteArrayOutputStream.toByteArray());
			 fileOutputStream.flush();
			 fileOutputStream.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public String getBusinessName() {
		return "哪粽人";
	}

	@Override
	public String getBusinessId() {
		return "nazhongren";
	}

	@Override
	public void subscribe_call_back(Gongzonghao gongzonghao, String data_id, String openid) {
		try {
			this.nazhongren_call_back(gongzonghao, data_id, openid);
		} catch (Exception e) {
			logger.error("哪粽人回调异常!",e);
		}
	}
	
	public void nazhongren_call_back(Gongzonghao gongzonghao, String data_id, String openid) throws Exception {
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		Random random = new Random();
		
		int nextInt = random.nextInt(4)+1;
		
		SubscribeUser subscribeUser_find = new SubscribeUser();
		subscribeUser_find.setOpenid(openid);

		SubscribeUser subscribeUser = (SubscribeUser)serializContext.get(subscribeUser_find);
		
		String realPath = WeixinCallBackMessageFilter.threadLocal_realPath.get();
		String basePath = WeixinCallBackMessageFilter.threadLocal_basePath.get();
		
		String res_base_pic = "activities/duanwu/img/res_"+nextInt+".jpg";
		
		
		BufferedImage bufferedImage_base_img = ImageIO.read(new File(realPath+res_base_pic));
		if(bufferedImage_base_img == null) {
			return;
		}
		
		URL head_image_url = new URL( subscribeUser.getHeadimgurl() );
		
		BufferedImage bufferedImage_head = ImageIO.read(head_image_url);
		
		bufferedImage_head= ImageUtil.scaledBufferedImage(bufferedImage_head, 139, 139);
		bufferedImage_head = ImageUtil.setRadius(bufferedImage_head);
		
		bufferedImage_base_img =  ImageUtil.synthesisBufferedImage(bufferedImage_base_img, bufferedImage_head, 306, 258);
		
		BufferedImage createQrBufferedImage = QrCodeUtil.createQrBufferedImage(basePath+"activities/duanwu/", 150);
		bufferedImage_base_img =  ImageUtil.synthesisBufferedImage(bufferedImage_base_img, createQrBufferedImage, 299, 1081);
		 
		String nickname = subscribeUser.getNickname();
		if(nickname == null){
			nickname = ""; 
		} 
		
		Graphics graphics = bufferedImage_base_img.getGraphics();
		
		int font_size = 26;
		
		Font font = new Font("微软雅黑",Font.PLAIN,font_size);
		graphics.setColor(Color.BLACK);
		graphics.setFont(font);
		
		Font font_tmp = new Font("微软雅黑",Font.PLAIN , font_size);
		graphics.setFont(font_tmp);
		
		int strWidth = graphics.getFontMetrics().stringWidth(nickname);
		graphics.drawString(nickname, 377 - strWidth / 2, 424); 
		graphics.dispose();
		
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		try {
//			ImageUtil.write(bufferedImage_base_img, new FileOutputStream("/home/lymava/workhome/program/罗彪项目/营销活动/端午节/结果.jpg"));
			ImageUtil.write(bufferedImage_base_img, baos);
			ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(baos.toByteArray());
			
			String nazhongren_resul_media_id = gongzonghao.upload_media(byteArrayInputStream,"tmp.jpg","image/jpeg","image");
			
			String send_result_image_message = gongzonghao.send_image_message(openid,nazhongren_resul_media_id);
			
			JsonObject send_result_image_JsonObject = JsonUtil.parseJsonObject(send_result_image_message);
			
			String send_result_image_errcode = JsonUtil.getString(send_result_image_JsonObject, "errcode");
			if(!"0".equals(send_result_image_errcode) ){
				logger.error("send_result_image_message:"+send_result_image_message);
			}
		} catch (IOException e) {
			
		}
	}
 
}
