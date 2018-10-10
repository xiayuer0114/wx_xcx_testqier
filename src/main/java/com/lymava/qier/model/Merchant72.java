package com.lymava.qier.model;

import java.util.Date;
import java.util.Map;

import org.bouncycastle.ocsp.Req;

import com.lymava.base.model.User;
import com.lymava.base.safecontroler.model.UserV2;
import com.lymava.base.util.ContextUtil;
import com.lymava.base.util.WebConfigContent;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.HttpUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.qier.util.DiLiUtil;
import com.mongodb.BasicDBList;

public class Merchant72 extends User{

	/**
	 * 
	 */
	private static final long serialVersionUID = -7513140722554854033L;

	/**
	 * 商家的简单信息
	 */
	private String simInfo;
	/**
	 * 经度
	 */
	private Double longitude;
	/**
	 * 纬度
	 */
	private Double latitude;
	/**
	 * 经纬度数组
	 */
	private BasicDBList location;
	/**
	 * 营业时间   只是做展示
	 */
	private String businessHours;
	/**
	 *店家的电话   与法人的私人电话区分
	 */
	private String merchart72Phone;
	/**
	 * 业务员id
	 */
	private String salesmanId;
	/**
	 * 业务员
	 */
	private Salesman salesman;

	// 业务员id   以前使用的salesmanId,  salesmanId是属于'用户', 现在用公司内部人员userRoleId (userRole中有userV2)
	private String userv2_yewuyuan_id;

	// 业务员
	private UserV2 userv2_yewuyuan;
	/**
	 * 红包使用人数
	 */
	private Integer useRed_renshu;
	/**
	 * 商家的日日流水   偏移6位  (User.pianyiFen)
	 */
	private Long oneDayLiuShui;
	/**
	 * 通用红包最大发放比例	偏移4位
	 * 1 代表0.01%
	 */
	private Integer merchant_red_pack_ratio;  
	/**
	 * 商户折扣比例	偏移分
	 * 1 代表0.01%
	 */
	private Integer discount_ratio;
	/**
	 * 红包最大发放比例	偏移4位
	 * 1 代表0.01%
	 */
	private Integer red_pack_ratio_max;
	/**
	 * 红包最小发放比例	偏移4位
	 * 1 代表0.01%
	 */
	private Integer red_pack_ratio_min;
	/**
	 * 商户的报表数据 每天查询的开始时间 (小时)
	 */
	private Integer queryHour;
	/**
	 * 打印联数
	 */
	private Integer print_count;
	/**
	 * 我们在商家预购的额度剩余	全偏移
	 */
	private Long merchant_balance;
	/**
	 * 买单成功后接收通知消息的openid
	 */
	private String notify_openid;
	/**
	 * 买单成功后接收通知消息的openid list
	 */
	private BasicDBList notify_openid_list;
	/**
	 * 商家定向红包余额	单位分
	 * 商家定向资金池子
	 */
	private Long merchant_redenvelope_balance_fen;
	/**
	 * 商家定向红包余额 是否与上级共享
	 */
	private Integer merchant_redenvelope_share; 
	/**
	 * 比如商家红包到达这个之后就开始检测并生成红包
	 * 	放在红包库里
	 * 		单位分
	 */
	private Long merchant_redenvelope_arrive_fen;
	/**
	 * 商家订单自动打印
	 * 	{@link State#STATE_OK}		自动打印
	 *  {@link State#STATE_FALSE}	关闭自动打印
	 */
	private Integer state_auto_print;
	/**
	 * 默认打印机名称
	 */
	private String default_printer_name;
	/**
	 * 打印联数
	 */
	private Integer print_lianshu;
    /**
     * 商家类型 标识  如:酒吧 牛排
     */
    private String merchant72_type;
	/**
	 * 	新订单语音播报
	 * 	{@link State#STATE_OK}		开启
	 *  {@link State#STATE_FALSE}	关闭
	 */
	private Integer state_auto_voice;
	/**
	 * 	扫码牌金额预置
	 * 	{@link State#STATE_OK}		开启功能
	 *  {@link State#STATE_FALSE}	关闭
	 */
	private Integer state_shaoma_yuzhi;
	/**
	 * 领取定向红包的金额配置
	 * 	高于多少的订单才能领取红
	 * 	0 	就是不设置领取的金额默认去全局的领取的金额
	 * -1	就是不限制金额
	 */
	private Integer receive_red_envelope_order_price_fen;
	/**
	 * 自动生成	定向红包
	 */
	public static final Integer receive_red_envelope_create_type_autocraete = State.STATE_OK;
	/**
	 * 不自动生成	定向红包
	 */
	public static final Integer amount_type_trade_bili_xinkehu_manual = State.STATE_FALSE; 
	/**
	 * 定向红包发放类型
	 */
	private  Integer receive_red_envelope_create_type;
	/**
	 * 新客户营销
	 */
	public static final Integer receive_red_envelope_lingqu_type_xinkehu = State.STATE_OK;
	/**
	 * 老客户营销
	 */
	public static final Integer amount_type_trade_bili_laokehu = State.STATE_FALSE;
	/**
	 * 营销类型
	 */
	private  Integer receive_red_envelope_lingqu_type;
	
