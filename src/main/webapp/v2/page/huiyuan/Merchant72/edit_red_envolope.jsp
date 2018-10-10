<%@page import="com.lymava.base.action.UserAction"%>
<%@page import="java.util.UUID"%>
<%@page import="com.lymava.commons.util.Md5Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
         <script type="text/javascript">
					jQuery(function(){
                        uploadInitMy();
						resetDialog();
					});
		</script> 
<div class="pageContent" id="${currentTimeMillis }"  >
	<form method="post" action="${basePath }v2/Merchant72/change_ratio.do" class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone);">
		<div class="pageFormContent" >
		 <fieldset >
			<dl>
				<dt style="font-size: 0.7rem;">折扣总比例：</dt>
				<dd>
					<input type="text" style="width: 50px;" name="user.inDiscount_ratio" value="<c:out value="${user.discount_ratio/10000 }" escapeXml="true"/>"   class="required" >% 
					<input type="hidden" name="id" value="${user.id }"   >
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dd>
					通用红包
				</dd>
			</dl>
			<div class="divider" ></div> 
			<dl>
				<dt style="font-size: 0.7rem;" >红包最小比例：</dt>
				<dd>
					<input type="text" style="width: 50px;" name="user.inRed_pack_ratio_min" value="<c:out value="${user.red_pack_ratio_min/10000 }" escapeXml="true"/>"   class="required" >% 
				</dd>
			</dl>
			<dl>
				<dt style="font-size: 0.7rem;" >红包最大比例：</dt>
				<dd>
					<input type="text" style="width: 50px;" name="user.inRed_pack_ratio_max" value="<c:out value="${user.red_pack_ratio_max/10000 }" escapeXml="true"/>"   class="required" >% 
				</dd>
			</dl> 
			<%--<div class="divider"></div>
			<dl>
				<dd>
					定向红包
				</dd>
			</dl>--%>
			<div class="divider" ></div> 
			<dl>
				<dt style="font-size: 0.7rem;" >定向红包余额</dt>
				<dd>
					${user.merchant_redenvelope_balance_fen/100 }
				</dd>
			</dl>
			<div class="divider" ></div> 
			<dl>
				<dt style="font-size: 0.7rem;" >生成阀值</dt>
				<dd>
					<input type="text" style="width: 50px;" name="user.inMerchant_redenvelope_arrive_yuan" value="<c:out value="${user.merchant_redenvelope_arrive_fen/100 }" escapeXml="true"/>"   class="required" >元 
				</dd>
			</dl>
			<div class="divider" ></div> 
			<dl>
				<dt style="font-size: 0.7rem;" >定向红包比例：</dt>
				<dd>
					<input type="text" style="width: 50px;" name="user.merchant_red_pack_ratio" value="<c:out value="${user.merchant_red_pack_ratio/10000 }" escapeXml="true"/>"   class="required" >% 
				</dd>
			</dl>
			 <div class="divider"></div>
			 <dl class="nowrap" >
				 <dt>变动凭证</dt>
				 <dd>
					 <input class="mydisupload required"   fileNumLimit="1" name="pinzheng"  type="hidden"  value="" />
				 </dd>
			 </dl>
			 <div class="divider"></div>
			 <dl>
				 <dt>备注：</dt>
				 <dd>
					 <input type="text" name="transter_memo" value=""  >
				 </dd>
			 </dl>
		 </fieldset>
 		</div>
		<div class="formBar">
			<ul>
				<li><div class="buttonActive"><div class="buttonContent"><button type="submit">提交审核</button></div></div></li>
				<li>
					<div class="button"><div class="buttonContent"><button type="button" class="close">取消</button></div></div>
				</li>
			</ul>
		</div>
	</form>
</div>
    