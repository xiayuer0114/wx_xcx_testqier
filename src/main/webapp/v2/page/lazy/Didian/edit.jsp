<%@page import="com.lymava.qier.action.MerchantShowAction"%>
<%@page import="com.lymava.trade.business.model.Address"%>
<%@page import="com.lymava.base.vo.State"%>
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
		<div class="pageFormContent" layoutH="56"> 
			<fieldset  >
					<dl >
						<dt>系统编号：</dt>
						<dd style="font-size: 0.8em;">
							<c:out value="${object.id }" escapeXml="true"/>
							<input type="hidden" name="object.id"  value="<c:out value="${object.id }" escapeXml="true"/>" />
						</dd>
					</dl>
					<div class="divider"></div>
					<dl>
						<dt>地点名称：</dt>
						<dd>
							<input type="text"  name="object.didianming"  value="<c:out value="${object.didianming }" escapeXml="true"/>"   class="required"   >
						</dd>
					</dl> 
					<div class="divider"></div>
					<dl>
						<dt>提示语：</dt>
						<dd>
							<input type="text"  name="object.tishi"  value="<c:out value="${object.tishi }" escapeXml="true"/>"   class="required"   >
						</dd>
					</dl>
					<div class="divider"></div>
					<dl class="nowrap" >
						<dt style="font-size: 0.6rem;" >老地点图片</dt>
						<dd>
							<input class="mydisupload required"   fileNumLimit="1" name="object.pic"  type="hidden"  value="<c:out value="${object.pic }" escapeXml="true"/>" />
						</dd>
					</dl>
					<div class="divider"></div>
					<dl class="nowrap" >
						<dt style="font-size: 0.6rem;" >结果图片</dt>
						<dd>
							<input class="mydisupload required"   fileNumLimit="1" name="object.picResult"  type="hidden"  value="<c:out value="${object.picResult }" escapeXml="true"/>" />
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