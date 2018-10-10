package com.lymava.qier.activities.model;

import com.lymava.nosql.mongodb.vo.BaseModel;
import com.mongodb.BasicDBList;

public class WorldCupForecast extends BaseModel{

	/**
	 * 
	 */
	private static final long serialVersionUID = 4314506447186540465L;

	/**
	 * 用户的openid
	 */
	private String openid; 
	/**
	 * 32进16
	 */
	public static final Integer type_32_to_16 = 32;
	/**
	 * 16 到决赛
	 */
	public static final Integer type_16 = 16;
	/**
	 * 预测类型
	 */
	private Integer type;
	/**
	 * 状态
	 */
	private Integer state;
	/**
	 * 预测结果
	 */
	private BasicDBList basicDBList;
	
	public Integer getType() {
		return type;
	}
	public void setType(Integer type) {
		this.type = type;
	}
	public BasicDBList getBasicDBList() {
		return basicDBList;
	}
	public void setBasicDBList(BasicDBList basicDBList) {
		this.basicDBList = basicDBList;
	}
	public String getOpenid() {
		return openid;
	}
	public void setOpenid(String openid) {
		this.openid = openid;
	}
	public Integer getState() {
		return state;
	}
	public void setState(Integer state) {
		this.state = state;
	}
	
	
	
}
