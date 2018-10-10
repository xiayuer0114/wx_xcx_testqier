<%@ page import="java.io.File" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="java.awt.*" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="com.lymava.commons.util.ImageUtil" %>
<%@ page import="com.lymava.commons.util.MyUtil" %>
<%@ page import="java.awt.font.TextAttribute" %>
<%@ page import="java.util.HashMap" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>

<html>
<%
	String you_name=request.getParameter("you_name");
	String nn =  request.getSession().getServletContext().getRealPath("/activities/national_day_3_chengdu/img/poster5.jpg");

	int p_x=(750-you_name.length()*40)/2;

	File file=new File(nn);
	BufferedImage bufferedImage= ImageIO.read(file);
//	Font font=new Font("微软雅黑",Font.PLAIN,40);

	HashMap<TextAttribute, Object> hm = new HashMap<TextAttribute, Object>();
	hm.put(TextAttribute.UNDERLINE, TextAttribute.UNDERLINE_ON); // 定义是否有下划线
	hm.put(TextAttribute.SIZE, 40); // 定义字号
	hm.put(TextAttribute.FAMILY, "微软雅黑"); // 定义字体名
	Font font = new Font(hm);

	Graphics graphics = bufferedImage.getGraphics();

	graphics.setColor(Color.BLACK);
	graphics.setFont(font);
	graphics.drawString(you_name, p_x, 118);
	graphics.dispose();

	ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
	ImageUtil.write(bufferedImage,byteArrayOutputStream);
	String realPath = application.getRealPath("/");
	String temp_pic_path = MyUtil.savePic(byteArrayOutputStream.toByteArray(),realPath);

	request.setAttribute("temp_pic_path",temp_pic_path);
%>
	<head>
		<meta charset="utf-8" />
		<title>国庆游戏-生成_弹窗</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <meta content="yes" name="apple-mobile-web-app-capable">
	    <meta content="telephone=no,email=no" name="format-detection">
	    <meta content="yes" name="apple-touch-fullscreen">
	    <meta http-equiv="X-UA-Compatible" content="ie=edge">
	    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" /><!-- 屏蔽双击缩放 -->
	    <script src="js/mui.min.js"></script>
	    <link href="css/mui.min.css" rel="stylesheet"/>
	    <link rel="stylesheet" type="text/css" href="css/n_d.css"/>
	    <script type="text/javascript" src="js/jquery.js" ></script>

		<script type="text/javascript">
				$(function(){
					var window_width = $(window).width();
					var rem_font_size = window_width*10/75;
					$("html").css("font-size",rem_font_size+"px");
					
						mui.init();
				});
		</script>

</head>
<body style="background-color: #FFFFFF;">
	<div class="n_d_poster mui-row">
		<img id="haibao" src="${basePath}${temp_pic_path}"/>
	</div>
</body>
</html>