<%@ page import="com.lymava.qier.activities.model.ActivitieMerchantRedEnvelope" %>
<%@ page import="com.lymava.commons.exception.CheckException" %>
<%@ page import="com.lymava.qier.model.MerchantRedEnvelope" %>
<%@ page import="com.lymava.qier.activities.model.ActivitieMerchant" %>
<%@ page import="com.lymava.trade.pay.model.PaymentRecord" %>
<%@ page import="com.lymava.qier.model.User72" %>
<%@ page import="com.lymava.qier.activities.hongbaoliebian.HongbaoliebianPaymentRecord" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="utf-8" %>
<!DOCTYPE html>
<html>

<%
    request.setAttribute("scope_snsapi", Gongzonghao.scope_snsapi_userinfo);

    request.removeAttribute("openid");
    session.removeAttribute("openid");
%>
<%@ include file="/header/check_openid.jsp"%>
<%@ include file="/header/header_check_login.jsp"%>

<%
    // 参数'订单id' 和 '活动红包id'
    String paymentRecord_id = request.getParameter("paymentRecord_id");
    CheckException.checkIsTure(MyUtil.isValid(paymentRecord_id), "订单id 不正确");

    // 找到订单  这笔订单必须为付款成功
    PaymentRecord paymentRecord_find = new PaymentRecord();
    paymentRecord_find.setId(paymentRecord_id);
    paymentRecord_find.setState(State.STATE_PAY_SUCCESS);
    paymentRecord_find = (PaymentRecord) serializContext.get( paymentRecord_find);
    CheckException.checkIsTure(paymentRecord_find != null, "订单不存在" );

    String activitieMerchantRedEnvelope_id = request.getParameter("activitieRedEnvelope_id");
    CheckException.checkIsTure(MyUtil.isValid(activitieMerchantRedEnvelope_id), "红包id 不正确");
        // 找到活动红包
    ActivitieMerchantRedEnvelope activitieMerchantRedEnvelope_find = new ActivitieMerchantRedEnvelope();
    activitieMerchantRedEnvelope_find.setId(activitieMerchantRedEnvelope_id);
    activitieMerchantRedEnvelope_find =  (ActivitieMerchantRedEnvelope)serializContext.get(activitieMerchantRedEnvelope_find);
    CheckException.checkIsTure(activitieMerchantRedEnvelope_find != null, "没找到活动红包");
        // 找到活动商家
    ActivitieMerchant activitieMerchant_find = activitieMerchantRedEnvelope_find.getActivitieMerchant();
    CheckException.checkIsTure(activitieMerchant_find != null, "该商家没有参与活动");
        // 找到商家的 定向红包
    MerchantRedEnvelope merchantRedEnvelope_find = activitieMerchantRedEnvelope_find.getMerchantRedEnvelope();
    Boolean chenkRed= (merchantRedEnvelope_find !=null && merchantRedEnvelope_find.getAmountFen()!=null);
    CheckException.checkIsTure(chenkRed , "定向红包信息错误!");


