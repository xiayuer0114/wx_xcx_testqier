package com.lymava.qier.activities.action;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.nosql.model.SerializModel;
import com.lymava.qier.activities.model.RedEnvelopes618;
import com.lymava.qier.activities.model.SubscribeFirstRedEnvelope;

@AcceptUrlAction(path="v2/SubscribeFirstRedEnvelope/",name="关注立减")
public class SubscribeFirstRedEnvelopeAction extends LazyBaseAction {
    /**
	 * 
	 */
	private static final long serialVersionUID = 5617352535553569250L; 

	@Override
    protected Class<? extends SerializModel> getObjectClass() {
        return SubscribeFirstRedEnvelope.class;
    }

    @Override
    protected void listParse(Object object_find) {
		SubscribeFirstRedEnvelope subscribeFirstRedEnvelope = (SubscribeFirstRedEnvelope)object_find;
    }

	@Override
	protected void saveParse(Object object_find) {
		super.saveParse(object_find);

	} 

}