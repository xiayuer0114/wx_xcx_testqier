<%@ page import="com.lymava.commons.state.State" %>
<%@ page import="com.lymava.qier.action.CashierAction" %>
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
		<div class="pageFormContent" layoutH="56">



			<fieldset>

				<dl>
					<dt>状态：</dt>
					<dd>
						<select class="combox" name="object.state" svalue="${object.state }">
							<option value="<%=State.STATE_OK %>"> 正常 </option>
							<option value="<%=State.STATE_FALSE %>"> 关闭 </option>
						</select>
					</dd>
				</dl>

				<div class="divider"></div>

				<dl>
					<dt>开始时间：</dt>
					<dd>
						<input type="text" name="object.inHuodong_startTime" value="<c:out value="${object.showHuodong_startTime }" escapeXml="true"/>" class="date required" dateFmt="yyyy-MM-dd HH:mm:ss" >
					</dd>
				</dl>
				<dl>
					<dt>结束时间：</dt>
					<dd>
						<input type="text" name="object.inHuodong_endTime" value="<c:out value="${object.showHuodong_endTime}" escapeXml="true"/>" class="date required" dateFmt="yyyy-MM-dd HH:mm:ss" >
					</dd>
				</dl>

				<div class="divider"></div>

				<dl>
					<dt>份数：</dt>
					<dd>
						<input type="text" name="object.fenshu" value="<c:out value="${object.fenshu }" escapeXml="true"/>" class="number required" >
					</dd>
				</dl>
				<dl>
					<dt>倒计时：</dt>
					<dd>
						<input type="text" name="object.daojishi" value="<c:out value="${object.daojishi }" escapeXml="true"/>" class="number required" >
					</dd>
				</dl>

				<div class="divider"></div>

				<dl>
					<dt>展示折扣：</dt>
					<dd>
						<input type="text" name="object.show_zhekou" value="<c:out value="${object.show_zhekou }" escapeXml="true"/>" class="required" >
					</dd>
				</dl>
				<dl>
					<dt>商家：</dt>
					<dd class="lookup_dd">
						<input type="text"   bringBack="user_merchant.showName" value="${object.merchant72.nickname}"  class="required">
						<input type="hidden"  bringBack="user_merchant.userId"  name="object.merchant_id" value="${object.merchant_id}"    >
						<a class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%= CashierAction.getMerchantUserGroutId()%>" lookupGroup="user_merchant" rel="user_merchant_lookup">查找</a>
					</dd>
				</dl>

				<div class="divider"></div>

				<dl>
					<dt>折扣前：</dt>
					<dd>
						<input type="text" name="object.inZhekou_qian" value="<c:out value="${object.zhekou_qian/100}" escapeXml="true"/>" class="number required" >
					</dd>
				</dl>
				<dl>
					<dt>折扣后：</dt>
					<dd>
						<input type="text" name="object.inZhekou_hou" value="<c:out value="${object.zhekou_hou/100}" escapeXml="true"/>" class="number required" >
					</dd>
				</dl>

				<div class="divider"></div>

				<dl>
					<dt>需要好友：</dt>
					<dd>
						<input type="text" name="object.xuyao_haoyou" value="<c:out value="${object.xuyao_haoyou}" escapeXml="true"/>" class="number required" >
					</dd>
				</dl>
				<dl>
					<dt>已经购买：</dt>
					<dd>
						<input type="text" name="object.yijing_goumei" value="<c:out value="${object.yijing_goumei}" escapeXml="true"/>" class="number required" >
					</dd>
				</dl>

				<div class="divider"></div>

				<dl>
					<dt>活动名字：</dt>
					<dd>
						<input type="text" name="object.huodong_name" value="<c:out value="${object.huodong_name}" escapeXml="true"/>" class="required" >
					</dd>
				</dl>
				<dl>
					<dt>活动标题：</dt>
					<dd>
						<input type="text" name="object.huodong_title" value="<c:out value="${object.huodong_title}" escapeXml="true"/>" class="required" >
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