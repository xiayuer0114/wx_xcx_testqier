<%@ page import="com.lymava.qier.model.merchant.MerchantBankChangeRecord" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
     <script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
		</script> 
   <div class="pageContent" id="${currentTimeMillis }"  >
   	<form method="post" action="${basePath }v2/Merchant72/shenghe_change_ratio.do"class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone);">
		<input hidden="hidden" type="text" name="id" value="<c:out value="${object.id}" escapeXml="true" />" readonly="readonly" >
		<div class="pageFormContent" layoutH="56"> 
			<fieldset style="height: ${pageContent_height-75}px;">
					<%@ include file="inc/edit_show_base.jsp" %>
				<div class="divider"></div>
				<dl>
					<dt>管理员名称：</dt>
					<dd>
						${object.userV2.userName }
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
					<dt>业务编号：</dt>
					<dd>
						${object.businessIntId }
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
					<dt>业务名称：</dt>
					<dd>
						${object.business.businessName }
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
					<dt>折扣总比例：</dt>
					<dd>
						${object.discount_ratio/10000 }%
					</dd>
				</dl>
				<dl>
					<dt>红包最小比例：</dt>
					<dd>
						${object.red_pack_ratio_min/10000 }%
					</dd>
				</dl>
				<dl>
					<dt>红包最大比例：</dt>
					<dd>
						${object.red_pack_ratio_max/10000 }%
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
					<dt>生成阀值：</dt>
					<dd>
						${object.merchant_redenvelope_arrive_fen/100 }
					</dd>
				</dl>
				<dl>
					<dt>定向红包比例：</dt>
					<dd>
						${object.merchant_red_pack_ratio/10000 }
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
					<dt>备注：</dt>
					<dd>
						${object.transter_memo }
					</dd>
				</dl>
				<div class="divider"></div>
				<dl>
					<dt>提交IP：</dt>
					<dd>
						${object.ip }
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
					<dt>变动凭证：</dt>
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
			</fieldset>
		</div>
		<div class="formBar">
			<ul>
				<li><div class="buttonActive"><div class="buttonContent"><button type="submit">提交</button></div></div></li>
				<li><div class="button"><div class="buttonContent"><button type="button" class="close">关闭</button></div></div></li>
			</ul>
		</div>
	</form>
</div>