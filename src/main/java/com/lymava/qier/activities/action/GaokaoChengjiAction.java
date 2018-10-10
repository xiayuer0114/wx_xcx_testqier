package com.lymava.qier.activities.action;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.nosql.model.SerializModel;
import com.lymava.qier.activities.model.GaokaoChengji;

@AcceptUrlAction(path="v2/GaokaoChengji/",name="高考成绩")
public class GaokaoChengjiAction extends LazyBaseAction {  

	/**
	 * 
	 */
	private static final long serialVersionUID = 5722685628873558905L;

	@Override
    protected Class<? extends SerializModel> getObjectClass() {
        return GaokaoChengji.class;
    }

    @Override
    protected void listParse(Object object_find) {
    	GaokaoChengji gaokaoChengji = (GaokaoChengji)object_find;
    }

	@Override
	protected void saveParse(Object object_find) {
		super.saveParse(object_find);
		
		
	} 

}