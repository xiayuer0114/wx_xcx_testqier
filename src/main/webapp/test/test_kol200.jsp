<%@page import="java.awt.Font"%>
<%@page import="java.awt.Color"%>
<%@page import="java.awt.Graphics"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.File"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="com.lymava.commons.util.ImageUtil"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="com.lymava.commons.util.QrCodeUtil"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.lymava.commons.util.JsonUtil"%>
<%@page import="com.lymava.qier.activities.sharebusiness.KOL200ShareBusiness"%>
<%@page import="com.lymava.qier.activities.sharebusiness.NazhongrenShareBusiness"%>
<%@page import="com.lymava.qier.activities.sharebusiness.LiuyibaShareBusiness"%>
<%@page import="com.lymava.qier.sharebusiness.GaosanShareBusiness"%>
<%@page import="com.lymava.qier.sharebusiness.QierGongzonghaoShareBusinessDefault"%>
<%@page import="com.lymava.wechat.gongzhonghao.sharebusiness.GongzonghaoShareBusiness"%>
<%@page import="com.lymava.wechat.gongzhonghao.GongzonghaoContent"%>
<%@page import="com.lymava.wechat.gongzhonghao.Gongzonghao"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.mongodb.DBObject"%>
<%@page import="com.mongodb.BasicDBObject"%>
<%@page import="com.lymava.nosql.mongodb.util.MongoCommand"%>
<%@page import="com.lymava.qier.model.Voucher"%>
<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.commons.util.HexM"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.qier.model.UserVoucher"%>
<%@page import="com.lymava.commons.pay.PayFinalVariable"%>
<%@page import="com.lymava.commons.util.MathUtil"%>
<%@page import="com.lymava.trade.business.model.Product"%>
<%@ page import="com.lymava.qier.model.Merchant72" %>
<%@ page import="com.lymava.qier.model.Product72" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%  
	int create_size = 200;
	int start_index = 10;
	
	BufferedImage bufferedImage_base = ImageIO.read(new File("/home/lymava/workhome/program/罗彪项目/营销活动/kol200/kol200_base.jpg"));

	for(int i=start_index;i<start_index+create_size;i++){
		
		Gongzonghao defaultGongzonghao = GongzonghaoContent.getMorenGongzonghao();
		
		KOL200ShareBusiness kol200ShareBusiness = new KOL200ShareBusiness();
		kol200ShareBusiness.setDataId(i+"");
		
		try {
			
			String create_qrcode = defaultGongzonghao.create_qrcode(kol200ShareBusiness);
			
			JsonObject jsonObject = JsonUtil.parseJsonObject(create_qrcode);
			
			String url = JsonUtil.getString(jsonObject, "url");
			
			
			BufferedImage createQrBufferedImage = QrCodeUtil.createQrBufferedImage(url, 146);
			
			BufferedImage bufferedImage_new = ImageUtil.synthesisBufferedImage(bufferedImage_base, createQrBufferedImage, 300, 908);
			
			Graphics graphics = bufferedImage_new.getGraphics();
			
			Font font = new Font("微软雅黑",Font.PLAIN,18);
			
			graphics.setFont(font);
			graphics.setColor(Color.WHITE);
			graphics.drawString(i+"", 580, 1310);
			graphics.dispose();
			
			String file_name = "/home/lymava/workhome/program/罗彪项目/营销活动/kol200/kol100-200/"+i+".jpg";
			
			ImageUtil.write(bufferedImage_new, new FileOutputStream(file_name));
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	
%>