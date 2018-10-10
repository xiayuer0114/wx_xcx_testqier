jQuery(function(){
	
	live_bind('.button-submit','click',function(){
    	submit_form_in_page_content_click(jQuery(this));
    });
	
	live_bind('.pager li','click',function(){
		submit_page_form_in_page_content(jQuery(this));
    }); 
	
	 // 为上一页,下一页,首页按钮 绑定事件
    live_bind('.pager_sun li','click',function(){
    	page_search_order($(this));
    });

    // 为上一页,下一页,首页按钮 绑定事件
    live_bind('.pager_store_list li','click',function(){
        page_search_store_list($(this));
    });
    
 // 为上一页,下一页,首页按钮 绑定事件
    live_bind('.pager_store li','click',function(){
    	page_search_store($(this));
    });
    
    init_merchantId_checkbox_select_all();
    
    live_bind('#id_query_list','click',function(){
    	refresh_settlement_list_url();
    	
    	 var ajax_link = $('#id_query_list').attr("link");
    	 if(checkNotNull(ajax_link)){
    		 ajax_link_click_m($('#id_query_list'));
    	 }
    	
    });
});
function find_form(formId){
	
	var form = null;
	
	if(typeof(formId) == 'string'){
		/** 通过id 找到form * */
		form = $('#'+formId);
		if(form.length==0){form = $('form[name="'+formId+'"]');}
	}else if(typeof(formId) == 'object'){
		form = $(formId);
	}

	return form;
}
function init_merchantId_checkbox_select_all(){
	live_bind('#merchantId_checkbox_select_all','click',function(){
   	 	if ($("#merchantId_checkbox_select_all").is(':checked')) {
            $("input[type='checkbox']").attr("checked", true);
            $("input[type='checkbox']").prop("checked",true);
        } else {
            $("input[type='checkbox']").attr("checked", false);
            $("input[type='checkbox']").removeAttr("checked");
        }
   }); 
}
function refresh_settlement_list_url(){
	    var reqParam = "";
	    var i = 0;
	  $(".merchantId_checkbox").each(function() {
	        if (i === 0 && $(this).is(':checked')){
	            reqParam += ("?subMerchantId=" + $(this).val());
	            i++;
	        }else if ($(this).is(':checked')){
	            reqParam += ("&subMerchantId=" + $(this).val());
	        }
	   });
	 
	    var reqUrl = basePath+"merchant/business_page/BranchManage/branch_list.jsp" + reqParam;
	    $('#id_query_list').attr("link", reqUrl);
}
function page_search_store(page_be_click){
	 var page = page_be_click.attr("page");
     if(checkNull(page)){ page = 1; }

     var form_be_done = $(document.forms["search_form"]);
     var page_input = jQuery(form_be_done).find("input[name='page']");
     if(page_input.length <= 0){
         form_be_done.append('<input  type="hidden" name="page" value="'+page+'" />');
     }else{
         page_input.val(page);
     }

     var data = $(document.forms["search_form"]).serializeArray();
     // 请求订单数据
     $.post(basePath+"/merchant/business_page/BranchManage/store_list.jsp",data,function(msg){
         $("#list_data_before").next().remove();
         $("#list_data_before").after(msg);
     });
}
function page_search_store_list(page_be_click){
    var page = page_be_click.attr("page");
    if(checkNull(page)){ page = 1; }

    var form_be_done = $(document.forms["search_form"]);
    var page_input = jQuery(form_be_done).find("input[name='page']");
    if(page_input.length <= 0){
        form_be_done.append('<input  type="hidden" name="page" value="'+page+'" />');
    }else{
        page_input.val(page);
    }

    var data = $(document.forms["search_form"]).serializeArray();
    // 请求订单数据
    $.post(basePath+"/qier/branchManage/loadMerchartOrder.do",data,function(msg){
        $("#list_data_before").next().remove();
        $("#list_data_before").after(msg);
    });
}
function page_search_order(page_be_click){
	//alert("调用上一页,下一页");
    var page = page_be_click.attr("page");
    if(checkNull(page)){ page = 1; }

    var form_be_done = $(document.forms["search_form"]);
    var page_input = jQuery(form_be_done).find("input[name='page']");
    if(page_input.length <= 0){
        form_be_done.append('<input  type="hidden" name="page" value="'+page+'" />');
    }else{
        page_input.val(page);
    }
    
    var request_data = $('#search_form').serializeArray(); 

    // 请求订单数据
    $.post(basePath+"/qier/orderReportContent/loadMerchartOrder.do",request_data,function(msg){
        $("#list_data_before").next().remove();
        $("#list_data_before").after(msg);
    });
}
function set_default_printer_by_name(LODOP_tmp,printer_name){
	if(checkNull(LODOP_tmp)){
		 return;
	}
	var index = get_printer_index_by_name(LODOP_tmp,printer_name);
	 
	LODOP_tmp.SET_PRINTER_INDEX(index)
}
function get_printer_index_by_name(LODOP_tmp,printer_name){
	if(checkNotNull(LODOP_tmp)){
		var iPrinterCount=LODOP_tmp.GET_PRINTER_COUNT();
		for(var i=0;i<iPrinterCount;i++){
			var printer_name = LODOP_tmp.GET_PRINTER_NAME(i);
			if(printer_name == default_printer_name){
				return i;
			}
	     };	
	}
}
function get_printer_name_by_index(LODOP_tmp,printer_index){
	if(checkNotNull(LODOP_tmp)){
		var iPrinterCount=LODOP_tmp.GET_PRINTER_COUNT();
		for(var i=0;i<iPrinterCount;i++){
			var printer_name = LODOP_tmp.GET_PRINTER_NAME(i);
			if(i == printer_index){
				return printer_name;
			}
	     };	
	}
}
function loadPageStart(){
		
}
function loadPageError(){
		alertMsg_warn("网络繁忙!");
}
function checkTrainFormUrl(url_string){
	
						modal_current_hide();
						
						jQuery('#trainCheckForm').attr("action",url_string);
						submit_form_in_page_content('trainCheckForm');
} 

