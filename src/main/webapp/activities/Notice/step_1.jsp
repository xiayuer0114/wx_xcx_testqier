<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String achievement = request.getParameter("achievement");//成绩
	request.setAttribute("achievement", achievement);
%>
<!DOCTYPE html>
<html>
	<head>
		
	</head> 
	<script type="text/javascript">
		function submit_to_step3(){
			var lookResult_value = getRadioValue("lookResult");
			if(checkNull(lookResult_value)){
				alertMsg_info("请先选择!");
				return;
			}
			document.forms["form_1"].submit();
		}
	</script>
	<body> 
		<div style="margin: 0;padding: 0;" class="layui-container">
			 <img alt="" src="${basePath }activities/Notice/img/beijing.jpg" style="width: 100%;">
		</div> 
	<form action="${basePath }activities/Notice/step_2.jsp" method="post" name="form_1" >
		<input name="achievement" type="hidden" value="${achievement }" >
				<div class="layui-row">  
				   
				    <div class="layui-col-xs5">
				    
				      <div>
				         <h2>2018高考成绩查询</h2>
				      </div>
				    
				      <div>
				         <input name="studentName" style="width:250px;hight:50px;border-radius:5px;" value="111" />
				      </div>
				    
				   	  <div class="layui-row">  
				      	<div class="layui-col-xs6 wenti_daan">少男</div>
				      	<div >
				      		<input name="lookResult" type="radio" value="少男" >
				      	</div>
				      	
				      </div>
				      
				      <div class="layui-row">  
				      	<div class="layui-col-xs6 wenti_daan">少女</div>
				      	<div >
				      		<input name="lookResult" type="radio" value="少女" >
				      	</div>
				      </div>
				      
				      <div >  
				      	<div class="layui-col-xs6 wenti_daan">文科</div>
				      	<div >
				      		<input name="lookResult" type="radio" value="文科" >
				      	</div>
				      </div>
				      
				      <div >  
				      	<div class="layui-col-xs6 wenti_daan">理科</div>
				      	<div>
				      		<input name="lookResult" type="radio" value="理科" >
				      	</div>
				      </div>
				      
				      <div >  
				      	 <div>
				      	    <input name="look" type="button" style="width:250px; height:40px; border-radius:10px;" value="查看我的成绩">
				      	 </div>  
				    </div>
				    
			   </div>
			</div>
		</form>
	</body>
</html>
