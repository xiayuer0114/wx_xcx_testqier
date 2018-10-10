package com.lymava.qier.action;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import com.google.gson.JsonObject;
import com.lymava.base.model.User;
import com.lymava.base.safecontroler.annotation.AcceptUrlMethod;
import com.lymava.base.safecontroler.model.UserV2;
import com.lymava.base.util.ContextUtil;
import com.lymava.base.util.FinalVariable;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.state.State;
import com.lymava.commons.state.StatusCode;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.commons.vo.EntityKeyValue;
import com.lymava.nosql.model.SerializModel;
import com.lymava.qier.business.BusinessIntIdConfigQier;
import com.lymava.qier.manager.model.ManagerOperationRecord;
import com.lymava.qier.manager.model.RedEnvelopeTransfer;
import com.lymava.qier.model.*;
import com.lymava.qier.model.merchant.MerchantBankChangeRecord;
import com.lymava.qier.model.xiaoChengXuModel.ConfigPub;
import com.lymava.qier.model.xiaoChengXuModel.ShowPub;
import com.lymava.qier.util.SunmingUtil;
import com.lymava.trade.base.context.BusinessContext;
import com.lymava.trade.base.model.Business;
import com.lymava.trade.base.model.BusinessIntIdConfig;

public class Merchant72UserAction extends com.lymava.base.action.UserAction {

    /**
	 * 
	 */
	private static final long serialVersionUID = -5135969342422596642L;


	private SettlementBank settBank;

    public SettlementBank getSettBank() {
        return settBank;
    }

    public void setSettBank(SettlementBank settBank) {
        this.settBank = settBank;
    }


    protected  String getBasePath(){
        return "/v2/page/huiyuan/Merchant72/";
    }


    // 得到银行配置的根节点
    public static String getBankCinfigRootPubid(){
        return "5af272cdc1e9ff18b46bee2a";
    };


    /**
     * '银行信息编辑'   选中一个具体的商家
     * @return
     */
    public String bankEdit(){
        String id = request.getParameter("id");

        User user = (User) object;
        if(MyUtil.isValid(id)){
            user = (User) serializContext.get(this.getObjectClass(),id);
        }
        if(user != null){
            user = user.getFinalUser();
        }
        this.object = user;
        request.setAttribute("user", user);


        SettlementBank settlementBank_find = null;
        if(MyUtil.isValid(id)){
            settlementBank_find = new SettlementBank();
            settlementBank_find.setMerchant72_id(id);
            settlementBank_find = (SettlementBank) ContextUtil.getSerializContext().get(settlementBank_find);
        }

        request.setAttribute("settBank", settlementBank_find);
        this.setSuccessResultValue(this.getBasePath()+"edit_bank.jsp");
        return SUCCESS;
    }


    /**
     * 保存'银行信息'  (保存/修改)
     * @return
     */
    public String changBank(){

		String pinzheng = this.getParameter("object.pinzheng");

		//获取登录后台管理员
		UserV2 userV2 = (UserV2) request.getAttribute(FinalVariable.SESSION_LOGINUSER);

		//获取Merchant72
		CheckException.checkIsTure(MyUtil.isValid(settBank.getMerchant72_id()),"商家id不正确");
		Merchant72 merchant72 = (Merchant72) serializContext.get(Merchant72.class, settBank.getMerchant72_id());

		// 处理对象的数据完整性的判断
		CheckException.checkNotEmpty(pinzheng, "请选择变更凭证！");
        CheckException.checkIsTure(settBank != null,"操作了一个空对象");
        CheckException.checkIsTure(settBank.getName() != null,"账户名称不能为空");
        CheckException.checkIsTure(settBank.getAccount() != null ,"卡号/账号不能为空");

		//BusinessContext用于WriteBusiness
		BusinessContext instance = BusinessContext.getInstance();
		Business<MerchantBankChangeRecord> business = instance.getBusiness(BusinessIntIdConfigQier.businessIntId_bank_change);
		CheckException.checkIsTure(business != null, "银行卡变更业务未配置!");

		Map requestMap = new HashMap();
		requestMap.putAll(request.getParameterMap());
		requestMap.put(Business.user_key, merchant72);
		requestMap.put(Business.ip_key, MyUtil.getIpAddr(request));
		requestMap.put(Business.requestFlow_key, new Long(System.currentTimeMillis()).toString());

		requestMap.put("userV2", userV2);
		requestMap.put("settBank", settBank);

		//保存记录
		business.executeBusiness(requestMap);

		this.setMessage("变更请求已提交，请等待审核！");
		this.setStatusCode(StatusCode.ACCEPT_OK);
		return SUCCESS;






//        // 根据对象是否存在 进行保存或者修改操作
//        SettlementBank settlementBank_panduan = new SettlementBank();
//        settlementBank_panduan.setMerchant72_id(settBank.getMerchant72_id());
//        if(ContextUtil.getSerializContext().get(settlementBank_panduan) == null){
//            settBank.setId(null);
//            ContextUtil.getSerializContext().save(settBank);
//        }else {
//            if (settBank.getId() == null ){ return ""; }
//            ContextUtil.getSerializContext().updateObject(settBank.getId(),settBank);
//        };
//
//
//        // 设置返回值
//        JsonObject jo = new JsonObject();
//        jo.addProperty("statusCode", "200");
//        jo.addProperty("message", "银行信息修改成功！");
//        this.setStrutsOutString(jo.toString());
//        return SUCCESS;
    }



