<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.qier.action.MerchantShowAction"%>
<%@page import="com.lymava.trade.business.model.Address"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
     <script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
		</script>
   <div  class="pageContent" id="${currentTimeMillis }"  >
   <form method="post" action="${basePath }${baseRequestPath }save.do"class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone);">
	   <input type="hidden" name="object.id"  value="<c:out value="${object.id }" escapeXml="true"/>" />
		<div class="pageFormContent" > 
			<fieldset>
				<dl>
					<dt>活动名称</dt>
					<dd>
						<input type="text" name="object.name" value="<c:out value="${object.name }" escapeXml="true"/>" class="required"   >
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
					<dt>每日可总数</dt>
					<dd>
						<input type="text" name="object.every_day_count" value="<c:out value="${object.every_day_count }" escapeXml="true"/>" class="digits"  >
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
					<dt>活动总数</dt>
					<dd>
						<input type="text" name="object.all_day_count" value="<c:out value="${object.all_day_count }" escapeXml="true"/>" class="digits"  >
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
					<dt>开始日期</dt>
					<dd>
						<input type="text" name="object.inStart_date" value="<c:out value="${object.showStart_date }" escapeXml="true"/>" class="date" dateFmt="yyyy-MM-dd HH:mm:ss" readonly="readonly" >
					</dd>
				</dl>
				<dl>
					<dt>结束日期</dt>
					<dd>
						<input type="text" name="object.inEnd_date" value="<c:out value="${object.showEnd_date }" escapeXml="true"/>" class="date" dateFmt="yyyy-MM-dd HH:mm:ss" readonly="readonly" >
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
					<dt>开始时间</dt>
					<dd>
						<input type="text" name="object.inDay_start_time" value="<c:out value="${object.showDay_start_time }" escapeXml="true"/><c:if test="${empty object.showDay_start_time }">00:00</c:if>" class="date" dateFmt="HH:mm" readonly="readonly" >
					</dd>
				</dl>
				<dl>
					<dt>结束时间</dt>
					<dd>
						<input type="text" name="object.inDay_end_time" value="<c:out value="${object.showDay_end_time }" escapeXml="true"/><c:if test="${empty object.showDay_end_time }">24:00</c:if>" class="date" dateFmt="HH:mm" readonly="readonly" >
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
					<dt>开始星期</dt>
					<dd>
						<select class="combox" name="object.start_week" svalue="${object.start_week }<c:if test="${empty object.start_week }">1</c:if>">
							<option value="1" >星期一</option>
							<option value="2" >星期二</option>
							<option value="3" >星期三</option>
							<option value="4" >星期四</option>
							<option value="5" >星期五</option>
							<option value="6" >星期六</option>
							<option value="7" >星期天</option>
						</select>
					</dd>
				</dl>
				<dl>
					<dt>结束星期</dt>
					<dd>	
						<select class="combox" name="object.end_week" svalue="${object.end_week }<c:if test="${empty object.end_week }">7</c:if>">
							<option value="1" >星期一</option>
							<option value="2" >星期二</option>
							<option value="3" >星期三</option>
							<option value="4" >星期四</option>
							<option value="5" >星期五</option>
							<option value="6" >星期六</option>
							<option value="7" >星期天</option>
						</select>
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
					<dt>未开始提醒</dt>
					<dd>
						<input type="text" name="object.not_start_message" value="<c:out value="${object.not_start_message }" escapeXml="true"/>"    >
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
					<dt>已结束提醒</dt>
					<dd>
						<input type="text" name="object.had_end_message" value="<c:out value="${object.had_end_message }" escapeXml="true"/>"   >
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
					<dt>状态：</dt>
					<dd>
						<select class="combox"  name="object.state" svalue="${object.state }">
							<option value="<%=State.STATE_OK %>"  >正常</option>
							<option value="<%=State.STATE_FALSE %>" >异常</option>
						</select>
					</dd>
				</dl>
				 
			</fieldset>
		</div>
		<div class="formBar">
			<ul>
				<li><div class="buttonActive"><div class="buttonContent"><button type="submit">保存</button></div></div></li>
				<li>
					<div class="button"><div class="buttonContent"><button type="button" class="close">关闭</button></div></div>
				</li>
			</ul>
		</div>
	</form>
</div>