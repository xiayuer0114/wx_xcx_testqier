<%@page import="com.lymava.qier.sharebusiness.QierGongzonghaoShareBusinessDefault"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%
    
    String openid = "o3gi9v0tOiS819RkSKZW97mpmNFQ";

    QierGongzonghaoShareBusinessDefault qierGongzonghaoShareBusinessDefault = new QierGongzonghaoShareBusinessDefault(); 
    
    qierGongzonghaoShareBusinessDefault.check_traderecord72_notify_huiyuan(openid);
    
    
%>