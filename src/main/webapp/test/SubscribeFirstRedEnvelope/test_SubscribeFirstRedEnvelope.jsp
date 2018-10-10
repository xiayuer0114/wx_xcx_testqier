<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.commons.util.ImageUtil"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="com.lymava.commons.util.QrCodeUtil"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.lymava.commons.util.JsonUtil"%>
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
<%@ page import="com.lymava.qier.activities.sharebusiness.SubscribeFirstRedEnvelopeShareBusiness" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%  
	
	Gongzonghao defaultGongzonghao = GongzonghaoContent.getMorenGongzonghao();
	
	SubscribeFirstRedEnvelopeShareBusiness subscribeFirstRedEnvelopeShareBusiness = new SubscribeFirstRedEnvelopeShareBusiness();

	
	try {
		
		String create_qrcode = defaultGongzonghao.create_qrcode(subscribeFirstRedEnvelopeShareBusiness);
		
		JsonObject jsonObject_root = JsonUtil.parseJsonObject(create_qrcode);
		
		String url= JsonUtil.getString(jsonObject_root, "url");
		String ticket= JsonUtil.getString(jsonObject_root, "ticket");
		 //49 331
		BufferedImage bufferedImage_qrcode =  QrCodeUtil.createQrBufferedImage(url, 265);
		 
		BufferedImage bufferedImage_base_image =  ImageIO.read(SubscribeFirstRedEnvelopeShareBusiness.class.getResourceAsStream("/com/lymava/qier/activities/image/lijian8.88.jpg"));
		BufferedImage bufferedImage_base_final = ImageUtil.synthesisBufferedImage(bufferedImage_base_image, bufferedImage_qrcode, 49, 331);
		
		ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
		ImageUtil.write(bufferedImage_base_final, byteArrayOutputStream);
		
		String pic_path_tmp = MyUtil.savePic(byteArrayOutputStream.toByteArray(), application.getRealPath("/"));
		
		request.setAttribute("pic_path_tmp", pic_path_tmp);
		request.setAttribute("basePath", MyUtil.getBasePath(request));
	} catch (Exception e) {
		e.printStackTrace();
	}
%>

<img style="width: 100%;padding: 0rem;margin: 0rem;" src="${basePath }${pic_path_tmp }" />
<img style="width: 80%;padding: 0;margin: 0rem;" src="${basePath }${pic_path_tmp }" />
style: 'padding: 0;width: 80%;'



