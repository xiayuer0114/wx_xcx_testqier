<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<!DOCTYPE html>
<html>
	<head>
		
	</head>
	 
<style type="text/css">
<!--设置DIV块的边界为5px-->
div{margin:25px;border:0;padding:0;}
#Box1{
    width:200px;
    height:72px;
    background-color:#666;
}
#Box2{
    width:200px;
    height:72px;
    background-color:#F0F;
}

</style>
	<script type="text/javascript">
		function submit_to_step3(){
			var lookResult_value = getRadioValue("lookResult");
			if(checkNull(lookResult_value)){
				alertMsg_info("请先选择!");
				return;
			}
			document.forms["form_3"].submit();
		}
	</script>
	<body> 
		<div style="margin: 0;padding: 0;" class="layui-container">
			 <img alt="" src="${basePath }activities/Notice/img/beijing.jpg" style="width: 100%;">
		</div> 
	<form action="${basePath }activities/Notice/step_2.jsp" method="post" name="form_3" >
		<input name="achievement" type="hidden" value="${achievement }" >
				<div class="layui-row">  
				   
				    <div class="layui-col-xs5">
				    
				         <div>
				             <h2>2018普通高等学校申报</h2>
				         </div>
				    
				          <div>
				      	    <input name="look" type="button" style="width:250px; height:40px; border-radius:10px;" value="佩 (SHE) 奇 (HUI)大学">
				      	 </div> 
				      	 
		                 <div>
				      	    <input name="look" type="button" style="width:250px; height:40px; border-radius:10px;" value="临沂市网络成瘾戒治中心">
				      	 </div> 
				      	 
				         <div>
				      	    <input name="look" type="button" style="width:250px; height:40px; border-radius:10px;" value="山东蓝翔学校">
				      	 </div> 
				      	 
				      	 <div>
				      	    <input name="look" type="button" style="width:250px; height:40px;border-radius:10px;" value="新东方烹饪学校">
				      	 </div> 
				      	 
				      	 <div>
				      	    <input name="look" type="button" style="width:250px; height:40px;border-radius:10px;" value="哈尔滨佛学院">
				      	 </div> 
				      	 
				      	 <div>
				      	    <input name="look" type="button" style="width:250px; height:40px;border-radius:10px;" value="北大青鸟学校">
				      	 </div> 
				      
				      <div >  
				      	 <div>
				      	    <input name="look" type="button" style="width:180px; height:40px;border-radius:10px;" value="提交我的志愿">
				      	 </div>  
				    </div>
				    
			   </div>
			</div>
		</form>
	</body>
</html>
