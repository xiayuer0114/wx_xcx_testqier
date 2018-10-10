<%@page import="com.lymava.commons.util.HttpUtil"%>
<%@page import="com.lymava.commons.util.Md5Util"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.wechat.gongzhonghao.GongzonghaoContent"%>
<%@page import="com.lymava.wechat.gongzhonghao.Gongzonghao"%>
<%@page import="com.lymava.commons.util.MathUtil"%>
<%@page import="org.apache.commons.logging.LogFactory"%>
<%@page import="java.security.NoSuchAlgorithmException"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="com.lymava.wechat.util.SHA1"%>
<%@page import="com.lymava.qier.activities.guaguaka.GuaguakaShareBusiness"%>
<%@page import="com.lymava.qier.util.DiLiUtil"%>
<%@page import="com.lymava.trade.pay.model.PaymentRecord"%>
<%@page import="com.lymava.nosql.mongodb.util.MongoCommand"%>
<%@page import="com.lymava.qier.model.Merchant72"%>
<%@page import="com.lymava.nosql.util.QuerySort"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.qier.model.MerchantRedEnvelope"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@page import="com.lymava.qier.model.TradeRecord72"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.trade.business.model.Product"%>
<%@page import="com.lymava.trade.business.model.TradeRecord"%>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
    <title>123456789</title>
    <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>
     <script>
	var timestamp_tmp  = ${timestamp};
	wx.config({
      debug: true,
      appId: '${appId}', // 必填，公众号的唯一标识
      timestamp: timestamp_tmp, // 必填，生成签名的时间戳
      nonceStr: '${nonceStr}', // 必填，生成签名的随机串
      signature: '${signature}',// 必填，签名，见附录1
      jsApiList: [
          'checkJsApi',
          'onMenuShareTimeline',
          'onMenuShareAppMessage',
          'onMenuShareQQ',
          'onMenuShareWeibo',
          'onMenuShareQZone',
          'hideMenuItems',
          'showMenuItems',
          'hideAllNonBaseMenuItem',
          'showAllNonBaseMenuItem',
          'translateVoice',
          'startRecord',
          'stopRecord',
          'onVoiceRecordEnd',
          'playVoice',
          'onVoicePlayEnd',
          'pauseVoice',
          'stopVoice',
          'uploadVoice',
          'downloadVoice',
          'chooseImage',
          'previewImage',
          'uploadImage',
          'downloadImage',
          'getNetworkType',
          'openLocation',
          'getLocation',
          'hideOptionMenu',
          'showOptionMenu',
          'closeWindow',
          'scanQRCode',
          'chooseWXPay',
          'openProductSpecificView',
          'addCard',
          'chooseCard',
          'openCard'
        ]
  });
  wx.ready(function(){
	  
	  // 2.2 监听“分享到朋友圈”按钮点击、自定义分享内容及分享结果接口
	  document.querySelector('#onMenuShareTimeline').onclick = function () {
	    wx.onMenuShareTimeline({
	      title: '互联网之子',
	      link: 'http://movie.douban.com/subject/25785114/',
	      imgUrl: 'http://demo.open.weixin.qq.com/jssdk/images/p2166127561.jpg',
	      trigger: function (res) {
	        // 不要尝试在trigger中使用ajax异步请求修改本次分享的内容，因为客户端分享操作是一个同步操作，这时候使用ajax的回包会还没有返回
	        alert('用户点击分享到朋友圈');
	      },
	      success: function (res) {
	        alert('已分享');
	      },
	      cancel: function (res) {
	        alert('已取消');
	      },
	      fail: function (res) {
	        alert(JSON.stringify(res));
	      }
	    });
	    alert('已注册获取“分享到朋友圈”状态事件');
	  };
  });
  function chooseImage(){
	   wx.chooseImage({
		    count: 1, // 默认9
		    sizeType: ['original', 'compressed'], // 可以指定是原图还是压缩图，默认二者都有
		    sourceType: ['camera'], // 可以指定来源是相册还是相机，默认二者都有
		    success: function (res) {
		        var localIds = res.localIds; // 返回选定照片的本地ID列表，localId可以作为img标签的src属性显示图片
				var localId = localIds[0];
		        
				alert(localId);
		    }

		});
   } 
  
</script>
</head>   
<body> 
	 <input type="button" value="注册分享监听事件" id="onMenuShareTimeline" ><br/>
	 当前访问全路径:${request_url }<br/>
	 <code>
	 	wx.onMenuShareTimeline({
	      title: '互联网之子',
	      link: 'http://movie.douban.com/subject/25785114/',
	      imgUrl: 'http://demo.open.weixin.qq.com/jssdk/images/p2166127561.jpg',
	      trigger: function (res) {
	        // 不要尝试在trigger中使用ajax异步请求修改本次分享的内容，因为客户端分享操作是一个同步操作，这时候使用ajax的回包会还没有返回
	        alert('用户点击分享到朋友圈');
	      },
	      success: function (res) {
	        alert('已分享');
	      },
	      cancel: function (res) {
	        alert('已取消');
	      },
	      fail: function (res) {
	        alert(JSON.stringify(res));
	      }
	    });
	 </code><br/>
</body>
</html>