package com.lymava.qier.activities.caididian;

import com.lymava.base.util.ContextUtil;
import com.lymava.base.util.WebConfigContent;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.nosql.context.SerializContext;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.nosql.mongodb.vo.BaseModel;
import org.bson.types.ObjectId;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.Iterator;

/**
 * 地点
 * @author lymava
 *
 */
public class Didian extends BaseModel{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8103456049345828374L; 
	/**
	 * 地点名称
	 */
	 private String didianming;
	 /**
	  * 提示语
	  */
	 private String tishi;
	 /**
	  * 图片
	  */
	 private String pic;
	/**
	 * 猜对之后的图片
	 */
	private String picResult;

	/**
	 * 获取指定用户对该地点的状态：
	 * @param openid 	指定微信用户
	 * @param isShared 	是否是分享
	 * @return 用户的状态
	 */
	public Integer getUserDidianStatus(String openid, boolean isShared) {
		if (isShared)
			return State.STATE_DONOT_HAS_FUNCTION;

		SerializContext serializContext = ContextUtil.getSerializContext();

		//查询该用户所有记录
		CaiDidianDaan caiDidianDaan_find = new CaiDidianDaan();
		caiDidianDaan_find.setDidian_id(getId());
		caiDidianDaan_find.setOpenid(openid);

		CaiDidianDaan caiDidianDaan_tmp = (CaiDidianDaan)serializContext.get(caiDidianDaan_find);

		if (caiDidianDaan_tmp == null) {
			return State.STATE_ORDER_NOT_EXIST;
		} else {

			return caiDidianDaan_tmp.getState();
		}
	}

	 //set get
	public String getDidianming() {
		return didianming;
	}

	public void setDidianming(String didianming) {
		this.didianming = didianming;
	}

	public String getTishi() {
		return tishi;
	}

	public void setTishi(String tishi) {
		this.tishi = tishi;
	}

	public String getPic() {
		return pic;
	}

	public void setPic(String pic) {
		this.pic = pic;
	}

	public String getPicResult()
	{
		return picResult;
	}

	public void setPicResult(String picResult)
	{
		this.picResult = picResult;
	}
}
