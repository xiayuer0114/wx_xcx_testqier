<%@page import="com.lymava.qier.action.CashierAction"%>
<%@page import="com.lymava.base.vo.State"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
     <script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
					function exeport_create_call_back(msg){
						var res = json2obj(msg);
						var statusCode = res.statusCode;
						
						if(statusCode == "200" ){
								var data = res.data;
								var fileName = data.fileName;
								window.location.href = basePath+fileName+"?r="+new Date().getTime();
						}else{
							 alertMsg.warn(res.message); 
						}
					}
		</script> 
   <div  class="pageContent" id="${currentTimeMillis }"  >
   <form method="post" action="${basePath }${baseRequestPath }list.do"class="pageForm required-validate" onsubmit="return validateCallback(this,exeport_create_call_back);">
   <input type="hidden" name="return_mod"  value="excel">
		<div class="pageFormContent" layoutH="56"> 
			<fieldset  > 
					<dl>
						<dt>商户：</dt>
						<dd  class="lookup_dd">
							<input type="text"  bringBack="user_merchant.userShowName" value="<c:out value="${object.user_merchant.showName }" escapeXml="true"/>"   readonly="readonly" > 
							<input type="hidden" name="userId_merchant" bringBack="user_merchant.userId" value="${object.userId_merchant }"    >
							 <a    class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%=CashierAction.getMerchantUserGroutId() %>" lookupGroup="user_merchant"  rel="user_merchant_lookup">查找</a>
						</dd>
					</dl>
					<div class="divider"></div>
					<dl>
						<dt>业务：</dt>
						<dd  class="lookup_dd">
							<input id="business_businessName" type="text"  bringBack="businessRecord.businessName"  value="<c:out value="${object.business.businessName }" escapeXml="true"/>" readonly="readonly"  >
							<input id="businessIntId" type="hidden" name="businessIntId" bringBack="businessRecord.businessIntId"  value="<c:out value="${object.businessIntId }" escapeXml="true"/>"  >
							<a  href="${basePath }v2/business/list.do?return_mod=lookup" class="btnLook"  lookupgroup="businessRecord">查找</a>
						</dd>
					</dl>
					<div class="divider"></div>  
					<dl>
						<dt>开始时间：</dt>
						<dd  >
							<input name="startTime" value="${startTime }"  type="text" class="date" dateFmt="yyyy-MM-dd HH:mm:ss"  />
						</dd>
					</dl>
					<div class="divider"></div>  
					<dl>
						<dt>结束时间：</dt>
						<dd  >
							<input name="endTime" value="${endTime }"  type="text" class="date" dateFmt="yyyy-MM-dd HH:mm:ss"   />
						</dd>
					</dl>
					<div class="divider"></div>  
					<dl>
						<dt   >状态</dt>
						<dd  >
							<select name="state" class="combox" svalue="${object.state }">
										<option    value="-1" >不限</option>
			                    		<option    value="<%=State.STATE_FALSE %>" >失败</option>
			                    		<option  value="<%=State.STATE_INPROCESS %>" >进行中</option>
			                    		<option  value="<%=State.STATE_REFUND_OK %>" >已退款</option>
			                    		<option  value="<%=State.STATE_WAITE_PAY %>" >等待付款</option>
			                    		<option  value="<%=State.STATE_PAY_SUCCESS %>" >支付成功</option>
			                    		<option  value="<%=State.STATE_WAITE_WAITSENDGOODS %>" >等待发货</option>
			                    		<option  value="<%=State.STATE_CLOSED %>" >交易关闭</option>
			                    		<option    value="<%=State.STATE_OK %>" >交易成功</option>
							</select> 
						</dd>
					</dl>
					<div class="divider"></div>  
					<dl>
						<dt>导出数：</dt>
						<dd  >
							<input name="pageSize" value="50000"  type="text" class="digits"  />
						</dd>
					</dl>
			</fieldset>
		</div>
		<div class="formBar">
			<ul>
				<li><div class="buttonActive"><div class="buttonContent"><button type="submit">确认导出</button></div></div></li>
				<li>
					<div class="button"><div class="buttonContent"><button type="button" class="close">关闭</button></div></div>
				</li>
			</ul>
		</div>
	</form>
</div>