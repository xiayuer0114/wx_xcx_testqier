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
function layer_loading(content){
	  //loading带文字
	  layer.open({
	    type: 2
	    ,content: content
	  });
}
function layer_loading(){
	  //loading带文字
	  layer.open({
	    type: 2
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