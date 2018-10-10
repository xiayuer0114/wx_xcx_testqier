<%@page import="com.lymava.nosql.mongodb.util.MongoCommand"%>
<%@page import="com.lymava.qier.model.TradeRecord72"%>
<%@page import="com.lymava.commons.state.State"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.commons.exception.CheckException"%>
<%@page import="com.lymava.base.util.FinalVariable"%>
<%@page import="com.lymava.base.model.User"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.List"%>
<%@ page import="com.lymava.qier.model.MerchantRedEnvelope" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="static java.lang.System.currentTimeMillis" %>
<%@ page import="com.lymava.qier.util.SunmingUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%
    User user = (User) request.getAttribute(FinalVariable.SESSION_FRONT_FULL_USER);
    CheckException.checkIsTure(user != null, "请先登录！");
    
    
    String page_red = request.getParameter("page");
    String pageSize_red = request.getParameter("pageSize");
    
    PageSplit pageSplit = new PageSplit(page_red,pageSize_red);
    //分页 每页面显示8条数据
    pageSplit.setPageSize(8);
    
    //定向红包
    MerchantRedEnvelope merchantRedEnvelope_find = new MerchantRedEnvelope();
    merchantRedEnvelope_find.setUserId_merchant(user.getId());
   //已发放的红包 
    merchantRedEnvelope_find.setState(State.STATE_OK);  
    //查询所有数据分页
    List<MerchantRedEnvelope> merchantRedEnvelope_list = ContextUtil.getSerializContext().findAll(merchantRedEnvelope_find,pageSplit);
   
     //查询所有数据 统计 
     MerchantRedEnvelope merchantRedEnvelope_findAll = new MerchantRedEnvelope();
     merchantRedEnvelope_findAll.setUserId_merchant(user.getId());
     //merchantRedEnvelope_findAll.addCommand(MongoCommand.budengyu, "red_envolope_name", "关注立减");
     
     List<MerchantRedEnvelope> merchantRedEnvelope_listAll = ContextUtil.getSerializContext().findAll(merchantRedEnvelope_findAll);
     int  countAll=0;//统计 红包的总数
     long sumAll=0;//统计 红包的总额
     
     int  count=0;//统计已发放的红包 个数
     long sumGrant=0;//统计已发放红包 总额
     
     int  countUse=0;//统计 已使用的红包个数
     long sumUse=0;//统计已使用红包 总额
     
     int  countOverdue=0;//统计 已过期的红包个数
     long sumOverdue=0;//统计已过期红包 总额
     
     for(int i=0;i<merchantRedEnvelope_listAll.size();i++){
    	 
    	 MerchantRedEnvelope merchantRedEnvelope_tmp = merchantRedEnvelope_listAll.get(i);
    	 
    	 Long amountFen = merchantRedEnvelope_tmp.getAmountFen();
    	 
    	 sumAll+=amountFen;
    	 countAll++;
    	 //统计已发放的红包
    	 if(State.STATE_OK.equals(merchantRedEnvelope_tmp.getState())){
    		 sumGrant+=amountFen;
        	 count++;
    	 }
    	
    	//统计已使用的红包 
    	 if(State.STATE_FALSE.equals(merchantRedEnvelope_tmp.getState())){
    		 sumUse+=amountFen;
    		 countUse++;
    	 }
    	 //统计 已过期 的红包 
    	 if(State.STATE_CLOSED.equals(merchantRedEnvelope_tmp.getState())){
    		 sumOverdue+=amountFen;
    		 countOverdue++;
    	 }
     }
     
    request.setAttribute("countAll", countAll); //统计 红包的总数
    request.setAttribute("sumAll", sumAll); //统计 红包的总额
    
    request.setAttribute("sumGrant", sumGrant); //统计已发放红包 总额
    request.setAttribute("count", count); //统计已发放的红包 个数
    
    request.setAttribute("countUse", countUse); //统计 已使用的红包个数
    request.setAttribute("sumUse", sumUse); //统计已使用红包 总额
    
    request.setAttribute("countOverdue", countOverdue); ///统计 已过期的红包个数
    request.setAttribute("sumOverdue", sumOverdue); //统计已过期红包 总额
    
    request.setAttribute("object_list", merchantRedEnvelope_list);//查询已发放的红包集合
    request.setAttribute("pageSplit", pageSplit);
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
                        <span class="caption-subject font-green bold uppercase"> 定向红包列表</span>
                    </div>
                </div>
                <div class="portlet-body">
                   <form id="search_form"  name="search_form" action="${requestURL }">
                        <table >
                            <tr>
                                <td>  <strong>精确查询 :</strong>  </td>
                                <td>  &nbsp;&nbsp;开始:  &nbsp;&nbsp;</td>
                                <td width="155px">
                                    <input style="width: 150px;" readonly="readonly" type="text" id="selStartDate" name="selStartDate" class="form-control date_m" datefmt="yyyy-MM-dd HH" >
                                </td> 
                                <td>&nbsp;--到--&nbsp;&nbsp;</td>
                                <td>
                                    <input style="width: 150px;" readonly="readonly" type="text" id="selStopDate" name="selStopDate"  class="form-control date_m" datefmt="yyyy-MM-dd HH">
                                </td>
                            </tr>
                            <tr style="height: 15px"></tr>
                            <tr>
                                <td></td>
                                <td></td>
                                <td style="width: 25px">
                                    <input type="button"  onclick="selBaobianForWhereRedpackage();" value="查询" class="btn btn-default">&nbsp;
                                </td>
                                <td colspan="4">
                                    红包状态设置:
                                    <select name="payState" id="payState">
                                        <option value="">全部</option>
                                        <option value="<%= State.STATE_WAITE_CHANGE%>">未领取</option>
                                        <option value="<%= State.STATE_OK%>">已领取</option>
                                        <option value="<%= State.STATE_FALSE%>">已使用</option>
                                        <option value="<%= State.STATE_CLOSED%>">已过期</option>
                                        <option value="<%=State.STATE_WAITE_WAITSENDGOODS%>">未激活</option>
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
                            <td><strong>红包时间段查询统计 :&nbsp;&nbsp;</strong></td>
                              <td colspan="8" style="width: 550px" ><span id="showStartTime"></span> ---至--- <span id="showEndTime"></span></td></tr>
                                
                        <tr>
                            <td></td>
                            <td style="width: 160px"><font color="red">红包发放情况 </td>
                            <td style="width: auto"> : <span id="red_package_priceALL" ></span></td>
                            <td width="">元 /</td>
                            <td style="width: auto">  <span id="red_package_size"></span></td>
                            <td width="">个</td>
                            <td width="">(红包总数)</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td style="width: 160px"><font color="blue">红包的用户领取情况</font></td>
                            <td> : <span id="red_package_priceFaALL"></span></td>
                            <td width="">元 /</td>
                            <td><span id="red_packageFA_size"></span></td>
                            <td width="">个</td>
                            <td>(已领取红包)</td>
                        </tr>

                        <tr>
                            <td></td>
                            <td style="width: 160px"><font color="green">领取红包的用户使用情况</font></td>
                            <td> : <span id="red_packageUse_priceALL"></span></td>
                            <td>元 /</td>
                            <td><span id="red_packageUse_size"></span></td>
                            <td>个</td>
                            <td>(已使用红包)</td>
                            
                            <td> ---:   <span id="red_packageOverdue_priceAll"></span></td>
                            <td width="">元 /</td>
                            <td><span id="red_packageOverdue_size"></span></td>
                            <td width="">个</td>
                            <td>(已过期红包)</td>
                        </tr>
                        
                    </table>
                    
                     <hr style="margin-top: 10px;margin-bottom: 10px;" >
                    <table border="0">
                        <tr>
                            <td><strong>所有历史红包总统计 :&nbsp;&nbsp;</strong></td>
                              <td colspan="8" style="width: 550px" ></td></tr>
                                
                        <tr>
                            <td></td>
                            <td style="width: 160px"><font color="red">红包发放情况 </td>
                            <td style="width: auto"> : <span  ></span>${sumAll/100 }</td>
                            <td width="">元 /</td>
                            <td style="width: auto">  <span ></span>${countAll }</td>
                            <td width="">个</td>
                            <td width="">(红包总数)</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td style="width: 160px"><font color="blue">红包的用户领取情况</font></td>
                            <td> : <span ></span>${sumGrant/100}</td>
                            <td width="">元 /</td>
                            <td><span ></span>${count}</td>
                            <td width="">个</td>
                            <td>(已领取红包)</td>
                        </tr>

                        <tr>
                            <td></td>
                            <td style="width: 160px"><font color="green">领取红包的用户使用情况</font></td>
                            <td> : <span ></span>${sumUse/100 }</td>
                            <td>元 /</td>
                            <td><span ></span>${countUse }</td>
                            <td>个</td>
                            <td>(已使用红包)</td>
                            
                            <td> ---:   <span ></span>${countOverdue/100 }</td>
                            <td width="">元 /</td>
                            <td><span ></span>${sumOverdue }</td>
                            <td width="">个</td>
                            <td>(已过期红包)</td>
                        </tr>
                        
                    </table>
                    
                    
                    <hr id="list_data_before" style="margin-top: 10px;margin-bottom: 10px;" >
                    <table class="table table-striped table-hover table-bordered" data-search="true">
                        <thead>
                        <tr>
                           <th>红包名称</th>
                           <th>商家</th>
				           <th>商家类型</th>
				           <th>会员</th>
				           <th>红包金额</th>
				           <th>状态</th>
				           <th>有效期至</th>
				           <th>发放时间</th>
                        </tr>
                        </thead>
                        <tbody  >
                        <c:forEach var="object" varStatus="i" items="${object_list }">
                            <tr target="id" rel="${object.id }" id="${object.id }">
                            <td><c:out value="${object.red_envolope_name}" escapeXml="true"/></td>
                            <td><c:out value="${object.tradeRecord72.user_merchant.nickname}" escapeXml="true"/></td>
                            
					        <td><c:out value="${object.merchant_type }" escapeXml="true"/></td>
				        	<td><c:out value="${object.user_huiyuan.showName}" escapeXml="true"/></td>
					        <td><c:out value="${object.amountFen/100}" escapeXml="true"/></td>
					        <td><c:out value="${object.showState }" escapeXml="true"/></td>
					        <td><c:out value="${object.showExpiry_time }" escapeXml="true"/></td>
					        <td><c:out value="${object.showTime }" escapeXml="true"/></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
					<ul class="pager" >
					    <li  page="1"><a href="javascript:void(0)" > 首页</a></li>
					    <li  page="${pageSplit.prePage }"><a href="javascript:void(0)"  >上一页</a></li>
					    <c:forEach var="current_page" begin="${pageSplit.fenyeFirstPage }" end="${pageSplit.fenyeLastPage }" >
					        <li   page="${current_page}"><a <c:if test="${current_page == pageSplit.page }">style="background-color: #eee;"</c:if>  href="javascript:void(0)"     >${current_page}</a></li>
					    </c:forEach>
					    <li  page="${pageSplit.nextPage }"><a href="javascript:void(0)"   >下一页</a></li>
					</ul>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
