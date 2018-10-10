<%@page import="java.awt.Color"%>
<%@page import="java.awt.Font"%>
<%@page import="java.awt.Graphics"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="com.lymava.commons.util.ImageUtil"%>
<%@page import="java.net.URL"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="java.io.File"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>
<%
	String realPath =  application.getRealPath("/");
	
	
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
	
	Font font = new Font("微软雅黑",Font.PLAIN,68);
	graphics.setColor(Color.WHITE);
	graphics.setFont(new Font("微软雅黑",Font.BOLD,68));
	
	int font_size = 68;
	 
	int left = (font_size*nickname.getBytes().length)/4;  
	
	Font font_tmp = new Font("微软雅黑",Font.BOLD , font_size);
	graphics.setFont(font_tmp);
	
	int strWidth = graphics.getFontMetrics().stringWidth(nickname);
	graphics.drawString(nickname, 734 - strWidth / 2, 698); 
	graphics.dispose();
	
	
	ByteArrayOutputStream baos = new ByteArrayOutputStream();
	ImageUtil.write(bufferedImage_base_img, baos);
	
	String temp_path = MyUtil.savePic(baos.toByteArray(), realPath);
	
	request.setAttribute("subscribeUser", subscribeUser);
	request.setAttribute("temp_path", temp_path);
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>618-嗨翻天</title>
		<link rel="stylesheet" type="text/css" href="css/online.css"/>
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <meta content="yes" name="apple-mobile-web-app-capable">
	    <meta content="telephone=no,email=no" name="format-detection">
	    <meta content="yes" name="apple-touch-fullscreen">
	    <meta http-equiv="X-UA-Compatible" content="ie=edge">
	    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" /><!-- 屏蔽双击缩放 -->
	</head>
	<body style="background: url(img/bg3.jpg) no-repeat; width:100%;background-size:100% 100%;">
		<div class="online3_14_ph" style="height:95vh;width:95%;margin: 1rem auto;">
			 	<img alt="" src="${basePath}${temp_path}" style="width: 100%;">
		</div> 
	</body>
</html>