var modal_current = null;

function fill_url_data(fill_url,fill_data){
	
	if(typeof(fill_data) == "object"){
		fill_data = JSON.stringify(fill_data);
	}
	
	var data_request = {"fill_data":fill_data};
	
	 jQuery.ajax({ 
			type : "post",
			url : fill_url,
			data : data_request,
			success : function(msg) { 
				modal_current_show(msg);
		    },error : function() {
		    	alertMsg_warn("网络繁忙！");
			}
		});
}

function modal_current_show_link(link_url){
	 jQuery.ajax({ 
			type : "get",
			url : link_url,
			success : function(msg) { 
				modal_current_show(msg);
		    },error : function() {
		    	alertMsg_warn("网络繁忙！");
			}
		});
}

function modal_current_hide(){
	if(modal_current != null){
		modal_current.modal('hide');
		modal_current.remove();
		jQuery('.modal-backdrop').remove();
	}
}

function modal_current_show(msg){
	if(modal_current != null){
		modal_current.modal('hide');
		modal_current.remove();
	}
	
	modal_current = jQuery(msg);
	modal_current.modal('show');
	
	init_compoment(modal_current);
}
function init_compoment(page_content_wrapper){
	page_content_wrapper.find('.date_m').each(function(){
		datepicker_m(this);
		jQuery(this).removeClass("date_m");
	});
	 //下拉列表
	page_content_wrapper.find('.bs-select').each(function(){
   	 	//下拉列表
    	jQuery(this).selectpicker({
            iconBase: 'fa',
            noneSelectedText: '没有选中任何项',
            tickIcon: 'fa-check'
        });
    	
    	var svalue = jQuery(this).attr("svalue");
    	
    	if(checkNotNull( svalue) ){
    		jQuery(this).selectpicker('val', svalue);
    	}
    });
    
	 //下拉列表
	page_content_wrapper.find('.touchspin').each(function(){
        jQuery(this).TouchSpin({
            min:1,
            max:500,
            width:10
        });
    });
}
function changeLowUserBalance(randId){
	var lowUserId = jQuery('#'+randId+"lowUserId").val();
	var orderId = jQuery('#'+randId+"orderId").val();
	var balance = jQuery('#'+randId+"balance").val();
	var memo = jQuery('#'+randId+"memo").val();
	
	var requestData = { "request":{
						"lowUserId":lowUserId,
						"orderId":orderId,
						"balance":balance,
						"memo":memo
					}};
	userRequestSimple(url_changeLowUserBalance,requestData,function(msg){
		modal_current_hide();
		linkToPage(basePath+"merchant/business_page/transaction_settlement/agencies.jsp");
	});
}
function datepicker_m(input_click){
	var $this = $(input_click);
	var opts = {};
	if ($this.attr("dateFmt"))
		opts.pattern = $this.attr("dateFmt");
	if ($this.attr("minDate"))
		opts.minDate = $this.attr("minDate");
	if ($this.attr("maxDate"))
		opts.maxDate = $this.attr("maxDate");
	if ($this.attr("mmStep"))
		opts.mmStep = $this.attr("mmStep");
	if ($this.attr("ssStep"))
		opts.ssStep = $this.attr("ssStep");
	$this.datepicker(opts);
}
function changeLowUserState(lowUserId,link_m){ 
	
	var requestData = { "request":{
						"lowUserId":lowUserId
					}};
	
	userRequestSimple(url_changeLowUserState,requestData,function(msg){
		linkToPage(link_m);
	});
}
function changePassword(){
	var pwdOld = jQuery('#pwdOld').val();
	 var pwdNew = jQuery('#pwdNew').val();
	 var pwdRe = jQuery('#pwdRe').val();

	 if (pwdNew=="" || pwdNew==null || pwdOld=="" || pwdOld==null || pwdRe=="" || pwdRe==null){
         jQuery('#errorMsgForPwd').text("信息不完整!");
         return;

	 }

	 if( pwdNew.length < 6){
         var pwdRe = jQuery('#errorMsgForPwd').text("新密码必须大于6位!");
		 return;
	 }
	 if(pwdRe != pwdNew){
         jQuery('#errorMsgForPwd').text("两次输入的新密码不一样!");
		 return;
	 }

    pwdOld = hex_md5(pwdOld);
    pwdNew = hex_md5(pwdNew);

    $.post("/qier/cashier/changePwd.do",{"pwdOld":pwdOld,"pwdNew":pwdNew},function (msg) {
        var res = json2obj(msg);
        alertMsg_info(res.message)
    })

}
// var requestData = { "request":{
// 	"pwdOld":pwdOld,
// 	"pwdNew":pwdNew,
// }};
// userRequestSimple(url_changePassword, requestData);
/**
 * 按钮按了submit 提交form
 * @param button_click
 * @returns
 */
