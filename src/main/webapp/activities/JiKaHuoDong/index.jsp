<%@ page import="com.lymava.qier.activities.model.MeiRiJiKa" %>
<%@ page import="com.lymava.qier.activities.model.JiKaHuoDong" %>
<%@ page import="javax.swing.text.html.HTMLDocument" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.lymava.nosql.util.PageSplit" %>
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

		<script type="text/javascript" >var basePath = '${basePath}';</script>

		<script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js"></script>
		<script type="text/javascript" src="${basePath }plugin/js/lymava_common.js?r=2018-08-15"></script>
		<script type="text/javascript" src="${basePath }activities/JiKaHuoDong/js/project.js?r=2018-08-15"></script>

		<link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
		<script type="text/javascript" src="${basePath }plugin/js/layer_mobile/layer.js"></script>

		<script src="${basePath }activities/JiKaHuoDong/mui/js/mui.min.js"></script>
		<link href="${basePath }activities/JiKaHuoDong/mui/css/mui.min.css" rel="stylesheet"/>

		<link rel="stylesheet" type="text/css" href="${basePath }activities/JiKaHuoDong/css/index.css"/>

	<%
		// 现在的时间
    	Long nowTime = System.currentTimeMillis();
		// 今天开始的时间
    	Long nowStartTime = DateUtil.getDayStartTime(nowTime);

		JiKaHuoDong jiKaHuoDong_find =new JiKaHuoDong();

		jiKaHuoDong_find.setOpenid(openid_header);
		jiKaHuoDong_find.setLingqu_day(nowStartTime);

		JiKaHuoDong jiKaHuoDong_find_out = (JiKaHuoDong) serializContext.get(jiKaHuoDong_find);


		PageSplit pageSplit = new PageSplit();
		pageSplit.setPageSize(8);

		MeiRiJiKa meiRiJiKa_find_zijiling = new MeiRiJiKa();

		meiRiJiKa_find_zijiling.setJika_kaishi_day(nowStartTime);
		meiRiJiKa_find_zijiling.setFriend_openid(openid_header);
		meiRiJiKa_find_zijiling.setMy_openid(openid_header);

		meiRiJiKa_find_zijiling = (MeiRiJiKa)serializContext.get(meiRiJiKa_find_zijiling);

		MeiRiJiKa meiRiJiKa_find = new MeiRiJiKa();
		meiRiJiKa_find.setJika_kaishi_day(nowStartTime);
		meiRiJiKa_find.setMy_openid(openid_header);

		List<MeiRiJiKa> meirijika_list = serializContext.findAll(meiRiJiKa_find);

		for (MeiRiJiKa meiRiJiKa_tmp:meirijika_list){
			request.setAttribute("card_type_"+meiRiJiKa_tmp.getCard_type(),meiRiJiKa_tmp.getCard_type());
		}
		if(jiKaHuoDong_find_out!=null&& jiKaHuoDong_find_out.getChoujiang_jine()!=null&&jiKaHuoDong_find_out.getChoujiang_jine()>0){
			request.setAttribute("lingqu_jiangjin",jiKaHuoDong_find_out.getChoujiang_jine());
		}
		String opid=request.getParameter("my_openid");
		String nk_name=request.getParameter("nkik_name");
		if(nk_name!=null&&nk_name!=""){
			nk_name=new String(nk_name.getBytes("iso-8859-1"),"utf-8");
		}
		request.setAttribute("nk_name",nk_name);
		request.setAttribute("opid",opid);
		request.setAttribute("nick_name",user.getNickname());
		request.setAttribute("my_openid",openid_header);
		request.setAttribute("ziji_jinri_shifoujika",meiRiJiKa_find_zijiling != null);
		request.setAttribute("jinri_shifoujiman",jiKaHuoDong_find_out != null && State.STATE_OK.equals(jiKaHuoDong_find_out.getState()));
		request.setAttribute("jinri_shifoulingjiang",jiKaHuoDong_find_out != null && jiKaHuoDong_find_out.getChoujiang_jine() !=null && jiKaHuoDong_find_out.getChoujiang_jine()>0);
	%>
		<script type="text/javascript">
            $(function(){
                var window_width = $(window).width();
                var rem_font_size = window_width*10/75;
                $("html").css("font-size",rem_font_size+"px");
                var opid='${opid}';
                var nkik_name='${nick_name}';
                var nk_name='${nk_name}';
                var myopenid='${my_openid}';
				if(opid==null||opid==""){
                    window.location.replace("${basePath}activities/JiKaHuoDong/index.jsp?nkik_name="+nkik_name+"&my_openid="+myopenid);
				}else if(opid!=myopenid){
                    window.location.href="${basePath}/activities/JiKaHuoDong/bangzhu.jsp?nk_name="+nk_name+"&my_openid="+opid;
				}

				if(${jinri_shifoulingjiang}){
				    var jiangjin_qu='${lingqu_jiangjin}';
                    $("#tishi").css("display","block");
                    $('.tixing_2_2').html(jiangjin_qu+"元");
				    if(jiangjin_qu=='138'){
                        $("#tixing_2_1").css("display","none");
                        $("#tixing_2_2").css("display","block");
					}
					else {
                        $("#tixing_2_1").css("display","block");
                        $("#tixing_2_2").css("display","none");
					}
                    $("#lingjiang").unbind();
				}

                mui.init();
            });
		</script>
	<body style="background: #fffbe0;">
		<div class="logo">
			<div class="logo_1">
				<img src="img/logo.png" />
			</div>
			<div class="logo_2">
				<img src="img/guize.png" id="guize" />
			</div>
		</div>
		<div class="zhuti">
			<img src="img/zhuti.png"/>
		</div>
		<div class="shneghuo">
			<img src="img/shenghuo.png"/>
		</div>
		<div class="riqi">
			<img src="img/huodongshijian2.png" />
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
				${nick_name}的吃货卡
			</div>

			<div class="leirong11 mui-row">

				<c:if test="${!jinri_shifoujiman}">
					<c:if test="${!ziji_jinri_shifoujika }" >
						<div class="leirong11_1">
							<img id="lingqu" src="img/lingqujinri.png" />
						</div>
					</c:if>
					<c:if test="${ziji_jinri_shifoujika }" >
						<div class="leirong11_1">
							<img id="yilingqu" src="img/mingrizailai.png" />
						</div>
					</c:if>
						<div class="leirong11_2">
							<img id="qiuzhu" src="img/rnagpengyoubangwo.png" />
						</div>
				</c:if>
				<c:if test="${jinri_shifoujiman }" >
					<div class="leirong11_1">
						<img id="lingjiang" src="img/quchoujiang.png" />
					</div>
				</c:if>

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
		<div class="tixing" id="tishi" style="display: none;">
			<div class="tixing_1">
				<img src="img/gongxi_02.png" />
			</div>
			<div class="tixing_2" id="tixing_2_1" style="display: none;">
				<div class="tixing_2_1">获得悠择通用红包</div>
				<div class="tixing_2_2"></div>
			</div>
			<div class="tixing_2" id="tixing_2_2" style="display: none;">
				<div class="tixing_2_1">获得圣慕缇价值</div>
				<div class="tixing_2_2"></div>
				<div class="tixing_2_3">烤羊排</div>
			</div>
		</div>

		<div class="sale_rule" id="fenxiang" style="display: none;line-height: 10rem;color: #FFFFFF">
			<img src="img/youshangjiao.png" id="youshangjiao"/>
		</div>

	</body>
