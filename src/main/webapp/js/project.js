/**
 * 微信支付
 */
var pay_method_weipay = 400;
/**
 * 支付宝支付
 */
var pay_method_alipay = 300;
/**
 * 钱包支付
 */
var pay_method_balance = 100;

$(function(){
	//绑定红包事件
	$('.open_red_package').on('click',function(){
		start_open_red_package();
 	 });  
	//创建订单
	$('.create_tradeorder').on('click',function(){
		
		var create_tradeorder_click_btn = $(this);
		
		if(is_first_user == "true"){
			
			var request_url = basePath+"activities/SubscribeFirst/create_subscribeFirst_qr_code.jsp";
			
			var price_yuan = $(".pay-money").html();
			var product_id = getInputValue("product_id");
			var orderId = getInputValue("orderId");                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
			
			var request_data = {
					"product_id":product_id
					,"price_yuan":price_yuan
					,"orderId":orderId
			};
			
			ajax_post(request_url,request_data,function(msg){
				var responseData = json2obj(msg);
				
				if(responseData.statusCode != statusCode_ACCEPT_OK){
					create_tradeorder_click(create_tradeorder_click_btn);
					return;
				}
				
				//信息框
				  layer.open({
				    content: responseData.html
				    ,style: 'padding: 0;width: 80%;'
				    ,btn: '无视勾引,继续付款'  
				    ,yes: function(index){
				    	layer.close(index);
				    	create_tradeorder_click(create_tradeorder_click_btn);
				    }
				  });
			});
			
			 
		}else{
			create_tradeorder_click(create_tradeorder_click_btn);
		}
		
	});
	//选择支付方式
	$('.radio-beauty-out').on('click',function(){
		radio_beauty_out_click($(this));
	});
}); 

function receive_red_envelopes(merchantRedEnvelope_id,tradeRecord_id){
	
	var request_data = {
			"tradeRecord_id":tradeRecord_id,
			"merchantRedEnvelope_id":merchantRedEnvelope_id
	};
	
	ajax_post(basePath+"qierFront/receive_red_envelopes.do",
			request_data,
			function (message) {
				var data_root = json2obj(message);                    				
				 
				var statusCode = data_root.statusCode;
				
				if(statusCode != statusCode_ACCEPT_OK){
					alertMsg_correct(data_root.message);
					return;
				}
				$('.'+merchantRedEnvelope_id).hide();
				$('.'+merchantRedEnvelope_id).next().show();
			} 
		);
	
} 

function create_tradeorder_click(create_tradeorder_be_clicked){
	
	var css_tmp = create_tradeorder_be_clicked.css("background-color");
	
	var is_paying = create_tradeorder_be_clicked.attr("is_paying");
	
	if(is_paying == "true"){
		alertMsg_info("提交中~请稍后!");
		return;
	}
	create_tradeorder_be_clicked.attr("is_paying","true");
	
	create_tradeorder_be_clicked.css("background-color","#999");
    setTimeout(function(){ 
    	create_tradeorder_be_clicked.css("background-color",css_tmp);
    	create_tradeorder_be_clicked.attr("is_paying","false");
    }, 5000);
	
	var quantity = $('.pay-money').html();
	
	var product_id = getInputValue("product_id");
	var orderId = getInputValue("orderId");
	
	if(checkNull(orderId)){
		orderId = new Date().getTime()+"";
	}
	
	var yongcan_renshu_str = $('.swiper-slide-active').attr("data");
	var order_memo = getInputValue("order_memo");
	var cashier_id = getInputValue("cashier_id");
	var userVoucher_id = getInputValue("userVoucher_id");
	if(checkNotNull(yongcan_renshu_str)){ 
		var yongcan_renshu = parseInt_m(yongcan_renshu_str);
		var canWeiFei_yuan_all = sheng(yongcan_renshu,canWeiFei_yuan);
		
		quantity = jia(quantity,canWeiFei_yuan_all);
		
		order_memo = "用餐人数:"+yongcan_renshu+"人 餐位费:"+canWeiFei_yuan_all+"元";
	}
	
	var wallet_is_select_value = wallet_is_select();
	
	var request_data = {
			product_id:product_id,
			order_memo	:	order_memo,
			wallet_pay	:	wallet_is_select_value,
			orderId	:	orderId,
			cashier_id	:	cashier_id,
			userVoucher_id	:	userVoucher_id,
			quantity:quantity
	}; 
    setTimeout(function(){ 
    	create_tradeRecord(request_data);
    }, 10);
}

