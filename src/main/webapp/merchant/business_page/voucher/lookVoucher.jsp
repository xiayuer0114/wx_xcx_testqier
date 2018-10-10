<%@page import="com.lymava.base.model.User"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.lymava.qier.model.Voucher" %>
<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%

        String id = request.getParameter("id");

        Voucher v = new Voucher();
        v.setId(id);
        v = (Voucher)ContextUtil.getSerializContext().get(v);

        // 存入 更新对象  和 操作符
        request.getSession().setAttribute("fabuUpdate",v);

%>

<div id="myModalLabel1" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
                <h4 class="modal-title"><i class="fa fa-plus"></i> 代金券信息 </h4>
            </div>

            <%--页面主体--%>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="addLowUser_form">
                    <div class="form-body">

                        <div class="form-group">
                            <label class="col-md-11 control-label">小提示:带*的内容可以不填</label>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label">代金券名称</label>
                            <div class="col-md-8">
                                <input readonly type="text" value="${fabuUpdate.voucherName}" name="voucherName" id="voucherName"  class="form-control" placeholder="代金券名称" maxlength="10">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label">代金券面额</label>
                            <div class="col-md-8">
                                <input readonly type="text" value="${fabuUpdate.voucherValue}" name="voucherValue" id="voucherValue" class="form-control" placeholder="代金券的实际价值" maxlength="11" >
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label">数量</label>
                            <div class="col-md-8">
                                <input readonly type="text" value="${fabuUpdate.voucherCount}" name="voucherCount" id="voucherCount"  class="form-control" placeholder="您想要发布多少张代金券" maxlength="10" >
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label"> * 使用条件</label>
                            <div class="col-md-8">
                                <input readonly type="text" value="${fabuUpdate.useWhere}" name="useWhere" id="useWhere"  class="form-control" placeholder="请输入一个数字,不填写就是无门槛使用" maxlength="10" >
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label"> * 描述</label>
                            <div class="col-md-8">
                                <input readonly type="text" value="${fabuUpdate.voucherMiaoSu}" name="voucherMiaoSu" id="voucherMiaoSu"  class="form-control" placeholder="简单描述一下你的代金券如:'满50立马减20', 可以不填" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label">发布时间</label>
                            <div class="col-md-8">
                                <input readonly type="text" value="${fabuUpdate.showReleaseTime}" name="releaseTime" id="releaseTime" class="form-control" onfocus="(this.type='date')"  placeholder="您想在那一天开始发布" >
                            </div>
                        </div>


                        <div class="form-group">
                            <label class="col-md-3 control-label"> * 结束时间</label>
                            <div class="col-md-8">
                                <input readonly type="text" value="${fabuUpdate.showStopTime}" name="stopTime" id="stopTime" class="form-control" onfocus="(this.type='date')"  placeholder="您想在那一天结束发布,可以不填写" >
                            </div>
                        </div>

                    </div>
                </form>

                <%
                    // 更新执行完之后,移除session (好像没什么卵用,预防添加和修改操作出问题)
                    request.getSession().removeAttribute("fabuUpdate");
                    request.getSession().removeAttribute("op");
                %>

                <div class="modal-footer">
                    <button type="button" class="btn default" data-dismiss="modal" aria-hidden="true">关闭</button>
                </div>
            </div>

        </div>
    </div>
</div>


