<%@ page import="com.lymava.qier.model.merchant.MerchantBankChangeRecord" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
     <script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
		</script> 
   <div class="pageContent" id="${currentTimeMillis }"  >

   	<form id="id_form_shenhe" method="post" action="${basePath }v2/MerchantBankChange/shenghe.do" class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone);">
		<input hidden="hidden" type="text" name="id" value="<c:out value="${object.id}" escapeXml="true" />" readonly="readonly" >
		<input hidden="hidden" type="text" name="user_huiyuan_id" value="<c:out value="${object.user_huiyuan.id}" escapeXml="true" />" readonly="readonly" >

		<input hidden="hidden" type="text" name="bank_type" value="<c:out value="${object.accept_bank_type}" escapeXml="true" />">
		<input hidden="hidden" type="text" name="depositary_bank" value="<c:out value="${object.accept_depositary_bank}" escapeXml="true" />">
		<input hidden="hidden" type="text" name="account" value="<c:out value="${object.accept_account}" escapeXml="true" />">
		<input hidden="hidden" type="text" name="bank_addr" value="<c:out value="${object.accept_bank_addr}" escapeXml="true" />">
		<input hidden="hidden" type="text" name="name" value="<c:out value="${object.accept_name}" escapeXml="true" />">
		<%--<input hidden="hidden" type="text" name="card_state" value="<c:out value="${object.accept_state}" escapeXml="true" />">--%>
		<input hidden="hidden" type="text" name="memo" value="<c:out value="${object.accept_memo}" escapeXml="true" />">

		<div class="pageFormContent" layoutH="56">
			<fieldset style="height: ${pageContent_height-75}px;">
					<%@ include file="inc/edit_show_base.jsp" %>
				<div class="divider"></div>
				<dl>
					<dt>订单编号：</dt>
					<dd>
						${object.requestFlow }
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
					<dt>提交管理员</dt>
					<dd>
						${object.userV2_submit.userName }
					</dd>
				</dl>
				<dl>
					<dt>审核管理员</dt>
					<dd>
						${object.userV2_shenghe.userName }
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
					<dt>商户：</dt>
					<dd>
						${object.user_huiyuan.showName }
					</dd>
				</dl>
				<div class="divider"></div>

				<dl>
					<dt>银行卡类型</dt>
					<dd>
						${object.accept_bank_type_name}
					</dd>
				</dl>
				<dl>
					<dt>开户行</dt>
					<dd>
						${object.accept_depositary_bank }
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
					<dt>收方行地址</dt>
					<dd>
						${object.accept_bank_addr }
					</dd>
				</dl>
				<dl>
					<dt>卡号/账号</dt>
					<dd>
						${object.accept_account }
					</dd>
				</dl>
				<dl>
					<dt>账户名称</dt>
					<dd>
						${object.accept_name }
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
					<dt>备注</dt>
					<dd>
						${object.accept_memo }
					</dd>
				</dl>
				<div class="divider"></div>

				<dl>
					<dt>时间：</dt>
					<dd>
						${object.showTime }
					</dd>
				</dl>
				<div class="divider"></div>
				<dl class="nowrap">
					<dt>变更凭证：</dt>
					<dd>
						<img class="upload_img" style="width: 150px;height: 150px;" src="${basePath }${object.pinzheng}">
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
					<dt>审核状态：</dt>
					<dd>
						<select name="state" class="combox" svalue="${object.state }">
							<option    value="<%=MerchantBankChangeRecord.accept_shenhe_state_no %>" >未审核</option>
							<option  value="<%=MerchantBankChangeRecord.accept_shenhe_state_fail%>" >审核失败</option>
							<option  value="<%=MerchantBankChangeRecord.accept_shenhe_state_complete%>" >已变更</option>
						</select>
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
					<dt>审核备注：</dt>
					<dd>
						<input type="text" name="record_memo"  value="<c:out value="${object.record_memo }" escapeXml="true"/>">
					</dd>
				</dl>
			</fieldset>
		</div>
		<div class="formBar">
			<ul>
				<li><div class="buttonActive"><div class="buttonContent"><button type="submit">提交</button></div></div></li>
				<%--<li><div class="buttonActive"><div class="buttonContent"><button id="id_shenhe_success" type="button">审核通过</button></div></div></li>
				<li><div class="buttonActive"><div class="buttonContent"><button id="id_shenhe_fail" type="button">审核失败</button></div></div></li>--%>
				<li><div class="button"><div class="buttonContent"><button type="button" class="close">关闭</button></div></div></li>
			</ul>
		</div>
	</form>

   <script>
       $("#id_shenhe_success").click(function () {
           $("#id_form_shenhe").get(0).submit();
       });
	   $("#id_shenhe_fail").click(function () {
           $("#id_form_shenhe").get(0).submit();
       });
   </script>
</div>