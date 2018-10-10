<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.commons.exception.CheckException"%>
<%@page import="com.lymava.base.util.FinalVariable"%>
<%@page import="com.lymava.base.model.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%
User user = (User) request.getAttribute(FinalVariable.SESSION_FRONT_FULL_USER);
CheckException.checkIsTure(user != null, "请先登录！");
//下级用户编号
		String lowUserId = request.getParameter("lowUserId");
		
		User lowUser = null;
		if(MyUtil.isValid(lowUserId)){
			lowUser = (User) ContextUtil.getSerializContext().get(User.class, lowUserId);
		}
		
		CheckException.checkIsTure(lowUser != null && lowUser.getTopUserId().equals(user.getId()) , "您操作的用户不存在！");
	
	request.setAttribute("lowUser", lowUser);
%>
<div  class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel1" aria-hidden="true" >
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
                                                    <h4 class="modal-title"><i class="fa fa-plus"></i> 管理额度</h4>
                                                </div>
                                                <div class="modal-body">
                                                    <form class="form-horizontal" role="form" id="addLowUser_form">
                                                        <div class="form-body">
                                                            <div class="form-group">
                                                                <label class="col-md-3 control-label">登录名</label>
                                                                <div class="col-md-4">
                                                                    	<input type="text" class="form-control"  value="${lowUser.username }" readonly="readonly" > 
																		<input type="hidden" id="${currentTimeMillis }lowUserId" name="lowUserId" value="${lowUser.id }"   >
																		<input type="hidden" id="${currentTimeMillis }orderId" name="orderId" value="<%=(System.currentTimeMillis()+"").substring(1) %>"   >
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label class="col-md-3 control-label">用户名称</label>
                                                                <div class="col-md-4">
                                                                    <input type="text" class="form-control"  value="${lowUser.nickname }"  readonly="readonly" >
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label class="col-md-3 control-label">店铺名称</label>
                                                                <div class="col-md-4">
                                                                    <input type="text" class="form-control"  value="${lowUser.realname }"  readonly="readonly" >
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label class="col-md-3 control-label">变动余额</label>
                                                                <div class="col-md-3">
                                                                    <input class="form-control"  id="${currentTimeMillis }balance" type="text"   >
                                                                </div>
                                                                <div class="col-md-1" style="padding-left:0;;margin: 0;padding-top: 3px;">
	                                                                <h3 class="font-blue" style="padding: 0;margin: 0;">
	                                                                   元
	                                                              	</h3>
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label class="col-md-3 control-label">备注说明</label>
                                                                <div class="col-md-4">
                                                                    <input class="form-control"  id="${currentTimeMillis }memo" type="text"  >
                                                                </div>
                                                            </div> 
                                                        </div>
                                                    </form>
                                                </div>
                                                <div class="modal-footer">
                                                	<button type="button" class="btn btn-primary" onclick="changeLowUserBalance('${currentTimeMillis }')">确认变更</button>
                                                    <button type="button" class="btn default" data-dismiss="modal" aria-hidden="true">关闭</button>
                                                </div>
                                            </div>
                                        </div>  
                   </div>