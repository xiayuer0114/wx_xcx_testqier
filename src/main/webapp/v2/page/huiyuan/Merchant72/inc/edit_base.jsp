<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.trade.util.WebConfigContentTrade"%>
<%@page import="com.lymava.qier.action.MerchantShowAction"%>
<%@page import="java.util.UUID"%>
<%@page import="com.lymava.commons.util.Md5Util"%>
<%@page import="com.lymava.base.model.User"%>
<%@page import="com.lymava.base.model.Pub"%>
<%@ page import="com.lymava.qier.model.Merchant72" %>
<%@ page import="com.lymava.qier.action.CashierAction" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<fieldset  >
			<dl>
				<dt>登录名：</dt>
				<dd> 
					<input type="text"  name="user.username"  value="<c:out value="${user.username }" escapeXml="true"/>"   class="required" <c:if test="${!empty user.id }">readonly="readonly"</c:if>  > 
					<input type="hidden" name="user.id" value="${user.id }"   >
				</dd>
			</dl>  
			<c:if test="${empty user.id}">
			<div class="divider"></div> 
				<dl>
					<dt>登录密码：</dt>
					<dd>
						<input type="password" name="password" value=""  autocomplete="off"> 
					</dd>
				</dl> 
				<dl>
					<dt>密码确认：</dt>
					<dd>
						<input type="password" name="passwdRe" value=""  autocomplete="off"> 
					</dd>
				</dl> 
			</c:if>  
			<div class="divider"></div> 
			<dl >
				<dt>上级用户：</dt>
				<dd class="lookup_dd"> 
					<input type="text"  bringBack="topuser.showName"   value="<c:out value="${user.topUser.nickname }" escapeXml="true"/>"   > 
					<input type="hidden" bringBack="topuser.userId" name="topuser.userId" value="${user.topUserId }"    >
					<a  class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%=WebConfigContentTrade.getInstance().getMerchantUserGroupId() %>" lookupGroup="topuser"  rel="topuser_lookup">查找</a>
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl >
				<dt>共享额度：</dt>
				<dd>
						<select name="user.share_balance" style="width: 155px;" class="required combox" svalue="${user.share_balance}">
								<option value="<%=User.share_balance_no %>" >不共享</option>
								<option   value="<%=User.share_balance_yes %>"  >共享</option>
						</select> 
				</dd>
			</dl>
			<dl >
				<dt>共享红包池</dt>
				<dd>
						<select name="user.merchant_redenvelope_share" style="width: 155px;" class="required combox" svalue="${user.merchant_redenvelope_share}">
								<option value="<%=State.STATE_FALSE %>" >不共享</option>
								<option   value="<%=State.STATE_OK %>"  >共享</option>
						</select> 
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl class="lookup_dd">
						<dt>用户组：</dt>
						<dd>
							<input type="hidden" name="userGroup.id"  value="<c:out value="${user.userGroupId }" escapeXml="true"/>"    class="required">
							<input type="text" name="userGroup.name"  value="<c:out value="${user.userGroup.name }" escapeXml="true"/>"    class="required">
							<a lookupgroup="userGroup" href="${basePath }v2/usergroup/list.do?return_mod=lookup" class="btnLook"  >查找</a>
						</dd>
			</dl> 
			<dl>
				<dt>支付状态</dt>
				<dd>
						<select name="user.payPwdState" style="width: 155px;" class="required combox" svalue="${user.payPwdState }">
								<option value="<%=User.payPwdState_STATE_NOTOK %>"  >不启用支付密码</option>
								<option  value="<%=User.payPwdState_STATE_OK %>" >启用支付密码</option>
						</select> 
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>状态：</dt>
				<dd>
						<select name="user.state" style="width: 155px;" class="required combox" svalue="${user.state }">
							<option  value="<%=User.STATE_NOTJIHUO %>" >未激活</option>
							<option  value="<%=User.STATE_OK %>" >正常</option>
							<option value="<%=User.STATE_NOTOK %>"  >暂停使用</option>
						</select>
				</dd>
			</dl>
			<dl>
				<dt>日流水：</dt>
				<dd>
					<input type="text" name="user.inOneDayLiuShui" value="<c:out value="${user.inOneDayLiuShui }" escapeXml="true"/>"  class="required">
				</dd>
			</dl>
			<div class="divider"></div>
			<dl>
				<dt>商户类型：</dt>
				<dd class="lookup_dd">
                    <input type="text"  bringBack="merchant72_type.pubName"  name="user.merchant72_type"  value='<c:out value="${user.merchant72_type }" escapeXml="true"/>'   class="required"  readonly="readonly" >
                    <a mask='true'   class="btnLook" href="${basePath }v2/pub/listPub.do?return_mod=lookup&pubConlumnId=<%=MerchantShowAction.getShangPingLeixingId()%>" lookupGroup="merchant72_type"  rel="merchant72_type">查找类型</a>
				</dd>
			</dl>
			<dl>
				<dt>业务员：</dt>
				<dd class="lookup_dd">
					<input type="text"   bringBack="salesman.userv2ShowName"  value='<c:out value="${user.userv2_yewuyuan.realName}" escapeXml="true"/>'  readonly="readonly" class="required" >
					<input type="hidden" bringBack="salesman.userV2Id"     name="user.userv2_yewuyuan_id"  value='<c:out value="${user.userv2_yewuyuan_id }" escapeXml="true"/>'    >
					<a mask='true' class="btnLook" href="${basePath }v2/userv2/list.do?return_mod=lookup" lookupGroup="salesman" rel="salesman">查找类型</a>
				</dd>
			</dl>
			<div class="divider"></div>
			<dl>
				<dt>营销类型：</dt>
				<dd  >
                    <select name="user.receive_red_envelope_lingqu_type"   class="required combox" svalue="${user.receive_red_envelope_lingqu_type }">
							<option  value="<%=Merchant72.receive_red_envelope_lingqu_type_xinkehu %>" >新客户营销</option>
							<option  value="<%=Merchant72.amount_type_trade_bili_laokehu %>" >老客户营销</option>
					</select>
				</dd>
			</dl>
			<dl>
				<dt style="font-size: 0.8rem;">红包生成类型</dt>
				<dd class="lookup_dd">
                     <select name="user.receive_red_envelope_create_type"   class="required combox" svalue="${user.receive_red_envelope_create_type }">
							<option  value="<%=Merchant72.receive_red_envelope_create_type_autocraete %>" >自动生成定向红包</option>
							<option  value="<%=Merchant72.amount_type_trade_bili_xinkehu_manual %>" >手动生成定向红包</option>
					</select>
				</dd>
			</dl>
			<div class="divider"></div>
			<dl>
				<dt>营业时间 :</dt>
				<dd>
					<input type="text" name="user.businessHours" value="<c:out value="${user.businessHours }" escapeXml="true"/>"  >
				</dd>
			</dl>
			<dl>
				<dt style="width: 160px;font-size: 0.8rem;">领定向订单金额(大于0生效)</dt>
					<dd style="width: 50px;">
						<input  class="number" style="width: 30px;"  type="text" name="user.inReceive_red_envelope_order_price_yuan" value="<c:out value="${user.receive_red_envelope_order_price_fen/100 }" escapeXml="true"/>"  >元
					</dd>
			</dl>
			<div class="divider"></div>
			<dl>
				<dt>经度：</dt>
				<dd>
					<input type="text" bringBack="shopmap.longitude"  name="user.inLongitude" value="<c:out value="${user.longitude}" escapeXml="true"/>"    style="width: 100px;">
				</dd>
			</dl>

			<dl style="width: 400px;">
				<dt>纬度：</dt>
				<dd  style="width: 320px;">
					<input type="text"  bringBack="shopmap.latitude" name="user.inLatitude" value="<c:out value="${user.latitude }" escapeXml="true"/>"    style="width: 100px;">
					<a id="shiqua" style="background:none;text-indent:0px;width:150px;overflow:hidden;line-height:15px;height:15px;"  class="btnLook" href="${basePath }v2/page/map/shiqu.jsp"  lookupGroup="shopmap"  rel="shopmap">坐标拾取-鼠标点击拾取坐标</a>
				</dd>
			</dl>
		</fieldset>