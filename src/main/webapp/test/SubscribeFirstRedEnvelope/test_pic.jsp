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
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.qier.model.UserVoucher"%>
<%@page import="com.lymava.commons.pay.PayFinalVariable"%>
<%@page import="com.lymava.trade.business.model.Product"%>
<%@ page import="com.lymava.qier.model.Merchant72" %>
<%@ page import="com.lymava.qier.model.Product72" %>
<%@ page import="com.lymava.qier.activities.sharebusiness.SubscribeFirstRedEnvelopeShareBusiness" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.awt.*" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.lymava.commons.util.*" %>
<%@ page import="java.io.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%

    String pic1 = "E:/idea2017/ideaWork/qier/src/main/webapp/img/lijian8.88.png";

    BufferedImage bufferedImage_base_img = ImageIO.read(new File(pic1));


    BufferedImage bufferedImage_head = QrCodeUtil.createQrBufferedImage("activities/bjdfbjkdflfkljkkfjldkjklklklllfgsdnhkjhjksdfjkdhfjkdhfjkdsgduanwu/asdnsakdsandjksadnsasdsadasldnaskldjka", 150);

    BufferedImage image  = bufferedImage_base_img;
    BufferedImage image2 = bufferedImage_head ;

    Graphics g = image.getGraphics();
//    g.drawImage(image2, image.getWidth() - image2.getWidth(), image.getHeight() - image2.getHeight() - 10,
//            image2.getWidth() , image2.getHeight(), null);

    g.drawImage(image2, 45, 310, 270, 270, null);

    ByteArrayOutputStream byteArrayOutputStream1 = new ByteArrayOutputStream();
    ImageUtil.write(bufferedImage_base_img,byteArrayOutputStream1);
    String realPath1 = application.getRealPath("/");
    String temp_pic_path1 = MyUtil.savePic(byteArrayOutputStream1.toByteArray(),realPath1);

    request.setAttribute("temp_pic_path1",temp_pic_path1);

    ByteArrayOutputStream byteArrayOutputStream2 = new ByteArrayOutputStream();
    ImageUtil.write(bufferedImage_head,byteArrayOutputStream2);
    String realPath2 = application.getRealPath("/");
    String temp_pic_path2 = MyUtil.savePic(byteArrayOutputStream2.toByteArray(),realPath2);
    request.setAttribute("temp_pic_path2",temp_pic_path2);


%>

<img src="${basePath}${temp_pic_path1}" alt=""> <br>
<img src="${basePath}${temp_pic_path2}" alt=""> <br>
