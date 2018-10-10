// JavaScript Document
/**
 * 创建选中区域
 * author:hufeng
 */
(function($) {
    $.fn.selectRange = function(start, end) {
        return this.each(function() {
            if(this.setSelectionRange) {
                var self = this;
                //fix chrome issue
                window.setTimeout(function() {
                    self.setSelectionRange(start, end);
                }, 0);
            } else if(this.createTextRange) {
                var range = this.createTextRange();
                range.collapse(true);
                range.moveEnd('character', end);
                range.moveStart('character', start);
                range.select();
            }
        });
    };
})(jQuery||$);

$(document).ready(function(){
	//tab
	$(".tab").next().children().not(".showOne").hide();
	$(".tab li a").click(function() {
		$(this).parent().parent().children().removeClass("current");
		$(this).parent().addClass("current");
		var tabindex = ($(this).parent().parent().find("li a").index($(this)));
		var nextdiv = $(this).parent().parent().next();
		$(nextdiv.children()).hide();
		$(nextdiv.children().get(tabindex)).show();
	});
	//Êý¾Ý±í¸ñ-±í¸ñÑÕÉ«¿ØÖÆ
	$(".iconLink").prepend("<i></i>");//add icons
	$(".tablelist tr:even").addClass("even");
	$(".tablelist tr th:last-child").addClass("last");
	$(".tablelist tr td:last-child").addClass("last");
	$(".tablelist tr").hover(function() { 
		$(this).addClass("hover");
	},function(){
		$(this).removeClass("hover");
	});
	//Êý¾Ý±í¸ñ-¸´ºÏ¹¦ÄÜ²Ëµ¥
	$(".buttonDiv").hover(
	function(){$(this).children("a.buttonDiv-link").addClass("hovered");
				$(this).children("ul").show();},
	function(){$(this).children("a.buttonDiv-link").removeClass("hovered");
				$(this).children("ul").hide();}
	);	
	
	//æ•°æ®è¡¨æ ¼-å‘ç”¨æˆ·å‘é€æ¶ˆæ?
	$(".user_box").hover(
	function(){$(this).addClass("user_box_hovered").css("border-color","#ccc").children("ul").show();},
	function(){$(this).removeClass("user_box_hovered").css("border-color","#fff").children("ul").hide();}
	);
	//æ•°æ®è¡¨æ ¼ç­›é€?æ˜¾ç¤ºéšè—é«˜çº§ç­›é€‰é¡¹ç›?
	$(".adv-filiter-trigger").click(
	function(){
	$(this).toggleClass("opened");
	$(this).nextAll("dl.adv-filiter").slideToggle("fast");
	});	
	//ÐÅÏ¢¹¤¾ßÀ¸-ÏÔÊ¾Òþ²ØÍ³¼Æ
	$(".trigger_link").click(
	function(){
	$(this).toggleClass("opened");
	$(this).parent(".trigger-box").fadeOut();
	});	
	//²é¿´Í³¼Æ-Õ¹¿ª
 $(".trigger_box_link").click(function(){
	 $(".trigger-box").fadeIn().children("a.trigger_link").removeClass("opened");
	 });
	 //Õ¾µã¹ÜÀí-Í¼Æ¬²Ù×÷
	 $(".img_content").hover(
	function(){$(this).children("a").show();},
	function(){$(this).children("a").hide();}
	);

	//系统公告条目划上样式
			$(".system-announce-list li").hover(
				function(){$(this).addClass('hovered');},
				function(){$(this).removeClass('hovered');});
			//系统公告条目点击-展开内容
			$(".system-announce-list li>a").click(
				function(){
					$(".system-announce-list li div").hide();
					$(".system-announce-list li").removeClass("active");
					$(this).next('div').toggle('fast');
					$(this).parent("li").toggleClass("active");	
				}
				);
			//关闭系统公告详细信息
			$(".system-announce-list li div p a").click(function(){
				$(this).parents(".info-box").hide("fast");
				$(this).parents("li").removeClass("active");
			});

		//value select function
		$(".value-select-list li label").click(function(){
      $(".value-select-list li input[type='radio']").removeAttr("checked");
      $(".value-select-list li label").removeClass("selected");
      $(this).next("input[type='radio']").attr("checked","checked");
      $(this).addClass("selected");

      
    });
		//安全设置-展开-关闭帮助
      $("a.fn-help-link").click(function(){$("div.help-tip").toggle("fast");});
    $("div.help-tip a.fn-close").click(function(){$(this).parent("div").fadeOut();});
    $(".ui-pop-tip .ui-popTop a.right,.ui-pop-tip a.fn-close-tip").click(function(){$(".ui-pop-tip").fadeOut();});
    
    $(".itemTitle a i").click(function(){
			$(this).toggleClass("icon-chevron-up").toggleClass("icon-chevron-down");
			$(this).parents(".itemTitle").next(".itemBody").toggle("fast");
		});


    $("input[type='text'],input[type='password']").focus(function(){$(this).addClass("focused");});
			$("input[type='text'],input[type='password']").blur(function(){$(this).removeClass("focused");});

	//充值页面
	$("input[type='text']").focus(function(){
	  var len = $(this).val().length;
	  $(this).selectRange(0, len);
      $(this).addClass("focused");
    
    });
    $(".input-text-big").wrap("<span class='input-wrapper'></span>");
    $(".input-text-big").css({"margin-right":"1px"});
    $(".input-text-big").focus(function(){	
    	//$(this).parent("span").addClass("wrapper-active");
    	$(this).css({"border-width":"2px"});
    	$(this).parent("span").css({"border-width":"0px"});
    	$(".input-text-big").css({"margin-right":"0px"});
    });
    $(".input-text-big").blur(function(){
    	//$(this).parent("span").removeClass("wrapper-active");
    	$(this).css({"border-width":"1px"});
    	$(this).parent("span").css({"border-width":"1px"});
    	$(".input-text-big").css({"margin-right":"1px"});
    });

	$('.login_reg').click(function(e){
		if ( e && e.preventDefault ) {
			e.preventDefault();
		} else {
			// IE中阻止函数器默认动作的方式
			window.event.returnValue = false;
		}
		if($(this).text() && $(this).text() == "登录器下载"){
			if($('#downloadIframe').length <= 0){
				$('body').after('<iframe id="downloadIframe" name="downloadIframe" style="display: none"></iframe>')
			}

			$.when(function(){
				var deferred = $.Deferred();
				var params = {};
				params._t = new Date().getTime();
				$.ajax({
					url:"/site/getSiteUserId",
					type:'get',
					data: params,
					statusCode:{
					404:function(){
						$('#downloadIframe').attr('src',"http://download.1000.com/downloads/1000/1000.exe");
					}
				}}).done(function(resp) {
						(resp.result === "ok") ? deferred.resolveWith(this, [resp.data]) : deferred.rejectWith(this, [resp]);
					})
					.fail(function(resq) {
						deferred.rejectWith(this, [resq]);
					});
				return deferred.promise();
			}()).then(function(data){
				 if(data && data != '0'){
					 $('#downloadIframe').attr('src',"http://download.1000.com/salesclient/"+ data +".exe");
				 }else{
					 $('#downloadIframe').attr('src',"http://download.1000.com/downloads/1000/1000.exe");
				 }
			},function(){
				$('#downloadIframe').attr('src',"http://download.1000.com/downloads/1000/1000.exe");
			});
		}
		else{
			window.location.href = $(this).attr("href");
		}

	});
})

