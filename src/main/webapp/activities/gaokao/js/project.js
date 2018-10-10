/**
 * 
 */
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
$(function(){
	
	$('.btn_to_step2').bind("click",function(){
		
		var sex_value = getRadioValue("sex");
		var kemu_value = getRadioValue("kemu");
		var user_name_value = $("#user_name").val();
		
		if(checkNull(user_name_value)){
			alertMsg_info("请先输入姓名!");
			return;
		}
		if(checkNull(sex_value)){
			alertMsg_info("请先选择性别!");
			return;
		}
		if(checkNull(kemu_value)){
			alertMsg_info("请先选择科目!");
			return;
		}
		
		document.forms["jump_to_step2_form"].submit();
	});
	
	$('.xuexiao_row img').bind("click",function(){
		 $('.xuexiao_row img').css('width','1.9rem');
		 $('.xuexiao_row img').css('margin-left','-0.95rem');
		 
		 $('#xuexiao').val($(this).attr('data'));
		 
		 $(this).css('width','2.2rem');
		 $(this).css('margin-left','-1.1rem');
	}); 
	
});