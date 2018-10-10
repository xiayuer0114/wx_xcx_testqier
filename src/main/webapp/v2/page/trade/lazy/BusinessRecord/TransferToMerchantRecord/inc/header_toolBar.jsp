<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<div class="panelBar">
		<ul class="toolBar">
			<li><a class="edit" href="${basePath }${baseRequestPath }edit.do?id={id}&return_mod=show" target="dialog"  ><span>查看</span></a></li>
			<li class="line">line</li>
			<li><a class="edit" href="${basePath }${baseRequestPath }edit.do?id={id}&return_mod=state" target="dialog"  ><span>状态变更</span></a></li>
			<li class="line">line</li>
			<li><a class="edit" href="${basePath }${baseRequestPath }edit.do?id={id}&return_mod=memo" target="dialog"  ><span>备注</span></a></li>
			<li class="line">line</li>
			<li><a class="delete" link="${basePath  }v2/paymentRecord/makeSureState.do" rootPubConlumnId="${currentTimeMillis }" title="确定要刷新状态吗?"   href="javascript:void(0)" ><span>状态确认</span></a></li>
			<li class="line">line</li>
			<li><a class="delete" link="${basePath  }${baseRequestPath }delete.do" rootPubConlumnId="${currentTimeMillis }" title="确定要删除吗?"   href="javascript:void(0)" ><span>删除</span></a></li>
   		</ul>
	</div>