<%@page import="com.lymava.commons.util.Md5Util"%>
<%@page import="com.lymava.commons.vo.EntityKeyValue"%>
<%@page import="java.util.LinkedList"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.base.util.FinalVariable"%>
<%@page import="com.lymava.commons.exception.CheckException"%>
<%@page import="com.lymava.base.model.User"%>
<%@ page import="com.lymava.qier.model.TradeRecord72" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lymava.wechat.gongzhonghao.Gongzonghao" %>
<%@ page import="com.lymava.wechat.gongzhonghao.GongzonghaoContent" %>
<%@ page import="com.lymava.commons.util.MyUtil" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="com.lymava.commons.util.QrCodeUtil" %>
<%@ page import="com.lymava.commons.util.ImageUtil" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="java.io.ByteArrayOutputStream" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	User user = (User) request.getAttribute(FinalVariable.SESSION_FRONT_FULL_USER);
    CheckException.checkIsTure(user != null, "请先登录！");

    request.getSession().setAttribute("userInfo",user);

    // 设置微信扫码后跳转的路径
    String recall_url = MyUtil.getBasePath(request)+"qier/cashier/getUserOpenId.do";

    // ^^^配置请求参数
    String user_id = user.getId();
    String user_key = user.getKey();
	String rand_code = System.currentTimeMillis()+"";
	String user_sign = Md5Util.MD5Normal(user_key + rand_code.toLowerCase());

	// ^^^设置跳转的路径后的请求参数
	List<EntityKeyValue> call_back_parameter = new LinkedList<EntityKeyValue>();
	call_back_parameter.add(new EntityKeyValue("user_id",user_id));
	call_back_parameter.add(new EntityKeyValue("rand_code",rand_code));
	call_back_parameter.add(new EntityKeyValue("user_sign",user_sign));

    Gongzonghao gongzonghao = GongzonghaoContent.getInstance().getDefaultGongzonghao();
    // ↓ 二维码的里面的实际内容
	String create_recall_url = gongzonghao.create_recall_url(recall_url,call_back_parameter,null);
	
    // 生成二维码的图片路径  大小:400px
	Integer qrcode_size = 400;
    
    BufferedImage bufferedImage =  QrCodeUtil.createQrBufferedImage(create_recall_url,qrcode_size);
    
    ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
    ImageUtil.write(bufferedImage,byteArrayOutputStream);
    
    String realPath = application.getRealPath("/");
    
    String temp_pic_path = MyUtil.savePic(byteArrayOutputStream.toByteArray(),realPath);

    request.setAttribute("temp_pic_path1",temp_pic_path);
%>
                <!-- BEGIN CONTENT BODY -->
                <div class="page-content">
                    <!-- BEGIN PAGE BASE CONTENT -->
                    <div class="row">
                        <div class="col-md-12">
                            <div class="portlet light bordered" id="form_wizard_1">
                                <div class="portlet-title">
                                    <div class="caption">
                                        <i class="fa fa-flag-checkered font-green"></i>
                                        <span class="caption-subject font-green bold uppercase"> 我的信息
                                        </span>
                                    </div>
                                </div>
                                <div>
                                    <table>
                                        <tr height="40">
                                            <td width="200"></td>
                                            <td width="100"> 昵 称: </td>
                                            <td width="200">${userInfo.nickname}</td>
                                            <td>扫描变更收款通知微信号</td>
                                        </tr>
                                        <tr height="40">
                                            <td width="200"></td>
                                            <td width="100"> 姓 名: </td>
                                            <td width="200">${userInfo.realname}</td>
                                            <td rowspan="4"><img src="${basePath}${temp_pic_path1}" width="240" height="240" alt=""></td>
                                        </tr>
                                        <tr height="40">
                                            <td width="200"></td>
                                            <td width="100"> 省 份: </td>
                                            <td>${userInfo.sheng}</td>
                                        </tr>
                                        <tr height="40">
                                            <td width="200"></td>
                                            <td width="100"> 市 名: </td>
                                            <td>${userInfo.shi}</td>
                                        </tr>
                                        <tr height="40">
                                            <td width="200"></td>
                                            <td width="100"> 地 区: </td>
                                            <td>${userInfo.qu}</td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
<script type="text/javascript">
    function binding() {
        jQuery.ajax({
            type : "post",
            url : "${basePath }merchant/business_page/cashier/cashier_add.jsp?isMerchant=true",
            data : "",
            success : function(msg) {
                modal_current_show(msg);
            }
        });
    }
</script>