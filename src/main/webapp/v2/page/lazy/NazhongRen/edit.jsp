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
						<dt>系统编号：</dt>
						<dd style="font-size: 0.8em;">
							<c:out value="${object.id }" escapeXml="true"/>
							<input type="hidden" name="object.id"  value="<c:out value="${object.id }" escapeXml="true"/>" />
						</dd>
					</dl>
					<div class="divider"></div>
					<dl>
						<dt>西游记里你最喜欢谁：</dt>
						<dd>
							<input type="text"  name="object.xiyouji"  value="<c:out value="${object.xiyouji }" escapeXml="true"/>"   class="required"   >
						</dd>
					</dl> 
					<div class="divider"></div>
					<dl>
						<dt>你喜欢哪种类型的电影：</dt>
						<dd>
							<input type="text"  name="object.dianying"  value="<c:out value="${object.dianying }" escapeXml="true"/>"   class="required"   >
						</dd>
					</dl> 
					<div class="divider"></div>
					<dl>
						<dt>你最怕：</dt>
						<dd>
							<input type="text"  name="object.nizuipa"  value="<c:out value="${object.nizuipa }" escapeXml="true"/>"   class="required"   >
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