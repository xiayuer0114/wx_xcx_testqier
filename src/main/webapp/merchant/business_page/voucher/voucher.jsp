<%@page import="com.lymava.base.vo.State"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.commons.exception.CheckException"%>
<%@page import="com.lymava.base.util.FinalVariable"%>
<%@page import="com.lymava.base.model.User"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.List"%>
<%@ page import="com.lymava.qier.model.Voucher" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="static java.lang.System.currentTimeMillis" %>
<%@ page import="com.lymava.qier.util.SunmingUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    User user = (User) request.getAttribute(FinalVariable.SESSION_FRONT_FULL_USER);
    CheckException.checkIsTure(user != null, "请先登录！");


        // 通过商家登录 获取他的userId  通过userId获取他的代金券信息
    Voucher voucher = new Voucher();
    voucher.setTopUserId(user.getId());
    List<Voucher> vouchers = ContextUtil.getSerializContext().findAll(voucher);


    SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");

    for (int i=0; i<vouchers.size(); i++){

        if(vouchers.get(i).getVoucherCount() == vouchers.get(i).getVoucherOutCount()){
            vouchers.get(i).setState(2);
            ContextUtil.getSerializContext().updateObject(user.getId(),vouchers.get(i));
        }

        if(vouchers.get(i).getStopTime()==null || "".equals(vouchers.get(i).getStopTime()) || SunmingUtil.dateStrToLongYMD("2999-12-12").equals(vouchers.get(i).getStopTime())){
            //vouchers.get(i).setShowStopTime("长期有效");
            continue;
        } else{
            //date= new Date(vouchers.get(i).getStopTime());
            //vouchers.get(i).setShowStopTime(simpleDateFormat.format(date));
        };
        if(vouchers.get(i).getStopTime()<currentTimeMillis() && vouchers.get(i).getState()!=3){
            vouchers.get(i).setState(3);
            ContextUtil.getSerializContext().updateObject(user.getId(),vouchers.get(i));
        }
    }

    request.setAttribute("object_ite", vouchers);

%>

<!-- BEGIN CONTENT BODY -->