	static{
		Class<?> classTmp = User.class;
		
		putConfig(classTmp, "merchant_redenvelope_share_"+State.STATE_OK, "共享");
		putConfig(classTmp, "merchant_redenvelope_share_"+State.STATE_FALSE, "不共享");
		
		putConfig(classTmp, "receive_red_envelope_create_type_"+receive_red_envelope_create_type_autocraete, "自动生成");
		putConfig(classTmp, "receive_red_envelope_create_type_"+amount_type_trade_bili_xinkehu_manual, "不自动生成");
		
		putConfig(classTmp, "receive_red_envelope_lingqu_type_"+receive_red_envelope_lingqu_type_xinkehu, "新客户营销");
		putConfig(classTmp, "receive_red_envelope_lingqu_type_"+amount_type_trade_bili_laokehu, "老客户营销");
	}
	
	public String getShowReceive_red_envelope_create_type(){
		 return (String) getConfig("receive_red_envelope_create_type_"+this.getReceive_red_envelope_create_type());
	}
	public String getShowReceive_red_envelope_lingqu_type(){
		 return (String) getConfig("receive_red_envelope_lingqu_type_"+this.getReceive_red_envelope_lingqu_type());
	}
	public Integer getReceive_red_envelope_lingqu_type() {
		return receive_red_envelope_lingqu_type;
	}
	public void setReceive_red_envelope_lingqu_type(Integer receive_red_envelope_lingqu_type) {
		this.receive_red_envelope_lingqu_type = receive_red_envelope_lingqu_type;
	}
	public Integer getReceive_red_envelope_create_type() {
		return receive_red_envelope_create_type;
	}
	public void setReceive_red_envelope_create_type(Integer receive_red_envelope_create_type) {
		this.receive_red_envelope_create_type = receive_red_envelope_create_type;
	} 
	public String getShowMerchant_redenvelope_share(){
		String state = (String)getConfig("merchant_redenvelope_share_"+this.merchant_redenvelope_share);
		return state; 
	}
	public Integer getMerchant_redenvelope_share() {
		return merchant_redenvelope_share;
	}
	public void setMerchant_redenvelope_share(Integer merchant_redenvelope_share) {
		this.merchant_redenvelope_share = merchant_redenvelope_share;
	}
	/**
	 * 优先取 receive_red_envelope_order_price_fen 定向红包领取的金额
	 * 如果为空或者小于等于0  那么就取全局的配置 WebConfigContent.getConfig("receive_red_envelope_order_price_yuan"); 的金额
	 * 
	 * @return 获取商户的最终的可领取定向红包的订单金额
	 */
	public Integer getFinalReceive_red_envelope_order_price_fen() {
		
		if(receive_red_envelope_order_price_fen != null && receive_red_envelope_order_price_fen > 0) {
			return receive_red_envelope_order_price_fen;
		}
		
		String receive_red_envelope_order_price_yuan_str = WebConfigContent.getConfig("receive_red_envelope_order_price_yuan");
		Double receive_red_envelope_order_price_yuan = MathUtil.parseDouble(receive_red_envelope_order_price_yuan_str);
		
		Integer receive_red_envelope_order_price_fen_tmp = MathUtil.multiply(receive_red_envelope_order_price_yuan, 100).intValue();
		return receive_red_envelope_order_price_fen_tmp;
	}
	public Integer getReceive_red_envelope_order_price_fen() {
		return receive_red_envelope_order_price_fen;
	}
	public void setReceive_red_envelope_order_price_fen(Integer receive_red_envelope_order_price_fen) {
		this.receive_red_envelope_order_price_fen = receive_red_envelope_order_price_fen;
	}
	public void setInReceive_red_envelope_order_price_yuan(String merchant_redenvelope_arrive_yuan) {
		double merchant_redenvelope_arrive_yuan_double = MathUtil.parseDouble(merchant_redenvelope_arrive_yuan);
		this.receive_red_envelope_order_price_fen = MathUtil.multiply(merchant_redenvelope_arrive_yuan_double, 100).intValue();
	}
	public SettlementBank getSettlementBank() {
		
		SettlementBank  settlementBank_find = new SettlementBank();
        
        settlementBank_find.setMerchant72_id(id);
        settlementBank_find = (SettlementBank) ContextUtil.getSerializContext().get(settlementBank_find);
		
        return settlementBank_find;
	}
	
