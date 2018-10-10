/**
 * 
 */
$(function(){

	$('.en2-13_15 img').bind('click',function(){
		
		$('.en2-13_15 img').each(function(){
			var src_str_tmp = $(this).attr("src");
			src_str_tmp = src_str_tmp.replace("-1.png",".png");
			$(this).attr("src",src_str_tmp);
		});
		
		var src_str = $(this).attr("src");
		
		if(src_str.indexOf("-1.png") == -1){
			src_str = src_str.replace(".png","-1.png");
			
			$('.btn_submit_next').attr("href",$('.btn_submit_next').attr("link"));
		}else{
			src_str = src_str.replace("-1.png",".png");
			$('.btn_submit_next').attr("href","");
		}
		//是不是选了灭绝
		if(src_str.indexOf("img/problem53") != -1){
			$('.Pop2_u_img').attr('src',basePath+'activities/qixi2018/img/guanzhu_miejue.jpeg');
		}else{
			$('.Pop2_u_img').attr('src',basePath+'activities/qixi2018/img/guanzhu_putong.jpeg');
		}
		 
		$(this).attr("src",src_str);
	});
	

	$('.btn_submit_next').bind('click',function(){
		
		var href = $(this).attr("href");
		
		if(checkNull(href)){
			alertMsg_correct("亲,选择一个再提交哦!");
			return;
		}
		
	});
}); 

function show_subscript(a_click){
	
	var is_select = false;
	
	$('.en2-13_15 img').each(function(){
		var src_str_tmp = $(this).attr("src");
		if(src_str_tmp.indexOf("-1.png") != -1){
			is_select = true;
		}
	});
	
	if(!is_select){
		alert("亲,选择一个再确认哦!"); 
		return;
	}
	
	  //页面层
	  layer.open({
	    type: 1
	    ,content: $('.Pop-ups_3').html()
	    ,anim: 'up'
	    ,style: 'position:fixed; bottom:25rem; left:0; width: 100%; height: 200px; padding:10px 0; border:none;'
	  }); 
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