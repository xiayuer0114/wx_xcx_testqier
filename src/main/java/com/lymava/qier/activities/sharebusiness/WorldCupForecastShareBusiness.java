package com.lymava.qier.activities.sharebusiness;

import java.awt.Font;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import javax.imageio.ImageIO;

import com.google.gson.JsonObject;
import com.lymava.base.util.ContextUtil;
import com.lymava.base.util.WebConfigContent;
import com.lymava.commons.util.ImageUtil;
import com.lymava.commons.util.JsonUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.context.SerializContext;
import com.lymava.qier.activities.model.WorldCupForecast;
import com.lymava.wechat.gongzhonghao.Gongzonghao;
import com.lymava.wechat.gongzhonghao.sharebusiness.GongzonghaoShareBusiness;
import com.lymava.wechat.opendevelop.WeixinCallBackMessageFilter;
import com.mongodb.BasicDBList;
import com.mongodb.BasicDBObject;

public class WorldCupForecastShareBusiness extends GongzonghaoShareBusiness{
	
	public static void main(String[] args) {
		
		
		URL resource = WorldCupForecastShareBusiness.class.getResource("/com/lymava/qier/activities/image/rule.jpg");
		File file_media = new File(resource.getFile());
		
		
	}

	@Override
	public String getBusinessName() {
		return "预测世界杯";
	}

	@Override
	public String getBusinessId() {
		return "shijiebei";
	}

	@Override
	public void subscribe_call_back(Gongzonghao gongzonghao, String data_id, String openid) {
		
		if(MyUtil.isEmpty(openid)){
			return;
		} 
			  
		SerializContext serializContext = ContextUtil.getSerializContext();

		String worldCupForecast_rule_media_id = WebConfigContent.getConfig(worldCupForecast_rule_key);
		
		if(MyUtil.isEmpty(worldCupForecast_rule_media_id) ) {
			
			URL resource = WorldCupForecastShareBusiness.class.getResource("/com/lymava/qier/activities/image/rule.jpg");
			File file_media = new File(resource.getFile());
			
			worldCupForecast_rule_media_id = gongzonghao.upload_media(file_media,"image");
			
			if(worldCupForecast_rule_media_id != null) {
				WebConfigContent.saveConfig(worldCupForecast_rule_key, worldCupForecast_rule_media_id);
			}
		}
		
		try {
			
			//发送规则图
			String send_fule_image_message = gongzonghao.send_image_message(openid,worldCupForecast_rule_media_id);
			
			JsonObject parseJsonObject = JsonUtil.parseJsonObject(send_fule_image_message);
			String errcode = JsonUtil.getString(parseJsonObject, "errcode");
			if(!"0".equals(errcode) ){
				logger.error("send_fule_image_message:"+send_fule_image_message);
			}
			
			WorldCupForecast worldCupForecast_find = new WorldCupForecast();
			
			worldCupForecast_find.setType(WorldCupForecast.type_16);
			worldCupForecast_find.setOpenid(openid);
			
			WorldCupForecast worldCupForecast = (WorldCupForecast)serializContext.get(worldCupForecast_find);
			
			if(worldCupForecast == null){
				return;
			}
			
			worldCupForecast_find = new WorldCupForecast();
			
			worldCupForecast_find.setType(WorldCupForecast.type_32_to_16);
			worldCupForecast_find.setOpenid(openid);
			
			WorldCupForecast worldCupForecast_32= (WorldCupForecast)serializContext.get(worldCupForecast_find);
			
			if(worldCupForecast_32 == null){
				return;
			}
			
			
			BufferedImage worldCupForecast_image_16_synthesis = this.worldCupForecast_image_synthesis_16(worldCupForecast);
			
			BufferedImage worldCupForecast_image_synthesis_32_synthesis = this.worldCupForecast_image_synthesis_32(worldCupForecast_image_16_synthesis,worldCupForecast_32);
			
//			ImageUtil.write(worldCupForecast_image_synthesis_32_synthesis, new FileOutputStream("/home/lymava/下载/世界杯/yuce_jieguo_base_out.jpg"));
			
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			ImageUtil.write(worldCupForecast_image_synthesis_32_synthesis, baos);
			ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(baos.toByteArray());
			
			String worldCupForecast_resul_media_id = gongzonghao.upload_media(byteArrayInputStream,"tmp.jpg","image/jpeg","image");
//			发送规则图
			String send_result_image_message = gongzonghao.send_image_message(openid,worldCupForecast_resul_media_id);
			
			JsonObject send_result_image_JsonObject = JsonUtil.parseJsonObject(send_result_image_message);
			String send_result_image_errcode = JsonUtil.getString(send_result_image_JsonObject, "errcode");
			if(!"0".equals(send_result_image_errcode) ){
				logger.error("send_result_image_message:"+send_result_image_message);
			}
			
		} catch (Exception e) {
			logger.error("关注回调业务处理失败!", e);
		}
		
	}
	
