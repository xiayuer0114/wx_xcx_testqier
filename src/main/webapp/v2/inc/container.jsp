<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"
%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

	<div id="container">
		<link rel="stylesheet" href="${basePath }v2/inc/css/backstage.css" />
			<div id="navTab" class="tabsPage">
				<div class="tabsPageHeader">
					<div class="tabsPageHeaderContent "><!-- 显示左右控制时添加 class="tabsPageHeaderMargin" -->
						<ul class="navTab-tab">
							<li tabid="main" class="main"><a href="javascript:;"><span><span class="home_icon">我的主页</span></span></a></li>
						</ul>
					</div>
					<div class="tabsLeft">left</div><!-- 禁用只需要添加一个样式 class="tabsLeft tabsLeftDisabled" -->
					<div class="tabsRight">right</div><!-- 禁用只需要添加一个样式 class="tabsRight tabsRightDisabled" -->
					<div class="tabsMore">more</div>
				</div>
				<ul class="tabsMoreList">
					<li><a href="javascript:;">我的主页</a></li>
				</ul>

				<script type="text/javascript">
				var welcomeimg = null;
				var welcomediv = null;
				jQuery(function(){
					welcomeimg =  jQuery('#welcomeimg');
					welcomediv =  jQuery('#welcomediv');
					
					jQuery(window).resize(function() {
							var divwidth = welcomediv.width();
							var divheight = welcomediv.height();
						  welcomeimg.css('width',divwidth-2);
						   welcomeimg.css('height',divheight-2);
					});
					setTimeout(resetdiv, 100);
				});
				function resetdiv(){
					var divwidth = welcomediv.width();
					var divheight = welcomediv.height();
					if( welcomeimg.width() != divwidth-2 ||  welcomeimg.height() != divheight-2){
						 	welcomeimg.css('width',divwidth-2);
						    welcomeimg.css('height',divheight-2);
					}
				   setTimeout(resetdiv, 100);
				}

				</script>

				<%-- 主体数据 --%>
				<div class="navTab-panel tabsPageContent layoutBox"  id=""welcomediv style="overflow-y:auto;">
					<div class="page unitBox" >
						<div class="backstage">
							<!-- 查询控制区域 -->
							<div class="b_font layui-col-xs12">
								<div class="b_f1">
									开始时间:
									<input style="width: 130px;height: 24px" readonly="readonly" type="text" id="startData" name="startData" class="form-control date" datefmt="yyyy-MM-dd HH:mm:ss" >
									---至---
									结束时间
									<input style="width: 130px;height: 24px" readonly="readonly" type="text" id="endData" name="endData" class="form-control date" datefmt="yyyy-MM-dd HH:mm:ss" >

									<%--搜索--%>
									<input type="button"  style="height: 25px" value="搜索" onclick="selSpell();" />

									<br><br><br>

									当前查询主体:
									<b> <span id="searchBody_startData"></span>  &nbsp;&nbsp;---至---&nbsp;&nbsp;  <span id="searchBody_endData"></span></b>
								</div>
							</div>

							<!--总金额区域  商家总金额  流水总金额   订单总金额 -->
							<div class="backstage1 layui-col-xs12">
								<div class="b_s layui-col-xs12">
									<div class="backstage1_1" onclick="lookMerchantData();">
										<div class="ba1">
											<div class="ba1_1">
												商家总金额
											</div>
											<div class="ba1_2" id="balanceAll">
												￥95.27
											</div>
										</div>
										<div class="ba2">
											<img src="img/icon1.png" width="65" height="65"/>
										</div>
									</div>
									<div class="backstage1_2">
										<div class="ba1">
											<div class="ba1_1">
												<span name="dayAllBalanceName"></span>总金额
											</div>
											<div class="ba1_2" id="dayAllBalance">
												￥95.27
											</div>
										</div>
										<div class="ba2">
											<img src="img/icon2.png" width="65" height="65" />
										</div>
									</div>
									<div class="backstage1_3">
										<div class="ba1">
											<div class="ba1_1">
												<span name="dayAllBalanceName"></span>订单总金额
											</div>
											<div class="ba1_2" id="dayAllCount">
												9527笔
											</div>
										</div>
										<div class="ba2">
											<img src="img/icon3.png" width="65" height="65"/>
										</div>
									</div>
								</div>
							</div>
							<div class="clear"></div>
							<div class="" style="background-color: #FFFFFF;box-shadow: 0px 0px 17px -1px #c7c7c7;height: 2px;margin-top: 1.5rem;"></div>

							<!--支付方式总金额-->
							<div class="backstage2">
								<div class="b_font layui-col-xs12">
									<div class="b_f">
										<span name="dayAllBalanceName"></span>支付总金额数据
									</div>
								</div>
								<div class="b_s layui-col-xs12">
									<div class="backstage1_1">
										<div class="bb1">
											<div class="">
												<div class="bb1_1">
													支付宝总金额
												</div>
												<div class="bb1_2" id="dayAllBalanceAlipay">
													￥95.27
												</div>
											</div>
											<div class="">
												<div class="bb1_1">
													支付宝总笔数
												</div>
												<div class="bb1_2" id="dayAllAlipayCount">
													28笔
												</div>
											</div>
										</div>
										<div class="bb2">
											<img src="img/icon4.png" width="65" height="65"/>
										</div>
									</div>
									<div class="backstage1_2">
										<div class="bb1">
											<div class="">
												<div class="bb1_1">
													微信总金额
												</div>
												<div class="bb1_2" id="dayAllBalanceWechat">
													￥200
												</div>
											</div>
											<div class="">
												<div class="bb1_1">
													微信总笔数
												</div>
												<div class="bb1_2" id="dayAllWechatCount">
													10
												</div>
											</div>
										</div>
										<div class="bb2">
											<img src="img/icon5.png" width="65" height="65"/>
										</div>
									</div>

									<div class="backstage1_2">
										<div class="bb1">
											<div class="">
												<div class="bb1_1">
													红包总金额
												</div>
												<div class="bb1_2">
													<span id="dayAllBalanceRed">200</span>
												</div>
											</div>
											<div class="">
												<div class="bb1_1">
													红包笔数
												</div>
												<div class="bb1_2">
													<span id="dayAllBalanceRedCount">200</span>
												</div>
											</div>
										</div>
										<div class="bb2">
											<img src="img/icon10.png" width="65" height="65"/>
										</div>
									</div>

								</div>
							</div>
							<div class="clear"></div>
							<div class="" style="background-color: #FFFFFF;box-shadow: 0px 0px 17px -1px #c7c7c7;height: 2px;margin-top: 1.5rem;"></div>

							<!--用户关注、取消变量-->
							<div class="backstage3">
								<div class="b_font layui-col-xs12">
									<div class="b_f">
										<span name="dayAllBalanceName"></span>用户统计数据
									</div>
								</div>
								<div class="b_s layui-col-xs12">
									<div class="backstage1_1">
										<div class="ba1">
											<div class="ba1_1">
												新增用户
											</div>
											<div class="ba1_2" id="newUser">
												99
											</div>
										</div>
										<div class="ba2">
											<img src="img/icon6.png" width="65" height="65"/>
										</div>
									</div>
									<div class="backstage1_2">
										<div class="ba1">
											<div class="ba1_1">
												关注用户
											</div>
											<div class="ba1_2" id="guanzhuUser">
												1680
											</div>
										</div>
										<div class="ba2">
											<img src="img/icon7.png" width="65" height="65"/>
										</div>
									</div>
									<div class="backstage1_3">
										<div class="ba1">
											<div class="ba1_1">
												取关用户
											</div>
											<div class="ba1_2" id="quxiaoUser">
												6
											</div>
										</div>
										<div class="ba2">
											<img src="img/icon8.png" width="65" height="65"/>
										</div>
									</div>
								</div>
                            </div>
                            <div class="clear"></div>
                            <div class="" style="background-color: #FFFFFF;box-shadow: 0px 0px 17px -1px #c7c7c7;height: 2px;margin-top: 1.5rem;"></div>

							<!--简单的收个烂尾-->
							<br><br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							the end...
							<br><br>

						</div>
					</div>
				</div>

			</div>
	</div>


