<%--
	生成海报
 --%>

<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="com.lymava.commons.util.*" %>
<%@ page import="com.lymava.commons.exception.CheckException" %>
<%@ page import="com.lymava.nosql.util.PageSplit" %>
<%@ page import="com.lymava.qier.activities.caididian.Didian" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.awt.*" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.File" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 初始化微信 --%>
<%
	request.setAttribute("scope_snsapi", Gongzonghao.scope_snsapi_userinfo);

	request.removeAttribute("openid");
	session.removeAttribute("openid");
%>
<%@ include file="/header/check_openid.jsp"%>
<%@ include file="/header/header_check_login.jsp"%>
<%-- 业务逻辑 --%>
<%
	//x:400 y:1163 w:68 h:68
	try {
		String current_page = request.getParameter("page");
		CheckException.checkNotEmpty(current_page, "未找到指定老地点图片");

		String qrCodeUrl = MyUtil.getBasePath(request) + "activities/caididian/action_getPageAndDeal.jsp?page=" + current_page;
		BufferedImage bufferedImage_base = ImageIO.read(this.getClass().getResourceAsStream("/../../activities/caididian/img/poster.jpg"));//主图片

		BufferedImage qrBufferedImage = QrCodeUtil.createQrBufferedImage(qrCodeUrl, 134);//二维码图片
		qrBufferedImage = ImageUtil.scaledBufferedImage(qrBufferedImage, 68, 68);

		//构造分页Bean
		PageSplit pageSplit_tmp = new PageSplit(current_page, "1");
		Didian didian_find = new Didian();
		List<Didian> didian_list = serializContext.findAll(didian_find, pageSplit_tmp);
		Didian diadian_currnet = didian_list.get(0);
		CheckException.checkNotNull(diadian_currnet, "未找到指定老地点图片");
		BufferedImage didianBufferedImage =//老地点图片
				ImageIO.read(new URL(MyUtil.getBasePath(request) + diadian_currnet.getPic()));

		//合成图片
		int xText = 267, yText = 899;//文本图片XY位置
		int xDidian = 150, yDidian = 451;//老地点图片XY位置
		int xQr = 400, yQr = 1163;//qrcode图片XY位置

		String weixinName = (String) request.getAttribute("weixin_nickname");	//微信用户名
		Graphics g = bufferedImage_base.getGraphics();//用户名字体

		Font font_tmp = new Font("",Font.BOLD,35);
		g.setFont(font_tmp);

		int weixinName_width = g.getFontMetrics().stringWidth(weixinName);
		weixinName_width /= 2;
		xText = 380 - weixinName_width;


		ImageUtil.drawString(bufferedImage_base, weixinName, font_tmp, new Color(0xffa36b3a), xText, yText);

		bufferedImage_base = ImageUtil.synthesisBufferedImage(bufferedImage_base,didianBufferedImage,xDidian,yDidian);
		bufferedImage_base = ImageUtil.synthesisBufferedImage(bufferedImage_base,qrBufferedImage,xQr,yQr);

		//写入图片
		String pic_tmp_path = "/attachFiles/tmp/"+new ObjectId().toString()+".jpg";
		String pic_full_path = application.getRealPath("/")+pic_tmp_path;

		File tmp_file = new File(application.getRealPath("/")+"/attachFiles/tmp/");
		if(!tmp_file.exists()){
			tmp_file.mkdirs();
		}

		FileOutputStream fileOutputStream = new FileOutputStream(pic_full_path);
		ImageUtil.write(bufferedImage_base,fileOutputStream);

		request.setAttribute("pic_tmp_path", pic_tmp_path);

//		response.setCharacterEncoding("utf-8");
//		response.setContentType("text/html; charset=utf-8");
//		response.getOutputStream().print("<html>");
//		response.getOutputStream().flush();
//		response.getOutputStream().close();

	} catch (Exception e) {
		return;
	}
%>


<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8" />
	<title>猜地点赢红包</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta content="yes" name="apple-mobile-web-app-capable">
	<meta content="telephone=no,email=no" name="format-detection">
	<meta content="yes" name="apple-touch-fullscreen">
	<meta http-equiv="X-UA-Compatible" content="ie=edge">
	<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" />
	<link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
	<script type="text/javascript" src="${basePath }plugin/js/layer_mobile/layer.js"></script>

</head>


<body>
	<img src="${basePath}${pic_tmp_path}" style="width: 100%;">

		<script type="text/javascript" >

			function alertMsg_correct(message) {
				layer.open({
					content : message,
					skin : 'msg',
					time : 3
					// 3秒后自动关闭
				});
			}
			function alertMsg_warn(message) {
				layer.open({
					content : message,
					skin : 'msg',
					time : 3
					// 3秒后自动关闭
				});
			}
			function alertMsg_info(message) {
				layer.open({
					content : message,
					skin : 'msg',
					time : 3
					// 3秒后自动关闭
				});
			}
			function layer_loading(content){
				//loading带文字
				layer.open({
					type: 2
					,content: content
				});
			}
			function layer_loading(){
				//loading带文字
				layer.open({
					type: 2
				});
			}

			alertMsg_info("长按图片可进行保存！");
		</script>
</body>

</html>