	public BufferedImage worldCupForecast_image_synthesis_32(BufferedImage bufferedImage_base,WorldCupForecast worldCupForecast_32) {
		
		Map<String,String> map_has = new HashMap<String,String>();
		
		BasicDBList basicDBList = worldCupForecast_32.getBasicDBList();
		
		String realPath = WeixinCallBackMessageFilter.threadLocal_realPath.get();
		
		for (Object object : basicDBList) {
			
			BasicDBObject basicDBObject = (BasicDBObject) object;
			
			bufferedImage_base = this.worldCupForecast_image_synthesis_one_32(bufferedImage_base, basicDBObject, realPath,map_has);
		}
		
		return bufferedImage_base;
	}
	
	public BufferedImage worldCupForecast_image_synthesis_16(WorldCupForecast worldCupForecast) {
		
		InputStream resourceAsStream = WorldCupForecastShareBusiness.class.getResourceAsStream("/com/lymava/qier/activities/image/yuce_jieguo_base.jpg");
		
		BufferedImage bufferedImage_base = null;
		try {
			bufferedImage_base = ImageIO.read(resourceAsStream);
		} catch (IOException e) {
			logger.error("基图读取失败!!", e);
		}
		
		BasicDBList basicDBList = worldCupForecast.getBasicDBList();
		
		String realPath = WeixinCallBackMessageFilter.threadLocal_realPath.get();
		
		for (Object object : basicDBList) {
			
			BasicDBObject basicDBObject = (BasicDBObject) object;
			
			bufferedImage_base = this.worldCupForecast_image_synthesis_one(bufferedImage_base, basicDBObject, realPath);
		}
		
		return bufferedImage_base;
	}
	
	public BufferedImage worldCupForecast_image_synthesis_one_32(BufferedImage bufferedImage_base,BasicDBObject basicDBObject,String realPath,Map<String,String> map_has) {
		
		String group_name = (String)basicDBObject.get("group_name");
		String country_name = (String)basicDBObject.get("country_name");
		String country_image = (String)basicDBObject.get("country_image");
		if(country_name == null) {
			country_name = "";
		}
		
		String group_name_full = null;
		
		String has_value = map_has.get(group_name);
		
		if(has_value == null){
			map_has.put(group_name, country_name);
			group_name_full  = group_name+"1";
		}else{
			group_name_full  = group_name+"2";
		}
		
		String country_full_image = realPath+"activities/WorldCup/"+country_image;
		
		try {
			BufferedImage country_bufferedImage = ImageIO.read(new File(country_full_image));
			
			int image_width = 50;
			int image_height = 35;
			
			int position_x = 0;
			int position_y = 0;
			
			if("A1".equals(group_name_full)) {
				position_x = 48;
				position_y = 162;
			}else if("B2".equals(group_name_full)) {
				position_x = 48;
				position_y = 271;
			}else if("C1".equals(group_name_full)) {
				position_x = 48;
				position_y = 364;
			}else if("D2".equals(group_name_full)) {
				position_x = 48;
				position_y = 472;
			}else if("E1".equals(group_name_full)) {
				position_x = 48;
				position_y = 566;
			}else if("F2".equals(group_name_full)) {
				position_x = 48;
				position_y = 674;
			}else if("G1".equals(group_name_full)) {
				position_x = 48;
				position_y = 768;
			}else if("H2".equals(group_name_full)) {
				position_x = 48;
				position_y = 878;
			}
			
			if("B1".equals(group_name_full)) {
				position_x = 658;
				position_y = 162;
			}else if("A2".equals(group_name_full)) {
				position_x = 658;
				position_y = 271;
			}else if("D1".equals(group_name_full)) {
				position_x = 658;
				position_y = 364;
			}else if("C2".equals(group_name_full)) {
				position_x = 658;
				position_y = 472;
			}else if("F1".equals(group_name_full)) {
				position_x = 658;
				position_y = 566;
			}else if("E2".equals(group_name_full)) {
				position_x = 658;
				position_y = 674;
			}else if("H1".equals(group_name_full)) {
				position_x = 658;
				position_y = 768;
			}else if("G2".equals(group_name_full)) {
				position_x = 658;
				position_y = 878;
			}
			 
			
			BufferedImage scaledBufferedImage = ImageUtil.scaledBufferedImage(country_bufferedImage, image_width	, image_height);
			
			BufferedImage synthesisBufferedImage = ImageUtil.synthesisBufferedImage(bufferedImage_base, scaledBufferedImage,position_x,position_y);
			
			Graphics graphics = synthesisBufferedImage.getGraphics();
			
			int font_size = 14;
			
			int left = (image_width - font_size*country_name.length())/2; 
			
			
			Font font_tmp = new Font("微软雅黑",Font.PLAIN , font_size);
			graphics.setFont(font_tmp);
			graphics.drawString(country_name, position_x+left, position_y+image_height+font_size);
			
			return synthesisBufferedImage;
		} catch (IOException e) {
			logger.error("图生成失败!country_full_image:"+country_full_image, e);
		}
		
		return bufferedImage_base;
	}
	
