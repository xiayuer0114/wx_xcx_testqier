<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.qier.action.CashierAction"%>
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
   <form method="post" action="${basePath }${baseRequestPath }batch_change_ok.do"class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone);">
		<div class="pageFormContent"  > 
			<fieldset  >
					<dl>
						<dt>指定商家：</dt>
						<dd>
							<input type="text" bringBack="user_merchant.showName"     value="<c:out value="${object.user_merchant.showName }" escapeXml="true"/>"   >
							<input type="hidden" bringBack="user_merchant.userId" name="object.userId_merchant" value="${object.userId_merchant }"    >
							<a  class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%=CashierAction.getMerchantUserGroutId() %>" lookupGroup="user_merchant"  rel="user_merchant_lookup">查找</a>
						</dd>
					</dl>

					<div class="divider"></div>

					<dl>
						<dt>指定会员：</dt>
						<dd>
							<input type="text" bringBack="user_huiyuan1.showName"     value=""   >
							<input type="hidden" bringBack="user_huiyuan1.userId" name="object.old_userId_huiyuan" value=""    >
							<a  class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%=CashierAction.getCommonUserGroutId() %>" lookupGroup="user_huiyuan1"  rel="user_huiyuan_lookup">查找</a>
						</dd>
					</dl>

					<dl>
						<dt>目标会员：</dt>
						<dd>
							<input type="text" bringBack="user_huiyuan2.showName"     value=""   >
							<input type="hidden" bringBack="user_huiyuan2.userId" name="object.new_userId_huiyuan" value=""    >
							<a  class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%=CashierAction.getCommonUserGroutId() %>" lookupGroup="user_huiyuan2"  rel="user_huiyuan_lookup">查找</a>
						</dd>
					</dl>
					<div class="divider"></div>
					<dl >
						<dt>原状态：</dt>
						<dd> 
							<select class="combox" name="object.old_state">
										<option value="">（全部）</option>
										<option value="<%=State.STATE_WAITE_CHANGE %>">未领取</option>
										<option value="<%=State.STATE_OK %>">已领取</option>							
										<option value="<%=State.STATE_FALSE %>">已使用</option>
										<option value="<%=State.STATE_CLOSED %>">已过期</option>
										<option value="<%=State.STATE_WAITE_WAITSENDGOODS %>">未激活</option>
										<option value="<%=State.STATE_WAITE_CODWAITRECEIPTCONFIRM %>">已转移</option>
										<option value="<%=State.STATE_ORDER_NOT_EXIST %>">小黑屋</option>
							</select>
						</dd>
					</dl>
					<dl >
						<dt>目标状态：</dt>
						<dd>
							<select class="combox" name="object.new_state">
								<option value="">（不变）</option>
								<option value="<%=State.STATE_WAITE_CHANGE %>">未领取</option>
								<option value="<%=State.STATE_OK %>">已领取</option>
								<option value="<%=State.STATE_FALSE %>">已使用</option>
								<option value="<%=State.STATE_CLOSED %>">已过期</option>
								<option value="<%=State.STATE_WAITE_WAITSENDGOODS %>">未激活</option>
								<option value="<%=State.STATE_WAITE_CODWAITRECEIPTCONFIRM %>">已转移</option>
								<option value="<%=State.STATE_ORDER_NOT_EXIST %>">小黑屋</option>
							</select>
						</dd>
					</dl>

					<div class="divider"></div>

					<dl>
						<dt>原红包名称</dt>
						<dd>
							<input type="text"  name="object.old_red_envolope_name"  value=""     >
						</dd>
					</dl>
					<dl>
						<dt style="font-size: 0.8rem;">目标红包名称</dt>
						<dd>
							<input type="text"  name="object.new_red_envolope_name"  value=""   >
						</dd>
					</dl>

					<div class="divider"></div>

					<dl>
						<dt>原红包总额</dt>
						<dd>
							<input type="text"  name="object.old_inAmount"  value=""   class="number"   >
						</dd>
					</dl>
					<dl>
						<dt style="font-size: 0.8rem;">目标红包总额</dt>
						<dd>
							<input type="text"  name="object.new_inAmount"  value=""   class="number"   >
						</dd>
					</dl>
					<div class="divider"></div>
					<dl>
						<dt style="font-size: 0.8rem;">搜索时间开始</dt>
						<dd>
							<input name="search_time_start" value="${lingqu_time_start }"  type="text" class="date" dateFmt="yyyy-MM-dd HH:mm:ss"  />
						</dd>
					</dl>
					<dl>
						<dt>有效时间：</dt>
						<dd>
							<input type="text" name="object.inExpiry_time"    value=""   class="date"   datefmt="yyyy-MM-dd HH:mm:ss">
						</dd>
					</dl> 
					<div class="divider"></div>
					<dl>
						<dt style="font-size: 0.8rem;">搜索时间结束</dt>
						<dd>
							<input name="search_time_end" value="${lingqu_time_end }"  type="text" class="date" dateFmt="yyyy-MM-dd HH:mm:ss"  />
						</dd>
					</dl>
					<dl>
					</dl>

					<div class="divider"></div>
					<dl>
						<dt style="font-size: 0.8rem;">操作数量</dt>
						<dd>
							<input type="text"  name="change_size" value="1" class="digits required"   >
						</dd>
					</dl>
					<dl>
						<dt>满减金额</dt>
						<dd>
							<input type="text"  name="object.inAmount_to_reach"  value=""   class="number"   >
						</dd>
					</dl> 
			</fieldset>
		</div>
		<div class="formBar">
			<ul>
				<li><div class="buttonActive"><div class="buttonContent"><button type="submit">确定</button></div></div></li>
				<li>
					<div class="button"><div class="buttonContent"><button type="button" class="close">关闭</button></div></div>
				</li>
			</ul>
		</div>
	</form>
</div>