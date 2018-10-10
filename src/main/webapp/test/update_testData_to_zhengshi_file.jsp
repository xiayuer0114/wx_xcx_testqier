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
<%@ page import="java.io.File" %>
<%@ page import="java.io.ObjectOutputStream" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="com.lymava.qier.model.xiaoChengXuModel.CityPub" %>
<%@ page import="com.lymava.qier.model.xiaoChengXuModel.ConfigPub" %>
<%@ page import="com.lymava.qier.model.xiaoChengXuModel.ShowPub" %>
<%@ page import="com.lymava.qier.model.xiaoChengXuModel.LinkPub" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%

	File dir = null;


	String beifei_beifei_PubConlumn = request.getRealPath("/beifei/beifei_PubConlumn");
	dir = new File(beifei_beifei_PubConlumn);
	if ( !dir.exists()) {
		dir.mkdirs();
	}

	String beifei_beifei_ConfigPub = request.getRealPath("/beifei/beifei_ConfigPub");
	dir = new File(beifei_beifei_ConfigPub);
	if ( !dir.exists()) {
		dir.mkdirs();
	}

	String beifei_beifei_ShowPub = request.getRealPath("/beifei/beifei_ShowPub");
	dir = new File(beifei_beifei_ShowPub);
	if ( !dir.exists()) {
		dir.mkdirs();
	}

	String beifei_beifei_LinkPub= request.getRealPath("/beifei/beifei_LinkPub");
	dir = new File(beifei_beifei_LinkPub);
	if ( !dir.exists()) {
		dir.mkdirs();
	}





	PubConlumn pubConlumn_find = new PubConlumn();
	pubConlumn_find.setRootPubConlumnId("5b5acdb3d6c45965a5c2e9bb");

	Iterator<PubConlumn> pubConlumnIterator = ContextUtil.getSerializContext().findIterable(pubConlumn_find);

	while (pubConlumnIterator.hasNext()){

		PubConlumn pubConlumn_temp = pubConlumnIterator.next();

		String path = request.getRealPath("/beifei/beifei_PubConlumn/"+pubConlumn_temp.getId());

		File file = new File(path);
		try {

		    if(file.exists()){ file.delete(); }

			if(!file.exists()){ file.createNewFile(); }

		} catch (Exception e) { e.printStackTrace(); }


		ObjectOutputStream objectOutputStream = new ObjectOutputStream(new FileOutputStream(path));

		objectOutputStream.writeObject(pubConlumn_temp);

		objectOutputStream.flush();
		objectOutputStream.close();
	}














	ConfigPub configPub_find = new ConfigPub();
	configPub_find.setSecondPubConlumnId(ConfigPub.getXiaochengxupeizhi());

	Iterator<ConfigPub> configPubIterator = ContextUtil.getSerializContext().findIterable(configPub_find);

	while (configPubIterator.hasNext()){

		ConfigPub configPub_temp = configPubIterator.next();

		String path = request.getRealPath("/beifei/beifei_ConfigPub/"+configPub_temp.getId());

		File file = new File(path);
		try {

			if(file.exists()){ file.delete(); }

			if(!file.exists()){ file.createNewFile(); }

		} catch (Exception e) { e.printStackTrace(); }


		ObjectOutputStream objectOutputStream = new ObjectOutputStream(new FileOutputStream(path));

		objectOutputStream.writeObject(configPub_temp);

		objectOutputStream.flush();
		objectOutputStream.close();
	}




	ShowPub showPub_find = new ShowPub();
	showPub_find.addCommand(MongoCommand.or, "secondPubConlumnId", ConfigPub.getZhuanti());
	showPub_find.addCommand(MongoCommand.or, "secondPubConlumnId", ConfigPub.getQuyu());
	showPub_find.addCommand(MongoCommand.or, "secondPubConlumnId", ConfigPub.getLeixingpeizhi());

	PageSplit pageSplit = new PageSplit(1,500);

	Iterator<ShowPub> showPub_findIterator = ContextUtil.getSerializContext().findIterable(showPub_find,pageSplit);

	out.println(pageSplit.getCount());

	while (showPub_findIterator.hasNext()){

		ShowPub showPub_temp = showPub_findIterator.next();

		String path = request.getRealPath("/beifei/beifei_ShowPub/"+showPub_temp.getId());

		File file = new File(path);
		try {

			if(file.exists()){ file.delete(); }

			if(!file.exists()){ file.createNewFile(); }

		} catch (Exception e) { e.printStackTrace(); }


		ObjectOutputStream objectOutputStream = new ObjectOutputStream(new FileOutputStream(path));

		objectOutputStream.writeObject(showPub_temp);

		objectOutputStream.flush();
		objectOutputStream.close();
	}









	LinkPub linkPub_find = new LinkPub();
	linkPub_find.setSecondPubConlumnId(ConfigPub.getTuijianka());

	Iterator<LinkPub> linkPub_findIterator = ContextUtil.getSerializContext().findIterable(linkPub_find);

	while (linkPub_findIterator.hasNext()){

		LinkPub linkPub_temp = linkPub_findIterator.next();

		String path = request.getRealPath("/beifei/beifei_LinkPub/"+linkPub_temp.getId());

		File file = new File(path);
		try {

			if(file.exists()){ file.delete(); }

			if(!file.exists()){ file.createNewFile(); }

		} catch (Exception e) { e.printStackTrace(); }


		ObjectOutputStream objectOutputStream = new ObjectOutputStream(new FileOutputStream(path));

		objectOutputStream.writeObject(linkPub_temp);

		objectOutputStream.flush();
		objectOutputStream.close();
	}




//	ObjectInputStream objectInputStream = new ObjectInputStream(new FileInputStream(path));
//
//	PubConlumn pub_read = (PubConlumn)objectInputStream.readObject();
//
//	if(pub_read != null){
//		System.out.println(pub_read);
//	}
//
//	objectInputStream.close();
	 
%>