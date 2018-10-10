<%@page import="com.lymava.base.vo.State"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
					function addIp(){
						jQuery('#addIpDl').before(jQuery('#iplist_moban').html());
						resetDialog();
					}
					function removeIp(athis){
						var dl_remove = jQuery(athis).parent().parent();
						var dl_next = dl_remove.next();
						if(jQuery(dl_next).hasClass('divider')){
							dl_next.remove();
						}
						dl_remove.remove();
						resetDialog();
					}
</script>
   <div class="pageContent" id="${currentTimeMillis }"  >
   	<div id="iplist_moban" style="display: none;">
				<dl class="iplist">
					<dt>绑定IP：</dt>
					<dd> 
						<input type="text" name="inIplist" value=""  style="width: 100px;"  ><a href="javascript:void(0)" onclick="removeIp(this)">删除</a>
					</dd>
				</dl>     	
				<div class="divider"></div>
   	</div>
	<form method="post" action="${basePath }v2/huiyuan/resetIpList.do"class="pageForm required-validate" onsubmit="return validateCallback(this);">
		<div class="pageFormContent" layoutH="56">
		<fieldset >
			<dl>
				<dt>登录名称：</dt>
				<dd> 
								<input type="text" name="user.username" value="<c:out value="${user.username }" escapeXml="true" />" readonly="readonly" > 
								<input type="hidden" name="id" value="${user.id }"   >
				</dd>
			</dl>  
			<div class="divider"></div>
			<dl>
				<dt>昵称：</dt>
				<dd> 
					<input type="text" name="user.nickname" value="<c:out value="${user.nickname }" escapeXml="true" />"  readonly="readonly" > 
				</dd>
			</dl>  
			<div class="divider"></div>
			<div style="display: none;">
				<input type="text" name="inIplist" value=""   >
   			</div>
			<c:forEach var="ip" items="${user.iplist }">
				<dl class="iplist">
					<dt>绑定IP：</dt>
					<dd> 
						<input type="text" name="inIplist" value="${ip }"  style="width: 100px;"  ><a href="javascript:void(0)" onclick="removeIp(this)">删除</a>
					</dd>
				</dl>  
			</c:forEach>
			<dl id="addIpDl"> 
					<dd> 
						<div class="button"><div class="buttonContent"><button onclick="addIp()" type="button">新增地址</button></div></div>
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
    