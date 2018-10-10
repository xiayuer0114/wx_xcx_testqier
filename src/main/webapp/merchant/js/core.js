// JavaScript Document
$(document).ready(function(){
	//数据表格-表格颜色控制
	$(".tablelist tr:even").addClass("even");
	$(".tablelist tr th:last-child").addClass("last");
	$(".tablelist tr td:last-child").addClass("last");
	$(".tablelist tr").hover(function() { 
		$(this).addClass("hover");
	},function(){
		$(this).removeClass("hover");
	});
	//数据表格-复合功能菜单
	$(".buttonDiv").hover(
	function(){$(this).children("a.buttonDiv-link").addClass("hovered");
				$(this).children("ul").show();},
	function(){$(this).children("a.buttonDiv-link").removeClass("hovered");
				$(this).children("ul").hide();}
	);	
	
	
	
	
})