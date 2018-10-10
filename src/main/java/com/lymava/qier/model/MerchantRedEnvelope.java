package com.lymava.qier.model;

import java.text.ParseException;
import java.util.Date;

import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.pay.PayFinalVariable;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.nosql.mongodb.vo.BaseModel;
import com.lymava.qier.business.BusinessIntIdConfigQier;
import com.lymava.trade.pay.model.PaymentRecord;
import com.lymava.trade.pay.model.PaymentRecordOperationRecord;
import com.mongodb.BasicDBList;
import com.mongodb.BasicDBObject;
import org.bson.types.ObjectId;

import javax.naming.Context;

/**
 * 商家的定向红包
 * @author lymava
 *
 */
public class MerchantRedEnvelope extends BaseModel {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6740015494399402261L;

	/**
	 * 红包名称
	 */
	private String red_envolope_name;
	/**
	 * 商户
	 */
	private Merchant72 user_merchant;
	/**
	 * 商户系统编号
	 */
	private String userId_merchant; 
	/**
	 * 领取商户
	 */
	private Merchant72 user_merchant_lingqu;
	/**
	 * 领取商户系统编号
	 */
	private String userId_merchant_lingqu; 
	/**
	 * 会员
	 */
	private User user_huiyuan;
	/**
	 * 会员系统编号
	 */
	private String userId_huiyuan;
	/**
	 * 红包总额	偏移金额
	 */
	private Long amount;
	/**
	 * 订单金额满多少减	单位偏移
	 */
	private Long amount_to_reach;
	/**
	 * 红包余额
	 */
	private Long balance;
	/**
	 * 定向红包状态
	 */
	private Integer state;
	/**
	 * 	定向红包的过期时间
	 */
	private Long expiry_time;
	/**
	 * 	定向红包的领取时间
	 */
	private Long lingqu_time;
	/**
	 * 领取的订单
	 */
	private TradeRecord72 tradeRecord72;
	/**
	 * 领取的订单	系统编号
	 */
	private String tradeRecord72_id;
	/**
	 * 商家类型
	 */
	private String merchant_type;
	/**
	 * 排序时间
	 */
	private Long index_id;
	/**
	 * 经纬度数组
	 */
	private BasicDBList location;
	/**
	 * 当前用户距离
	 */
	private Double distance;
	
	public Long getAmount_to_reach_fen() {
		if(amount_to_reach == null) {
			return null;
		}
		return amount_to_reach/User.pianyiFen;
	}
	public Double getAmount_to_reach_yuan() {
		if(amount_to_reach == null) {
			return null;
		}
		return MathUtil.divide(amount_to_reach, User.pianyiYuan).doubleValue();
	}
	public Long getAmount_to_reach() {
		return amount_to_reach;
	}
	public void setAmount_to_reach(Long amount_to_reach) {
		this.amount_to_reach = amount_to_reach;
	}
	public void setInAmount_to_reach(String amount_to_reach_yuan) {
		Double parseDoubleNull = MathUtil.parseDoubleNull(amount_to_reach_yuan);
		if(parseDoubleNull == null){
			return;
		}
		Long amount_to_reach_fen = MathUtil.multiply(parseDoubleNull, 100).longValue();
		this.amount_to_reach = amount_to_reach_fen*User.pianyiFen;
	}
	/**
	 * 胡金石 获取消费这个定向红包的订单
	 * @return
	 */
	public TradeRecord72 getConsumeTradeRecord72() {

		TradeRecord72 tradeRecord72  = null;
		PaymentRecordOperationRecord paymentRecord = new PaymentRecordOperationRecord();

		paymentRecord.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_dingxiang);
		paymentRecord.setRequestFlow(this.getId());

		paymentRecord = (PaymentRecordOperationRecord)ContextUtil.getSerializContext().get(paymentRecord);

		if(paymentRecord != null && MyUtil.isValid(paymentRecord.getPaymentRecord_id()) ) {
			tradeRecord72 = (TradeRecord72) ContextUtil.getSerializContext().get(TradeRecord72.class, paymentRecord.getPaymentRecord_id());
		}

