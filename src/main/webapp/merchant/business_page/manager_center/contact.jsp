<%@page import="com.lymava.base.vo.State"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.commons.exception.CheckException"%>
<%@page import="com.lymava.base.util.FinalVariable"%>
<%@page import="com.lymava.base.model.User"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%

User user = (User) request.getAttribute(FinalVariable.SESSION_FRONT_FULL_USER);
CheckException.checkIsTure(user != null, "请先登录！");
//用户自己的
//remittanceRequest_find.setUser(user);

String page_temp = request.getParameter("page");
String pageSize_temp = request.getParameter("pageSize");

PageSplit pageSplit = new PageSplit(page_temp,pageSize_temp);
pageSplit.setPageSize(15);
%>
                <!-- BEGIN CONTENT BODY -->
                <div class="page-content">
                    <!-- BEGIN PAGE BASE CONTENT -->
                    <div class="row">
                        <div class="col-md-12">
                            <div class="portlet light bordered" id="form_wizard_1">
                                <div class="portlet-title">
                                    <div class="caption">
                                        <i class="fa fa-info-circle font-green"></i>
                                        <span class="caption-subject font-green bold uppercase"> 联系我们
                                        </span>
                                    </div>
                                </div>
                                <div class="portlet-body">
                                    <table class="table table-striped table-hover table-bordered" data-search="true">
                                            <thead>
                                                <tr>
                                                    <th align="center">联系名称</th>
                                                    <th text-align="center">真实姓名</th>
                                                    <th text-align="center">座机电话</th>
                                                    <th text-align="center">手机号码</th>
                                                    <th text-align="center">QQ</th>
                                                    <th text-align="center">邮箱</th>
                                                    <th text-align="center">系统时间</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                          <c:forEach var="object" varStatus="i" items="${object_ite }">
												<tr >
													<td><c:out value="${object.name }" escapeXml="true"/></td>
													<td><c:out value="${object.realName }" escapeXml="true"/></td>
													<td><c:out value="${object.tel }" escapeXml="true"/></td>
													<td><c:out value="${object.phone }" escapeXml="true"/></td>
								 					<td><c:out value="${object.qq }" escapeXml="true"/></td>
								 					<td><c:out value="${object.email }" escapeXml="true"/></td>
								 					<td><c:out value="${object.showTime }" escapeXml="true"/></td>
								 				</tr>
										</c:forEach>
                                            </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>