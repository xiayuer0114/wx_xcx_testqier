<%@page import="com.lymava.nosql.util.QuerySort"%>
<%@page import="com.lymava.qier.model.TradeRecord72"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.qier.model.User72"%>
<%@page import="com.lymava.qier.action.CashierAction"%>
<%@page import="com.lymava.wechat.gongzhonghao.SubscribeUser"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.base.model.User"%>
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
<%@ page import="com.lymava.base.model.PubConlumn" %>
<%@ page import="com.lymava.qier.model.xiaoChengXuModel.CityPub" %>
<%@ page import="com.lymava.qier.model.xiaoChengXuModel.ConfigPub" %>
<%@ page import="com.lymava.qier.model.xiaoChengXuModel.ShowPub" %>
<%@ page import="com.lymava.qier.model.xiaoChengXuModel.LinkPub" %>
<%@ page import="java.io.*" %>
<%@ page import="com.lymava.commons.exception.CheckException" %>
<%@ page import="com.lymava.qier.util.WeiHtmlProcess" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%!
	public String process_href(String content_update,String replace_to){
		if(content_update == null){
			return content_update;
		}
		content_update = content_update.replaceAll("http://114.115.184.214:7210/", replace_to);
		return content_update;
	}
%>
<%
	String  basePath = MyUtil.getBasePath(request);
	CheckException.checkIsTure( !MyUtil.isEmpty(basePath), "basePath is null" );


	String path_wenjianjia = request.getRealPath("/beifei/beifei_ConfigPub");

	File file_ConfigPub = new File(path_wenjianjia);
	String[] fileNames_ConfigPub = file_ConfigPub.list();

	for (String fileName : fileNames_ConfigPub){

	    String filePath = request.getRealPath("/beifei/beifei_ConfigPub")+"/"+fileName;

		ObjectInputStream objectInputStream = new ObjectInputStream(new FileInputStream(filePath));

		ConfigPub object = (ConfigPub)objectInputStream.readObject();

		if(object != null && MyUtil.isValid(object.getId())){

			ConfigPub object_find = (ConfigPub)ContextUtil.getSerializContext().get(ConfigPub.class, object.getId());


			String content_update = WeiHtmlProcess.process_replace_img_src(object.getContent(), basePath);
			object.setContent(content_update);

			if (object_find != null){
				ContextUtil.getSerializContext().updateObject(object.getId(), object);
			}else {
				ContextUtil.getSerializContext().save(object);
			}


		}
		objectInputStream.close();
	}












	path_wenjianjia = request.getRealPath("/beifei/beifei_PubConlumn");

	File file_PubConlumn = new File(path_wenjianjia);
	String[] fileNames_PubConlumn = file_PubConlumn.list();

	for (String fileName : fileNames_PubConlumn){

		String filePath = request.getRealPath("/beifei/beifei_PubConlumn")+"/"+fileName;

		ObjectInputStream objectInputStream = new ObjectInputStream(new FileInputStream(filePath));

		PubConlumn  object = (PubConlumn )objectInputStream.readObject();

		if(object != null && MyUtil.isValid(object.getId())){

			PubConlumn  object_find = (PubConlumn )ContextUtil.getSerializContext().get(PubConlumn.class, object.getId());
			
			String content_update = process_href(object.getContent(),MyUtil.getBasePath(request));
			object.setContent(content_update);

			if (object_find != null){
				ContextUtil.getSerializContext().updateObject(object.getId(), object);
			}else {
				ContextUtil.getSerializContext().save(object);
			}


		}
		objectInputStream.close();
	}










	path_wenjianjia = request.getRealPath("/beifei/beifei_ShowPub");

	File file_ShowPub = new File(path_wenjianjia);
	String[] fileNames_ShowPub= file_ShowPub.list();

	for (String fileName : fileNames_ShowPub){

		String filePath = request.getRealPath("/beifei/beifei_ShowPub")+"/"+fileName;

		ObjectInputStream objectInputStream = new ObjectInputStream(new FileInputStream(filePath));

		ShowPub  object = (ShowPub )objectInputStream.readObject();

		if(object != null && MyUtil.isValid(object.getId())){

			ShowPub  object_find = (ShowPub )ContextUtil.getSerializContext().get(ShowPub.class, object.getId());

			String content_update = process_href(object.getContent(),MyUtil.getBasePath(request));
			object.setContent(content_update);

			if (object_find != null){
				ContextUtil.getSerializContext().updateObject(object.getId(), object);
			}else {
				ContextUtil.getSerializContext().save(object);
			}


		}
		objectInputStream.close();
	}


















	path_wenjianjia = request.getRealPath("/beifei/beifei_LinkPub");

	File file_LinkPub = new File(path_wenjianjia);
	String[] fileNames_LinkPub = file_LinkPub.list();

	for (String fileName : fileNames_LinkPub){

		String filePath = request.getRealPath("/beifei/beifei_LinkPub")+"/"+fileName;

		ObjectInputStream objectInputStream = new ObjectInputStream(new FileInputStream(filePath));

		LinkPub  object = (LinkPub)objectInputStream.readObject();

		if(object != null && MyUtil.isValid(object.getId())){

			LinkPub  object_find = (LinkPub )ContextUtil.getSerializContext().get(LinkPub.class, object.getId());

			String content_update = process_href(object.getContent(),MyUtil.getBasePath(request));
			object.setContent(content_update);

			if (object_find != null){
				ContextUtil.getSerializContext().updateObject(object.getId(), object);
			}else {
				ContextUtil.getSerializContext().save(object);
			}


		}
		objectInputStream.close();
	}


%>