<%@page import="com.lymava.base.model.User"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.List"%>
<%@ page import="com.lymava.commons.util.QrCodeUtil" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="com.lymava.commons.util.MyUtil" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="com.lymava.commons.util.IOUtil" %>
<%@ page import="com.lymava.commons.util.ImageUtil" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="com.lymava.wechat.gongzhonghao.Gongzonghao" %>
<%@ page import="com.lymava.base.util.FinalVariable" %>
<%@ page import="com.lymava.wechat.gongzhonghao.GongzonghaoContent" %>
<%@ page import="com.lymava.commons.exception.CheckException" %>
<%@ page import="com.lymava.commons.vo.EntityKeyValue" %>
<%@ page import="java.util.LinkedList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
    User user = (User) request.getAttribute(FinalVariable.SESSION_FRONT_FULL_USER);
    CheckException.checkIsTure(user != null, "请先登录！");

    String isMerchant = request.getParameter("isMerchant");

    request.setAttribute("isMerchant",isMerchant);

%>
<div id="myModalLabel1" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel1" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
                                                    <h4 class="modal-title"><i class="fa fa-plus"></i> 新增收银员</h4>
                                                </div>
                                                <div class="modal-body">
                                                    <form class="form-horizontal" role="form" id="addLowUser_form">
                                                        <div class="form-body">
                                                            <div class="form-group">
                                                                <label class="col-md-4 control-label">电话</label>
                                                                <div class="col-md-8">
                                                                    <input type="text" name="phone" id="phone" class="form-control" placeholder="电话" maxlength="11" >
                                                                </div>
                                                            </div>

                                                            <div class="form-group">
                                                                <label class="col-md-4 control-label">密码</label>
                                                                <div class="col-md-8">
                                                                    <input type="password" name="pwd" id="pwd" class="form-control" placeholder="密码不能小于六位" maxlength="8">
                                                                </div>
                                                            </div>

                                                            <div class="form-group">
                                                                <label class="col-md-4 control-label">确认密码</label>
                                                                <div class="col-md-8">
                                                                    <input type="password" name="pwd" id="newpwd" class="form-control" placeholder="密码不能小于六位" maxlength="8">
                                                                </div>
                                                            </div>

                                                            <div>
                                                                <label class="col-md-4 control-label"></label>
                                                                <div class="col-md-8">
                                                                    <font color="red"><span id="errorMsg"></span></font>
                                                                </div>
                                                            </div>


                                                            <br>
                                                        </div>
                                                    </form>

                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-primary" id="addc">确认添加</button>

                                                        <script type="text/javascript">
                                                            $(function () {
                                                                $("#addc").click(function () {
                                                                    var phone = $("#phone").val();
                                                                    var pwd = $("#pwd").val();
                                                                    var newpwd = $("#newpwd").val();


                                                                        // 数据验证
                                                                    if(pwd=="" || pwd==null || phone=="" || phone==null || newpwd=="" || newpwd==null){
                                                                        $("#errorMsg").text("数据不完整!!!");
                                                                        return;
                                                                    }
                                                                    if(phone.length <11){
                                                                        $("#errorMsg").text("电话为11位数!!!");
                                                                        return;
                                                                    }
                                                                    if(pwd.length<6 || newpwd.length<6){
                                                                        $("#errorMsg").text("密码不能小于6位!!!");
                                                                        return;
                                                                    }
                                                                    if(pwd != newpwd){
                                                                        $("#errorMsg").text("两次输入的密不一样!!!");
                                                                        return;
                                                                    }


                                                                        // 所有数据正确   清楚错误信息
                                                                    $("#errorMsg").text(" ");

                                                                    $.post("${basePath}/qier/cashier/cashier_add.do",{"phone":phone,"pwd":pwd},function (msg) {
                                                                        msg = JSON.parse(msg);
                                                                        alert(msg.message);

                                                                        layer.load(0, {shade: false,time:1000});
                                                                        var url = '${basePath}/merchant/business_page/cashier/cashier.jsp';
                                                                        linkToPage(url);
                                                                    });
                                                                });

                                                            });
                                                        </script>

                                                        <button type="button" class="btn default" data-dismiss="modal" aria-hidden="true">关闭</button>
                                                    </div>
                                                </div>

                                            </div>
                                        </div> 
                   </div>