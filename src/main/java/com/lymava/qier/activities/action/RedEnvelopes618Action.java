package com.lymava.qier.activities.action;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.nosql.model.SerializModel;
import com.lymava.qier.activities.model.RedEnvelopes618;
import com.lymava.qier.activities.model.WorldCupForecast;

@AcceptUrlAction(path="v2/RedEnvelopes618/",name="618红包活动")
public class RedEnvelopes618Action extends LazyBaseAction {
    /**
	 * 
	 */
	private static final long serialVersionUID = -1192989015263667855L;
	@Override
    protected Class<? extends SerializModel> getObjectClass() {
        return RedEnvelopes618.class;
    }

    @Override
    protected void listParse(Object object_find) {
    	RedEnvelopes618 redEnvelopes618 = (RedEnvelopes618)object_find;
    }

	@Override
	protected void saveParse(Object object_find) {
		super.saveParse(object_find);
		
		
	} 

}