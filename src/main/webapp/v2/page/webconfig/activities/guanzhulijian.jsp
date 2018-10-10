<%@page import="com.lymava.base.model.User"%>
<%@page import="com.lymava.base.model.Pub"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<fieldset >
			<dl>
				<dt>红包金额</dt>
				<dd>
					<input type="hidden"  name="name"  value="guanzhulijian_amount_yuan" > 
					<input type="text" name="guanzhulijian_amount_yuan" value="<c:out value="${webConfig_guanzhulijian_amount_yuan }" escapeXml="true"/>"  class="number" >
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>每日总数：</dt>
				<dd>
					<input type="hidden"  name="name"  value="guanzhulijian_every_day_count" > 
					<input type="text" name="guanzhulijian_every_day_count" value="<c:out value="${webConfig_guanzhulijian_every_day_count }" escapeXml="true"/>"  class="number" >
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>活动总数</dt>
				<dd>
					<input type="hidden"  name="name"  value="guanzhulijian_all_day_count" > 
					<input type="text" name="guanzhulijian_all_day_count" value="<c:out value="${webConfig_guanzhulijian_all_day_count }" escapeXml="true"/>"  class="number" >
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>活动开始</dt>
				<dd>
					<input type="hidden"  name="name"  value="startTime_guanzhulijian" > 
					<input type="text" name="startTime_guanzhulijian" value="<c:out value="${webConfig_startTime_guanzhulijian }" escapeXml="true"/>"  class="date" dateFmt="yyyy-MM-dd HH:mm:ss"  >
				</dd>
			</dl>
			<dl>
				<dt>活动结束</dt>
				<dd>
					<input type="hidden"  name="name"  value="endTime_guanzhulijian" > 
					<input type="text" name="endTime_guanzhulijian" value="<c:out value="${webConfig_endTime_guanzhulijian }" escapeXml="true"/>"  class="date" dateFmt="yyyy-MM-dd HH:mm:ss" >
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>有效期从</dt>
				<dd>
					<input type="hidden"  name="name"  value="startTime_guanzhulijian" > 
					<input type="text" name="startTime_guanzhulijian" value="<c:out value="${webConfig_startTime_guanzhulijian }" escapeXml="true"/>"  class="date" dateFmt="yyyy-MM-dd HH:mm:ss" >
				</dd>
			</dl>
			<dl>
				<dt>有效期至</dt>
				<dd>
					<input type="hidden"  name="name"  value="endTime_guanzhulijian" > 
					<input type="text" name="endTime_guanzhulijian" value="<c:out value="${webConfig_endTime_guanzhulijian }" escapeXml="true"/>"  class="date" dateFmt="yyyy-MM-dd HH:mm:ss" >
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>推文标题：</dt>
				<dd>
					<input type="hidden"  name="name"  value="guanzhulijian_tuiwen_title" > 
					<input type="text" name="guanzhulijian_tuiwen_title" value="<c:out value="${webConfig_guanzhulijian_tuiwen_title }" escapeXml="true"/>"   >
				</dd>
			</dl>
			<dl>
				<dt>推文内容：</dt>
				<dd>
					<input type="hidden"  name="name"  value="guanzhulijian_tuiwen_content" > 
					<input type="text" name="guanzhulijian_tuiwen_content" value="<c:out value="${webConfig_guanzhulijian_tuiwen_content }" escapeXml="true"/>"   >
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl class="nowrap">
				<dt>推文图：</dt>
				<dd >
						<input type="hidden"  name="name"  value="guanzhulijian_tuiwen_pic" > 
						<input type="hidden"  name="guanzhulijian_tuiwen_pic" value="<c:out value="${webConfig_guanzhulijian_tuiwen_pic}" escapeXml="true"/>"   class="mydisupload"   fileNumLimit="1"  >
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt style="font-size: 0.5rem;" >今日已领完提醒</dt>
				<dd>
					<input type="hidden"  name="name"  value="today_is_finish_guanzhulijian_message" > 
					<input type="text" name="today_is_finish_guanzhulijian_message" value="<c:out value="${webConfig_today_is_finish_guanzhulijian_message }" escapeXml="true"/>"   >
				</dd>
			</dl> 
			<div class="divider"></div> 
			<dl>
				<dt style="font-size: 0.5rem;" >已领完提醒</dt>
				<dd>
					<input type="hidden"  name="name"  value="guanzhulijian_all_is_finish_message" > 
					<input type="text" name="guanzhulijian_all_is_finish_message" value="<c:out value="${webConfig_guanzhulijian_all_is_finish_message }" escapeXml="true"/>"   >
				</dd>
			</dl> 
		</fieldset>