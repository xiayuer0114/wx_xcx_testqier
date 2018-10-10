<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.mongodb.BasicDBObject"%>
<%@page import="com.mongodb.BasicDBList"%>
<%@page import="com.lymava.qier.activities.model.WorldCupForecast"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>
<%

	WorldCupForecast worldCupForecast_find = new WorldCupForecast();
	
	worldCupForecast_find.setType(WorldCupForecast.type_32_to_16);
	worldCupForecast_find.setOpenid(openid_header);
	
	WorldCupForecast worldCupForecast = (WorldCupForecast)serializContext.get(worldCupForecast_find);
	
	if(worldCupForecast == null){
		 response.sendRedirect(MyUtil.getBasePath(request)+"activities/WorldCup/index.jsp");
		return;
	}
	
	BasicDBList basicDBList = worldCupForecast.getBasicDBList();

	Map<String,String> map_has = new HashMap<String,String>();
	
	for(Object basicDbObject_tmp:basicDBList){
		BasicDBObject basicDbObject = (BasicDBObject)basicDbObject_tmp;
		
		String group_name = (String)basicDbObject.get("group_name");
		String country_name = (String)basicDbObject.get("country_name");
		String country_image = (String)basicDbObject.get("country_image");
		
		String has_value = map_has.get(group_name);
		
		if(has_value == null){
			
			request.setAttribute(group_name+"1_name", country_name);
			request.setAttribute(group_name+"1_image", country_image);
			
			map_has.put(group_name, country_name);
		}else{
			
			request.setAttribute(group_name+"2_name", country_name);
			request.setAttribute(group_name+"2_image", country_image);
		}
	}
	
	request.setAttribute("worldCupForecast", worldCupForecast);
%>
<!DOCTYPE html>
<html style="font-size: 18px;">
<head> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport"
	content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no">
<meta name="format-detection" content="telephone=no">
<meta http-equiv="X-UA-Compatible" content="ie=edge">

<link rel="stylesheet" type="text/css"
	href="${basePath }layui-v2.2.5/layui/css/layui.css" />

<script type="text/javascript"
	src="${basePath }plugin/js/layer_mobile/layer.js"></script>
<script type="text/javascript"
	src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js"></script>
<script type="text/javascript"
	src="${basePath }plugin/js/lymava_common.js?r=2018-06-10"></script>
<script type="text/javascript">
	var basePath = '${basePath}';
</script>
<link rel="stylesheet"
	href="${basePath }plugin/js/layer_mobile/need/layer.css">
<script type="text/javascript"
	src="${basePath }plugin/js/layer_mobile/layer.js"></script>
<script type="text/javascript"
	src="${basePath }activities/WorldCup/js/project.js"></script>
<title>2018世界杯冠军之路</title>
<style>
* {
	margin: 0;
	padding: 0;
}
</style>
<link
	href="2/2_files/world_cup_way.655150927e698c71eee660af4ccd0180.css"
	rel="stylesheet">
<script type="text/javascript">
	$(function() {
		$('.team-icon img').bind("click", function() {
			 var img_src = $(this).attr("src");
			 
			 var team_icon_p = $(this).parent();
			 var country_name_span = $(this).next();
			 
			 var team_number_p = team_icon_p.prev();
			 var team_icon_p = $(this).parent();
			 var data_class = $(this).attr("data");
			 
			 if(img_src == null){
				 return img_src;
			 } 
			 
			 var country_name = $(this).attr("country_name");
			 if(checkNull(country_name)){
				 country_name = country_name_span.html();
			 } 
			 
			  
			 if("group_a_2" == data_class){
				 $('.final_res').html('<img country_name="'+country_name+'" data-v-5521cdf9="" src="'+img_src+'" alt="" class="champion-icon group_a_2">');
				 $('.champion-name').html(country_name);
			 }else{ 
				 $('.'+data_class).attr("src",img_src);
				 $('.'+data_class).attr("country_name",country_name);
			 }
			 
			 $('.'+data_class+"_input").remove();
			 
			 var image_input_html = '<input name="country_image" value="'+img_src+'" type="hidden" class="'+data_class+'_input" >';
			 var data_class_input_html = '<input name="data_class" value="'+data_class+'" type="hidden" class="'+data_class+'_input" >';
			 var country_name_input_html = '<input name="country_name" value="'+country_name+'" type="hidden" class="'+data_class+'_input" >';
			 
			 $('#16_form').append(data_class_input_html);
			 $('#16_form').append(country_name_input_html);
			 $('#16_form').append(image_input_html);
			 
			 check_can_submit();
		});  
	});
	function check_can_submit(){
		var team_icon_ok = true;
		$('.team-icon img').each(function(){
			var img_src = $(this).attr("src");
			if(checkNull(img_src)){
				team_icon_ok = false;
			}
		});
		
		var final_name = $('.champion-name').html();
		
		if(team_icon_ok && checkNotNull(final_name)){
			$('.submit_ok').show();
			$('.gray').hide(); 
		}else{
			$('.submit_ok').hide();
			$('.gray').show();
		}
		 
	}
	function submit_32_to_16(){
		
		ajaxForm("16_form",function(){
			
		},function(msg){
			var res = json2obj(msg);
			
			if(res.statusCode != "200"){
				alertMsg_warn(res.message);
				return;
			}
			 
			document.forms["guanzhu_form"].submit();
		});
		
	}
