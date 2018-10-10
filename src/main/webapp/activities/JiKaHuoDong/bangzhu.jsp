<%@ page import="com.lymava.qier.activities.model.JiKaHuoDong" %>
<%@ page import="com.lymava.nosql.util.PageSplit" %>
<%@ page import="com.lymava.qier.activities.model.MeiRiJiKa" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/header/check_openid.jsp"%>
<%@ include file="/header/header_check_login.jsp"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <meta content="yes" name="apple-mobile-web-app-capable">
	    <meta content="telephone=no,email=no" name="format-detection">
	    <meta content="yes" name="apple-touch-fullscreen">
	    <meta http-equiv="X-UA-Compatible" content="ie=edge">
	    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" /><!-- 屏蔽双击缩放 -->
		<script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js"></script>
		<link href="css/bangzhu.css" rel="stylesheet">
	    <script src="mui/js/mui.min.js"></script>
    	<link href="mui/css/mui.min.css" rel="stylesheet"/>
		<script type="text/javascript">
			$(function(){
				var window_width = $(window).width();
				var rem_font_size = window_width*10/75;
				$("html").css("font-size",rem_font_size+"px");
				
 				mui.init();
			}); 
		</script>
	<%
		// 现在的时间
    	Long nowTime = System.currentTimeMillis();
		// 今天开始的时间
    	Long nowStartTime = DateUtil.getDayStartTime(nowTime);

    	//
    	String my_openid=request.getParameter("my_openid");
    	String nk_name=request.getParameter("nk_name");
    	if(nk_name!=null&&nk_name!=""){
			nk_name=new String(nk_name.getBytes("iso-8859-1"),"utf-8");
    	}
		JiKaHuoDong jiKaHuoDong_find =new JiKaHuoDong();
		jiKaHuoDong_find.setOpenid(my_openid);
		jiKaHuoDong_find.setLingqu_day(nowStartTime);

		JiKaHuoDong jiKaHuoDong_find_out = (JiKaHuoDong) serializContext.get(jiKaHuoDong_find);


		PageSplit pageSplit = new PageSplit();
		pageSplit.setPageSize(8);

		MeiRiJiKa meiRiJiKa_find_zijiling = new MeiRiJiKa();

		meiRiJiKa_find_zijiling.setJika_kaishi_day(nowStartTime);
		meiRiJiKa_find_zijiling.setFriend_openid(openid_header);

		meiRiJiKa_find_zijiling = (MeiRiJiKa)serializContext.get(meiRiJiKa_find_zijiling);

		MeiRiJiKa meiRiJiKa_find_haoyoujikacishu = new MeiRiJiKa();
		meiRiJiKa_find_haoyoujikacishu.setFriend_openid(openid_header);
		meiRiJiKa_find_haoyoujikacishu.setMy_openid(my_openid);

		List<MeiRiJiKa> meirijika_list_cishu = serializContext.findAll(meiRiJiKa_find_haoyoujikacishu);


		MeiRiJiKa meiRiJiKa_find = new MeiRiJiKa();
		meiRiJiKa_find.setJika_kaishi_day(nowStartTime);
		meiRiJiKa_find.setMy_openid(my_openid);

		List<MeiRiJiKa> meirijika_list = serializContext.findAll(meiRiJiKa_find);

		for (MeiRiJiKa meiRiJiKa_tmp:meirijika_list){
			request.setAttribute("card_type_"+meiRiJiKa_tmp.getCard_type(),meiRiJiKa_tmp.getCard_type());
		}
		request.setAttribute("my_openid",my_openid);
		request.setAttribute("nk_name",nk_name);
		request.setAttribute("haoyou_shifou_jikaliangchi",meirijika_list_cishu != null&&meirijika_list_cishu.size()>1);
		request.setAttribute("haoyou_jinri_shifoubangzhu",meiRiJiKa_find_zijiling != null&& (MeiRiJiKa.state_inprocess.equals(meiRiJiKa_find_zijiling.getState())||MeiRiJiKa.state_chongfu.equals(meiRiJiKa_find_zijiling.getState())));
		request.setAttribute("haoyou_jinri_meichongfu",meiRiJiKa_find_zijiling != null&& MeiRiJiKa.state_inprocess.equals(meiRiJiKa_find_zijiling.getState()));
		request.setAttribute("bangzhu_jinri_yichongfu",meiRiJiKa_find_zijiling != null&& MeiRiJiKa.state_chongfu.equals(meiRiJiKa_find_zijiling.getState()));
		request.setAttribute("haoyou_shifoujiman",jiKaHuoDong_find_out != null && State.STATE_OK.equals(jiKaHuoDong_find_out.getState()));
	%>
	<body style="background: #fffbe0;">
		<div class="logo">
			<div class="logo_1">
				<img src="img/logo.png" />
			</div>
			<div class="logo_2">
				<img id="guize" src="img/guize.png" />
			</div>
		</div>
		<div class="zhuti">
			<img src="img/zhuti.png"/>
		</div>
		<div class="shneghuo">
			<img src="img/shenghuo.png"/>
		</div>
		<div class="riqi"  style="display: none;">
			<img src="img/banghaoyou.png" />
		</div>
		<div class="leirong mui-row">
			<div class="leirong10 mui-row">
				<div class="leirong_1 mui-col-xs-3"  >
					<img id="hc1" src="img/hui1<c:if test="${!empty card_type_1 }" >_yiling</c:if>.png" />
				</div>
				<div class="leirong_2 mui-col-xs-3">
					<img id="hc2" src="img/hui2<c:if test="${!empty card_type_2 }" >_yiling</c:if>.png" />
				</div>
				<div class="leirong_3 mui-col-xs-3">
					<img id="hc3" src="img/hui3<c:if test="${!empty card_type_3 }" >_yiling</c:if>.png" />
				</div>
				<div class="leirong_4 mui-col-xs-3">
					<img id="hc4" src="img/hui4<c:if test="${!empty card_type_4 }" >_yiling</c:if>.png" />
				</div>
			</div>
			<div class="leirong19 mui-row" >
				<div class="leirong_5 mui-col-xs-3">
					<img id="hc5" src="img/hui5<c:if test="${!empty card_type_5 }" >_yiling</c:if>.png" />
				</div>
				<div class="leirong_6 mui-col-xs-3">
					<img id="hc6" src="img/hui6<c:if test="${!empty card_type_6 }" >_yiling</c:if>.png" />
				</div>
				<div class="leirong_7 mui-col-xs-3">
					<img id="hc7" src="img/hui7<c:if test="${!empty card_type_7 }" >_yiling</c:if>.png" />
				</div>
				<div class="leirong_8 mui-col-xs-3">
					<img id="hc8" src="img/hui8<c:if test="${!empty card_type_8 }" >_yiling</c:if>.png" />
				</div>
			</div>
			<div class="leirong9 mui-row">
				${nk_name}的吃货卡
			</div>  
			<div class="leirong11 mui-row">
				<c:if test="${!haoyou_shifou_jikaliangchi}">
					<c:if test="${!haoyou_shifoujiman}">
						<c:if test="${!haoyou_jinri_shifoubangzhu}">
							<div class="leirong11_1">
								<img id="bangtajika" src="img/bangtajika.png" />
							</div>
						</c:if>
						<c:if test="${haoyou_jinri_meichongfu}">
							<div class="leirong11_1">
								<img src="img/xinde.png" />
							</div>
						</c:if>
						<c:if test="${bangzhu_jinri_yichongfu}">
							<div class="leirong11_1">
								<img src="img/chonghude.png" />
							</div>
						</c:if>
					</c:if>
					<c:if test="${haoyou_shifoujiman}">
						<div class="leirong11_1">
							<img src="img/haoyoujiqi.png" />
						</div>
					</c:if>
				</c:if>
				<c:if test="${haoyou_shifou_jikaliangchi}">
					<div class="leirong11_1">
						<img src="img/liangci.png"/>
					</div>
				</c:if>
				<div class="leirong11_2">
					<img id="woyeyao" src="img/woyeyao.png" />
				</div>
			</div>
		</div>
		<div class="leirong13 mui-row" >
			<img src="img/huodongshijian.png" />
		</div>

		<div class="tanchang" id="guize99" style="display: none;">
			<div class="tanchang_1">
				<img src="img/guizhegai.png" />
			</div>
		</div>
	</body>
<script type="text/javascript">
	var i=1;
    $("#guize").click(function () {
        if(i%2==0){
            $("#guize99").css("display","none");
        }else {
            $("#guize99").css("display","block");
        }
        i++;
    });
	$("#bangtajika").click(function () {
	    var bangling_url="${basePath}activities/JiKaHuoDong/event/pengyou_bangzhu_ingqu.jsp";
	    var data={my_openid:"${my_openid}"}
		$.post(bangling_url,data,function (msg) {
//            var responseData = json2obj(msg);
//            var statusCode = responseData.statusCode;
//
//            if (responseData.current_card_type == null) {
//                alertMsg_correct(responseData.message);
//                return;
//            }
            window.location.reload(true);
        });
    });
	$("#woyeyao").click(function () {
		window.location.href="${basePath}activities/JiKaHuoDong/index.jsp";
    })
</script>
</html>
