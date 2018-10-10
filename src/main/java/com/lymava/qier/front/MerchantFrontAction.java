package com.lymava.qier.front;

import static java.lang.System.currentTimeMillis;

import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import com.lymava.qier.util.SunmingUtil;
import org.bson.types.ObjectId;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.lymava.base.face.action.FaceAction;
import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.state.State;
import com.lymava.commons.state.StatusCode;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.JsonUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.nosql.util.PageSplit;
import com.lymava.qier.action.CashierAction;
import com.lymava.qier.model.Cashier;
import com.lymava.qier.model.TradeRecord72;
import com.lymava.trade.base.model.BusinessIntIdConfig;
import com.lymava.trade.business.model.Product;
import com.lymava.trade.business.model.TradeRecord;
import com.lymava.userfront.util.FrontUtil;

public class MerchantFrontAction extends FaceAction {

    /**
	 * 
	 */
	private static final long serialVersionUID = 4672435400231820459L;
	
	public  User check_login_user() {
		User init_http_user = FrontUtil.init_http_user(request);
		CheckException.checkIsTure(init_http_user != null, "请先登录!",StatusCode.USER_INFO_TIMEOUT);
		return init_http_user;
	}

    /**
     * 检查是不是收银员
     * @param user
     * @return
     */
    public User get_merchant_user(User user){
    	
    	if(	CashierAction.getCashierUserGroutId().equals(user.getUserGroupId()) ){
    		if( MyUtil.isValid(user.getTopUserId()) ){
   			 return user.getTopUser();
    		}
    	}
    	
    	if(CashierAction.getMerchantUserGroutId().equals(user.getUserGroupId()) ){
    		 return user;
    	}
    	
    	return null;
    }
    


    /**
     * 查询出这个'商家今天'所有订单的统计数据
     * @return
     */
    public String queryAllOrderData(){

        // 检查登录
        User user = requestFrameMsg.getUser();
        user = this.get_merchant_user(user);

        TradeRecord72 tradeRecord72 = new TradeRecord72();
        
        tradeRecord72.setUser_merchant(user);
        tradeRecord72.setState(State.STATE_PAY_SUCCESS);
        
        Long start_time = DateUtil.getDayStartTime(currentTimeMillis());
        Long end_time = start_time+DateUtil.one_day;
        
        ObjectId today_start_object_id = new ObjectId(new Date(start_time));
        ObjectId today_end_object_id = new ObjectId(new Date(end_time));
        
        tradeRecord72.addCommand(MongoCommand.dayuAndDengyu, "id", today_start_object_id);
        tradeRecord72.addCommand(MongoCommand.xiaoyu, "id", today_end_object_id);

        List<TradeRecord72> tradeRecord72s = ContextUtil.getSerializContext().findAll(tradeRecord72);

        Long today_price_fen_all = 0L;
        Integer today_order = 0 + tradeRecord72s.size();

        HashMap<String,String> hashMap = new HashMap();

        for (int i=0; i<tradeRecord72s.size();i++){
            today_price_fen_all += tradeRecord72s.get(i).getShowPrice_fen_all();
            hashMap.put(tradeRecord72s.get(i).getUserId_huiyuan(),"0");
        }
        Integer renshu = hashMap.size();

        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("today_price_fen_all",today_price_fen_all);
        jsonObject.addProperty("today_order",today_order);
        jsonObject.addProperty("renshu",renshu);

        this.setDataRoot(jsonObject);
        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("响应成功");
        return SUCCESS;
    }


	/**
	 * 设置打印配置
	 */
	public String set_print_config() {

		User user_login = this.check_login_user();
		

		PageSplit pageSplit = this.getPageSplit();
		 
		this.setStatusCode(StatusCode.ACCEPT_OK);
		this.setMessage("设置成功");
		return SUCCESS;
	}

