<%@page import="com.lymava.commons.util.HttpUtil"%>
<%@page import="com.google.gson.JsonArray"%>
<%@ page import="com.lymava.commons.state.State" %>
<%@ page import="com.lymava.qier.model.Merchant72" %>
<%@ page import="com.lymava.base.model.User" %>
<%@ page import="com.lymava.userfront.util.FrontUtil" %>
<%@ page import="com.lymava.commons.exception.CheckException" %>
<%@ page import="com.lymava.commons.state.StatusCode" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    //获取选择的分店ID，将其转化为前端可用Json格式
    String[] subMerchantIdsArr = request.getParameterValues("subMerchantId");
	request.setAttribute("subMerchantId_array", subMerchantIdsArr); 
%>
<script type="text/javascript" src="https://img.hcharts.cn/highcharts/highcharts.js"></script>
<script type="text/javascript" src="https://img.hcharts.cn/highcharts-plugins/highcharts-zh_CN.js"></script>
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
                            分店交易记录
                         </span>
                    </div>
                </div>
                <div class="portlet-body">
                    <table>
                        <tr>
                            <td>
                                <strong>快速展示 :</strong>
                            </td>
                            <td>
                                &nbsp;&nbsp;
                                <button onclick="selDataQuick('today');return false;" class="btn btn-default">今日报表</button>
                                &nbsp;&nbsp;&nbsp;&nbsp;
                      		</td>
                            <td>
                    			<button  onclick="selDataQuick('week');return false;" class="btn btn-default">七日报表</button>
                    			&nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                            <td>
                                <button  onclick="selDataQuick('month');return false;" class="btn btn-default">十五日报表</button>
                                &nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
                        </tr>
                    </table>
                    <hr style="margin-top: 10px;margin-bottom: 10px;" />
                    <form id="search_form"  name="search_form" action="${basePath }qier/branchManage/loadMerchartOrder.do">
                    	<c:forEach var="subMerchantId_tmp" items="${subMerchantId_array }">
	                    	<input type="hidden"  name="subMerchantId" value="${subMerchantId_tmp }" >
                    	</c:forEach>
                        <table >
                            <tr>
                                <td>  <strong>精确查询 :</strong>  </td>
                                <td>  &nbsp;&nbsp;开始:  &nbsp;&nbsp;</td>
                                <td width="155px">
                                    <input style="width: 150px;" readonly="readonly" type="text" id="selStartDate" name="selStartDate" class="form-control date_m" datefmt="yyyy-MM-dd HH:mm:ss" >
                                </td> 
                                <td>&nbsp;--到--&nbsp;&nbsp;</td>
                                <td>
                                    <input style="width: 150px;" readonly="readonly" type="text" id="selStopDate" name="selStopDate"  class="form-control date_m" datefmt="yyyy-MM-dd HH:mm:ss">
                                </td>
                            </tr>
                            <tr style="height: 15px"></tr>
                            <tr>
                                <td></td>
                                <td></td>
                                <td style="width: 25px">
                                    <input type="button"  onclick="selBaobianForWhere();" value="查询" class="btn btn-default">&nbsp;
                                    <input type="button"  onclick="downloadExcelByTime();" value="下载" class="btn btn-default">&nbsp;
                                </td>
                                <td colspan="4">
                                    订单状态设置:
                                    <select name="payState" id="payState">
                                        <option value="">全部</option>
                                        <option value="<%= State.STATE_PAY_SUCCESS%>">付款成功</option>
                                        <option value="<%= State.STATE_FALSE%>">付款失败</option>
                                        <option value="<%= State.STATE_WAITE_PAY%>">等待付款</option>
                                        <option value="<%= State.STATE_REFUND_OK%>">已退款</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td colspan="6">
                                    <font color="red">&nbsp;&nbsp;<span id="errorMsgInData"></span></font>
                                </td>
                            </tr>
                        </table>
                    </form>
                    <hr style="margin-top: 10px;margin-bottom: 10px;" >
                    <table border="0">
                        <tr>
                            <td><strong>收益数据 :&nbsp;&nbsp;</strong></td>
                            <td colspan="8" style="width: 550px" ><span id="showStartTime"></span> --至-- <span id="showEndTime"></span></td></tr>
                        <tr>
                            <td></td>
                            <td style="width: 80px"> 总收益 </td>
                            <td style="width: auto"> : <span id="time_price_all"></span></td>
                            <td width="">元 /</td>
                            <td style="width: auto">  <span id="time_order_size"></span></td>
                            <td width="">笔</td>
                            <td width="">(付款成功)</td>
                        </tr>

                        <tr>
                            <td></td>
                            <td style="width: 80px"> 实际收益 </td>
                            <td> : <span id="read_time_price_all">0</span></td>
                            <td width="">元</td>
                            <%--<td><span id="read_time_aliPay_size"></span></td>--%>
                            <%--<td width="">笔</td>--%>
                            <td></td>
                            <td></td>
                            <td>(不包含退款)</td>
                        </tr>

                        <tr>
                            <td></td>
                            <td><font color="blue"> 支付宝支付</font></td>
                            <td> : <span id="time_aliPay"></span></td>
                            <td width="">元 /</td>
                            <td><span id="time_aliPay_size"></span></td>
                            <td width="">笔</td>
                            <td>(付款成功)</td>
                        </tr>

                        <tr>
                            <td></td>
                            <td><font color="green"> 微信支付</font></td>
                            <td> : <span id="time_wechatPay"></span></td>
                            <td>元 /</td>
                            <td><span id="time_wechatPay_size"></span></td>
                            <td>笔</td>
                            <td>(付款成功)</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td><font color="red">  悠择红包</font></td>
                            <td> : <span id="time_redPay"></span></td>
                            <td>元 /</td>
                            <td> <span id="time_redPay_size"></span></td>
                            <td>笔</td>
                            <td>(付款成功)</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td><font color="red">退单</font></td>
                            <td> : <span id="time_refund"></span></td>
                            <td>元 /</td>
                            <td> <span id="time_refund_size"></span></td>
                            <td>&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                    </table>
                    <hr id="list_data_before" style="margin-top: 10px;margin-bottom: 10px;" >
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    function downloadExcelByTime() {
        var selStartDate = $("#selStartDate").val();
        var selStopDate = $("#selStopDate").val();

        // 数据验证
        if(selStartDate==null || selStartDate==""){
            $("#errorMsgInData").text("请选择输入完整的 开始 日期.如2018-10-10");
            return;
        }
        if(selStopDate==null || selStopDate==""){
            $("#errorMsgInData").text("请选择输入完整的 结束 日期.如2018-12-12");
            return;
        }

        $("#errorMsgInData").text("");
 
        var request_data = $('#search_form').serializeArray();
        request_data.push({"name":"precise", "value":"200"});
        console.log(request_data);

        $.post("${basePath}/qier/branchManage/excelFileDownload.do",request_data,function (data) {
            data = JSON.parse(data);

            if(data.statusCode == 200){
                var userPhone = data.data.userPhone;
                window.location.href=basePath+"excelFileDownload/"+userPhone+".xlsx";
            }else {
                $("#errorMsgInData").text(data.message);
            }

        });
    }



    function selBaobianForWhere() {

        var selStartDate = $("#selStartDate").val();
        var selStopDate = $("#selStopDate").val();

        var payState = $("#payState").val();

        // 数据验证
        if(selStartDate==null || selStartDate==""){
            $("#errorMsgInData").text("请选择输入完整并且正确的  开始  日期.如: 2018年10月10日10点");
            return;
        }
        if(selStopDate==null || selStopDate==""){
            $("#errorMsgInData").text("请选择输入完整并且正确的  结束  日期.如: 2018年12月12日12点");
            return;
        }
        $("#errorMsgInData").text("");
        
        getCollectDataByTime();
      
        loadMerchartOrder(true);
    };

    // 展示报表数据的方法
    function selDataQuick(scope){
        var action= "selToday";
        var showDataTitle = "今日";
        if("today" == scope){action = "selToday"; showDataTitle = "今日";}
        if("week" == scope){action = "selZhou"; showDataTitle = "七日";}
        if("month" == scope){action = "selYue"; showDataTitle = "十五日";}
        
        var request_data = $('#search_form').serializeArray();
        request_data.push({name:"scope", value:scope});

        $.post("${basePath}/qier/branchManage/selDataQuick.do",request_data,function (data) {
            layer.open({
                type: 1,
                title: showDataTitle+'订单信息',
                area : ['85%' , '85%'],
                content: data
            });
        });
    }
    function loadMerchartOrder(click_query){
    	  var request_data = $('#search_form').serializeArray();
    	  if (click_query != null) {
              request_data.push({name:"click_query", value:click_query});
          }

          // 请求订单数据
          $.post("${basePath}qier/branchManage/loadMerchartOrder.do",request_data,function(msg){
          	var res = json2obj(msg);
          	
          	if(res == null){
          		  $("#list_data_before").next().remove();
                    $("#list_data_before").after(msg);
          	}else if(res.statusCode == 300){
          		  alertMsg_warn(res.message);
          	}
            
          });
    }
    function getCollectDataByTime(){
    	var request_data = $('#search_form').serializeArray();

        // 请求收益数据
        $.post("${basePath}/qier/branchManage/getCollectDataByTime.do",request_data,function (data) {
            data  = JSON.parse(data);

            if (data.statusCode == 300){
                alert(data.message);
            }else if(data.statusCode == 200){
                $("#showStartTime").text(data.data.start_date);
                $("#showEndTime").text(data.data.end_date);

                $("#time_price_all").text((data.data.price_fen_all/100));
                $("#time_order_size").text((data.data.order_size));

                $("#read_time_price_all").text((data.data.price_fen_all-data.data.had_refund_amout_fen)/100);

                $("#time_redPay").text((data.data.red_pay_fen/100));
                $("#time_redPay_size").text((data.data.red_pay_size));

                $("#time_aliPay").text((data.data.price_fen_alipay/100));
                $("#time_aliPay_size").text((data.data.price_fen_alipay_size));

                $("#time_wechatPay").text((data.data.price_fen_wechat/100));
                $("#time_wechatPay_size").text((data.data.price_fen_wechat_size));

                $("#time_redPay_yorz").text((data.data.price_fen_yorz/100));
                $("#time_redPay_yorz_size").text((data.data.price_fen_yorz_size));
                
                $("#time_refund").html(data.data.had_refund_amout_fen/100);
            }; 
        });
    }

    function refundById(tradeRecord_id){
    	
    	ajax_open(basePath+"merchant/business_page/manager_center/refund_payment_record.jsp?tradeRecord_id="+tradeRecord_id,function(){
    		
    		 var refund_memo = $("#refund_memo").val();
    		 var requestFlow = $("#refund_requestFlow").val();
    		 var refundAmount = $("#refundAmount").val();
    		 var pay_password = $("#pay_password").val();
    		 
    		 if(!checkNull(pay_password)){
    			 pay_password = hex_md5(pay_password+""); 
    		 }
    		 
             var request_data = {
			                		"tradeRecord_id":tradeRecord_id, 
			                		"refundAmount":refundAmount,
			                		"requestFlow":requestFlow,
			                		"pay_password":pay_password, 
			                		"refund_memo":refund_memo
			                		};
         
             $.post("${basePath}qierFront/refundById.do",request_data,function (msg) {
                 var data = json2obj(msg);

                 if(data.statusCode != "200"){
                     layer.msg(data.message);
                     return;
                 }   
                 
                 layer.closeAll();
                 layer.msg(data.message);
                 
                 if(data.state_refund == "204"){
                	 $('.'+tradeRecord_id+"state").html("已退款");
                 }
             });
    	});	
    }

    $(function() {
        getCollectDataByTime();
        loadMerchartOrder();
    });
</script>


