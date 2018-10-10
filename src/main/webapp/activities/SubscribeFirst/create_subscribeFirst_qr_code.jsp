<%@page import="com.lymava.commons.state.StatusCode"%>
<%@page import="com.lymava.commons.exception.CheckException"%>
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

	String price_yuan_str = request.getParameter("price_yuan");
	String product_id = request.getParameter("product_id");
	String orderId = request.getParameter("orderId");
	
	Double price_yuan_double = MathUtil.parseDoubleNull(price_yuan_str);
	
	Product72 product72 = null;
	if(MyUtil.isValid(product_id)){
		product72 = (Product72)ContextUtil.getSerializContext().get(Product72.class, product_id);
	}
	
	CheckException.checkIsTure(product72 != null, "产品编号不能为空!");
	CheckException.checkIsTure(price_yuan_double != null  && price_yuan_double > 0, "买单金额不能为空!");
	
	
	session.setAttribute("price_yuan", price_yuan_str);
	session.setAttribute("product_id", product_id);
	session.setAttribute("orderId", orderId);
	
	Gongzonghao defaultGongzonghao = GongzonghaoContent.getMorenGongzonghao();
	
	SubscribeFirstRedEnvelopeShareBusiness subscribeFirstRedEnvelopeShareBusiness = new SubscribeFirstRedEnvelopeShareBusiness();
	subscribeFirstRedEnvelopeShareBusiness.setDataId(product_id);

	JsonObject jsonObject = new JsonObject();
	
	try {
		
		String create_qrcode = defaultGongzonghao.create_qrcode(subscribeFirstRedEnvelopeShareBusiness);
		
		JsonObject jsonObject_root = JsonUtil.parseJsonObject(create_qrcode);
		
		String url= JsonUtil.getString(jsonObject_root, "url");
		String ticket= JsonUtil.getString(jsonObject_root, "ticket");
		 //49 331
		BufferedImage bufferedImage_qrcode =  QrCodeUtil.createQrBufferedImage(url, 265);
		 
		BufferedImage bufferedImage_base_image =  ImageIO.read(SubscribeFirstRedEnvelopeShareBusiness.class.getResourceAsStream("/com/lymava/qier/activities/image/lijian3.8.jpg"));
		BufferedImage bufferedImage_base_final = ImageUtil.synthesisBufferedImage(bufferedImage_base_image, bufferedImage_qrcode, 49, 315);
		
		ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
		ImageUtil.write(bufferedImage_base_final, byteArrayOutputStream);
		
		String pic_path_tmp = MyUtil.savePic(byteArrayOutputStream.toByteArray(), application.getRealPath("/"));
		
		String basePath = MyUtil.getBasePath(request);
		
		String html = "<img style=\"width: 100%;padding: 0rem;margin: 0rem;\" src=\""+basePath+pic_path_tmp+"\" />";
		
		JsonUtil.addProperty(jsonObject,"html",html);
		JsonUtil.addProperty(jsonObject,StatusCode.statusCode_key,StatusCode.ACCEPT_OK);
	} catch (Exception e) {
		log("首次关注创建二维码失败!", e);
		JsonUtil.addProperty(jsonObject,StatusCode.statusCode_key,StatusCode.ACCEPT_FALSE);
	}
	out.print(jsonObject);
%>
