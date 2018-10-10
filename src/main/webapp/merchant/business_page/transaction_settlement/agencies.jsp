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
User user_find = new User();
user_find.setTopUser(user);

StringBuilder pageCase = new StringBuilder();

String page_temp = request.getParameter("page");
String pageSize_temp = request.getParameter("pageSize");
String username = request.getParameter("username");
if(username != null && !username.trim().isEmpty()){
	user_find.setUsername(username);
	pageCase.append("&username="+username);
	request.setAttribute("username", username);
}



PageSplit pageSplit = new PageSplit(page_temp,pageSize_temp);
pageSplit.setPageSize(15);


Iterator  object_ite = ContextUtil.getSerializContext().findIterable(user_find, pageSplit);
request.setAttribute("object_ite", object_ite); 
request.setAttribute("pageCase", pageCase); 
request.setAttribute("pageSplit", pageSplit); 
%>
                <!-- BEGIN CONTENT BODY -->
                <div class="page-content">
                    <!-- BEGIN PAGE BASE CONTENT -->
                    <div class="row">
                        <div class="col-md-12">
                            <div class="portlet light bordered" id="form_wizard_1">
                                <div class="portlet-title">
                                    <div class="caption">
                                        <i class="fa fa-list font-green"></i>
                                        <span class="caption-subject font-green bold uppercase"> 商户列表
                                        </span>
                                    </div>
                                </div>
                                <div class="portlet-body">
                                    <form  name="search_form"  class="form-inline" style="margin-bottom:10px;" role="form" action="${requestURL }">
                                        <div class="form-group">
                                            <label class="sr-only" for="num">登陆用户名</label>
                                            <div class="input-icon">
                                                <i class="fa fa-user"></i>
                                                <input type="text" class="form-control" value="${username }" name="username" placeholder="登陆用户名"> </div>
                                        </div>
                                        <button type="button"  class="btn btn-default button-submit"><i class="fa fa-search"></i> 搜索</button>
                                        <a href="javascript:void(0)" onclick="addLowUserShow()" type="submit" class="btn btn-primary"  ><i class="fa fa-plus"></i> 新增账号</a>
                                        <script type="text/javascript">
										function addLowUserShow(){
											 jQuery.ajax({ 
													type : "post",
													url : "${basePath }merchant/business_page/transaction_settlement/agencies_add.jsp",
													data : "",
													success : function(msg) { 
														modal_current_show(msg);
												    }
												});
										}
										function changeLowUserBalanceShow(lowUserId){
											 jQuery.ajax({ 
													type : "post",
													url : "${basePath }merchant/business_page/transaction_settlement/agencies_changeBalance.jsp",
													data : "lowUserId="+lowUserId,
													success : function(msg) { 
														modal_current_show(msg);
												    }
												});
										}
									</script>
                                    </form>
                                    <table class="table table-striped table-hover table-bordered" data-search="true">
                                            <thead>
                                                <tr>
                                                    <th align="center">登录名</th>
                                                    <th text-align="center">用户名称</th>
                                                    <th text-align="center">门店名称</th>
                                                    <th text-align="center">联系电话</th>
                                                    <th text-align="center">邮箱</th>
                                                    <th text-align="center">余额</th>
                                                    <th text-align="center">冻结</th>
                                                    <th text-align="center">额度模式</th>
                                                    <th text-align="center">状态</th>
                                                    <th text-align="center">注册日期</th>
                                                    <th text-align="center">操作</th>
                                                </tr>
                                            </thead>
                                            <tbody>
	                                          <c:forEach var="user" varStatus="i" items="${object_ite }">
												<tr target="id" rel="${user.id }" id="${user.id }">
													<td><c:out value="${user.username }" escapeXml="true"/></td>
													<td><c:out value="${user.nickname }" escapeXml="true"/></td>
													<td><c:out value="${user.realname }" escapeXml="true"/></td>
													<td><c:out value="${user.phone }" escapeXml="true"/></td>
													<td><c:out value="${user.email }" escapeXml="true"/></td>
													<td><c:out value="${user.showBalance }" escapeXml="true"/></td>
													<td><c:out value="${user.showFrozenBalance }" escapeXml="true"/></td>
													<td><c:out value="${user.showShareBalance }" escapeXml="true"/></td>
													<td>
													<a onclick="changeLowUserState('${user.id }','${requestURL }')"  href="javascript:void(0)" ><c:out value="${user.showState }" escapeXml="true"/>
													</a>
													</td>
													<td><c:out value="${user.showTime }" escapeXml="true"/></td>
													<td>
													<button onclick="changeLowUserBalanceShow('${user.id }')" class="btn btn-link btn-xs"><i class="fa fa-hand-pointer-o"></i>
													<c:if test="${user.share_balance == 1}">余额转移</c:if>
															<c:if test="${user.share_balance == 2}">额度变动</c:if>
													</button>
													</td>
												</tr>
											</c:forEach>
                                      </tbody>
                                    </table>
                                    <ul class="pager" > 
										<li  page="1"><a href="javascript:void(0)" >首页</a></li>
										<li  page="${pageSplit.prePage }"><a href="javascript:void(0)"  >上一页</a></li>
										<c:forEach var="current_page" begin="${pageSplit.fenyeFirstPage }" end="${pageSplit.fenyeLastPage }" >
										<li  page="${current_page}"><a href="javascript:void(0)"     >${current_page}</a></li>
										</c:forEach>
										<li  page="${pageSplit.nextPage }"><a href="javascript:void(0)"    >下一页</a></li>
								  	</ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>  