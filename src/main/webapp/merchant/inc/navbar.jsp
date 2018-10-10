<%@page import="com.lymava.qier.model.Merchant72"%>
<%@page import="com.lymava.qier.util.QierUtil"%>
<%@page import="com.lymava.commons.state.StatusCode"%>
<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.commons.exception.CheckException"%>
<%@page import="com.lymava.base.model.User"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.base.util.WebConfigContent"%>
<%@ page import="com.lymava.wechat.gongzhonghao.Gongzonghao" %>
<%@ page import="com.lymava.wechat.gongzhonghao.GongzonghaoContent" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="com.lymava.commons.util.QrCodeUtil" %>
<%@ page import="org.apache.commons.io.output.ByteArrayOutputStream" %>
<%@ page import="com.lymava.commons.util.ImageUtil" %>
<%@ page import="com.lymava.userfront.util.FrontUtil" %>
<%@ page import="com.lymava.commons.cache.SimpleCache" %>
<%@ page import="com.lymava.qier.model.SendInformLog" %>
<%@ page import="com.lymava.nosql.util.QuerySort" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="com.lymava.qier.util.SunmingUtil" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.lymava.commons.util.DateUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%


    User init_http_user = FrontUtil.init_http_user(request);
    CheckException.checkIsTure(init_http_user != null, "请先登录!", StatusCode.USER_INFO_TIMEOUT);

    Merchant72 merchant72 = QierUtil.getMerchant72User(init_http_user);

    String sessionId_user = request.getParameter("sessionId")+ init_http_user.getId();
    SimpleCache.cache_object(sessionId_user,init_http_user);

    String description = WebConfigContent.getConfig("description");
    String basePath_ = MyUtil.getBasePath(request);

    request.setAttribute("basePath",basePath_);

    request.setAttribute("webtitle",WebConfigContent.getConfig("webtitle"));
    request.setAttribute("description", description);


    // 孙M   7.2   检测这个后台有没有给这个商家发提示的信息
    SendInformLog sendInformLog_find = new SendInformLog();

    sendInformLog_find.setMerchantId(merchant72.getId());
    sendInformLog_find.setStart(SendInformLog.start_send);   // 状态为 已发送 的数据
    sendInformLog_find.initQuerySort("sendTime", QuerySort.desc);

    SendInformLog sendInformLog = (SendInformLog)ContextUtil.getSerializContext().findOneInlist(sendInformLog_find);

    Integer infoCount = 0;
    String sendTime = "";

    if(sendInformLog != null){
        infoCount = 1;

        Date date = new Date(sendInformLog.getSendTime());
        SimpleDateFormat simpleDateFormat = DateUtil.getSdfShort();
        String dateStr = simpleDateFormat.format(date);

        sendTime =  dateStr;
    }

    request.setAttribute("infoCount",infoCount);   // 日志信息的条数
    request.setAttribute("sendTime",sendTime);   // 最后一次提示的时间


    // 生成'绑定我的微信'的二维码图片路径
    Gongzonghao gongzonghao = GongzonghaoContent.getInstance().getDefaultGongzonghao();

    String recall_url = MyUtil.getBasePath(request)+"qier/cashier/bindMerchantWeChat.do?sessionId_user="+sessionId_user;
    String create_recall_url = gongzonghao.create_recall_url(recall_url,null,null);

    Integer qrcode_size = 400;
    BufferedImage bufferedImage =  QrCodeUtil.createQrBufferedImage(create_recall_url,qrcode_size);
    ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
    ImageUtil.write(bufferedImage,byteArrayOutputStream);
    String realPath = application.getRealPath("/");
    String temp_pic_path = MyUtil.savePic(byteArrayOutputStream.toByteArray(),realPath);

    request.setAttribute("temp_pic_path3",temp_pic_path);
    request.setAttribute("merchant72",merchant72);
%>
<span id="infoCount" value="${infoCount}"></span>
<span id="sendTime" value="${sendTime}"></span>

<script type="text/javascript">

    var infoCount = $("#infoCount").attr("value");
    var sendTime = $("#sendTime").attr("value");


    if(infoCount != null  && infoCount != ""  && infoCount != 0){
        layer.open({
            type: 1,
            shadeClose: false, //点击遮罩关闭
            area: ['605px'],
            content: '<img src="/merchant/img/prompMessage.jpg" style="width: 600px;height: 450px">',
            title:'悠择于'+sendTime+'提示您',
            btn:['好的,我知道了'],
            btn1:function(){
                layer.closeAll();
            },
            end:function () {
                $.post("${basePath}qier/cashier/readMessage.do");
            }
        });
    }