/**
 * 选择支付方式
 * @param be_clicked_button
 * @returns
 */
function radio_beauty_out_click(be_clicked_button){
	
	var label_radio_beauty = be_clicked_button.find('.radio-beauty');
	
	 var data_select = label_radio_beauty.attr('data_select');
	 
	 var data_type = be_clicked_button.attr('data_type');
	 
	 var showBalance_str = getInputValue("showBalance");
	 var showBalance_float = parseFloat_m(showBalance_str);
	 
	 var quantity_str = $('.pay-money').html();
	 var quantity_float = parseFloat_m(quantity_str);
	 
	 var is_balance_enough = check_balance_enough();
	 
	 if(data_select != "true"){
		 //选择
		 label_radio_beauty.addClass("radio_beauty_check");
		 label_radio_beauty.attr('data_select','true');
	 }else{
		 //取消
		 label_radio_beauty.removeClass("radio_beauty_check"); 
		 label_radio_beauty.attr('data_select','false');
	 } 
	 if(!wallet_is_select() && !pay_method_is_select()){
		 	$('.pay-item > .radio-beauty').addClass("radio_beauty_check"); 
			$('.pay-item > .radio-beauty').attr('data_select','true');
	 }
	 if(!is_balance_enough  && !pay_method_is_select()){
		 	$('.pay-item > .radio-beauty').addClass("radio_beauty_check"); 
			$('.pay-item > .radio-beauty').attr('data_select','true');
	 }
	 if(is_balance_enough  && pay_method_is_select() && wallet_is_select()){
		   if(data_type == "balance"){
				$('.pay-item > .radio-beauty').removeClass("radio_beauty_check"); 
				$('.pay-item > .radio-beauty').attr('data_select','false');
		   }else{
			   $('.wallet-item > .radio-beauty').removeClass("radio_beauty_check"); 
			   $('.wallet-item > .radio-beauty').attr('data_select','false'); 
		   }
	 }
	 
	 refresh_pay_money();
}
 
function wallet_is_select(){
	var balance_select =  $('.wallet');
	
	var label_radio_beauty = balance_select.find('.radio-beauty');
	
	var data_select = label_radio_beauty.attr('data_select');
 
	return data_select == "true";
}

function pay_method_is_select(){
	var balance_select =  $('.pay-item');
	var label_radio_beauty = balance_select.find('.radio-beauty');
	
	var data_select = label_radio_beauty.attr('data_select');
 
	return data_select == "true";
}

function refresh_pay_money(){
	
	var balance_select =  $('.wallet');
	
	var voucherValue_str =  getInputValue('voucherValue');
	
	var voucherValue_float = parseFloat_m(voucherValue_str);
	
	var label_radio_beauty = balance_select.find('.radio-beauty');
	
	var data_select = label_radio_beauty.attr('data_select');
	
    var priceElement =  $('#pay-price');
    var pay_money = parseFloat_m($('.pay-money').html()); // 要买单的金额
    
    if(!isNumber(pay_money)){
    	return;
    }
    
    if(isNumber(voucherValue_float)) {
        pay_money -= voucherValue_float;
        if (pay_money<=0) {
            pay_money = 0;
        }
    }
    
	var yongcan_renshu_str = $('.swiper-slide-active').attr("data");
	if(checkNotNull(yongcan_renshu_str)){ 
		var yongcan_renshu = parseInt_m(yongcan_renshu_str);
		var canWeiFei_yuan_all = sheng(yongcan_renshu,canWeiFei_yuan);
		pay_money = jia(pay_money,canWeiFei_yuan_all);
	}

    
    if(wallet_is_select()){ 
    	 var showBalance_str = getInputValue("showBalance");
		 var showBalance_float = parseFloat_m(showBalance_str);
		 
		 var is_balance_enough = check_balance_enough();
		 
		 
		 if(is_balance_enough){
			 priceElement.html("0");
			 $('.waite_back_payment').html("0");
		 }else{
			 var payment_final = jian(pay_money,showBalance_float);
			 priceElement.html(payment_final);
			 $('.waite_back_payment').html(payment_final);
		 }
    }else{
    	 priceElement.html(pay_money);
    	 $('.waite_back_payment').html(pay_money);
    }
}

