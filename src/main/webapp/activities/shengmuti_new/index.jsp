<%@page import="org.apache.commons.logging.LogFactory"%>
<%@page import="java.security.NoSuchAlgorithmException"%>
<%@page import="java.security.MessageDigest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/header/check_openid.jsp"%>
<%@ include file="/header/header_check_login.jsp"%>
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
<!DOCTYPE html>
<html>
	<meta charset="utf-8" />
		<title>圣慕缇:享优惠两折法式大餐</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <meta content="yes" name="apple-mobile-web-app-capable">
	    <meta content="telephone=no,email=no" name="format-detection">
	    <meta content="yes" name="apple-touch-fullscreen">
	    <meta http-equiv="X-UA-Compatible" content="ie=edge">
	    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" /><!-- 屏蔽双击缩放 -->
		<link rel="stylesheet" type="text/css" href="css/home_page.css"/>

		<script type="text/javascript" >var basePath = '${basePath}';</script>
		
	    <link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
		<script type="text/javascript" src="${basePath }plugin/js/layer_mobile/layer.js"></script>
		
		<script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js"></script>
		<script type="text/javascript" src="${basePath }plugin/js/lymava_common.js?r=2018-09-27"></script>

		<script type="text/javascript" src="${basePath }activities/shengmuti/js/project.js?r=2018-09-27"></script>
		
		<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.4.0.js"></script>

		<script type="text/javascript">
			var timestamp_tmp  = ${timestamp};
		
			$(function(){
				var window_width = $(window).width();
				var rem_font_size = window_width*10/75;
				$("html").css("font-size",rem_font_size+"px");
				

				wx.ready(function(){
				    // config信息验证后会执行ready方法，所有接口调用都必须在config接口获得结果之后，config是一个客户端的异步操作，所以如果需要在页面加载时就调用相关接口，则须把相关接口放在ready函数中调用来确保正确执行。对于用户触发时才调用的接口，则可以直接调用，不需要放在ready函数中。
					  regist_share_to_frend();
					  regist_share_to_pengyouquan();
				});
				
				wx.config({
				      debug: false,
				      appId: '${appId}', // 必填，公众号的唯一标识
				      timestamp: timestamp_tmp, // 必填，生成签名的时间戳
				      nonceStr: '${nonceStr}', // 必填，生成签名的随机串
				      signature: '${signature}',// 必填，签名，见附录1
				      jsApiList: [
				    	  'updateAppMessageShareData',
				    	  'updateTimelineShareData',
				    	  'onMenuShareTimeline',
				          'onMenuShareAppMessage',
				          'onMenuShareQQ',
				          'onMenuShareWeibo',
				          'onMenuShareQZone',
				          'checkJsApi'
				        ]
				  }); 
			}); 
			
			function not_start_notice(){
				var message = "10月1日才开放哦，敬请期待。";
				alertMsg_info(message);
			}
			
			function not_start_notice_message(message){
				alertMsg_info(message);
			} 
			var share_object = {
				      title: '圣慕缇:享优惠两折法式大餐',
				      desc: '呼亲唤友，享724元圣慕缇精致双人餐',
				      link: '${basePath}activities/shengmuti_new/index.jsp',
				      imgUrl: 'http://tiesh.liebianzhe.com/activities/shengmuti_new/img/573769070.jpg',
				      trigger: function (res) {
				        //alert('用户点击发送给朋友');
				      },
				      success: function (res) {
				        //alert('已分享');
				      },
				      cancel: function (res) {
				        //alert('已取消');
				      },
				      fail: function (res) {
				        //alert(JSON.stringify(res));
				      }
			};
			function regist_share_to_frend(){
			    wx.checkJsApi({
			        jsApiList: ["updateAppMessageShareData"],
			        success: function (res) {
			        	var checkResult = res.checkResult;
			        	if(checkResult.updateAppMessageShareData){
			        		wx.updateAppMessageShareData(share_object);
			        	}else{
			        		wx.onMenuShareAppMessage(share_object);
			        	}
			        	
			        }
			     });
			}
			function regist_share_to_pengyouquan(){
				 wx.checkJsApi({
				        jsApiList: ["updateTimelineShareData"],
				        success: function (res) {
				        	var checkResult = res.checkResult;
				        	if(checkResult.updateTimelineShareData){
				        		wx.updateTimelineShareData(share_object);
				        	}else{
				        		wx.onMenuShareTimeline(share_object);
				        	}
				        	
				        }
				    });
			}
		</script>
	<body>
		
		<div class="home_page">
			<img src="img/bg.gif"/>
		</div>
		
		<div class="home_page1" style="width:100%;background:url(img/bg.jpg) no-repeat;background-size:100% 100%;">
			<div class="h_p1">
					<img src="img/title.png"/>
			</div>
			<div class="h_p3">
				<img  onclick="not_start_notice_message('活动筹备中,敬请期待。')" src="img/four.png"/>
			</div> 
		</div>
	</body>
</html>
