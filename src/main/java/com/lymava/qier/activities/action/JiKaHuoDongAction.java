package com.lymava.qier.activities.action;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.model.SerializModel;
import com.lymava.qier.activities.guaguaka.GuaguakaJiangPin;
import com.lymava.qier.activities.model.JiKaHuoDong;
import com.lymava.qier.activities.model.MeiRiJiKa;

import java.util.Iterator;

@AcceptUrlAction(path="v2/JiKaHuoDong/",name="集卡活动")
public class JiKaHuoDongAction extends LazyBaseAction {
 

	/**
	 * 
	 */
	private static final long serialVersionUID = -5759793696918169211L;

	@Override
    protected Class<? extends SerializModel> getObjectClass() {
        return JiKaHuoDong.class;
    }

    @Override
    protected void listParse(Object object_find) {
		JiKaHuoDong jiKaHuoDong = (JiKaHuoDong)object_find;
    	
    	String openid = this.getParameter("openid");
    	if(!MyUtil.isEmpty(openid)) {
			jiKaHuoDong.setOpenid(openid);
    	}
    }

	@Override
	protected void saveParse(Object object_find) {
		super.saveParse(object_find);

	}

//	public String showJika(){
//		String jika_id=this.getParameter("id");
//		if(!MyUtil.isEmpty(jika_id)){
//			JiKaHuoDong jiKaHuoDong_findone=new JiKaHuoDong();
//			jiKaHuoDong_findone.setId(jika_id);
//			JiKaHuoDong jiKaHuoDong_one=(JiKaHuoDong) serializContext.get(jiKaHuoDong_findone);
//			MeiRiJiKa meiRiJiKa_find_byjikaid=new MeiRiJiKa();
//
//			meiRiJiKa_find_byjikaid.setJika_kaishi_day(jiKaHuoDong_one.getLingqu_day());
//
//			Iterator object_ite= this.serializContext.findIterable(meiRiJiKa_find_byjikaid);
//			this.request.setAttribute("object_ite", object_ite);
//		}
//
//
//		return SUCCESS;
//	}
}