function check_balance_enough(){
	 var showBalance_str = getInputValue("showBalance");
	 var showBalance_float = parseFloat_m(showBalance_str);
	 
	 var quantity_str = $('.pay-money').html();
	 var quantity_float = parseFloat_m(quantity_str);
	 
	var voucherValue_str =  getInputValue('voucherValue');
	var voucherValue_float = parseFloat_m(voucherValue_str);
	if(!isNumber(voucherValue_float)){voucherValue_float = 0;} 
	
	 
	 var is_balance_enough = !isNaN(showBalance_float) && !isNaN(quantity_float) &&  jia(showBalance_float,voucherValue_float) >= quantity_float;
	 
	 return is_balance_enough;
}

var payFlow = null;

function start_tradeRecord_paydata(tradeRecord_id){
	
	var wallet_pay = wallet_is_select();
	
	 var pay_money = parseFloat_m($('.pay-money').html()); // 要买单的金额
	 var showBalance_str = getInputValue("showBalance");
	 var merchantRedEnvelope_id = getInputValue("merchantRedEnvelope_id");
	 var showBalance_float = parseFloat_m(showBalance_str);
	 
	 var is_balance_enough = check_balance_enough();
	 
	 if(wallet_pay && is_balance_enough){
		 //如果金额足够
		 default_pay_method = pay_method_balance;
	 }
	 
	var request_data = {
			pay_method	:	default_pay_method,
			wallet_pay	:	wallet_pay,
			tradeRecord_id	:	tradeRecord_id
	}; 
	
	if(wallet_pay){
		//选择了金额的默认就使用定向红包
		request_data.merchantRedEnvelope_id = merchantRedEnvelope_id;
	}
	
	$.ajax({
		type : "post",
		url : basePath+"payFront/create_paymentRecord.do",
		data : request_data,
		dataType : "text",
		timeout:30*1000,
		async: false,
		success : function(msg) {
				var responseData = json2obj(msg);
				var statusCode = responseData.statusCode;
				
				if(responseData.statusCode != statusCode_ACCEPT_OK){
					alertMsg_correct(responseData.message);
					return;
				}
			
				var data = responseData.data;
				
				var pay_data_str = data.pay_data;
				
				var pay_data = json2obj(pay_data_str);
				if(pay_data != null){
					payFlow = data.payFlow;
				}

				$('#pay_success_out_trade_no').val(payFlow);
				
				if(pay_method_weipay == default_pay_method){
					process_pay_data_weipay(data);
				}else if(pay_method_alipay == default_pay_method){
					//支付宝
					process_pay_data_alipay(pay_data_str);
				}else if(pay_method_balance == default_pay_method){
					process_pay_data_balance(data);
				} 
	    },
	    error : function(){
	    	alertMsg_info("网络繁忙,请检查您的网络!");
	    	layer.closeAll();
		}
	});
}
/**
 * 微信支付 处理
 * @param pay_data
 * @returns
 */
function process_pay_data_weipay(data){
	
	var pay_data_str = data.pay_data;
	
	var pay_data = json2obj(pay_data_str);
	
	var payFlow = data.payFlow;
	
	weipay_start(pay_data,function(res){
		  if(res.err_msg == "get_brand_wcpay_request:ok" ) {
			  document.forms["pay_success_back_form"].submit();
		  }else{
			  jQuery('.layui-m-layersection').css("vertical-align","middle");
			  alertMsg_warn("支付失败!");
		  }
	}); 
	
}
/**
 * 支付宝 处理
 * @param pay_data
 * @returns
 */
function process_pay_data_alipay(pay_data){
	$('.alipay_form_div').append(pay_data);
}
/**
 * 钱包支付
 * @param pay_data
 * @returns
 */
function process_pay_data_balance(data){
	
	var pay_data_str = data.pay_data;
	var pay_data = json2obj(pay_data_str);
	
	var payFlow = data.payFlow;
	var pay_state = pay_data.pay_state;
	
	
	if(pay_state == STATE_PAY_SUCCESS){
		document.forms["pay_success_back_form"].submit();
	}else{
		 alertMsg_warn("支付异常!");
	}
}

