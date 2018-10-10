<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.base.util.WebConfigContent"%>
<%@page import="com.lymava.wechat.gongzhonghao.vo.MessageSendNews"%>
<%@page import="com.lymava.base.model.User"%>
<%@page import="com.lymava.base.model.Pub"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<fieldset >
			<dl>
				<dt>每日总数：</dt>
				<dd>
					<input type="hidden"  name="name"  value="guaguaka_every_day_count" > 
					<input type="text" name="guaguaka_every_day_count" value="<c:out value="${webConfig_guaguaka_every_day_count }" escapeXml="true"/>"  class="digits" >
				</dd>
			</dl>
			<dl>
				<dt>活动总数</dt>
				<dd>
					<input type="hidden"  name="name"  value="guaguaka_all_day_count" > 
					<input type="text" name="guaguaka_all_day_count" value="<c:out value="${webConfig_guaguaka_all_day_count }" escapeXml="true"/>"  class="digits" >
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>活动当天</dt>
				<dd>
					<input type="hidden"  name="name"  value="guaguaka_dangtianTime" > 
					<input type="text" name="guaguaka_dangtianTime" value="<c:out value="${webConfig_guaguaka_dangtianTime }" escapeXml="true"/>"  class="date" dateFmt="yyyy-MM-dd"  >
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>活动开始</dt>
				<dd>
					<input type="hidden"  name="name"  value="guaguaka_startTime" > 
					<input type="text" name="guaguaka_startTime" value="<c:out value="${webConfig_guaguaka_startTime }" escapeXml="true"/>"  class="date" dateFmt="yyyy-MM-dd HH:mm:ss"  >
				</dd>
			</dl>
			<dl>
				<dt>活动结束</dt>
				<dd>
					<input type="hidden"  name="name"  value="guaguaka_endTime" > 
					<input type="text" name="guaguaka_endTime" value="<c:out value="${webConfig_guaguaka_endTime }" escapeXml="true"/>"  class="date" dateFmt="yyyy-MM-dd HH:mm:ss" >
				</dd>
			</dl> 
			<div class="divider"></div> 
			<dl>
				<dt style="font-size: 0.5rem;">定向红包有效期至</dt>
				<dd>
					<input type="hidden"  name="name"  value="guaguaka_dingxiang_endTime" > 
					<input type="text" name="guaguaka_dingxiang_endTime" value="<c:out value="${webConfig_guaguaka_dingxiang_endTime }" escapeXml="true"/>"  class="date" dateFmt="yyyy-MM-dd" >
				</dd>
			</dl>
			<dl>
				<dt>回复推文</dt>
				<dd class="lookup_dd">
					<input type="hidden"  name="name"  value="guaguaka_tuiwen_id" > 
					<%
						MessageSendNews messageSendNews = null;
						String guaguaka_tuiwen_id = WebConfigContent.getConfig("guaguaka_tuiwen_id");
						if(MyUtil.isValid(guaguaka_tuiwen_id)){
							messageSendNews = (MessageSendNews)ContextUtil.getSerializContext().get(MessageSendNews.class, guaguaka_tuiwen_id);
						}
						request.setAttribute("messageSendNews", messageSendNews);
					%>
					<input type="text" 	 bringBack="messageSendNews.title"     value="<c:out value="${messageSendNews.title }" escapeXml="true"/>"   > 
					<input type="hidden" bringBack="messageSendNews.id" name="guaguaka_tuiwen_id" value="<c:out value="${webConfig_guaguaka_tuiwen_id }" escapeXml="true"/>"   >
					<a  class="btnLook" href="${basePath }v2/MessageSendNews/list.do?return_mod=lookup" lookupGroup="messageSendNews"  rel="messageSendNews_lookup">查找</a>
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>回复口令</dt>
				<dd>
					<input type="hidden"  name="name"  value="guaguaka_text_kouling" > 
					<input type="text" name="guaguaka_text_kouling" value="<c:out value="${webConfig_guaguaka_text_kouling }" escapeXml="true"/>"   >
				</dd>
			</dl>
			<dl>
				<dt>文字回复</dt>
				<dd>
					<input type="hidden"  name="name"  value="guaguaka_text_send_message" > 
					<input type="text" name="guaguaka_text_send_message" value="<c:out value="${webConfig_guaguaka_text_send_message }" escapeXml="true"/>"   >
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt style="font-size: 0.6rem;" >今日已领完提醒</dt>
				<dd>
					<input type="hidden"  name="name"  value="guaguaka_today_is_finish_message" > 
					<input type="text" name="guaguaka_today_is_finish_message" value="<c:out value="${webConfig_guaguaka_today_is_finish_message }" escapeXml="true"/>"   >
				</dd>
			</dl> 
			<dl>
				<dt style="font-size: 0.6rem;" >已领完提醒</dt>
				<dd>
					<input type="hidden"  name="name"  value="guaguaka_all_is_finish_message" > 
					<input type="text" name="guaguaka_all_is_finish_message" value="<c:out value="${webConfig_guaguaka_all_is_finish_message }" escapeXml="true"/>"   >
				</dd>
			</dl> 
			<div class="divider"></div> 
			<dl>
				<dt style="font-size: 0.6rem;" >活动未开始提醒</dt>
				<dd>
					<input type="hidden"  name="name"  value="guaguaka_not_start_message" > 
					<input type="text" name="guaguaka_not_start_message" value="<c:out value="${webConfig_guaguaka_not_start_message }" escapeXml="true"/>"   >
				</dd>
			</dl> 
			<dl>
				<dt style="font-size: 0.6rem;" >活动已结束提醒</dt>
				<dd>
					<input type="hidden"  name="name"  value="guaguaka_had_end_message" > 
					<input type="text" name="guaguaka_had_end_message" value="<c:out value="${webConfig_guaguaka_had_end_message }" escapeXml="true"/>"   >
				</dd>
			</dl> 
			<!-- 
			<div class="divider"></div> 
			<dl>
				<dd style="text-align: center;width: 100%;">
					活动当天奖品和几率
				</dd>
			</dl> 
			<div class="divider"></div> 
			<dl class="nowrap">
				<dt style="width: 20px;"  >从</dt>
				<dd style="width: 70px;" >
					<input type="hidden"  name="name"  value="guaguaka_current_day_tongyong1_from" > 
					<input style="width: 60px;" type="text" name="guaguaka_current_day_tongyong1_from" value="<c:out value="${webConfig_guaguaka_current_day_tongyong1_from }" escapeXml="true"/>" class="digits"    >
				</dd> 
				<dd style="width: 50px;" >
					元 到
				</dd>
				<dd  style="width: 70px;">
					<input type="hidden"  name="name"  value="guaguaka_current_day_tongyong1_to" > 
					<input style="width: 60px;" type="text" name="guaguaka_current_day_tongyong1_to" value="<c:out value="${webConfig_guaguaka_current_day_tongyong1_to }" escapeXml="true"/>" class="digits"    >
				</dd>
				<dd style="width: 30px;" >
					元
				</dd>
				<dd style="width: 60px;" >
					中奖几率
				</dd>
				<dd  style="width: 70px;">
					<input type="hidden"  name="name"  value="guaguaka_current_day_tongyong1_jilv" > 
					<input style="width: 60px;" type="text" name="guaguaka_current_day_tongyong1_jilv" value="<c:out value="${webConfig_guaguaka_current_day_tongyong1_jilv }" escapeXml="true"/>" class="digits"    >
				</dd>
				<dd style="width: 20px;" >
					%
				</dd>
			</dl>  
			<div class="divider"></div> 
			<dl>
				<dt style="font-size: 0.6rem;" >定向红包几率</dt>
				<dd style="width: 60px;">
					<input type="hidden"  name="name"  value="guaguaka_current_day_dingxiang_jilv" > 
					<input style="width: 50px;" type="text" name="guaguaka_current_day_dingxiang_jilv" value="<c:out value="${webConfig_guaguaka_current_day_dingxiang_jilv }" escapeXml="true"/>"   >
				</dd>
				<dd style="width:50px;">
					%
				</dd>
			</dl> 
			<dl>
				<dt style="font-size: 0.6rem;" >iPhone x</dt>
				<dd style="width: 60px;">
					<input type="hidden"  name="name"  value="guaguaka_current_day_iphonex_jilv" > 
					<input style="width: 50px;" type="text" name="guaguaka_current_day_iphonex_jilv" value="<c:out value="${webConfig_guaguaka_current_day_iphonex_jilv }" escapeXml="true"/>"   >
				</dd>
				<dd style="width:50px;">
					%
				</dd>
			</dl> 
			<div class="divider"></div> 
			<dl>
				<dt style="font-size: 0.6rem;" >8888元通用红包</dt>
				<dd style="width: 60px;">
					<input type="hidden"  name="name"  value="guaguaka_current_day_8888_jilv" > 
					<input style="width: 50px;" type="text" name="guaguaka_current_day_8888_jilv" value="<c:out value="${webConfig_guaguaka_current_day_8888_jilv }" escapeXml="true"/>"   >
				</dd>
				<dd style="width:50px;">
					%
				</dd>
			</dl> 
			<div class="divider"></div> 
			<dl class="nowrap">
				<dt style="width: 20px;"  >从</dt>
				<dd style="width: 70px;" >
					<input type="hidden"  name="name"  value="guaguaka_current_day_tongyong2_from" > 
					<input style="width: 60px;" type="text" name="guaguaka_current_day_tongyong2_from" value="<c:out value="${webConfig_guaguaka_current_day_tongyong2_from }" escapeXml="true"/>" class="digits"    >
				</dd> 
				<dd style="width: 50px;" >
					元 到
				</dd>
				<dd  style="width: 70px;">
					<input type="hidden"  name="name"  value="guaguaka_current_day_tongyong2_to" > 
					<input style="width: 60px;" type="text" name="guaguaka_current_day_tongyong2_to" value="<c:out value="${webConfig_guaguaka_current_day_tongyong2_to }" escapeXml="true"/>" class="digits"    >
				</dd>
				<dd style="width: 30px;" >
					元
				</dd>
				<dd style="width: 60px;" >
					中奖几率
				</dd>
				<dd  style="width: 70px;">
					<input type="hidden"  name="name"  value="guaguaka_current_day_tongyong2_jilv" > 
					<input style="width: 60px;" type="text" name="guaguaka_current_day_tongyong2_jilv" value="<c:out value="${webConfig_guaguaka_current_day_tongyong2_jilv }" escapeXml="true"/>" class="digits"    >
				</dd>
				<dd style="width: 20px;" >
					%
				</dd>
			</dl>  
			 -->
			<div class="divider"></div> 
			<dl>
				<dd style="text-align: center;width: 100%;">
					非活动当天奖品和几率
				</dd>
			</dl> 
			<div class="divider"></div> 
			<dl class="nowrap">
				<dt style="width: 20px;"  >从</dt>
				<dd style="width: 70px;" >
					<input type="hidden"  name="name"  value="guaguaka_other_day_tongyong1_from" > 
					<input style="width: 60px;" type="text" name="guaguaka_other_day_tongyong1_from" value="<c:out value="${webConfig_guaguaka_other_day_tongyong1_from }" escapeXml="true"/>" class="digits"    >
				</dd> 
				<dd style="width: 50px;" >
					元 到
				</dd>
				<dd  style="width: 70px;">
					<input type="hidden"  name="name"  value="guaguaka_other_day_tongyong1_to" > 
					<input style="width: 60px;" type="text" name="guaguaka_other_day_tongyong1_to" value="<c:out value="${webConfig_guaguaka_other_day_tongyong1_to }" escapeXml="true"/>" class="digits"    >
				</dd>
				<dd style="width: 30px;" >
					元
				</dd>
				<dd style="width: 60px;" >
					中奖几率
				</dd>
				<dd  style="width: 70px;">
					<input type="hidden"  name="name"  value="guaguaka_other_day_tongyong1_jilv" > 
					<input style="width: 60px;" type="text" name="guaguaka_other_day_tongyong1_jilv" value="<c:out value="${webConfig_guaguaka_other_day_tongyong1_jilv }" escapeXml="true"/>" class="digits"    >
				</dd>
				<dd style="width: 20px;" >
					%
				</dd>
			</dl>  
			<div class="divider"></div> 
			<dl>
				<dt style="font-size: 0.6rem;" >定向红包几率</dt>
				<dd style="width: 60px;">
					<input type="hidden"  name="name"  value="guaguaka_other_day_dingxiang_jilv" > 
					<input style="width: 50px;" type="text" name="guaguaka_other_day_dingxiang_jilv" value="<c:out value="${webConfig_guaguaka_other_day_dingxiang_jilv }" escapeXml="true"/>"   >
				</dd>
				<dd style="width:50px;">
					%
				</dd>
			</dl> 
			<dl>
				<dt style="font-size: 0.6rem;" >iPhone x</dt>
				<dd style="width: 60px;">
					<input type="hidden"  name="name"  value="guaguaka_other_day_iphonex_jilv" > 
					<input style="width: 50px;" type="text" name="guaguaka_other_day_iphonex_jilv" value="<c:out value="${webConfig_guaguaka_other_day_iphonex_jilv }" escapeXml="true"/>"   >
				</dd>
				<dd style="width:50px;">
					%
				</dd>
			</dl> 
			<div class="divider"></div> 
			<dl>
				<dt style="font-size: 0.6rem;" >8888元通用红包</dt>
				<dd style="width: 60px;">
					<input type="hidden"  name="name"  value="guaguaka_other_day_8888_jilv" > 
					<input style="width: 50px;" type="text" name="guaguaka_other_day_8888_jilv" value="<c:out value="${webConfig_guaguaka_other_day_8888_jilv }" escapeXml="true"/>"   >
				</dd>
				<dd style="width:50px;">
					%
				</dd>
			</dl> 
			<div class="divider"></div> 
			<dl class="nowrap">
				<dt style="width: 20px;"  >从</dt>
				<dd style="width: 70px;" >
					<input type="hidden"  name="name"  value="guaguaka_other_day_tongyong2_from" > 
					<input style="width: 60px;" type="text" name="guaguaka_other_day_tongyong2_from" value="<c:out value="${webConfig_guaguaka_other_day_tongyong2_from }" escapeXml="true"/>" class="digits"    >
				</dd> 
				<dd style="width: 50px;" >
					元 到
				</dd>
				<dd  style="width: 70px;">
					<input type="hidden"  name="name"  value="guaguaka_other_day_tongyong2_to" > 
					<input style="width: 60px;" type="text" name="guaguaka_other_day_tongyong2_to" value="<c:out value="${webConfig_guaguaka_other_day_tongyong2_to }" escapeXml="true"/>" class="digits"    >
				</dd>
				<dd style="width: 30px;" >
					元
				</dd>
				<dd style="width: 60px;" >
					中奖几率
				</dd>
				<dd  style="width: 70px;">
					<input type="hidden"  name="name"  value="guaguaka_other_day_tongyong2_jilv" > 
					<input style="width: 60px;" type="text" name="guaguaka_other_day_tongyong2_jilv" value="<c:out value="${webConfig_guaguaka_other_day_tongyong2_jilv }" escapeXml="true"/>" class="digits"    >
				</dd>
				<dd style="width: 20px;" >
					%
				</dd>
			</dl>  
			<div class="divider"></div> 
			<dl>
				<dt style="font-size: 0.8rem;" >未中奖几率</dt>
				<dd style="width: 60px;">
					<input type="hidden"  name="name"  value="guaguaka_other_day_weizhongjiang_jilv" > 
					<input style="width: 50px;" type="text" name="guaguaka_other_day_weizhongjiang_jilv" value="<c:out value="${webConfig_guaguaka_other_day_weizhongjiang_jilv }" escapeXml="true"/>"  class="digits" >
				</dd>
				<dd style="width:50px;">
					%
				</dd>
			</dl> 
			<dl>
				<dt style="width: 120px;" >每天发定向红包数</dt>
				<dd style="width: 60px;">
					<input type="hidden"  name="name"  value="guaguaka_other_day_evry_day_dingxiang_count" > 
					<input style="width: 50px;" type="text" name="guaguaka_other_day_evry_day_dingxiang_count" value="<c:out value="${webConfig_guaguaka_other_day_evry_day_dingxiang_count }" escapeXml="true"/>" class="digits"   >
				</dd>
				<dd style="width:20px;">
					个
				</dd>
			</dl> 
			<div class="divider"></div> 
			<dl>
				<dt style="width: 50px;" >用户每</dt>
				<dd style="width: 40px;">
					<input type="hidden"  name="name"  value="guaguaka_other_day_zhongjiang_tianshu" > 
					<input style="width:30px;" type="text" name="guaguaka_other_day_zhongjiang_tianshu" value="<c:out value="${webConfig_guaguaka_other_day_zhongjiang_tianshu }" escapeXml="true"/>" class="digits"   >
				</dd>
				<dd style="width:120px;">
					天可中奖一次
				</dd>
			</dl> 
		</fieldset>