<%@page import="com.lymava.base.vo.State"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.commons.exception.CheckException"%>
<%@page import="com.lymava.base.util.FinalVariable"%>
<%@page import="com.lymava.base.model.User"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.List"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.lymava.qier.model.Cashier" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%
    User user = (User) request.getAttribute(FinalVariable.SESSION_FRONT_FULL_USER);
    CheckException.checkIsTure(user != null, "请先登录！");

//用户自己的
    Cashier user_find = new Cashier();
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


        // 得到商户 根据商户查找他的收银员
    User cashier_find = new User();
    cashier_find.setTopUser(user);
    List<User> cashier_list = ContextUtil.getSerializContext().findAll(cashier_find);

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
                        <span class="caption-subject font-green bold uppercase"> 收银员列表
                                        </span>
                    </div>
                </div>
                <div class="portlet-body">
                    <form  name="search_form"  class="form-inline" style="margin-bottom:10px;" role="form" action="${requestURL }">
                        <a href="javascript:void(0)" onclick="addLowUserShow()" type="submit" class="btn btn-primary"  ><i class="fa fa-plus"></i> 添加收银员</a>
                        <a href="javascript:void(0)" onclick="refresh()" type="button" class="btn btn-primary"  >刷新</a>
                    </form>
                    <table class="table table-striped table-hover table-bordered" data-search="true">
                        <thead>
                        <tr>
                            <th align="center">电话</th>
                            <th text-align="center">注册时间</th>
                            <th text-align="center">已收金额</th>
                            <th text-align="center">操作</th>
                        </tr>
                        </thead>
                        <tbody id="cashierTable">
                        <c:forEach var="user" varStatus="i" items="${object_ite }">
                            <tr target="id" rel="${user.id }" id="${user.id }">
                                <td><c:out value="${user.phone }" escapeXml="true"/></td>
                                <td><c:out value="${user.showTime }" escapeXml="true"/></td>
                                <td><c:out value="${user.showBalance }" escapeXml="true"/></td>
                                <td>
                                    <c:if test="${user.state== 1}">
                                        <button onclick="changeCashier('${user.id}',this)" class="btn btn-link btn-xs"   >
                                            <i class="fa fa-hand-pointer-o">编辑</i>
                                        </button>
                                    </c:if>
                                    <c:if test="${user.state!=1}">
                                        已解除绑定
                                    </c:if>
                                    <c:if test="${user.userGroupId=='5aa0c7d2ef722c21498f4485'}">
                                        商家
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                    <%--<ul class="pager" >--%>
                        <%--<li  page="1"><a href="javascript:void(0)" >首页</a></li>--%>
                        <%--<li  page="${pageSplit.prePage }"><a href="java script:void(0)"  >上一页</a></li>--%>
                        <%--<c:forEach var="current_page" begin="${pageSplit.fenyeFirstPage }" end="${pageSplit.fenyeLastPage }" >--%>
                            <%--<li  page="${current_page}"><a href="javascript:void(0)"     >${current_page}</a></li>--%>
                        <%--</c:forEach>--%>
                        <%--<li  page="${pageSplit.nextPage }"><a href="javascript:void(0)"    >下一页</a></li>--%>
                    <%--</ul>--%>
                </div>
            </div>
        </div>
    </div>
</div>



<script type="text/javascript">

    /**
     * 添加收银员
     */
    function addLowUserShow(){
        jQuery.ajax({
            type : "post",
            url : "${basePath }merchant/business_page/cashier/cashier_add.jsp",
            data : "",
            success : function(msg) {
                modal_current_show(msg);
            }
        });
    }

    /**
     * 修改收银员
     * @param lowUserId
     */
    function changeCashier(lowUserId,obj){
        layer.open({
            type: 1,
            title: '编辑收银员信息',
            maxmin: false,
            shadeClose: true, //点击遮罩关闭层
            area : ['425px' , '400px'],
            content: '\<\div style="padding:20px;"> <br>  ' +
            '电话:' +
            '                     <input type="text" id="cashierPhone" class="form-control" maxlength="11" value='+obj.parentNode.parentNode.children[0].innerText+'  \n' +
            '                                   onkeypress = \'return /^\\d$/.test(String.fromCharCode(event.keyCode))\'\n' +
            '                                   oninput= \'this.value = this.value.replace(/\\D+/g, "")\'\n' +
            '                                   onpropertychange=\'if(!/\\D+/.test(this.value)){return;};this.value=this.value.replace(/\\D+/g, "")\'\n' +
            '                                   onblur = \'this.value = this.value.replace(/\\D+/g, "")\'>' +
            '<br>新密码: <input type="password" id="newpwd" maxlength="8" class="form-control" >' +
            '<br>确认密码: <input type="password" id="querenpwd" maxlength="8" class="form-control" >' +


            '<\/div>',
            btn: ['修改','解除绑定','关闭'],
            btn1:function(index, layero){

                var cashierPhone = $("#cashierPhone").val();
                var newpwd = $("#newpwd").val();
                var querenpwd = $("#querenpwd").val();

                if (cashierPhone.length<11){
                    alert("电话不能小于11位!");
                    return;
                }
                if (newpwd!=querenpwd){
                    alert("两次输入的密码不一致");
                    return;
                }

                $.post("${basePath}/qier/cashier/cashier_update.do",{"cashierId":lowUserId,"cashierPhone":cashierPhone,"newpwd":newpwd},function (msg) {
                    msg = JSON.parse(msg)
                    layer.msg(msg.message)

                    var url = '${basePath}/merchant/business_page/cashier/cashier.jsp';
                    linkToPage(url);
                });
            },
            btn2:function(index, layero){
                if(confirm("确定与此收银员解除绑定?")){
                    $.post("${basePath}/qier/cashier/cashier_relieve.do",{"cashierId":lowUserId},function (msg) {
                        msg = JSON.parse(msg)
                        layer.msg(msg.message);

                        layer.load(0, {shade: false,time:1000});
                        var url = '${basePath}/merchant/business_page/cashier/cashier.jsp';
                        linkToPage(url);
                    });
                }
            }
        });
    }


    /**
     * 刷新
     */
    function refresh(){
        layer.load(0, {shade: false,time:1500});
        var url = '${basePath}/merchant/business_page/cashier/cashier.jsp';
        linkToPage(url);
    }
</script>