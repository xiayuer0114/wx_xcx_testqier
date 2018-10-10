<%@ page import="com.lymava.commons.exception.CheckException" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page import="org.apache.commons.logging.LogFactory" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>

<%!
	public String sha_only(String str){
		// SHA1签名生成
		MessageDigest md = null;
		StringBuffer hexstr = new StringBuffer();
		try {
			md = MessageDigest.getInstance("SHA-1");
			md.update(str.getBytes());
			byte[] digest = md.digest();

			String shaHex = "";
			for (int i = 0; i < digest.length; i++) {
				shaHex = Integer.toHexString(digest[i] & 0xFF);
				if (shaHex.length() < 2) {
					hexstr.append(0);
				}
				hexstr.append(shaHex);
			}
		} catch (NoSuchAlgorithmException e) {
			LogFactory.getLog(this.getClass()).error("sha签名错误!", e);
		}
		return hexstr.toString();
	}
%>
<%
	Gongzonghao gongzonghao = GongzonghaoContent.getInstance().getDefaultGongzonghao();
	
	String jsapi_ticket = gongzonghao.initJsapi_ticket();
	
	String basePath_ = MyUtil.getBasePath(request);
	
	String appId = gongzonghao.getAppid();
	String timestamp = System.currentTimeMillis()/1000+"";
	String nonceStr = Md5Util.MD5Normal(UUID.randomUUID().toString());
	
	String request_url = basePath_+HttpUtil.getFullRequestPath(request);
	
	String signature_old = "jsapi_ticket="+jsapi_ticket+"&noncestr="+nonceStr+"&timestamp="+timestamp+"&url="+request_url;
	
	String signature =  sha_only(signature_old);
	
	request.setAttribute("appId", appId);
	request.setAttribute("timestamp", timestamp);
	request.setAttribute("nonceStr", nonceStr);
	request.setAttribute("signature", signature);
	request.setAttribute("request_url", request_url);
%>

