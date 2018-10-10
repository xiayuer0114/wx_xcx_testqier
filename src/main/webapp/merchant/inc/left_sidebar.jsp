<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="java.util.List"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.qier.model.Product72"%>
<%@ page import="com.lymava.base.model.User" %>
<%@ page import="com.lymava.base.util.FinalVariable" %>
<%@ page import="com.lymava.commons.exception.CheckException" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
         
    String user_sign = request.getParameter("user_sign");     
    request.setAttribute("back_login", !MyUtil.isEmpty(user_sign));
%>
<script type="text/javascript">
var user_id = "${front_user.id}";
var user_key = "${front_user.key}";
var default_printer_name = "${front_user.default_printer_name}";

var state_auto_print = STATE_OK;
var state_auto_voice = STATE_FALSE;
var state_shaoma_yuzhi = STATE_FALSE;
var back_login = STATE_FALSE;

var print_lianshu = 2;

jQuery(function(){
	
	var state_auto_print_str = '${front_user.state_auto_print}';
	var state_auto_voice_str = '${front_user.state_auto_voice}';
	var state_shaoma_yuzhi_str = '${front_user.state_shaoma_yuzhi}';
	var back_login_str = '${back_login }';
	
	var print_lianshu_int = parseInt_m('${front_user.print_lianshu}'); 
	
	if(state_auto_print_str == STATE_FALSE){
		state_auto_print = STATE_FALSE;
	}
	if(state_auto_voice_str == STATE_OK){
		state_auto_voice = STATE_OK;
	}
	if(state_shaoma_yuzhi_str == STATE_OK){
		state_shaoma_yuzhi = STATE_OK;
	}
	if(isNumber(print_lianshu_int)){
		print_lianshu = print_lianshu_int;
	}
	//如果是后端的登录这些 就不打印订单
	if(back_login_str == 'true'){
		back_login = STATE_OK;
	}

	live_bind('.ajax_link_m',"click",function(){
        var link_m = jQuery(this);

        ajax_link_click_m(this,function(msg){
            jQuery('.nav-item').removeClass("active");
            link_m.parent().addClass("active");
        });
    });

	
	ajax_link_click_m(jQuery('.default_nav_item'));
	
	setTimeout(loadSomething, 3000);
	
	
});

function loadSomething(){
	try{
		do_things();
	}catch (e) {
	}
	setTimeout(loadSomething, 3000);
}

var userMessage_array = null;

var userMessage_map = {};

var function_array = {};

function do_things() {
	if(back_login != STATE_OK){
		load_need_print_tradeRecord();
	}
}

function load_need_print_tradeRecord(){
	
	var randCode = new Date().getTime()+"";
	
	var user_sign = hex_md5(user_key+randCode.toLowerCase());
	
	var request_data = {
			"user_id":user_id,
			"randCode":randCode,
			"user_sign":user_sign,
			"state":STATE_PAY_SUCCESS
	};
	
	ajax_post(
			"${basePath}qierFront/list_print_tradeRecord.do",
			request_data,
			function (message) {
				var data_return = json2obj(message).data;       
				
				if(data_return.length > 0){
					for(var i=0;i<data_return.length;i++){
						var tradeRecord_tmp = data_return[i];
						
						 printed_tradeRecord_id(tradeRecord_tmp.id);
						 
						 notice_and_show(tradeRecord_tmp);
						 
						 if(state_auto_print == STATE_OK){
							print_tradeRecord(tradeRecord_tmp); 
						 }
						 
					}
				}
			} 
		);
}
function voice_play(voice_str){
	$('.tts_autio_id').remove();
	
	voice_str = encodeURIComponent(voice_str);
	
	var audio_link = "http://tts.baidu.com/text2audio?lan=zh&ie=UTF-8&spd=6&text="+voice_str;
	 
	var audio_html = '<audio class="tts_autio_id" autoplay="autoplay">';
		audio_html	+= '<source class="tts_source_id" src="'+audio_link+'" type="audio/mpeg">';
		audio_html	+= '<embed class="tts_embed_id" height="0" width="0" src="">';
	audio_html	+= '</audio>';
	
	$('body').append(audio_html);
} 
function notice_and_show(tradeRecord_tmp){
	//收银牌名称	
	var product_name = tradeRecord_tmp.product_name;
	//订单总金额
	var price_fen_all = tradeRecord_tmp.price_fen_all;
	//支付时间
	var payTime = tradeRecord_tmp.payTime;
	//订单编号
	var requestFlow = tradeRecord_tmp.requestFlow;
	//支付方式
	var showPay_method = tradeRecord_tmp.showPay_method;
	
	var show_html = '<table class="layui-table">'+
					  	'<tr><td width="120px;">收银牌</td><td>'+product_name
					  	
					  	+'</td></tr>'+
					    '<tr><td  >收到金额</td><td>'+chu(price_fen_all,100)+' 元</td></tr>'+
					    '<tr><td  >支付时间</td><td>'+payTime+'</td></tr>'+
					    '<tr><td  >订单编号</td><td>'+requestFlow+'</td></tr>'+
					'</table>';  
					
	if(state_auto_voice == STATE_OK){
		voice_play(product_name+","+showPay_method+"收到"+chu(price_fen_all,100)+"元");
	}
					
	layer.open({
		  title: '收款成功通知'
		  ,content: show_html 
		  ,offset: 'rb'
		  ,btn: ['确认关闭']
	  	  ,yes: function(index, layero){
	  			layer.closeAll();
	  	  }
	});     
}
var shouyinpai_yushe_html = null;
function shouyinpai_yuluru_show(){
	
	if(shouyinpai_yushe_html == null){
		shouyinpai_yushe_html = $('#shouyinpai_yushe').html();
		$('#shouyinpai_yushe').html("");
	}
				  
	layer.open({
		  title: '收银牌金额预设'
		  ,content: shouyinpai_yushe_html 
		  ,offset: 'r' 
		  ,shade:0
		  ,btn: ['确认设置']
	  	  ,yes: function(index, layero){
	  		  
	  		  var product_72_id = $('#product_72_id').val();
	  		  var price_yushe = $('#price_yushe').val();
	  		  
	  		  var request_url = "${basePath}merchant/business_page/manager_center/shouyinpai_yushe_save.jsp";
	  		  var request_data = {
	  				product_72_id: product_72_id,
	  				price_yushe: price_yushe
	  		  };
	  		  ajax_post(request_url,request_data,function(msg){
	  			  
	  			  var response_data = json2obj(msg);
	  			  
	  			  layer.tips(response_data.message, '#shouyinpai_yushe_table');
	  		  });
	  		   
		    return false;
		  }
	});     
}



