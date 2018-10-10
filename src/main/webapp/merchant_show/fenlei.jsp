<%@ page import="com.lymava.qier.model.MerchantPub" %>
<%@ page import="com.lymava.qier.action.MerchantShowAction" %>
<%@ page import="com.lymava.base.util.ContextUtil" %><%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018\4\20 0020
  Time: 11:39
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<%
    String leibie = request.getParameter("leibie");
    request.getSession().setAttribute("leibie",leibie);

    MerchantPub merchantPub = new MerchantPub();
    if ("meishi_1".equals(leibie)){
        merchantPub.setPubConlumnId(MerchantShowAction.getFoodPubConlumnId());
    }else if ("yule_2".equals(leibie)){
        merchantPub.setPubConlumnId(MerchantShowAction.getRecreationPubConlumnId());
    }else if ("tuijian_3".equals(leibie)){
        merchantPub.setPubConlumnId(MerchantShowAction.getRecommendPubConlumnId());
    }

    merchantPub = (MerchantPub) ContextUtil.getSerializContext().get(merchantPub);

    String merchantPubName =  merchantPub.getPubConlumn().getName();

%>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
    <title>悠择生活<%=merchantPubName%>频道</title>
    <link rel="stylesheet" href="css/business.css" />
    <link rel="stylesheet" type="text/css" href="layui-v2.2.5/layui/css/layui.css"/>

    <script type="text/javascript" src="${basePath }merchant_show/js/jquery-1.11.0.js"></script>
</head>
<body>
<div class="container">
    <!--banner部分-->
    <div class="banner_f layui-col-xs12">
        <img src="img/banner_3.jpg"/>
    </div>

    <!--内容部分-->
    <div class="content">
        <div class="content1 layui-col-xs12">
            <span id="leibie" value="${leibie}"></span>
            <img id="imgTiele" src="img/title1.png"/>
        </div>
        <div class="content2" id="content2Body">

        </div>
    </div>

</div>
</body>

<script type="text/javascript">
    var page_temp = 1;

    $(function () {

        var leibie = $("#leibie").attr("value");
        if ("meishi_1"==leibie){
            $("#imgTiele").attr("src",'img/title.png');
        }else if ("yule_2"==leibie){
            $("#imgTiele").attr("src",'img/title1.png');
        }else if ("tuijian_3"==leibie){
            $("#imgTiele").attr("src",'img/title2.png');
        }else if ("zhekou_4"==leibie){
            $("#imgTiele").attr("src",'img/sadasdsas.png');
        }

        var page_temp = 1;

        $(function () {
            $.post("${basePath}/qier/merchantshow/getMorePub.do",{"page_temp":page_temp},function (data) {
                $("#content2Body").append(data);
            });
        });

    });

    //  收藏小心心的点击事件
    function collectPub(id,obj) {
        $.post("${basePath}/qier/merchantshow/collectPub.do",{"id":id},function (data) {
            data = JSON.parse(data).statusCode;
            if(data == 200){
                $(obj).attr("src","img/xing1.png");
                $(obj).parent().prev().text(parseInt($(obj).parent().prev().text())+1);
            }
        });
    };

    // 事件监听  上拉到底部加载数据
    window.onscroll = function () {
        //监听事件内容
        if(getScrollHeight() <= getWindowHeight() + getDocumentTop()){
            //当滚动条到底时,这里是触发内容
            //异步请求数据,局部刷新dom
            page_temp++;
            $.post("${basePath}/qier/merchantshow/getMorePub.do",{"page_temp":page_temp},function (data) {
                $("#containerPub").append(data);
            });
        }
    }
    //文档高度
    function getDocumentTop() {
        var scrollTop = 0, bodyScrollTop = 0, documentScrollTop = 0;
        if (document.body) {
            bodyScrollTop = document.body.scrollTop;
        }
        if (document.documentElement) {
            documentScrollTop = document.documentElement.scrollTop;
        }
        scrollTop = (bodyScrollTop - documentScrollTop > 0) ? bodyScrollTop : documentScrollTop;    return scrollTop;
    }
    //可视窗口高度
    function getWindowHeight() {
        var windowHeight = 0;    if (document.compatMode == "CSS1Compat") {
            windowHeight = document.documentElement.clientHeight;
        } else {
            windowHeight = document.body.clientHeight;
        }
        return windowHeight;
    }
    //滚动条滚动高度
    function getScrollHeight() {
        var scrollHeight = 0, bodyScrollHeight = 0, documentScrollHeight = 0;
        if (document.body) {
            bodyScrollHeight = document.body.scrollHeight;
        }
        if (document.documentElement) {
            documentScrollHeight = document.documentElement.scrollHeight;
        }
        scrollHeight = (bodyScrollHeight - documentScrollHeight > 0) ? bodyScrollHeight : documentScrollHeight;    return scrollHeight;
    }
</script>

</html>