	public void useRedRenshu_znegjia(Integer use_count){
		
		Merchant72 userUpdate = new Merchant72();
		
		if(this.useRed_renshu == null){
			userUpdate.addCommand(MongoCommand.set, "useRed_renshu", use_count);
		}else{
			userUpdate.addCommand(MongoCommand.jiaDengyu, "useRed_renshu", use_count);
		}
		
		ContextUtil.getSerializContext().commandUpdateObject(Merchant72.class,this.getId(), userUpdate);
	}
	
    @Override
	public Integer beforeSave() {
    	return BLOCK_NO;
	}
	@Override
	public Integer beforeUpdate() {
		return BLOCK_NO;
	}
	public Integer getState_auto_voice() {
		return state_auto_voice;
	}
	public void setState_auto_voice(Integer state_auto_voice) {
		this.state_auto_voice = state_auto_voice;
	}
	public Integer getState_shaoma_yuzhi() {
		return state_shaoma_yuzhi;
	}
	public void setState_shaoma_yuzhi(Integer state_shaoma_yuzhi) {
		this.state_shaoma_yuzhi = state_shaoma_yuzhi;
	}
	public BasicDBList getLocation() { 
		return location;
	}
	public void setLocation(BasicDBList location) {
		this.location = location;
	}
	public void addNotify_openid(String notify_openid) {
    	if(notify_openid_list == null) {
    		notify_openid_list = new BasicDBList();
    	}else {
    		notify_openid_list.remove(notify_openid);
    	}
    	notify_openid_list.add(notify_openid);
    } 
	public BasicDBList getNotify_openid_list() {
		return notify_openid_list;
	}
	public void setNotify_openid_list(BasicDBList notify_openid_list) {
		this.notify_openid_list = notify_openid_list;
	}
	public String getMerchant72_type() {
		return merchant72_type;
	}
	public void setMerchant72_type(String merchant72_type) {
		this.merchant72_type = merchant72_type;
	}
	public Integer getPrint_lianshu() {
		return print_lianshu;
	}
	public void setPrint_lianshu(Integer print_lianshu) {
		this.print_lianshu = print_lianshu;
	}
	public String getDefault_printer_name() {
		return default_printer_name;
	}
	public void setDefault_printer_name(String default_printer_name) {
		this.default_printer_name = default_printer_name;
	}
	/**
	 * @param changeFen	单位分
	 */
	public void share_merchant_redenvelope_balance_changeFen(Long changeFen){
		//如果额度是被共享的 检查上级用户的余额
		if(State.STATE_OK.equals(this.getMerchant_redenvelope_share())){
			Merchant72 merchant72_top  = this.getTopMerchant72();
			if(merchant72_top != null){
				merchant72_top.share_merchant_redenvelope_balance_changeFen(changeFen);
			}
		}
		this.merchant_redenvelope_balance_changeFen(changeFen);
	}
	/**
	 * @param changeFen	单位分
	 */
	public void merchant_redenvelope_balance_changeFen(Long changeFen){
		
		Merchant72 userUpdate = new Merchant72();
		
		if(this.merchant_redenvelope_balance_fen == null){
			userUpdate.addCommand(MongoCommand.set, "merchant_redenvelope_balance_fen", changeFen);
		}else{
			userUpdate.addCommand(MongoCommand.jiaDengyu, "merchant_redenvelope_balance_fen", changeFen);
		}
		 
		ContextUtil.getSerializContext().commandUpdateObject(Merchant72.class,this.getId(), userUpdate);
	}
	public Long getMerchant_redenvelope_balance_fen() {
		return merchant_redenvelope_balance_fen;
	}
	public void setMerchant_redenvelope_balance_fen(Long merchant_redenvelope_balance_fen) {
		this.merchant_redenvelope_balance_fen = merchant_redenvelope_balance_fen;
	}
	public Long getMerchant_redenvelope_arrive_fen() {
		return merchant_redenvelope_arrive_fen;
	}
	public void setInMerchant_redenvelope_arrive_yuan(String merchant_redenvelope_arrive_fen) {
		if(merchant_redenvelope_arrive_fen == null){
			merchant_redenvelope_arrive_fen = "0";
		}
		this.merchant_redenvelope_arrive_fen = MathUtil.multiply(merchant_redenvelope_arrive_fen, 100).longValue();
	}
	public void setMerchant_redenvelope_arrive_fen(Long merchant_redenvelope_arrive_fen) {
		this.merchant_redenvelope_arrive_fen = merchant_redenvelope_arrive_fen;
	}
	public Integer getState_auto_print() {
		return state_auto_print;
	}
	public void setState_auto_print(Integer state_auto_print) {
		this.state_auto_print = state_auto_print;
	}
	@Override
	public String getShowAddress() {
		
		StringBuilder show_addr = new StringBuilder();
		
		if( this.getQu() != null && !getShi().equals(this.getQu()) ){
			show_addr.append(this.getQu());
		}
		if( this.getAddress() != null ){
			show_addr.append(this.getAddress());
		}
		
		return show_addr.toString();
	} 
	public String getNotify_openid() {
		return notify_openid;
	}
	public void setNotify_openid(String notify_openid) {
		this.notify_openid = notify_openid;
	}
	/**
	 * 获取利润 出来
	 * @param price_fen_all
	 * @return
	 */
	public Long get_profit_fen(Long price_fen_all){
		CheckException.checkIsTure(discount_ratio != null, "discount_ratio:未配置!");
		//利润
		Long profit_fen = MathUtil.multiply(price_fen_all, discount_ratio).longValue()/Merchant72.pianyiYuan;
		
		return profit_fen;
	}
	/**
	 * 红包发送金额 最大值
	 * @param price_fen_all
	 * @return
	 */
	public Long get_red_pack_fen_max(Long price_fen_all){
		CheckException.checkIsTure(red_pack_ratio_max != null, "red_pack_ratio_max:未配置!");
		
		Long  profit_fen = this.get_profit_fen(price_fen_all);
		//红包发送金额 最大值
		Long red_pack_fen_max = MathUtil.multiply(profit_fen, red_pack_ratio_max).longValue()/Merchant72.pianyiYuan;
		
		return red_pack_fen_max;
	}
	/**
	 * 红包发送金额 最小值
	 * @param price_fen_all
	 * @return
	 */
	public Long get_red_pack_fen_min(Long price_fen_all){
		CheckException.checkIsTure(red_pack_ratio_min != null, "red_pack_ratio_min:未配置!");
		
		Long  profit_fen = this.get_profit_fen(price_fen_all);
		//红包发送金额 最大值
		Long red_pack_fen_min = MathUtil.multiply(profit_fen, red_pack_ratio_min).longValue()/Merchant72.pianyiYuan;
		
		return red_pack_fen_min;
	}
	/**
	 * 红包发送金额 最小值
	 * @param price_fen_all
	 * @return
	 */
	public Long get_merchant_red_pack_fen(Long price_fen_all){
		//检查商户红包配置
		CheckException.checkIsTure(merchant_red_pack_ratio != null, "merchant_red_pack_ratio:未配置!");
		//拿到利润
		Long  profit_fen = this.get_profit_fen(price_fen_all);
		//红包发送金额 最大值
		Long red_pack_fen_min = MathUtil.multiply(profit_fen, merchant_red_pack_ratio).longValue()/Merchant72.pianyiYuan;
		
		return red_pack_fen_min;
	}
	