//    putConfig(classTmp, "st_"+State.STATE_OK, "正常");
//    putConfig(classTmp, "st_"+State.STATE_WAITE_CHANGE, "等待支付");
//    putConfig(classTmp, "st_"+State.STATE_ALL_IN_ONE_PAY_SUCCESS, "等待好友支付");
//    putConfig(classTmp, "st_"+State.STATE_PAY_SUCCESS, "付款成功");
//    putConfig(classTmp, "st_"+State.STATE_FALSE, "异常");

    Object share = request.getSession().getAttribute("share"+paymentRecord_id);
    Integer activitie_state = activitieMerchantRedEnvelope_find.getState();
    Integer check_ret = 0;

    if( share!= null && State.STATE_WAITE_CHANGE.equals(activitie_state) ){
        // 点击分享
        // session值不为空 并且红包为等待支付
        check_ret = State.STATE_INPROCESS; // 500  点击分享
    }else if( State.STATE_WAITE_CHANGE.equals(activitie_state) ||  (State.STATE_ALL_IN_ONE_PAY_SUCCESS.equals(activitie_state) && openid_header.equals(activitieMerchantRedEnvelope_find.getOpen_id()) )  ){
        // 该支付的情况
        // 红包的状态为'等待支付'  或者  为'等待好友支付'并且等待支付的那个人是自己
        check_ret = State.STATE_OK; //  200  支付
        // '等待支付' 马上变成 '等待好友支付'
        if(State.STATE_WAITE_CHANGE.equals(activitie_state)){
            ActivitieMerchantRedEnvelope activitieMerchantRedEnvelope_update = new ActivitieMerchantRedEnvelope();
            activitieMerchantRedEnvelope_update.setState(State.STATE_ALL_IN_ONE_PAY_SUCCESS);
            activitieMerchantRedEnvelope_update.setOpen_id(openid_header);
            activitieMerchantRedEnvelope_update.setHaoyouClickTime(System.currentTimeMillis());
            serializContext.updateObject(activitieMerchantRedEnvelope_find.getId(),activitieMerchantRedEnvelope_update);
        }
    }else if( (State.STATE_PAY_SUCCESS.equals(activitie_state) && !openid_header.equals(activitieMerchantRedEnvelope_find.getOpen_id()) )   ||   (State.STATE_ALL_IN_ONE_PAY_SUCCESS.equals(activitie_state) && !openid_header.equals(activitieMerchantRedEnvelope_find.getOpen_id()))  ){
        // 被好友抢走了
        // 红包作态为'付款成功'并且付款的那个不是自己  或者  为'等待好友支付'但等待的那个人不是自己
        check_ret = State.STATE_FALSE; // 300  被抢走先机
    }else if(State.STATE_PAY_SUCCESS.equals(activitie_state) && openid_header.equals(activitieMerchantRedEnvelope_find.getOpen_id())){
        // 查看分享
        // 红包状态为'付款成功'并且付款的那个是自己
        check_ret = State.STATE_PAY_SUCCESS; // 207  查看分享
    }

    request.setAttribute("check", check_ret);  // 作用现在页面上的按钮该显示啥子
    request.setAttribute("paymentRecord_id", paymentRecord_id);
    request.setAttribute("activitieRedEnvelope_id", activitieMerchantRedEnvelope_find.getId());
    request.setAttribute("redEnvelope_pic", activitieMerchant_find.getRedEnvelope_pic());
    request.setAttribute("amount", merchantRedEnvelope_find.getAmountFen()/100);
    request.setAttribute("activity_redEnvelope_price_yuan", activitieMerchant_find.getShowActivity_redEnvelope_price_yuan());
    request.setAttribute("redEnvelope_title", activitieMerchant_find.getRedEnvelope_title());
    request.setAttribute("redEnvelope_name", merchantRedEnvelope_find.getRed_envolope_name());

%>


<head>
    <meta charset="utf-8" />
    <title>特卖活动</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta content="yes" name="apple-mobile-web-app-capable">
    <meta content="telephone=no,email=no" name="format-detection">
    <meta content="yes" name="apple-touch-fullscreen">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" /><!-- 屏蔽双击缩放 -->
    <link rel="stylesheet" type="text/css" href="css/sale.css"/>
    <script type="text/javascript" src="js/jquery.js" ></script>


    <script type="text/javascript" >var basePath = '${basePath}';</script>

    <link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
    <script type="text/javascript" src="${basePath }plugin/js/layer_mobile/layer.js"></script>

    <script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="${basePath }plugin/js/lymava_common.js?r=2018-09-20"></script>
    <script type="text/javascript" src="${basePath }activities/hongbaoliebian/js/project.js?r=2018-09-20"></script>


    <script type="text/javascript">
        $(function(){
            $(".sale7").hide();

            var check = '${check}';
            if(check == 200){
                $('#liebian_queren_pay').show();
            }else if(check == 500){
                $('#liebian_share_pay').show();
            } else if(check == 207){
                $('#liebian_lookshare_pay').show();
            } else if(check == 300){
                $('#liebian_look_pay').show();
            }

//            liebian_queren_pay  // 支付  200  支付
//            liebian_share_pay   // 分享   500
//            liebian_lookshare_pay // 查看分享   207
//            liebian_look_pay    // 被抢了  300
//
//            liebian_wait_pay    // 等待支付




            var window_width = $(window).width();
            var rem_font_size = window_width*10/75;
            $("html").css("font-size",rem_font_size+"px");
        });
    </script>
</head>
<body>
<div class="sale1">
    <img src="${basePath}${redEnvelope_pic}"/>
