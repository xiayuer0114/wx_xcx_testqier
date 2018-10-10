<%--
	复活用户
 --%>

<%@ page import="com.lymava.commons.exception.CheckException" %>
<%@ page import="com.lymava.qier.activities.caididian.CaiDidianDaan" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.lymava.commons.util.*" %>
<%@ page import="com.lymava.qier.activities.caididian.Relife" %>
<%@ page import="com.lymava.nosql.mongodb.util.MongoCommand" %>
<%@ page import="java.util.Iterator" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>

<%
	String current_page = request.getParameter("current_page");//当前显示页
	String origin_openid = request.getParameter("origin_openid");//被复活用户openid
	String didian_id = request.getParameter("didian_id");//指定地点ID

	//检测参数正确性
	CheckException.checkNotNull(current_page, "未知的地点页面");
	CheckException.checkNotNull(origin_openid, "非法的用户");
	CheckException.isValid(didian_id, "未找到指定地点");
	CheckException.checkIsTure(!origin_openid.equals(openid_header), "不能自己复活自己！");

	//查询帮助复活的朋友用户
	Relife relife_find  = new Relife();
	relife_find.setOpenid(origin_openid);
	relife_find.setFriend_openid(openid_header);

	Date currentDate = new Date();
	Date todayStart_date = new Date(DateUtil.getDayStartTime(currentDate.getTime()));
	Date todayEnd_date = new Date(DateUtil.getDayStartTime(currentDate.getTime() + DateUtil.one_day));
	relife_find.addCommand(MongoCommand.dayuAndDengyu, "relife_day", todayStart_date.getTime());
	relife_find.addCommand(MongoCommand.xiaoyu, "relife_day", todayEnd_date.getTime());
	int relifeCount = serializContext.findAll(relife_find).size();

	if (relifeCount >= 1){//此朋友今天已经帮助复活过

		request.setAttribute("status", "false");
		request.getRequestDispatcher("/activities/caididian/index.jsp").forward(request, response);
		return;
	}

	//复活用户
	String status = "false";//false表示复活失败，true表示复活成功

	CaiDidianDaan caiDidianDaan_find = new CaiDidianDaan();
	caiDidianDaan_find.setDidian_id(didian_id);
	caiDidianDaan_find.setOpenid(origin_openid);
	CaiDidianDaan caiDidianDaan_tmp = (CaiDidianDaan)serializContext.get(caiDidianDaan_find);

	CheckException.checkIsTure(State.STATE_FALSE.equals(caiDidianDaan_tmp.getState()), "只能复活未中奖的用户！");

	if (caiDidianDaan_tmp != null && caiDidianDaan_tmp.getRelife_day() != null) {

		//最大复活限制
		Integer caididian_relife_count = Integer.valueOf(WebConfigContent.getConfig("caididian_relife_count"));

		//获取用户今天总共复活的次数
		//之前的逻辑：relifeCount = caiDidianDaan_tmp.getRelife_count();
		caiDidianDaan_find = new CaiDidianDaan();
		caiDidianDaan_find.setOpenid(origin_openid);
		Iterator<CaiDidianDaan> caiDidianDaan_ite = serializContext.findIterable(caiDidianDaan_find);
		relife_find.addCommand(MongoCommand.dayuAndDengyu, "relife_day", todayStart_date.getTime());
		relife_find.addCommand(MongoCommand.xiaoyu, "relife_day", todayEnd_date.getTime());
		relifeCount = 0;
		while (caiDidianDaan_ite.hasNext()) {
			CaiDidianDaan caiDidianDaan_ite_tmp = caiDidianDaan_ite.next();
			relifeCount = relifeCount + caiDidianDaan_ite_tmp.getRelife_count();
		}

		Date lastRelife_date = new Date(caiDidianDaan_tmp.getRelife_day());
		todayStart_date = new Date(DateUtil.getDayStartTime(System.currentTimeMillis()));
		todayEnd_date = new Date(DateUtil.getDayStartTime(System.currentTimeMillis() + DateUtil.one_day));


		if (lastRelife_date.after(todayStart_date) && lastRelife_date.before(todayEnd_date)) {//还在今天
			if (relifeCount < caididian_relife_count) {
				caiDidianDaan_tmp.setRelife_count(relifeCount + 1);
				caiDidianDaan_tmp.setRelife_day(new Date().getTime());
				caiDidianDaan_tmp.setState(State.STATE_WAITE_PROCESS);
				status = "true";

				//增加Relife记录
				Relife relife_save = new Relife();
				relife_save.setOpenid(origin_openid);
				relife_save.setFriend_openid(openid_header);
				relife_save.setRelife_day(System.currentTimeMillis());
				serializContext.save(relife_save);
			}

		} else if (lastRelife_date.before(todayStart_date)){//已经是第二天了，应该重置复活次数
			caiDidianDaan_tmp.setRelife_count(1);
			caiDidianDaan_tmp.setRelife_day(new Date().getTime());
			caiDidianDaan_tmp.setState(State.STATE_WAITE_PROCESS);
			status = "true";

			//增加Relife记录
			Relife relife_save = new Relife();
			relife_save.setOpenid(origin_openid);
			relife_save.setFriend_openid(openid_header);
			relife_save.setRelife_day(System.currentTimeMillis());
			serializContext.save(relife_save);
		}
		//增加CaiDidianDaan记录
		serializContext.updateObject(caiDidianDaan_tmp.getId(), caiDidianDaan_tmp);
	}

	request.setAttribute("status", status);
	request.getRequestDispatcher("/activities/caididian/index.jsp").forward(request, response);
%>
