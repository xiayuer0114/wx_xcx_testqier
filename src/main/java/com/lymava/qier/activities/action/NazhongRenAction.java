package com.lymava.qier.activities.action;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.nosql.model.SerializModel;
import com.lymava.qier.activities.model.NazhongRen;

@AcceptUrlAction(path="v2/NazhongRen/",name="哪粽人")
public class NazhongRenAction extends LazyBaseAction { 
	/**
	 * 
	 */
	private static final long serialVersionUID = 3891398289410260012L;

	@Override
    protected Class<? extends SerializModel> getObjectClass() {
        return NazhongRen.class;
    }

    @Override
    protected void listParse(Object object_find) {
    	NazhongRen nazhongRen = (NazhongRen)object_find;
    }

	@Override
	protected void saveParse(Object object_find) {
		super.saveParse(object_find);
		
		
	} 

}