function create_tradeRecord(create_tradeRecord_data){
	$.ajax({
		type : "post",
		url : basePath+"tradeFront/create_tradeRecord.do",
		data : create_tradeRecord_data,
		dataType : "text",
		timeout:10*1000,
		async: false,
		success : function(msg) {
			var responseData = json2obj(msg);
			var statusCode = responseData.statusCode;
			
			if(responseData.statusCode != statusCode_ACCEPT_OK){
				//getInput("orderId").val(new Date().getTime());
				alertMsg_correct(responseData.message);
				return;
			}
				
			var data = responseData.data;
				
			var tradeRecord_id = data.tradeRecord_id;
			
			var price_fen_all_sum = parseInt_m(data.price_fen_all_sum);
			if(checkNotNull(price_fen_all_sum)){
				$('#waiting_pay_success_amount').html( chu(price_fen_all_sum,100) );
			}
				
			start_tradeRecord_paydata(tradeRecord_id);
	    },
	    error : function(){
	    	alertMsg_info("网络繁忙,请检查您的网络!");
		}
	});
	
}

var query_tradeRecord_current_interval = null;

function open_waite_weipay_success_window(){
	var pay_stand_html = $('#pay_stand').html();
	 //页面层
	  layer.open({  
	    type: 1 
	    ,content: pay_stand_html 
	    ,anim: 'down' 
		,shadeClose: false
		,style: 'width: 7.82629rem;border:none;margin-top: 1.2rem;border-radius:5px;'
	  });
	  jQuery('.layui-m-layersection').css("vertical-align","top");
	  
	  query_tradeRecord_current_interval =  setInterval(function(){
		  //定时查询状态
		  query_tradeRecord_current(function(msg){
				
				var responseData = json2obj(msg);
				var statusCode = responseData.statusCode;
				
				if(responseData.statusCode != statusCode_ACCEPT_OK){
					return;
				}
				
				document.forms["pay_success_back_form"].submit();
			});
	  }, 500);
}

function close_and_repay(){
	layer.closeAll();
	$('.create_tradeorder').css("background-color","#fe9700");
	clearInterval(query_tradeRecord_current_interval);
}
/**
 * 用户点击已完成支付按钮
 * @returns
 */
function user_click_pay_success(){
	
	if(payFlow == null){
		layer.open({
			content : "未找到亲的支付订单!",
			skin : 'msg',
			time : 2
		});
		return;
	}
	
	query_tradeRecord_current(function(msg){
		
		var responseData = json2obj(msg);
		var statusCode = responseData.statusCode;
		
		if(responseData.statusCode != statusCode_ACCEPT_OK){
			alertMsg_correct(responseData.message);
			return;
		}
		
		document.forms["pay_success_back_form"].submit();
		
	},function(){
		alertMsg_info("网络繁忙，请稍后再试!");
	});
	 
}

function query_tradeRecord_current(success_call_back,error_call_back){
	
	if(payFlow == null){
		return query_call_back(null);
	}
	
	var request_data = {
			payFlow:payFlow
	};
	
	ajax_post(basePath+"qierFront/query_tradeRecord.do",request_data,success_call_back,error_call_back);
}


function weipay_start(pay_data,call_back){
		
		if (typeof WeixinJSBridge == "undefined"){
	  	   if( document.addEventListener ){
	  	       document.addEventListener('WeixinJSBridgeReady', weipay_start, false);
	  	   }else if (document.attachEvent){
	  	       document.attachEvent('WeixinJSBridgeReady', weipay_start); 
	  	       document.attachEvent('onWeixinJSBridgeReady', weipay_start);
	  	   }
	  	}else{
	  		setTimeout(open_waite_weipay_success_window, 1000);
	  		WeixinJSBridge.invoke('getBrandWCPayRequest', pay_data,
	  	       function(res){     
	  	    	 	call_back(res);
	  	       }
	  	   ); 
	  	} 
}
 

function alertMsg_correct(message) {
	layer.open({
		content : message,
		skin : 'msg',
		time : 2
		// 2秒后自动关闭
	});
}
function alertMsg_warn(message) {
	layer.open({
		content : message,
		skin : 'msg',
		time : 2
		// 2秒后自动关闭
	});
}
function alertMsg_info(message) {
	layer.open({
		content : message,
		skin : 'msg',
		time : 2
		// 2秒后自动关闭
	});
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
 * 用户信息过期
 */
var statusCode_USER_INFO_TIMEOUT = 301;
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
var STATE_DONOT_HAS_FUNCTION = 206;
/**
 * 付款成功
 */
var STATE_PAY_SUCCESS = 207;  
/**
 * 等待退款
 */
var STATE_WAITE_REFUND = 208; 
/**
 * 退款失败
 */
var STATE_REFUND_FALSE = 2081; 
/**
 * 等待处理
 */
var STATE_WAITE_CHANGE = 209;
/**
 * 处理失败
 */
var STATE_WAITE_CHANGE_FLASE = 2091; 