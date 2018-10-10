<%@page import="com.lymava.base.model.User"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.List"%>
<%@ page import="com.lymava.qier.model.Voucher" %>
<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%
    String op = request.getParameter("op");

    if("update".equals(op)){
        String id = request.getParameter("id");

        Voucher v = new Voucher();
        v.setId(id);
        v = (Voucher)ContextUtil.getSerializContext().get(v);
        request.getSession().setAttribute("fabuUpdate",v);
        request.getSession().setAttribute("op",op);
    }
%>

<div id="myModalLabel1" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
                <h4 class="modal-title"><i class="fa fa-plus"></i> 代金券信息 </h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="addLowUser_form">
                    <div class="form-body">
                        <div class="form-group">
                            <label class="col-md-3 control-label">代金券名称</label>
                            <div class="col-md-8">
                                <input type="text" value="${fabuUpdate.voucherName}" name="voucherName" id="voucherName"  class="form-control" placeholder="代金券名称" maxlength="10">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label">代金券价值</label>
                            <div class="col-md-8">
                                <input type="text" value="${fabuUpdate.voucherValue}" name="voucherValue" id="voucherValue" class="form-control" placeholder="代金券的实际价值" maxlength="11"
                                       onkeypress = 'return /^\d$/.test(String.fromCharCode(event.keyCode))'
                                       oninput= 'this.value = this.value.replace(/\D+/g, "")'
                                       onpropertychange='if(!/\D+/.test(this.value)){return;};this.value=this.value.replace(/\D+/g, "")'
                                       onblur = 'this.value = this.value.replace(/\D+/g, "")'>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label">描述</label>
                            <div class="col-md-8">
                                <input type="text" value="${fabuUpdate.voucherMiaoSu}" name="voucherMiaoSu" id="voucherMiaoSu"  class="form-control" placeholder="描述:'满50立马减20'" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label">数量</label>
                            <div class="col-md-8">
                                <input type="text" value="${fabuUpdate.voucherCount}" name="voucherCount" id="voucherCount"  class="form-control" placeholder="发布多少张代金券" maxlength="10" >
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label">使用条件</label>
                            <div class="col-md-8">
                                <input type="text" value="${fabuUpdate.useWhere}" name="useWhere" id="useWhere"  class="form-control" placeholder="使用条件,不写就是无门槛代金券" maxlength="10" >
                            </div>
                        </div> 

                        <div class="form-group">
                            <label class="col-md-3 control-label">发布时间</label>
                            <div class="col-md-8">
                                <input type="text"  name="username"   class="form-control" placeholder="当前时间,有效时间不填表示长期有效" readonly>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label">有效时间</label>
                            <div class="col-md-8">
                                <input type="date" value="${fabuUpdate.showStopTime}" name="stopTime" id="stopTime"  class="form-control" value="new date()">
                            </div>
                        </div>

                        <div>
                            <label class="col-md-3 control-label"></label>
                            <div class="col-md-8">
                                <font color="red"><span id="errorMsg"></span></font>
                            </div>
                        </div>

                        <br>
                        <br>
                    </div>
                </form>

                <span id="op" value="${op}"></span>
                <span id="id" value="${fabuUpdate.id}"></span>

                <%
                    request.getSession().removeAttribute("fabuUpdate");
                    request.getSession().removeAttribute("op");
                %>

                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" id="addc">确认</button>

                    <script type="text/javascript">
                        $(function () {
                            $("#addc").click(function () {
                                var op = $("#op").attr("value");
                                var id = $("#id").attr("value");

                                var voucherName = $("#voucherName").val();
                                var voucherMiaoSu = $("#voucherMiaoSu").val();
                                var voucherValue = $("#voucherValue").val();
                                var voucherCount = $("#voucherCount").val();
                                var useWhere = $("#useWhere").val();
                                var stopTime = $("#stopTime").val();

                                var date = new Date($("#stopTime").val());
                                var datenow= new Date();
                                var dateString = datenow.getFullYear()+"-"+(datenow.getMonth()+1)+"-"+(datenow.getDate()+1);


                                if(voucherName=="" || voucherName==null ||
                                    voucherMiaoSu=="" || voucherMiaoSu==null ||
                                    voucherValue=="" || voucherValue==null ||
                                    voucherCount=="" || voucherCount==null)
                                {
                                    $("#errorMsg").text("数据不完整!!!");
                                    return;
                                }
                                if(date<datenow){
                                    $("#errorMsg").text("有效时间至少是明天!");
                                    return;
                                };

                                if (stopTime==null || stopTime==""){
                                    stopTime="";
                                }

                                $("#errorMsg").text(" ");


                                $.post("${basePath}/qier/voucher/voucher_add.do",
                                    {
                                        "op":op,
                                        "id":id,
                                        "voucher.voucherName":voucherName,
                                        "voucher.voucherMiaoSu":voucherMiaoSu,
                                        "voucher.voucherValue":voucherValue,
                                        "voucher.voucherCount":voucherCount,
                                        "voucher.useWhere":useWhere,
                                        "voucher.inStopTime":stopTime
                                    },
                                    function (msg) {
                                        msg = JSON.parse(msg);
                                        alert(msg.message);

                                        $('#myModalLabel1').modal('hide');

                                            // 刷新
                                        layer.load(0, {shade: false,time:1000});
                                        var url = '${basePath}/merchant/business_page/voucher/voucher.jsp';
                                        linkToPage(url);
                                    }
                                );

                                return;

                            });

                        });
                    </script>

                    <button type="button" class="btn default" data-dismiss="modal" aria-hidden="true">关闭</button>
                </div>
            </div>

        </div>
    </div>
</div>