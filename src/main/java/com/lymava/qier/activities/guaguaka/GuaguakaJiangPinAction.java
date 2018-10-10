package com.lymava.qier.activities.guaguaka;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.model.SerializModel;

@AcceptUrlAction(path="v2/GuaguakaJiangPin/",name="JAY迷刮刮卡")
public class GuaguakaJiangPinAction extends LazyBaseAction {
 

	/**
	 * 
	 */
	private static final long serialVersionUID = -5759793696918169211L;

	@Override
    protected Class<? extends SerializModel> getObjectClass() {
        return GuaguakaJiangPin.class;
    }

    @Override
    protected void listParse(Object object_find) {
    	GuaguakaJiangPin guaguakaJiangPin = (GuaguakaJiangPin)object_find;
    	
    	String openid = this.getParameter("openid");
    	if(!MyUtil.isEmpty(openid)) {
    		guaguakaJiangPin.setOpenid(openid);
    	}
    }

	@Override
	protected void saveParse(Object object_find) {
		super.saveParse(object_find);

	} 

}