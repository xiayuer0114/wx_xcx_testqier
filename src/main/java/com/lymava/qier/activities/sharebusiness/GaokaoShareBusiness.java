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
import java.util.Random;

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
import com.lymava.qier.activities.model.GaokaoChengji;
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

public class GaokaoShareBusiness extends GongzonghaoShareBusiness{
	
	public static void main(String[] args) throws IOException {
		
		BufferedImage createQrBufferedImage;
		try {
			createQrBufferedImage = QrCodeUtil.createQrBufferedImage("http://tiesh.liebianzhe.com/activities/gaokao/index.jsp", 168);
			

			ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
			
			ImageUtil.write(createQrBufferedImage, byteArrayOutputStream);
			
			 FileOutputStream fileOutputStream = new FileOutputStream("/home/lymava/workhome/program/罗彪项目/营销活动/高考查成绩/750/fenxiang_168.jpg");
			 
			 fileOutputStream.write(byteArrayOutputStream.toByteArray());
			 fileOutputStream.flush();
			 fileOutputStream.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public String getBusinessName() {
		return "高考";
	}

	@Override
	public String getBusinessId() {
		return "gaokao";
	}
  
	@Override
	public void subscribe_call_back(Gongzonghao gongzonghao, String data_id, String openid) {
		try {
			this.gaokao_call_back(gongzonghao, data_id, openid);
		} catch (Exception e) {
			logger.error("哪粽人回调异常!",e);
		}
	}

	private void gaokao_call_back(Gongzonghao gongzonghao, String data_id, String openid)  throws Exception{
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		
		SubscribeUser subscribeUser_find = new SubscribeUser();
		subscribeUser_find.setOpenid(openid);

		GaokaoChengji gaokaoChengji = new GaokaoChengji();
		gaokaoChengji.setOpenid(openid);
		
		gaokaoChengji = (GaokaoChengji)serializContext.get(gaokaoChengji);
		
		if(gaokaoChengji == null) {
			gongzonghao.send_text_message("请按步骤操作!", openid);
			return;
		}
		
		gaokaoChengji.setState(State.STATE_OK);
		
		serializContext.save(gaokaoChengji);
		
		URL resource = WorldCupForecastShareBusiness.class.getResource("/com/lymava/qier/activities/image/gaokao/"+gaokaoChengji.getXuexiao()+".jpg");
		File file_media = new File(resource.getFile());
		
		if(!file_media.exists()) {
			gongzonghao.send_text_message("学校不存在!", openid);
			return;
		}
		
		
		BufferedImage bufferedImage_base_img = ImageIO.read(file_media);
		if(bufferedImage_base_img == null) {
			return;
		}
		
		String user_name = gaokaoChengji.getUser_name();
		
		Graphics graphics = bufferedImage_base_img.getGraphics();
		
		int font_size = 30;
		
		Font font = new Font("微软雅黑",Font.BOLD,font_size);
		graphics.setColor(Color.BLACK);
		graphics.setFont(font);
		
		graphics.drawString(user_name+"同学：", 186, 445+font_size); 
		graphics.dispose();
		
		try {
//			ImageUtil.write(bufferedImage_base_img, new FileOutputStream("/home/lymava/workhome/program/罗彪项目/营销活动/高考查成绩/750/结果.jpg"));
			
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
