package com.lymava.qier.activities.action;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.model.SerializModel;
import com.lymava.qier.activities.model.JiKaHuoDong;
import com.lymava.qier.activities.model.MeiRiJiKa;

import java.util.Iterator;

@AcceptUrlAction(path="v2/MeiRiJiKa/",name="每日集卡")
public class MeiRiJiKaAction extends LazyBaseAction {
 

	/**
	 * 
	 */
	private static final long serialVersionUID = -5759793696918169211L;

	@Override
    protected Class<? extends SerializModel> getObjectClass() {
        return MeiRiJiKa.class;
    }

    @Override
    protected void listParse(Object object_find) {
		MeiRiJiKa meiRiJiKa = (MeiRiJiKa)object_find;
    	
    	String my_openid = this.getParameter("my_openid");
    	if(!MyUtil.isEmpty(my_openid)) {
			meiRiJiKa.setMy_openid(my_openid);
    	}
    }

	@Override
	protected void saveParse(Object object_find) {
		super.saveParse(object_find);

	}

}