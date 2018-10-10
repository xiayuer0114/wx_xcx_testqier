<%@ page import="com.lymava.base.model.User" %>
<%@ page import="com.lymava.base.util.FinalVariable" %>
<%@ page import="com.lymava.commons.exception.CheckException" %><%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018\3\31 0031
  Time: 15:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<span id="dataOrder" value=${datas}></span>
<span id="showTime" value="${showTime}"></span>


<button class="btn btn-info" onclick="excelFileDownload();">下载收银信息</button>
<script type="text/javascript">
        function excelFileDownload() {
            // 获取商家电话  用作为下载文件的文件名 电话.xlxs
            $.post("${basePath}/qier/orderReportContent/excelFileDownload.do",{},function (data) {
                data = JSON.parse(data);

                // 状态正常 进行下载  300时说明后台出现了异常
                if(data.statusCode == 200){
                    var userPhone = data.data.userPhone;
                    window.location.href=basePath+"excelFileDownload/"+userPhone+".xlsx";
                }
            });
        }
</script>


<div style="width: 100%;height: 400px;" id="container"  >
    <%-- 核心类容显示区域(报表数据) --%>
</div>



<script type="text/javascript">
    $(function () {
        var data = JSON.parse($("#dataOrder").attr("value"));
        var showTime = $("#showTime").attr("value");


        var dataPrice = new Array();
        var dataCount= new Array();
        var dataPriceAvg = new Array();

        var DataTimeX = showTime.split(',');

        for (var i=0;i<data.length;i++){
            dataPrice.push(data[i].price_fen_all/100);
            dataCount.push(data[i].order_sum_count);
            dataPriceAvg.push(data[i].price_fen_avg/100);
        }


        $('#container').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: '收银信息'
            },
            xAxis: {
                categories:
                    DataTimeX
                ,
                crosshair: true
            },
            yAxis: {
                min: 0,
                title: {
                    text: '收银总额(元)'
                }
            },
            tooltip: {
                headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                '<td style="padding:0"><b>{point.y}</b></td></tr>',
//                '<td style="padding:0"><b>{point.y:.2f} 元</b></td></tr>',
                footerFormat: '</table>',
                shared: true,
                useHTML: true
            },
            plotOptions: {
                column: {
                    borderWidth: 0
                }
            },
            series: [{
                name: '总金额收益(元)',
                data: dataPrice
            }, {
                name: '平均消费(元)',
                data: dataPriceAvg
            }, {
                name: '订单数量(笔)',
                data: dataCount
            }]
        });
    });

</script>
