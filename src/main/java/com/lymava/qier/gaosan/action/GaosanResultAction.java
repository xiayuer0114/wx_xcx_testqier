package com.lymava.qier.gaosan.action;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.nosql.model.SerializModel;
import com.lymava.qier.gaosan.model.GaosanResult;

@AcceptUrlAction(path="v2/GaosanResult/",name="重返高三")
public class GaosanResultAction extends LazyBaseAction {

    /**
	 * 
	 */
	private static final long serialVersionUID = -1192989015263667855L;

	@Override
    protected Class<? extends SerializModel> getObjectClass() {
        return GaosanResult.class;
    }

    @Override
    protected void listParse(Object object_find) {

    	GaosanResult gaosanResult = (GaosanResult)object_find;
    }

	@Override
	protected void saveParse(Object object_find) {
		super.saveParse(object_find);
		
		
	} 

}
