package com.lymava.qier.gaosan.model;

import com.lymava.base.model.Pub;
import com.lymava.base.model.PubConlumn;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;

public class GaosanResult extends BaseModel {

	/**
	 * 
	 */
	private static final long serialVersionUID = -367846383327469572L;
	/**
	 * 用户的openid
	 */
	private String openid;
	/**
	 * 用户的名称
	 */
	private String name;

	/**
	 * 内容类别
	 */
	private PubConlumn pubConlumn;
	/**
	 * 类别 系统编号
	 */
	private String pubConlumnId;
	
	/**
	 * 抽中的学校
	 */
	private Pub pub_link;
	/**
	 * 抽中的学校 系统编号
	 */
	private String pub_link_id;
	/**
	 * 状态
	 */
	private Integer state;
	/**
	 * 图片的资源编号
	 */
	private String media_id;
	/**
	 * 状态
	 */
	private Integer scan_state;
	
	static{
			putConfig(GaosanResult.class, "state_"+State.STATE_WAITE_PROCESS, "等待出图");
			putConfig(GaosanResult.class, "state_"+State.STATE_PAY_SUCCESS, "出图成功");
	}
	
	public void send_result() {
		
	}
	
	public Integer getScan_state() {
		return scan_state;
	}
	public void setScan_state(Integer scan_state) {
		this.scan_state = scan_state;
	}
	public String getMedia_id() {
		return media_id;
	}
	public void setMedia_id(String media_id) {
		this.media_id = media_id;
	}
	public String getNickName() {
		return null;
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

	public Pub getPub_link() {
		if(pub_link == null && MyUtil.isValid(pub_link_id)){
			pub_link = Pub.getFinalPub(pub_link_id);
		}
		return pub_link;
	}
	public void setPub_link(Pub pub_link) {
		if(pub_link != null){
			pub_link_id = pub_link.getId();
		}
		this.pub_link = pub_link;
	}
	public String getPub_link_id() {
		return pub_link_id;
	}
	public void setPub_link_id(String pub_link_id) {
		this.pub_link_id = pub_link_id;
	}

	public PubConlumn getPubConlumn() {
		if (pubConlumn == null && pubConlumnId != null) {
			pubConlumn = (PubConlumn) ContextUtil.getSerializContext().get(PubConlumn.class, pubConlumnId);
		}
		return pubConlumn;
	}

	public void setPubConlumn(PubConlumn pubConlumn) {
		if (pubConlumn != null) {
			this.setPubConlumnId(pubConlumn.getId());
		}
		this.pubConlumn = pubConlumn;
	}

	public String getOpenid() {
		return openid;
	}

	public void setOpenid(String openid) {
		this.openid = openid;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPubConlumnId() {
		return pubConlumnId;
	}

	public void setPubConlumnId(String pubConlumnId) {
		this.pubConlumnId = pubConlumnId;
	}

}
