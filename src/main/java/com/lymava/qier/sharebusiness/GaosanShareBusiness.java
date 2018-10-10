package com.lymava.qier.sharebusiness;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Random;

import org.bson.types.ObjectId;

import com.google.gson.JsonObject;
import com.lymava.base.model.Pub;
import com.lymava.base.model.PubConlumn;
import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.JsonUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.commons.util.ThreadPoolContext;
import com.lymava.nosql.context.SerializContext;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.qier.gaosan.GaosanImageUtil;
import com.lymava.qier.gaosan.model.GaosanResult;
import com.lymava.qier.model.TradeRecord72;
import com.lymava.wechat.gongzhonghao.Gongzonghao;
import com.lymava.wechat.gongzhonghao.GongzonghaoContent;
import com.lymava.wechat.gongzhonghao.sharebusiness.GongzonghaoShareBusiness;
import com.lymava.wechat.opendevelop.WeixinCallBackMessageFilter;

public class GaosanShareBusiness extends GongzonghaoShareBusiness{

	@Override
	public String getBusinessName() {
		return "重返高三";
	}

	@Override
	public String getBusinessId() {
		return "gaosan";
	}

	@Override
	public String getDataId() {
		return null;
	}

	@Override
	public void subscribe_call_back(Gongzonghao gongzonghao, String data_id, String openid) {
		this.check_gaosan(openid);
	}
	/**
	 * 重返高三活动
	 */
	public void check_gaosan(String openid) {
		
		if(MyUtil.isEmpty(openid)){
			return;
		}
			  
		SerializContext serializContext_tmp = ContextUtil.getSerializContext();
		
		GaosanResult gaosanResult_find = new GaosanResult();
		gaosanResult_find.setOpenid(openid);
		gaosanResult_find.setState(com.lymava.commons.state.State.STATE_WAITE_PROCESS);
		
		GaosanResult gaosanResult = (GaosanResult)serializContext_tmp.get(gaosanResult_find);

		if(gaosanResult == null){
			return;
		} 
		
		final String realPath = WeixinCallBackMessageFilter.threadLocal_realPath.get();
		
		ThreadPoolContext.getExecutorService().execute(new Runnable() {
			@Override
			public void run() {
				
				long currentTimeMillis = System.currentTimeMillis();
				
				String chutu_path = GaosanImageUtil.chutu_path(gaosanResult, realPath);
				
//				System.out.println("chutu_path"+ (System.currentTimeMillis()-currentTimeMillis ));
				
				Gongzonghao gongzonghao = GongzonghaoContent.getInstance().getDefaultGongzonghao();
				
				String upload_media = gongzonghao.upload_media(realPath+chutu_path, "image");
				
//				System.out.println("upload_media"+ (System.currentTimeMillis()-currentTimeMillis) );
				
				try {
					String send_image_message = gongzonghao.send_image_message(gaosanResult.getOpenid(),upload_media);
					//{"errcode":42001,"errmsg":"access_token expired hint: [I9JQua0689a456!]"}
					//{"errcode":0,"errmsg":"ok"}

					JsonObject parseJsonObject = JsonUtil.parseJsonObject(send_image_message);
					String errcode = JsonUtil.getString(parseJsonObject, "errcode");

					if(!"0".equals(errcode)) {
						logger.error("发送失败!:"+send_image_message);
					}else {
						
						GaosanResult gaosanResult_update = new GaosanResult();
						gaosanResult_update.setState(State.STATE_PAY_SUCCESS);
						
						serializContext_tmp.updateObject(gaosanResult.getId(), gaosanResult_update);
					}
					
				} catch (IOException e) {
					logger.error("发送消息失败!", e);
				}
			}
		});
		
	}
}