	public String getCurrentDayStr(){
		return getCurrentDayStr(System.currentTimeMillis());
	}
	
	public String getCurrentDayStr(Long currentTimeMillis){
		if(queryHour == null) {
			queryHour = 0;
		}
		
		Long current_day = currentTimeMillis-DateUtil.one_hour*queryHour;
		
		String format = DateUtil.getSdfShort().format(new Date(current_day));
		
		return format;
	}
	
	@Override
	public void parseBeforeSave(Map parameterMap) {
		
	}
	@Override
	public void parseBeforeSearch(Map parameterMap) {
		
		String unionid = HttpUtil.getParemater(parameterMap, "unionid");
		
		if(!MyUtil.isEmpty(unionid)) {
			this.setUnionid(unionid);
		}
		
	}
	/**
	 * 校验可用余额是否足够
	 * @param productPrice_pianyi	检查是否有足够的可用余额	 单位偏移余额
	 * @throws CheckException	如果不足抛出异常
	 */
	public void checkMerchantBalanceFen(Long productPrice_fen) throws CheckException{
		 this.checkMerchantBalance(productPrice_fen*User.pianyiFen);
	}
	/**
	 * 校验可用余额是否足够
	 * @param productPrice_pianyi	检查是否有足够的可用余额	 单位偏移余额
	 * @throws CheckException	如果不足抛出异常
	 */
	public void checkMerchantBalance(Long productPrice_pianyi) throws CheckException{
		//如果额度是被共享的 检查上级用户的余额
		if(share_balance_yes.equals(this.getShare_balance())  || State.STATE_OK.equals(this.getShare_balance()) ){
			Merchant72 topMerchant72 = this.getTopMerchant72();
			//又是额度共享 上级商户不存在 或者 上级商户状态有问题
			CheckException.checkIsTure(topMerchant72 != null && User.STATE_OK.equals( topMerchant72.getState() ),"用户校验失败!");
			//检查上级商户的额度
			topMerchant72.checkMerchantBalance(productPrice_pianyi);
		}else {
			Long merchant_balance = this.getMerchant_balance();
			CheckException.checkIsTure(merchant_balance != null && productPrice_pianyi != null && merchant_balance > productPrice_pianyi, "商户余额不足!");
		}
	}
	/**
	 * 获取上级商户
	 * @return
	 */
	public Merchant72 getTopMerchant72() {
		Merchant72 merchant72_top = null;
		if(MyUtil.isValid(this.getTopUserId())) {
			merchant72_top = (Merchant72) ContextUtil.getSerializContext().get(Merchant72.class, this.getTopUserId());
		}
		return merchant72_top;
	}
	/**
	 * @param change	单位分
	 */
	public void shareMerchant_balance_Change_fen(Long amount_fen){
		 this.shareMerchant_balance_Change(amount_fen*User.pianyiFen);
	}
	/**
	 * @param change	单位偏移
	 */
	public void shareMerchant_balance_Change(Long amount_pianyi){
		//如果额度是被共享的 检查上级用户的余额
		if(share_balance_yes.equals(this.getShare_balance()) || State.STATE_OK.equals(this.getShare_balance()) ){
			Merchant72 merchant72_top  = this.getTopMerchant72();
			if(merchant72_top != null){
				merchant72_top.shareMerchant_balance_Change(amount_pianyi);
			}
		}
		this.merchant_balance_Change(amount_pianyi);
	}
	/**
	 * @param change	单位分
	 */
	public void merchant_balance_Change(Long change){
		Merchant72 userUpdate = new Merchant72();
		if(this.merchant_balance == null){
			userUpdate.addCommand(MongoCommand.set, "merchant_balance", change);
		}else{
			userUpdate.addCommand(MongoCommand.jiaDengyu, "merchant_balance", change);
		}
		ContextUtil.getSerializContext().commandUpdateObject(Merchant72.class,this.getId(), userUpdate);
	}
	/**
	 * @param changeFen	单位分
	 */
	public void merchant_balance_Change_fen(Integer changeFen){
		Long change = changeFen*pianyiFen;
		this.merchant_balance_Change(change);
	}
	/**
	 * @param changeFen	单位分
	 */
	public void merchant_balance_Change_fen(Long changeFen){
		Long change = changeFen*pianyiFen;
		this.merchant_balance_Change(change);
	}
	/**
	 * 显示用户余额 单位元
	 * @return
	 */
	public Long getMerchant_balance_fen() {
		Long merchant_balance_tmp = this.getMerchant_balance();
		if(merchant_balance_tmp == null){
			this.merchant_balance_Change(0l);
		}
		return this.getMerchant_balance()/User.pianyiFen;
	}
	/**
	 * 显示用户余额 单位元
	 * @return
	 */
	public String getShowMerchant_balance() {
		return Double.toString(MathUtil.divide(this.getMerchant_balance(),User.pianyiYuan).doubleValue());
	}
	public Long getMerchant_balance() {
		return merchant_balance;
	}
	public Long getCurrentMerchant_balance() {
		//如果额度是被共享的 检查上级用户的余额
		if(share_balance_yes.equals(this.getShare_balance()) || State.STATE_OK.equals(this.getShare_balance())  ){
			Merchant72 merchant72_top  = this.getTopMerchant72();
			if(merchant72_top != null){
				return merchant72_top.getCurrentMerchant_balance();
			}
		}
		Merchant72 user_huiyuan_now = (Merchant72) ContextUtil.getSerializContext().get(Merchant72.class, this.getId());
		return user_huiyuan_now.getMerchant_balance();
	}
	public void setMerchant_balance(Long merchant_balance) {
		this.merchant_balance = merchant_balance;
	}
	public Integer getPrint_count() {
		return print_count;
	}
	public void setPrint_count(Integer print_count) {
		this.print_count = print_count;
	}

