package com.lymava.qier.activities.caididian;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.model.SerializModel;

@AcceptUrlAction(path="v2/CaiDidianDaan/",name="猜地点答案")
public class CaiDidianDaanAction extends LazyBaseAction {
 

	/**
	 * 
	 */
	private static final long serialVersionUID = -5759793696918169211L;

	@Override
    protected Class<? extends SerializModel> getObjectClass() {
        return CaiDidianDaan.class;
    }

    @Override
    protected void listParse(Object object_find) {
		CaiDidianDaan caiDidianDaan = (CaiDidianDaan)object_find;

//    	String didianming = this.getParameter("didianming");
//    	if(!MyUtil.isEmpty(didianming)) {
//			caiDidianDaan.setDi
//    	}
//		String didianming = this.getParameter("didianming");
    }

	@Override
	protected void saveParse(Object object_find) {
		super.saveParse(object_find);
	} 

}