<%-- 主体数据对应的js --%>
<script type="text/javascript">

    getMerchant72AllBalance(); 		// 得到商家的余额 总和
    financialData("","");	// 加载其他数据

    var timer;
    // 初始化加载 (今天)
    $(function () {
        var handler = function(){
            getMerchant72AllBalance(); 		// 得到商家的余额 总和
            financialData("","");	// 加载其他数据
        }

//        timer = setInterval(handler,2000); //每2秒刷新一次数据
    });


    // 查看每一个商家剩余的余额
    function lookMerchantData() {
        layer.open({
            type: 1,
            area: ['600px', '500px'],
            shadeClose: true, //点击遮罩关闭
            content: '\<\div style="padding:20px;"><table width="550px" border="1" id="merchantDataTable"><tr><th>编号</th><th>昵称</th><th>用户名</th><th>余额</th></tr></table>\<\/div>'
        });

        $.post("${basePath}/qier/cashier/getMerchant72AllData.do",function (msg) {

            var data = JSON.parse(msg).data;

            for (var i=0;i<data.length;i++){
                $tr = $("<tr></tr>");
                $td1 = $("<td>"+data[i].bianhao+"</td>");
                $td2 = $("<td>"+data[i].nickname+"</td>");
                $td3 = $("<td>"+data[i].username+"</td>");
                $td4 = $("<td>"+data[i].balance/1000000+"</td>");

                $tr.append($td1).append($td2).append($td3).append($td4);
                $("#merchantDataTable").append($tr);
            }
        });
    }

    // 得到所有商家的 余额总和(商家总金额)
    function getMerchant72AllBalance() {
        // 得到所有商家的余额
        jQuery.ajax({
            type : "post",
            url : basePath + "qier/cashier/getMerchant72AllBalance.do",
            global:false,
            dataType : "text",
            success : function(data) {
                data = JSON.parse(data);
                $("#balanceAll").text("￥"+data.data.price_all/1000000)
            },
            error : function() {}
        });
    }

    // 查询一段时间的数据  向'financialData()'传入起止时间
    function selSpell() {
        var start_time = $("#startData").val();
        var end_time = $("#endData").val();

        financialData(start_time,end_time);

        function cleartime(){
            clearInterval(timer);
            console.log("end circulation")
        };

        setTimeout(cleartime,0);

    };


    /**
     * 加载其他数据  向后端得到除去'商家总金额'的其他数据 支付宝,微信数据,关注和取关用户等
     * @param start_time   开始时间
     * @param end_time   结束时间
     */
    function financialData(start_time,end_time) {


        jQuery.ajax({
            type : "post",
            url : basePath + "qier/cashier/financialData.do",
            global:false,
            dataType : "text",
            data:{"start_time":start_time,"end_time":end_time},
            success : function(data) {
                data = JSON.parse(data);

                if(data.statusCode == 300 || data.statusCode=="300"){
                    alert(data.message);
                }else {
                    var showName = document.getElementsByName("dayAllBalanceName");
                    var testMsg = "此时间段的";
                    for (var i = 0; i < showName.length; i++) {
                        showName[i].innerText = testMsg;
                    }

                    $("#dayAllBalance").text("￥"+data.data.price_all/100);
                    $("#dayAllCount").text(data.data.mao_price_all / 100);

                    $("#dayAllBalanceAlipay").text("￥" + data.data.price_all_alipay / 100);
                    $("#dayAllAlipayCount").text(data.data.price_all_alipay_count);
                    $("#dayAllBalanceWechat").text("￥" + data.data.price_all_wechatpay / 100);
                    $("#dayAllWechatCount").text(data.data.price_all_wechatpay_count);
                    $("#dayAllBalanceRed").text("￥" + data.data.price_all_redpay / 100);
                    $("#dayAllBalanceRedCount").text(data.data.price_all_redpay_count);

                    $("#newUser").text(data.data.newGuanZhuUser);
                    $("#guanzhuUser").text(data.data.guanZhuUser);
                    $("#quxiaoUser").text(data.data.quXiaoGuanZhuUser);

                    $("#all_hongbao").text(data.data.all_hongbao / 1000000);
                    $("#user_use_forTime").text(data.data.user_use_forTime / 100);
                    $("#user_all_shengyu").text(data.data.user_all_shengyu / 1000000);

                    // 显示查询主体
                    $("#searchBody_startData").text(data.startDataStr);
                    $("#searchBody_endData").text(data.endDataStr);
                }
            },
            error : function() {}

        });
    }

</script>