//按时间段精确查询红包 情况
 function selBaobianForWhereRedpackage() {

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
    
    var request_data = {
    		            "selStartDate":selStartDate,
		        		"selStopDate":selStopDate,
	        		   };
    // 请求时间段内的红包 的情况 
    $.post("${basePath}qier/orderReportContent/getCollectDataByTimeRedPackage.do",request_data,function (data) {
        data  = JSON.parse(data);
        if (data.statusCode == 300){
            alert(data.message);
        }else if(data.statusCode == 200){
            $("#showStartTime").text(data.data.start_date);
            $("#showEndTime").text(data.data.end_date);
            //红包的发放情况 
            $("#red_package_priceALL").text((data.data.red_package_priceALL));
            $("#red_package_size").text((data.data.red_package_size));
            //已发放的红包 
            $("#red_package_priceFaALL").text((data.data.red_package_priceFaALL));
            $("#red_packageFA_size").text((data.data.red_packageFA_size));
            //已使用的红包 
            $("#red_packageUse_priceALL").text((data.data.red_packageUse_priceALL));
            $("#red_packageUse_size").text((data.data.red_packageUse_size));
            //过期的红包 
            $("#red_packageOverdue_priceAll").text((data.data.red_packageOverdue_priceAll));
            $("#red_packageOverdue_size").text((data.data.red_packageOverdue_size));
        };
    });
    
};
</script>