<%-- 业务逻辑 --%>
<%
	Object userState = request.getAttribute("userState");
	request.setAttribute("openid_header", openid_header);

	//是否是分享页面
	if (userState != null && userState.equals(206)) {
		String current_page = request.getParameter("current_page");
		String origin_openid = request.getParameter("origin_openid");
		String didian_id = request.getParameter("didian_id");

		CheckException.checkNotNull(current_page, "参数有误，请重试");
		CheckException.checkNotNull(origin_openid, "参数有误，请重试");
		CheckException.isValid(didian_id, "参数有误，请重试");

		if (!origin_openid.equals(openid_header)) {//是朋友的微信用户
			request.getRequestDispatcher("/activities/caididian/guess_relife.jsp").forward(request, response);
		}
	}
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title>猜地点赢红包</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <meta content="yes" name="apple-mobile-web-app-capable">
	    <meta content="telephone=no,email=no" name="format-detection">
	    <meta content="yes" name="apple-touch-fullscreen">
	    <meta http-equiv="X-UA-Compatible" content="ie=edge">
	    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" /><!-- 屏蔽双击缩放 -->

		<meta itemprop="name" content="猜地点赢红包"/>
		<meta itemprop="image" content="${basePath }activities/caididian/img/share_icon.jpg" />
		<meta name="description" itemprop="description" content="猜地点赢红包，我需要你的帮助" />

	    <link rel="stylesheet" type="text/css" href="css/guess.css"/>

		<script type="text/javascript" >var basePath = '${basePath}';</script>
		<script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js" ></script>
		<script type="text/javascript" src="${basePath }plugin/js/lymava_common.js?r=<%=System.currentTimeMillis()%>"></script>

		<script src="${basePath }js/mui.min.js"></script>
		<link href="${basePath }css/mui.min.css" rel="stylesheet"/>
		<script src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>

		<link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
		<script type="text/javascript"	src="${basePath }plugin/js/layer_mobile/layer.js"></script>

		<script type="text/javascript"	src="${basePath }activities/caididian/js/project.js"></script>
	</head>
	
	
	<body>
		<div class="guess_choose">
			<div class="guess2-1">
				<img src="img/2_02.jpg" style="display: block;"/>
			</div>

			<div class="guess2-2" id="id_click_guess_rule">
				活动规则
			</div>
			<div class="clear"></div>

			<div class="guess2-3">
				<img src="img/2_02_1.jpg" style="display: block;"/>
			</div>
			<!--电视部分-->
			<div class="guess3-3 ">
				<div class="guess3-4_01">
					<img src="img/2_03.jpg" style="display: block; height: auto;"/>
				</div>
				<div class="guess2-4_02">
					<%--<c:if test="${pageSplit.page > 1}">--%>
						<div class="gu2_01" id="id_left">
							<img src="img/left.png"/>
						</div>
					<%--</c:if>--%>
					<div class="gu2_02">
						<img src="${basePath}${diadian_currnet.picResult}"/>
					</div>
					<%--<c:if test="${pageSplit.page < pageSplit.count}">--%>
						<div class="gu2_03" id="id_right">
							<img src="img/right.png"/>
						</div>
					<%--</c:if>--%>
				</div>
			</div>
			<div class="clear"></div>

			<!--搜索框部分-->
			<div class="guess3-1">
				你已经猜中这张老照片啦！
			</div>

			<div class="guess2-7" id="id_click_open_box">
				<img src="img/botton3.png" style="padding-top: 2.3rem;"/>
			</div>

			<div class="guess3-2">
				<img src="img/2_06.jpg"/>
			</div>
		</div>

		<!--活动规则-->
		<div class="guess_rule" hidden="hidden" id="id_guess_rule">
			<div class=""style="height: 10rem;width: 100%;"> </div>
			<div class="guess_rule1">
				<img src="img/rule.png"/>
			</div>
		</div>

		<c:if test="${userState == 502}">
			<!--选择两个盒子-->
			<div class="guess_choose1" hidden="hidden" id="id_guess_ok_div">
				<form id="id_open_box_form">
					<input hidden="hidden" id="diadian_id" name="diadian_id" value="${diadian_currnet.id}">
				</form>
				<div class=""style="height: 10rem;width: 100%;"> </div>
				<div class="g_c2">
					<div class="g_ch">
						<img src="img/dui.png"/>
					</div>
					<div class="g_ch1">
						<div class="" style="text-align: center;width: 40%;" id="id_left_box">
							<img src="img/box.png" style="width: 6rem;"/>
						</div>
						<div class="" style="text-align: center;width: 20%;">
							<img src="img/or.png" style="width: 1.5rem;padding-top: 1.5rem;"/>
						</div>
						<div class="" style="text-align: center;width: 40%;" id="id_right_box">
							<img src="img/box1.png" style="width: 6rem;"/>
						</div>
					</div>
					<div class="g_ch2">
						<img src="img/xuan.png"/>
					</div>
					<div class="" style="height: 2rem;"></div>
				</div>
			</div>
		</c:if>
		<c:if test="${userState == 300 or userState == 206}">
			<!--还有机会-->
			<%@include file="inc/hasChance.jsp"%>
		</c:if>
		<c:if test="${userState == 206}">
			<%-- 提示 --%>
			<div class="guess_choose1" id="id_guess_ok_div3">
				<img src="img/hint_relife.png" style="position: absolute;top: 0;right: 0; width: 10rem;">
			</div>
		</c:if>

	</body>

