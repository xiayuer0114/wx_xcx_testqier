package com.lymava.qier.action;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;

import com.google.gson.Gson;
import com.lymava.base.model.User;
import com.lymava.base.model.UserGroup;
import com.lymava.qier.activities.model.ActivitieMerchant;
import com.lymava.qier.activities.model.ActivitieMerchantRedEnvelope;
import com.lymava.qier.model.User72;
import org.bson.types.ObjectId;

import com.google.gson.JsonObject;
import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.model.User;
import com.lymava.base.model.UserGroup;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlMethod;
import com.lymava.base.util.FinalVariable;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.state.State;
import com.lymava.commons.state.StatusCode;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.model.SerializModel;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.nosql.util.PageSplit;
import com.lymava.nosql.util.QuerySort;
import com.lymava.qier.business.BusinessIntIdConfigQier;
import com.lymava.qier.manager.model.UserRedEnvelopeTransfer;
import com.lymava.qier.model.Merchant72;
import com.lymava.qier.model.MerchantRedEnvelope;
import com.lymava.qier.model.TradeRecord72;
import com.lymava.qier.util.SunmingUtil;
import com.lymava.trade.base.context.BusinessContext;
import com.lymava.trade.base.model.Business;
import com.lymava.trade.util.WebConfigContentTrade;

/**
 * 定向红包管理
 * @author lymava
 *
 */
