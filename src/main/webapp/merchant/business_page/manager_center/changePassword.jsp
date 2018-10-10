<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javascript" src="${basePath }plugin/js/md5.js"></script>

<div class="page-content">
                    <!-- BEGIN PAGE BASE CONTENT -->
                    <div class="row">
                        <div class="col-md-12">
                            <div class="portlet light bordered" id="form_wizard_1">
                                <div class="portlet-title">
                                    <div class="caption">
                                        <i class="fa fa-asterisk font-green"></i>
                                        <span class="caption-subject font-green bold uppercase"> 密码修改
                                        </span>
                                    </div>
                                </div>
                                <div class="portlet-body  clearfix">
                                    <form class="form-horizontal" role="form">
                                        <div class="form-body">
                                            <div class="form-group">
                                                <label class="col-md-3 control-label">输入原始密码</label>
                                                <div class="col-md-2">
                                                    <input id="pwdOld" type="password" class="form-control" placeholder="原始密码">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-3 control-label">输入新密码</label>
                                                <div class="col-md-2">
                                                    <input id="pwdNew"  type="password" class="form-control" placeholder="输入新密码">
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-3 control-label">再次确认新密码</label>
                                                <div class="col-md-2">
                                                    <input id="pwdRe" type="password"  class="form-control" placeholder="再次确认新密码">
                                                    <br>
                                                    <font color="red"><span id="errorMsgForPwd"></span></font>
                                                </div>
                                            </div>
                                            <div class="form-group">
                                                <label class="col-md-3 control-label"></label>
                                                <div class="col-md-8">
                                                    <div class="alert alert-warning">
                                                        <strong>特别提醒：</strong>设置高密度密码可有效防止他人破解您的密码。建议设置密码时区分大小写字母、添加特殊符号%、*、@。 当您习惯了登录器记住密码登录或者其他原因，忘记了密码，您可以联系平台客服找回密码。
                                                    </div>
                                                </div>
                                            </div>

                                        </div>
                                        <div class="form-actions right">
                                            <label class="col-md-3 control-label"></label>
                                            <div class="col-md-4">
                                                <button onclick="changePassword()"  type="button" class="btn green">确认修改</button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>