	public Integer getQueryHour() {
		return queryHour;
	}

	public void setQueryHour(Integer queryHour) {
		this.queryHour = queryHour;
	}
	public void setInMerchant_red_pack_ratio(String red_pack_ratio_max) {
		if(red_pack_ratio_max == null){
			red_pack_ratio_max = "0";
		}
		this.merchant_red_pack_ratio = MathUtil.multiply(red_pack_ratio_max, pianyiFen).intValue();
	} 
	public void setInRed_pack_ratio_max(String red_pack_ratio_max) {
		if(red_pack_ratio_max == null){
			red_pack_ratio_max = "0";
		}
		this.red_pack_ratio_max = MathUtil.multiply(red_pack_ratio_max, pianyiFen).intValue();
	}
	public void setInRed_pack_ratio_min(String red_pack_ratio_min) {
		if(red_pack_ratio_min == null){
			red_pack_ratio_min = "0";
		}
		this.red_pack_ratio_min = MathUtil.multiply(red_pack_ratio_min, pianyiFen).intValue();
	}
	public void setInDiscount_ratio(String discount_ratio) {
		if(discount_ratio == null){
			discount_ratio = "0";
		}
		this.discount_ratio = MathUtil.multiply(discount_ratio, pianyiFen).intValue();
	}