function submit_page_form_in_page_content(button_click){
	
	var form_be_done = null;
	
	var target_form = button_click.attr("target_form");
	if(checkNull(target_form)){
		target_form = "search_form";
	}
	
	if(checkNotNull(target_form)){
		form_be_done =  document.forms[target_form];
	}
	
	if(form_be_done == null){
		return;
	}
	
	var page = button_click.attr("page");
	if(checkNull(page)){ page = 1; }
	
	var page_input = jQuery(form_be_done).find("input[name='page']");
	
	if(page_input.length <= 0){
		jQuery(form_be_done).append('<input  type="hidden" name="page" value="'+page+'" />');
	}else{
		page_input.val(page);
	}
	
	var beforeFunction = jQuery(form_be_done).attr('before');
	var after = jQuery(form_be_done).attr('after');
	submit_form_in_page_content(form_be_done,beforeFunction);
}
/**
 * 按钮按了submit 提交form
 * @param button_click
 * @returns
 */
function submit_form_in_page_content_click(button_click){
	var form_be_done = find_form_by_button(button_click);
	if(form_be_done == null){
		return;
	}
	
	var page_input = jQuery(form_be_done).find("input[name='page']");
	//page_input.val("");
	
	var beforeFunction = jQuery(form_be_done).attr('before');
	submit_form_in_page_content(form_be_done,beforeFunction);
}
/**
 * 通过按钮找表单
 * @param button_click
 * @returns
 */
function find_form_by_button(button_click_parent){
	
	var target_form = button_click_parent.attr("target_form");
	if(checkNotNull(target_form)){
		var form_target =  document.forms[target_form];
		if(form_target != null){
			return form_target;
		}
	}
	
	if(button_click_parent == null){
		return null;
	}
	var tagName = button_click_parent.get(0).tagName;
	
	if(tagName == "form" || tagName == "FORM"){
		return button_click_parent;
	}
	if(tagName == undefined || tagName == null){
		return null;
	}
	var button_click_parent = button_click_parent.parent();
	
	var form = find_form_by_button(button_click_parent);
	
	return form;
}
 

