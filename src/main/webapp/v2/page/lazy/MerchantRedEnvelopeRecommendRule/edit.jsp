<%@page import="com.lymava.qier.action.CashierAction"%>
<%@page import="com.lymava.qier.action.MerchantShowAction"%>
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
						<dt>规则编号：</dt>
						<dd style="font-size: 0.8em;">
							<c:out value="${object.id }" escapeXml="true"/>
							<input type="hidden" name="object.id"  value="<c:out value="${object.id }" escapeXml="true"/>" />
						</dd>
					</dl>
					<div class="divider"></div>
					<dl>
						<dt>消费商家：</dt>

						<dd class="lookup_dd">
						<%-- 	<input type="hidden" name="object.id"  value="<c:out value="${object.id }" escapeXml="true"/>"> --%>
							<input type="text"   bringBack="user_merchant1.showName"   value="<c:out value="${object.user_merchant_xiaofei.showName} " escapeXml="true"/>"     >
							<input type="hidden"  bringBack="user_merchant1.userId"  name="object.user_merchant_xiaofei_id"  value="${object.user_merchant_xiaofei_id }" escapeXml="true"/>
							<a  class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%=CashierAction.getMerchantUserGroutId() %>" lookupGroup="user_merchant1"  rel="user_merchant_lookup">查找</a>
						</dd>
					</dl>
					<div class="divider"></div>
					
					<dl>
						<dt>红包商家：</dt>

						<dd class="lookup_dd">
							<%-- <input type="hidden" name="object.id"  value="<c:out value="${object.id }" escapeXml="true"/>"> --%>
							<input type="text"   bringBack="user_merchant2.showName"    value="<c:out value="${object.user_merchant_hongbao.showName}" escapeXml="true"/>"     >
							<input type="hidden"  bringBack="user_merchant2.userId"  name="object.user_merchant_hongbao_id"  value="${object.user_merchant_hongbao_id }" escapeXml="true"/>
							<a  class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%=CashierAction.getMerchantUserGroutId() %>" lookupGroup="user_merchant2"  rel="user_merchant_lookup">查找</a>
						</dd>
					</dl>
					<div class="divider"></div>
					
					
					<dl >
						<dt>规则状态</dt>
						<dd> 
							<select class="combox" name="object.state" svalue="${object.state }" >
									<option value="<%=State.STATE_OK %>">生效</option>							
									<option value="<%=State.STATE_CLOSED %>">失效</option>
							</select>
						</dd>
					</dl>
					<div class="divider"></div>
					
					
					<dl>
						<dt>生效开始时间</dt>

						<dd >
							<input type="text" name="object.start_time_shengxiao_str" value="${object.start_time_shengxiao_str }" class="required date" dateFmt="yyyy-MM-dd HH:mm:ss"  / >
						</dd>
					</dl>
					<div class="divider"></div>
					
					<dl>
						<dt>生效结束时间</dt>

						<dd >
							<input type="text" name="object.end_time_shengxiao_str" value="${object.end_time_shengxiao_str }"  class="required date" dateFmt="yyyy-MM-dd HH:mm:ss"  / >
						</dd>
					</dl>
					<div class="divider"></div>
					
					<dl>
						<dt>排序时间：</dt>
						<dd>
							<input type="text" name="object.sort_id_str"    value="${object.sort_id_str }"   class="required date"   datefmt="yyyy-MM-dd HH:mm:ss">
						</dd>
					</dl>
					<div class="divider"></div>
					
					<dl>
						<dt>权重：</dt>
						<dd>
							<input type="text" name="object.rule_weight"    value="${object.rule_weight }"  >
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