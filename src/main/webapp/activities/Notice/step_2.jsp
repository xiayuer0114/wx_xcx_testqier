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
			var information_value = getRadioValue("information");
			if(checkNull(information_value)){
				alertMsg_info("请先选择!");
				return;
			}
			document.forms["form_2"].submit();
		}
	</script>
	<body> 
		<div style="margin: 0;padding: 0;" class="layui-container">
			 <img alt="" src="${basePath }activities/Notice/img/beijing.jpg" style="width: 100%;">
		</div> 
	<form action="${basePath }activities/Notice/step_2.jsp" method="post" name="form_2" >
		<input name="achievement" type="hidden" value="${achievement }" >
				<div class="layui-row">  
				   
				    <div class="layui-col-xs5">
				    
				      <div>
				         <h4>2018普通高等学校招生考试</h4>
				      </div>
				      
				      <div>
				         <h4>成绩证书</h4>
				      </div>
				   	   
				      	<div >
				      		姓        名:  <input name="information" type="text" style="border-style:none" value=" 陈宁" ><br/>
				      	</div>
				   	   
				      	<div >
				      		考  生   证: <input name="information" type="text" style="border-style:none" value="20185001030112" ><br/>
				      	</div>
				      
				      	<div >
				      		报名序号: <input name="information" type="text" style="border-style:none" value="201822224242" ><br/>
				      	</div>
				      
				      	<div >
				      		身份证号: <input name="information" type="text"style="border-style:none" value="500103200105082128" ><br/>
				      	</div>
				    
				      
				      <table border="1" cellspacing="0">
				        <tr>
				           <th>科目</th>
				           <th>分数</th>
				        </tr>
				        <tr>
				           <td width="20%" align="center">语文</td>
				           <td width="20%" align="center">120</td>
				        </tr>
				      
	                     <tr>
				           <td width="20%" align="center">数学</td>
				           <td width="20%" align="center">120</td>
				        </tr>	
				         <tr>
				           <td width="20%" align="center">英语</td>
				           <td width="20%" align="center">120</td>
				        </tr>	
				         <tr>
				           <td width="20%" align="center">综合</td>
				           <td width="20%" align="center">220</td>
				        </tr>
				         <tr>
				           <td width="20%" align="center">总分</td>
				           <td width="20%" align="center">580</td>
				        </tr> 	      
				      </table>
				      <div>
				         <h5>(请妥善保管,遗失不补)</h5>
				      </div>
				      <div >  
				      	 <div>
				      	    <input name="look" type="button" style="width:200px; height:40px; border-radius:10px;" value="填报志愿">
				      	 </div>  
				    </div>
				    
			   </div>
			</div>
		</form>
	</body>
</html>