</script>
<div class="page-header navbar navbar-fixed-top">
    <div class="page-header-inner ">
        <div class="page-logo" style="width: 254px;">
            <a href="#">
                <img src="${basePath }img/top.png" alt="悠择生活" width="165" height="55">
            </a>
            <div class="menu-toggler sidebar-toggler">
            </div>
        </div>
        <a href="javascript:;" class="menu-toggler responsive-toggler" data-toggle="collapse" data-target=".navbar-collapse"> </a>
        <div class="page-top">
            <div class="top-menu">
                <ul class="nav navbar-nav pull-right">
                    <li class="dropdown dropdown-user dropdown-dark">
                        <a style="padding:27px 10px 27px;" href="javascript:;" class="dropdown-toggle" data-toggle="dropdown" data-hover="dropdown" data-close-others="true">
                                    <span class="username username-hide-on-mobile">
                                        <span aria-hidden="true" class="icon-user"></span>
                                        个人中心(${front_user.showName })
                                        ,余额:${front_user.showMerchant_balance}
                                        <c:if test="${!empty  front_user.queryHour}">
                                            ,结帐时间:每日 <span id="front_userQueryHour">${front_user.queryHour}</span>时
                                        </c:if>

                                        <script type="text/javascript">
                                            function selShijian() {
                                                ajax_get(basePath+"merchant/business_page/manager_center/set_jiezhang_time.jsp",function(html_content){
                                                    layer.open({
                                                        type: 1,
                                                        shadeClose: true, //点击遮罩关闭
                                                        content: html_content,
                                                        btn:['保存','取消'],
                                                        btn1:function(){

                                                            var selHour = $(".selHour").val();
                                                            var state_auto_voice_value = $(".state_auto_voice").val();
                                                            var state_shaoma_yuzhi_value = $(".state_shaoma_yuzhi").val();

                                                            var request_data = {
                                                                "selHour":selHour
                                                                ,"state_auto_voice":state_auto_voice_value
                                                                ,"state_shaoma_yuzhi":state_shaoma_yuzhi_value
                                                            };

                                                            var request_url = "${basePath}merchant/business_page/manager_center/set_jiezhang_time_save.jsp";

                                                            ajax_post(request_url,request_data,function(msg){
                                                                layer.closeAll();
                                                                var data = JSON.parse(msg);
                                                                if(data.statusCode == "200"){
                                                                    layer.msg("设置成功");
                                                                }else{
                                                                    layer.msg(msg.message);
                                                                }
                                                                $("#front_userQueryHour").text(selHour);
                                                            });
                                                        }
                                                    });
                                                });
                                            }

                                            function print_set() {
                                                ajax_get(basePath+"merchant/business_page/manager_center/print_set.jsp?",function(print_set_html){
                                                    layer.open({
                                                        type: 1,
                                                        shadeClose: true, //点击遮罩关闭
                                                        content: print_set_html,
                                                        btn:['保存','取消'],
                                                        btn1:function(){

                                                            var request_data = $('#print_set_form').serializeArray();

                                                            default_printer_name = $('#default_printer_name').val();

                                                            ajax_post("${basePath}merchant/business_page/manager_center/print_set_save.jsp",request_data,function(msg){

                                                            });

                                                            layer.closeAll();
                                                        }
                                                    });

                                                    var LODOP_tmp = getLodop();
                                                    if(checkNotNull(LODOP_tmp)){
                                                        var iPrinterCount=LODOP_tmp.GET_PRINTER_COUNT();
                                                        var html_tmp = "";
                                                        for(var i=0;i<iPrinterCount;i++){
                                                            var printer_name = LODOP_tmp.GET_PRINTER_NAME(i);
                                                            var selected_html = '';
                                                            if(printer_name ==  $('#default_printer_name').attr("svalue")){
                                                                selected_html = 'selected="selected"';
                                                            }
 
                                                            html_tmp += '<option '+selected_html+' value="'+printer_name+'">'+printer_name+'</option>';
                                                        };
                                                        $('#default_printer_name').html(html_tmp);
                                                    }

                                                });
                                            }

                                            function pay_password_set() {
                                                ajax_get(basePath+"merchant/business_page/manager_center/pay_password_set.jsp",function(print_set_html){
                                                    layer.open({
                                                        type: 1,
                                                        shadeClose: true, //点击遮罩关闭
                                                        content: print_set_html,
                                                        btn:['确认修改','取消'],
                                                        btn1:function(){

                                                            var request_data = $('#pay_password_set').serializeArray();

                                                            ajax_post("${basePath}merchant/business_page/manager_center/pay_password_set_save.jsp",request_data,function(msg){

                                                                var data = JSON.parse(msg);

                                                                if(data.statusCode == "200"){
                                                                    layer.closeAll();
                                                                    layer.msg(data.message);
                                                                }else{
                                                                    layer.msg(data.message);
                                                                }
                                                            });

                                                        }
                                                    });

                                                });
                                            }

                                            // 绑定我的微信
                                            function bindMerchantWeChat() {
                                                layer.open({
                                                    type: 1,
                                                    area: ['300px', '350px'],
                                                    shadeClose: true, //点击遮罩关闭
                                                    content: '\ <br><center> <img src="${basePath}${temp_pic_path3}" width="240" height="240"> <br>绑定我的微信 </center> '
                                                });
                                            }
                                        </script>
                                    </span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-default">
                            <li style="margin-bottom:10px;">
                                <a href="javascript:void(0)" onclick="selShijian();" >
                                    <i class="icon-settings"></i> 系统设置</a>
                            </li>

                            <li style="margin-bottom:10px;">
                                <a href="javascript:void(0)" onclick="bindMerchantWeChat();" >
                                    <i class="icon-user-following"></i> 绑定我的微信</a>
                            </li>
                            <li style="margin-bottom:10px;">
                                <a href="javascript:void(0)" onclick="print_set();" >
                                    <i class="icon-printer"></i> 打印设置</a>
                            </li>
                            <c:if test="${merchant72.id ==  front_user.id}">
                                <li style="margin-bottom:10px;">
                                    <a href="javascript:void(0)" onclick="pay_password_set();" >
                                        <i class="icon-printer"></i> 修改支付密码</a>
                                </li>
                            </c:if>
                            <li style="margin-bottom:10px;">
                                <a href="javascript:void(0)" onclick="shouyinpai_yuluru_show();" >
                                    <i class="icon-printer"></i> 收银牌金额预设</a>
                            </li>
                            <li style="margin-bottom:10px;">
                                <a href="${basePath }merchant/loginOut.jsp" >
                                    <i class="icon-logout"></i> 退出登录 </a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</div>
<div class="clearfix"> </div>