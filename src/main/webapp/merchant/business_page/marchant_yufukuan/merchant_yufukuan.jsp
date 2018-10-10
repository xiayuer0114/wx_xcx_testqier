
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- BEGIN CONTENT BODY -->
<div class="page-content">
    <!-- BEGIN PAGE BASE CONTENT -->
    <div class="row">
        <div class="col-md-12">
            <div class="portlet light bordered" id="form_wizard_1">
                <div class="portlet-title">
                    <div class="caption">
                        <i class="fa fa-table font-green"></i>
                        <span class="caption-subject font-green bold uppercase">
                            预付款信息
                         </span>
                    </div>
                </div>
                <div class="portlet-body">

                    <table class="table table-striped table-hover table-bordered" data-search="true" id="merchant_yufukuan_data">
                        <thead>
                        <tr>
                            <th align="center">交易号</th>
                            <th >预付金额</th>
                            <th >交易金额</th>
                            <th >时间</th>
                        </tr>
                        </thead>

                        </tbody>
                    </table>
                    <button class="btn btn-info" onclick="get_more_merchant();">更多数据</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">

    var requsetUrl = basePath+"merchant/business_page/marchant_yufukuan/merchant_yufukuan_data.jsp";

    $(function () {

        $.post(requsetUrl,{"time" : new Date()}, function (msg) {
            var msg = $.trim(msg);
            var data = JSON.parse(msg);
            assemble_returnData_merchant_yufukuan(data);
        });
    });

    function get_more_merchant() {

        $.post(requsetUrl,{"time" : new Date(), "next":"next"}, function (msg) {
            var msg = $.trim(msg);
            var data = JSON.parse(msg);
            assemble_returnData_merchant_yufukuan(data);
        });
    }




    function assemble_returnData_merchant_yufukuan(data) {
        for(var i = 0; i<data.length; i++){

            var tr = "<tr>";
            tr +="<td>"+ data[i].orderId+"</td><td>"+data[i].yufukuan_price+"<td>"+ data[i].price_all+"</td><td>"+ data[i].shoeTime+"</td>";
            tr += "</tr>";

            $("#merchant_yufukuan_data").append($(tr));
        }

    }


    
</script>