<script type="text/javascript">
	var i=1;
	$("#lingqu").click(function () {

		var request_url = "${basePath  }activities/JiKaHuoDong/event/lingqu_jinri_kapian.jsp";

		ajax_get(request_url,function(msg){
            var responseData = json2obj(msg);
            var statusCode = responseData.statusCode;

            if (responseData.current_card_type == null) {
                alertMsg_correct(responseData.message);
                return;
            }
            window.location.reload(true);

        })
    });
	$("#lingjiang").click(function () {
		var request_url="${basePath}activities/JiKaHuoDong/event/lingqu_jiangli.jsp";
		ajax_get(request_url,function (msg) {
            var responseData = json2obj(msg);
            var statusCode = responseData.statusCode;

            if (responseData.jiangjin==null) {
                alertMsg_correct(responseData.message);
                return;
            }
            //领奖成功
            var jiangjin = responseData.jiangjin;
            $("#tishi").css("display","block");
            $('.tixing_2_2').html(jiangjin+"元");
            if(jiangjin==138){
                $("#tixing_2_2").css("display","block");
                $("#tixing_2_1").css("display","none");
            }else {
                $("#tixing_2_1").css("display","block");
                $("#tixing_2_2").css("display","none");
            }
        })
    });
	$("#guize").click(function () {
		if(i%2==0){
		    $("#guize99").css("display","none");
		}else {
            $("#guize99").css("display","block");
		}
		i++;
    });
	$("#qiuzhu").click(function () {
        $("#fenxiang").css("display","block");
    });
    $("#youshangjiao").click(function () {
        $("#fenxiang").css("display","none");
    })
</script>
</html>
