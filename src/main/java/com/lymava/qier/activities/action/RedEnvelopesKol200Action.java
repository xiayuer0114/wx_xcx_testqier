package com.lymava.qier.activities.action;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.nosql.model.SerializModel;
import com.lymava.qier.activities.model.RedEnvelopesKol200;

@AcceptUrlAction(path="v2/RedEnvelopesKol200/",name="kol200")
public class RedEnvelopesKol200Action extends LazyBaseAction {
    /**
	 * 
	 */
	private static final long serialVersionUID = -1192989015263667855L;
	@Override
    protected Class<? extends SerializModel> getObjectClass() {
        return RedEnvelopesKol200.class;
    }

    @Override
    protected void listParse(Object object_find) {
    	RedEnvelopesKol200 redEnvelopesKol200 = (RedEnvelopesKol200)object_find;
    }

	@Override
	protected void saveParse(Object object_find) {
		super.saveParse(object_find);
		
		
	} 

}