package com.lymava.qier.activities.caididian;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.model.SerializModel;
import com.lymava.qier.activities.guaguaka.GuaguakaJiangPin;

@AcceptUrlAction(path="v2/Didian/",name="老地点")
public class DidianAction extends LazyBaseAction {
 

	/**
	 * 
	 */
	private static final long serialVersionUID = -5759793696918169211L;

	@Override
    protected Class<? extends SerializModel> getObjectClass() {
        return Didian.class;
    }

    @Override
    protected void listParse(Object object_find) {
		Didian didian = (Didian)object_find;

		String didianming = this.getParameter("didianming");
		if(!MyUtil.isEmpty(didianming)) {
			didian.setDidianming(didianming);
		}
		String tishi = this.getParameter("tishi");
		if(!MyUtil.isEmpty(tishi)) {
			didian.setTishi(tishi);
		}
    }

	@Override
	protected void saveParse(Object object_find) {
		super.saveParse(object_find);
	} 

}