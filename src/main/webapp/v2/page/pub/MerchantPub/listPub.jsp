<%@page import="com.lymava.base.util.WebConfigContent"%>
<%@page import="com.lymava.base.model.Pub"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<form id="pagerForm" method="post" action="${basePath  }v2/pub/listPub.do">
	<input type="hidden" name="page" value="${pageSplit.page }" />
	<input type="hidden" name="pageSize" value="${pageSplit.pageSize }" />
	<input type="hidden" name="name" value="${name }" />
	<input type="hidden" name="tuijian" value="${tuijian }" />
	<input type="hidden" name="pubConlumnId" value="${pubConlumnId }" />
	<input type="hidden" name="rootPubConlumnId" value="${rootPubConlumnId }" />
</form>
<% request.setAttribute("rel", "listPub"+request.getAttribute("rootPubConlumnId")); %>
<div class="pageHeader">
	<form name="listPubsearchform${rootPubConlumnId}"  onsubmit="return divSearch(this, 'listPub${rootPubConlumnId }')"  action="${basePath  }v2/pub/listPub.do" method="post">
	<div class="searchBar">
		<table class="searchContent"  >
			<tr style="width: 100%;float: left;">
				<td>
					系统编号：<input type="text" name="pub_id" value="${pub_id }"/>
						<input type="hidden" name="pubConlumnId" value="${pubConlumnId }" />
						<input type="hidden" name="rootPubConlumnId" value="${rootPubConlumnId }" />
				</td> 
			</tr>
			<tr style="width: 100%;float: left;">
				<td>
					内容标题：<input type="text" name="name" value="${name }" />
				</td>
				<td>
					<div class="buttonActive"><div class="buttonContent"><button type="submit">检索</button></div></div>
				</td>
			</tr>
		</table>
	</div>
	</form> 
</div>
<div class="pageContent">
						<div class="panelBar">
							<ul class="toolBar">
								<c:if test="${!empty rootPubConlumnId || !empty pubConlumnId }">
								<li><a class="add" href="${basePath  }v2/pub/editPub.do?pubConlumnId=${pubConlumnId }&rootPubConlumnId=${rootPubConlumnId }"   target="dialog"  rel="pubEdit"><span>新增内容</span></a></li>
								<li class="line">line</li>
								</c:if>
								<li><a class="delete" link="${basePath  }v2/pub/deletePub.do"  rel="${rel }"  rootPubConlumnId="${rootPubConlumnId }"  href="javascript:void(0)"  ><span>删除</span></a></li>
								<li  class="line">line</li>
								<li><a  class="edit" 	href="${basePath  }v2/pub/editPub.do?id={pubId}" target="dialog"  rel="pub"  ><span>修改</span></a></li>
								<li class="line">line</li>
								<li ><a class="icon"  	href="${basePath  }v2/pub/toShenghePub.do?id={pubId}" target="dialog"     ><span>审核</span></a></li>
								<li class="line">line</li>
								<li ><a class="edit dialog_m"  	href="javascript:void(0)" rootPubConlumnId="${rootPubConlumnId }" 	link="${basePath  }v2/pub/listPubConlumn.do?return_mod=moveto&rootPubConlumnId=${rootPubConlumnId }"  rel="moveto" title="移动到"   ><span>移动</span></a></li>
								<li class="line">line</li>
								<li ><a class="add dialog_m"  href="javascript:void(0)" rootPubConlumnId="${rootPubConlumnId }" 	link="${basePath  }v2/pub/listPubConlumn.do?return_mod=copyto&rootPubConlumnId=${rootPubConlumnId }" rel="copyto"  title="复制到" ><span>复制</span></a></li>
								<li class="line">line</li>
								<li><a class="icon" href="${basePath  }v2/pub/editPub.do?rootPubConlumnId=<%=WebConfigContent.getConfig("recommend_pubConlumnId") %>&pubConlumnId=<%=WebConfigContent.getConfig("recommend_pubConlumnId") %>&pub_link_id={pubId}"   target="dialog"  rel="pubEdit"><span>推荐到</span></a></li>

								<li><a  class="edit"  href="${basePath  }v2/pub/editPub.do?id={pubId}&return_mod=show_xiaochengxu" target="dialog"  rel="pub"  ><span>查看小程序连接</span></a></li>
								<li class="line">line</li>
							</ul>
						</div>
						<table class="table" width="100%" layoutH="138">
							<thead>
								<tr>
									<th width="30"><input type="checkbox" class="checkboxCtrl" group="${rootPubConlumnId }checkbox" /></th>
									<th>名称</th>
									<th>发布者</th>
									<th>系统时间</th>
									<th>状态</th>
									<th>审核状态</th>
									<th>浏览</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="pub" varStatus="i" items="${pub_ite }">
									<tr target="pubId" rel="${pub.id }">
										<td><input type="checkbox" name="${rootPubConlumnId }checkbox" value="${pub.id }" /></td>
										<td>${pub.name }</td>
										<td>${pub.user.realName }</td>
										<td>${pub.showTime }</td>
										<td>${pub.showState }</td>
										<td>${pub.showShenghe }</td>
										<td>${pub.viewcount }</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
						<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
					</div>