	public Integer getMerchant_red_pack_ratio() {
		return merchant_red_pack_ratio;
	}
	public void setMerchant_red_pack_ratio(Integer merchant_red_pack_ratio) {
		this.merchant_red_pack_ratio = merchant_red_pack_ratio;
	}


	public Long getInOneDayLiuShui() {

		if (oneDayLiuShui != null){
			return oneDayLiuShui/User.pianyiFen;
		}

		return oneDayLiuShui;
	}

	public void setInOneDayLiuShui(Long oneDayLiuShui) {
		if (oneDayLiuShui != null){
			this.oneDayLiuShui = oneDayLiuShui*User.pianyiFen;
		};
	}

	public Long getOneDayLiuShui() {
		return oneDayLiuShui;
	}

	public void setOneDayLiuShui(Long oneDayLiuShui) {
		this.oneDayLiuShui = oneDayLiuShui;
	}

	public Integer getRed_pack_ratio_max() {
		return red_pack_ratio_max;
	}
	public void setRed_pack_ratio_max(Integer red_pack_ratio_max) {
		this.red_pack_ratio_max = red_pack_ratio_max;
	}
	public Integer getRed_pack_ratio_min() {
		return red_pack_ratio_min;
	}
	public void setRed_pack_ratio_min(Integer red_pack_ratio_min) {
		this.red_pack_ratio_min = red_pack_ratio_min;
	}
	public Integer getDiscount_ratio() {
		return discount_ratio;
	}

	public Integer getUseRed_renshu() {
		return useRed_renshu;
	}

	public void setUseRed_renshu(Integer useRed_renshu) {
		this.useRed_renshu = useRed_renshu;
	}

	public void setDiscount_ratio(Integer discount_ratio) {
		this.discount_ratio = discount_ratio;
	}

