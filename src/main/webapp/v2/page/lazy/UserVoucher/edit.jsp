<%@page import="com.lymava.trade.business.model.Address"%>
<%@page import="com.lymava.base.vo.State"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
     <script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
		</script>
   <div  class="pageContent" id="${currentTimeMillis }"  >
   <form method="post" action="${basePath }${baseRequestPath }save.do"class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone);">
		<div class="pageFormContent" layoutH="56"> 
			<fieldset  > 
					<dl >
						<dt>会员：</dt>
						<dd class="lookup_dd">
							<c:out value="${object.user_huiyuan.third_user_id }" escapeXml="true"/> 
							<input type="hidden" name="object.id"  value="<c:out value="${object.id }" escapeXml="true"/>" />
						</dd>
					</dl>
					<div class="divider"></div>
					<dl>
						<dt>代金券名称：</dt>
						<dd>
							<c:out value="${object.voucher.voucherName }" escapeXml="true"/>
						</dd>
					</dl>
					<div class="divider"></div>
					<dl >
						<dt>发放商家：</dt>
						<dd class="lookup_dd">
							${object.user_merchant.showName }
						</dd>
					</dl>
					<div class="divider"></div>
					<dl>
						<dt>价值：</dt>
						<dd>
							<c:out value="${object.voucher.voucherValue }" escapeXml="true"/>
						</dd>
					</dl>  
					<dl>
						<dt>使用条件：</dt>
						<dd>
							<c:out value="${object.voucher.useWhere }" escapeXml="true"/>
						</dd>
					</dl> 
					<div class="divider"></div> 
					<dl >
						<dt>状态：</dt>
						<dd> 
							<select class="combox" name="object.useState" svalue="${object.useState }">
										<option value="<%=State.STATE_OK %>">正常</option>							
										<option value="<%=State.STATE_FALSE %>">不能使用</option>
										<option value="<%=State.STATE_CLOSED %>">已过期</option>
										<option value="<%=State.STATE_PAY_SUCCESS %>">已使用</option>
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