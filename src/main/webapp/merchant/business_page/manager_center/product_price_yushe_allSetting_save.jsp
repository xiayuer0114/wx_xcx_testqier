<%@page import="com.lymava.commons.cache.SimpleCache"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.qier.model.Product72"%>
<%@page import="com.lymava.commons.state.StatusCode"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.commons.util.MathUtil"%>
<%@page import="com.lymava.commons.exception.CheckException"%>
<%@page import="com.lymava.userfront.util.FrontUtil"%>
<%@page import="com.lymava.base.model.User"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Iterator" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    User front_user = FrontUtil.init_http_user(request);
    request.setAttribute("front_user", front_user);

    CheckException.checkIsTure(front_user != null, "登录超时,请重新登录!");

    // 参数获取&检测
    String product72_all_open_str = request.getParameter("product72_all_open"); // 开启
    String chushi_canweifei_str = request.getParameter("chushi_canweifei"); // 餐位费
    String canweifei_state_all_str = request.getParameter("canweifei_state_all"); // 餐位费
    
    Integer product72_all_open =  MathUtil.parseIntegerNull(product72_all_open_str);
    Double chushi_canweifei = MathUtil.parseDoubleNull(chushi_canweifei_str);
    
    if(chushi_canweifei == null){
        chushi_canweifei = 0D;
    };
    Boolean state_ok = Product72.yushe_state_kaiqi.equals(product72_all_open) || Product72.yushe_state_guanbi.equals(product72_all_open);
    CheckException.checkIsTure(state_ok, "修改状态不正确!");

    Integer canweifei_state_all = MathUtil.parseIntegerNull(canweifei_state_all_str);


    Product72 product72_find = new Product72();
    product72_find.setUserId_merchant(front_user.getId());

    Iterator<Product72> product72Iterable = ContextUtil.getSerializContext().findIterable(product72_find);

    while (product72Iterable.hasNext()){
        Product72 product72_temp =  product72Iterable.next();

        Product72 product72_update =  new Product72();
        product72_update.setYushe_state(product72_all_open);
        product72_update.setCanWeiFei_fen(  ((long)(chushi_canweifei * Product72.preset_amount_pianyi)) );
        product72_update.setUpdate_amount_time(new Date().getTime());
        product72_update.setCanweifei_state(canweifei_state_all);

        ContextUtil.getSerializContext().updateObject(product72_temp.getId(), product72_update);
    }

    JsonObject jsonObject_return = new JsonObject();

    jsonObject_return.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_OK);
    jsonObject_return.addProperty(StatusCode.statusCode_message_key, "设置成功！");

    out.print(jsonObject_return.toString());
%>