@AcceptUrlAction(path="v2/MerchantRedEnvelope/",name="定向红包")
public class MerchantRedEnvelopeAction extends LazyBaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6285710434054344790L;

	@Override
	protected Class<? extends SerializModel> getObjectClass() {
		return MerchantRedEnvelope.class;
	}

	@Override
	protected void listParse(Object object_find) {
		
		MerchantRedEnvelope merchantRedEnvelope = (MerchantRedEnvelope) object_find;
		
		String userId_merchant = this.getRequestParameter("object.userId_merchant","userId_merchant");
		if(MyUtil.isValid(userId_merchant)) {
			merchantRedEnvelope.setUserId_merchant(userId_merchant);
		}
		
 		String userId_huiyuan = this.getRequestParameter("object.userId_huiyuan","userId_huiyuan");
		if(MyUtil.isValid(userId_huiyuan)) {
			merchantRedEnvelope.setUserId_huiyuan(userId_huiyuan);
		}
		
		String state_str = this.getRequestParameter("object.state","state");
		Integer state = MathUtil.parseInteger(state_str);
		if(state > 0) {
			merchantRedEnvelope.setState(state);
		}
		
		String sort_filed = this.getRequestParameter("sort_filed");
		if(!MyUtil.isEmpty(sort_filed)) {
			merchantRedEnvelope.initQuerySort(sort_filed, QuerySort.desc);
			request.setAttribute("sort_filed", sort_filed);
		}
		
	}

	@Override
	protected void saveParse(Object object_find) {
		super.saveParse(object_find);
		
		MerchantRedEnvelope merchantRedEnvelope = (MerchantRedEnvelope) object_find;
		
	}

	@AcceptUrlMethod(name = "定向红包转移")
	public String transfer_to_tongyong(){

		JsonObject jo = new JsonObject();

		String[] id_array = request.getParameterValues("id");

		CheckException.checkNotNull(id_array, "请点击左边多选框选取操作的项");

		for(String id:id_array){
			if(MyUtil.isValid(id)){
				MerchantRedEnvelope merchantRedEnvelope = (MerchantRedEnvelope) serializContext.get(MerchantRedEnvelope.class, id);

				CheckException.checkIsTure(MyUtil.isValid(merchantRedEnvelope.getUserId_huiyuan()), "只能选择已领取的红包");

				//BusinessContext用于WriteBusiness
				BusinessContext instance = BusinessContext.getInstance();
				Business<UserRedEnvelopeTransfer> business = instance.getBusiness(BusinessIntIdConfigQier.businessIntId_merchant_user_hongbaozhuanyi);
				CheckException.checkIsTure(business != null, "转账业务未配置!");

				//设置业务参数
				Map requestMap = new HashMap();

				requestMap.put("merchantRedEnvelope", merchantRedEnvelope);
				requestMap.put(Business.user_key, merchantRedEnvelope.getUser_huiyuan() );
				requestMap.put(Business.ip_key, MyUtil.getIpAddr(request));
				requestMap.put(Business.requestFlow_key, new Long(System.currentTimeMillis()).toString() + id);

				requestMap.put("userV2", request.getAttribute(FinalVariable.SESSION_LOGINUSER));

				business.executeBusiness(requestMap);
			}
		}

		this.setMessage("操作成功！");
		this.setStatusCode(StatusCode.ACCEPT_OK);
		return SUCCESS;
	}

	//胡金石 查看定向红包
	@AcceptUrlMethod(name = "查看定向红包")
	public String look(){
		String merchantRedEnvelope_id = this.getRequestParameter("id");

		MerchantRedEnvelope merchantRedEnvelope = (MerchantRedEnvelope) serializContext.get(MerchantRedEnvelope.class, merchantRedEnvelope_id);
		TradeRecord72 consumeTradeRecord72 = merchantRedEnvelope.getConsumeTradeRecord72();

		request.setAttribute("merchantRedEnvelope", merchantRedEnvelope);
		request.setAttribute("consumeTradeRecord72", consumeTradeRecord72);

		setSuccessResultValue(getBasePath() + "look.jsp");
		return SUCCESS;
	}


	//胡金石 点击 批量红包修改
	@AcceptUrlMethod(name = "批量红包修改")
	public String batch_change(){
		setSuccessResultValue(getBasePath() + "batch_change.jsp");
		return SUCCESS;
	}

	//胡金石 批量红包修改 确定
	@AcceptUrlMethod(name = "批量红包修改")
	public String batch_change_ok(){

		//获取参数parameter
		String userId_merchant = this.getParameter("object.userId_merchant");//指定商家
		String old_userId_huiyuan = this.getParameter("object.old_userId_huiyuan");//指定会员
		String new_userId_huiyuan = this.getParameter("object.new_userId_huiyuan");//目标会员
		
		String usergroup_id=this.getParameter("object.usergroupId");	//随机领取的会员组的组id

		String old_state = this.getParameter("object.old_state");//原状态
		String new_state = this.getParameter("object.new_state");//目标状态

		String old_red_envolope_name = this.getParameter("object.old_red_envolope_name");//原红包名称
		String new_red_envolope_name = this.getParameter("object.new_red_envolope_name");//目标红包名称

		String old_inAmount = this.getParameter("object.old_inAmount");//原红包总额，需要*100
		String new_inAmount = this.getParameter("object.new_inAmount");//目标红包总额，需要*100

		String inExpiry_time = this.getParameter("object.inExpiry_time");//有效时间
		String inAmount_to_reach = this.getParameter("object.inAmount_to_reach");//满减金额，需要*100
		
		String change_size_str = this.getParameter("change_size");//批量修改数量
		Integer change_size = MathUtil.parseInteger(change_size_str);
		
		String userId_merchant_lingqu = this.getParameter("object.userId_merchant_lingqu");
		
		//领取商家随机
		String user_merchant_lingqu_rand_str = this.getParameter("user_merchant_lingqu_rand");
		Integer user_merchant_lingqu_rand = MathUtil.parseIntegerNull(user_merchant_lingqu_rand_str);
		
		/*
		 * 领取会员随机
		 */
		String user_huiyuan_lingqu_rand_str=this.getParameter("user_huiyuan_lingqu_rand");
		Integer user_huiyuan_lingqu_rand=MathUtil.parseIntegerNull(user_huiyuan_lingqu_rand_str);
		
		
		//领取时间随机
		String lingqu_time_is_set_str = this.getParameter("lingqu_time_is_set");
		Integer lingqu_time_is_set = MathUtil.parseIntegerNull(lingqu_time_is_set_str);
		
		
		String search_time_start_str = this.getParameter("search_time_start");
		String search_time_end_str = this.getParameter("search_time_end");
		Long search_time_start = DateUtil.date_str_to_timeMillis(search_time_start_str);
		Long search_time_end = DateUtil.date_str_to_timeMillis(search_time_end_str);
		
		
		String lingqu_time_start_str = this.getParameter("lingqu_time_start");
		String lingqu_time_end_str = this.getParameter("lingqu_time_end");
		Long lingqu_time_start = DateUtil.date_str_to_timeMillis(lingqu_time_start_str);
		Long lingqu_time_end = DateUtil.date_str_to_timeMillis(lingqu_time_end_str);
		
		if(State.STATE_OK.equals(lingqu_time_is_set)) {
			CheckException.checkIsTure(lingqu_time_start != null && lingqu_time_start > 0, "请选择随机领取开始时间!");
			CheckException.checkIsTure(lingqu_time_end != null && lingqu_time_end > 0, 	   "请选择随机领取结束时间!");
			CheckException.checkIsTure(lingqu_time_end > lingqu_time_start, 	   "结束时间必须大于开始时间!");
		}
		
		
		
		List<Merchant72> merchant72_list = null;
		/**
		 * @TODO	这个暂时拿所有的
		 */
		if(State.STATE_OK.equals(user_merchant_lingqu_rand)) {
			
			PageSplit pageSplit_tmp = new PageSplit(); 
			pageSplit_tmp.setPageSize(500);
			
			Merchant72 merchant72_find = new Merchant72();
			
			merchant72_find.setState(Merchant72.STATE_OK);
			merchant72_find.setUserGroupId(WebConfigContentTrade.getInstance().getMerchantUserGroupId());
			
			merchant72_list = serializContext.findAll(merchant72_find, pageSplit_tmp);
		}
		
		
		
		/**
		 * @TODO 如果有会员组id取得会员的列表
		 */
		List<User> user_list = null;
		if(State.STATE_OK.equals(user_huiyuan_lingqu_rand)) {
			
			PageSplit pageSplit_tmp = new PageSplit(); 
			pageSplit_tmp.setPageSize(100);
			
			User user_find = new User();
			
			user_find.setUserGroupId(usergroup_id);
			
			user_list = serializContext.findAll(user_find, pageSplit_tmp);
		}
		
		
		pageSplit = new PageSplit();
		pageSplit.setPageSize(change_size);

		//检测参数
		CheckException.checkIsTure( MyUtil.isValid(userId_merchant) || MyUtil.isValid(old_userId_huiyuan), "商户和用户必须输入一个");
		//如果有随机会员组，目标会员失效
		if(!MyUtil.isEmpty(usergroup_id)) {
			 //目标会员失效，不做参考
			new_userId_huiyuan =null;//目标会员
		}
		//转换参数
		if (MyUtil.isEmpty(userId_merchant)) {
			userId_merchant = null;
		}
		if (MyUtil.isEmpty(old_userId_huiyuan)) {
			old_userId_huiyuan = null;
		}
		if (MyUtil.isEmpty(new_userId_huiyuan)) {
			new_userId_huiyuan = null;
		}
		if (MyUtil.isEmpty(old_red_envolope_name)) {
			old_red_envolope_name = null;
		}
		if (MyUtil.isEmpty(new_red_envolope_name)) {
			new_red_envolope_name = null;
		}
		if (MyUtil.isEmpty(old_inAmount)) {
			old_inAmount = null;
		}
		if (MyUtil.isEmpty(new_inAmount)) {
			new_inAmount = null;
		}
		if (MyUtil.isEmpty(inAmount_to_reach)) {
			inAmount_to_reach = null;
		}

		Long inExpiry_time_long;
		try {
			inExpiry_time_long = DateUtil.getSdfFull().parse(inExpiry_time).getTime();
		} catch (ParseException e) {
			inExpiry_time_long = null;
		}

		Integer old_state_int = MathUtil.parseIntegerNull(old_state);
		Integer new_state_int =  MathUtil.parseIntegerNull(new_state);


		//业务逻辑
		MerchantRedEnvelope merchantRedEnvelope_find = new MerchantRedEnvelope();

		merchantRedEnvelope_find.setUserId_merchant(userId_merchant);
		merchantRedEnvelope_find.setUserId_huiyuan(old_userId_huiyuan);
		merchantRedEnvelope_find.setState(old_state_int);
		merchantRedEnvelope_find.setInAmount(old_inAmount);
		merchantRedEnvelope_find.setRed_envolope_name(old_red_envolope_name);
		
		
		
	
        if(search_time_start != null  ) {
            ObjectId start_object_id = new ObjectId(new Date(search_time_start));
            merchantRedEnvelope_find.addCommand(MongoCommand.dayuAndDengyu, "id", start_object_id);
        }
        if(search_time_end != null){
            ObjectId end_object_id = new ObjectId(new Date(search_time_end));
            merchantRedEnvelope_find.addCommand(MongoCommand.xiaoyu, "id", end_object_id);
        }

		Iterator<MerchantRedEnvelope> merchantRedEnvelope_ite = serializContext.findIterable(merchantRedEnvelope_find,pageSplit);
		
		Random random = new Random();

		while (merchantRedEnvelope_ite.hasNext()) {

			MerchantRedEnvelope merchantRedEnvelope_tmp = merchantRedEnvelope_ite.next();
			MerchantRedEnvelope merchantRedEnvelope_update = new MerchantRedEnvelope();
			merchantRedEnvelope_update.setState(new_state_int);
			merchantRedEnvelope_update.setRed_envolope_name(new_red_envolope_name);
			merchantRedEnvelope_update.setInAmount(new_inAmount);
			merchantRedEnvelope_update.setExpiry_time(inExpiry_time_long);
			merchantRedEnvelope_update.setInAmount_to_reach(inAmount_to_reach);
			
			//如果领取商家随机
			if(State.STATE_OK.equals(user_merchant_lingqu_rand) && merchant72_list != null && merchant72_list.size() > 0) {
				int nextInt = random.nextInt(merchant72_list.size());
				Merchant72 merchant72 = merchant72_list.get(nextInt);
				merchantRedEnvelope_update.setUserId_merchant_lingqu(merchant72.getId());
			}else if(MyUtil.isValid(userId_merchant_lingqu)){
				merchantRedEnvelope_update.setUserId_merchant_lingqu(userId_merchant_lingqu);
			}
			
			
			//如果有随机会员组，随机选择目标会员
			if(State.STATE_OK.equals(user_huiyuan_lingqu_rand) && user_list != null && user_list.size() > 0) {
				int nextInt = random.nextInt(user_list.size());
				User user=user_list.get(nextInt);
				merchantRedEnvelope_update.setUserId_huiyuan(user.getId());
			}else if(MyUtil.isValid(new_userId_huiyuan)) {
				merchantRedEnvelope_update.setUserId_huiyuan(new_userId_huiyuan);
			}
			
			
			
			
			if(State.STATE_OK.equals(lingqu_time_is_set)) {
				int lingqu_cha_e = (int) ((lingqu_time_end-lingqu_time_start)/1000);
				
				Long lingqu_time_rand =  random.nextInt((lingqu_cha_e/1000))*1000 +lingqu_time_start;
				
				merchantRedEnvelope_update.setLingqu_time(lingqu_time_rand);
			}
			System.out.println(merchantRedEnvelope_tmp.toString());
			System.out.println(merchantRedEnvelope_update.toString());
			serializContext.updateObject(merchantRedEnvelope_tmp.getId(), merchantRedEnvelope_update);

		}

		this.setMessage("操作成功！");
		this.setStatusCode(StatusCode.ACCEPT_OK);
		return SUCCESS;
	}


	@AcceptUrlMethod(name = "获取商家的红包信息")
	public String getMerchantRedEnvelopeByid(){

		String merchantId = this.getParameter("merchantId");
		CheckException.checkIsTure(MyUtil.isValid(merchantId), "商家id不正确" );

		ActivitieMerchant  activitieMerchant_find = new ActivitieMerchant();
		activitieMerchant_find.setUser_merchant_id(merchantId);
		activitieMerchant_find.setState(State.STATE_OK);
		activitieMerchant_find = (ActivitieMerchant)serializContext.get(activitieMerchant_find);
		CheckException.checkIsTure(activitieMerchant_find!=null, "该商家不是活动商家" );

		MerchantRedEnvelope merchantRedEnvelope_find = new MerchantRedEnvelope();
		merchantRedEnvelope_find.setUserId_merchant(merchantId);
		merchantRedEnvelope_find.addCommand(MongoCommand.budengyu, "red_envolope_name", "关注立减");
		merchantRedEnvelope_find = (MerchantRedEnvelope)serializContext.get(merchantRedEnvelope_find);
		CheckException.checkIsTure(merchantRedEnvelope_find!=null, "没找到商家红包" );

		JsonObject jsonObject = new JsonObject();
		jsonObject.addProperty("redEnvelope_name",merchantRedEnvelope_find.getRed_envolope_name());
		jsonObject.addProperty("redEnvelope_amount",merchantRedEnvelope_find.getAmountFen());

		this.setStatusCode(StatusCode.ACCEPT_OK);
		this.setMessage("");
		this.setDataRoot(jsonObject);
		return SUCCESS;
	}


	@AcceptUrlMethod(name = "加入到活动红包")
	public String addToActivityRed(){

		String op_count_str = this.getParameter("op_count");
		Integer op_count  =  MathUtil.parseIntegerNull(op_count_str);
		CheckException.checkIsTure( op_count != null && op_count >0 , "操作数量不正确");
		PageSplit pageSplit = new PageSplit("1",op_count_str);

		String merchant_id = this.getParameter("userId_merchant");
		CheckException.checkIsTure(MyUtil.isValid(merchant_id), "商家id不正确");

		ActivitieMerchant  activitieMerchant_find = new ActivitieMerchant();
		activitieMerchant_find.setUser_merchant_id(merchant_id);
		activitieMerchant_find.setState(State.STATE_OK);
		activitieMerchant_find = (ActivitieMerchant)serializContext.get(activitieMerchant_find);
		CheckException.checkIsTure(activitieMerchant_find!=null, "该商家不是活动商家" );

		// 设置查询
		MerchantRedEnvelope merchantRedEnvelope_find = new MerchantRedEnvelope();
		merchantRedEnvelope_find.setUserId_merchant(merchant_id);
			// 设置所属用户
		String user_id = this.getParameter("old_userId_huiyuan");
		if (MyUtil.isValid(user_id)) {
			merchantRedEnvelope_find.setUserId_huiyuan(user_id);
		}
			// 设置状态
		String old_state = this.getParameter("old_state");
		CheckException.checkIsTure(MathUtil.parseIntegerNull(old_state) != null, "原状态不正确");
		merchantRedEnvelope_find.setState(MathUtil.parseIntegerNull(old_state));
		SimpleDateFormat sdf = DateUtil.getSdfFull();
			// 设置时间
		String shengcheng_state_time_str = this.getParameter("shengcheng_state_time");
		String shengcheng_end_time_str = this.getParameter("shengcheng_end_time");
		String youxiao_state_time_str = this.getParameter("youxiao_state_time");
		String youxiao_end_time_str = this.getParameter("youxiao_end_time");
		String lingqu_state_time_str = this.getParameter("lingqu_state_time");
		String lingqu_end_time_str = this.getParameter("lingqu_end_time");
		try {
			// 设置生成时间
			Long shengcheng_state_time = sdf.parse(shengcheng_state_time_str).getTime();
			Long shengcheng_end_time = sdf.parse(shengcheng_end_time_str).getTime();
			merchantRedEnvelope_find = (MerchantRedEnvelope) SunmingUtil.setQueryWhere_time(merchantRedEnvelope_find,shengcheng_state_time,shengcheng_end_time);
		} catch (ParseException e) { }
		try {
			// 设置有效时间
			Long youxiao_state_time = sdf.parse(youxiao_state_time_str).getTime();
			Long youxiao_end_time = sdf.parse(youxiao_end_time_str).getTime();
			merchantRedEnvelope_find.addCommand(MongoCommand.dayuAndDengyu, "expiry_time", youxiao_state_time);
			merchantRedEnvelope_find.addCommand(MongoCommand.xiaoyuAndDengyu, "expiry_time", youxiao_end_time);
		} catch (ParseException e) { }
		try {
			// 设置领取时间
			Long lingqu_state_time = sdf.parse(lingqu_state_time_str).getTime();
			Long lingqu_end_time = sdf.parse(lingqu_end_time_str).getTime();
			merchantRedEnvelope_find.addCommand(MongoCommand.dayuAndDengyu, "lingqu_time", lingqu_state_time);
			merchantRedEnvelope_find.addCommand(MongoCommand.xiaoyuAndDengyu, "lingqu_time", lingqu_end_time);
		} catch (ParseException e) { }


		List<MerchantRedEnvelope> merchantRedEnvelopeList = serializContext.findAll(merchantRedEnvelope_find,pageSplit);
		System.out.println(merchantRedEnvelopeList);
		Iterator<MerchantRedEnvelope> merchantRedEnvelopeIterator = serializContext.findIterable(merchantRedEnvelope_find,pageSplit);

		// 获取活动红包名称
		String activity_envolope_name = this.getParameter("activity_envolope_name");
		CheckException.checkIsTure(!MyUtil.isEmpty(activity_envolope_name), "活动红包名称不能为空");

		// 获取新的状态
		String new_state_srt = this.getParameter("new_state");
		Integer new_state = MathUtil.parseIntegerNull(new_state_srt);
		CheckException.checkIsTure(new_state !=null, "加入之后状态不正确");

		// 获取会员组信息
		String user_group_id = this.getParameter("target_user_group_id");
		CheckException.checkIsTure(MyUtil.isValid(user_group_id), "目标会员组id不正确");
		UserGroup userGroup = (UserGroup)serializContext.get(UserGroup.class, user_group_id);
		CheckException.checkIsTure( userGroup != null, "根据会员组id没找到会员组");
		// 获取会员
		User72 user72_find = new User72();
		user72_find.setUserGroup(userGroup);
		user72_find.setState(User.STATE_OK);
		List<User72> user72List = serializContext.findAll(user72_find);
		CheckException.checkIsTure( user72List != null && user72List.size()!=0, "该会员组下没有用户");

		// 随机数
		Random rand = new Random();
		// 受影响的数据条数
		int count = 0;

		while ( merchantRedEnvelopeIterator.hasNext()){
			MerchantRedEnvelope merchantRedEnvelope_tmp = merchantRedEnvelopeIterator.next();
			Merchant72 merchant72_tmp  = merchantRedEnvelope_tmp.getUser_merchant();


			int index = 0;
			if(user72List.size() != 1){ index = rand.nextInt(user72List.size()-1); }
			User72 user72_op = user72List.get(index);

			MerchantRedEnvelope merchantRedEnvelope_update = new MerchantRedEnvelope();
			merchantRedEnvelope_update.setState(new_state);
			merchantRedEnvelope_update.setUser_huiyuan(user72_op);
			serializContext.updateObject(merchantRedEnvelope_tmp.getId(), merchantRedEnvelope_update);

			ActivitieMerchantRedEnvelope activitieMerchantRedEnvelope_add = new ActivitieMerchantRedEnvelope();
			activitieMerchantRedEnvelope_add.setActivity_redEnvelope_name(activity_envolope_name);
			activitieMerchantRedEnvelope_add.setRedEnvelope_id(merchantRedEnvelope_tmp.getId());
			activitieMerchantRedEnvelope_add.setMerchant72(merchant72_tmp);
			activitieMerchantRedEnvelope_add.setActivitieMerchant(activitieMerchant_find);
			activitieMerchantRedEnvelope_add.setState(State.STATE_OK);
			serializContext.save(activitieMerchantRedEnvelope_add);
			count++;
		}

		this.setStatusCode(StatusCode.ACCEPT_OK);
		this.setMessage("操作成功！ 操作了"+count+"数据");
		return SUCCESS;
	}



