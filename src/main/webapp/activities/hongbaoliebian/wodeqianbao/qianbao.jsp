<%@ page import="com.lymava.qier.model.xiaoChengXuModel.ShowPub" %>
<%@ page import="com.lymava.qier.model.MerchantRedEnvelope" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.lymava.base.model.Pub" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="com.lymava.qier.model.Merchant72" %>
<%--
  User: Administrator---SunM
  Date: 2018\9\22 0022
  Time: 11:55
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@ include file="/header/check_openid.jsp"%>
<%@ include file="/header/header_check_login.jsp"%>

<%

    User user_find = new User();
    user_find.setThird_user_id(openid_header);
    user_find.setState(User.STATE_OK);
    user_find = (User) serializContext.get(user_find);

    List<MerchantRedEnvelope> merchantRedEnvelopeIterable = new LinkedList<>();
    if(user_find!=null){
        request.setAttribute("balance", user_find.getShowBalance());

        MerchantRedEnvelope merchantRedEnvelope_find = new MerchantRedEnvelope();
        merchantRedEnvelope_find.setUser_huiyuan(user_find);
        merchantRedEnvelope_find.setState(State.STATE_OK);

        Iterator<MerchantRedEnvelope> merchantRedEnvelopeIterator = serializContext.findIterable(merchantRedEnvelope_find);
        while(merchantRedEnvelopeIterator.hasNext()){
            MerchantRedEnvelope merchantRedEnvelope_tmp = merchantRedEnvelopeIterator.next();
            Merchant72 merchant72 = merchantRedEnvelope_tmp.getUser_merchant();
            if(merchant72 != null && (User.STATE_OK.equals(merchant72.getState()) || User.STATE_OK == merchant72.getState()) ){
                merchantRedEnvelopeIterable.add(merchantRedEnvelope_tmp);
            }
        }
    }

    request.setAttribute("merchantRedEnvelopeIterable",merchantRedEnvelopeIterable);

%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta content="yes" name="apple-mobile-web-app-capable">
    <meta content="telephone=no,email=no" name="format-detection">
    <meta content="yes" name="apple-touch-fullscreen">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" /><!-- 屏蔽双击缩放 -->
    <link rel="stylesheet" type="text/css" href="css/qianbao.css"/>
    <script type="text/javascript" src="js/jquery-1.12.4.min.js" ></script>
    <script src="mui/js/mui.min.js"></script>
    <link href="mui/css/mui.min.css" rel="stylesheet"/>
    <script type="text/javascript">
        $(function(){
            var window_width = $(window).width();
            var rem_font_size = window_width*10/75;
            $("html").css("font-size",rem_font_size+"px");

            mui.init();
        });
    </script>
<body style="background: #fff;">
<div class="xiantian mui-row">
    <div class="xiantian_1"></div>
</div>
<div class="qianbao mui-row">
    <div class="qianbao_1 mui-row">
        <div class="qianbao_1_1 mui-col-xs-9">
            <img src="img/qianbao.png"/>
        </div>
        <div class="qianbao_1_2 mui-col-xs-3"></div>
    </div>
    <div class="nicheng" ></div>
    <div class="yue">余额：¥${balance}</div>
</div>


<div class="xiantian mui-row">
    <div class="xiantian_2"></div>
</div>

<c:forEach var="red_tmp" varStatus="i" items="${merchantRedEnvelopeIterable }">

    <div class="shangjia mui-row">
        <div class="shangjialogo mui-col-xs-3">
            <img src="${basePath}<c:out value="${red_tmp.user_merchant.picname}" escapeXml="true"/>" />
        </div>
        <div class="shangjiaxinxi mui-col-xs-9">
            <div class="xinxi mui-row">
                <div class="xinxi_1 mui-col-xs-6" >
                    <%--台塑王品--%>
                    <c:out value="${red_tmp.red_envolope_name}" escapeXml="true"/>
                </div>
                <div class="xinxi_2 mui-col-xs-6">
                    <div class="xinxi_2_1 mui-row">
                        <div class="xinxi_2_12 mui-col-xs-6">
                            <img src="img/biaoqian.png"/>
                        </div>
                        <div class="xinxi_2_13 mui-col-xs-6">
                            <%--牛排--%>
                            <c:out value="${red_tmp.merchant_type}" escapeXml="true"/>
                        </div>
                    </div>
                </div>
            </div>
            <div class="qian mui-row">
                <div class="qian_1 mui-col-xs-7">
                    <%--金额：CNY10--%>
                        金额：CNY
                        <c:out value="${red_tmp.amount/1000000}" escapeXml="true"/>
                </div>
                <div class="qian_2 mui-col-xs-5">
                    <%--有效期至：12-19--%>
                        有效期至：
                        <c:out value="${red_tmp.showExpiryMonthDay}" escapeXml="true"/>
                </div>
            </div>
            <%--<div class="guize mui-row">--%>
                <%--<div class="guize_1 mui-col-xs-7">--%>
                    <%--<div class="guize1_1" style="">--%>
                        <%--<div class="guize1_2">--%>
                            <%--&lt;%&ndash;使用规则&ndash;%&gt;--%>

                            <%--金额：CNY--%>
                            <%--<c:out value="${red_tmp.amount_to_reach_yuan}" escapeXml="true"/>--%>
                        <%--</div>--%>
                    <%--</div>--%>
                <%--</div>--%>
                <%--<div class="guize_2 mui-col-xs-4">--%>
                    <%--&lt;%&ndash;前往商家&ndash;%&gt;--%>
                    <%--有效期至：--%>
                    <%--<c:out value="${red_tmp.showExpiryMonthDay}" escapeXml="true"/>--%>
                <%--</div>--%>
                <%--<div class="guize_3 mui-col-xs-1">--%>
                    <%--<img src="img/jiantou.png" />--%>
                <%--</div>--%>
            <%--</div>--%>
        </div>
    </div>
    <div class="xiantian mui-row">
        <div class="xiantian_3"></div>
    </div>
</c:forEach>


</body>
</html>