<div class="page-content" id="containerCashier">
    <!-- BEGIN PAGE BASE CONTENT -->
    <div class="row">
        <div class="col-md-12">
            <div class="portlet light bordered" id="form_wizard_1">
                <div class="portlet-title">
                    <div class="caption">
                        <i class="fa fa-list font-green"></i>
                        <span class="caption-subject font-green bold uppercase"> 代金券列表
                                        </span>
                    </div>
                </div>
                <div class="portlet-body">
                    <form  name="search_form"  class="form-inline" style="margin-bottom:10px;" role="form" action="${requestURL }">
                        <a href="javascript:void(0)" onclick="addNewVoucher('add')" type="submit" class="btn btn-primary"  ><i class="fa fa-plus"></i> 发布新的代金券</a>
                        <a href="javascript:void(0)" onclick="refresh()" type="button" class="btn btn-primary"  >刷新</a>
                    </form>
                    <table class="table table-striped table-hover table-bordered" data-search="true">
                        <thead>
                        <tr>
                            <th align="center">代金券名称</th>
                            <th text-align="center">代金券价值</th>
                            <th text-align="center">总数量</th>
                            <th text-align="center">已发出</th>
                            <th text-align="center">使用条件</th>
                            <th text-align="center">发布时间</th>
                            <th text-align="center">有效时间</th>
                            <%--<th text-align="center">领取时间</th>--%>
                            <%--<th text-align="center">使用时间</th>--%>
                            <th text-align="center">描述</th>
                            <th text-align="center">状态</th>
                            <th text-align="center">操作</th>
                        </tr>
                        </thead>
                        <tbody id="cashierTable">
                        <c:forEach var="user" varStatus="i" items="${object_ite }">
                            <tr target="id" rel="${user.id }" id="${user.id }">
                                <td><c:out value="${user.voucherName}" escapeXml="true"/></td>
                                <td><c:out value="${user.voucherValue}" escapeXml="true"/></td>

                                <td><c:out value="${user.voucherCount}" escapeXml="true"/></td>
                                <td><c:out value="${user.voucherOutCount}" escapeXml="true"/></td>
                                <td><c:out value='${user.useWhere!=null?user.useWhere:"无门槛"}' escapeXml="true"/></td>
                                <%--<td><c:out value='${user.showUseWhere}' escapeXml="true"/></td>--%>

                                <td><c:out value="${user.showReleaseTime}" escapeXml="true"/></td>
                                <td><c:out value="${user.showStopTime}" escapeXml="true"/></td>
                                <%--<td><c:out value="${user.showGetTime}" escapeXml="true"/></td>--%>
                                <%--<td><c:out value="${user.showUseTime}" escapeXml="true"/></td>--%>
                                <td><c:out value="${user.voucherMiaoSu}" escapeXml="true"/></td>
                                <td>
                                    <c:if test="${user.state==0}">待提交</c:if>
                                    <c:if test="${user.state==1}">发布中</c:if>
                                    <c:if test="${user.state==2}">已结束</c:if>
                                    <c:if test="${user.state==3}">已过期</c:if>
                                    <c:if test="${user.state==4}">待审核</c:if>
                                </td>

                                <td>
                                    <c:if test="${user.state==0}">
                                        <button onclick="addVoucher('${user.id}')" class="btn btn-primary">提交</button>
                                        <button onclick="updateVoucher('${user.id}')" class="btn btn-info">修改</button>
                                        <button onclick="delVoucher('${user.id}')" class="btn btn-danger">删除</button>
                                    </c:if>
                                    <c:if test="${user.state==1}">
                                        <button onclick="lookVoucher('${user.id}')" class="btn btn-info">查看</button>
                                        <%--<button onclick="endVoucher('${user.id}','${user.voucherOutCount}')" class="btn btn-default">结束发放</button>--%>
                                    </c:if>
                                    <c:if test="${user.state==2}">
                                        <button onclick="lookVoucher('${user.id}')" class="btn btn-info">查看</button>
                                        <%--<button onclick="resetVoucher('${user.id}')" class="btn btn-warning">修改后重新发布</button>--%>
                                    </c:if>
                                    <c:if test="${user.state==3}">
                                        <button onclick="lookVoucher('${user.id}')" class="btn btn-info">查看</button>
                                        <%--<button onclick="delVoucher('${user.id}')" class="btn btn-danger">删除</button>--%>
                                    </c:if>
                                    <c:if test="${user.state==4}">
                                        <button onclick="lookVoucher('${user.id}')" class="btn btn-info">查看</button>
                                        <%--<button onclick="delVoucher('${user.id}')" class="btn btn-danger">删除</button>--%>
                                    </c:if>
                                </td>


                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>

                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">

    /**
     * 刷新
     */
    function refresh(){
        layer.load(0, {shade: false,time:1500});
        var url = '${basePath}merchant/business_page/voucher/voucher.jsp';
        linkToPage(url);
    }
    /**
     * 发布新的代金券  填写代金券的信息(未正式发布)
     */
    function addNewVoucher(op){
        jQuery.ajax({
            type : "post",
            url : "${basePath}merchant/business_page/voucher/voucher_add.jsp?op="+op,
            data : "",
            success : function(msg) {
                modal_current_show(msg);
            }
        });
    }

    /**
     * 状态为 未发布的代金券的方法  add(发布)  update(修改)  del(删除)
     */
    function addVoucher(voucherid){
        if(!confirm("确定提交?")){
            return;
        }

        $.post("${basePath }/qier/voucher/addVoucher.do",{"voucherId":voucherid},function (msg) {
            alert(msg);

            layer.load(0, {shade: false,time:1000});
            var url = '${basePath }/merchant/business_page/voucher/voucher.jsp';
            linkToPage(url);
        });
    }
    function updateVoucher(id){
        jQuery.ajax({
            type : "post",
            url : "${basePath }merchant/business_page/voucher/voucher_add.jsp?op=update",
            data : {"id":id},
            success : function(msg) {
                modal_current_show(msg);
            }
        });

    }

    function lookVoucher(id){
        jQuery.ajax({
            type : "post",
            url : "${basePath }merchant/business_page/voucher/lookVoucher.jsp?op=update",
            data : {"id":id},
            success : function(msg) {
                modal_current_show(msg);
            }
        });

    }

    function delVoucher(voucherid){
        if(!confirm("确定删除?")){
            return;
        }
        $.post("${basePath }/qier/voucher/delVoucher.do",{"voucherId":voucherid},function (msg) {
            alert(msg);

            layer.load(0, {shade: false,time:1000});
            var url = '${basePath }/merchant/business_page/voucher/voucher.jsp';
            linkToPage(url);
        });
    }


    /**
     * 结束发放
     */
    function endVoucher(id, outCount) {
        if(!confirm("确定结束?")){
            return;
        }
        $.post("${basePath }/qier/voucher/endVoucher.do",{"voucherId":id,"outCount":outCount},function (msg) {
            alert(msg);

            layer.load(0, {shade: false,time:1000});
            var url = '${basePath }/merchant/business_page/voucher/voucher.jsp';
            linkToPage(url);
        });
    }


    /*
    *   修改后重新发布
    * */
    function resetVoucher(id){
        layer.open({
            type: 1,
            title: '修改后 重新发布',
            maxmin: true,
            shadeClose: true, //点击遮罩关闭层
            area : ['400' , '275px'],
            content: '\<\div style="padding:20px;">  ' +
            '               <br><br> 添加数量: <input type="text" id="countAll"  /> ' +
            '               <br><br> 有效时间: <input type="date" id="date" maxlength="10"/>' +
            '               <br>     提示:有效时间不选择表示长期有效. ' +
            '         \<\/div>',
            btn: ['修改','取消'],
            btn1:function(index, layero){
                    // 获取添加数量和有效时间  并验证
                var date = new Date($("#date").val());
                var datenow= new Date();
                var dateString = datenow.getFullYear()+"-"+(datenow.getMonth()+1)+"-"+(datenow.getDate()+1);
                if(date<datenow){
                    alert("有效时间至少是明天!.")
                    return;
                };

                var date = $("#date").val();
                if (date==null || date==""){
                    date="";
                }
                var countAll = $("#countAll").val();
                if(countAll<=0){
                    alert("数量请输入0以上的值");
                    return;
                }

                $.post("${basePath }/qier/voucher/revampVoucher.do",{"voucherId":id,"countAll":countAll,"date":date},function (msg) {
                    alert(msg);

                    layer.load(0, {shade: false,time:1000});
                    var url = '${basePath }/merchant/business_page/voucher/voucher.jsp';
                    linkToPage(url);
                });
            }
        });

    }




</script>