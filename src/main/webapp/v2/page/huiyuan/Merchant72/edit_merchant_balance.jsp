<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
</script> 
<div class="pageContent">
	<form method="post" action="${basePath }v2/Merchant72/merchant_balance_change.do"class="pageForm required-validate" onsubmit="return validateCallback(this, navTabAjaxDone);">
		<div class="pageFormContent" layoutH="56">
		<fieldset  > 
			<dl>
				<dt>登录名称：</dt>
				<dd  >
					<input type="text" name="user.username" value="<c:out value="${user.username }" escapeXml="true" />" readonly="readonly" > 
					<input type="hidden" name="id" value="${user.id }"   >
					<input type="hidden" name="orderId" value="<%=(System.currentTimeMillis()+"").substring(1) %>"   >
				</dd>
			</dl> 
			<div class="divider"></div>
			<dl>
				<dt>商户名称：</dt>
				<dd  >
					<input type="text" name="user.nickname" value="<c:out value="${user.nickname }" escapeXml="true" />"  readonly="readonly" > 
				</dd>
			</dl>

			<div class="divider"></div>
				<dl>
				<dt style="font-size: 0.8rem;">变动预付款：</dt>
				<dd  >
					<input type="text" name="balance" id="balance" value="" class="required" style="width: 100px;"  placeholder="" >元
				</dd>
			</dl>

			<div class="divider"></div>
			<dl>
				<dt style="font-size: 0.8rem;">折扣额：</dt>
				<dd  >
					<input type="text" name="discount" id="discount" value="" class="required" style="width: 100px;"   >元
				</dd>
			</dl>
			<div class="divider"></div>

			<dl>
				<dt style="font-size: 0.8rem;">折扣比：</dt>
				<dd  >
					<input type="text" id="" value="${user.discount_ratio/10000}%" readonly>
					<input type="hidden" id="discount_ratio" value="${user.discount_ratio}">
				</dd>
			</dl>

			<div class="divider"></div>

			<dl>
				<dt style="font-size: 0.7rem; width: 40%">悠择实际支付：</dt>
				<dd  style="width: 55%">
					<input type="text" id="topUpBalance" name="topUpBalance" style="width:75%;" value="" class="required" style="width: 100px;"  >元
				</dd>
			</dl>

			<div class="divider"></div>

			<dl>
				<dt>备注说明：</dt>
				<dd  >
					<input type="text" name="memo" value="" class=""   > 
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
<script type="text/javascript">
	$(function () {


        $("#topUpBalance").focus(function () {
            var ratio = $("#discount_ratio").val();

            $("#topUpBalance").keyup(function(){

//                $("#discount").val( ((ratio*$("#topUpBalance").val())/1000000) );
//
//                $("#balance").val( $("#topUpBalance").val()*1 + ((ratio*$("#topUpBalance").val())/1000000) );

                var real = sheng($("#topUpBalance").val(), 1);

                var discount = chu(sheng(real, ratio), 1000000);

                $("#discount").val(discount);

                $("#balance").val( jia(real, discount) );


            });
        });



    });
</script>
    