		return tradeRecord72;
	}
	
	public static void main(String[] args) {
		
		// 经度
		Double longitude = 106.593888d;
		// 纬度
		Double latitude = 29.571829d;
		
		BasicDBList values = new BasicDBList(); 
		
		values.add(longitude);
		values.add(latitude);
		
		 
		BasicDBObject basicDBObject_root = new BasicDBObject();
		
		BasicDBObject basicDBObject_near = new BasicDBObject();
		basicDBObject_near.put("$maxDistance", 5000);
		
		basicDBObject_root.put("$near", basicDBObject_near);
		
		BasicDBObject basicDBObject_geometry = new BasicDBObject();
		basicDBObject_geometry.put("type" , "Point");
		basicDBObject_geometry.put("coordinates" , values);
		
		basicDBObject_near.put("$geometry", basicDBObject_geometry);
		
		
		System.out.println(basicDBObject_root);
	}
	
	static{
		putConfig(MerchantRedEnvelope.class, "state_"+State.STATE_WAITE_CHANGE, "未领取");
		putConfig(MerchantRedEnvelope.class, "state_"+State.STATE_OK, "已领取");
		putConfig(MerchantRedEnvelope.class, "state_"+State.STATE_FALSE, "已使用");
		putConfig(MerchantRedEnvelope.class, "state_"+State.STATE_CLOSED, "已过期");
		putConfig(MerchantRedEnvelope.class, "state_"+State.STATE_WAITE_WAITSENDGOODS, "未激活");
		putConfig(MerchantRedEnvelope.class, "state_"+State.STATE_WAITE_CODWAITRECEIPTCONFIRM, "已转移");
		putConfig(MerchantRedEnvelope.class, "state_"+State.STATE_ORDER_NOT_EXIST, "小黑屋");
		putConfig(MerchantRedEnvelope.class, "state_"+State.STATE_WAITE_PROCESS, "转赠中");
	}
	
	public void check_can_use(TradeRecord72 tradeRecord72) {
		//状态异常的
		CheckException.checkIsTure(State.STATE_OK.equals(this.getState()), "定向红包状态异常不能使用!");
		//不是本用户的
		CheckException.checkIsTure(this.getUserId_huiyuan() != null && this.getUserId_huiyuan().equals(tradeRecord72.getUserId_huiyuan()), "定向红包不存在!");
		//不是本商家的
		CheckException.checkIsTure(this.getUserId_merchant() != null && this.getUserId_merchant().equals(tradeRecord72.getUserId_merchant()), "定向红包不存在!");
		//没达到订单金额的
		Long showPrice_fen_all = tradeRecord72.getShowPrice_fen_all();
		
		//如果这个设置了 满减金额的
		if(this.getAmount_to_reach_fen() != null) {
			CheckException.checkIsTure(showPrice_fen_all >= this.getAmount_to_reach_fen(), "此定向红包最低需要消费"+this.getAmount_to_reach_yuan()+"元才能使用!");
		}
		
	}
	
	public String getShowDistance() {
		
		if(distance  == null) {
			return "";
		}
		if(distance < 1000) {
			return distance.intValue()+"米";
		}
		
		int distance_tmp = (int)(distance/100);
		
		return distance_tmp/10d+"km";
	}
	public Double getDistance() {
		return distance;
	}

	public void setDistance(Double distance) {
		this.distance = distance;
	}

	public Double getLongitude() {
		if(location != null && location.size() > 0) {
			return (Double) location.get(0);
		}
		return null;
	}

	public Double getLatitude() {
		if(location != null && location.size() > 1) {
			return (Double) location.get(1);
		}
		return null;
	}
	public BasicDBList getLocation() {
		return location;
	}
	public void setLocation(BasicDBList location) {
		this.location = location;
	}
	public String getMerchant_type() {
		return merchant_type;
	}
	public void setMerchant_type(String merchant_type) {
		this.merchant_type = merchant_type;
	}
	public Long getIndex_id() {
		return index_id;
	}
	public void setIndex_id(Long index_id) {
		this.index_id = index_id;
	}
	public TradeRecord72 getTradeRecord72() {
		if (tradeRecord72 == null && MyUtil.isValid(this.getTradeRecord72_id())) {
			tradeRecord72 = (TradeRecord72) ContextUtil.getSerializContext().get(TradeRecord72.class, this.getTradeRecord72_id());
		}
		return tradeRecord72;
	}
	public void setTradeRecord72(TradeRecord72 tradeRecord72) {
		if( tradeRecord72 != null){
			tradeRecord72_id = tradeRecord72.getId();
		}
		this.tradeRecord72 = tradeRecord72;
	}
	public String getTradeRecord72_id() {
		return tradeRecord72_id;
	}
	public void setTradeRecord72_id(String tradeRecord72_id) {
		this.tradeRecord72_id = tradeRecord72_id;
	}
	public String getShowIndex_id(){
        if (this.getIndex_id() == null){
            return "";
        }
        Date date = new Date(this.getIndex_id());
        return DateUtil.getSdfFull().format(date);
    }
	public void setInIndex_id(String index_id_str) {
	        Date date = null;
	        try {
	            date = DateUtil.getSdfFull().parse(index_id_str);
	            this.index_id = date.getTime();
	        } catch (ParseException e) {
	        }
	}
	public String getShowExpiryMonthDay(){
		   if (this.getExpiry_time() == null){
	            return "";
	        }
	        Date date = new Date(this.getExpiry_time());
	        return DateUtil.getSdfMonthDay().format(date);
	}
	public String getShowExpiry_time(){
	        if (this.getExpiry_time() == null){
	            return "";
	        }
	        Date date = new Date(this.getExpiry_time());
	        return DateUtil.getSdfFull().format(date);
	    }
	public void setInExpiry_time(String inExpiry_time_str) {
		System.out.println("-------------------------"+inExpiry_time_str);
	        Date date = null;
	        try {
	            date = DateUtil.getSdfFull().parse(inExpiry_time_str);
	            this.expiry_time = date.getTime();
	        } catch (ParseException e) {
	        }
	} 
	public String getShowLingqu_time(){
        if (this.getLingqu_time() == null){
            return "";
        }
        Date date = new Date(this.getLingqu_time());
        return DateUtil.getSdfFull().format(date);
    }
	public void setInLingqu_time(String inLingqu_time_str) {
	        Date date = null;
	        try {
	            date = DateUtil.getSdfFull().parse(inLingqu_time_str);
	            this.lingqu_time = date.getTime();
	        } catch (ParseException e) {
	        }
	} 
	public Long getLingqu_time() {
		return lingqu_time;
	}
	public void setLingqu_time(Long lingqu_time) {
		this.lingqu_time = lingqu_time;
	}
	public Long getExpiry_time() {
		return expiry_time;
	}
	public void setExpiry_time(Long expiry_time) {
		this.expiry_time = expiry_time;
	}
	public String getRed_envolope_name() {
		return red_envolope_name;
	}
	public void setRed_envolope_name(String red_envolope_name) {
		this.red_envolope_name = red_envolope_name;
	}
	public Long getAmount() {
		return amount;
	}
	public void setInAmount(String amount_yuan) {
		
		Double parseDoubleNull = MathUtil.parseDoubleNull(amount_yuan);
		if(parseDoubleNull == null){
			return;
		}

		Long amount_fen = MathUtil.multiply(parseDoubleNull, 100).longValue();
		
		this.amount = amount_fen*User.pianyiFen;
	}
	public void setAmount(Long amount) {
		this.amount = amount;
	}
	public String getShowState(){
		 return (String) getConfig("state_"+this.getState());
	}
	public Integer getState() {
		return state;
	}
	public void setState(Integer state) {
		this.state = state;
	}
	/**
	 * 显示用户余额 单位元
	 * @return
	 */
	public String getBalanceYuan() {
		return Double.toString(MathUtil.divide(this.getBalance(),User.pianyiYuan).doubleValue());
	}  
	public Long getBalanceFen() {
		if(balance == null){
			return null;
		}
		return balance/User.pianyiFen;
	}
	public Long getAmountFen() {
		if(amount == null){
			return null;
		}
		return amount/User.pianyiFen;
	}
	/**
	 * @param change	单位分
	 */
	public void balanceChange(Long change){
		User userUpdate = new User();
		if(this.balance == null){
			userUpdate.addCommand(MongoCommand.set, "balance", change);
		}else{
			userUpdate.addCommand(MongoCommand.jiaDengyu, "balance", change);
		}
		 
		ContextUtil.getSerializContext().commandUpdateObject(User.class,this.getId(), userUpdate);
	}
	/**
	 * @param change	单位分
	 */
	public void balanceChangeFen(Integer changeFen){
		
		Long change = changeFen*User.pianyiFen;
		
		this.balanceChange(change);
	}
	/**
	 * @param change	单位分
	 */
	public void balanceChangeFen(Long changeFen){
		
		Long change = changeFen*User.pianyiFen;
		
		this.balanceChange(change);
	}
	/**
	 * @param change	单位元
	 */
	public void balanceChangeYuan(Double changeYuan){
		
		Long change = MathUtil.multiply(changeYuan, User.pianyiYuan).longValue();
		 
		this.balanceChange(change);
	}
	public Long getBalance() {
		return balance;
	}
	public void setInBalance(String balance_yuan) {
		
		Double parseDoubleNull = MathUtil.parseDoubleNull(balance_yuan);
		if(parseDoubleNull == null){
			return;
		}

		Long balance_fen = MathUtil.multiply(parseDoubleNull, 100).longValue();
		
		this.balance = balance_fen*User.pianyiFen;
	}
	public void setBalance(Long balance) {
		this.balance = balance;
	}
	public Merchant72 getUser_merchant() {
		if (user_merchant == null && MyUtil.isValid(this.userId_merchant)) {
			user_merchant = (Merchant72) ContextUtil.getSerializContext().get(Merchant72.class, userId_merchant);
		}
		return user_merchant;
	}
	public void setUser_merchant(Merchant72 user_merchant) {
		if (user_merchant != null) {
			userId_merchant = user_merchant.getId();
		}
		this.user_merchant = user_merchant;
	}
	public String getUserId_merchant() {
		return userId_merchant;
	}
	public void setUserId_merchant(String userId_merchant) {
		this.userId_merchant = userId_merchant;
	}  
	
	public User getUser_huiyuan() {
		if (user_huiyuan == null && MyUtil.isValid(this.userId_huiyuan)) {
			user_huiyuan = (User) ContextUtil.getSerializContext().get(User.class, userId_huiyuan);
		}
		return user_huiyuan;
	}

	public void setUser_huiyuan(User user_huiyuan) {
		if (user_huiyuan != null) {
			userId_huiyuan = user_huiyuan.getId();
		}
		this.user_huiyuan = user_huiyuan;
	}

	public String getUserId_huiyuan() {
		return userId_huiyuan;
	}

	public void setUserId_huiyuan(String userId_huiyuan) {
		this.userId_huiyuan = userId_huiyuan;
	}
	
	public Merchant72 getUser_merchant_lingqu() {
		if (user_merchant_lingqu == null && MyUtil.isValid(this.userId_merchant_lingqu)) {
			user_merchant_lingqu = (Merchant72) ContextUtil.getSerializContext().get(Merchant72.class, userId_merchant_lingqu);
		}
		return user_merchant_lingqu;
	}
	public void setUser_merchant_lingqu(Merchant72 user_merchant_lingqu) {
		if (user_merchant_lingqu != null) {
			userId_merchant_lingqu = user_merchant_lingqu.getId();
		}
		this.user_merchant_lingqu = user_merchant_lingqu;
	}
	public String getUserId_merchant_lingqu() {
		return userId_merchant_lingqu;
	}
	public void setUserId_merchant_lingqu(String userId_merchant_lingqu) {
		this.userId_merchant_lingqu = userId_merchant_lingqu;
	}
	/**
	 * 领取红包
	 * @param init_http_user
	 */
	public void lingqu(User init_http_user) {
		
//		MerchantRedEnvelope merchantRedEnvelope_update = new MerchantRedEnvelope();
//		
//		merchantRedEnvelope_update.setState(State.STATE_OK);
//		merchantRedEnvelope_update.setUserId_huiyuan(init_http_user.getId());
//		merchantRedEnvelope_update.setTradeRecord72_id(tradeRecord_id);
//		
//		serializContext.updateObject(merchantRedEnvelope.getId(), merchantRedEnvelope_update);
		
		
	}
	
	
	
	@Override
	public String toString() {
		return "MerchantRedEnvelope [red_envolope_name=" + red_envolope_name + ", user_merchant=" + user_merchant
				+ ", userId_merchant=" + userId_merchant + ", user_merchant_lingqu=" + user_merchant_lingqu
				+ ", userId_merchant_lingqu=" + userId_merchant_lingqu + ", user_huiyuan=" + user_huiyuan
				+ ", userId_huiyuan=" + userId_huiyuan + ", amount=" + amount + ", amount_to_reach=" + amount_to_reach
				+ ", balance=" + balance + ", state=" + state + ", expiry_time=" + expiry_time + ", lingqu_time="
				+ lingqu_time + ", tradeRecord72=" + tradeRecord72 + ", tradeRecord72_id=" + tradeRecord72_id
				+ ", merchant_type=" + merchant_type + ", index_id=" + index_id + ", location=" + location
				+ ", distance=" + distance + "]";
	}
    
    
}
