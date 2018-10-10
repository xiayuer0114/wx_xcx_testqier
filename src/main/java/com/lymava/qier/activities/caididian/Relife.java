package com.lymava.qier.activities.caididian;

import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.nosql.context.SerializContext;
import com.lymava.nosql.mongodb.vo.BaseModel;

/**
 * 复活记录
 * @author lymava
 *
 */
public class Relife extends BaseModel{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8103456049345828374L; 
	/**
	 * 朋友的openid
	 */
	 private String friend_openid;
	 /**
	  * 被复活用户的openid
	  */
	 private String openid;
	/**
	 * 复活的时间戳
	 * 比如 2018-07-20 的时间戳
	 */
	private Long relife_day;



	public String getShowRelife_day()
	{
		if (relife_day != null)
			return DateUtil.getSdfFull().format(relife_day);
		return null;
	}

	//set get
	public String getFriend_openid()
	{
		return friend_openid;
	}

	public void setFriend_openid(String friend_openid)
	{
		this.friend_openid = friend_openid;
	}

	public String getOpenid()
	{
		return openid;
	}

	public void setOpenid(String openid)
	{
		this.openid = openid;
	}

	public Long getRelife_day()
	{
		return relife_day;
	}

	public void setRelife_day(Long relife_day)
	{
		this.relife_day = relife_day;
	}
}
