<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.qier.action.CashierAction"%>
<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="com.lymava.nosql.context.SerializContext" %>
<%@ page import="com.lymava.commons.util.MyUtil" %>
<%@ page import="com.lymava.qier.model.MerchantRedEnvelope" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

     <script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
		</script>

   <div  class="pageContent" id="${currentTimeMillis }"  >

   <form method="post" action="${basePath }${baseRequestPath }addToActivityRed.do"class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone);">
		<div class="pageFormContent"  > 
			<fieldset  >

				<script type="text/javascript">
					$(function () {
                        $("#op_user_name_merchant").blur(function() {
                            var merchantId = $("#op_user_id_merchant").val();
                            $.post(basePath+"v2/MerchantRedEnvelope/getMerchantRedEnvelopeByid.do",{"merchantId":merchantId},function (msg) {
                                data = JSON.parse(msg);
                                if(data.statusCode == 200){
                                    $("input[name='old_red_envolope_name']").val(data.data.redEnvelope_name);
                                    $("input[name='red_envolope_prince']").val(data.data.redEnvelope_amount/100);
								}else{
								}
                            });
                        });
                    })

				</script>

				<dl>
					<dt>指定商家：</dt>
					<dd>
						<input type="text" bringBack="user_merchant.showName" id="op_user_name_merchant" value="<c:out value="${object.user_merchant.showName }" escapeXml="true"/>"   >
						<input type="hidden" bringBack="user_merchant.userId" id="op_user_id_merchant" name="userId_merchant" value="${object.userId_merchant }"    >
						<a class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%=CashierAction.getMerchantUserGroutId() %>" lookupGroup="user_merchant"  rel="user_merchant_lookup">查找</a>
					</dd>
				</dl>
				<dl>
					<dt></dt>
					<dd>
						<span style="color: red" id="merchantErrorMessage"></span>
					</dd>
				</dl>

				<div class="divider"></div>

				<dl>
					<dt>指定会员：</dt>
					<dd>
						<input type="text" bringBack="user_huiyuan1.showName" >
						<input type="hidden" bringBack="user_huiyuan1.userId" name="old_userId_huiyuan"     >
						<a  class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%=CashierAction.getCommonUserGroutId() %>" lookupGroup="user_huiyuan1"  rel="user_huiyuan_lookup">查找</a>
					</dd>
				</dl>

				<dl>
					<dt>目标会员组</dt>
					<dd>
						<input type="text" bringBack="userGroup.name"  >
						<input type="hidden" bringBack="userGroup.id" name="target_user_group_id"  >
						<a  class="btnLook" href="${basePath }v2/usergroup/list.do?return_mod=lookup" lookupGroup="userGroup"  rel="user_huiyuan_lookup">查找</a>
					</dd>
				</dl>

				<div class="divider"></div>

				<dl >
					<dt>原状态：</dt>
					<dd>
						<select class="combox" name="old_state" >
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

				<dl >
					<dt style="font-size: 0.7rem;">加入后状态：</dt>
					<dd>
						<select class="combox" name="new_state" >
							<option value="<%=State.STATE_OK %>">已领取</option>
							<option value="<%=State.STATE_WAITE_CHANGE %>">未领取</option>
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
						<input type="text"  name="old_red_envolope_name"  value="" readonly="readonly">
					</dd>
				</dl>

				<dl>
					<dt style="font-size: 0.8rem;">活动红包名称</dt>
					<dd>
						<input type="text"  name="activity_envolope_name" class="required" >
					</dd>
				</dl>

				<div class="divider"></div>

				<dl>
					<dt>红包金额</dt>
					<dd>
						<input type="text"  name="red_envolope_prince"  value="" readonly="readonly">
					</dd>
				</dl>

				<div class="divider"></div>

				<dl>
					<dt>操作数量</dt>
					<dd>
						<input type="text"  name="op_count"  class="required" >
					</dd>
				</dl>

				<div class="divider"></div>

				<dl>
					<dt style="font-size: 0.8rem;">生成时间开始</dt>
					<dd>
						<input name="shengcheng_state_time"  type="text" class="date" dateFmt="yyyy-MM-dd HH:mm:ss"  />
					</dd>
				</dl>

				<div class="divider"></div>

				<dl>
					<dt style="font-size: 0.8rem;">生成时间结束</dt>
					<dd>
						<input type="text" name="shengcheng_end_time"    value=""   class="date"   datefmt="yyyy-MM-dd HH:mm:ss">
					</dd>
				</dl>

				<div class="divider"></div>

				<dl>
					<dt style="font-size: 0.8rem;">有效时间开始</dt>
					<dd>
						<input name="youxiao_state_time"  type="text" class="date" dateFmt="yyyy-MM-dd HH:mm:ss"  />
					</dd>
				</dl>

				<div class="divider"></div>

				<dl>
					<dt style="font-size: 0.8rem;">有效时间结束</dt>
					<dd>
						<input type="text" name="youxiao_end_time"    value=""   class="date"   datefmt="yyyy-MM-dd HH:mm:ss">
					</dd>
				</dl>

				<div class="divider"></div>

				<dl>
					<dt style="font-size: 0.8rem;">领取时间开始</dt>
					<dd>
						<input name="lingqu_state_time"   type="text" class="date" dateFmt="yyyy-MM-dd HH:mm:ss"  />
					</dd>
				</dl>

				<div class="divider"></div>

				<dl>
					<dt style="font-size: 0.8rem;">领取时间结束</dt>
					<dd>
						<input type="text" name="lingqu_end_time"    value=""   class="date"   datefmt="yyyy-MM-dd HH:mm:ss">
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