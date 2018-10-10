package com.lymava.qier.activities.action;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.model.SerializModel;
import com.lymava.qier.activities.model.Daka;


@AcceptUrlAction(path="v2/Daka/",name="七日打卡")
public class DakaAction extends LazyBaseAction
{
	/**
	 *
	 */
	private static final long serialVersionUID = 5722685628873558905L;

	@Override
    protected Class<? extends SerializModel> getObjectClass() {
        return Daka.class;
    }

    @Override
    protected void listParse(Object object_find) {
    	Daka daka = (Daka) object_find;

    	String openid = this.getParameter("openid");

    	if(!MyUtil.isEmpty(openid)){
			daka.setOpenId(openid);
		}
    }

	@Override
	protected void saveParse(Object object_find) {
		super.saveParse(object_find);


	}



}