<%@ page import="com.lymava.commons.exception.CheckException" %>
<%@ page import="com.lymava.commons.util.MyUtil" %>
<%@ page import="com.lymava.commons.state.State" %>
<%@ page import="com.lymava.qier.activities.model.ActivitieMerchantRedEnvelope" %>
<%@ page import="com.lymava.nosql.mongodb.util.MongoCommand" %>
<%@ page import="java.util.*" %>
<%@ page import="com.lymava.qier.activities.model.ActivitieMerchant" %>
<%@ page import="com.lymava.qier.activities.hongbaoliebian.HongbaoliebianPaymentRecord" %>
<%@ page import="com.lymava.qier.model.MerchantRedEnvelope" %>
<%--
  User: Administrator---SunM
  Date: 2018\9\19 0019
  Time: 13:50
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>
<!DOCTYPE html>
<html>
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
    <script type="text/javascript" src="${basePath }plugin/js/lymava_common.js?r=2018-08-15"></script>
    <script type="text/javascript" src="${basePath }activities/hongbaoliebian/js/project.js?r=2018-08-15"></script>

    <%
        // 找到活动订单
        String paymentRecord_id = request.getParameter("paymentRecord_id");
        CheckException.checkIsTure(MyUtil.isValid(paymentRecord_id), "源订单id不正确");
        HongbaoliebianPaymentRecord hongbaoliebianPaymentRecord_find = new HongbaoliebianPaymentRecord();
        hongbaoliebianPaymentRecord_find.setId(paymentRecord_id);
        hongbaoliebianPaymentRecord_find.setState(State.STATE_PAY_SUCCESS);  // 付款成功
        hongbaoliebianPaymentRecord_find = (HongbaoliebianPaymentRecord)serializContext.get(hongbaoliebianPaymentRecord_find);
        CheckException.checkIsTure( hongbaoliebianPaymentRecord_find !=  null, "源订单不正确");
            // 找到活动红包
        ActivitieMerchantRedEnvelope activitieMerchantRedEnvelope_find = hongbaoliebianPaymentRecord_find.getActivitie_redEnvelope();
        CheckException.checkIsTure( activitieMerchantRedEnvelope_find !=  null, "订单信息中没有活动红包");
            // 活动红包中的定向红包
        MerchantRedEnvelope merchantRedEnvelope_find = activitieMerchantRedEnvelope_find.getMerchantRedEnvelope();
        CheckException.checkIsTure( merchantRedEnvelope_find != null && merchantRedEnvelope_find.getAmountFen()!=null , "定向红包信息不正确");
            // 找到活动找到活动商家
        ActivitieMerchant activitieMerchant_find = activitieMerchantRedEnvelope_find.getActivitieMerchant();
        CheckException.checkIsTure( activitieMerchant_find !=  null, "活动红包中没有活动商家");
            //
        request.getSession().setAttribute("share"+paymentRecord_id, "share");
        request.setAttribute("paymentRecord_id", paymentRecord_id);
        request.setAttribute("redEnvelope_pic", activitieMerchant_find.getRedEnvelope_pic());
        String amount = "";
        if(merchantRedEnvelope_find.getAmountFen() != null){
            amount = merchantRedEnvelope_find.getAmountFen()/100+"";
        }
        request.setAttribute("amount", amount);
        request.setAttribute("redEnvelope_name", activitieMerchantRedEnvelope_find.getActivity_redEnvelope_name());


        // 设置一个 活动商家的id 集合
        String activitieMerchant_id = activitieMerchant_find.getId();
        List<String> merchant_id_list = new LinkedList<String>();
        merchant_id_list.add(activitieMerchant_id);

        // 生成最多三条支付信息 (三个分享给好友的红包)
        List<ActivitieMerchantRedEnvelope> activitieMerchantRedEnvelopeList = new LinkedList<ActivitieMerchantRedEnvelope>();

        ActivitieMerchantRedEnvelope activitieMerchantRedEnvelope_find_check = new ActivitieMerchantRedEnvelope();
        activitieMerchantRedEnvelope_find_check.setSuper_paymentRecord_id(paymentRecord_id);
        activitieMerchantRedEnvelopeList = serializContext.findAll(activitieMerchantRedEnvelope_find_check);

        if( activitieMerchantRedEnvelopeList.size()<=0 ){
            while (activitieMerchantRedEnvelopeList.size()<3) {
                ActivitieMerchantRedEnvelope activitieMerchantRedEnvelope_op = null;

                synchronized (ActivitieMerchantRedEnvelope.class) {
                    // 去找到不是活动商家集合中商家的 活动红包
                    ActivitieMerchantRedEnvelope activitieMerchantRedEnvelope_find_create = new ActivitieMerchantRedEnvelope();
                    activitieMerchantRedEnvelope_find_create.setState(State.STATE_OK);
                    for (String activitie_merchant_user_id : merchant_id_list){
                        activitieMerchantRedEnvelope_find_create.addCommand(MongoCommand.not_in, "activitie_merchant_user_id", activitie_merchant_user_id);
                    }
                    activitieMerchantRedEnvelope_find_create = (ActivitieMerchantRedEnvelope) serializContext.get(activitieMerchantRedEnvelope_find_create);
                    // 找到了之后 马上修改这个活动红包状态为等待支付
                    if (activitieMerchantRedEnvelope_find_create != null) {
                        activitieMerchantRedEnvelope_op = activitieMerchantRedEnvelope_find_create;
                        ActivitieMerchantRedEnvelope activitieMerchantRedEnvelope_update = new ActivitieMerchantRedEnvelope();
                        activitieMerchantRedEnvelope_update.setState(State.STATE_WAITE_CHANGE);
                        activitieMerchantRedEnvelope_update.setSuper_paymentRecord_id(paymentRecord_id);
                        serializContext.updateObject(activitieMerchantRedEnvelope_find_create.getId(), activitieMerchantRedEnvelope_update);
                    }
                }

                // 找到了 添加给好友的活动红包和对应的活动商家,  没找到结束循环
                if (activitieMerchantRedEnvelope_op != null) {
                    activitieMerchantRedEnvelopeList.add(activitieMerchantRedEnvelope_op);
                    merchant_id_list.add(activitieMerchantRedEnvelope_op.getActivitie_merchant_user_id());
                }else {
                    break;
                }
            }
        }
    %>

    <script type="text/javascript">
        $(function(){
            var window_width = $(window).width();
            var rem_font_size = window_width*10/75;
            $("html").css("font-size",rem_font_size+"px");
        });
    </script>
