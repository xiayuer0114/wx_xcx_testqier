<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<div class="panelBar">
		<ul class="toolBar">
		<li><a class="edit" href="${basePath }v2/businessRecord/edit.do?id={id}&return_mod=show&showBusinessIntId=${showBusinessIntId }" target="dialog"  ><span>查看</span></a></li>
			<li><a class="edit" href="${basePath }v2/businessRecord/edit.do?id={id}&return_mod=state&showBusinessIntId=${showBusinessIntId }" target="dialog"  ><span>状态变更</span></a></li>
			<li class="line">line</li>
			<li><a class="edit" href="${basePath }v2/businessRecord/edit.do?id={id}&return_mod=memo&showBusinessIntId=${showBusinessIntId }" target="dialog"  ><span>备注</span></a></li>
			<li class="line">line</li> 
			<li><a class="delete" link="${basePath  }v2/businessRecord/delete.do?showBusinessIntId=${showBusinessIntId }" rootPubConlumnId="${currentTimeMillis }" title="确定要删除吗?"   href="javascript:void(0)" ><span>删除</span></a></li>
			<li class="line">line</li>
			<li><a class="edit" href="${basePath }v2/businessRecord/edit.do?id={id}&return_mod=refund" target="dialog"  ><span>退款</span></a></li>
			<li class="line">line</li>
   		</ul>
	</div>