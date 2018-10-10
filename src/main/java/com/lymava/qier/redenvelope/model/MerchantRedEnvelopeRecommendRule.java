package com.lymava.qier.redenvelope.model;

import java.text.ParseException;
import java.util.Date;

import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;
import com.lymava.qier.model.MerchantRedEnvelope;
/**
 * 红包发放规则模型
 * @author 黄诗晴
 *
 */
public class MerchantRedEnvelopeRecommendRule extends BaseModel{

	/**
	 * 
	 */
	private static final long serialVersionUID = -860640005496369058L;
	
	
	/**
	 * 消费商户
	 */
	private User user_merchant_xiaofei;
	/**
	 * 消费商户系统编号
	 */
	private String user_merchant_xiaofei_id; 
	/**
	 * 红包商户
	 */
	private User user_merchant_hongbao;
	/**
	 * 红包商户系统编号
	 */
	private String user_merchant_hongbao_id;

	/**
	 * 规则状态
	 */
	private Integer state;
	/**
	 * 生效开始时间
	 */
	private Long start_time_shengxiao;
	private String start_time_shengxiao_str;

	/**
	 * 生效结束时间
	 */
	private Long end_time_shengxiao;
	private String end_time_shengxiao_str;
	/**
	 * 排序
	 */
	private Long sort_id;
	
	
	/**
	 * 此规则被执行的概率
	 * 用0到100之间的整形表示
	 * */
	private Integer rule_weight;
	
	
	
	
	
	public Integer getRule_weight() {
		return rule_weight;
	}
	public void setRule_weight(Integer rule_weight) {
		this.rule_weight = rule_weight;
	}
	static{
		putConfig(MerchantRedEnvelopeRecommendRule.class, "state_"+State.STATE_OK, "已领取");
		putConfig(MerchantRedEnvelopeRecommendRule.class, "state_"+State.STATE_CLOSED, "已过期");
	}
	
	
	public Long getSort_id() {
		return sort_id;
	}
	public void setSort_id(Long sort_id) {
		this.sort_id = sort_id;
	}
	
	public Long getStart_time_shengxiao() {
		return start_time_shengxiao;
	}
	public void setStart_time_shengxiao(Long start_time_shengxiao) {
		this.start_time_shengxiao = start_time_shengxiao;
	}
	
	public Long getEnd_time_shengxiao() {
		return end_time_shengxiao;
	}
	public void setEnd_time_shengxiao(Long end_time_shengxiao) {
		this.end_time_shengxiao = end_time_shengxiao;
	}
	/**
	 * 获取和设置页面显示的时间
	 * */
	public String getSort_id_str() {
		if(this.getSort_id()==null) {
			return "";
		}
		Date date=new Date(this.getSort_id());
		return DateUtil.getSdfFull().format(date);
	}
	public void setSort_id_str(String sort_id_str) {
		Date date=null;
		try {
			date = DateUtil.getSdfFull().parse(sort_id_str);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		this.sort_id = date.getTime();
	}
	/**
	 * 前端接受到的数据与long数据的转换：开始生效时间
	 */
	public String getStart_time_shengxiao_str(){
        if (this.getStart_time_shengxiao() == null){
            return "";
        }
        Date date = new Date(this.getStart_time_shengxiao());
        return DateUtil.getSdfFull().format(date);
    }
	
	public void setStart_time_shengxiao_str(String start_time_shengxiao_str) {
        Date date = null;
        try {
            date = DateUtil.getSdfFull().parse(start_time_shengxiao_str);
            this.start_time_shengxiao = date.getTime();
        } catch (ParseException e) {
        }
	} 
	/**
	 * 前端接受到的数据与long数据的转换：生效结束时间
	 */
	public String getEnd_time_shengxiao_str(){
        if (this.getEnd_time_shengxiao() == null){
            return "";
        }
        Date date = new Date(this.getEnd_time_shengxiao());
        return DateUtil.getSdfFull().format(date);
    }
	public void setEnd_time_shengxiao_str(String end_time_shengxiao_str) {
        Date date = null;
        try {
            date = DateUtil.getSdfFull().parse(end_time_shengxiao_str);
            this.end_time_shengxiao = date.getTime();
        } catch (ParseException e) {
        }
	} 
	
	
	public Integer getState() {
		return state;
	}
	public void setState(Integer state) {
		this.state = state;
	}
	/**
	 * 前端显示的状态
	 */
	public String getState_str(){
		Integer state_tmp= this.getState();
		String state_str="";
		if(state_tmp.equals(State.STATE_OK)) { state_str="生效";}
		else if(state_tmp.equals(State.STATE_CLOSED)) {
			state_str="失效";
		}
		return state_str;
	}
	
	
	public User getUser_merchant_xiaofei() {
		if(MyUtil.isValid(user_merchant_xiaofei_id)) {
			user_merchant_xiaofei= (User) ContextUtil.getSerializContext().findOne(User.class, user_merchant_xiaofei_id);
		}
		return user_merchant_xiaofei;
	}
	public void setUser_merchant_xiaofei(User user_merchant_xiaofei) {
		this.user_merchant_xiaofei = user_merchant_xiaofei;
	}
	public String getUser_merchant_xiaofei_id() {
		
		return user_merchant_xiaofei_id;
	}
	public void setUser_merchant_xiaofei_id(String user_merchant_xiaofei_id) {
		this.user_merchant_xiaofei_id = user_merchant_xiaofei_id;
	}
	public User getUser_merchant_hongbao() {
		if(MyUtil.isValid(user_merchant_hongbao_id)) {
			user_merchant_hongbao= (User) ContextUtil.getSerializContext().findOne(User.class, user_merchant_hongbao_id);
		}
		return user_merchant_hongbao;
	}
	public void setUser_merchant_hongbao(User user_merchant_hongbao) {
		this.user_merchant_hongbao = user_merchant_hongbao;
	}
	public String getUser_merchant_hongbao_id() {
		return user_merchant_hongbao_id;
	}
	public void setUser_merchant_hongbao_id(String user_merchant_hongbao_id) {
		this.user_merchant_hongbao_id = user_merchant_hongbao_id;
	}
	@Override
	public String toString() {
		return "MerchantRedEnvelopeRule [user_merchant_xiaofei=" + user_merchant_xiaofei + ", user_merchant_xiaofei_id="
				+ user_merchant_xiaofei_id + ", user_merchant_hongbao=" + user_merchant_hongbao
				+ ", user_merchant_hongbao_id=" + user_merchant_hongbao_id + ", state=" + state
				+ ", start_time_shengxiao=" + start_time_shengxiao + ", end_time_shengxiao=" + end_time_shengxiao
				+ ", start_time_shengxiao_str=" + start_time_shengxiao_str + ", sort_id=" + sort_id + "]";
	} 
	
	
	
	
	
	
	
	
	
}
