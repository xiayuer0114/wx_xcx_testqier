/**
 * 
 */

function shop_cart_clear(){
	clearShoppingCart();
}

function submit_shopcart_to_order(){
	var request_url = basePath +'self_order/event/submit_shopcart_to_order.jsp';
	
	var request_data = $('#submit_shopcart_to_order_form').serializeArray(); 
	
	ajax_post(request_url,request_data,function(message){
		
		var data_root = json2obj(message);                    				
		 
		var statusCode = data_root.statusCode;
		
		if(statusCode != statusCode_ACCEPT_OK){
			alertMsg_correct(data_root.message);
			return;
		} 
		
		document.forms["submit_shopcart_to_order_form"].submit();
	});
}

function add_to_shoppingCart_clicked(a_beclick){
	var count = $(a_beclick).attr("count");
	
	var jia_jian_div  = $(a_beclick).parent();
	
	var shop_cart_product_div  = jia_jian_div.parent().parent();;
	
	var product_id = jia_jian_div.attr("data");
	
	add_product_to_shoppingCart(product_id,count,function(data){
		
		$('.shuzi_'+data.product_bianhao).html(data.productItem_count);
		
		$('.cart_count').html(data.cartSize);
		$('.price_yuan_all').html(data.price_fen_all/100);
		
		if(data.productItem_count == "0" && shop_cart_product_div.hasClass("shop_cart_product")){
			shop_cart_product_div.remove();
		}
	});
}

function pop_shop_cart(){
	load_shop_cart();
	mui('#shop_cart').popover('show');
}
function load_shop_cart(){
	var request_url = basePath +'self_order/event/load_shopcart_product.jsp';
	ajax_get(request_url,function(msg){
		$('.shop_cart_scroll_content').html(msg);
	});
}
function load_product(pubConlumn_caipin_id_tmp){
	var request_url = basePath +'self_order/event/index_load_product.jsp?pubConlumn_caipin_id='+pubConlumn_caipin_id_tmp;
	ajax_get(request_url,function(msg){
		$('.index_product_content').html(msg);
	});
}
			function load_product_clicked(clicked_div){
				 var pubConlumn_caipin_id_tmp  = $(clicked_div).attr('data');
				 var fenlei_current = $('.fenlei_current');
				 
				 fenlei_current.removeClass('fenlei_current');
				 fenlei_current.addClass('fenlei');
				 
				 $(clicked_div).removeClass('fenlei');
				 $(clicked_div).addClass('fenlei_current');
				 
				 load_product(pubConlumn_caipin_id_tmp);
			}
			function clearShoppingCart(){
				
				var request_url = basePath +'tradeFront/clearShoppingCart.do';
				 
				
				ajax_get(request_url,function(message){
					
					var data_root = json2obj(message);                    				
					 
					var statusCode = data_root.statusCode;
					
					if(statusCode != statusCode_ACCEPT_OK){
						alertMsg_correct(data_root.message);
						return;
					}
					
					$('.add_to_cart_content > .shuzi').html("0");
					$('.cart_count').html("0");
					$('.price_yuan_all').html("0");
					
					$('.shop_cart_scroll_content').html("");
				});
			}
			function add_product_to_shoppingCart(productId,count,add_call_back){
				
				var request_url = basePath +'tradeFront/add_product_to_shoppingCart.do';
				
				var request_data = {
						productId:productId,
						count:count
				};
				
				ajax_post(request_url,request_data,function(message){
					
					var data_root = json2obj(message);                    				
					 
					var statusCode = data_root.statusCode;
					
					if(statusCode != statusCode_ACCEPT_OK){
						alertMsg_correct(data_root.message);
						return;
					}
					add_call_back(data_root.data);					
				});
			}

function alertMsg_correct(message) {
	alert(message);
}
function alertMsg_warn(message) {
	alert(message);
}
function alertMsg_info(message) {
	alert(message);
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