function alertMsg_correct(message){
	alert(message);
}
function alertMsg_warn(message){
	alert(message);
}
function alertMsg_info(message){
	alert(message);
}



function linkToPage(link_m){
	var ajaxData = { 
			type : "get",
			url : link_m,
			dataType : "text",
			timeout:15*1000,
			success : function(msg){
				 page_content_wrapper_msg_back(msg);
			},
		    error : function(){
		    	loadPageError();
			}
		};
		jQuery.ajax(ajaxData);
}

function page_content_wrapper_msg_back(msg){
	
	if(msg != null && msg.length < 200){
		 var res_json = json2obj(msg);
		 
		 if(res_json == null){
			 var page_msg = jQuery(msg);
			 init_compoment(page_msg);
			 jQuery('.page-content-wrapper').html(page_msg);
		 }else{
			 //登录
			 if(res_json != null && res_json.statusCode == "301"){
				 redirectPage(basePath+"merchant/needLogin.jsp");
			 }
			 //错误
			 if(res_json != null && res_json.statusCode == "300"){
				 if( checkNotNull(res_json.message) ){
					 alertMsg_info(res_json.message);
				 }
			 }
		 }
	 }else{
		 var page_msg = jQuery(msg);
		 init_compoment(page_msg);
		 jQuery('.page-content-wrapper').html(page_msg);
		 
	 }
}

function submit_form_in_page_content(form_be_done,beforeFunction){
	
	ajaxForm(form_be_done,beforeFunction,function(msg){
		 page_content_wrapper_msg_back(msg);
	},function(){
		loadPageError();
	});
}

function ajax_link_click_m(a_click,finishCallBack){
	var link_m = jQuery(a_click);
	var link = link_m.attr("link");
	var ajaxData = { 
			type : "get",
			url : link,
			dataType : "text",
			timeout:15*1000,
			success : function(msg){
				page_content_wrapper_msg_back(msg);
				 if(finishCallBack != undefined && finishCallBack != null && typeof(finishCallBack) == "function"){
					 finishCallBack(msg);
				 }
			},
		    error : function(){
		    	loadPageError();
			}
		};
		
		jQuery.ajax(ajaxData);
}

function convertSerializeArrayToRequest(serializeArray){
	var requestData = {};
	for(var i=0;i<serializeArray.length;i++){
		var name = serializeArray[i].name;
		var value = serializeArray[i].value;
		//如果已经有的那么就是数组
		if(checkNotNull(requestData[name])){
			if(typeof(requestData[name]) == "string"){
				var old_value = requestData[name];
				requestData[name] = new Array();
				requestData[name].push(old_value);
			} 
			requestData[name].push(value);
		}else{
			requestData[name] = value;
		}
	}
	return requestData;
}

function addLowUser(){
	
	var serializeArray = jQuery('#addLowUser_form').serializeArray();
	
	var serializeData = convertSerializeArrayToRequest(serializeArray);
	
	var requestData = { "request":serializeData};
	
	userRequestSimple(url_addLowUser, requestData,function(data){
		modal_current_hide();
		linkToPage(basePath+"merchant/business_page/transaction_settlement/agencies.jsp");
	});
	return false;
}

function userRequestSimple(url_request,requestData,funcok,funcfalse){
	var requestString = JSON.stringify(requestData);
	
	var url_request_full = "face/rechargeuserfront/"+url_request+".do";
	
	sendDataSimple(url_request_full, requestData, funcok, funcfalse);
}

function errMessageShow(message){
	
	var submit_form = jQuery('.submit_form');
	var error = jQuery('.alert-danger', submit_form);
    var success = jQuery('.alert-success', submit_form);
    
    success.hide();
    
    if(checkNotNull( message) ){
    	error.html('<button data-dismiss="alert" class="close"></button>'+message);
    }
    
    error.show();
    
    App.scrollTo(error, -200);
}
var loading_old_html = null;

