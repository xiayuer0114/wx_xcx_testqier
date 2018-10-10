<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.ObjectInputStream"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.ObjectOutputStream"%>
<%@page import="com.lymava.qier.model.TradeRecord72"%>
<%@page import="com.lymava.qier.util.PrintUtil"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.trade.business.model.TradeRecord"%>
<%@page import="java.util.List"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.PubConlumn"%>
<%@page import="com.lymava.base.model.Pub"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.lymava.wechat.opendevelop.DevelopAccount"%>
<%@page import="com.lymava.wechat.gongzhonghao.GongzonghaoContent"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<%

	ObjectInputStream objectInputStream = new ObjectInputStream(new FileInputStream("/home/lymava/edit_email"));

	Pub pub_read = (Pub)objectInputStream.readObject();
	System.out.println("pub_read:"+pub_read.getId());
	objectInputStream.close(); 


	Pub pub = Pub.getPub("5b6d6cd1d6c4593d57698457");

	ObjectOutputStream objectOutputStream = new ObjectOutputStream(new FileOutputStream("/home/lymava/edit_email"));

	objectOutputStream.writeObject(pub);
	objectOutputStream.flush();
	objectOutputStream.close();
%>