    /**
     * '流水检测'   选中一个具体的商家
     * @return
     */
    public String checkLiuShui(){
        String id = request.getParameter("id");

        User user = (User) object;
        if(MyUtil.isValid(id)){
            user = (User) serializContext.get(this.getObjectClass(),id);
        }
        if(user != null){
            user = user.getFinalUser();
        }
        this.object = user;
        request.setAttribute("user", user);


        Integer tianshu = 14;

        // 查找这个商家的近段时间的订单
        TradeRecord72 tradeRecord72_find = new TradeRecord72();

        tradeRecord72_find.setUserId_merchant(user.getId());  // 商家id
		tradeRecord72_find.setBusinessIntId(BusinessIntIdConfig.businessIntId_trade);  // 业务订单
        tradeRecord72_find.setState(State.STATE_PAY_SUCCESS); // 付款成功


        Long end_time = DateUtil.getDayStartTime();    // 结束时间 为今天的开始(昨天的结束)
        Long start_time = end_time - (DateUtil.one_day*tianshu);   //  开始时间 为结束时间减去天数


        //  格式化返回时间  yyyy-mm-dd
        SimpleDateFormat sdf = DateUtil.getSdfShort();


        List<EntityKeyValue> entityKeyValueList = new LinkedList<>();

        while (start_time<end_time){
            Long endTime = start_time+DateUtil.one_day;

            tradeRecord72_find = (TradeRecord72) SunmingUtil.setQueryWhere_time(tradeRecord72_find,start_time,endTime);

            Iterator<TradeRecord72> tradeRecord72_ite = serializContext.findIterable(tradeRecord72_find);

            Long oneDayPrice = 0L;
            
            while(tradeRecord72_ite.hasNext()) {
            	
            	TradeRecord72 tradeRecord72_out = tradeRecord72_ite.next();
            	
                if(tradeRecord72_out.getShowPrice_fen_all() == null){ continue; };
                oneDayPrice += tradeRecord72_out.getShowPrice_fen_all();
            }


            String date = sdf.format(new Date(start_time));
            EntityKeyValue entityKeyValue = new EntityKeyValue(date,oneDayPrice/100);

            entityKeyValueList.add(entityKeyValue);

            start_time = endTime;
        }


        // 返回这个商家配置的日流水  和  他这几天 每天的订单总总金额
        request.setAttribute("oneDayLiuShui", ((Merchant72)user).getInOneDayLiuShui());
        request.setAttribute("liuShuiByTime", entityKeyValueList);
        this.setSuccessResultValue(this.getBasePath()+"edit_liushui.jsp");
        return SUCCESS;
    }




    /**
     * 发送通知   向商家发送未达到签约标准通知
     * @return
     */
    public String sendInform(){

        String id = this.getParameter("id");
        CheckException.checkIsTure(MyUtil.isValid(id),"id不正确");

        // 操作的 管理员
        UserV2 userv2 =	(UserV2) request.getAttribute(FinalVariable.SESSION_LOGINUSER);

        SendInformLog sendInformLog_add = new SendInformLog();

        sendInformLog_add.setMerchantId(id);
        sendInformLog_add.setAdmin(userv2);
        sendInformLog_add.setSendTime(System.currentTimeMillis());
        sendInformLog_add.setStart(SendInformLog.start_send);

        // 保存日志
        serializContext.save(sendInformLog_add);

        // 设置返回值
        JsonObject jo = new JsonObject();
        jo.addProperty("statusCode", "200");
        jo.addProperty("message", "发送成功！");
        this.setStrutsOutString(jo.toString());
        return SUCCESS;
    }

