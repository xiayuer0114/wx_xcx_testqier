package com.lymava.qier.activities.action;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.nosql.model.SerializModel;
import com.lymava.qier.activities.model.GaokaoChengji;
import com.lymava.qier.activities.model.ShengmutiTemaiConfig;

@AcceptUrlAction(path="v2/ShengmutitemaiConfig/",name="圣穆提特卖配置")
public class ShengmutitemaiConfigAction extends LazyBaseAction {

	@Override
    protected Class<? extends SerializModel> getObjectClass() {
        return ShengmutiTemaiConfig.class;
    }

    @Override
    protected void listParse(Object object_find) {
		ShengmutiTemaiConfig shengmutiTemaiConfig = (ShengmutiTemaiConfig)object_find;
    }

	@Override
	protected void saveParse(Object object_find) {
		super.saveParse(object_find);
		
		
	} 

}