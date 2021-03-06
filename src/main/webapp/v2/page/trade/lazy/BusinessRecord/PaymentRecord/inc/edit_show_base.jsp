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
						<dt>商户流水：</dt>
						<dd>
							<c:out value="${object.requestFlow }" escapeXml="true"/>
						</dd>
					</dl> 
					<div class="divider"></div> 
   					<dl> 
						<dt>支付流水：</dt>
						<dd>
							<c:out value="${object.payFlow }" escapeXml="true"/>
						</dd>
					</dl> 
					<div class="divider"></div> 
					<dl class="nowrap">
						<dt>用户登录名</dt>
						<dd>
							 <c:out value="${object.user_huiyuan.username }" escapeXml="true"/>
						</dd>
					</dl>
					<div class="divider"></div> 
					<dl>
						<dt>用户名称</dt>
						<dd>
							 <c:out value="${object.user_huiyuan.realname }" escapeXml="true"/>
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
						<dt>创建时间：</dt>
						<dd> 
							 <c:out value="${object.showTime }" escapeXml="true"/>
						</dd>
					</dl>
