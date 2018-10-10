	
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
		function layer_loading(){
			  //loading带文字
			  layer.open({
			    type: 2
			  });
		}
		function create_paymentrecord() {
			//var qingliang_price_yuan_value = 66.8;
			
			/* if(checkNull(qingliang_price_yuan_value)){
				alertMsg_correct("亲，请填写您的助捐金额哟！");
				return;
			}
			 */
			var requestFlow = new Date().getTime() + "";
			/* var qingliang_price_yuan_value_float = parseFloat_m(qingliang_price_yuan_value);
			var qingliang_price_fen = sheng(qingliang_price_yuan_value_float,100);
			 */
			
			 /* if(qingliang_price_fen <= 1 || qingliang_price_fen > 9900 ){
				alertMsg_correct("亲，助捐金需要在1-99之间！");
				return;
			} */

			var request_data = {
				requestFlow : requestFlow,
				price_fen : "6680",
				userId_merchant : userId_merchant,
			};
			
			layer_loading();

			$.post(basePath+"activities/dianjibaoming/event/create_pay_order.jsp",request_data, function(message) {

						var responseData = json2obj(message);
						var statusCode = responseData.statusCode;
						/*statusCode_ACCEPT_OK*/
						if (responseData.statusCode != 200) {
							alertMsg_correct(responseData.message);
							return;
						}

						var paymentRecord_id = responseData.paymentRecord_id;

						paymentRecord_start_pay(paymentRecord_id);
			});
		}

		function paymentRecord_start_pay(paymentRecord_id) { 
			var request_data = {
				paymentRecord_id : paymentRecord_id,
				pay_method:pay_method
			};

			$.ajax({
				type : "post",
				url : basePath + "payFront/create_paymentRecord.do",
				data : request_data,
				dataType : "text",
				timeout : 30 * 1000,
				async : false,
				success : function(msg) {
					var responseData = json2obj(msg);
					var statusCode = responseData.statusCode;
					
					if (responseData.statusCode != statusCode_ACCEPT_OK) {
						layer.closeAll();
						alertMsg_correct(responseData.message);
						return;
					}

					var data = responseData.data;

					var pay_data_str = data.pay_data;

					var pay_data = json2obj(pay_data_str);
					 
					process_pay_data_weipay(data);
				},
				error : function() {
					layer.closeAll();
					alertMsg_info("网络繁忙,请检查您的网络!");
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
				  layer.closeAll();
				  if(res.err_msg == "get_brand_wcpay_request:ok" ) {
					  alertMsg_warn("支付成功!");
					  //跳转页面
					  redirectPage(basePath+"activities/dianjibaoming/pay_success.jsp");
				  }else{
					  alertMsg_warn("支付失败!");
				  }
			}); 
			
		}
		
		
		function weipay_start(pay_data, call_back) {
			if (typeof WeixinJSBridge == "undefined") {
				if (document.addEventListener) {
					document.addEventListener('WeixinJSBridgeReady', weipay_start, false);
				} else if (document.attachEvent) {
					document.attachEvent('WeixinJSBridgeReady', weipay_start);
					document.attachEvent('onWeixinJSBridgeReady', weipay_start);
				}
			} else {
				WeixinJSBridge.invoke('getBrandWCPayRequest', pay_data, function(res) {
					call_back(res);
				});
			}
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
 * 方法不具备此功能 比如确认交易记录状态，这个通道没有这个方法 那么就确认一次 如果返回 这个状态 就不再轮巡刷新状态了
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

var  statusCode_ACCEPT_OK=200;