    /**
     * 胡金石 选中一个商户，点击预下架
     */
    public String yuxiajia() {

		String merchantId = this.getParameter("merchantId");
		CheckException.checkIsTure(MyUtil.isValid(merchantId),"id有误");


		MerchantRedEnvelope merchantRedEnvelope_find = new MerchantRedEnvelope();
		merchantRedEnvelope_find.setUserId_merchant(merchantId);
		Merchant72 merchant72 = (Merchant72) serializContext.findOne(Merchant72.class, merchantId);

		//商家名称
		this.request.setAttribute("nickname", merchant72.getNickname());

		//未领取
		merchantRedEnvelope_find.setState(State.STATE_WAITE_CHANGE);
		serializContext.findIterable(merchantRedEnvelope_find, pageSplit);
		this.request.setAttribute("STATE_WAITE_CHANGE_Size", pageSplit.getCount());

		//已领取
		merchantRedEnvelope_find.setState(State.STATE_OK);
		serializContext.findIterable(merchantRedEnvelope_find, pageSplit);
		this.request.setAttribute("STATE_OK_Size", pageSplit.getCount());

		//已使用
		merchantRedEnvelope_find.setState(State.STATE_FALSE);
		serializContext.findIterable(merchantRedEnvelope_find, pageSplit);
		this.request.setAttribute("STATE_FALSE_Size",pageSplit.getCount());

		//已过期
		merchantRedEnvelope_find.setState(State.STATE_CLOSED);
		serializContext.findIterable(merchantRedEnvelope_find, pageSplit);
		this.request.setAttribute("STATE_CLOSED_Size", pageSplit.getCount());

		//未激活
		merchantRedEnvelope_find.setState(State.STATE_WAITE_WAITSENDGOODS);
		serializContext.findIterable(merchantRedEnvelope_find, pageSplit);
		this.request.setAttribute("STATE_WAITE_WAITSENDGOODS_Size", pageSplit.getCount());

		this.request.setAttribute("merchantId", merchantId);
		this.setSuccessResultValue(this.getBasePath()+"yuxiajia.jsp");

        return SUCCESS;

    }

	/**
	 * 胡金石 确认预下架提交
	 */
	@AcceptUrlMethod(name = "保存确认预下架记录")
	public String yuxiajiaConfirm() {

		//获取登录后台管理员
		UserV2 userV2 = (UserV2) request.getAttribute(FinalVariable.SESSION_LOGINUSER);

		//获取Merchant72
		String merchantId = this.getParameter("merchantId");
		CheckException.checkIsTure(MyUtil.isValid(merchantId),"id有误");
		Merchant72 merchant72 = (Merchant72) serializContext.get(Merchant72.class, merchantId);

		//BusinessContext用于WriteBusiness
		BusinessContext instance = BusinessContext.getInstance();
		Business<ManagerOperationRecord> business = instance.getBusiness(BusinessIntIdConfigQier.businessIntId_merchant_yuxiajia);
		CheckException.checkIsTure(business != null, "预下架业务未配置!");

		Map requestMap = new HashMap();
		requestMap.putAll(request.getParameterMap());
		requestMap.put(Business.user_key, merchant72);
		requestMap.put(Business.ip_key, MyUtil.getIpAddr(request));
		requestMap.put(Business.requestFlow_key, new Long(System.currentTimeMillis()).toString());
//		requestMap.put("transter_memo", transter_memo);

		requestMap.put("userV2", userV2);

		//1.0商家文章下架
		MerchantPub merchantPub_find = new MerchantPub();
		merchantPub_find.setMerchant72_Id(merchantId);
		merchantPub_find.setRootPubConlumnId(MerchantShowAction.getRootPubConlumnId());
		Iterator<MerchantPub> merchantPub_ite = serializContext.findIterable(merchantPub_find);
		while (merchantPub_ite.hasNext()) {

			MerchantPub merchantPub_tmp = merchantPub_ite.next();

			MerchantPub merchantPub_update = new MerchantPub();
			merchantPub_update.setState(MerchantPub.state_false);

			serializContext.updateObject(merchantPub_tmp.getId(), merchantPub_update);

		}

		//2.0商家文章下架
		ShowPub showPub_find = new ShowPub();
		showPub_find.setMerchant72_Id(merchantId);
		showPub_find.setRootPubConlumnId(ConfigPub.getXiaochengxu());
		Iterator<ShowPub> showPub_ite = serializContext.findIterable(showPub_find);
		while (showPub_ite.hasNext()) {

			ShowPub showPub_tmp  = showPub_ite.next();

			ShowPub showPub_update = new ShowPub();
			showPub_update.setState(MerchantPub.state_false);

			serializContext.updateObject(showPub_tmp.getId(), showPub_update);

		}

		//保存记录
		ManagerOperationRecord mor = business.executeBusiness(requestMap);
		//serializContext.save(mor);

		// 设置返回值
		Integer state = mor.getState();

		if(State.STATE_OK.equals(state)) {

			this.setMessage("下架成功！");
			this.setStatusCode(StatusCode.ACCEPT_OK);
		}else {

			this.setMessage("下架失败！");
			this.setStatusCode(StatusCode.ACCEPT_FALSE);
		}
		return SUCCESS;
	}

