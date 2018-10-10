<%@ page import="com.google.gson.JsonArray" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.lymava.commons.util.MyUtil" %>
<%@ page import="com.lymava.qier.model.Merchant72" %>
<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="com.lymava.commons.util.Md5Util" %>
<%@ page import="com.mongodb.BasicDBList" %>
<%@ page import="com.lymava.commons.exception.CheckException" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String sign = request.getParameter("sign");
    String openId = request.getParameter("openId");
    String merchantId = request.getParameter("merchantId");
    String caozuo = request.getParameter("caozuo");

    // 数据校验
    CheckException.checkIsTure(!MyUtil.isEmpty(sign),"操作'标签'不正确 (sign is null)");
    CheckException.checkIsTure(!MyUtil.isEmpty(openId),"用户标识不正确  (openid)");
    CheckException.checkIsTure(MyUtil.isValid(merchantId),"商家标识不正确  (merchantId)");

    Boolean check_caozuo = MyUtil.isEmpty(caozuo) || !("bind".equals(caozuo)||"unbind".equals(caozuo));
    CheckException.checkIsTure(!check_caozuo,"操作标识不正确  (caozuo)");


    // 数据校验
    Merchant72 merchant72_find  = (Merchant72)ContextUtil.getSerializContext().get(Merchant72.class,merchantId);
    String sign_panduan = Md5Util.MD5Normal(openId+ merchantId + merchant72_find.getKey());

    CheckException.checkIsTure(sign_panduan.equals(sign),"操作'标签'不正确 (sign is error) ");

    // 操作处理
    BasicDBList openid_list =  merchant72_find.getNotify_openid_list();
    openid_list = openid_list == null?new BasicDBList():openid_list;

    if("bind".equals(caozuo)){
        openid_list.remove(openId);
        openid_list.add(openId);
    }
    if("unbind".equals(caozuo)){
        openid_list.remove(openId);
    }

    // 更新
    Merchant72 merchant72_update = new Merchant72();
    merchant72_update.setNotify_openid_list(openid_list);

    ContextUtil.getSerializContext().updateObject(merchant72_find.getId(), merchant72_update);

    // 设置返回数据
    JsonObject jsonObject = new JsonObject();
    jsonObject.addProperty("statusCode","200");
    jsonObject.addProperty("message","操作成功");
    out.print(jsonObject);
    return;
%>