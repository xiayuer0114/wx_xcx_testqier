<%@page import="com.lymava.base.vo.State"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="panelBar">
		<ul class="toolBar">
			<li><a class="add" href="${basePath }${baseRequestPath }edit.do" target="dialog"  rel="${currentTimeMillis }" ><span>新增</span></a></li>
			<li class="line">line</li>
			<li><a class="edit" href="${basePath }${baseRequestPath }look.do?id={id}" target="dialog"  rel="${currentTimeMillis }" ><span>查看</span></a></li>
			<li class="line">line</li>
			<li><a class="edit" href="${basePath }${baseRequestPath }edit.do?id={id}" target="dialog"  rel="${currentTimeMillis }" ><span>编辑</span></a></li>
			<li class="line">line</li>
			<li><a class="delete" link="${basePath  }${baseRequestPath }delete.do" rootPubConlumnId="${currentTimeMillis }" title="确定要删除吗?"   href="javascript:void(0)" ><span>删除</span></a></li>
			<li class="line">line</li>
			<li><a class="icon ajaxdo" link="${basePath  }${baseRequestPath }re_index.do" rootPubConlumnId="${currentTimeMillis }" title="确认未领重新排序?"   href="javascript:void(0)" ><span>未领重新排序</span></a></li>
			<li class="line">line</li>
			<li><a class="delete" link="${basePath  }${baseRequestPath }transfer_to_tongyong.do" rootPubConlumnId="${currentTimeMillis }" title="确定要转移红包吗?"   href="javascript:void(0)" ><span>转移红包</span></a></li>
			<li class="line">line</li>
			<li><a class="add" href="${basePath }${baseRequestPath }batch_change.do" target="dialog"  rel="${currentTimeMillis }" ><span>批量红包修改</span></a></li>
			<li class="line">line</li>
			<li><a class="icon" href="${basePath }${baseRequestPath }edit.do?return_mod=batch_lingqu" target="dialog"  rel="${currentTimeMillis }" ><span>红包批量处理</span></a></li>

			<li class="line">line</li>
			<li><a class="icon" href="${basePath }${baseRequestPath }edit.do?return_mod=to_activity_red" target="dialog"  rel="${currentTimeMillis }" ><span>加入到活动红包</span></a></li>
			<%--<li><a class="icon" href="${basePath }${baseRequestPath }edit.do?return_mod=to_activity_red&id={id}" target="dialog"  rel="${currentTimeMillis }" ><span>转让到活动红包</span></a></li>--%>
   		</ul>
</div>