</script>
</head>
<body>
	<form name="guanzhu_form" action="${basePath }activities/WorldCup/guanzhu.jsp" >
	</form> 
	<form name="16_form" action="${basePath }activities/WorldCup/event/save_16.jsp" id="16_form">
	</form> 
	<div id="main">
		<div data-v-5521cdf9="" id="part2">
			<div data-v-5521cdf9="" class="hint-flap" style="display: none;">
				<span data-v-5521cdf9=""> <img data-v-5521cdf9=""
					src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAewAAADECAMAAABqfOK9AAAAkFBMVEUAAAD///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////+WABnwAAAAL3RSTlMARLt37hEzIs1mmd2IeqpVnPGzvIXoJm8U9tUcBOIJja86YCzCgcellk5JDdpaJD+0TckAAA6/SURBVHjaxJvtmqMgDIUJ4VsevRTu/+72KVCPFFHr2t3zY1qnDoS8JEDsiE8RM1txVYaItLgiTYefLhzkIp5QKOabmY96jDIyrlhKNuLfyTLL6ZsOZfiJfZxSInGoKKV8G3F4t5/t2qyaxL7Q0CQekE4phfNxqJQSrsLezYZOZFZyx6LeyCmlJEdeY6jG3ZIHdcu++7AB5hA2hqQY3vSHc13lO56ZrLMQwqWkxFC6dfbUoMfYDoQGKJ2IRSdKcNxhvwQ337DvH8JmdEh94HrZ6AVbyVZ34E9l0tjMfKilYWBh6G9hQ/MYRg+bcm9vmSdhd+J7sE01Fgy6jm54aSh4XtXWI30It8WUksG8Q1//CraFc85hu7QV3YBNWE5+ALuaGLb+nPQvYcMghn9aNfE/tWFmdpuioTawYWkzQHw4XG6OEydV53Iawl4Da6GPvlvYDHc+DBvBo3TzR7FN46fytwI72ZxVhrCJyL/mYWZm6wKuaCONYQ61C5uTjPYabJ0tPYfdJnFVpiXuw/vpJuzAjegabF2tQCinBdcG1z+UrNkkHMDuJrJPH6LvYWOx0mPYx0l3ANu8ALtmc9FhWJpFy/awaQybxsv5GLaZnICyiaGLdCNa2cPjys3ALk5R3AhZs4Mtr8MG6D3YHmN+DLZRq51wN+6DsyEewKbHYHuVUmxZO93kLYdlG0Y8tVxjmxBrYHO3W+R92L0NtJ5jx7BxjtXvYBKuzcz48D7sUDkqi+PN5j549h/C1nPuxoI1wribAD+DzamkUZtfux2EBSrOKv2EZuGSo/2u/EzhkKzC6XGrjX0DRaD4hD3nHFUct2ToHWwzYUQ8n8PWtCoHBW10BbZXefYtQ9bocTKfv3LyQ+4mbJutEBVfsaRu87RKyQEV491nCYDHsC0VZaPPIhYSp4pdxGZwua43vxz5QhiMguXA8Pa9WT0/6WPYlMbah00vmfpWFm9oUeTBupWvUwIi2ADRDdg4jmLlRlPZdN6FnYfgL8Hm1Iofgg17+15JzzrXIotm0cKuKfU9DYzKju9h67+AXSXz22KI8u92A2baLu0U9U9gx5SFlXsL28GdLWxGYHewPW/kfwO7kuSjosp6lHS6g50Hm39Ky6g5AzZM1A/AbgFahWTdy5dP7eNrNg5QpYimP+eNJTGETdf3LGMb4/dWo6TjxAFs/NL0J2Cj1FL3TMib+7A3Pg/Uy12EHWybTKWhkXAkexQ2jh9CGJl4nCT6NB4/iQ5m6s6aDaGk5lG/viIGxd7KKnJA+blmL8WMStuLc9gD98oh7JLZ8lsF1DXjxHEtlLRMTvwAdngReNu7ZB9gYNrPNIKtX7mR20EOpeHIVlrlnTJyw1V5jHYEWwf4RZo9OBSnVOW8fg72ebmUF3EAWwivt8fQgeyNLO40LNMpueU9MN1kE2Sx96jJ4eOIsip/SJBMdgDbIaquw0bx6QC25lpWofIaTANHE0tV82slLtn8HDZ0CPtH0kmVwwECZoUtHFbxnQqaTiCFJvoxvKJX7sMOQHYC+7z2YIjMCtvGQtIZIbRE8FZLsaRObIXw70uls40NSfUr2MTrSVE29Qp7+cHX13ncwLKyhOl1YB40O9jVDmVOYZcZBNgta4VhNk8XLrKGZG69qe6p2oqvsRtXS335PHiuB+2oyrB62PJx2H2AL+3f/ww2LKvB6jCwfLkPGxtifQa7PlzqYetb40BBYgBb1pmTgl574mk1VVaTXKS8+kz1gdsSJyfGsMe78duw8bHG1Tewp7uw8XUEwM6hZ3fXbBx144eRttYTPXGpKpbm/E5ky1uwOYF1D7toccp52iq4ZDaWWp0Bpyw8FD6EPdB92IivMWxLvaKC1fdhzxkuYC/jChqKFjRKZrR9EjbtwOYbsHWoa/EhbLJadgeaHXeauh+f/P+CzV1pSImhkKVUgAfuwbZ1lmF9GtfGYeqkO9ihgZ3fhR42dH2DZhxKYkew+7RBg9hZ8o28Dzs8C5sc250v/9nmUooDUcBe8z5szDLARh4fwRauXmBwiGTAFmzFI7A5YTHehQ3bzmFbUV9DcoM0zjgtaBrrGmz4FVqaDs98ZBHUfwUbswxGIY8PYZta421hl8MWNfgegE0Ou8MrsB1VhT3YlJTkktytObfRjs0S38CmLrB966MZXfIqHNOmyI3sPdhL7gmwa+fuCLaIQbeDq8tB7Iam4UgESv+QGNICMvQKQDw/uARbjp7JbUPfxeXShJSTbxHzUl6nZMawjQfs1g4sg8OHWZTOhPZslNFehV1fFvSJg/cQ9mBjUc/ngG0CM5evzS728kAIo55SmhQeHT0B2zr0NLPdh73Ms4e9UQjDslTaVaW05F3LLmy9hCnJT9haHHzD0N+FrfNx1F6Ejf9IAGxwuwJbNvszA9ibE/Vrnjv/LWzf1bjPYOsT2EXEs0pVjjVg71TgpzIm8675xTcmh8w7fupFu5tDo9Adqs70NWxsZi7DloVrC9uuTYwfuMBJyOJTu0JN64Nll9u7DhunYZh3Alv7OZ3AhgxXLqqFDbMV/k0HEQ3qmdjSPP3j4NIebK2a1knVbtsOxUjg0gqw3VXYtgyjbbTUxy/DRs01trBZvsQaacEy1JRLIbt51D9lv8/6Aux85zlsSPtZZXIdbFVg1yxJ21IEHhwwkJlFpkYqEL76r0N5Ny4OeQD7ErZNWRdh5zH7vtGYJn8O2yCXlcHb2soiWvn+dz2Q3jqnq2/YHsGmP+ybWa7DIAxFKWYICTJLYf+7exIVudAMr5byV5+vqlUHepBjOybXhkh2I3E4kZ17bOR9fTTeGUj7J3J/AFpDtn0IwOKjPbomjMtJZZuyCWRfHeCLxZxPlx7mnQk6Ua3zJCe0tnaUyMZwaKqNhWlitbmHILDc19n2kiYbZNeKeprH83je37FLzKPo4mEION+9wnXGuZXLf6fd0vN8uxlc3WSyg81EGMoC13W2s8uwZwnXjlDBJEIke0Oy6Cq4OZ6yUDQ3suWnOONHj23rMd7NBRS9a0Nu1TtYB9dIijBrmr8YP1lu8haoYJnsWDvhUvZ0nMzNDuNYAmz1jCSR3SxatLrArDHsqprpR2QDwhbFkYZ13+B+e5eExa7wPJDYvqF41hIvFWRzDiE03AzlJZFsCLIGQPER7q59l4MLUTix7ciIZHsen/Zpta5+sP/ubS1+atki+ROH8ZkX7rywY2rfQht3eckVI4THSanOdUYS/q09U4suMtlke+L8HS8itpaw2LyE4dUD8nZpYfMFtKZogCxBA5Atwj/8DjkJS3yc55cRW4NUkYPml/ITeOeKUX4EjYqKoiiKoiiKoih/7MGBAAAAAACQ/2sjqKqqqqqqqgo797abOBAEAbTYQMyyYALEgDH3mwkQ9f//3TKDIj/EkYLpSD2kzjtPJcqttmeIiIiIiIiIiIhuMV/nzaT3bcm5v45AQeo25Wb1xRgUnFNLKjmvQIHZNKWiXg0UlFVPKkufQQF5rsvVv2Wr9fJNh2Ui3pnP7YBkM/GSUQO3GObixaBQnJribSPcqiPeGhSIWLxBA7dri1PPQEEYibedo4LpXpwlKARRWlyLXMHm+vMOKACxOEmEip7ESYcg82ridVHZVpwtyLxrVH04dxX5E8i4lThphDusxUk3INticXa4y1KcPci0SJykgbtkdRZ5AHYaf2zgXTy+ETFt4p+2GQAW+aNbaa2/xglXK9a9ivOG+3XF40Ru10Au6mO9sX4/BdmU+fLNAagV+SvIppU4I6jociI3bS1OTXU/02SR29SRiySDjsZMnDbIopZcTKYAi/zxxcqbkFycyRxkT18uBnA4kT+6P8WrbNUi54kggwbaYeOFRW6VftjjGYvcKP2w8cYiN6oIW30i52rFGvWwi9XKAmTLR9gs8l+gCJsT+cP7mbDHLHKL9MP2jixyg4qwdbVY5Pb8VNgnFrk9RdjKjvz80ByVsKfH7Ksiz0FmqISNQ4xP5me5SHn7hh06Ye/K5u6/4nRBVuiE3Sn7yHA+44hmi1bYssMnS96rY4tS2KUfGS540s8WpbBLU20zbFuUwi49v5mzxm1RDDsdlp38PoCsUAxbtmU3br2DrPjf3p0tpwpEURhuo0QSJ1AJIJNj4hCz3v/tDrQxCuU5Vk5xgbvXd+vlX2BXA73rjA1fXXvnpkrD1BobO3Wx5XZp09Qb+3IQdbrlV1+NU3NsbPdRqtTqxQa4PGuaWmNrib1+DwEeudE8tcauSnhOcaPUGLvXQ9mEw/yapcbY88DBlZBHWzZNjbGflGo9edDcdcYXkhqn1ti57sjfZO0lSzdRJfZ+PByOncN/xqZmq8RuIxcGjC1SJbaPnMfYMjG2QRjbIPdij+aO8zFNGVuCe7Ez5BKLsSW4F7uP3IyxRXj6bezDcZn7YuwHNERu8ovYbygMGPsBbXXMuBzb+lfsDnIbxn5Apy2zReXKvht7ytgPaIFCVord6TK2SFaCnBtdxw6fGVumDDpUXBoZwtgyRSEKk0jl0jkKO8YWagqtN9212ja0JWMLFa9RtanE9iLGFiKwUfFUiR1+MbYU0Rpl4apyk18xthjxwEXJXJ1l1RXbF2M/uq4/+ezAtV+PCQrtc9oZCs5VbJexH1+8aq30paz1Y5XbJdBcS52twNhiWB602db3hzj7UGd9xhZkj1va6mQJxpbkiFucKP8pHYCxZTm6uLB9D5o3H2SfYGxpnsf45vUt5eOCsQVq9ddJOHNO75pljC1cfAhS9c1nbIMs5vjmOdxBE2+xmdu99dCPLI+xjdHldqk5+NTLIIxtEMY2CGMbhLENwtgGYWyDMLZBGNsgjG0QxjYIYxuEsQ3C2AZhbIO8uX+LPVEkTHRr3v2G83RFOtg3pi46yDmKpJkg10vVlTQ53dpJmvIX29oIhZYiaVoozFL1I7aR8ziKUZ5TWjjV4cmZInmO0JxAaV0HnIouVryG9ukvgmCx6UDbKJIo8nASJkmIkzH/sYXau6iwA0VCrWYoGR8UiWW9hviR+IpEW2xtaPaU63D50uf9iz9qpeq+PzMHN4sN1OQVAAAAAElFTkSuQmCC"
					alt="">
				</span>
			</div>
			<p data-v-5521cdf9="" class="team-people-num">
				<img src="2/2_files/3.jpg" />
			</p> 
			<div data-v-5521cdf9="" class="content layui-col-xs12">
				<div data-v-5521cdf9="" class="grounp-8-left">
					<div data-v-5521cdf9="" class="grounp-8">
						<div data-v-5521cdf9="" class="team-16">
							<div data-v-5521cdf9="" class="team">
								<p data-v-5521cdf9="" class="team-number">A1</p>
								<p data-v-5521cdf9="" class="team-icon">
									<img data="group_a_16" data-v-5521cdf9=""
										src="${A1_image }" alt="">
									<span data-v-5521cdf9="" class="">${A1_name }</span>
								</p>
								<p data-v-5521cdf9="" class="link-down"></p>
							</div>
							<p data-v-5521cdf9="" class="link-row"></p>
						</div>
						<div data-v-5521cdf9="" class="team-16">
							<div data-v-5521cdf9="" class="team">
								<p data-v-5521cdf9="" class="team-number">B2</p>
								<p data-v-5521cdf9="" class="team-icon">
									<img data="group_a_16" data-v-5521cdf9=""
										src="${B2_image }" alt="">
									<span data-v-5521cdf9="" class="">${B2_name }</span>
								</p>
								<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								<p data-v-5521cdf9="" class="link-up"></p>
							</div>
							<p data-v-5521cdf9="" class="link-row"></p>
						</div>
					</div>
					<div data-v-5521cdf9="" class="grounp-8">
						<!---->
						<div data-v-5521cdf9="" class="team-16">
							<div data-v-5521cdf9="" class="team">
								<p data-v-5521cdf9="" class="team-number">C1</p>
								<p data-v-5521cdf9="" class="team-icon">
									<img data="group_c_16" data-v-5521cdf9=""
										src="${C1_image }" alt="">
									<span data-v-5521cdf9="" class="">${C1_name }</span>
								</p>
								<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								<p data-v-5521cdf9="" class="link-down"></p>
							</div>
							<p data-v-5521cdf9="" class="link-row"></p>
						</div>
						<div data-v-5521cdf9="" class="team-16">
							<div data-v-5521cdf9="" class="team">
								<p data-v-5521cdf9="" class="team-number">D2</p>
								<p data-v-5521cdf9="" class="team-icon">
									<img data="group_c_16"  data-v-5521cdf9=""
										src="${D2_image }" alt="">
									<span data-v-5521cdf9="" class="">${D2_name }</span>
								</p>
								<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								<p data-v-5521cdf9="" class="link-up"></p>
							</div>
							<p data-v-5521cdf9="" class="link-row"></p>
						</div>
					</div>
					<div data-v-5521cdf9="" class="grounp-8">
						<!---->
						<div data-v-5521cdf9="" class="team-16">
							<div data-v-5521cdf9="" class="team">
								<p data-v-5521cdf9="" class="team-number">E1</p>
								<p data-v-5521cdf9="" class="team-icon">
									<img data="group_e_16"  data-v-5521cdf9=""
										src="${E1_image }" alt="">
									<span data-v-5521cdf9="" class="">${E1_name }</span>
								</p>
								<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								<p data-v-5521cdf9="" class="link-down"></p>
							</div>
							<p data-v-5521cdf9="" class="link-row"></p>
						</div>
						<div data-v-5521cdf9="" class="team-16">
							<div data-v-5521cdf9="" class="team">
								<p data-v-5521cdf9="" class="team-number">F2</p>
								<p data-v-5521cdf9="" class="team-icon">
									<img data="group_e_16"  data-v-5521cdf9=""
										src="${F2_image }" alt="">
									<span data-v-5521cdf9="" class="">${F2_name }</span>
								</p>
								<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								<p data-v-5521cdf9="" class="link-up"></p>
							</div>
							<p data-v-5521cdf9="" class="link-row"></p>
						</div>
					</div>
					<div data-v-5521cdf9="" class="grounp-8">
						<!---->
						<div data-v-5521cdf9="" class="team-16">
							<div data-v-5521cdf9="" class="team">
								<p data-v-5521cdf9="" class="team-number">G1</p>
								<p data-v-5521cdf9="" class="team-icon">
									<img data="group_g_16"  data-v-5521cdf9=""
										src="${G1_image }" alt="">
									<span data-v-5521cdf9="" class="">${G1_name }</span>
								</p>
								<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								<p data-v-5521cdf9="" class="link-down"></p>
							</div>
							<p data-v-5521cdf9="" class="link-row"></p>
						</div>
						<div data-v-5521cdf9="" class="team-16">
							<div data-v-5521cdf9="" class="team">
								<p data-v-5521cdf9="" class="team-number">H2</p>
								<p data-v-5521cdf9="" class="team-icon">
									<img data="group_g_16"  data-v-5521cdf9=""
										src="${H2_image }" alt="">
									<span data-v-5521cdf9="" class="">${H2_name }</span>
								</p>
								<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								<p data-v-5521cdf9="" class="link-up"></p>
							</div>
							<p data-v-5521cdf9="" class="link-row"></p>
						</div>
					</div>
				</div>
				<div data-v-5521cdf9="" class="grounp-4-left">
					<div data-v-5521cdf9="" class="grounp-4">
						<div data-v-5521cdf9="" class="team-8">
							<div data-v-5521cdf9="">
								<div data-v-5521cdf9="" class="team-icon">
									<img data="group_a_8" class="group_a_16" data-v-5521cdf9="" alt="">
									<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								</div>
								<p data-v-5521cdf9="" class="link-down"></p>
							</div>
						</div>
						<div data-v-5521cdf9="" class="team-8">
							<div data-v-5521cdf9="">
								<div data-v-5521cdf9="" class="team-icon">
									<img data="group_a_8" class="group_c_16" data-v-5521cdf9="" alt="">
									<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								</div>
								<p data-v-5521cdf9="" class="link-up"></p>
							</div>
						</div>
						<p data-v-5521cdf9="" class="link-row"></p>
					</div>
					<div data-v-5521cdf9="" class="grounp-4">
						<div data-v-5521cdf9="" class="team-8">
							<div data-v-5521cdf9="">
								<div data-v-5521cdf9="" class="team-icon">
									<img data="group_e_8" class="group_e_16" data-v-5521cdf9="" alt="">
									<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								</div>
								<p data-v-5521cdf9="" class="link-down"></p>
							</div>
						</div>
						<div data-v-5521cdf9="" class="team-8">
							<div data-v-5521cdf9="">
								<div data-v-5521cdf9="" class="team-icon">
									<img data="group_e_8" class="group_g_16" data-v-5521cdf9="" alt="">
									<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								</div>
								<p data-v-5521cdf9="" class="link-up"></p>
							</div>
						</div>
						<p data-v-5521cdf9="" class="link-row"></p>
					</div>
				</div>
				<div data-v-5521cdf9="" class="grounp-2-left">
					<div data-v-5521cdf9="">
						<div data-v-5521cdf9="" class="grounp-2">
							<div data-v-5521cdf9="" class="team-icon">
								<div data-v-5521cdf9="">
									<img data="group_a_4"  class="group_a_8" data-v-5521cdf9="" alt="">
									<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								</div>
							</div>
							<p data-v-5521cdf9="" class="link-down"></p>
						</div>
						<div data-v-5521cdf9="" class="grounp-2">
							<div data-v-5521cdf9="" class="team-icon">
								<div data-v-5521cdf9="">
									<img data="group_a_4"  class="group_e_8" data-v-5521cdf9="" alt="">
									<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								</div>
							</div>
							<p data-v-5521cdf9="" class="link-up"></p>
						</div>
						<p data-v-5521cdf9="" class="link-row"></p>
					</div>
				</div>
				<div data-v-5521cdf9="" class="grounp-1-center" style="position: absolute;left: 50%;margin-left: -2rem;">
					<img data-v-5521cdf9="" src="2/2_files/cup.6f2339f.png" alt=""
						class="cup">
					<div data-v-5521cdf9="" class="link-row"></div>
					<div data-v-5521cdf9="" class="grounp-1">
						<!---->
						<div data-v-5521cdf9="" class="team-icon">
							<img data="group_a_2" class="group_a_4" data-v-5521cdf9="" alt="">
							<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
						</div>
						<p data-v-5521cdf9="" class="line-right"></p>
					</div>
					<div data-v-5521cdf9="" class="grounp-1">
						<p data-v-5521cdf9="" class="line-left"></p>
						<div data-v-5521cdf9="" class="team-icon">
							<img data="group_a_2" class="group_b_4" data-v-5521cdf9="" alt="">
							<div data-v-5521cdf9="" class="screen" style="display: none;">
							</div>
						</div>
						<!---->
					</div>
					<div data-v-5521cdf9="" class="champion">
						<div data-v-5521cdf9="" class="icon-box final_res" >
							<div data-v-5521cdf9="" class="screen"></div>
						</div>
						<p data-v-5521cdf9="" class="champion-name"></p>
						<img data-v-5521cdf9="" src="2/2_files/1.png" alt=""
							class="champion-logo">
					</div>
				</div>
				<div data-v-5521cdf9="" class="grounp-8-right">
					<div data-v-5521cdf9="" class="grounp-8">
						<div data-v-5521cdf9="" class="team-16">
							<div data-v-5521cdf9="" class="team">
								<p data-v-5521cdf9="" class="team-number">B1</p>
								<p data-v-5521cdf9="" class="team-icon">
									<img data="group_b_16" data-v-5521cdf9=""
										src="${B1_image }" alt="">
									<span data-v-5521cdf9="" class="">${B1_name }</span>
								</p>
								<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								<p data-v-5521cdf9="" class="link-down"></p>
							</div>
							<p data-v-5521cdf9="" class="link-row"></p>
						</div>
						<div data-v-5521cdf9="" class="team-16">
							<div data-v-5521cdf9="" class="team">
								<p data-v-5521cdf9="" class="team-number">A2</p>
								<p data-v-5521cdf9="" class="team-icon">
									<img data="group_b_16" data-v-5521cdf9=""
										src="${A2_image }" alt="">
									<span data-v-5521cdf9="" class="">${A2_name }</span>
								</p>
								<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								<p data-v-5521cdf9="" class="link-up"></p>
							</div>
							<p data-v-5521cdf9="" class="link-row"></p>
						</div>
					</div>
					<div data-v-5521cdf9="" class="grounp-8">
						<div data-v-5521cdf9="" class="team-16">
							<div data-v-5521cdf9="" class="team">
								<p data-v-5521cdf9="" class="team-number">D1</p>
								<p data-v-5521cdf9="" class="team-icon">
									<img data="group_d_16" data-v-5521cdf9=""
										src="${D1_image }" alt="">
									<span data-v-5521cdf9="" class="">${D1_name }</span>
								</p>
								<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								<p data-v-5521cdf9="" class="link-down"></p>
							</div>
							<p data-v-5521cdf9="" class="link-row"></p>
						</div>
						<div data-v-5521cdf9="" class="team-16">
							<div data-v-5521cdf9="" class="team">
								<p data-v-5521cdf9="" class="team-number">C2</p>
								<p data-v-5521cdf9="" class="team-icon">
									<img data="group_d_16" data-v-5521cdf9=""
										src="${C2_image }" alt="">
									<span data-v-5521cdf9="" class="">${C2_name }</span>
								</p>
								<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								<p data-v-5521cdf9="" class="link-up"></p>
							</div>
							<p data-v-5521cdf9="" class="link-row"></p>
						</div>
					</div>
					<div data-v-5521cdf9="" class="grounp-8">
						<div data-v-5521cdf9="" class="team-16">
							<div data-v-5521cdf9="" class="team">
								<p data-v-5521cdf9="" class="team-number">F1</p>
								<p data-v-5521cdf9="" class="team-icon">
									<img data="group_f_16" data-v-5521cdf9=""
										src="${F1_image }" alt="">
									<span data-v-5521cdf9="" class="">${F1_name }</span>
								</p>
								<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								<p data-v-5521cdf9="" class="link-down"></p>
							</div>
							<p data-v-5521cdf9="" class="link-row"></p>
						</div>
						<div data-v-5521cdf9="" class="team-16">
							<div data-v-5521cdf9="" class="team">
								<p data-v-5521cdf9="" class="team-number">E2</p>
								<p data-v-5521cdf9="" class="team-icon">
									<img data="group_f_16" data-v-5521cdf9=""
										src="${E2_image }" alt="">
									<span data-v-5521cdf9="" class="">${E2_name }</span>
								</p>
								<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								<p data-v-5521cdf9="" class="link-up"></p>
							</div>
							<p data-v-5521cdf9="" class="link-row"></p>
						</div>
					</div>
					<div data-v-5521cdf9="" class="grounp-8">
						<div data-v-5521cdf9="" class="team-16">
							<div data-v-5521cdf9="" class="team">
								<p data-v-5521cdf9="" class="team-number">H1</p>
								<p data-v-5521cdf9="" class="team-icon">
									<img data="group_h_16" data-v-5521cdf9=""
										src="${H1_image }" alt="">
									<span data-v-5521cdf9="" class="">${H1_name }</span>
								</p>
								<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								<p data-v-5521cdf9="" class="link-down"></p>
							</div>
							<p data-v-5521cdf9="" class="link-row"></p>
						</div>
						<div data-v-5521cdf9="" class="team-16">
							<div data-v-5521cdf9="" class="team">
								<p data-v-5521cdf9="" class="team-number">G2</p>
								<p data-v-5521cdf9="" class="team-icon">
									<img data="group_h_16" data-v-5521cdf9=""
										src="${G2_image }" alt="">
									<span data-v-5521cdf9="" class="">${G2_name }</span>
								</p>
								<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								<p data-v-5521cdf9="" class="link-up"></p>
							</div>
							<p data-v-5521cdf9="" class="link-row"></p>
						</div>
					</div>
				</div>
				<div data-v-5521cdf9="" class="grounp-4-right">
					<div data-v-5521cdf9="" class="grounp-4">
						<div data-v-5521cdf9="" class="team-8">
							<div data-v-5521cdf9="">
								<div data-v-5521cdf9="" class="team-icon">
									<img data="group_b_8" class="group_b_16" data-v-5521cdf9="" alt="">
									<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								</div>
								<p data-v-5521cdf9="" class="link-down"></p>
							</div>
						</div>
						<div data-v-5521cdf9="" class="team-8">
							<div data-v-5521cdf9="">
								<div data-v-5521cdf9="" class="team-icon">
									<img data="group_b_8" class="group_d_16" data-v-5521cdf9="" alt="">
									<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								</div>
								<p data-v-5521cdf9="" class="link-up"></p>
							</div>
						</div>
						<p data-v-5521cdf9="" class="link-row"></p>
					</div>
					<div data-v-5521cdf9="" class="grounp-4">
						<div data-v-5521cdf9="" class="team-8">
							<div data-v-5521cdf9="">
								<div data-v-5521cdf9="" class="team-icon">
									<img data="group_f_8" class="group_f_16" data-v-5521cdf9="" alt="">
									<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								</div>
								<p data-v-5521cdf9="" class="link-down"></p>
							</div>
						</div>
						<div data-v-5521cdf9="" class="team-8">
							<div data-v-5521cdf9=""> 
								<div data-v-5521cdf9="" class="team-icon">
									<img data="group_f_8" class="group_h_16" data-v-5521cdf9="" alt="">
									<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								</div>
								<p data-v-5521cdf9="" class="link-up"></p>
							</div>
						</div>
						<p data-v-5521cdf9="" class="link-row"></p>
					</div>
				</div>
				<div data-v-5521cdf9="" class="grounp-2-right">
					<div data-v-5521cdf9="">
						<div data-v-5521cdf9="" class="grounp-2">
							<div data-v-5521cdf9="" class="team-icon">
								<div data-v-5521cdf9="">
									<img data="group_b_4" class="group_b_8" data-v-5521cdf9="" alt="">
									<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								</div>
							</div>
							<p data-v-5521cdf9="" class="link-down"></p>
						</div>
						<div data-v-5521cdf9="" class="grounp-2">
							<div data-v-5521cdf9="" class="team-icon">
								<div data-v-5521cdf9="">
									<img data="group_b_4" class="group_f_8" data-v-5521cdf9="" alt="">
									<div data-v-5521cdf9="" class="screen" style="display: none;"></div>
								</div>
							</div>
							<p data-v-5521cdf9="" class="link-up"></p>
						</div>
						<p data-v-5521cdf9="" class="link-row"></p>
					</div>
				</div>
			</div>
			<!---->
			<div class="">
				<div data-v-5521cdf9="" class="confirm gray">完成</div>
				<div data-v-5521cdf9="" onclick="submit_32_to_16()" style="cursor: pointer;display: none;" class="confirm submit_ok">完成</div>
			</div>

			<!---->
		</div>
	</div>
</body>
</html>