</script>
<%
    User user = (User) request.getAttribute(FinalVariable.SESSION_FRONT_FULL_USER);
    CheckException.checkIsTure(user != null, "请先登录！");
    
    Product72 product72_find = new Product72();
    product72_find.setUserId_merchant(user.getId());
    
    SerializContext serializContext = ContextUtil.getSerializContext();
    
    List<Product72> product72_list = serializContext.findAll(product72_find);
    request.setAttribute("product72_list", product72_list);
%> 
<div style="display: none;" id="shouyinpai_yushe">
	<table class="layui-table" id="shouyinpai_yushe_table">
	<tbody>
		<tr>
			<td width="100px;">收银牌</td>
			<td>
				<select id="product_72_id" name="product_72_id">
					<c:forEach var="product72" items="${product72_list }">
						<option value="${product72.id }">${product72.name }</option>
					</c:forEach>
				</select>
			</td>
		</tr>
		<tr style="margin-top: 5px;">
			<td>预设金额</td>
			<td>
				<input id="price_yushe" style="width: 100px;" name="price_yushe" >元
			</td>
		</tr>
	</tbody>
	</table>
</div>
<div class="page-sidebar-wrapper">
                <div class="page-sidebar navbar-collapse collapse">
                    <ul class="page-sidebar-menu   " data-keep-expanded="false" data-auto-scroll="true" data-slide-speed="200">
                        <li class="nav-item start ">
                            <a href="${basePath }merchant/index.jsp" class="nav-link">
                                <i class="icon-home"></i>
                                <span class="title">主页</span>
                            </a>
                        </li>
                        <li class="nav-item open">
                            <a href="javascript:;" class="nav-link nav-toggle">
                                <i class="icon-settings"></i>
                                <span class="title">资料管理</span>
                                <span class="selected"></span>
                                <span class="arrow open"></span>
                            </a>
                            <ul class="sub-menu" style="display: block;">  
                                <li class="nav-item ">
                                    <a link="${basePath }merchant/business_page/manager_center/merchant_info.jsp" href="javascript:void(0)"  class="nav-link ajax_link_m default_nav_item">
                                        <span class="title">
                                            <span class="fa fa-flag-checkered"></span>
                                            我的信息
                                        </span> 
                                    </a>
                                </li>
                                <li class="nav-item  ">
                                    <a link="${basePath }merchant/business_page/manager_center/changePassword.jsp" href="javascript:void(0)"  class="nav-link ajax_link_m">
                                        <span class="title">
                                            <span class="fa fa-asterisk"></span>
                                            密码修改
                                        </span>
                                    </a>
                                </li>

                                <li class="nav-item  ">
                                    <a link="${basePath }merchant/business_page/manager_center/shouYinPai_GuanLi.jsp" href="javascript:void(0)"  class="nav-link ajax_link_m">
                                        <span class="title">
                                            <span class="fa fa-asterisk"></span>
                                            收银牌管理
                                        </span>
                                    </a>
                                </li>
                            </ul>
                        </li>
                        <li class="nav-item">
                            <a href="javascript:;" class="nav-link nav-toggle">
                                <i class="icon-briefcase"></i>
                                <span class="title">订单管理</span>
                                <span class="arrow"></span>
                            </a>
                            <ul class="sub-menu">
 
                                <li class="nav-item  ">
                                    <a link="${basePath }merchant/business_page/BusinessRecord/TradeRecord72_list_content.jsp" href="javascript:void(0)"  class="nav-link ajax_link_m">
                                        <span class="title">
                                            <span class="fa fa-table"></span>
                                            订单信息
                                        </span>
                                    </a>
                                </li>
                                <li class="nav-item  ">
                                    <a link="${basePath }merchant/business_page/MerchantRedEnvelope/list.jsp" href="javascript:void(0)"  class="nav-link ajax_link_m">
                                        <span class="title">
                                            <span class="fa fa-table"></span>
                                            定向红包
                                        </span>
                                    </a>
                                </li>
                                <li class="nav-item  ">
                                    <a link="${basePath }merchant/business_page/marchant_yufukuan/merchant_yufukuan.jsp" href="javascript:void(0)"  class="nav-link ajax_link_m">
                                        <span class="title">
                                            <span class="fa fa-table"></span>
                                            预付款记录
                                        </span>
                                    </a>
                                </li>
                            </ul>
                        </li>

                        <%-- 分店管理 --%>
                        <li class="nav-item"  >
                            <a href="javascript:;" class="nav-link nav-toggle">
                                <i class="icon-briefcase"></i>
                                <span class="title">分店管理</span>
                                <span class="arrow"></span>
                            </a>
                            <ul class="sub-menu">
                                <li class="nav-item  ">
                                    <a link="${basePath }merchant/business_page/BranchManage/branch_list.jsp" href="javascript:void(0)"  class="nav-link ajax_link_m">
                                    <span class="title">
                                        <span class="fa fa-table"></span>
                                        分店订单
                                    </span>
                                    </a>
                                </li>
                                <li class="nav-item  ">
                                    <a link="${basePath }merchant/business_page/BranchManage/list.jsp" href="javascript:void(0)"  class="nav-link ajax_link_m">
                                    <span class="title">
                                        <span class="fa fa-table"></span>
                                        分店列表
                                    </span>
                                    </a>
                                </li>
                            </ul>
                        </li>


                        <%--<li class="nav-item">--%>
                            <%--<a href="javascript:;" class="nav-link nav-toggle">--%>
                                <%--<i class="icon-user"></i>--%>
                                <%--<span class="title">收银员管理</span>--%>
                                <%--<span class="arrow"></span>--%>
                            <%--</a>--%>
                            <%--<ul class="sub-menu">--%>
                                <%--<li class="nav-item  ">--%>
                                    <%--<a link="${basePath }merchant/business_page/cashier/cashier.jsp" href="javascript:void(0)"  class="nav-link ajax_link_m">--%>
                                        <%--<span class="title">--%>
                                            <%--<span class="fa fa-asterisk"></span>--%>
                                            <%--收银员--%>
                                        <%--</span>--%>
                                    <%--</a>--%>
                                <%--</li>--%>
                            <%--</ul>--%>
                        <%--</li>--%>

                        <%--<li class="nav-item">--%>
                            <%--<a href="javascript:;" class="nav-link nav-toggle">--%>
                                <%--<i class="fa fa-list"></i>--%>
                                <%--<span class="title"> &nbsp; 代金券</span>--%>
                                <%--<span class="arrow"></span>--%>
                            <%--</a>--%>
                            <%--<ul class="sub-menu">--%>
                                <%--<li class="nav-item ">--%>
                                    <%--<a link="${basePath }merchant/business_page/voucher/voucher.jsp" href="javascript:void(0)"  class="nav-link ajax_link_m">--%>
                                        <%--<span class="title">--%>
                                            <%--<span class="fa fa-list"></span>--%>
                                            <%--代金券管理--%>
                                        <%--</span>--%>
                                    <%--</a>--%>
                                <%--</li>--%>
                            <%--</ul>--%>
                        <%--</li>--%>
                    </ul>
                    <!-- END SIDEBAR MENU -->
                </div>
                <!-- END SIDEBAR -->
            </div>