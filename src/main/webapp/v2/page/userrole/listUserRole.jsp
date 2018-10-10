<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<form id="pagerForm" method="post" action="${basePath }v2/userrole/list.do">
    <input type="hidden" name="page" value="${pageSplit.page }" />
    <input type="hidden" name="pageSize" value="${pageSplit.pageSize }" />
    <input type="hidden" name="pageSize" value="${pageSplit.pageSize }" />
</form>
<% request.setAttribute("currentTimeMillis", "userRole"); %>
<div class="pageHeader">
    <form id="${currentTimeMillis }searchform" name="${currentTimeMillis }searchform" onsubmit="return navTabSearch(this);" action="${basePath }v2/userrole/list.do" method="post">
        <div class="searchBar">
            <table class="searchContent">
                <tr>
                    <td>
                        员工编号：<input type="text" name="user_bianhao" value="${user_bianhao }"  />
                    </td>
                    <td>
                        <select name="roleId" class="required combox"  >
                            <option value="-1" >所有职位</option>
                            <c:forEach var="role" items="${role_list }"  >
                                <option <c:if test="${role.id == roleId }">selected="selected" </c:if> value="${role.id }"  >${role.name }</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <select name="departMentId" class="required combox"  >
                            <option value="-1" >所有部门</option>
                            <c:forEach var="departMent" items="${departMents }"  >
                                <option <c:if test="${departMent.id == departMentId }">selected="selected" </c:if> value="${departMent.id }"  >${departMent.departMentName }</option>
                            </c:forEach>
                        </select>
                    </td>
                    <c:if test="${loginuser_company.manager_back_company }">
                        <td>
                            公司
                        </td>
                        <td class="lookup_td">
                            <input type="text" name="company.name"  value="${company.name }"  class="required" readonly="readonly">
                            <input type="hidden" name="company.id"  value="${company.id }"   >
                            <a   class="btnLook" href="${basePath }v2/company/list.do?return_mod=lookup"  lookupGroup="company"  >查找</a>
                        </td>
                    </c:if>
                </tr>
            </table>
            <div class="subBar">
                <ul>
                    <li><div class="buttonActive"><div class="buttonContent"><button type="submit">检索</button></div></div></li>
                </ul>
            </div>
        </div>
    </form>
</div>
<div class="pageContent">
    <div class="panelBar">
        <ul class="toolBar">
            <li><a class="add" href="${basePath  }v2/userrole/toEdit.do"  target="dialog"  rel="editUserRole"><span>添加</span></a></li>
            <li><a class="delete"   link="${basePath  }v2/userrole/del.do" rootPubConlumnId="${currentTimeMillis }"  href="javascript:void(0)" ><span>删除</span></a></li>
            <li><a class="edit" href="${basePath  }v2/userrole/toEdit.do?id={id}"  target="dialog"  rel="editUserRole"><span>修改</span></a></li>
            <li class="line">line</li>
        </ul>
    </div>
    <table class="table" width="100%" layoutH="138">
        <thead>
        <tr>
            <th width="25"><input type="checkbox" class="checkboxCtrl" group="${currentTimeMillis }checkbox"  /></th>
            <th>职员编号</th>
            <th>公司</th>
            <th>职员姓名</th>
            <th>登录名</th>
            <th>在职职位</th>
            <th>添加时间</th>
            <th>状态</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="userRole" varStatus="i" items="${userRole_list }">
            <tr target="id" rel="${userRole.id }">
                <td><input type="checkbox"  name="${currentTimeMillis }checkbox"  value="${userRole.id }" /></td>
                <td><c:out value="${userRole.userV2.bianhao }" escapeXml="true"/></td>
                <td><c:out value="${userRole.company.name }" escapeXml="true"/></td>
                <td><c:out value="${userRole.userV2.realName }" escapeXml="true"/></td>
                <td><c:out value="${userRole.userV2.userName }" escapeXml="true"/></td>
                <td><c:out value="${userRole.role.name }" escapeXml="true"/></td>
                <td><c:out value="${userRole.showTime }" escapeXml="true"/></td>
                <td><c:out value="${userRole.showState }" escapeXml="true"/></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>