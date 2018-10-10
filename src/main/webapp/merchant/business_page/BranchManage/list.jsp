<%@ page import="com.lymava.commons.state.State" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">

    $(function(){

        // 请求订单数据
        $.post("${basePath}/merchant/business_page/BranchManage/store_list.jsp",null,function(msg){
            $("#list_data_before").after(msg);
        });
    });

</script>


<!-- BEGIN CONTENT BODY -->
<div class="page-content">
    <!-- BEGIN PAGE BASE CONTENT -->
    <div class="row">
        <div class="col-md-12">
            <div class="portlet light bordered" id="form_wizard_1">
                <div class="portlet-title">
                    <div class="caption">
                        <i class="fa fa-table font-green"></i>
                        <span class="caption-subject font-green bold uppercase"> 分店管理
                         </span>
                    </div>
                </div>
 				
                <button id="id_query_list" link="" href="javascript:void(0)"  class="btn btn-default nav-link">
                    <span class="title">
                        查询订单
                    </span>
                </button>
				 <form id="search_form"  name="search_form">
				 </form>
                <div class="portlet-body">
                    <hr id="list_data_before" style="margin-top: 10px;margin-bottom: 10px;" >
                </div>
            </div>
        </div>
    </div>
</div>