//	//胡金石 点击 批量状态转移
//	@AcceptUrlMethod(name = "批量修改红包名字")
//	public String batch_updateHongBaoName(){
//		String merchantRedId =  request.getParameter("id");
//
//		request.setAttribute("merchantRedId", merchantRedId);
//
//		setSuccessResultValue(getBasePath() + "batch_updateHongBaoName.jsp");
//		return SUCCESS;
//	}
//
//	//胡金石 批量状态转移 确定
//	@AcceptUrlMethod(name = "确定修改红包名字")
//	public String batch_updateHongBaoName_ok(){
//		String userId_merchant = this.getParameter("object.userId_merchant");
//		String new_red_envolope_name = this.getParameter("object.new_red_envolope_name");
//
//		CheckException.checkIsTure(MyUtil.isValid(userId_merchant),"商家id不正确");
//		CheckException.checkIsTure(!MyUtil.isEmpty(new_red_envolope_name),"新的红包名不能为空");
//
//		// 找到要修改的红包
//		MerchantRedEnvelope merchantRed_find = new MerchantRedEnvelope();
//		merchantRed_find.setUserId_merchant(userId_merchant);
//
//		Iterator<MerchantRedEnvelope> merchantRedEnvelopeIterator = serializContext.findIterable(merchantRed_find);
//
//		// 要修修改的字段
//		MerchantRedEnvelope merchantRed_update = new MerchantRedEnvelope();
//		merchantRed_update.setRed_envolope_name(new_red_envolope_name);
//
//
//		while (merchantRedEnvelopeIterator.hasNext()){
//			MerchantRedEnvelope merchantRed_temp = merchantRedEnvelopeIterator.next();
//			serializContext.updateObject(merchantRed_temp.getId(), merchantRed_update);
//		}
//
//		this.setStatusCode(StatusCode.ACCEPT_OK);
//		this.setMessage("修改成功");
//		return SUCCESS;
//	}
//
//	//胡金石 点击 批量状态转移
//	@AcceptUrlMethod(name = "批量状态转移")
//	public String batch_transfer(){
//		setSuccessResultValue(getBasePath() + "batch_transfer.jsp");
//		return SUCCESS;
//	}
//
//	//胡金石 批量状态转移 确定
//	@AcceptUrlMethod(name = "批量状态转移")
//	public String batch_transfer_ok(){
//
//		//获取参数parameter
//		String userId_merchant = this.getParameter("object.userId_merchant");
//		String userId_huiyuan = this.getParameter("object.userId_huiyuan");
//
//		CheckException.checkIsTure(
//				!MyUtil.isEmpty(userId_merchant) || !MyUtil.isEmpty(userId_huiyuan),
//				"商户和用户必须输入一个");
//
//		String old_state = this.getParameter("object.old_state");
//		CheckException.checkNotEmpty(old_state, "请求参数中没有old_state");
//		String new_state = this.getParameter("object.new_state");
//		CheckException.checkNotEmpty(new_state, "请求参数中没有new_state");
//
//		//业务逻辑
//		MerchantRedEnvelope merchantRedEnvelope_find = new MerchantRedEnvelope();
//
//		if (!MyUtil.isEmpty(userId_merchant)) {
//			merchantRedEnvelope_find.setUserId_merchant(userId_merchant);
//		}
//		if (!MyUtil.isEmpty(userId_huiyuan)) {
//			merchantRedEnvelope_find.setUserId_huiyuan(userId_huiyuan);
//		}
//		merchantRedEnvelope_find.setState(Integer.valueOf(old_state));
//		Iterator<MerchantRedEnvelope> merchantRedEnvelope_ite = serializContext.findIterable(merchantRedEnvelope_find);
//		while (merchantRedEnvelope_ite.hasNext()) {
//			MerchantRedEnvelope merchantRedEnvelope_tmp = merchantRedEnvelope_ite.next();
//			merchantRedEnvelope_tmp.setState(Integer.valueOf(new_state));
//			serializContext.updateObject(merchantRedEnvelope_tmp.getId(), merchantRedEnvelope_tmp);
//		}
//
//		this.setMessage("操作成功！");
//		this.setStatusCode(StatusCode.ACCEPT_OK);
//		return SUCCESS;
//	}
	
	@AcceptUrlMethod(name = "未领重新排序")
	public String re_index(){
		

		MerchantRedEnvelope merchantRedEnvelope_find = new MerchantRedEnvelope();
		merchantRedEnvelope_find.setState(State.STATE_WAITE_CHANGE);
		
		Iterator<MerchantRedEnvelope> findIterable = serializContext.findIterable(merchantRedEnvelope_find);
		
		Random random = new Random();
		
		Long currentDayStartTime = DateUtil.getCurrentDayStartTime();
		
		
		while(findIterable.hasNext()) {
			
			MerchantRedEnvelope merchantRedEnvelope_next = findIterable.next();
			
			int nextInt = random.nextInt(DateUtil.one_day.intValue());
			
			MerchantRedEnvelope merchantRedEnvelope_update = new MerchantRedEnvelope();
			merchantRedEnvelope_update.setIndex_id(currentDayStartTime+nextInt);
			
			serializContext.updateObject(merchantRedEnvelope_next.getId(), merchantRedEnvelope_update);
		}
		
		
		this.setStatusCode(StatusCode.ACCEPT_OK);
		this.setMessage("操作成功");
		return SUCCESS;
	}
	
	
	
}
