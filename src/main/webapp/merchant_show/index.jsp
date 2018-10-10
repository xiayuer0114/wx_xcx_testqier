<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../header/check_openid.jsp"%>
<%@ include file="../header/header_check_login.jsp"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
	    <meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
	    <title>商家联盟</title>
	    <link rel="stylesheet" href="${basePath }merchant_show/css/business.css" />
	    <link rel="stylesheet" type="text/css" href="${basePath }user_center/layui-v2.2.5/layui/css/layui.css"/>

		<style type="text/css">
			body,div,ul,li,a,img{margin: 0;padding: 0;}
			ul,li{list-style: none;}
			a{text-decoration: none;}

			#wrapper{position: relative;margin: 0px auto;height: auto;}
			#banner{position:relative;height: auto;overflow: hidden;}
			.imgList{position:relative;width:1452px;height:auto;z-index: 10;overflow: hidden;}
			.imgList li{float:left;display: inline;}
			#prev,
			#next{position: absolute;top:80px;z-index: 20;cursor: pointer;opacity: 0.2;filter:alpha(opacity=20);}
			#prev{left: 10px;}
			#next{right: 10px;}
			#prev:hover,
			#next:hover{opacity: 0.5;filter:alpha(opacity=50);}
			.bg{position: absolute;bottom: 0;width: 400px;height: 40px;z-index:20;opacity: 0.4;filter:alpha(opacity=40);background: black;}
			.infoList{position: absolute;left: 10px;bottom: 10px;z-index: 30;}
			.infoList li{display: none;}
			.infoList .infoOn{display: inline;color: white;}
			.indexList{position: absolute;right: 10px;bottom: 5px;z-index: 30;}
			.indexList li{float: left;margin-right: 5px;padding: 2px 4px;border: 2px solid black;background: grey;cursor: pointer;}
			.indexList .indexOn{background: red;font-weight: bold;color: white;}
		</style>

		<script type="text/javascript" src="${basePath }merchant_show/js/jquery-1.11.0.js"></script>

	</head>

	<body>
		<div class="container layui-col-xs12"  id="containerPub">

			<!--banner部分-->
			<div class="banner layui-col-xs12">
				<div class="banner1 layui-col-xs12" style="position: relative;" id="wrapper">
					<%--<div><!-- 最外层部分 -->--%>
						<div id="banner"><!-- 轮播部分 -->
							<ul class="imgList" id="picLunbo"><!-- 图片部分 -->
								<%--<li style="width: 338px"><a href="#"><img src="./img/banner_1.jpg" style="width: 338px"></a></li>--%>
								<%--<li style="width: 338px"><a href="#"><img src="./img/banner_2.jpg" style="width: 338px"></a></li>--%>
								<%--&lt;%&ndash;<li><a href="#"><img src="./img/banner_3.jpg" ></a></li>&ndash;%&gt;--%>
								<%--<li style="width: 338px"><a href="#"><img src="./img/banner_1.jpg" style="width: 338px"></a></li>--%>
							</ul>
							<!--<div class="bg"></div> <!-- 图片底部背景层部分-->
						</div>
					<%--</div>--%>
				</div>
			</div>

			<div class="clear"></div>
			<!--导航部分-->
			<div class="nav">
				<div class="nav1 layui-col-xs12">
						<div class="nav1_1 layui-col-xs6">
							<a href="${basePath }merchant_show/fenlei.jsp?leibie=meishi_1"><img src="img/banner_1.jpg"/></a>
						</div>
						<div class="nav1_2 layui-col-xs6">
							<a href="${basePath }merchant_show/fenlei.jsp?leibie=yule_2"><img src="img/banner_2.jpg"/></a>
						</div>
						<div class="nav1_1 layui-col-xs6">
							<a href="${basePath }merchant_show/fenlei.jsp?leibie=tuijian_3"><img src="img/photo.png"/></a>
						</div>
						<div class="nav1_2 layui-col-xs6">
							<a href="${basePath }merchant_show/activity.jsp"><img src="img/photo1.png"/></a>
						</div>
				</div>
				<div class="nav2 layui-col-xs12"></div>
			</div>
			<div class="clear"></div>

			<!--内容部分  标题-->
			<div class="content layui-col-xs12">
				<div class="content1 layui-col-xs12">
					<img src="img/title.png"/>
					<div class="" style="height: 1rem;"></div>
				</div>
			</div>


			<!--内容部分-->

			</div>

	</body>


	<script type="text/javascript">

        var w = parseInt($(window).width());//获取浏览器的宽度
        var picWid = w;
        var picCount = 0;

		$(function () {
            $.post("${basePath}/qier/merchantshow/getHomePic.do",{},function (data) {
                data = JSON.parse(data);
                data = data.data.jsonData;
                data = JSON.parse(data);

                picCount = data.length;
//                console.log(data);

                var wid = "width:"+w+"px";

                for (var  i = 0;  i < data.length ; i++){

                    $li =  $("<li><a href='#'></a></li>");
                    $img = $("<img src=../"+data[i].pic+"  style="+wid+" />");
                    $li.append($img);
                    $("#picLunbo").append($li);

                }
//                console.log($img.width());
//
//                console.log(w);
                $("#picLunbo").css("width",picCount*w);

                var curIndex = 0, //当前index
                    imgLen = $(".imgList li").length; //图片总数

                // 定时器自动变换2.5秒每次
                var autoChange = setInterval(function(){
                    if(curIndex < imgLen-1){
                        curIndex ++;
                    }else{
                        curIndex = 0;
                    }
                    //调用变换处理函数
                    changeTo(curIndex);
                },2500);

            });
        });


        function changeTo(num){
            var goLeft = num * w;
            $(".imgList").animate({left: "-" + goLeft + "px"},500);
            $(".infoList").find("li").removeClass("infoOn").eq(num).addClass("infoOn");
            $(".indexList").find("li").removeClass("indexOn").eq(num).addClass("indexOn");
        }
	</script>


	<%--初始化加载 和 上拉到底部加载跟多--%>
	<script type="text/javascript">
        var page_temp = 1;

        $(function () {
            $.post("${basePath}/qier/merchantshow/clearSession.do");

            $.post("${basePath}/qier/merchantshow/getMorePub.do",{"page_temp":page_temp},function (data) {
                $("#containerPub").append(data);
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
