<%@ page import="com.lymava.qier.activities.model.MeiRiJiKa" %>
<%@ page import="com.lymava.qier.activities.model.JiKaHuoDong" %>
<%@ page import="com.lymava.nosql.util.PageSplit" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lymava.userfront.util.FrontUtil" %>
<%@ page import="com.lymava.base.model.User" %>
<%@ page import="com.lymava.commons.exception.CheckException" %>
<%@ page import="com.lymava.commons.util.DateUtil" %>
<%@ page import="com.lymava.commons.state.State" %>
<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="com.lymava.nosql.context.SerializContext" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.lymava.commons.state.StatusCode" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="java.util.Random" %>
<%@ page import="org.bson.types.ObjectId" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%

	JsonObject jsonObject = new JsonObject();

	try{

		String my_openid=request.getParameter("my_openid");

		User user_huiyuan =  FrontUtil.init_http_user(request);
		CheckException.checkIsTure(user_huiyuan != null,"用户登录超时！请刷新！");

		SerializContext serializContext = ContextUtil.getSerializContext();

		// 现在的时间
		Long nowTime = System.currentTimeMillis();
		// 今天开始的时间
		Long nowStartTime = DateUtil.getDayStartTime(nowTime);

		//校验今日是否已经帮助集卡完成
		MeiRiJiKa meiRiJiKa_find_one = new MeiRiJiKa();

		meiRiJiKa_find_one.setJika_kaishi_day(nowStartTime);
		meiRiJiKa_find_one.setMy_openid(my_openid);
		meiRiJiKa_find_one.setFriend_openid(user_huiyuan.getThird_user_id());


		List<MeiRiJiKa> meirijika_list_one = serializContext.findAll(meiRiJiKa_find_one);
		CheckException.checkIsTure(meirijika_list_one.size()==0,"今日已帮助集卡完成！");


		MeiRiJiKa meiRiJiKa_find = new MeiRiJiKa();

		meiRiJiKa_find.setJika_kaishi_day(nowStartTime);
		meiRiJiKa_find.setMy_openid(my_openid);


		List<MeiRiJiKa> meirijika_list = serializContext.findAll(meiRiJiKa_find);
		Random chongfu = new Random();
		int chong=chongfu.nextInt(5)+1;
		LinkedList<Integer> card_type_list_wei = new LinkedList<Integer>();
		LinkedList<Integer> card_type_list_yi = new LinkedList<Integer>();

		card_type_list_wei.add(MeiRiJiKa.card_type_1);
		card_type_list_wei.add(MeiRiJiKa.card_type_2);
		card_type_list_wei.add(MeiRiJiKa.card_type_3);
		card_type_list_wei.add(MeiRiJiKa.card_type_4);
		card_type_list_wei.add(MeiRiJiKa.card_type_5);
		card_type_list_wei.add(MeiRiJiKa.card_type_6);
		card_type_list_wei.add(MeiRiJiKa.card_type_7);
		card_type_list_wei.add(MeiRiJiKa.card_type_8);

		for (MeiRiJiKa meiRiJiKa_tmp:meirijika_list){
			card_type_list_wei.remove(meiRiJiKa_tmp.getCard_type());
			card_type_list_yi.add(meiRiJiKa_tmp.getCard_type());
		}

		Random random = new Random();
		Integer current_card_type =0;
		MeiRiJiKa meiRiJiKa_save = new MeiRiJiKa();
		MeiRiJiKa meiRiJiKa_save_chongfu = new MeiRiJiKa();
		if(chong==1){
			int current_card_type_index = random.nextInt(card_type_list_yi.size());
			current_card_type=card_type_list_yi.get(current_card_type_index);
			meiRiJiKa_save.setState(MeiRiJiKa.state_chongfu);
		}else {
			int current_card_type_index = random.nextInt(card_type_list_wei.size());
			current_card_type = card_type_list_wei.get(current_card_type_index);
			if(card_type_list_wei.size()==1){
				meiRiJiKa_save.setState(MeiRiJiKa.state_ok);

				//JiKaHuoDong jiKaHuoDong_find_tep = new JiKaHuoDong();
				//jiKaHuoDong_find.setState(State.STATE_OK);

				//List<JiKaHuoDong> jiKaHuoDong_find_out_list = serializContext.findAll(jiKaHuoDong_find_tep);

				synchronized (JiKaHuoDong.class){
					JiKaHuoDong jiKaHuoDong_find_check = new JiKaHuoDong();
					jiKaHuoDong_find_check.setState(State.STATE_OK);

					jiKaHuoDong_find_check = (JiKaHuoDong)serializContext.findOneInlist(jiKaHuoDong_find_check);

					Integer paiming = 1;
					if(jiKaHuoDong_find_check!=null&&jiKaHuoDong_find_check.getJika_paiming() != null){
						paiming = jiKaHuoDong_find_check.getJika_paiming()+1;
					}

					JiKaHuoDong jiKaHuoDong_save = new JiKaHuoDong();
					jiKaHuoDong_save.setJika_paiming(paiming);
					jiKaHuoDong_save.setOpenid(my_openid);
					jiKaHuoDong_save.setLingqu_day(nowStartTime);
					jiKaHuoDong_save.setState(State.STATE_OK);
					serializContext.save(jiKaHuoDong_save);
				}
			}else {
				meiRiJiKa_save.setState(MeiRiJiKa.state_inprocess);
			}
		}

		meiRiJiKa_save.setId(new ObjectId().toString());

		meiRiJiKa_save.setMy_openid(my_openid);
		meiRiJiKa_save.setFriend_openid(user_huiyuan.getThird_user_id());
		meiRiJiKa_save.setJika_lei("hui"+current_card_type+"_yiling");
		meiRiJiKa_save.setCard_type(current_card_type);
		meiRiJiKa_save.setJika_day(nowTime);
		meiRiJiKa_save.setJika_kaishi_day(nowStartTime);


		serializContext.save(meiRiJiKa_save);

		jsonObject.addProperty("current_card_type", current_card_type);
	}catch(CheckException checkException){
		jsonObject.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_FALSE);
		jsonObject.addProperty(StatusCode.statusCode_message_key, checkException.getMessage());
	}catch(Exception e){
		jsonObject.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_FALSE);
		jsonObject.addProperty(StatusCode.statusCode_message_key, "领取失败!");
	}
	out.print(jsonObject);
%>