	public String getSimInfo() {
		return simInfo;
	}

	public void setSimInfo(String simInfo) {
		this.simInfo = simInfo;
	}
	
	public void setInLongitude(Double longitude) {
		if(location == null) {
			location = new BasicDBList();
			location.add(longitude);
		}else if(location.size() == 0){
			location.add(longitude);
		}else if(location.size() >= 1){
			location.set(0, longitude);
		}
		this.longitude = longitude;
	}
	public void setInLatitude(Double latitude) {
		if(location == null || location.size() == 0) {
			location = new BasicDBList();
			location.add(0);
			location.add(latitude);
		}else if(location.size() == 1){
			location.add(latitude);
		}else if(location.size() > 1){
			location.set(1, latitude);
		}
		this.latitude = latitude;
	}
	public Double getLongitude() {
		return longitude;
	}
	public void setLongitude(Double longitude) {
		this.longitude = longitude;
	}
	public Double getLatitude() {
		return latitude;
	}
	public void setLatitude(Double latitude) {
		this.latitude = latitude;
	}

	public String getBusinessHours() {
		return businessHours;
	}

	public void setBusinessHours(String businessHours) {
		this.businessHours = businessHours;
	}

	public String getMerchart72Phone() {
		return merchart72Phone;
	}

	public void setMerchart72Phone(String merchart72Phone) {
		this.merchart72Phone = merchart72Phone;
	}

	public String getSalesmanId() {
		return salesmanId;
	}

	public void setSalesmanId(String salesmanId) {
		this.salesmanId = salesmanId;
	}

	public Salesman getSalesman() {
		if (MyUtil.isValid(this.salesmanId)){
			return (Salesman)ContextUtil.getSerializContext().get(Salesman.class, this.salesmanId);
		}
		return salesman;
	}

	public void setSalesman(Salesman salesman) {
		if(salesman != null && MyUtil.isValid(salesman.getId()) ){
			this.setSalesmanId(salesman.getId());
		}
		this.salesman = salesman;
	}


	public String getUserv2_yewuyuan_id() {
		return userv2_yewuyuan_id;
	}

	public void setUserv2_yewuyuan_id(String userv2_yewuyuan_id) {
		this.userv2_yewuyuan_id = userv2_yewuyuan_id;
	}

	public UserV2 getUserv2_yewuyuan() {

		String userv2Id = this.getUserv2_yewuyuan_id();

		if(MyUtil.isValid(userv2Id)){
			return (UserV2)ContextUtil.getSerializContext().get(UserV2.class, userv2Id);
		}


		return userv2_yewuyuan;
	}

	public void setUserv2_yewuyuan(UserV2 userv2_yewuyuan) {
		String userv2Id = userv2_yewuyuan.getId();

		if(MyUtil.isValid(userv2Id)){
			this.setUserv2_yewuyuan_id(userv2Id);
		}


		this.userv2_yewuyuan = userv2_yewuyuan;
	}

	/**
	 *
	 * @param latitude_now
	 * @param longitude_now
	 * @return
	 */
	public Double getDistance(Double latitude_now,Double longitude_now){

		// 对传进来的经纬度做校正
		latitude_now = latitude_now==null?0d:latitude_now;  // 传进来的纬度
		longitude_now = longitude_now==null?0d:longitude_now;     // 传进来的纬度

		// 对商家的经纬度做校正
		Double merchantLongitude = this.getLongitude()==null?0d:this.getLongitude();  // 商家的经度
		Double merchantLatitude = this.getLatitude()==null?0d:this.getLatitude();     // 商家的纬度

		// 前端 或者 后台 把经纬度弄反了的情况 做一次校正(目前只针对于中国地区)
		double latitude_1 = latitude_now;
		double longitude_1 = longitude_now;

		if(latitude_now > longitude_now){
			latitude_1 = longitude_now;
			longitude_1 = latitude_now;
		}

		double latitude_2 = merchantLatitude;
		double longitude_2 = merchantLongitude;

		if( merchantLatitude > merchantLongitude ){
			latitude_2 = merchantLongitude;
			longitude_2 = merchantLatitude;
		}

		// 获取两点的距离
		Double  distance = DiLiUtil.getDistance(latitude_1,  longitude_1,  latitude_2,  longitude_2);

		return distance;
	}





}