<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.lymava.commons.util.MyUtil" %>
<%@ page import="com.lymava.nosql.context.SerializContext" %>
<%@ page import="com.lymava.commons.util.DateUtil" %>
<%@ page import="com.lymava.qier.model.qianduanModel.Liuyan" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.lymava.nosql.util.PageSplit" %>
<%@ page import="com.lymava.commons.state.StatusCode" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>

<%!
    public boolean checkEmail( String email ){

        if(MyUtil.isEmpty(email)){ return false; }
        int strsize = email.length();
        if( strsize < 5){ return false; };

        // 有且只有一个 @
        int index_a = email.indexOf("@");
        int last_index_a = email.indexOf("@");
        if( index_a == -1){ return false; };
        if( index_a != last_index_a){ return false; };

        // 有且只有一个 .
        int index_dian = email.indexOf(".");
        int last_index_dian = email.indexOf(".");
        if( index_dian == -1){ return false; };
        if( index_dian != last_index_dian){ return false; };

        // @的位子要在.的位置之前至少两位
        if(index_dian<index_a+1){ return false; }

        // @和.都不能在开始和结尾
        if(index_a == 0 || index_a == strsize-1){
            return false;
        }
        if(index_dian == 0 || index_dian == strsize-1){
            return false;
        }

        return true;
    }
%>

<%!
    public String ret_data (Boolean check, String message, String callback){

        String ret_data = callback+"({";

        if(check){
            ret_data +="'statusCode':"+StatusCode.ACCEPT_OK+",'message':'"+message+"'";
            ret_data += "})";
            return ret_data;
        }else {
            ret_data +="'statusCode':"+StatusCode.ACCEPT_FALSE+",'message':'"+message+"'";
            ret_data += "})";
            return ret_data;
        }
    }

%>

<%

    String callback = request.getParameter("callback");

    SerializContext serializContext = ContextUtil.getSerializContext();

    // 今天开始的时间
    Long dayStartTime = DateUtil.getDayStartTime();
    // 用户ip
    String ipAddr = MyUtil.getIpAddr(request);

    Liuyan liuyan_find = new Liuyan();
    liuyan_find.setIpAddr(ipAddr);
    liuyan_find.setSubTimeDay(dayStartTime);

    PageSplit pageSplit = new PageSplit();
    Iterator<Liuyan> liuyanIterator = serializContext.findIterable(liuyan_find, pageSplit);

    if(pageSplit.getCount()>=4){
        out.println(ret_data(false, "您提交的次数过多", callback));
        return;
    }

    String name = request.getParameter("name");
    if(MyUtil.isEmpty(name)){
        out.println(ret_data(false, "请留下您的名字", callback));
        return;
    }

    String email = request.getParameter("email");
    if(!checkEmail(email)){
        out.println(ret_data(false, "请输入正确的邮箱地址", callback));
        return;
    }

    String leaveMessage = request.getParameter("leaveMessage");
    if( !(!MyUtil.isEmpty(leaveMessage) && leaveMessage.length()>6) ){
        out.println(ret_data(false, "留言信息请大于六个字", callback));
        return;
    }


    Liuyan liuyan_add = new Liuyan();
    liuyan_add.setIpAddr(ipAddr);
    liuyan_add.setSubTimeDay(dayStartTime);
    liuyan_add.setName(name);
    liuyan_add.setEmail(email);
    liuyan_add.setLeaveMessage(leaveMessage);
    liuyan_add.setState(Liuyan.state_ok);

    serializContext.save(liuyan_add);

    out.println(ret_data(true, "留言成功", callback));
%>