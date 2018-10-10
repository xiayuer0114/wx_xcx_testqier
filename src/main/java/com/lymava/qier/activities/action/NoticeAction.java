package com.lymava.qier.activities.action;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.nosql.model.SerializModel;
import com.lymava.qier.activities.model.Notice;
@AcceptUrlAction(path="v2/Notice/",name="录取通知书活动")
public class NoticeAction extends LazyBaseAction {

	private static final long serialVersionUID = -1192989015263667855L;
	@Override
    protected Class<? extends SerializModel> getObjectClass() {
        return Notice.class;
    }
    @Override
    protected void listParse(Object object_find) {
    	Notice notice = (Notice)object_find;
    }
	@Override
	protected void saveParse(Object object_find) {
		super.saveParse(object_find);
	} 
}
