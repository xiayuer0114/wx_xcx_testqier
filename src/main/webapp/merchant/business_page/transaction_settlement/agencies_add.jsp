<%@page import="com.lymava.base.model.User"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div  class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel1" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
                                                    <h4 class="modal-title"><i class="fa fa-plus"></i> 新增账户</h4>
                                                </div>
                                                <div class="modal-body">
                                                    <form class="form-horizontal" role="form" id="addLowUser_form">
                                                        <div class="form-body">
                                                            <div class="form-group">
                                                                <label class="col-md-3 control-label">登录名</label>
                                                                <div class="col-md-8">
                                                                    <input type="text"  name="username" id="username"  class="form-control" placeholder="登录名">
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label class="col-md-3 control-label">店铺名称</label>
                                                                <div class="col-md-8">
                                                                    <input type="text" name="realName" id="realName" class="form-control" placeholder="店铺名称">
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label class="col-md-3 control-label">密码</label>
                                                                <div class="col-md-8">
                                                                    <input type="text"  name="password" id="password" class="form-control" placeholder="密码">
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label class="col-md-3 control-label">确认密码</label>
                                                                <div class="col-md-8">
                                                                    <input type="text" name="passwordRe" id="passwordRe" class="form-control" placeholder="确认密码">
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label class="col-md-3 control-label">联系方式</label>
                                                                <div class="col-md-8">
                                                                    <input type="text" name="mobile" id="mobile" class="form-control" placeholder="联系方式">
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label class="col-md-3 control-label">门店地址</label>
                                                                <div class="col-md-8">
                                                                    <input type="text" name="addr" id="addr" class="form-control" placeholder="门店地址">
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label class="col-md-3 control-label">代理商姓名</label>
                                                                <div class="col-md-8">
                                                                    <input type="text" name="nickname" id="nickname" class="form-control" placeholder="代理商姓名">
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label class="col-md-3 control-label">用户状态</label>
                                                                <div class="col-md-8">
                                                                    <select class="bs-select" name="state" svalue="">
                                                                        <option value="<%=User.STATE_OK %>">立即生效</option>
                                                                        <option value="<%=User.STATE_NOTOK %>" >暂不生效</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <label class="col-md-3 control-label">额度模式</label>
                                                                <div class="col-md-8">
                                                                    <select class="bs-select" name="gongxiangedu">
                                                                        <option  value="<%=User.share_balance_yes %>">共享额度</option>
                                                                        <option value="<%=User.share_balance_no %>" >独立额度</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </form>
                                                </div>
                                                <div class="modal-footer">
                                                	<button type="button" class="btn btn-primary" onclick="addLowUser()">确认添加</button>
                                                    <button type="button" class="btn default" data-dismiss="modal" aria-hidden="true">关闭</button>
                                                </div>
                                            </div>
                                        </div> 
                   </div>