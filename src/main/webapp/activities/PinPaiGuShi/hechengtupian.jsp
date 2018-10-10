<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="java.io.File" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="com.lymava.commons.util.ImageUtil" %>
<%@ page import="java.awt.*" %>
<%@ page import="com.lymava.commons.util.QrCodeUtil" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="com.lymava.commons.util.MyUtil" %>
<%@ page import="org.apache.struts2.ServletActionContext" %>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018\9\20 0020
  Time: 15:29
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%

	String mingzi=request.getParameter("mingzi");
	String chenghu=request.getParameter("chenghu");

	mingzi=new String(mingzi.getBytes("iso-8859-1"),"utf-8");
	chenghu=new String(chenghu.getBytes("iso-8859-1"),"utf-8");
	String nn =  request.getSession().getServletContext().getRealPath("/activities/PinPaiGuShi/img/haibao.jpg");

	File file=new File(nn);
	BufferedImage bufferedImage= ImageIO.read(file);
	Font font=new Font("微软雅黑",Font.PLAIN,75);
	Graphics graphics = bufferedImage.getGraphics();
	graphics.setColor(Color.GRAY);
	graphics.setFont(font);
	graphics.drawString(mingzi, 568, 1560);
	graphics.dispose();
	Graphics graphics1 = bufferedImage.getGraphics();
	graphics1.setColor(Color.GRAY);
	graphics1.setFont(font);
	graphics1.drawString(chenghu, 568, 1730);
	graphics1.dispose();

	ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
	ImageUtil.write(bufferedImage,byteArrayOutputStream);
	String realPath = application.getRealPath("/");
	String temp_pic_path = MyUtil.savePic(byteArrayOutputStream.toByteArray(),realPath);

	request.setAttribute("temp_pic_path",temp_pic_path);
%>
<body >
			<img src="${basePath}${temp_pic_path}" style="width: 100%;height: 100%" >

			<div class="layer" style="position: absolute; font-size: 1.33rem;left:43%;top:79.5%">点击长按保存</div>

</body>
