<%@page import="com.lymava.base.util.WebConfigContent"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@ page import="com.lymava.wechat.gongzhonghao.Gongzonghao" %>
<%@ page import="com.lymava.wechat.gongzhonghao.GongzonghaoContent" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="com.lymava.commons.util.QrCodeUtil" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page import="com.lymava.commons.util.ImageUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<% 	request.setAttribute("basePath", MyUtil.getBasePath(request)); %>
<%
    String description = WebConfigContent.getConfig("description");
    String basePath_ = MyUtil.getBasePath(request);

    request.setAttribute("basePath",basePath_);

    request.setAttribute("webtitle",WebConfigContent.getConfig("webtitle"));
    request.setAttribute("description", description);


    // 生成'扫码登录'的二维码图片路径
    Gongzonghao gongzonghao = GongzonghaoContent.getInstance().getDefaultGongzonghao();

    String sessionId = request.getSession().getId();

    request.setAttribute("saomaSessionId",sessionId);

    String recall_url = MyUtil.getBasePath(request)+"qier/cashier/saomaLogin.do?sessionId="+sessionId;
    String create_recall_url = gongzonghao.create_recall_url(recall_url,null,null);

    Integer qrcode_size = 400;
    BufferedImage bufferedImage =  QrCodeUtil.createQrBufferedImage(create_recall_url,qrcode_size);
    ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
    ImageUtil.write(bufferedImage,byteArrayOutputStream);
    String realPath = application.getRealPath("/");
    String temp_pic_path = MyUtil.savePic(byteArrayOutputStream.toByteArray(),realPath);

    request.setAttribute("temp_pic_path2",temp_pic_path);

%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
    <meta name="description" content="" />
    <meta name="keywords" content="${description }" />
    <title>${title }</title>
    <link rel="stylesheet" href="${basePath }merchant/css/login.css" />
    <%--<link rel="stylesheet" href="${basePath }/css/login.css" />--%>
    <%--<link rel="stylesheet" href="${basePath }merchant/css/global.css" />--%>
    <script src="${basePath }merchant/assets/jquery.min.js" type="text/javascript"></script>
    <script type="text/javascript">var basePath = '${basePath }';</script>
    <script type="text/javascript" src="${basePath }plugin/js/md5.js"></script>
    <script type="text/javascript" src="${basePath }plugin/js/lymava_common.js"></script>
    <script type="text/javascript" src="${basePath }merchant/js/merchant.js"></script>
    <script type="text/javascript" src="${basePath }merchanr_center/js/layer-v3.1.0/layer/layer.js"></script>
    <script type="text/javascript">

        // todo  未测试!.  测试通过  但需考虑多个账户绑定了一个openid的情况
        // 弹出扫描二维码登录的界面
        function saomaLogin() {

            <%--xunhuanCheckLogin(${saomaSessionId});--%>
            layer.open({
                type: 1,
                area: ['300px', '350px'],
                shadeClose: true, //点击遮罩关闭
                content: '\ <br><center> <img src="${basePath}${temp_pic_path2}" width="240" height="240"> <br>扫码登录 </center> '
            });

            var sessionId = $("#sessionId").attr("value");
            xunhuanCheckLogin(sessionId);
        }

        // 循环判断用户是否扫描二维码
        function xunhuanCheckLogin(sessionId) {

            var timer;

            // 循环判断用户是否扫描二维码
            var handler = function(){
                $.post("${basePath}/qier/cashier/checkSaomaLogin.do",{"sessionId":sessionId},function(msg) {
                    var res = json2obj(msg);
                    if(res.statusCode == "200"){
                        clearInterval(timer);
                        document.forms['index'].submit();
                    }
                })
            }

            timer = setInterval(handler,500); //每0.5秒去判断一次

            // 一分四十秒后 结束判断
            function cleartime(){clearInterval(timer);};
            setTimeout(cleartime,1000*100);
        }

        jQuery(function(){
            jQuery(document).keypress(function(e) {

                // 兼容FF和IE和Opera
                var theEvent = e || window.event;
                var code = theEvent.keyCode || theEvent.which || theEvent.charCode;
                if (code == 13) {
                    var username = jQuery('#username').val();
                    var password = jQuery('#password').val();
                    var randCode = jQuery('#randCode').val();

                    if(checkNotNull(username) && checkNotNull(password) && checkNotNull(randCode)){
                        login();
                    }
                }

            });

        });
        function  loadOk(){
            jQuery('#username').focus();
        }
        var i = 0;
        function randChange(){
            jQuery('#randChangeId').attr("src","${basePath }rand/getImageRand.do?i="+i);
            i++;
        }
    </script>
</head>
<body onload="loadOk();">
<form action="${basePath }merchant/" name="index" id="index">
</form>
<span id="sessionId" value="${saomaSessionId}"></span>

<div class="g-header">
    <div class="h-box clearfix">
        <div class="fl">
            <img src="img/yorz.png"  style="width: 280px; height: 60px; "/>
        </div>
    </div>
</div>
<div class="g-main">
    <div class="pos-r">
        <div style=" height: 551px;overflow: hidden; width: 100%;">
            <div style="text-align: center;height: 551px;">
                <div class="bg-img"></div>
            </div>

            <div class="slot slot-main-02 pageLayout" id="login">
                <form id="loginForm" name="loginForm" >
                    <input type="hidden" name="ping" id="ping" />
                    <input type="hidden" name="rand" id="rand" />
                    <input type="hidden" name="macAddress" id="macAddress" />
                    <input type="hidden" name="wbtype" id="wbtype" value="1" />

                    <div class="m-table">
                        <div class="user">
                            用户登录 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span onclick="saomaLogin();">扫码登录</span>
                        </div>
                        <div class="user-img">
                            <center><hr width="85%"></center>
                            <%--<img src="img/bg-1.png" />--%>
                        </div>
                        <div class="users clearfix">
                            <div class="fl mag-l35">
                                <img src="img/user.png" />
                            </div>
                            <div class="fl">
                                <input  type="text" placeholder="请输入用户名" name="username" id="username" />
                            </div>
                        </div>
                        <div class="users clearfix">
                            <div class="fl mag-l35">
                                <img src="img/Password.png" />
                            </div>
                            <div class="fl">
                                <input type="Password" placeholder="请输入密码" name="password" id="password" />
                            </div>
                        </div>
                        <div class="yz clearfix">
                        	<div class="fl" style="margin-left: 0px;width: 35px;height: 100%;">
                                &nbsp;
                            </div>  
                            <div class="fl" style="margin-left: 0px;">
                                <input style="margin: 0;float: left;" type="text" class="input-small" name="randCode" id="randCode"  autocomplete="off" maxlength="8" placeholder="验证码"/>
                            </div> 
                            <div class="fl" style="margin-left: 2px;">
                                <a href="javascript:randChange();">
                                    <img id="randChangeId" onclick="randChange()" width="100" src="${basePath }rand/getImageRand.do?t=<%=System.currentTimeMillis()%>" height="40" title="看不清？点击更换另一个。"/>
                                </a>
                            </div>
                        </div>

                        <div class="m-login">
                            <a href="javascript:void(0)" target="_self" onclick="login()">登录</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>



    </div>
</div>
<div class="footer"></div>
</body>
</html>
