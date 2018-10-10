package com.lymava.qier.gaosan;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URL;
import java.util.Random;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.lymava.base.model.Pub;
import com.lymava.base.model.PubConlumn;
import com.lymava.commons.util.ImageUtil;
import com.lymava.qier.gaosan.model.GaosanResult;

public class GaosanImageUtil {

	public static void main(String[] args) throws FileNotFoundException, IOException {
		 
		URL resource = GaosanImageUtil.class.getResource("/");
		
		System.out.println(resource);
		
	}
	
	public static String chutu_path(GaosanResult gaosanResult,String basePath) {
		
		PubConlumn pubConlumn = gaosanResult.getPubConlumn();
		
		Pub pub_link = gaosanResult.getPub_link();
		
		String background_image = basePath+"gaosan/template_image/bg_background.jpg";
		
		String xuexiao_image = basePath+ pub_link.getPic();
		
		String wenzi_image = basePath+ pubConlumn.getPic();
		
		String erweima_image = basePath+"gaosan/template_image/erweima.jpg";
		
		String name = gaosanResult.getName();
		String xuexiao_str = "你可以考上"+pub_link.getName();
		
		BufferedImage back_ground_bufferedImage = ImageUtil.readBufferedImage(background_image);
		
		BufferedImage xuexiao_bufferedImage = ImageUtil.readBufferedImage(xuexiao_image);
		
		BufferedImage wenzi_bufferedImage = ImageUtil.readBufferedImage(wenzi_image);
		
		BufferedImage erweima_bufferedImage = ImageUtil.readBufferedImage(erweima_image);
		
		back_ground_bufferedImage = ImageUtil.synthesisBufferedImage(back_ground_bufferedImage, xuexiao_bufferedImage,292,636);
		
		back_ground_bufferedImage = ImageUtil.synthesisBufferedImage(back_ground_bufferedImage, wenzi_bufferedImage,336,1867);
		
		back_ground_bufferedImage = ImageUtil.synthesisBufferedImage(back_ground_bufferedImage, erweima_bufferedImage,160,2159);
		
		Graphics graphics = back_ground_bufferedImage.getGraphics();
		
		int width = back_ground_bufferedImage.getWidth();
		int height = back_ground_bufferedImage.getHeight();
		
		int font_size = 80;
		
		Font font = new Font("微软雅黑", Font.BOLD, font_size);
		
		graphics.setColor(new Color(0xeed5bc));
		graphics.setFont(font);
		
		graphics.drawString(xuexiao_str, width/2-xuexiao_str.length()*font_size/2, 502+font_size);
		graphics.drawString(name, width/2-+name.length()*font_size/2, 394+font_size);
		
		String result_path = "gaosan/image_tmp/"+gaosanResult.getId()+".jpg";
		
		back_ground_bufferedImage = ImageUtil.getScaledBufferedImage(back_ground_bufferedImage, width/2, height/2);
		
		try {
			ImageUtil.write(back_ground_bufferedImage, new FileOutputStream(basePath+result_path));
		} catch (Exception e) {
			 LogFactory.getLog(GaosanImageUtil.class).error("出图失败",e);
		}
		
		return result_path;
	}
	
	public static ByteArrayOutputStream chutu(GaosanResult gaosanResult,String basePath) {
		
		PubConlumn pubConlumn = gaosanResult.getPubConlumn();
		
		Pub pub_link = gaosanResult.getPub_link();
		
		String background_image = basePath+"gaosan/template_image/bg_background.jpg";
		
		String xuexiao_image = basePath+ pub_link.getPic();
		
		String wenzi_image = basePath+ pubConlumn.getPic();
		
		String erweima_image = basePath+"gaosan/template_image/erweima.jpg";
		
		String name = gaosanResult.getName();
		String xuexiao_str = "你可以考上"+pub_link.getName();
		
		BufferedImage back_ground_bufferedImage = ImageUtil.readBufferedImage(background_image);
		
		BufferedImage xuexiao_bufferedImage = ImageUtil.readBufferedImage(xuexiao_image);
		
		BufferedImage wenzi_bufferedImage = ImageUtil.readBufferedImage(wenzi_image);
		
		BufferedImage erweima_bufferedImage = ImageUtil.readBufferedImage(erweima_image);
		
		back_ground_bufferedImage = ImageUtil.synthesisBufferedImage(back_ground_bufferedImage, xuexiao_bufferedImage,292,636);
		
		back_ground_bufferedImage = ImageUtil.synthesisBufferedImage(back_ground_bufferedImage, wenzi_bufferedImage,336,1867);
		
		back_ground_bufferedImage = ImageUtil.synthesisBufferedImage(back_ground_bufferedImage, erweima_bufferedImage,160,2159);
		
		Graphics graphics = back_ground_bufferedImage.getGraphics();
		
		int width = back_ground_bufferedImage.getWidth();
		
		int font_size = 80;
		
		Font font = new Font("微软雅黑", Font.BOLD, font_size);
		
		graphics.setColor(new Color(0xeed5bc));
		graphics.setFont(font);
		
		graphics.drawString(xuexiao_str, width/2-xuexiao_str.length()*font_size/2, 502+font_size);
		graphics.drawString(name, width/2-+name.length()*font_size/2, 394+font_size);
		
		String result_path = "gaosan/image_tmp/"+gaosanResult.getId();
		
		ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
		
		try {
			ImageUtil.write(back_ground_bufferedImage, byteArrayOutputStream);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return byteArrayOutputStream;
	}
}
