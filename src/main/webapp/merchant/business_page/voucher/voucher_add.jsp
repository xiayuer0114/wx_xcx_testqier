<%@page import="com.lymava.base.model.User"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.lymava.qier.model.Voucher" %>
<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%
    String op = request.getParameter("op");

        // 操作命令是修改时的赋值操作
    if("update".equals(op)){
        String id = request.getParameter("id");

        Voucher v = new Voucher();
        v.setId(id);
        v = (Voucher)ContextUtil.getSerializContext().get(v);

            // 存入 更新对象  和 操作符
        request.getSession().setAttribute("fabuUpdate",v);
        request.getSession().setAttribute("op",op);

//        request.getSession().setAttribute("lingquState",v.getUser_get_startTime());
//        request.getSession().setAttribute("lingquEnd",v.getUser_get_endTime());
//        request.getSession().setAttribute("shiyongState",v.getUser_use_startTime());
//        request.getSession().setAttribute("shiyongEnd",v.getUser_use_endTime());
    }

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
                                <input type="text" value="${fabuUpdate.voucherName}" name="voucherName" id="voucherName"  class="form-control" placeholder="代金券名称" maxlength="10">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label">代金券面额</label>
                            <div class="col-md-8">
                                <input type="text" value="${fabuUpdate.voucherValue}" name="voucherValue" id="voucherValue" class="form-control" placeholder="代金券的实际价值" maxlength="11" >
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label">数量</label>
                            <div class="col-md-8">
                                <input type="text" value="${fabuUpdate.voucherCount}" name="voucherCount" id="voucherCount"  class="form-control" placeholder="您想要发布多少张代金券" maxlength="10" >
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label"> * 使用条件</label>
                            <div class="col-md-8">
                                <input type="text" value="${fabuUpdate.useWhere}" name="useWhere" id="useWhere"  class="form-control" placeholder="请输入一个数字,不填写就是无门槛使用" maxlength="10" >
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label"> * 描述</label>
                            <div class="col-md-8">
                                <input type="text" value="${fabuUpdate.voucherMiaoSu}" name="voucherMiaoSu" id="voucherMiaoSu"  class="form-control" placeholder="简单描述一下你的代金券如:'满50立马减20', 可以不填" maxlength="50">
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label">发布时间</label>
                            <div class="col-md-8">
                                <input type="text" value="${fabuUpdate.showReleaseTime}" name="releaseTime" id="releaseTime" class="form-control date_m" dateFmt="yyyy-MM-dd HH"   placeholder="您想在那一天开始发布" >
                            </div>
                        </div>


                        <div class="form-group">
                            <label class="col-md-3 control-label"> * 结束发布</label>
                            <div class="col-md-8">
                                <input type="text" value="${fabuUpdate.showStopTime}" name="stopTime" id="stopTime" class="form-control date_m" dateFmt="yyyy-MM-dd HH"   placeholder="您想在那一天结束发布,可以不填写" >
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-3 control-label"> * 限时使用:开始</label>
                            <div class="col-md-8">
                                <input type="text" value="${fabuUpdate.showUseReleaseTime}" name="useReleaseTime" id="useReleaseTime" class="form-control date_m" dateFmt="yyyy-MM-dd HH"  placeholder="您想顾客在从那一天开始可以使用" >
                                <%--<input type="text" value="" name="useReleaseTime" id="useReleaseTime" class="form-control date_m" dateFmt="yyyy-MM-dd HH"  placeholder="您想顾客在从那一天开始可以使用" >--%>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-3 control-label"> * 限时使用:结束</label>
                            <div class="col-md-8">
                                <input type="text" value="${fabuUpdate.showUseStopTime}" name="useStopTime" id="useStopTime" class="form-control date_m" dateFmt="yyyy-MM-dd HH" placeholder="您想顾客在那一天后就不能使用了" >
                                <%--<input type="text" value="" name="useStopTime" id="useStopTime" class="form-control date_m" dateFmt="yyyy-MM-dd HH" placeholder="您想顾客在那一天后就不能使用了" >--%>
                            </div>
                        </div>


                        <br>

                            <%--错误信息提示--%>
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

                
                <%--预存数据 --%>
                    <%--↓操作符, --%>
                <span id="op" value="${op}"></span>
                    <%--↓更新对象的id , --%>
                <span id="id" value="${fabuUpdate.id}"></span>
                    <%--↓更新的对象,--%>
                <span id="fabuUpdate" value="${fabuUpdate}"></span>


                <span id="lingquState" value="${lingquState }"></span>
                <span id="lingquEnd" value="${lingquEnd }"></span>
                <span id="shiyongState" value="${shiyongState }"></span>
                <span id="shiyongEnd" value="${shiyongEnd }"></span>

                <%
                        // 更新执行完之后,移除session (好像没什么卵用,预防添加和修改操作出问题)
                    request.getSession().removeAttribute("fabuUpdate");
                    request.getSession().removeAttribute("op");
                %>

                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" id="addc">确认</button>

                    <script type="text/javascript">

                        $(function () {
                                // 确定按钮事件  (添加和修改)
                            $("#addc").click(function () {

                                    // 得到操作符 和 操作对象的id
                                var op = $("#op").attr("value");
                                var id = $("#id").attr("value");

                                // 设置 添加&修改 的值
                                // ↓ 必填项
                                var voucherName = $("#voucherName").val();
                                var voucherValue = $("#voucherValue").val();
                                var voucherCount = $("#voucherCount").val();
                                var releaseTime = $("#releaseTime").val();

                                // ↓ 选填项
                                var useWhere = $("#useWhere").val();
                                var voucherMiaoSu = $("#voucherMiaoSu").val();
                                var stopTime = $("#stopTime").val();

                                var useReleaseTime = $("#useReleaseTime").val();
                                var useStopTime = $("#useStopTime").val();


//                                var  fromData = $("#addLowUser_form").serialize();

//                                return;

                                // 必填项完整性判断
                                if(voucherName=="" || voucherName==null || voucherValue=="" || voucherValue==null ||
                                    voucherCount=="" || voucherCount==null || releaseTime=="" || releaseTime==null)
                                {
                                    $("#errorMsg").text("数据不完整!!!      不带*号的为必填项!");
                                    return;
                                }

                                $("#errorMsg").text(" ");

//                                // 获取所有表单元素
//                                var fromData = $("#addLowUser_form").serialize();

                                $.post("${basePath}/qier/voucher/voucher_add.do",
                                    {
                                        "op":op,
                                        "id":id,

                                        "voucherName":voucherName,
                                        "voucherValue":voucherValue,
                                        "voucherCount":voucherCount,
                                        "releaseTime":releaseTime,

                                        "useWhere":useWhere,
                                        "voucherMiaoSu":voucherMiaoSu,
                                        "stopTime":stopTime,

                                        "useReleaseTime":useReleaseTime,
                                        "useStopTime":useStopTime,
                                    },
                                    function (msg) {

                                        msg = JSON.parse(msg);

                                        if(msg.statusCode == 300){
                                            $("#errorMsg").text(msg.message);
                                            return;
                                        }

                                        alert(msg.message);

                                        $('#myModalLabel1').modal('hide');

                                            // 刷新
                                        layer.load(0, {shade: false,time:1000});
                                        var url = '${basePath}/merchant/business_page/voucher/voucher.jsp';
                                        linkToPage(url);
                                    }
                                );
                            });

                        });
                    </script>

                    <button type="button" class="btn default" data-dismiss="modal" aria-hidden="true">关闭</button>
                </div>
            </div>

        </div>
    </div>
</div>


