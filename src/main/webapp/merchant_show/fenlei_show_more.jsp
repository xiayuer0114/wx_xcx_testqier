<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018\4\20 0020
  Time: 14:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:forEach var="allPubByPageSplit" items="${allPubByPageSplit }" varStatus="i" >
    <div class="content2_1 layui-col-xs6">
      <div class="content2_all">
        <div class="content1_ph">
                <%--图片--%>
            <a href="${basePath }merchant_show/detail.jsp?file=${allPubByPageSplit.file}"><img src="${basePath }${allPubByPageSplit.pic}"/></a>
            <%--<img src="img/ph.png"/>--%>
        </div>
        <div class="content2_font ">
                <%--简介--%>
            <c:out value="${allPubByPageSplit.intro}" escapeXml="true"/>
            <%--祇园，是祇树给孤独园的略称，印度佛教圣地之一.......--%>
        </div>
        <div class="clear"></div>
        <div class="content3_1">
            <div class="content3_a">
                    <%--商家的图片 小的logo--%>
                <%--<img src="logo/mankafei.png"/>--%>
                <%--<img src="img/tou.png"/>--%>
                        <img src="${basePath }${allPubByPageSplit.logo}"/>
            </div>
            <div class="content3_b">
                <div class="content3_b1">
                        <%--收藏次数--%>
                    <c:out value="${allPubByPageSplit.shoucang_count}" escapeXml="true"/>
                    <%--386--%>
                </div>
                <div class="content3_b2">
                        <%--收藏的小心心图片--%>
                    <img src="${(allPubByPageSplit.beCollected!=1)?'img/xing.png':'img/xing1.png'}" onclick=collectPub('${allPubByPageSplit.id}',this); />
                </div>
            </div>
        </div>
        <div class="clear"></div>
        <div class="" style="height: 0.4rem;"></div>
    </div>
    </div>
</c:forEach>