</head>
<body>
<div class="sale_share">
    <div class="sale_s1">
        <%--<img src="img/cai.png"/>--%>
        <img src="${basePath}${redEnvelope_pic}"/>
    </div>
    <div class="sale_s2">
        <div class="" style="width: 7.5rem;height: 1rem;"></div>
        <div class="sale_s2a">
            <div class="" style="color: white;font-size: 0.33rem;padding-top: 0.5rem;">
                您已获得价值<br />
                <%--98--%>
                ${amount}
                元的产品
            </div>
            <div class="" style="font-size: 0.25rem;color: white;padding-top: 0.4rem;">
                <%--波士顿龙虾焗土豆--%>
                ${redEnvelope_name}
            </div>
        </div>
    </div>
    <div class="sale_s3">
        <a onclick="chang_show_hide();">使用规则</a>
    </div>
    <div class="sale_s4">
        【出示公众号-我的到店使用悠择YORZ扫码付款即可】
    </div>
    <div class="sale_s5">
        <div class="sale_s5a" onclick="look_merchant('${paymentRecord_id}');">
            查看商家信息
        </div>

        <div class="sale_s5b" onclick="look_my_wallte();">
            查看我的钱包
        </div>
        <script type="text/javascript">
            function look_my_wallte(){
                window.location.href= '${basePath}activities/hongbaoliebian/wodeqianbao/qianbao.jsp';
            }
            function look_merchant(paymentRecord_id){
                window.location.href= '${basePath}activities/hongbaoliebian/wodeqianbao/xiangqingye.jsp?paymentRecord_id='+paymentRecord_id;
            }
        </script>
    </div>
    <div class="sale_s6">
        <img src="img/title.png"/>
    </div>
    <div class="sale_s7">

        <%
            for (ActivitieMerchantRedEnvelope activitieMerchantRedEnvelope : activitieMerchantRedEnvelopeList){
                ActivitieMerchant activitieMerchant = activitieMerchantRedEnvelope.getActivitieMerchant();
                if(activitieMerchant == null){continue;}
        %>

            <div class="sale_s7a" style="margin-top: 0.3rem;margin-left: 0.31rem;">
                <div class="" style="width: 1.95rem;height: 0.65rem;font-size: 0.25rem;text-align: center;margin: 0 auto;">
                    <%--埠口精酿：波士顿--%>
                    <%--龙虾焗土豆--%>
                    <%= activitieMerchantRedEnvelope.getActivity_redEnvelope_name()%>
                </div>
                <div class="" style="width: 1.95rem;height: 2.3rem;margin: 0 auto;text-align: center;">
                    <img src="${basePath}<%= activitieMerchant.getRedEnvelope_headPic()%>" style="width: 1.95rem;height: 1.88rem;padding-top: 0.2rem;"/>
                </div>
                <div class="" onclick="songHaoyou('<%= activitieMerchantRedEnvelope.getId()%>','${paymentRecord_id}');" style="width: 1.2rem;height: 0.55rem;background: #fedd00;font-size: 0.3rem;color: #3a3a3a;text-align: center;margin: 0 auto;line-height: 0.55rem;">
                    送好友
                </div>
            </div>

        <%
            }
        %>

    </div>
</div>

<div class="sale_rule" onclick="chang_show_hide();">
    <img src="img/rule.png"/>
</div>


<script type="text/javascript">

    function chang_show_hide(){
        if(  ($('.sale_rule').is(':hidden'))  ){
            $(".sale_rule").show();
        }else{
            $(".sale_rule").hide();
        }
    }

    function songHaoyou(activitieRedEnvelope_id, paymentRecord_id) {
        window.location.href= '${basePath}activities/hongbaoliebian/index.jsp?activitieRedEnvelope_id='+activitieRedEnvelope_id+'&paymentRecord_id='+paymentRecord_id;
    }
</script>

</body>
</html>

