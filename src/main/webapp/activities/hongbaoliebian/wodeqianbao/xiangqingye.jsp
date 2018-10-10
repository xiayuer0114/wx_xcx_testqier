<%@ page import="com.lymava.commons.util.MyUtil" %>
<%@ page import="com.lymava.qier.activities.hongbaoliebian.HongbaoliebianPaymentRecord" %>
<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="com.lymava.nosql.context.SerializContext" %>
<%@ page import="com.lymava.qier.model.xiaoChengXuModel.ShowPub" %>
<%@ page import="com.lymava.base.model.Pub" %>
<%@ page import="com.lymava.qier.activities.model.ActivitieMerchantRedEnvelope" %>
<%@ page import="com.lymava.nosql.mongodb.util.MongoCommand" %>
<%@ page import="com.lymava.qier.model.xiaoChengXuModel.ConfigPub" %><%--
  User: Administrator---SunM
  Date: 2018\9\22 0022
  Time: 14:52
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>

<%
    SerializContext serializContext = ContextUtil.getSerializContext();

    String paymentRecord_id = request.getParameter("paymentRecord_id");
    if(MyUtil.isValid(paymentRecord_id)){
        HongbaoliebianPaymentRecord hongbaoliebianPaymentRecord_find = (HongbaoliebianPaymentRecord)serializContext.get(HongbaoliebianPaymentRecord.class,paymentRecord_id);
        ActivitieMerchantRedEnvelope activitieMerchantRedEnvelope = hongbaoliebianPaymentRecord_find.getActivitie_redEnvelope();
        if (activitieMerchantRedEnvelope != null){
            String merhcnt_id = activitieMerchantRedEnvelope.getMerchant_user_id();
            if(MyUtil.isValid(merhcnt_id)){
                ShowPub showPub_find = new ShowPub();
                showPub_find.setShenghe(Pub.shenghe_tongguo);
                showPub_find.setState(Pub.state_nomal);
                showPub_find.addCommand(MongoCommand.or, "secondPubConlumnId", ConfigPub.getQuyu());
//                showPub_find.addCommand(MongoCommand.or, "secondPubConlumnId", ConfigPub.getZhuanti());
//                showPub_find.addCommand(MongoCommand.or, "secondPubConlumnId", ConfigPub.getLeixingpeizhi());
                showPub_find.setMerchant72_Id(merhcnt_id);
                showPub_find = (ShowPub) serializContext.get(showPub_find);
                if(showPub_find!=null){

                    request.setAttribute("merchnant_name",showPub_find.getName());
                    request.setAttribute("merchnant_head_pic",showPub_find.getMerchant72().getPicname());

                    request.setAttribute("man_avg",showPub_find.getShowAvg());
                    request.setAttribute("yingye_time",showPub_find.getMerchant72().getBusinessHours());

                    request.setAttribute("phone",showPub_find.getMerchant72().getPhone());
                    request.setAttribute("addr",showPub_find.getMerchant72().getAddr());
                    request.setAttribute("pubTitle",showPub_find.getTitle());
                    request.setAttribute("pubSubhead",showPub_find.getSubhead());
                    request.setAttribute("pubContent",showPub_find.getContent());
                }
            }
        }
    }

%>

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
    <link rel="stylesheet" type="text/css" href="css/qianbao.css"/>
    <script type="text/javascript" src="js/jquery-1.12.4.min.js" ></script>
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
<body style="background: #fff;">
<div class="logobeijing mui-row">
    <div class="logobeijing_1 mui-col-xs-1">
        <img src="img/logobeijing.png" />
    </div>
    <div class="logobeijing_2 mui-col-xs-11">
        <div class="beijingwenzi">
            <div class="beijingwenzi_1">
                <%--CNY 160/人--%>
                    CNY ${man_avg}/人
            </div>
        </div>
        <div class="shijian mui-row">
            <div class="shijian-1 mui-col-xs-9">
                <%--10:00-22:00--%>
                    ${yingye_time}
            </div>
            <div class="shijian-1 mui-col-xs-3">
                <div class="juli mui-row">
                    <div class="juli_1 mui-col-xs-4">
                        <%--<img src="img/ditutubiao.png"/>--%>
                    </div>
                    <div class="juli_2 mui-col-xs-8">

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="logo1">
    <%--<img src="img/logo1.png" />--%>
    <img src="${basePath}${merchnant_head_pic}" />
</div>
<div class="shangjiamingzi" style="font-family: SourceHanSansCN-Regular_2;">
    <%--蟹愛餐厅（财富中心店）--%>
    ${merchnant_name}
</div>
<div class="lianxifangshi mui-row">
    <div class="dianhua_1 mui-col-xs-11">
        <%--02367885800--%>
        ${phone}
    </div>
    <div class="dianhua_2 mui-col-xs-1">
        <%--<img src="img/dianhua.png" />--%>
    </div>
</div>
<div class="dizhi mui-row">
    <div class="dizhi_1 mui-col-xs-11">
        <%--渝北区洪湖东路11号附41号--%>
        ${addr}
    </div>
    <div class="dizhi_2 mui-col-xs-1">
        <%--<img src="img/dizhi.png" />--%>
    </div>
</div>

<div class="reirong">

    <p style="font-size: 0.36rem;color: #000;margin-left: 0.32rem;padding-top: 0.4rem;font-family: SourceHanSansCN-Regular_2;">
        <%--所有的乡愁都是因为馋--%>
        ${pubTitle}
    </p>
    <p style="font-size: 0.24rem;color: #000;margin-left: 0.32rem;">
        <%--探秘师：阿水儿 摄影：张令奇--%>
        ${pubSubhead}
    </p>

    <div style="width: 7rem;font-size: 0.24rem;color: #848484;margin-left: 0.32rem;">
            ${pubContent}
    </div>
</div>
<div class="xiantiandibu mui-row">
    <%--<div class="xiantiandibu_1">--%>
        <%--相关标签--%>
    <%--</div>--%>
    <%--<div class="xiantiandibu_2_1 mui-row">--%>
        <%--<div class="xiantiandibu_2 mui-col-xs-2">--%>
            <%--地方菜--%>
        <%--</div>--%>
        <%--<div class="xiantiandibu_3 mui-col-xs-2">--%>
            <%--川菜--%>
        <%--</div>--%>
    <%--</div>--%>
</div>

</body>
</html>