function loadingStart(){
	
	var loading_html_tmp = jQuery('.loading').html();
	
	var loading_html = '<img style="line-height:34px;text-align:center;height: 23px;" src="'+basePath+'merchant/img/loding.gif" >';
	
	if(loading_old_html == null){
		loading_old_html = loading_html_tmp;
	} 
	
	jQuery('.loading').html(loading_html);
}
function loadingEnd(){
	jQuery('.loading').html(loading_old_html);
}
/**
 * 交易成功
 */
var STATE_OK = "200";
/**
 * 等待付款
 */
var STATE_WAITE_PAY = "201";  
/**
 * 交易失败
 */
var STATE_FALSE = "300";
/**
 * 等待发货(交易已提交)
 */
var STATE_WAITE_WAITSENDGOODS = "202";
/**
 * 等待结果
 */
var STATE_DONOTKNOW = "501";  

/**
 * 接收成功
 */
var statusCode_ACCEPT_OK = "200";
/**
 * 接收失败
 */
var statusCode_ACCEPT_FALSE = "300";
/**
 * 系统异常
 */
var statusCode_ACCEPT_GUAQI = "500";

/**
 * 交易成功
 */
var STATE_OK = "200";
/**
 * 交易失败
 */
var STATE_FALSE = "300";
/**
 * 等待处理
 * 这个是处理业务逻辑是等待处理
 * 比如供货用的就是这个
 */
var STATE_WAITE_PROCESS = "502";  
/**
 * 处理中
 * 这个是处理业务逻辑前的交易处理中
 * 是这个状态就是最终款都木有扣
 */
var STATE_INPROCESS = "500";  
/**
 * 等待结果
 * 这个是处理业务逻辑之后的交易处理中
 * 是这个状态就是扣了款的
 */
var STATE_DONOTKNOW = "501";  
/**
 * 订单不存在
 */
var STATE_ORDER_NOT_EXIST = "404";  
/**
 * 等待付款
 */
var STATE_WAITE_PAY = "201";  
/**
 * 等待发货
 */
var STATE_WAITE_WAITSENDGOODS = "202";  
/**
 * 等待确认收货
 */
var STATE_WAITE_CODWAITRECEIPTCONFIRM = "203";  
/**
 * 已退款
 */
var STATE_REFUND_OK = "204"; 
/**
 * 交易关闭
 */
var STATE_CLOSED = "205";  

var client_type_xml = 1;
var client_type_json = 2;

function sendDataSimple(urlString,requestData,funcok,funcfalse,isEncryptionTmp){
	
	var requestString = JSON.stringify(requestData);
	
	sendData(urlString, requestString , function(returndata){
		var responseData = json2obj(returndata);
		var statusCode = responseData.statusCode;
		
		if(responseData.statusCode == statusCode_ACCEPT_FALSE){
			if(funcfalse != null && funcfalse != undefined ){
				funcfalse(responseData);
			}else{
				if( checkNotNull(responseData.message) ){
					alertMsg_info(responseData.message);
				}
			}
			return;
		}else if(responseData.statusCode == statusCode_ACCEPT_OK){
			if(funcok != null && funcok != undefined ){
				funcok(responseData); 
			}else{
				if( checkNotNull(responseData.message) ){
					alertMsg_correct(responseData.message);
				}
			}
		}else{
			if( checkNotNull(responseData.message) ){
				alertMsg_warn(responseData.message);
			}
		} 
	}, function(){
		alertMsg_info("网络繁忙!请确认是否操作成功！");
	}, isEncryptionTmp);
}

/**
 * 支付密码正常使用
 */
var payPwdState_STATE_OK = "1";
/**
 * 支付密码异常使用
 */
var payPwdState_STATE_NOTOK = "2";

