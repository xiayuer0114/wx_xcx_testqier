<%@page import="com.lymava.base.model.Pub"%>
<%@ page import="com.lymava.wechat.gongzhonghao.Gongzonghao" %>
<%@ page import="com.lymava.wechat.gongzhonghao.GongzonghaoContent" %>
<%@ page import="com.lymava.commons.util.MyUtil" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="org.apache.commons.io.output.ByteArrayOutputStream" %>
<%@ page import="com.lymava.commons.util.ImageUtil" %>
<%@ page import="com.lymava.commons.util.QrCodeUtil" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.UUID" %>
<%@ page import="org.bson.types.ObjectId" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<form id="pagerForm" method="post" action="${basePath }v2/huiyuan/list.do">
		<input type="hidden" name="page" value="${pageSplit.page }" />
		<input type="hidden" name="phone" value="<c:out value="${phone }" escapeXml="true"/>"   />
		<input type="hidden" name="userGroup_id" value="${object.userGroupId }" /> 
		<input type="hidden" name="return_mod" value="lookup" />
</form>
<%
	request.setAttribute("targetType", "dialog");

	// 生成 获取用户opendid 的二维码图片路径     孙M  6.27
	String cache_id = new ObjectId().toString();
	request.setAttribute("cache_id",cache_id);
%>
<div class="pageHeader">
	<form  id="${currentTimeMillis }searchform" name="${currentTimeMillis }searchform"  onsubmit="return dwzSearch(this, 'dialog');"    target="dialog"  action="${basePath }v2/huiyuan/list.do" method="post">
	<div class="searchBar">
		<table class="searchContent">
			<tr>
				<td>
					客户手机:
				</td>
				<td>
					<input type="text" name="phone" value="<c:out value="${phone }" escapeXml="true"/>"  size="15"  />
					<input type="hidden" name="return_mod" value="lookup" />
					<input type="hidden" name="userGroup_id" value="${object.userGroupId }" /> 
				</td>
			</tr>
			<tr>
				<td>
					登录名：
				</td>
				<td>
					<input type="text" id="userName" name="userName" value="<c:out value="${userName }" escapeXml="true"/>"  size="15"  />
				</td>
				<td>
					<div class="buttonActive"><div class="buttonContent"><button type="submit">检索</button></div></div>
				</td>
				<td>
					<a href="javascript:void(0);"  onclick="saoMa()">扫码</a>
				</td>
			</tr>
		</table>

		<script type="text/javascript" src="../js/jquery.qrcode.min.js"></script>

		<script type="text/javascript">
            var timer = null;
            var index = null;

            function cleartime(){
            	if(timer != null){
	                clearInterval(timer);
            	}
            	if(index != null){
	                layer.close(index);
            	}
            };

			function saoMa() {
				
				//cleartime();

                index = layer.open({
                    type: 1,
                    area: ['350px', '400px'],
                    shadeClose: true, //点击遮罩关闭
                    end: function(index){ 
                    	cleartime();
                    },
                    content: '\ <br><center> <div id="qrcode"></div> <br>扫码 获取您的信息 </center> '
                });

                $("#qrcode").qrcode("${basePath}/plugin_back/wechat/index.jsp?cache_id=${cache_id}");

                var requestData = {
                    "cache_id":"${cache_id}"
				};

                 // 循环判断用户是否扫描二维码
                 var handler = function(){
                     jQuery.ajax({
                         type : "post",
                         url : basePath + "v2/guanzhuUser/getUserOpenIdByQrcode.do",
                         global:false,
                         data:requestData,
                         dataType : "text",
                         success : function(data) {
                             data = JSON.parse(data);

                             if(data.statusCode == "200"){
                                 clearInterval(timer);
                                 $("#userName").val(data.openId);
                                 layer.close(index);
                             }
                         },
                         error : function() {}
                     });
				}

                 timer = setInterval(handler,2000); //每2秒去判断一次

                 // 一百秒后 结束判断
                 setTimeout(cleartime,1000*100);
            }

		</script>


	</div>
	</form> 
</div>
<div class="pageContent">
						<div class="panelBar">
							<ul class="toolBar">
								<li class="line">line</li>
							</ul>
						</div>
						<table class="table" width="100%" layoutH="138">
							<thead>
								<tr>
																			<th>用户名</th>
														    				<th>名称</th>
														    				<th>联系电话</th>
														    				<th>邮箱</th>
														    				<th>状态</th>
														    				<th width="40"><a class="btnSelect_bean"  href="javascript:jQuery.bringBack({userId:'', userShowName:'', showName:''})" title="清空">清空</a></th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="user" varStatus="i" items="${user_list }">
									<tr target="id" rel="${user.id }">
										<td><c:out value="${user.username }" escapeXml="true"/></td>
										<td><c:out value="${user.showName }" escapeXml="true"/></td>
										<td><c:out value="${user.phone }" escapeXml="true"/></td>
										<td><c:out value="${user.email }" escapeXml="true"/></td>
										<td><c:out value="${user.showState }" escapeXml="true"/></td>
										<td>
											<a  class="btnSelect_bean" href="javascript:jQuery.bringBack({userId:'${user.id }', userShowName:'${user.showName }', showName:'${user.showName }'})" title="带回">带回</a>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>