	public BufferedImage worldCupForecast_image_synthesis_one(BufferedImage bufferedImage_base,BasicDBObject basicDBObject,String realPath) {
		
		String data_class = (String)basicDBObject.get("data_class");
		String country_name = (String)basicDBObject.get("country_name");
		String country_image = (String)basicDBObject.get("country_image");
		if(country_name == null) {
			country_name = "";
		}
		
		String country_full_image = realPath+"activities/WorldCup/"+country_image;
		
		try {
			BufferedImage country_bufferedImage = ImageIO.read(new File(country_full_image));
			
			int image_width = 50;
			int image_height = 35;
			
			int position_x = 0;
			int position_y = 0;
			
			if("group_a_16".equals(data_class)) {
				position_x = 155;
				position_y = 214;
			}else 	if("group_c_16".equals(data_class)) {
				position_x = 155;
				position_y = 414;
			}else 	if("group_e_16".equals(data_class)) {
				position_x = 155;
				position_y = 617;
			}else 	if("group_g_16".equals(data_class)) {
				position_x = 155;
				position_y = 819;
			}
			
			if("group_b_16".equals(data_class)) {
				position_x = 548;
				position_y = 214;
			}else 	if("group_d_16".equals(data_class)) {
				position_x = 548;
				position_y = 416;
			}else 	if("group_f_16".equals(data_class)) {
				position_x = 548;
				position_y = 616;
			}else 	if("group_h_16".equals(data_class)) {
				position_x = 548;
				position_y = 820;
			}
			
			
			if("group_a_8".equals(data_class)) {
				position_x = 252;
				position_y = 314;
			}else 	if("group_e_8".equals(data_class)) {
				position_x = 252;
				position_y = 716;
			}else 	if("group_b_8".equals(data_class)) {
				position_x = 458;
				position_y = 314;
			}else 	if("group_f_8".equals(data_class)) {
				position_x = 458;
				position_y = 716;
			}
			
			if("group_a_4".equals(data_class)) {
				position_x = 308;
				position_y = 512;
			}else 	if("group_b_4".equals(data_class)) {
				position_x = 409;
				position_y = 512;
			}
			
			if("group_a_2".equals(data_class)) {
				position_x = 344;
				position_y = 361;
				
				image_width = 82; 
				image_height = 57;
			}
			
			BufferedImage scaledBufferedImage = ImageUtil.scaledBufferedImage(country_bufferedImage, image_width	, image_height);
			
			BufferedImage synthesisBufferedImage = ImageUtil.synthesisBufferedImage(bufferedImage_base, scaledBufferedImage,position_x,position_y);
			
			Graphics graphics = synthesisBufferedImage.getGraphics();
			
			int font_size = 14;
			
			int left = (image_width - font_size*country_name.length())/2; 
			
			
			Font font_tmp = new Font("微软雅黑",Font.PLAIN , font_size);
			graphics.setFont(font_tmp);
			graphics.drawString(country_name, position_x+left, position_y+image_height+font_size);
			
			return synthesisBufferedImage;
		} catch (IOException e) {
			logger.error("图生成失败!", e);
		}
		
		
		return bufferedImage_base;
	}

	
	public static final String worldCupForecast_rule_key = "worldCupForecast_rule_media_id";
 
}