</div>
<div class="sale2">
    <div class="sale2_01">
        <%--<img src="${redEnvelope_pic}"/>--%>
        <img src="img/zhong.png"/>
    </div>
    <div class="sale2_02">
        <div class="sale2_02L">
            <div class="sale02_1">
                <div class="sale2a_02">
                    <s>
                        原价:${amount}
                    </s>
                </div>
                <div class="sale2b_02" >
                    超低价:
                </div>
            </div>
            <div class="sale02_2">
                <div class="" style="float: left;font-size: 0.3rem;margin-top: 0.33rem;">
                    ￥
                </div>
                <div class="" style="float: left;font-size: 0.4rem;margin-top: 0.23rem;">
                    <span id="activity_redEnvelope_price_yuan" value="${activity_redEnvelope_price_yuan}"></span>
                    <span id="activitieRedEnvelope_id" value="${activitieRedEnvelope_id}"></span>
                    <span id="source_paymentRecord_id" value="${paymentRecord_id}"></span>

                    ${activity_redEnvelope_price_yuan}
                    <%--5--%>
                </div>
            </div>
        </div>
        <div class="sale2_02M">
            <img src="img/ph2.png"/>
        </div>
        <div class="sale2_02R">
            ${redEnvelope_title}
            <%--好吃没上限,价格还实惠--%>
        </div>
    </div>
</div>
<div class="clear"></div>
<div class="sale3">
    <%--埠口精酿:波士顿龙虾--%>
    ${redEnvelope_name}
</div>
<div class="sale4">
    秒杀商品
</div>
<div class="sale5"></div>
<div class="sale6">
    <div class="sale6_01">
        活动规则：
    </div>
    <div class="sale6_02">
        1.本次活动由悠择YORZ用户专享。<br />
        2.活动周期：9月1日-9月10日。<br />
        3.购买后可产生3个名额赠送给朋友，朋友购买后，你将免费得到已付费购买的菜品，买单金额将以通用红包形式到账，到公众号【悠择YORZ】-会员中心-我的钱包查看。<br />
        4.活动特卖商品数量有限，抢完为止，抢购成功与否与实际结果为准。<br />
        5.活动周期内，每名用户只可持有一次特卖商品，在使用完毕后可再次购买。<br />
        6.每份特卖商品自购买后半个月后到期，如未使用，到期作废，付费金额不退还。<br />
    </div>
</div>
<div class="sale7" id="liebian_queren_pay">
    立马 ${activity_redEnvelope_price_yuan} 元抢购
</div>

<div class="sale7" id="liebian_wait_pay" style="background-color: #e8e8e8; font-size:0.3rem ">
    等待支付...
</div>
<div class="sale7" id="liebian_share_pay" style="background-color: #e8e8e8; font-size:0.3rem ">
    点击右上角分享哦.
</div>
<div class="sale7" id="liebian_lookshare_pay" onclick="liebian_lookshare_pay();" style="background-color: #e8e8e8; font-size:0.3rem ">
    查看分享
</div>
<div class="sale7" id="liebian_look_pay" style="background-color: #e8e8e8; font-size:0.3rem ">
    居然被其他好友抢占了先机!
</div>


</body>

<script type="text/javascript">

    var pay_method = '<%=PayFinalVariable.pay_method_weipay%>';
    
    function liebian_lookshare_pay() {
        var super_paymentRecord_id = "${paymentRecord_id}";
        $.get(basePath+"activities/hongbaoliebian/event/check_payment_isexit.jsp?time="+new Date().getTime(),{"paymentRecord_id":super_paymentRecord_id},function (message) {
            data = json2obj(message);
            super_paymentRecord_id = data.paymentRecord_id;
            window.location.href = basePath+"activities/hongbaoliebian/rule.jsp?paymentRecord_id="+super_paymentRecord_id+"&time="+new Date().getTime();
        });
    }

    $('#liebian_queren_pay').bind('click',function(){
        if(  !($('#liebian_queren_pay').is(':hidden'))  ){

            // 点击支付  马上隐藏支付按钮
            $(".sale7").hide();

            // 检测这笔订单 不是另一笔订单的'原订单'就调用支付, 是.就直接跳转页面
            var paymentRecord_id = "${paymentRecord_id}";
            $.get(basePath+"activities/hongbaoliebian/event/check_payment_isexit.jsp?time="+new Date().getTime(),{"paymentRecord_id":paymentRecord_id},function (message) {
                data = json2obj(message);
                if(data.statusCode == 500){
                    $('#liebian_wait_pay').show();
                    create_paymentrecord(); // 不是就支付
                }else if(data.statusCode == 200){
                    paymentRecord_id = data.paymentRecord_id; // 是 就直接跳转,    并将'原订单'的id带过去
                    window.location.href = basePath+"activities/hongbaoliebian/rule.jsp?paymentRecord_id="+paymentRecord_id+"&time="+new Date();
                }
            });
        }else{
            layer.closeAll();
            alertMsg_info("出现了一个小错误!");
        }
    });
</script>


</html>