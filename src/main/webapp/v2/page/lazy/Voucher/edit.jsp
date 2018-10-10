<%@page import="com.lymava.qier.model.Voucher"%>
<%@page import="com.lymava.trade.business.model.Address"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
     <script type="text/javascript">
					jQuery(function(){
						
						uploadInitMy();
						
						resetDialog();
					});
		</script>
   <div  class="pageContent" id="${currentTimeMillis }"  >
   <form method="post" action="${basePath }${baseRequestPath }save.do"class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone);">
		<div class="pageFormContent" >
			<fieldset  > 
					<dl >
						<dt>商家：</dt>
						<%--<dd class="lookup_dd">--%>
							<%--<input type="text"    value="<c:out value="${object.showInNickName}" escapeXml="true"/>"  readonly >--%>
							<%--<input type="hidden" name="object.id"  value="<c:out value="${object.id }" escapeXml="true"/>">--%>
						<%--</dd>--%>

						<dd class="lookup_dd">
							<input type="hidden" name="object.id"  value="<c:out value="${object.id }" escapeXml="true"/>">
							<input type="text"   bringBack="user_merchant.showName" value="<c:out value="${object.showInNickName}" escapeXml="true"/>"     >
							<input type="hidden"  bringBack="user_merchant.userId"  name="object.topUserId"  value="<c:out value="${object.topUserId }" escapeXml="true"/>" >
							<a  class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup" lookupGroup="user_merchant"  rel="topuser_lookup">查找</a>
						</dd>
					</dl>
					<div class="divider"></div>
					<dl>
						<dt>代金券名称：</dt>
						<dd>
							<input type="text"  name="object.voucherName"  value="<c:out value="${object.voucherName }" escapeXml="true"/>"   class="required"   >
						</dd>
					</dl>
					<dl>
						<dt>描述：</dt>
						<dd>
							<input type="text"  name="object.voucherMiaoSu"  value="<c:out value="${object.voucherMiaoSu }" escapeXml="true"/>"   class="required"   >
						</dd>
					</dl>
					<div class="divider"></div>
					<dl>
						<dt>价值：</dt>
						<dd>
							<input type="text"  name="object.voucherValue"  value="<c:out value="${object.voucherValue_fen/100 }" escapeXml="true"/>"   class="required"   >
						</dd>
					</dl>
					<dl>
						<dt>总数量：</dt>
						<dd>
							<input type="text"  name="object.voucherCount"  value="<c:out value="${object.voucherCount }" escapeXml="true"/>"   class="required"   >
						</dd>
					</dl>
					<div class="divider"></div>
					<dl>
						<dt>已发出：</dt>
						<dd>
							<input type="text"  name="object.voucherOutCount"  value="<c:out value="${object.voucherOutCount }" escapeXml="true"/>"   class="required"   >
						</dd>
					</dl>
					<dl>
						<dt>条件：</dt>
						<dd>
							<input type="text"  name="object.useWhere"  value="<c:out value="${object.useWhere }" escapeXml="true"/>"   class="required"   >
						</dd>
					</dl>
					<div class="divider"></div>
					<dl>
						<dt>发布时间：</dt>
						<dd>
							<input type="text" name="object.inReleaseTime"    value="<c:out value="${object.showInReleaseTime }" escapeXml="true"/>"   class="required date"   datefmt="yyyy-MM-dd HH:mm:ss">
						</dd>
					</dl>
					<dl>
						<dt>有效时间：</dt>
						<dd>
							<input type="text" name="object.inStopTime"    value="<c:out value="${object.showInStopTime }" escapeXml="true"/>"   class="required date"   datefmt="yyyy-MM-dd HH:mm:ss">
						</dd>
					</dl>
					<div class="divider"></div>
				<dl>
					<dt>使用时间：</dt>
					<dd>
						<input type="text" name="object.showUseReleaseTime"    value="<c:out value="${object.showUseReleaseTime }" escapeXml="true"/>"   class="date"   datefmt="yyyy-MM-dd HH">
					</dd>
				</dl>
				<dl>
					<dt>最后时间：</dt>
					<dd>
						<input type="text" name="object.showUseStopTime"    value="<c:out value="${object.showUseStopTime }" escapeXml="true"/>"   class="date"   datefmt="yyyy-MM-dd HH">
					</dd>
				</dl>
				<div class="divider"></div>
					<dl>
						<dt>状态：</dt>
						<dd>
							<select class="combox" name="object.state" svalue="${object.state }">
								<option value="<%=Voucher.voucherState_now %>" >发布中</option>
								<option value="<%=Voucher.voucherState_editing %>" >商家编辑中</option>
								<option value="<%=Voucher.voucherState_stop %>" >已结束</option>
								<option value="<%=Voucher.voucherState_timeout %>" >已过期</option>
								<option value="<%=Voucher.voucherState_wait %>" >待审核</option>
							</select>
						</dd>
					</dl>
					<dl class="nowrap">
						<dt>效果图片：</dt>
						<dd>
							<input class="mydisupload"   fileNumLimit="1" name="object.logo"  type="hidden"  value="<c:out value="${object.logo }" escapeXml="true" />" />
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