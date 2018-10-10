<%--
	中奖之后的页面
 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<div class="guess_ture" id="id_guess_ok_div" hidden="hidden">
	<div class="" style="height: 7.5rem; width: 100%;"> </div>
	<div class="g_t">
		<div class="g_tu">
			<img src="img/dui1.png"/>
		</div>
		<div class="g_tu1">
			<c:if test="${caiDidianDaan.type_jiangpin == 2}"><img src="img/ticket.png"/></c:if>
			<c:if test="${caiDidianDaan.type_jiangpin == 3}"><img src="img/ticket2.png"/></c:if>
		</div>
		<div class="g_tu2">
			<a href="${basePath}activities/caididian/action_generate_poster.jsp?page=${pageSplit.page}">点击生成你的专属海报</a>
		</div>
		<div class="g_tu3" id="id_money_package">
			<%-- 进入钱包 --%>
			<img src="img/botton4.png"/>
		</div>
	</div>
</div>