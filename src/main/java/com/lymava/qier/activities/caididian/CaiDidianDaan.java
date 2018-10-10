package com.lymava.qier.activities.caididian;

import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.base.util.WebConfigContent;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.HttpUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.context.SerializContext;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.nosql.mongodb.vo.BaseModel;
import com.lymava.qier.activities.guaguaka.GuaguakaJiangPin;
import com.lymava.qier.model.User72;

import java.text.ParseException;
import java.util.Map;

/**
 * 猜地点答案
 * @author lymava
 *
 */
public class CaiDidianDaan extends BaseModel{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8103456049345828374L; 

	/**
	 * 用户的openid
	 */
	private String openid;  
	/**
	 * 奖品类型	未中奖
	 */
	public static final Integer type_jiangpin_weizhongjiang = 1;
	/**
	 * 奖品类型	6.66 红包
	 */
	public static final Integer type_jiangpin_666 = 2;
	/**
	 * 奖品类型	1.66 红包
	 */	
	public static final Integer type_jiangpin_166 = 3;
	/**
	 * 奖品类型
	 */
	private Integer type_jiangpin;
	/**
	 * 中奖状态
	 */
	private Integer state;
	
	static{
		putConfig(CaiDidianDaan.class, "state_"+State.STATE_OK, "已发放");//已领奖
		putConfig(CaiDidianDaan.class, "state_"+State.STATE_FALSE, "未中奖");//死亡
		putConfig(CaiDidianDaan.class, "state_"+State.STATE_WAITE_PROCESS, "未开宝箱");//复活
		//putConfig(CaiDidianDaan.class, "state_"+State.STATE_ORDER_NOT_EXIST, "还没猜");//（这个值不会记录，仅用于标记）
		//putConfig(CaiDidianDaan.class, "state_"+State.STATE_DONOT_HAS_FUNCTION, "分享");//（这个值不会记录，仅用于标记）
		//putConfig(CaiDidianDaan.class, "state_"+State.STATE_REFUND_FALSE, "今天已经猜了，要等到明天再猜");//（这个值不会记录，仅用于标记）2081
		
		putConfig(CaiDidianDaan.class, "type_jiangpin_"+type_jiangpin_weizhongjiang , "未中奖");
		putConfig(CaiDidianDaan.class, "type_jiangpin_"+type_jiangpin_666 , "通用6.66");
		putConfig(CaiDidianDaan.class, "type_jiangpin_"+type_jiangpin_166 , "通用1.66");
	}
	/**
	 * 会员
	 */
	private User user_huiyuan;
	/**
	 * 会员系统编号
	 */
	private String userId_huiyuan;
	/**
	 * 地点
	 */
	private Didian didian;
	/**
	 * 地点	系统编号
	 */
	private String didian_id;
	/**
	 * 生成的几率数
	 * 0-100 的数  
	 * 	大于等于50 中奖
	 * 	小于等于49	不中奖
	 */
	private Integer rand_number;
	/**
	 * 抽中的红包金额
	 * 	通用红包的时候有用
	 */
	private Integer price_fen;
	/**
	 * 领取的 某一天的时间戳
	 * 比如 2018-07-20 的时间戳
	 */
	private Long lingqu_day;
	/**
	 * 复活次数
	 */
	private Integer relife_count;
	/**
	 * 复活的时间戳
	 * 比如 2018-07-20 的时间戳
	 */
	private Long relife_day;

	
	public User getUser_huiyuan() {
		if (user_huiyuan == null && MyUtil.isValid(this.userId_huiyuan)) {
			user_huiyuan = (User) ContextUtil.getSerializContext().get(User.class, userId_huiyuan);
		}
		if(user_huiyuan == null && !MyUtil.isEmpty(openid)) {
			WebConfigContent instance = WebConfigContent.getInstance();
			String defaultUserGroupId = instance.getDefaultUserGroupId();
			
			User72 user72_find = new User72();
			
			user72_find.setUserGroupId(defaultUserGroupId);
			user72_find.setThird_user_id(openid);
			
			user_huiyuan = (User72) ContextUtil.getSerializContext().get(user72_find);
		}
		return user_huiyuan;
	}

