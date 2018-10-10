<%@page import="com.graphbuilder.struc.LinkedList"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.lymava.qier.model.Merchant72"%>
<%@page import="com.lymava.qier.model.MerchantRedEnvelope"%>
<%@page import="com.lymava.commons.util.MathUtil"%>
<%@page import="com.lymava.qier.activities.guaguaka.GuaguakaShareBusiness"%>
<%@page import="com.lymava.commons.util.DateUtil"%>
<%@page import="java.sql.Date"%>
<%@page import="com.lymava.commons.exception.CheckException"%>
<%@page import="com.lymava.qier.activities.guaguaka.GuaguakaJiangPin"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>
<%
	CheckException.checkIsTure(subscribeUser != null && State.STATE_OK.equals(subscribeUser.getState()), "请先关注我们再参加活动!");

	Long currentDayStartTime = DateUtil.getCurrentDayStartTime();

	GuaguakaJiangPin guaguakaJiangPin_find = new GuaguakaJiangPin();
	
	guaguakaJiangPin_find.setOpenid(openid_header);
	guaguakaJiangPin_find.setLingqu_day(currentDayStartTime);

	guaguakaJiangPin_find = (GuaguakaJiangPin)serializContext.get(guaguakaJiangPin_find);
	
	CheckException.checkIsTure(guaguakaJiangPin_find == null, "今日已刮过,明天再来吧!");
	
	GuaguakaShareBusiness guaguakaShareBusiness = new GuaguakaShareBusiness();
	
	List<Long> bianhao_list = new ArrayList<Long>();
	
	bianhao_list.add(9001l);//动物园咖啡
	bianhao_list.add(18354l);//圣慕缇
	bianhao_list.add(5051l);//FL酒吧(解放碑)
	bianhao_list.add(5113l);//FL酒吧(鎏嘉码头)
	bianhao_list.add(7183l);//聚点足道
	bianhao_list.add(8588l);//restaurant
	//bianhao_list.add(7322l);//痴小鱼餐厅(南岸区)
	bianhao_list.add(7321l);//痴小鱼餐厅(江北区)
	bianhao_list.add(7323l);//卿楼
	bianhao_list.add(7184l);//三木焰日式烧肉
	bianhao_list.add(7324l);//艾美沙
	bianhao_list.add(28117l);//片甲不留
	/**
	 * 定向红包的商家
	 */
	List<Merchant72> merchant72_list = new ArrayList<Merchant72>();
	
	for(Long user_bianhao_tmp:bianhao_list){
		
		Merchant72 merchant72_find = new Merchant72();
		merchant72_find.setBianhao(user_bianhao_tmp);
	
		merchant72_find = (Merchant72)serializContext.get(merchant72_find);
		if(merchant72_find != null){
			merchant72_list.add(merchant72_find);
		}
	}
	
	guaguakaShareBusiness.setMerchant72_list(merchant72_list);
	
	
	CheckException.checkIsTure(guaguakaShareBusiness.check_is_start(), "小可爱，活动还未开始（7月20日晚7点），敬请期待！");
	CheckException.checkIsTure(guaguakaShareBusiness.check_is_end(), "活动已经结束啦，要不去小程序看看美文？");
	
	GuaguakaJiangPin guaguakaJiangPin = guaguakaShareBusiness.choujiang(subscribeUser);
	
	
	Integer type_jiangpin_final = null;
	if(guaguakaJiangPin != null){
		type_jiangpin_final = guaguakaJiangPin.getType_jiangpin();
	}
	
	String message = "";
	String image_src = "";
	if(guaguakaJiangPin == null || State.STATE_FALSE.equals(guaguakaJiangPin.getState())){
		message = "未中奖";
		image_src = "activities/guaguaka/img/red_4.png";
	}else if(GuaguakaJiangPin.type_jiangpin_tongyong.equals(type_jiangpin_final)) {
		//通用红包1
		//通用红包2
		Integer price_fen = guaguakaJiangPin.getPrice_fen();
		if(price_fen == null){
			price_fen = 0;
		}
		message = "您中了:"+price_fen/100+"元通用红包!";
		image_src = "activities/guaguaka/img/red_2.png";
	}else if(GuaguakaJiangPin.type_jiangpin_dingxiang.equals(type_jiangpin_final)) {
		//定向红包
		//通用红包2
		Integer price_fen = guaguakaJiangPin.getPrice_fen();
		MerchantRedEnvelope merchantRedEnvelope = guaguakaJiangPin.getMerchantRedEnvelope();
		if(merchantRedEnvelope == null){
			message = "很遗憾,什么也没抽到!";
			image_src = "activities/guaguaka/img/red_4.png";
		}else{
			
			Merchant72 merchant72 = merchantRedEnvelope.getUser_merchant();
			
			if(price_fen == null){
				price_fen = 0;
			}
			message = "您中了:"+merchant72.getShowName()+"的"+price_fen/100+"元红包!";
			image_src = "activities/guaguaka/img/red_3.png";
		}
	}else  if(GuaguakaJiangPin.type_jiangpin_tongyong_2.equals(type_jiangpin_final)) {
		//通用红包2
		Integer price_fen = guaguakaJiangPin.getPrice_fen();
		if(price_fen == null){
			price_fen = 0;
		}
		message = "您中了:"+price_fen/100+"元通用红包!";
		image_src = "activities/guaguaka/img/red_2.png";
	}else{
		message = "未中奖";
		image_src = "activities/guaguaka/img/red_4.png";
	}
	
	request.setAttribute("message", message);
	request.setAttribute("image_src", image_src);
%>
<style type="text/css">
		#guaguaka .layui-m-layerbtn{
			display: none;
		}
		#guaguaka .layui-m-layerchild{
			width: 7rem;height: 8rem;background-color: rgba(255,255,255,0);
		}
		#guaguaka .layui-m-layercont{
			padding: 0em;
		}
	</style>
<div class="layui-col-xs12" style="position: relative;width: 7rem;height: 8rem;background-color: rgba(255,255,255,0);">
				<img alt="" src="${basePath }${image_src}" style="width: 100%;height: 100%;">
				<div  style="position: absolute;width: 100%;height: 1rem;z-index: 1000;left: 0;top: 1.5rem;line-height: 1rem;text-align: center;">
					${message }
				</div>
				<div  style="position: absolute;z-index: 1000;left: 0;top: 5.8rem;">
					 <img onclick="sure_jiangp()" alt="" src="${basePath }activities/guaguaka/img/botton.png" style="width: 4rem;padding-left: 1.5rem;">
				</div>
</div>
