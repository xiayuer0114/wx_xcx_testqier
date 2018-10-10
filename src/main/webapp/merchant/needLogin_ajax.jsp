<%@page import="com.google.gson.JsonObject"%><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%
JsonObject jo = new JsonObject();
jo.addProperty("statusCode", "301");
jo.addProperty("message","亲,请先登录哦！");
out.print(jo);
%>