<script>
	var bClick_invite_relife2 = false;

	//用户答案输入框
	$("input[name='didianming']").focus(function () {
		$(this).val("");
	});

	//左右滑动图片
	$("#id_left").click(function () {
		window.location.href = "${basePath}activities/caididian/action_getPageAndDeal.jsp?page=${pageSplit.prePage}";
	});
	$("#id_right").click(function () {
		window.location.href = "${basePath}activities/caididian/action_getPageAndDeal.jsp?page=${pageSplit.nextPage}";
	});

	//活动规则（显示、隐藏）
	$("#id_click_guess_rule").click(function () {
		$("#id_guess_rule").removeAttr("hidden");
	});
	$("#id_guess_rule").click(function () {
		$(this).attr("hidden", "hidden");
	});

	//动态div显示隐藏
    $("#id_click_open_box").click(function () {
        $("#id_guess_ok_div,#id_guess_ok_div2").removeAttr("hidden");
    });
    $("#id_guess_ok_div").click(function () {
        $(this).attr("hidden", "hidden");
    });
    $("#id_guess_ok_div3").click(function () {
        $(this).attr("hidden", "hidden");
    });


    //点击盒子
    $("#id_left_box,#id_right_box").click(function () {
        var request_data = $('#id_open_box_form').serializeArray();
        ajax_post("${basePath}activities/caididian/action_openBox.jsp",request_data,function(message){
            var json = eval("(" + message + ")");

            if (json.result === true) {//中奖
                grant = "<div class=\"guess_ture\" id=\"id_guess_ok_div2\">\n" +
                    "\t<div class=\"\"style=\"height: 7.5rem;width: 100%;\"> </div>\n" +
                    "\t<div class=\"g_t\">\n" +
                    "\t\t<div class=\"g_tu\">\n" +
                    "\t\t\t<img src=\"img/dui1.png\"/>\n" +
                    "\t\t</div>\n" +
                    "\t\t<div class=\"g_tu1\">\n" +
                    "\t\t\t<img src=\"img/" + json.img + "\"/>\n" +
                    "\t\t</div>\n" +
                    "\t\t<div class=\"g_tu2\">\n" +
                    "\t\t\t<a href=\"${basePath}activities/caididian/action_generate_poster.jsp?page=${pageSplit.page}\">点击生成你的专属海报</a>\n" +
                    "\t\t</div>\n" +
                    "\t\t<div class=\"g_tu3\"  id=\"id_money_package\">\n" +

                    <%-- 进入钱包 --%>
                    "\t\t\t<img src=\"img/botton4.png\"/>\n" +

                    "\t\t</div>\n" +
                    "\t</div>\n" +
                    "</div>";

				$("#id_guess_rule").after(grant);

            } else  {//未中奖
                hasChance = "<div class=\"guess_chance\" id=\"id_guess_ok_div2\">\n" +
                    "\t<div class=\"\"style=\"height: 10rem;width: 100%;\"> </div>\n" +
                    "\t<div class=\"guess_chance1\">\n" +
                    "\t\t<div class=\"g_cha\">\n" +
                    "\t\t\t<img src=\"img/dui2.png\"/>\n" +
                    "\t\t</div>\n" +
                    "\t\t<div class=\"g_cha1\">\n" +
                    "\t\t\t<img src=\"img/ph.png\"/>\n" +
                    "\t\t</div>\n" +
                    "\t\t<div class=\"g_cha2\">\n" +
                    "\t\t\t可以邀请朋友助力复活<br />\n" +
                    "\t\t\t&nbsp;再猜（每天可助力5次）\n" +
                    "\t\t</div>\n" +
                    "\t\t<div class=\"g_cha3\">\n" +
                    "\t\t\t<img src=\"img/botton5.png\" id=\"id_invite_relife2\"/>\n" +
                    "\t\t</div>\n" +
                    "\t\t<div class=\"g_cha4\">\n" +
                    "\t\t\t<a href=\"${basePath}activities/caididian/action_generate_poster.jsp?page=${pageSplit.page}\">点击生成你的专属海报</a>\n" +
                    "\t\t</div>\n" +
                    "\t\t<div class=\"\" style=\"height: 2rem;width:100% ;\"></div>\n" +
                    "\t</div>\n" +
                    "</div>";

                $("#id_guess_rule").after(hasChance);
            }

            $("#id_guess_ok_div2").click(function () {
                if (bClick_invite_relife2 === false)
                	window.location.href = "${basePath}activities/caididian/action_getPageAndDeal.jsp?page=${pageSplit.page}";
            });
            $("#id_invite_relife2").click(function () {
                bClick_invite_relife2 = true;
                window.location.href = "${basePath}activities/caididian/action_getPageAndDeal.jsp?" +
                    "page=${pageSplit.page}&current_page=${pageSplit.page}&origin_openid=${openid_header}&didian_id=${diadian_currnet.id}&is_share=true";
            });
            //进入钱包
//            $("#id_money_package").click(function () {
//                window.location.href = "";
//            });
        });
    });

    //还有机会
	$("#id_invite_relife").click(function () {
        window.location.href = "${basePath}activities/caididian/action_getPageAndDeal.jsp?" +
        "page=${pageSplit.page}&current_page=${pageSplit.page}&origin_openid=${openid_header}&didian_id=${diadian_currnet.id}&is_share=true";
    });

	//进入钱包
//	$("#id_money_package").click(function () {
//        window.location.href = "";
//    });

</script>
</html>
