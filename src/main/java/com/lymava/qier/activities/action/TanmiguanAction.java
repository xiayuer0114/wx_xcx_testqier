package com.lymava.qier.activities.action;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.model.SerializModel;
import com.lymava.qier.activities.model.Tanmiguan;


@AcceptUrlAction(path="v2/Tanmiguan/",name="探秘官")
public class TanmiguanAction extends LazyBaseAction
{

	/**
	 *
	 */
	private static final long serialVersionUID = 5722685628873558905L;

	@Override
    protected Class<? extends SerializModel> getObjectClass() {
        return Tanmiguan.class;
    }

    //查询条件
    @Override
    protected void listParse(Object object_find) {
		Tanmiguan tanmiguan = (Tanmiguan) object_find;

		String openId = this.getParameter("openId");

		if(!MyUtil.isEmpty(openId)){
			tanmiguan.setOpenId(openId);
		}
    }

	@Override
	protected void saveParse(Object object_find) {
		super.saveParse(object_find);
	}
}
