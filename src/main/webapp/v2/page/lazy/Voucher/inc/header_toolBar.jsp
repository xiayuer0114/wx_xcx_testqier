<%@page import="com.lymava.base.vo.State"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="panelBar">
		<ul class="toolBar">
			<%--<li><a class="add" href="${basePath }${baseRequestPath }edit.do" target="dialog"  rel="${currentTimeMillis }" ><span>新增地址</span></a></li>			<li class="line">line</li>--%>
			<li><a class="edit" href="${basePath }${baseRequestPath }edit.do" target="dialog"  rel="${currentTimeMillis }" ><span>发布代金券</span></a></li>
			<li><a class="edit" href="${basePath }${baseRequestPath }edit.do?id={id}" target="dialog"  rel="${currentTimeMillis }" ><span>查看编辑</span></a></li>
			<li><a class="edit" href="${basePath }${baseRequestPath }edit.do?id={id}&return_mod=send_voucher" target="dialog"  rel="${currentTimeMillis }" ><span>发放代金券</span></a></li>
			<li><a class="delete" link="${basePath  }${baseRequestPath }delete.do" rootPubConlumnId="${currentTimeMillis }" title="确定要删除吗?"   href="javascript:void(0)" ><span>删除</span></a></li>

			<li class="line">line</li>
			<%--<li><a class="delete" link="${basePath  }${baseRequestPath }delete.do" rootPubConlumnId="${currentTimeMillis }" title="确定要删除吗?"   href="javascript:void(0)" ><span>删除</span></a></li>--%>
   		</ul>
</div>