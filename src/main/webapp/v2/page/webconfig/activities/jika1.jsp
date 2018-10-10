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
				<dt style="font-size: 0.6rem;" >羊排优惠券上限</dt>
				<dd>
					<input type="hidden"  name="name"  value="jika_relife_count" >
					<input type="text" name="jika_relife_count" value="<c:out value="${webConfig_jika_relife_count }" escapeXml="true"/>"   >
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>活动开始</dt>
				<dd>
					<input type="hidden"  name="name"  value="jika_startTime" >
					<input type="text" name="jika_startTime" value="<c:out value="${webConfig_jika_startTime }" escapeXml="true"/>"  class="date" dateFmt="yyyy-MM-dd HH:mm:ss"  >
				</dd>
			</dl>
			<dl>
				<dt>活动结束</dt>
				<dd>
					<input type="hidden"  name="name"  value="jika_endTime" >
					<input type="text" name="jika_endTime" value="<c:out value="${webConfig_jika_endTime }" escapeXml="true"/>"  class="date" dateFmt="yyyy-MM-dd HH:mm:ss" >
				</dd>
			</dl>
			<%--<div class="divider"></div> --%>
			<%--<dl>--%>
				<%--<dt>回复口令</dt>--%>
				<%--<dd>--%>
					<%--<input type="hidden"  name="name"  value="caididian_text_kouling" > --%>
					<%--<input type="text" name="caididian_text_kouling" value="<c:out value="${webConfig_caididian_text_kouling }" escapeXml="true"/>"   >--%>
				<%--</dd>--%>
			<%--</dl>--%>
			<%--<dl>--%>
				<%--<dt>文字回复</dt>--%>
				<%--<dd>--%>
					<%--<input type="hidden"  name="name"  value="caididian_text_send_message" > --%>
					<%--<input type="text" name="caididian_text_send_message" value="<c:out value="${webConfig_caididian_text_send_message }" escapeXml="true"/>"   >--%>
				<%--</dd>--%>
			<%--</dl>--%>
			<%--<div class="divider"></div> --%>
			<%--<dl>--%>
				<%--<dt style="font-size: 0.6rem;" >今日已领完提醒</dt>--%>
				<%--<dd>--%>
					<%--<input type="hidden"  name="name"  value="caididian_today_is_finish_message" > --%>
					<%--<input type="text" name="caididian_today_is_finish_message" value="<c:out value="${webConfig_caididian_today_is_finish_message }" escapeXml="true"/>"   >--%>
				<%--</dd>--%>
			<%--</dl> --%>
			<%--<dl>--%>
				<%--<dt style="font-size: 0.6rem;" >已领完提醒</dt>--%>
				<%--<dd>--%>
					<%--<input type="hidden"  name="name"  value="caididian_all_is_finish_message" > --%>
					<%--<input type="text" name="caididian_all_is_finish_message" value="<c:out value="${webConfig_caididian_all_is_finish_message }" escapeXml="true"/>"   >--%>
				<%--</dd>--%>
			<%--</dl>--%>
			<%--<div class="divider"></div>--%>
			<%--<dl>--%>
				<%--<dt style="font-size: 0.6rem;" >6.66元总数</dt>--%>
				<%--<dd>--%>
					<%--<input type="hidden"  name="name"  value="caididian_666_count" >--%>
					<%--<input type="text" name="caididian_666_count" value="<c:out value="${webConfig_caididian_666_count }" escapeXml="true"/>"   >--%>
				<%--</dd>--%>
			<%--</dl>--%>
			<%--<dl>--%>
				<%--<dt style="font-size: 0.6rem;" >1.66元总数</dt>--%>
				<%--<dd>--%>
					<%--<input type="hidden"  name="name"  value="caididian_166_count" >--%>
					<%--<input type="text" name="caididian_166_count" value="<c:out value="${webConfig_caididian_166_count }" escapeXml="true"/>"   >--%>
				<%--</dd>--%>
			<%--</dl>--%>
		<%--
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
					<input type="hidden"  name="name"  value="caididian_current_day_tongyong1_from" > 
					<input style="width: 60px;" type="text" name="caididian_current_day_tongyong1_from" value="<c:out value="${webConfig_caididian_current_day_tongyong1_from }" escapeXml="true"/>" class="digits"    >
				</dd> 
				<dd style="width: 50px;" >
					元 到
				</dd>
				<dd  style="width: 70px;">
					<input type="hidden"  name="name"  value="caididian_current_day_tongyong1_to" > 
					<input style="width: 60px;" type="text" name="caididian_current_day_tongyong1_to" value="<c:out value="${webConfig_caididian_current_day_tongyong1_to }" escapeXml="true"/>" class="digits"    >
				</dd>
				<dd style="width: 30px;" >
					元
				</dd>
				<dd style="width: 60px;" >
					中奖几率
				</dd>
				<dd  style="width: 70px;">
					<input type="hidden"  name="name"  value="caididian_current_day_tongyong1_jilv" > 
					<input style="width: 60px;" type="text" name="caididian_current_day_tongyong1_jilv" value="<c:out value="${webConfig_caididian_current_day_tongyong1_jilv }" escapeXml="true"/>" class="digits"    >
				</dd>
				<dd style="width: 20px;" >
					%
				</dd>
			</dl>  
			<div class="divider"></div> 
			<dl>
				<dt style="font-size: 0.6rem;" >定向红包几率</dt>
				<dd style="width: 60px;">
					<input type="hidden"  name="name"  value="caididian_current_day_dingxiang_jilv" > 
					<input style="width: 50px;" type="text" name="caididian_current_day_dingxiang_jilv" value="<c:out value="${webConfig_caididian_current_day_dingxiang_jilv }" escapeXml="true"/>"   >
				</dd>
				<dd style="width:50px;">
					%
				</dd>
			</dl> 
			<dl>
				<dt style="font-size: 0.6rem;" >iPhone x</dt>
				<dd style="width: 60px;">
					<input type="hidden"  name="name"  value="caididian_current_day_iphonex_jilv" > 
					<input style="width: 50px;" type="text" name="caididian_current_day_iphonex_jilv" value="<c:out value="${webConfig_caididian_current_day_iphonex_jilv }" escapeXml="true"/>"   >
				</dd>
				<dd style="width:50px;">
					%
				</dd>
			</dl> 
			<div class="divider"></div> 
			<dl>
				<dt style="font-size: 0.6rem;" >8888元通用红包</dt>
				<dd style="width: 60px;">
					<input type="hidden"  name="name"  value="caididian_current_day_8888_jilv" > 
					<input style="width: 50px;" type="text" name="caididian_current_day_8888_jilv" value="<c:out value="${webConfig_caididian_current_day_8888_jilv }" escapeXml="true"/>"   >
				</dd>
				<dd style="width:50px;">
					%
				</dd>
			</dl> 
			<div class="divider"></div> 
			<dl class="nowrap">
				<dt style="width: 20px;"  >从</dt>
				<dd style="width: 70px;" >
					<input type="hidden"  name="name"  value="caididian_current_day_tongyong2_from" > 
					<input style="width: 60px;" type="text" name="caididian_current_day_tongyong2_from" value="<c:out value="${webConfig_caididian_current_day_tongyong2_from }" escapeXml="true"/>" class="digits"    >
				</dd> 
				<dd style="width: 50px;" >
					元 到
				</dd>
				<dd  style="width: 70px;">
					<input type="hidden"  name="name"  value="caididian_current_day_tongyong2_to" > 
					<input style="width: 60px;" type="text" name="caididian_current_day_tongyong2_to" value="<c:out value="${webConfig_caididian_current_day_tongyong2_to }" escapeXml="true"/>" class="digits"    >
				</dd>
				<dd style="width: 30px;" >
					元
				</dd>
				<dd style="width: 60px;" >
					中奖几率
				</dd>
				<dd  style="width: 70px;">
					<input type="hidden"  name="name"  value="caididian_current_day_tongyong2_jilv" > 
					<input style="width: 60px;" type="text" name="caididian_current_day_tongyong2_jilv" value="<c:out value="${webConfig_caididian_current_day_tongyong2_jilv }" escapeXml="true"/>" class="digits"    >
				</dd>
				<dd style="width: 20px;" >
					%
				</dd>
			</dl>  
			 --%>
			<%--<div class="divider"></div>
			<dl>
				<dd style="text-align: center;width: 100%;">
					非活动当天奖品和几率
				</dd>
			</dl>
			<div class="divider"></div>
			<dl class="nowrap">
				<dt style="width: 20px;"  >从</dt>
				<dd style="width: 70px;" >
					<input type="hidden"  name="name"  value="caididian_other_day_tongyong1_from" >
					<input style="width: 60px;" type="text" name="caididian_other_day_tongyong1_from" value="<c:out value="${webConfig_caididian_other_day_tongyong1_from }" escapeXml="true"/>" class="digits"    >
				</dd>
				<dd style="width: 50px;" >
					元 到
				</dd>
				<dd  style="width: 70px;">
					<input type="hidden"  name="name"  value="caididian_other_day_tongyong1_to" >
					<input style="width: 60px;" type="text" name="caididian_other_day_tongyong1_to" value="<c:out value="${webConfig_caididian_other_day_tongyong1_to }" escapeXml="true"/>" class="digits"    >
				</dd>
				<dd style="width: 30px;" >
					元
				</dd>
				<dd style="width: 60px;" >
					中奖几率
				</dd>
				<dd  style="width: 70px;">
					<input type="hidden"  name="name"  value="caididian_other_day_tongyong1_jilv" >
					<input style="width: 60px;" type="text" name="caididian_other_day_tongyong1_jilv" value="<c:out value="${webConfig_caididian_other_day_tongyong1_jilv }" escapeXml="true"/>" class="digits"    >
				</dd>
				<dd style="width: 20px;" >
					%
				</dd>
			</dl>
			<div class="divider"></div>
			<dl>
				<dt style="font-size: 0.6rem;" >定向红包几率</dt>
				<dd style="width: 60px;">
					<input type="hidden"  name="name"  value="caididian_other_day_dingxiang_jilv" >
					<input style="width: 50px;" type="text" name="caididian_other_day_dingxiang_jilv" value="<c:out value="${webConfig_caididian_other_day_dingxiang_jilv }" escapeXml="true"/>"   >
				</dd>
				<dd style="width:50px;">
					%
				</dd>
			</dl>
			<dl>
				<dt style="font-size: 0.6rem;" >iPhone x</dt>
				<dd style="width: 60px;">
					<input type="hidden"  name="name"  value="caididian_other_day_iphonex_jilv" >
					<input style="width: 50px;" type="text" name="caididian_other_day_iphonex_jilv" value="<c:out value="${webConfig_caididian_other_day_iphonex_jilv }" escapeXml="true"/>"   >
				</dd>
				<dd style="width:50px;">
					%
				</dd>
			</dl>
			<div class="divider"></div>
			<dl>
				<dt style="font-size: 0.6rem;" >8888元通用红包</dt>
				<dd style="width: 60px;">
					<input type="hidden"  name="name"  value="caididian_other_day_8888_jilv" >
					<input style="width: 50px;" type="text" name="caididian_other_day_8888_jilv" value="<c:out value="${webConfig_caididian_other_day_8888_jilv }" escapeXml="true"/>"   >
				</dd>
				<dd style="width:50px;">
					%
				</dd>
			</dl>
			<div class="divider"></div>
			<dl class="nowrap">
				<dt style="width: 20px;"  >从</dt>
				<dd style="width: 70px;" >
					<input type="hidden"  name="name"  value="caididian_other_day_tongyong2_from" >
					<input style="width: 60px;" type="text" name="caididian_other_day_tongyong2_from" value="<c:out value="${webConfig_caididian_other_day_tongyong2_from }" escapeXml="true"/>" class="digits"    >
				</dd>
				<dd style="width: 50px;" >
					元 到
				</dd>
				<dd  style="width: 70px;">
					<input type="hidden"  name="name"  value="caididian_other_day_tongyong2_to" >
					<input style="width: 60px;" type="text" name="caididian_other_day_tongyong2_to" value="<c:out value="${webConfig_caididian_other_day_tongyong2_to }" escapeXml="true"/>" class="digits"    >
				</dd>
				<dd style="width: 30px;" >
					元
				</dd>
				<dd style="width: 60px;" >
					中奖几率
				</dd>
				<dd  style="width: 70px;">
					<input type="hidden"  name="name"  value="caididian_other_day_tongyong2_jilv" >
					<input style="width: 60px;" type="text" name="caididian_other_day_tongyong2_jilv" value="<c:out value="${webConfig_caididian_other_day_tongyong2_jilv }" escapeXml="true"/>" class="digits"    >
				</dd>
				<dd style="width: 20px;" >
					%
				</dd>
			</dl>
			<div class="divider"></div>
			<dl>
				<dt style="font-size: 0.8rem;" >未中奖几率</dt>
				<dd style="width: 60px;">
					<input type="hidden"  name="name"  value="caididian_other_day_weizhongjiang_jilv" >
					<input style="width: 50px;" type="text" name="caididian_other_day_weizhongjiang_jilv" value="<c:out value="${webConfig_caididian_other_day_weizhongjiang_jilv }" escapeXml="true"/>"  class="digits" >
				</dd>
				<dd style="width:50px;">
					%
				</dd>
			</dl>
			<dl>
				<dt style="width: 120px;" >每天发定向红包数</dt>
				<dd style="width: 60px;">
					<input type="hidden"  name="name"  value="caididian_other_day_evry_day_dingxiang_count" >
					<input style="width: 50px;" type="text" name="caididian_other_day_evry_day_dingxiang_count" value="<c:out value="${webConfig_caididian_other_day_evry_day_dingxiang_count }" escapeXml="true"/>" class="digits"   >
				</dd>
				<dd style="width:20px;">
					个
				</dd>
			</dl>
			<div class="divider"></div>
			<dl>
				<dt style="width: 50px;" >用户每</dt>
				<dd style="width: 40px;">
					<input type="hidden"  name="name"  value="caididian_other_day_zhongjiang_tianshu" >
					<input style="width:30px;" type="text" name="caididian_other_day_zhongjiang_tianshu" value="<c:out value="${webConfig_caididian_other_day_zhongjiang_tianshu }" escapeXml="true"/>" class="digits"   >
				</dd>
				<dd style="width:120px;">
					天可中奖一次
				</dd>
			</dl> --%>
		</fieldset>