function sendData(urlString,dataString,funcok,funcfalse,isEncryptionTmp,timeout){
	
	var payPwdState = getData("payPwdState");
	if(payPwdState == payPwdState_STATE_OK){
		
		var confirm_paypassword_input = jQuery("input[name='confirm_paypassword']");
		
		if(confirm_paypassword_input.length > 0){
			var confirm_paypassword = jQuery("input[name='confirm_paypassword']").val();
			
			var data_root  =  null;
			if(typeof(dataString) == "string"){
				data_root  = json2obj(dataString);
			}
			
			var data_root_request = data_root.request;
			if(data_root_request != null){
				data_root = data_root_request;
			}
			data_root.confirm_paypassword = confirm_paypassword;
			dataString = data_root;
		}
	}
	
	
	var key = getData("key");
	var name = getData("name");
	var isEncryption = true;
	var hexmac = true;
	if(isEncryptionTmp == false){
		isEncryption = false;
	} 
	
	var timestamp = Math.random()+"";
	
	var keyFinal = hex_md5(key + timestamp);
	
	var data = dataString;
	
	if(typeof(dataString) == "object"){
		data = JSON.stringify(dataString);
	}
	
	//兼容问题 如果没加密 就只能采用16进制的信息摘要
	if(isEncryption){
		data = encryptStr(data,keyFinal.substring(0, 16));
	} 

	var urlString_full = basePath+urlString;
	
	var mac =  "";
	var mac_old = "";
	if(hexmac){
		mac_old = keyFinal+ toHexStr(name+data).toLocaleLowerCase();
	}else{
		mac_old = keyFinal+toHexStr(name).toLocaleLowerCase()+ data;
	} 
	mac = hex_md5(mac_old);
	
	var reqData = 
		 "name="+name+
			"&randCode="+timestamp+
			"&encrpt=enAes"+
			"&isEncryption="+isEncryption+
			"&mode="+client_type_json+
			"&data="+data+
			"&hexmac="+hexmac+
			"&mac="+mac;
	
	var ajaxData = { 
		type : "post",
		url : urlString_full,
		data : reqData,
		dataType : "text",
		success : function(msg){
			var returndata = null;
			//xml 和 json 未加密的就不解密了
			if(msg.indexOf("response") != -1 || msg.indexOf("{") != -1){
				returndata = msg;
			}else{
				returndata = decryptStr(msg,keyFinal.substring(0, 16));
			}
			funcok(returndata);
		},
	    error : function(){
			funcfalse();
		}
	};
	
	if(timeout == undefined || timeout == null ){
		timeout = 30*1000;
	}
	ajaxData.timeout = timeout;
	
	jQuery.ajax(ajaxData);
}
 
function  login(){
	var username = jQuery('#username').val();
	var password = jQuery('#password').val();
	var randCode = jQuery('#randCode').val();
	
	if(!checkNotNull(username)){
		alertMsg_info("请填写用户名!");
		return;
	}
	if(!checkNotNull(password)){
		alertMsg_info("请填写用密码!");
		return;
	}
	if(!checkNotNull(randCode)){
		alertMsg_info("请填写验证码!");
		return;
	}
	 
	var md5Final  = hex_md5(password);
	var userpwd_final = hex_md5(md5Final+randCode.toLowerCase());
	
	jQuery.ajax({
		type : "post",
		url :  basePath+'front/login.do',
		data: "username="+username+"&userpwd="+userpwd_final,
		dataType:"text",
		success : function(msg) {
			var res = json2obj(msg);
			if(res.statusCode == "200"){
			   	document.forms['index'].submit();    
		 	}else{
		 		randChange();
		 		alertMsg_info(res.message);
		 	}
		}, error : function() {
			alertMsg_warn("网络繁忙！");
		}
	});
}

function ajax_open(link_href,sure_func,cancle_func){
	ajax_get(link_href,function(html_content){
		 layer.open({
            type: 1,
            shadeClose: true, //点击遮罩关闭
            content: html_content,
            btn:['保存','取消'],
            btn1:function(){
            	sure_func();
            },
        });
	});  
}

function printed_tradeRecord_id(tradeRecord_id){
	ajax_post(
			basePath+"qierFront/tradeRecord_printed.do",
		{"tradeRecord_id":tradeRecord_id},
		function (message) {
		}
	);
}
var LODOP = null;

var font_size_width_bili = 1.32;

	var base_left = 10;
	var base_top = 10;
	var base_width_full = 182;

function print_tradeRecord(tradeRecord_tmp){
	for(var i=0;i<print_lianshu;i++){
		print_tradeRecord_one(tradeRecord_tmp);
	}
}
/**
 * 第一联
 * @param tradeRecord_tmp
 * @returns
 */
