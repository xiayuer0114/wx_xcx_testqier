<%@ page import="com.lymava.qier.activities.model.Daka" %>
<%@ page import="com.lymava.commons.util.*" %>
<%@ page import="com.lymava.nosql.util.QuerySort" %><%--
  Created by IntelliJ IDEA.
  User: sunM
  Date: 2018\7\3 0003
  Time: 14:33
  To change this template use File | Settings | File Templates.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>

<%
    /**
     * 这个页面是这次活动的主入口
     * 只用于判断用户进来 该进哪一个页面
      */


    // 现在的时间
    Long nowTime = System.currentTimeMillis();

    // 今天开始的时间
    Long nowStartTime = DateUtil.getDayStartTime(nowTime);

    Daka daka_find = new Daka();

    daka_find.setOpenId(openid_header);
    daka_find.setState(Daka.state_ok);
    daka_find.initQuerySort("dakaTime", QuerySort.desc);

    // 总共打卡的次数
    Integer count = serializContext.findAll(daka_find).size();

    // 最后一次打卡的记录
    daka_find = (Daka) ContextUtil.getSerializContext().findOneInlist(daka_find);

    if(count.equals(7)){
        // 已经打卡七天 就跳转到最后一天打卡的那个页面
        request.setAttribute("dakaView","date1_"+daka_find.getLianxuMark()+".html");
    }else {

        if (daka_find == null || daka_find.getLianxuMark() == null) {
            // // 没有打卡记录 或者 连续打卡标记为空  跳第一次打卡的页面
            request.setAttribute("dakaView", "date1_1.html");
        } else {
            if (nowStartTime.equals(daka_find.getDakaStartTime())) {
                // 最后一次打卡是今天   跳今天打卡的页面  mark
                request.setAttribute("dakaView", "date1_" + daka_find.getLianxuMark() + ".html");
            } else if (nowStartTime.equals(daka_find.getDakaStartTime() + DateUtil.one_day)) {
                //  最后一次打卡是昨天  跳今天打卡的页面  mark+1
                request.setAttribute("dakaView", "date1_" + (daka_find.getLianxuMark() + 1) + ".html");
            } else {
                // 中断打卡  跳第一次打卡页面
                request.setAttribute("dakaView", "date1_1.html");
            }
        }
    }

%>

<html>

    <script type="text/javascript" src="js/jquery-3.2.1.js"></script>

    <script type="text/javascript">
        $(function () {
            var dataView = "${dakaView}";
            window.location.href = "/activities/daka/"+dataView;
        });
    </script>

</html>