	/**
	 * 胡金石 选中一个商户，点击红包转移
	 */
	public String hongbaozhuanyi() {

		String merchantId = this.getParameter("merchantId");
		CheckException.checkIsTure(MyUtil.isValid(merchantId),"id有误");


		MerchantRedEnvelope merchantRedEnvelope_find = new MerchantRedEnvelope();
		
		merchantRedEnvelope_find.setUserId_merchant(merchantId);
		merchantRedEnvelope_find.setState(State.STATE_OK);
		
		Merchant72 merchant72 = (Merchant72) serializContext.findOne(Merchant72.class, merchantId);

		//商家名称
		this.request.setAttribute("nickname", merchant72.getNickname());

		//红包总数
		serializContext.findIterable(merchantRedEnvelope_find, pageSplit);
		this.request.setAttribute("hongbaozongshu", pageSplit.getCount());

		//红包总金额
		Long amount = 0L;
		Iterator merchantRedEnvelope_ite = serializContext.findIterable(merchantRedEnvelope_find);
		while (merchantRedEnvelope_ite.hasNext()) {
			MerchantRedEnvelope merchantRedEnvelope_tmp = (MerchantRedEnvelope) merchantRedEnvelope_ite.next();
			amount += merchantRedEnvelope_tmp.getAmount();
		}
		this.request.setAttribute("hongbaozongjine", amount);

		//金额偏移：100、1000000
		this.request.setAttribute("offset", 1000000);

		//流水号
		this.request.setAttribute("nickname", merchant72);


		this.request.setAttribute("merchantId", merchantId);
		this.setSuccessResultValue(this.getBasePath()+"hongbaozhuanyi.jsp");
		return SUCCESS;

	}

	/**
	 * 胡金石 确认红包转移提交
	 */
	@AcceptUrlMethod(name = "保存确认红包转移记录")
	public String hongbaozhuanyiConfirm() {

		//获取登录后台管理员
		UserV2 userV2 = (UserV2) request.getAttribute(FinalVariable.SESSION_LOGINUSER);

		//获取Merchant72
		String merchantId = this.getParameter("merchantId");
		CheckException.checkIsTure(MyUtil.isValid(merchantId),"id有误");

		Merchant72 merchant72 = (Merchant72) ContextUtil.getSerializContext().get(Merchant72.class, merchantId);

		//BusinessContext用于WriteBusiness
		BusinessContext instance = BusinessContext.getInstance();
		Business<RedEnvelopeTransfer> business = instance.getBusiness(BusinessIntIdConfigQier.businessIntId_merchant_hongbaozhuanyi);
		CheckException.checkIsTure(business != null, "转账业务未配置!");

		Map requestMap = new HashMap();
		requestMap.putAll(request.getParameterMap());
		requestMap.put(Business.user_key, merchant72);
		requestMap.put(Business.ip_key, MyUtil.getIpAddr(request));
		requestMap.put(Business.requestFlow_key, this.getParameter("requestFlow"));
//		requestMap.put("transter_memo", transter_memo);

		requestMap.put("userV2", userV2);

		RedEnvelopeTransfer ret = business.executeBusiness(requestMap);

		 //设置返回值
		Integer state = ret.getState();

		if(State.STATE_OK.equals(state)) {

			this.setMessage("红包转移成功！");
			this.setStatusCode(StatusCode.ACCEPT_OK);
		}else {

			this.setMessage("红包转移失败！");
			this.setStatusCode(StatusCode.ACCEPT_FALSE);
		}
		return SUCCESS;
	}


	@Override
	protected void listParse(Object object_find) {
		super.listParse(object_find);
	}

	@Override
	protected Class<? extends SerializModel> getObjectClass() {
		return Merchant72.class;
	}
}