    /**
     * 查询订单
     * @return
     */
    public String query_tradeRecord(){
        // 检查登录  检查是不是收银员
        User user = requestFrameMsg.getUser();
        user = this.get_merchant_user(user);

        String payFlow = this.getParameter("payFlow");
        // 获取参数
        Long startTime = MathUtil.parseLongNull(this.getParameter("startTime"));
        Long endTime = MathUtil.parseLongNull(this.getParameter("endTime"));

        TradeRecord72 tradeRecord72 = new TradeRecord72();
        
		//业务订单
        tradeRecord72.setBusinessIntId(BusinessIntIdConfig.businessIntId_trade);
        
        tradeRecord72.setUser_merchant(user);
        if(MyUtil.isValid(payFlow)) {
        	tradeRecord72.setId(payFlow);
        }else {
        	tradeRecord72.setPayFlow(payFlow);
        }
        if(startTime != null){
        	ObjectId start_object_id = new ObjectId(new Date(startTime));
        	tradeRecord72.addCommand(MongoCommand.dayu, "id", start_object_id);
        }
        if(endTime != null){
        	ObjectId end_object_id = new ObjectId(new Date(endTime));
        	tradeRecord72.addCommand(MongoCommand.xiaoyuAndDengyu, "id", end_object_id);
        }
        
        tradeRecord72.setState(State.STATE_PAY_SUCCESS);
        
        Iterator<TradeRecord72> tradeRecord = serializContext.findIterable(tradeRecord72,pageSplit);

        // 孙M  5.5   (同时传入开始时间和结束时间)前台需要这段时间的顾客人数,总消费,总订单数   进行一次全查询(可能会有性能问题:数据较多的情况)
        Long today_price_fen_all = 0L;
        Integer today_order = 0;
        Integer renshu = 0;
        if(startTime != null  &&  endTime != null  && tradeRecord72.getUserId_merchant() != null){
            List<TradeRecord72> tradeRecord72s_findAll_byTime = serializContext.findAll(tradeRecord72);
            today_price_fen_all = 0L;      // 总消费金额
            today_order += SunmingUtil.listIsNull(tradeRecord72s_findAll_byTime); // 订单数
            HashMap<String,String> hashMap = new HashMap(); // 用于统计顾客人数
            for (int i=0;  i<SunmingUtil.listIsNull(tradeRecord72s_findAll_byTime);  i++){
                TradeRecord72 tradeRecord72_count = tradeRecord72s_findAll_byTime.get(i);
                if (tradeRecord72_count != null  &&  tradeRecord72_count.getPrice_fen_all() !=null){
                    today_price_fen_all += tradeRecord72_count.getShowPrice_fen_all();
                }
                hashMap.put(tradeRecord72_count.getUserId_huiyuan(),"0");
            }
            renshu = hashMap.size();
        }




        long last_order_time = System.currentTimeMillis();

        JsonArray jsonArray = new JsonArray();
        while(tradeRecord.hasNext()){
        	
        	TradeRecord72 tradeRecord72_next = tradeRecord.next();
        	
        	Product product = tradeRecord72_next.getProduct();
        	
        	JsonObject jsonObject_tradeRecord = new JsonObject();
        	
        	JsonUtil.addProperty(jsonObject_tradeRecord, "id", tradeRecord72_next.getId());
        	if(product != null){
       		JsonUtil.addProperty(jsonObject_tradeRecord, "product_name", product.getName());
        	}
        	JsonUtil.addProperty(jsonObject_tradeRecord, "price_fen_all", tradeRecord72_next.getShowPrice_fen_all());
        	
        	JsonUtil.addProperty(jsonObject_tradeRecord, "id_time_tmp", tradeRecord72_next.get_id_time_tmp());
        	JsonUtil.addProperty(jsonObject_tradeRecord, "showTime", tradeRecord72_next.getShowTime());
        	
        	JsonUtil.addProperty(jsonObject_tradeRecord, "showPay_method", tradeRecord72_next.getShowPay_method());
        	JsonUtil.addProperty(jsonObject_tradeRecord, "pay_method", tradeRecord72_next.getPay_method());
        	
        	JsonUtil.addProperty(jsonObject_tradeRecord, "showState", tradeRecord72_next.getShowState());
        	JsonUtil.addProperty(jsonObject_tradeRecord, "state", tradeRecord72_next.getState());
        	
        	JsonUtil.addProperty(jsonObject_tradeRecord, "payFlow", tradeRecord72_next.getShowPayFlow());
        	
        	jsonArray.add(jsonObject_tradeRecord);
        	
        	if(tradeRecord72_next.get_id_time_tmp() > last_order_time){
        		last_order_time = tradeRecord72_next.get_id_time_tmp();
        	}
        }
        
        this.addField("page", pageSplit.getPage());
        this.addField("lastPage", pageSplit.getLastPage());
        this.addField("pageSize", pageSplit.getPageSize());
        this.addField("count", pageSplit.getCount());
        this.addField("last_order_time", last_order_time);

        this.addField("today_price_fen_all", today_price_fen_all);
        this.addField("today_order", today_order);
        this.addField("renshu", renshu);
		
        this.setDataRoot(jsonArray);
        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("响应成功");
        return SUCCESS;
    } 

}
