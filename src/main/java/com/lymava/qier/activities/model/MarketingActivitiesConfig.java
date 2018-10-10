package com.lymava.qier.activities.model;

import com.lymava.nosql.mongodb.vo.BaseModel;

public class MarketingActivitiesConfig extends BaseModel{

	/**
	 * 
	 */
	private static final long serialVersionUID = 2219183327671844563L;
	/**
	 * 配置名称
	 */
	private String name;
	/**
	 * 配置key
	 */
	private String key;
	/**
	 * 配置值
	 */
	private String value;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}
	
	
}
