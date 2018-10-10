<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
					<dl> 
						<dt>系统编号：</dt>
						<dd>
							<c:out value="${object.id }" escapeXml="true"/>
							<input type="hidden" name="object.id"  value="<c:out value="${object.id }" escapeXml="true"/>">
						</dd>
					</dl> 
					<div class="divider"></div>
					<dl>
						<dt>管理员名：</dt>
						<dd>
							<c:out value="${object.userV2.userName }" escapeXml="true"/>
						</dd>
					</dl>
					<div class="divider"></div>
					<dl>
						<dt>商户流水：</dt>
						<dd>
							<c:out value="${object.requestFlow }" escapeXml="true"/>
						</dd>
					</dl>  
					<div class="divider"></div> 
					<dl>
						<dt>用户登录名</dt>
						<dd>
							 <c:out value="${object.user_huiyuan.username }" escapeXml="true"/>
						</dd>
					</dl>
					<dl>
						<dt>用户名称</dt>
						<dd>
							 <c:out value="${object.user_huiyuan.nickname }" escapeXml="true"/>
						</dd>
					</dl> 
					<div class="divider"></div>
					<dl>
						<dt>业务名称：</dt>
						<dd>
							 <c:out value="${object.business.businessName }" escapeXml="true"/>
						</dd>
					</dl> 
					<div class="divider"></div>
					<dl>
						<dt>付款帐号</dt>
						<dd>
							 <c:out value="${object.pay_account_no }" escapeXml="true"/>
						</dd>
					</dl> 
					<dl>
						<dt>商户卡号</dt>
						<dd>
							 <c:out value="${object.accept_account }" escapeXml="true"/>
						</dd>
					</dl> 
					<div class="divider"></div>
					<dl>
						<dt>银行类型</dt>
						<dd>
							 <c:out value="${object.showBank_type }" escapeXml="true"/>
						</dd>
					</dl> 
					<dl>
						<dt>账户名称</dt>
						<dd>
							 <c:out value="${object.accept_name }" escapeXml="true"/>
						</dd>
					</dl> 
					<div class="divider"></div>
					<dl>
						<dt>开户行</dt>
						<dd>
							 <c:out value="${object.accept_depositary_bank }" escapeXml="true"/>
						</dd>
					</dl> 
					<dl>
						<dt>开户地址</dt>
						<dd>
							 <c:out value="${object.accept_bank_addr }" escapeXml="true"/>
						</dd>
					</dl> 
					<div class="divider"></div>
					<dl>
						<dt>营销金额</dt>
						<dd>
							 <c:out value="${object.yingxiao_price_fen/100 }" escapeXml="true"/>
						</dd>
					</dl> 
					<dl>
						<dt>预付款金额</dt>
						<dd>
							 <c:out value="${object.yufukuan_price_fen/100 }" escapeXml="true"/>
						</dd>
					</dl>
					<div class="divider"></div>
					<dl class="nowrap" >
						<dt>打款凭证</dt>
						<dd>
							<img class="upload_img" style="width: 150px;height: 150px;" src="${basePath }${object.pinzheng}">
						</dd>
					</dl>
					<div class="divider"></div>
					<dl>
						<dt>创建时间：</dt>
						<dd> 
							 <c:out value="${object.showTime }" escapeXml="true"/>
						</dd>
					</dl>
