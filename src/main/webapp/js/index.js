var NUM = ''; // 输入的值

var keyboard = (function () {
    var keyboardElement = $('#keyboard'); // 键盘元素
    var buyBtn = $('#buy-btn');
    var mask = $('.mask1');  // 遮罩层
    var priceElement = null; // 价格输入框
    var inputElement = null; // 正在输入的输入框
    var cursor = null; // 输入时光标跳动
    var cursorState = null; // 控制光标跳动的变量
 
    /**
     * 监听键盘的点击事件
     */
    $('.key-item').on('click', function () {

        var dataValue = $(this).attr('data-value');
        
        var key_item_tmp =  $(this);
        
        var css_tmp = key_item_tmp.css("background-color");
        key_item_tmp.css("background-color","#999");
        setTimeout(function(){
        	key_item_tmp.css("background-color",css_tmp);
        }, 100);
        
        if(dataValue == '.'){
	         if (NUM.length >= 10) {
	                return;
	         } 
	         //已经有点了
	         if(NUM.indexOf(".") != -1){
	        	 return;
	         }
             NUM = NUM+".";
             $(priceElement).html(NUM);
             check_pay_num();
             return;
        }
        if(dataValue == 'done'){
        	check_pay_num();
        	 done();
             return;
        }
        if(dataValue == 'cancel'){
        	check_pay_num();
        	hidden();
            return;
        }
        if(dataValue == 'x'){
        	NUM = NUM.substring(0, NUM.length -1);
            $(priceElement).html(NUM);
            check_pay_num();
            return;
        }
        if (parseInt_m(dataValue) >= 0) {
            if (NUM.length >= 10) {
                return;
            }
            
            var dian_index = NUM.indexOf(".");
            
	         //已经有点了
	         if(dian_index != -1 ){
	        	 //两位小数
	        	 if(NUM.length-dian_index <= 2){
		        	 NUM += dataValue;
		             $(priceElement).html(NUM);
	        	 }
	        	 check_pay_num();
	        	 return; 
	         }else{
	        	 NUM += dataValue;
	             $(priceElement).html(NUM);
	             check_pay_num();
	             return;
	         }
        }
    });
    
    /**
     * 显示键盘
     * @param {Object<Element>} priceEle
     */
    function show(priceEle) {
        inputElement = priceEle;
        priceElement = priceEle.find('span')[1];
        cursor = priceEle.find('.cursor');
        mask.show();
        keyboardElement.css({
            'display': 'flex',
            'transform': 'translate3d(0px, 0px, 0px)',
            '-webkit-transform': 'translate3d(0px, 0px, 0px)'
        });
        cursorState = setInterval(function () {
            $(cursor).show();
            setTimeout(function () {
                $(cursor).hide();
            }, 500);
        }, 1000);
    }

    /**
     * 隐藏键盘
     */
    function hidden() {
        mask.hide();
        inputElement.removeClass('active');
        if (NUM > 0) {
            buyBtn.removeClass('unpay');
            buyBtn.addClass('payok');
        } else {
            buyBtn.removeClass('payok');
            buyBtn.addClass('unpay');
        }
        clearInterval(cursorState);
        keyboardElement.css({
            'transform': 'translate3d(0, 100%, 0)',
            '-webkit-transform': 'translate3d(0px, 100%, 0px)'
        });
    }

    /**
     * 点击完成
     * @return {string}
     */
    function done() {
        hidden();
    }

    /**
     * 点击输入框以外区域关闭键盘
     */
    mask.on('click', function () {
        keyboard.hidden();
    });
    return {
        show: show,
        hidden: hidden,
        value: NUM
    }
})();

var coupon = (function () {
    var couponElement = $('#coupon-mask');
    var mask = $('.mask2');  // 遮罩层

    function show() {
        mask.show();
        couponElement.css({
            'transform': 'translate3d(0px, 0px, 0px)',
            '-webkit-transform': 'translate3d(0px, 0px, 0px)'
        });
    }

    function hidden() {
        mask.hide();
        couponElement.css({
            'transform': 'translate3d(0, 100%, 0)',
            '-webkit-transform': 'translate3d(0px, 100%, 0px)'
        });
    }

    mask.on('click', function () {
        hidden();
    });

    return {
        show: show,
        hidden: hidden
    }
})();

// 买单弹框
var buyOrder = (function () {
    var buyBtn = $('#payment');
    var closeBtn = $('#close-buy-order');
    var mask = $('#mask3');
    var buyOrderElement = $('#buy-order');
    var priceElement = $('#pay-price');
    var payMoneyElement = $('.pay-money'); // 要买单的金额

    function show() {
        mask.show();
        buyOrderElement.css({
            'transform': 'translate3d(0px, 0px, 0px)',
            '-webkit-transform': 'translate3d(0px, 0px, 0px)'
        });
        priceElement.html(payMoneyElement.html());
    }

    function hidden() {
        mask.hide();
        buyOrderElement.css({
            'transform': 'translate3d(0, 100%, 0)',
            '-webkit-transform': 'translate3d(0px, 100%, 0px)'
        });
    }

    closeBtn.on('click', function () {
        hidden()
    });

    mask.on('click', function () {
        hidden();
    });

    return {
        show: show,
        hidden: hidden
    };
})();

$('.input-item_bind').on('click', function () {
    $(this).addClass('active');
    keyboard.show($(this));
});

$('#coupon_select_ok').on('click', function () {
	coupon.hidden();
});

$('#buy-btn').on('click', buy_btn_be_clicked);

function buy_btn_be_clicked(){
	
	 var payMoney= $('.pay-money').html();
	    
	    var payMoney_float = parseFloat_m(payMoney);
	     
	    if (isNaN(payMoney_float) || payMoney_float == null || payMoney_float <= 0) {
	    	alertMsg_warn('消费金额必需大于零!');
	        return;
	    }
	    
	    buyOrder.show();
	    
	    refresh_pay_money();
}

var pay_num_last = null;

function check_pay_num(){
	
	var pay_num_now = parseFloat_m(NUM);
	
	if(pay_num_last != pay_num_now){
		if(pay_num_now >= amount_to_reach_yuan){
			$('#merchantRedEnvelope_id').val(merchantRedEnvelope_id);
			$('#show_merchantRedEnvelope_font').show();
		}else{
			$('#merchantRedEnvelope_id').val("");
			$('#show_merchantRedEnvelope_font').hide();
		}
	}
	
    if (pay_num_now > 0) {
    	pay_num_last = pay_num_now;
    	
    	$('#buy-btn').removeClass('unpay');
    	$('#buy-btn').addClass('payok');
    } else {
    	$('#buy-btn').removeClass('payok');
    	$('#buy-btn').addClass('unpay');
    }
} 
 
$(function(){ 
    
    NUM = getInputValue("price_yuan"); // 输入的值
     
    check_pay_num();
    refresh_pay_money();
    
    if(checkNull(NUM)){
    	var input_item_tmp = $('.input-item_bind');
        $(input_item_tmp).addClass('active');
        keyboard.show($(input_item_tmp));
    }else{
    	$('#buy-btn').click();
    }
    
});