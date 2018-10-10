<%@page import="com.lymava.commons.state.State"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
     <script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
		</script> 
   <div class="pageContent" id="${currentTimeMillis }"  >
   	<form method="post" action="${basePath }${baseRequestPath }save.do"class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone);">
		<div class="pageFormContent" layoutH="56"> 
			<fieldset style="height: ${pageContent_height-75}px;">
					<%@ include file="inc/edit_show_base.jsp" %>
					<div class="divider"></div>
					<dl>
						<dt>商户名称：</dt>
						<dd>
							${object.user_merchant.showName }
						</dd>
					</dl>
					<div class="divider"></div>
					<dl>
						<dt>产品编号：</dt>
						<dd>
							${object.product.bianhao }
						</dd>
					</dl>
					<div class="divider"></div>
					<dl>
						<dt>订单金额：</dt>
						<dd>
							${object.showPrice_fen_all/100}
						</dd>
					</dl> 
					<div class="divider"></div>  
					<dl>
						<dt>业务状态：</dt>
						<dd>
							<select name="state" class="combox" svalue="${object.state }">
			                    		<option    value="<%=State.STATE_OK %>" >已上菜</option>
			                    		<option    value="<%=State.STATE_WAITE_PROCESS %>" >等待确认</option>
			                    		<option    value="<%=State.STATE_INPROCESS %>" >已下厨</option>
			                    		<option  value="<%=State.STATE_CLOSED %>" >已取消</option>
							</select>
						</dd>
					</dl> 
			</fieldset>
		</div>
		<div class="formBar">
			<ul>
				<li><div class="buttonActive"><div class="buttonContent"><button type="submit">保存</button></div></div></li>
				<li>
					<div class="button"><div class="buttonContent"><button type="button" class="close">取消</button></div></div>
				</li>
			</ul>
		</div>
	</form>
</div>