function print_tradeRecord_one(tradeRecord_tmp){
	
	base_top = 10;
	
	LODOP	=	getLodop();
	
	var date_now = new Date(); 
	
	var date_now_str = date_to_string(date_now);
	
	//打印机机型
	/*var name= LODOP.PRINTSETUP_PRINTER_NAME;
	
	name=$.trim(name);
	//此处可以根据机型去做操作上的处理
	if(name=='XP-58'){
		LODOP.SET_PRINT_STYLE("Bold",1);
	}*/
	
	LODOP.SET_PRINT_STYLE("Bold",1);
	
	LODOP.PRINT_INIT("58mm");	
	LODOP.SET_PRINT_PAGESIZE(0,580,1180,"58mm");
	
	LODOP.SET_PRINT_STYLE("Bold",1);

	
	LODOP.SET_PRINT_STYLE("Alignment",2);
	
	LODOP.SET_PRINT_STYLE("FontSize",20);
	LODOP.ADD_PRINT_TEXT(base_top,base_left,182,15,tradeRecord_tmp.userId_merchant_name);
	
	LODOP.SET_PRINT_STYLE("FontSize",8);
	LODOP.SET_PRINT_STYLE("Alignment",1);
	base_top += 30;
	//LODOP.ADD_PRINT_TEXT(new_line_top(),base_left,base_width_full,15,"订单序号:16");
	LODOP.ADD_PRINT_TEXT(new_line_top(),base_left,base_width_full,15,"订单编号:"+tradeRecord_tmp.requestFlow);
	
	LODOP.ADD_PRINT_TEXT(new_line_top(),base_left,base_width_full,11,"………………………………………………………………………………");
	
	LODOP.ADD_PRINT_TEXT(new_line_top(),base_left,base_width_full,11,"订单时间:"+tradeRecord_tmp.showTime);
	LODOP.ADD_PRINT_TEXT(new_line_top(),base_left,base_width_full,11,"打印时间:"+date_now_str);
	LODOP.ADD_PRINT_TEXT(new_line_top(),base_left,base_width_full,11,"备注:"+tradeRecord_tmp.memo);
	
	//LODOP.SET_PRINT_STYLE("Bold",1);
	LODOP.SET_PRINT_STYLE("FontSize",12);
	LODOP.ADD_PRINT_TEXT(new_line_top(),base_left,base_width_full,11,"………………………………………………………………………………");
	LODOP.SET_PRINT_STYLE("FontSize",8);
	//LODOP.SET_PRINT_STYLE("Bold",0);
	
	base_top +=10;
	LODOP.ADD_PRINT_TEXT(new_line_top(),base_left,40,11,"商品名称");
	LODOP.ADD_PRINT_TEXT(base_top,base_left+60,40,11,"数量");
	LODOP.ADD_PRINT_TEXT(base_top,base_left+90,40,11,"单价");
	LODOP.ADD_PRINT_TEXT(base_top,base_left+120,40,11,"小计");
	
	base_top += 5;
	LODOP.ADD_PRINT_TEXT(new_line_top(),base_left,60,11,tradeRecord_tmp.product_name);
	LODOP.ADD_PRINT_TEXT(base_top,base_left+60,60,11,tradeRecord_tmp.quantity/100);
	LODOP.ADD_PRINT_TEXT(base_top,base_left+90,60,11,tradeRecord_tmp.price_fen/100);
	LODOP.ADD_PRINT_TEXT(base_top,base_left+120,60,11,tradeRecord_tmp.price_fen_all/100);
	
	LODOP.ADD_PRINT_TEXT(new_line_top(),base_left,base_width_full,11,"………………………………………………………………………………");
	
	

	base_top += 10;
	LODOP.SET_PRINT_STYLE("Alignment",1);
	LODOP.ADD_PRINT_TEXT(new_line_top(),base_left,base_width_full-30,11,"钱包支付:"+tradeRecord_tmp.amount_payment/100);
	
	//退款金额为零则不展示
	if((tradeRecord_tmp.had_refund_amout_fen_all) != 0){
	LODOP.ADD_PRINT_TEXT(new_line_top(),base_left,base_width_full-30,11,"退款金额:"+tradeRecord_tmp.had_refund_amout_fen_all/100);
	}
	
	LODOP.ADD_PRINT_TEXT(new_line_top(),base_left,base_width_full-30,11,"实收(¥):"+tradeRecord_tmp.payPrice_fen_all/100);
	LODOP.ADD_PRINT_TEXT(new_line_top(),base_left,base_width_full-30,11,"合计:"+tradeRecord_tmp.price_fen_all/100);
	
	base_top += 10;
	
	LODOP.SET_PRINT_STYLE("Alignment",1);
	LODOP.ADD_PRINT_TEXT(new_line_top(),base_left,base_width_full-30,11,"状态:"+tradeRecord_tmp.showState+"("+tradeRecord_tmp.showPay_method+")");
	
	LODOP.ADD_PRINT_TEXT(new_line_top(),base_left,base_width_full,11,"………………………………………………………………………………");
	LODOP.ADD_PRINT_TEXT(new_line_top(),base_left,base_width_full-30,11,"悠择生活竭诚为您服务!");
	
	LODOP.ADD_PRINT_TEXT(new_line_top(),base_left,base_width_full-30,11,"关注悠择生活领取红包");
	
	LODOP.ADD_PRINT_BARCODE(new_line_top(), base_left,base_width_full, base_width_full, "QRCode", "http://weixin.qq.com/r/ty9ieuPEIb5eracZ93ql")
	
	if(checkNotNull(default_printer_name)){
		set_default_printer_by_name(LODOP,default_printer_name);
	}
	/**
	 * LODOP.PREVIEW();	打印预览
	 * */
  	LODOP.PRINT();		 

}
	
	function new_line_top(){
		base_top += 12;
		return base_top;
	}
	
	/**
	 * 交易成功
	 */
	var STATE_OK = "200";
	/**
	 * 等待付款
	 */
	var STATE_WAITE_PAY = "201";
	/**
	 * 交易失败
	 */
	var STATE_FALSE = "300";
	/**
	 * 等待发货(交易已提交)
	 */
	var STATE_WAITE_WAITSENDGOODS = "202";
	/**
	 * 等待结果
	 */
	var STATE_DONOTKNOW = "501";

	/**
	 * 接收成功
	 */
	var statusCode_ACCEPT_OK = "200";
	/**
	 * 接收失败
	 */
	var statusCode_ACCEPT_FALSE = "300";
	/**
	 * 系统异常
	 */
	var statusCode_ACCEPT_GUAQI = "500";

	/**
	 * 交易成功
	 */
	var STATE_OK = "200";
	/**
	 * 交易失败
	 */
	var STATE_FALSE = "300";
	/**
	 * 等待处理 这个是处理业务逻辑是等待处理 比如供货用的就是这个
	 */
	var STATE_WAITE_PROCESS = "502";
	/**
	 * 处理中 这个是处理业务逻辑前的交易处理中 是这个状态就是最终款都木有扣
	 */
	var STATE_INPROCESS = "500";
	/**
	 * 等待结果 这个是处理业务逻辑之后的交易处理中 是这个状态就是扣了款的
	 */
	var STATE_DONOTKNOW = "501";
	/**
	 * 订单不存在
	 */
	var STATE_ORDER_NOT_EXIST = "404";
	/**
	 * 等待付款
	 */
	var STATE_WAITE_PAY = "201";
	/**
	 * 等待发货
	 */
	var STATE_WAITE_WAITSENDGOODS = "202";
	/**
	 * 等待确认收货
	 */
	var STATE_WAITE_CODWAITRECEIPTCONFIRM = "203";
	/**
	 * 已退款
	 */
	var STATE_REFUND_OK = "204";
	/**
	 * 交易关闭
	 */
	var STATE_CLOSED = "205";

	/**
	 * 方法不具备此功能 比如确认交易记录状态，这个通道没有这个方法
	 * 那么就确认一次 如果返回 这个状态 就不再轮巡刷新状态了
	 */
	var STATE_DONOT_HAS_FUNCTION = "206";
	/**
	 * 付款成功
	 */
	var STATE_PAY_SUCCESS = "207";  
	/**
	 * 等待退款
	 */
	var STATE_WAITE_REFUND = "208"; 
	/**
	 * 退款失败
	 */
	var STATE_REFUND_FALSE = "2081"; 
	/**
	 * 等待处理
	 */
	var STATE_WAITE_CHANGE = "209";
	/**
	 * 处理失败
	 */
	var STATE_WAITE_CHANGE_FLASE = "2091"; 
 