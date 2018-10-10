package com.lymava.qier.activities.model;

import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;
import com.lymava.qier.model.User72;
import com.lymava.wechat.gongzhonghao.SubscribeUser;

/**
 * 618红包活动
 */
public class XingGeTest extends BaseModel {

	private static final long serialVersionUID = 1L;

	/**
	 * 用户的openid
	 */
	private String openid;
	/**
	 * 性格测试用户名称
	 */
	private String test_name ;
	/**
	 * 所选答案
	 */
	private String da_an;
	/**
	 *结果图片
	 */
	private String result_img;
	/**
	 * 关注用户
	 */
	private SubscribeUser subscribeUser;
	/**
	 * 状态
	 */
	private Integer state;
	
	 static{
			putConfig(XingGeTest.class, "state_"+State.STATE_WAITE_PROCESS, "异常");
			putConfig(XingGeTest.class, "state_"+State.STATE_OK, "正常");

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

	public SubscribeUser getSubscribeUser() {
		if (subscribeUser == null && !MyUtil.isEmpty(openid)) {

			SubscribeUser subscribeUser_find = new SubscribeUser();
			subscribeUser_find.setOpenid(openid);

			subscribeUser = (SubscribeUser) ContextUtil.getSerializContext().get(subscribeUser_find);
		}
		return subscribeUser;
	}

	public String getOpenid() {
		return openid;
	}

	public void setOpenid(String openid) {
		this.openid = openid;
	}


	public static long getSerialVersionUID()
	{
		return serialVersionUID;
	}

	public String getTest_name()
	{
		return test_name;
	}

	public void setTest_name(String test_name)
	{
		this.test_name = test_name;
	}

	public String getDa_an()
	{
		return da_an;
	}

	public void setDa_an(String da_an)
	{
		this.da_an = da_an;
	}

	public String getResult_img()
	{
		return result_img;
	}

	public void setResult_img(String result_img)
	{
		this.result_img = result_img;
	}

	public void setSubscribeUser(SubscribeUser subscribeUser)
	{
		this.subscribeUser = subscribeUser;
	}
}
