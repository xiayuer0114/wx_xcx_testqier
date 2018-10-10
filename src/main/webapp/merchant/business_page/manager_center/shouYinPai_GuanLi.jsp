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
<%@ page import="com.lymava.qier.model.Product72" %>
<%@ page import="com.lymava.base.model.Pub" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%
    User user = (User) request.getAttribute(FinalVariable.SESSION_FRONT_FULL_USER);
    CheckException.checkIsTure(user != null, "请先登录！");



    Product72 product72_find = new Product72();
    product72_find.setUserId_merchant(user.getId());
    product72_find.setState(Pub.state_nomal);
    product72_find.setShenghe(Pub.shenghe_tongguo);

    Iterator<Product72> product72List = ContextUtil.getSerializContext().findIterable(product72_find);

    request.setAttribute("product72List", product72List);
%>
<!-- BEGIN CONTENT BODY -->

<head>
    <meta charset="utf-8">
    <title>layui</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${basePath}layui-v2.2.5/layui/css/layui.css"  media="all">
    <!-- 注意：如果你直接复制所有代码到本地，上述css路径需要改成你本地的 -->
</head>

<div class="page-content" id="containerCashier">

    <!-- BEGIN PAGE BASE CONTENT -->
    <div class="row">
        <div class="col-md-12">
            <div class="portlet light bordered" id="form_wizard_1">
                <div class="portlet-title">
                    <div class="caption">
                        <i class="fa fa-list font-green"></i>
                        <span class="caption-subject font-green bold uppercase"> 收银牌列表</span>
                    </div>
                </div>
                <form  name="search_form"  class="form-inline" style="margin-bottom:10px;" role="form" action="${requestURL }">
                    <a href="javascript:void(0)" onclick="refresh()" type="button" class="btn btn-primary"  >刷新</a>
                    <a href="javascript:void(0)" onclick="product72_basicSetting()" type="button" class="btn btn-info"  >基础设置</a>
                </form>
                <div style="padding: 20px; background-color: #F2F2F2;">
                    <div class="layui-row layui-col-space15">
                        <c:forEach var="product72List" varStatus="i" items="${product72List }">
                            <div class="layui-col-md3" style="width: 18rem;">
                                <div class="layui-card">
                                    <div class="layui-card-header">
                                        <c:out value="${product72List.name }" escapeXml="true"/>
                                        <div style="float: right">
                                            <button onclick="changYuSheZhi('${product72List.id}','${product72List.name}',this);" class="btn btn-primary" >
                                                设置
                                            </button>
                                        </div>
                                    </div>
                                    <div class="layui-card-body">
                                        <input type="hidden" value="${product72List.id }">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td>开启预设: &nbsp;&nbsp;&nbsp;</td>
                                                <td style="color: red"><c:out value="${product72List.yushe_state==200?'开启':'关闭' }" escapeXml="true"/></td>
                                            </tr>
                                            <tr>
                                                <td>设置时间: &nbsp;&nbsp;&nbsp;</td>
                                                <td><c:out value="${product72List.show_update_amount_time }" escapeXml="true"/></td>
                                            </tr>
                                            <tr>
                                                <td>预置金额: &nbsp;&nbsp;&nbsp; </td>
                                                <td><c:out value="${product72List.preset_amount_fen/100}" escapeXml="true"/></td>
                                            </tr>
                                            <tr>
                                                <td>餐位费: &nbsp;&nbsp;&nbsp; </td>
                                                <td><c:out value="${product72List.canWeiFei_fen/100}" escapeXml="true"/></td>
                                            </tr>
                                            <tr>
                                                <td>用餐人数: &nbsp;&nbsp;&nbsp; </td>
                                                <td><c:out value="${product72List.renshu}" escapeXml="true"/></td>
                                            </tr>
                                            <tr>
                                                <td>小计: &nbsp;&nbsp;&nbsp; </td>
                                                <td><c:out value="${product72List.xiaoJi}" escapeXml="true"/></td>
                                            </tr>
                                            <%--<tr>--%>
                                                <%--<td>--%>
                                                    <%--<button onclick="changYuSheZhi('${product72List.id}','${product72List.name}',this);" class="btn btn-primary" >--%>
                                                        <%--设置--%>
                                                    <%--</button>--%>
                                                <%--</td>--%>
                                                <%--<td></td>--%>
                                            <%--</tr>--%>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>

                    </div>
                </div>



                </div>
            </div>
        </div>
</div>


<script type="text/javascript">


    /**
     * 预置收银牌
     * @param lowUserId
     */
    function changYuSheZhi(product72_id,product72_name, obj){   // 1参数的名字

        var request_url = basePath+"merchant/business_page/manager_center/product_price_yushe_show.jsp";

        var request_data = {
            "product72_id":product72_id
        };

        ajax_post(request_url,request_data,function(msg){
            layer.open({
                type: 1,
                title: product72_name+'',
                maxmin: false,
                shadeClose: true, //点击遮罩关闭层
                content: msg,
                btn: ['设置','清台','关闭'],
                btn1:function(index, layero){
                    var product_72_id = product72_id;
                    var price_yushe = $("#product72_price").val();
                    var canweifei = $("#canweifei").val();
                    var renshu = $("#renshu").val();
                    var yushe_state = $("#yushe_state").val();
                    var canweifei_state = $("#canweifei_state").val();
                    
                    var request_data =  $('#product_price_yushe_form').serializeArray(); 

                    var request_url = "${basePath}merchant/business_page/manager_center/shouyinpai_yushe_save.jsp";
                    

                    ajax_post(request_url,request_data,function(msg){
                        var response_data = json2obj(msg);
                        refresh();
                        if (response_data.statusCode == 200){
                            layer.close(index);
                        }
                    });

                    return false;
                },
                btn2:function(index, layero){
                    var product_72_id = product72_id;

                    var request_url = "${basePath}merchant/business_page/manager_center/shouyinpai_yushe_clear.jsp";
                    var request_data = {
                        product_72_id: product_72_id,
                    };

                    ajax_post(request_url,request_data,function(msg){
                        var response_data = json2obj(msg);
                        refresh();
                        if (response_data.statusCode == 200){
                            layer.close(index);
                        }
                    });

                    return false;
                }
            });
        });

    }



    function product72_basicSetting() {

        var request_url = basePath+"merchant/business_page/manager_center/product_price_yushe_allSetting.jsp";


        ajax_post(request_url,null,function(msg) {
            layer.open({
                type: 1,
                title: '基础设置',
                maxmin: false,
                shadeClose: true, //点击遮罩关闭层
                area: ['350px', '400px'],
                content: msg,
                btn: ['设置', '关闭'],
                btn1:function(index, layero){

                    var product72_all_open = $("#product72_all_open").val();
                    var chushi_canweifei = $("#chushi_canweifei").val();
                    var canweifei_state_all = $("#canweifei_state_all").val();

                    var request_url = "${basePath}merchant/business_page/manager_center/product_price_yushe_allSetting_save.jsp";

                    var request_data = {
                        product72_all_open: product72_all_open,
                        chushi_canweifei: chushi_canweifei,
                        canweifei_state_all: canweifei_state_all
                    };

                    ajax_post(request_url,request_data,function(msg){
                        var response_data = json2obj(msg);

                        refresh();

                        if (response_data.statusCode == 200){
                            layer.close(index);
                        }
                    });

                    return false;
                }
            });

        })
    }


    /**
     * 刷新
     */
    function refresh(){
        layer.load(0, {shade: false,time:300});
        var url = '${basePath}/merchant/business_page/manager_center/shouYinPai_GuanLi.jsp';
        linkToPage(url);
    }
</script>