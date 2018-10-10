<%@page import="com.lymava.qier.model.SettlementBank"%>
<%@page import="com.lymava.qier.action.Merchant72UserAction"%>
<%@page import="com.lymava.qier.model.Merchant72"%>
<%@ page import="com.lymava.commons.state.State" %>
<%@ page import="com.lymava.qier.action.Merchant72UserAction" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    jQuery(function(){
        uploadInitMy();
        resetDialog();
    });
</script>

<div class="pageContent">
    <form method="post" action="${basePath }v2/merchant72user/changBank.do" class="pageForm required-validate" onsubmit="return validateCallback(this, navTabAjaxDone);">
        <div class="pageFormContent" layoutH="56">
            <fieldset  >
                <dl>
                    <dt>登录名称：</dt>
                    <dd  >
                        <input type="text" name="user.username" value="<c:out value="${user.username }" escapeXml="true" />" readonly="readonly" >
                    </dd>
                </dl>
                <div class="divider"></div>
                <dl>
                    <dt>昵称：</dt>
                    <dd  >
                        <input type="text" name="user.nickname" value="<c:out value="${user.nickname }" escapeXml="true" />"  readonly="readonly" >
                        <input type="hidden" name="settBank.merchant72_id" value="<c:out value="${user.id }" escapeXml="true" />"  readonly="readonly" >
                        <input type="hidden" name="settBank.id" value="<c:out value="${settBank.id }" escapeXml="true" />"  readonly="readonly" >
                    </dd>
                </dl>
                <div class="divider"></div>
                <dl>
                    <dt>银行名称：</dt>
                    <dd>
                        <select name="settBank.bank_type" style="width: 155px;" class="required combox" svalue="${settBank.bank_type }">
                            <option  value="<%=SettlementBank.bank_type_gongshang %>"  >工商银行</option>
                            <option  value="<%=SettlementBank.bank_type_zhaoshang %>"  >招商银行</option>
                            <option  value="<%=SettlementBank.bank_type_nongye %>"  >农业银行</option>
                            <option  value="<%=SettlementBank.bank_type_jianshe %>"  >建设银行</option>
                            <option  value="<%=SettlementBank.bank_type_zhongguo %>"  >中国银行</option>
                            <option  value="<%=SettlementBank.bank_type_guangda %>"  >光大银行</option>
                            <option  value="<%=SettlementBank.bank_type_xingye %>"  >兴业银行</option>
                            <option  value="<%=SettlementBank.bank_type_minsheng %>"  >民生银行</option>
                            <option  value="<%=SettlementBank.bank_type_huaxia %>"  >华夏银行</option>
                            <option  value="<%=SettlementBank.bank_type_cq_nongshanghang %>"  >重庆农村商业银行</option>
                            <option  value="<%=SettlementBank.bank_type_guangfa %>"  >广发银行</option>
                            <option  value="<%=SettlementBank.bank_type_jiaotong %>"  >交通银行</option>
                            <option  value="<%=SettlementBank.bank_type_pingan %>"  >平安银行</option>
                            <option  value="<%=SettlementBank.bank_type_shanghaipudongfazhan %>"  >上海浦东发展银行</option>
                            <option  value="<%=SettlementBank.bank_type_chongqingyinhang %>"  >重庆银行</option>
                            <option  value="<%=SettlementBank.bank_type_hengfeng %>"  >恒丰银行</option>
                            <option  value="<%=SettlementBank.bank_type_ningbo %>"  >宁波银行</option>
                            <option  value="<%=SettlementBank.bank_type_weizhi %>"  >未知</option>
                        </select>
                    </dd>
                </dl>
                <div class="divider"></div>
                <dl>
                    <dt>开户行：</dt>
                    <dd  >
                        <input type="text" name="settBank.depositary_bank" value="${settBank.depositary_bank}" class=""   >
                    </dd>
                </dl>
                <div class="divider"></div>
                <dl>
                    <dt>卡号/账号：</dt>
                    <dd  >
                        <input type="text" name="settBank.account" value="${settBank.account}" class="required"   >
                    </dd>
                </dl>
                 <div class="divider"></div>
                <dl>
                    <dt>收方行地址：</dt>
                    <dd  >
                        <input type="text" name="settBank.bank_addr" value="${settBank.bank_addr}" class="required"   >
                    </dd>
                </dl>
                <div class="divider"></div>
                <dl>
                    <dt>账户名称：</dt>
                    <dd  >
                        <input type="text" name="settBank.name" value="${settBank.name}" class="required"    >
                    </dd>
                </dl>
                <div class="divider"></div>

                <dl>
                    <dt>状态：</dt>

                    <dd>
                        <select name="settBank.state" style="width: 155px;" class="required combox" svalue="${settBank.state }">
                            <option  value="<%=State.STATE_OK %>" selected="selected">正常使用</option>
                            <option value="<%=State.STATE_FALSE %>" >暂停使用</option>
                        </select>
                    </dd>
                </dl>

                <div class="divider"></div>
                <dl class="nowrap" >
                    <dt>变更凭证</dt>
                    <dd>
                        <input class="mydisupload required"   fileNumLimit="1" name="object.pinzheng"  type="hidden"  value="" />
                    </dd>
                </dl>

                <div class="divider"></div>
                <dl>
                    <dt>备注说明：</dt>
                    <dd  >
                        <input type="text" name="settBank.memo" value="${settBank.memo}" class=""   >
                    </dd>
                </dl>
            </fieldset>
        </div>
        <div class="formBar">
            <ul>
                <li><div class="buttonActive"><div class="buttonContent"><button type="submit">提交审核</button></div></div></li>
                <li>
                    <div class="button"><div class="buttonContent"><button type="button" class="close">取消</button></div></div>
                </li>
            </ul>
        </div>
    </form>
</div>
