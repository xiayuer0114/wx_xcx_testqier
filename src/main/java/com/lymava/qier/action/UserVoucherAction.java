package com.lymava.qier.action;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.nosql.model.SerializModel;
import com.lymava.qier.model.UserVoucher;

@AcceptUrlAction(path="v2/UserVoucher/",name="用户代金卷")
public class UserVoucherAction extends LazyBaseAction{
	/**
	 * 
	 */
	private static final long serialVersionUID = -8351595748654824117L;

	@Override
	protected Class<? extends SerializModel> getObjectClass() {
		return UserVoucher.class;
	}
	
	@Override
	protected void listParse(Object object_find) {
		
		UserVoucher userVoucher = (UserVoucher) object_find;
	}
	   
	@Override
	protected void saveParse(Object object_find) {
		super.saveParse(object_find);
		
		UserVoucher userVoucher = (UserVoucher) object_find;
		
	}

}
