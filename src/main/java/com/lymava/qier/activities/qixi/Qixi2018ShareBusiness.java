package com.lymava.qier.activities.qixi;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Random;

import javax.imageio.ImageIO;

import org.bson.types.ObjectId;

import com.google.gson.JsonObject;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.util.ImageUtil;
import com.lymava.commons.util.JsonUtil;
import com.lymava.commons.util.QrCodeUtil;
import com.lymava.nosql.context.SerializContext;
import com.lymava.nosql.model.SerializModel;
import com.lymava.qier.activities.model.NazhongRen;
import com.lymava.wechat.gongzhonghao.Gongzonghao;
import com.lymava.wechat.gongzhonghao.sharebusiness.GongzonghaoShareBusiness;
import com.lymava.wechat.opendevelop.WeixinCallBackMessageFilter;

public class Qixi2018ShareBusiness extends GongzonghaoShareBusiness{
	
	public static void main(String[] args) throws IOException {
		
		BufferedImage createQrBufferedImage;
		try {
			createQrBufferedImage = QrCodeUtil.createQrBufferedImage("http://weixin.qq.com/q/02qUxVABx-cVk1KjWs1rcR", 211);
			

			ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
			
			ImageUtil.write(createQrBufferedImage, byteArrayOutputStream);
			
			 FileOutputStream fileOutputStream = new FileOutputStream("/home/lymava/workhome/program/罗彪项目/营销活动/七夕线上活动/test.jpg");
			 
			 fileOutputStream.write(byteArrayOutputStream.toByteArray());
			 fileOutputStream.flush();
			 fileOutputStream.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public String getBusinessName() {
		return "2018七夕";
	}

	@Override
	public String getBusinessId() {
		return "qixi2018";
	}

	@Override
	public void subscribe_call_back(Gongzonghao gongzonghao, String data_id, String openid) {
		try {
			this.qixi2018_call_back(gongzonghao, data_id, openid);
		} catch (Exception e) {
			logger.error("qixi2018回调异常!",e);
		}
	}
	
	public void qixi2018_call_back(Gongzonghao gongzonghao, String data_id, String openid) throws Exception {
		
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		NazhongRen nazhongRen = new NazhongRen();
		nazhongRen.setOpenid(openid);
		
		nazhongRen = (NazhongRen) serializContext.get(nazhongRen);
		
		if(nazhongRen == null) {
			nazhongRen = new NazhongRen();
			nazhongRen.setOpenid(openid);
				
			nazhongRen.setId(new ObjectId().toString());
			nazhongRen.setDianying(data_id);
			nazhongRen.setXiyouji("七夕活动");
			nazhongRen.setNizuipa("关注用户");
			
			serializContext.save(nazhongRen);
		}
		
		String realPath = WeixinCallBackMessageFilter.threadLocal_realPath.get();
		String basePath = WeixinCallBackMessageFilter.threadLocal_basePath.get();
		
		Random random = new Random();
		int nextInt = random.nextInt(3)+1;
		String res_base_pic = "/com/lymava/qier/activities/qixi/resource/qixi_res_"+nextInt+".jpg";
		
		if("miejue".equals(data_id)) {
			res_base_pic = "/com/lymava/qier/activities/qixi/resource/qixi_res_miejue.jpg";
		}
		
		InputStream resourceAsStream = this.getClass().getResourceAsStream(res_base_pic);
		
		BufferedImage bufferedImage_base_img = ImageIO.read(resourceAsStream);
		if(bufferedImage_base_img == null) {
			return;
		}
		
		BufferedImage url_bufferedImage = QrCodeUtil.createQrBufferedImage(basePath+"activities/qixi2018/", 105);
		
		
		bufferedImage_base_img =  ImageUtil.synthesisBufferedImage(bufferedImage_base_img, url_bufferedImage, 210, 1192);
		  
		try {
//			ImageUtil.write(bufferedImage_base_img, new FileOutputStream("/home/lymava/workhome/program/罗彪项目/营销活动/七夕线上活动/result.jpg"));
			
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
		} catch (IOException e) {
			
		}
	}
 
}
