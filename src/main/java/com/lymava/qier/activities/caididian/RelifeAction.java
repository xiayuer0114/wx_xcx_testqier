package com.lymava.qier.activities.caididian;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.nosql.model.SerializModel;

@AcceptUrlAction(path="v2/Relife/",name="猜地点复活记录")
public class RelifeAction extends LazyBaseAction {
 

	/**
	 * 
	 */
	private static final long serialVersionUID = -5759793696918169211L;

	@Override
    protected Class<? extends SerializModel> getObjectClass() {
        return Relife.class;
    }

    @Override
    protected void listParse(Object object_find) {
		Relife relife = (Relife)object_find;
    }

	@Override
	protected void saveParse(Object object_find) {
		super.saveParse(object_find);
	} 

}