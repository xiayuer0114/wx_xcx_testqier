<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.qier.model.TradeRecord72"%>
<%@page import="com.lymava.qier.util.PrintUtil"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.trade.business.model.TradeRecord"%>
<%@page import="java.util.List"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.PubConlumn"%>
<%@page import="com.lymava.base.model.Pub"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.lymava.wechat.opendevelop.DevelopAccount"%>
<%@page import="com.lymava.wechat.gongzhonghao.GongzonghaoContent"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> 
<%
	String basePath = MyUtil.getBasePath(request);
	request.setAttribute("basePath", basePath);
%>
<!DOCTYPE html>
<html lang="en" style="font-size:36px;">
<head>
  
	<head>
		<meta charset="UTF-8">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>百度语音测试</title>
		<script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js"></script>
		<script type="text/javascript" src="${basePath }plugin/js/lymava_common.js?r=2018-06-10"></script>
		<script type="text/javascript"> 
		function doTTS(){
			var ttsText = $('#ttsText').val();
			voice_play(ttsText);
		}  
		function voice_play(voice_str){
			$('.tts_autio_id').remove();
			
			voice_str = encodeURIComponent(voice_str);
			
			var audio_link = "http://tts.baidu.com/text2audio?lan=zh&ie=UTF-8&spd=6&text="+voice_str;
			
			var audio_html = '<audio class="tts_autio_id" autoplay="autoplay">';
				audio_html	+= '<source class="tts_source_id" src="'+audio_link+'" type="audio/mpeg">';
				audio_html	+= '<embed class="tts_embed_id" height="0" width="0" src="">';
			audio_html	+= '</audio>';
			
			$('body').append(audio_html);
		}
		</script>
	</head>
	<body>
		<div>  
			<textarea style="width: 500px;height: 400px;" id="ttsText"></textarea>
			<input type="button" id="tts_btn" onclick="doTTS()" value="播放">
		</div>
	</body>
</html>