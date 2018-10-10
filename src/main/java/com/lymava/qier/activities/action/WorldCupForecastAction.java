package com.lymava.qier.activities.action;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.nosql.model.SerializModel;
import com.lymava.qier.activities.model.WorldCupForecast;

@AcceptUrlAction(path="v2/WorldCupForecast/",name="世界杯")
public class WorldCupForecastAction extends LazyBaseAction {
    /**
	 * 
	 */
	private static final long serialVersionUID = -1192989015263667855L;

	@Override
    protected Class<? extends SerializModel> getObjectClass() {
        return WorldCupForecast.class;
    }

    @Override
    protected void listParse(Object object_find) {

    	WorldCupForecast worldCupForecast = (WorldCupForecast)object_find;
    }

	@Override
	protected void saveParse(Object object_find) {
		super.saveParse(object_find);
		
		
	} 

}