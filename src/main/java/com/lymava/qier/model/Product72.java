package com.lymava.qier.model;

import java.util.Date;
import java.util.Map;

import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.HttpUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.trade.business.model.Product;
import com.lymava.trade.business.model.TradeRecord;

/**
 * 收银牌/桌号
 * @author lymava
 *
 */
public class Product72 extends Product{

	/**
	 * 
	 */
	private static final long serialVersionUID = -2271425836230437543L;


	/**
	 * 预置的扫码牌金额   偏移100
	 */
	private Long preset_amount_fen;
	
	public static Long preset_amount_pianyi = 100L;


	/**
	 * 预置餐位费
	 */
	private Long canWeiFei_fen;


	/**
	 * 是否开启预设置
	 */
	private Integer yushe_state;
	
	public static Integer yushe_state_kaiqi = State.STATE_OK;    // 开启
	
	public static Integer yushe_state_guanbi = State.STATE_FALSE; //  关闭
	
	/**
	 * 是否收取餐位费
	 */
	private Integer canweifei_state;

	/**
	 * 用餐人数
	 */
	private Integer renshu; 
	/**
	 * 修改收银牌预置金额的时间
	 */
	private Long update_amount_time; 
	
	static{
		putConfig(Product72.class, "canweifei_state_"+State.STATE_OK, "收取餐位费");
		putConfig(Product72.class, "canweifei_state_"+State.STATE_FALSE, "不收取餐位费");
		
		putConfig(Product72.class, "yushe_state_"+State.STATE_OK, "开启预设");
		putConfig(Product72.class, "yushe_state_"+State.STATE_FALSE, "不开启预设");
	}
	
	public String getShowCanweifei_state(){
		 return (String) getConfig("canweifei_state_"+this.getCanweifei_state());
	}
	public String getShowYushe_state() {
		return (String) getConfig("yushe_state_"+this.getYushe_state());
	}
	/**
	 * 最长清理的时间	8个小时
	 */
	public static Long max_clear_time = DateUtil.one_hour*8;

	/**
	 * 这个是 预设的金额+ 单个餐位费*用餐人数
	 * @return
	 */
	public Long getPreset_amount_fen_all() {
		
		if(!State.STATE_OK.equals(this.getYushe_state())) {
			return 0l;
		}
		
		if(update_amount_time != null && System.currentTimeMillis()-update_amount_time > max_clear_time) {
			this.clear_preset();
			return 0l;
		}
		
		
		Integer renshu_tmp = this.getRenshu();
		if(renshu_tmp == null) {renshu_tmp = 0;}
		
		Long canWeiFei_fen_tmp = this.getCanWeiFei_fen();
		if(State.STATE_OK.equals(canweifei_state)) {
			if(canWeiFei_fen_tmp == null) {canWeiFei_fen_tmp = 0l;}
		}else {
			canWeiFei_fen_tmp = 0L;
		}
		
		Long preset_amount_fen_tmp = this.getPreset_amount_fen();
		if(preset_amount_fen_tmp == null) {preset_amount_fen_tmp = 0l;}
		
		return preset_amount_fen_tmp + canWeiFei_fen_tmp*renshu_tmp;
	}

	public Integer getCanweifei_state() {
		return canweifei_state;
	}

	public void setCanweifei_state(Integer canweifei_state) {
		this.canweifei_state = canweifei_state;
	}
	@Override
	public TradeRecord createNewTradeRecord() {
		return new TradeRecord72();
	}

	@Override
	public Class<? extends TradeRecord> getTradeRecordClass() {
		return TradeRecord72.class;
	}

	@Override
	public void check_can_buy(TradeRecord tradeRecord_tmp) throws CheckException {
		

	}
	private Merchant72 merchant72;
	
	public User getUser_merchant() {
		
		String userId_merchant_tmp = this.getUserId_merchant();
		
		if (merchant72 == null && MyUtil.isValid(userId_merchant_tmp)) {
			merchant72 = (Merchant72) ContextUtil.getSerializContext().get(Merchant72.class, userId_merchant_tmp);
		}
		return merchant72;
	}

	//设置搜索条件
	@Override
	public void parseBeforeSearch(Map parameterMap) {
		//获取requestParameter：商户ID
		String merchantId  = HttpUtil.getParemater(parameterMap, "merchantId");

		//判断objectId是否有效
		if(MyUtil.isValid(merchantId)) {
			this.setUserId_merchant(merchantId);
		}
	}

	public String getShow_update_amount_time(){

		if(this.getUpdate_amount_time() != null){
			String showTime = DateUtil.getSdfMMddhhmm().format(new Date(this.getUpdate_amount_time()));
			return showTime;
		} 



		return "";
	}

	/**
	 * 清除预设金额
	 */
	public void clear_preset(){
		
		Product72 product72_update = new Product72();

		product72_update.setPreset_amount_fen(0L);
		product72_update.setRenshu(0);
		product72_update.setUpdate_amount_time(System.currentTimeMillis());

		ContextUtil.getSerializContext().updateObject(this.id, product72_update);
	}

	public void setInCanWeiFei_fen(Double canWeiFei_fen) {
		if(canWeiFei_fen != null){
			this.canWeiFei_fen  = MathUtil.multiply(canWeiFei_fen, preset_amount_pianyi).longValue();
		}
	}

	public void setInPreset_amount_fen(Double preset_amount_fen) {
		if(preset_amount_fen != null){
			this.preset_amount_fen  = MathUtil.multiply(preset_amount_fen, preset_amount_pianyi).longValue();
		}
	}

	//   get/set

	public Integer getYushe_state() {
		return yushe_state;
	}

	public void setYushe_state(Integer yushe_state) {
		this.yushe_state = yushe_state;
	}

	public Double getXiaoJi() {
		Long preset_amount_fen_all = this.getPreset_amount_fen_all();
		return MathUtil.divide(preset_amount_fen_all, 100).doubleValue();
	}

	public Long getCanWeiFei_fen() {
		return canWeiFei_fen;
	}
	public Double getShowCanWeiFei_all_yuan() {
		
		if(!State.STATE_OK.equals(canweifei_state)) {
			return 0d;
		}
		
		if(canWeiFei_fen == null || renshu == null ) {
			return 0d;
		}
		
		return MathUtil.divide(canWeiFei_fen*renshu, 100).doubleValue();
	}

	public void setCanWeiFei_fen(Long canWeiFei_fen) {
		this.canWeiFei_fen = canWeiFei_fen;
	}

	public Integer getRenshu() {
		return renshu;
	}

	public void setRenshu(Integer renshu) {
		this.renshu = renshu;
	}

	public Long getUpdate_amount_time() {
		return update_amount_time;
	}

	public void setUpdate_amount_time(Long update_amount_time) {
		this.update_amount_time = update_amount_time;
	}

	public Long getPreset_amount_fen() {
		return preset_amount_fen;
	}

	public void setPreset_amount_fen(Long preset_amount_fen) {
		this.preset_amount_fen = preset_amount_fen;
	}
}