	public void setUser_huiyuan(User user_huiyuan) {
		if (user_huiyuan != null) {
			userId_huiyuan = user_huiyuan.getId();
		}
		this.user_huiyuan = user_huiyuan;
	}


	//get set
	public Integer getRelife_count()
	{
		return relife_count;
	}

	public void setRelife_count(Integer relife_count)
	{
		this.relife_count = relife_count;
	}

	public Long getRelife_day()
	{
		return relife_day;
	}

	public void setRelife_day(Long relife_day)
	{
		this.relife_day = relife_day;
	}

	public String getShowRelife_day()
	{
		if (relife_day != null)
			return DateUtil.getSdfFull().format(relife_day);
		return null;
	}

	public String getShowLingqu_day()
	{
		if (lingqu_day != null)
			return DateUtil.getSdfFull().format(lingqu_day);
		return null;
	}

	public String getOpenid()
	{
		return openid;
	}

	public void setOpenid(String openid)
	{
		this.openid = openid;
	}

	public Integer getType_jiangpin()
	{
		return type_jiangpin;
	}

	public void setType_jiangpin(Integer type_jiangpin)
	{
		this.type_jiangpin = type_jiangpin;
	}

	public Integer getState()
	{
		return state;
	}

	public void setState(Integer state)
	{
		this.state = state;
	}

	public String getUserId_huiyuan()
	{
		return userId_huiyuan;
	}

	public void setUserId_huiyuan(String userId_huiyuan)
	{
		this.userId_huiyuan = userId_huiyuan;
	}

	public Didian getDidian()
	{
		if (didian == null && didian_id != null) {
			didian = (Didian) ContextUtil.getSerializContext().get(Didian.class, didian_id);
		}
		return didian;
	}

	public void setDidian(Didian didian)
	{
		this.didian = didian;
	}

	public String getDidian_id()
	{
		return didian_id;
	}

	public void setDidian_id(String didian_id)
	{
		this.didian_id = didian_id;
	}

	public Integer getRand_number()
	{
		return rand_number;
	}

	public void setRand_number(Integer rand_number)
	{
		this.rand_number = rand_number;
	}

	public Integer getPrice_fen()
	{
		return price_fen;
	}

	public void setPrice_fen(Integer price_fen)
	{
		this.price_fen = price_fen;
	}

	public Long getLingqu_day()
	{
		return lingqu_day;
	}

	public void setLingqu_day(Long lingqu_day)
	{
		this.lingqu_day = lingqu_day;
	}


	@Override
	public void parseBeforeSearch(Map parameterMap)
	{
		String openid = HttpUtil.getParemater(parameterMap, "openid");
		if (!MyUtil.isEmpty(openid)) {
			setOpenid(openid);
		}

		String startTime = HttpUtil.getParemater(parameterMap, "startTime");
		if (!MyUtil.isEmpty(startTime)) {
			try {
				long time = DateUtil.getSdfFull().parse(startTime).getTime();
				addCommand(MongoCommand.dayuAndDengyu, "lingqu_day", time);

			} catch (ParseException e) {
			}
		}
		String endTime = HttpUtil.getParemater(parameterMap, "endTime");
		if (!MyUtil.isEmpty(endTime)) {
			try {
				long time = DateUtil.getSdfFull().parse(endTime).getTime();
				addCommand(MongoCommand.xiaoyu, "lingqu_day", time);

			} catch (ParseException e) {
			}
		}

		String type_jiangpin = HttpUtil.getParemater(parameterMap, "type_jiangpin");
		if (!MyUtil.isEmpty(type_jiangpin)) {
			setType_jiangpin(Integer.valueOf(type_jiangpin));
		}

		String state = HttpUtil.getParemater(parameterMap, "state");
		if (!MyUtil.isEmpty(state)) {
			setState(Integer.valueOf(state));
		}

		super.parseBeforeSearch(parameterMap);
	}
}
