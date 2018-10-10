<%@page import="com.lymava.base.model.User"%>
<%@page import="com.lymava.base.model.Pub"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<fieldset >
			<dl>
				<dt>活动红包：</dt>
				<dd>
					<input type="hidden"  name="name"  value="618_amount_yuan" > 
					<input type="text" name="618_amount_yuan" value="<c:out value="${webConfig_618_amount_yuan }" escapeXml="true"/>"  class="number" >
				</dd>
			</dl>
			<dl>
				<dt>每日红包总数：</dt>
				<dd>
					<input type="hidden"  name="name"  value="618_every_day_count" > 
					<input type="text" name="618_every_day_count" value="<c:out value="${webConfig_618_every_day_count }" escapeXml="true"/>"  class="number" >
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>活动开始</dt>
				<dd>
					<input type="hidden"  name="name"  value="startTime_618_do" > 
					<input type="text" name="startTime_618_do" value="<c:out value="${webConfig_startTime_618_do }" escapeXml="true"/>"  class="date" dateFmt="yyyy-MM-dd HH:mm:ss"  >
				</dd>
			</dl>
			<dl>
				<dt>活动结束</dt>
				<dd>
					<input type="hidden"  name="name"  value="endTime_618_do" > 
					<input type="text" name="endTime_618_do" value="<c:out value="${webConfig_endTime_618_do }" escapeXml="true"/>"  class="date" dateFmt="yyyy-MM-dd HH:mm:ss" >
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt style="font-size: 0.5rem;" >未开始提醒</dt>
				<dd>
					<input type="hidden"  name="name"  value="activities_not_start_618" > 
					<input type="text" name="activities_not_start_618" value="<c:out value="${webConfig_activities_not_start_618 }" escapeXml="true"/>"   >
				</dd>
			</dl>
			<dl>
				<dt style="font-size: 0.5rem;" >已结束提醒</dt>
				<dd>
					<input type="hidden"  name="name"  value="activities_had_end_618" > 
					<input type="text" name="activities_had_end_618" value="<c:out value="${webConfig_activities_had_end_618 }" escapeXml="true"/>"  >
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt style="font-size: 0.5rem;" >今日已领完提醒</dt>
				<dd>
					<input type="hidden"  name="name"  value="today_is_finish_618" > 
					<input type="text" name="today_is_finish_618" value="<c:out value="${webConfig_today_is_finish_618 }" escapeXml="true"/>"   >
				</dd>
			</dl> 
			<div class="divider"></div> 
			<dl>
				<dt>有效期从</dt>
				<dd>
					<input type="hidden"  name="name"  value="startTime_618" > 
					<input type="text" name="startTime_618" value="<c:out value="${webConfig_startTime_618 }" escapeXml="true"/>"  class="date" dateFmt="yyyy-MM-dd HH:mm:ss" >
				</dd>
			</dl>
			<dl>
				<dt>有效期至</dt>
				<dd>
					<input type="hidden"  name="name"  value="endTime_618" > 
					<input type="text" name="endTime_618" value="<c:out value="${webConfig_endTime_618 }" escapeXml="true"/>"  class="date" dateFmt="yyyy-MM-dd HH:mm:ss" >
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>推文标题：</dt>
				<dd>
					<input type="hidden"  name="name"  value="618_tuiwen_title" > 
					<input type="text" name="618_tuiwen_title" value="<c:out value="${webConfig_618_tuiwen_title }" escapeXml="true"/>"   >
				</dd>
			</dl>
			<dl>
				<dt>推文内容：</dt>
				<dd>
					<input type="hidden"  name="name"  value="618_tuiwen_content" > 
					<input type="text" name="618_tuiwen_content" value="<c:out value="${webConfig_618_tuiwen_content }" escapeXml="true"/>"   >
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl class="nowrap">
				<dt style="font-size: 0.5rem;">红包发放成功消息：</dt>
				<dd>
					<input type="hidden"  name="name"  value="618_get_red_success_message" > 
					<textarea name="618_get_red_success_message"  style="width: 300px;height: 100px;"><c:out value="${webConfig_618_get_red_success_message }" escapeXml="true"/></textarea>
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl >
				<dt>推文链接：</dt>
				<dd >
						<input type="hidden"  name="name"  value="618_tuiwen_link" > 
						<input type="text" name="618_tuiwen_link" value="<c:out value="${webConfig_618_tuiwen_link }" escapeXml="true"/>"   >
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl class="nowrap">
				<dt>推文图：</dt>
				<dd >
						<input type="hidden"  name="name"  value="618_tuiwen_pic" > 
						<input type="hidden"  name="618_tuiwen_pic" value="<c:out value="${webConfig_618_tuiwen_pic}" escapeXml="true"/>"   class="mydisupload"   fileNumLimit="1"  >
				</dd>
			</dl>
		</fieldset>