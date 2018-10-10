package com.lymava.qier.activities.action;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.model.SerializModel;
import com.lymava.nosql.mongodb.vo.BaseModel;
import com.lymava.qier.activities.model.MarketingActivities;
import com.lymava.qier.activities.model.MarketingActivitiesMerchant;


@AcceptUrlAction(path="v2/MarketingActivitiesMerchant/",name="活动参与商家")
public class MarketingActivitiesMerchantAction extends LazyBaseAction{ 
	/**
	 * 
	 */
	private static final long serialVersionUID = 2181830810477979758L;

	@Override
    protected Class<? extends SerializModel> getObjectClass() {
        return MarketingActivitiesMerchant.class;
    }

    @Override
    protected void listParse(Object object_find) {
    	MarketingActivitiesMerchant marketingActivitiesMerchant = (MarketingActivitiesMerchant) object_find;
 
    }
    
	@Override
	public String edit() {
		String id = request.getParameter("id"); 
		String marketingActivities_id = request.getParameter("marketingActivities_id"); 
		
		MarketingActivitiesMerchant object = null;
		
		if(MyUtil.isValid(id)){
			object = (MarketingActivitiesMerchant) serializContext.get(this.getObjectClass(),id);
		}
		
		if(MyUtil.isValid(marketingActivities_id)){
			MarketingActivities marketingActivities = (MarketingActivities) serializContext.get(MarketingActivities.class,marketingActivities_id);
			
			if(object == null) {
				object = new MarketingActivitiesMerchant();
				object.setMarketingActivities(marketingActivities);
			}
		}
		
		
		request.setAttribute("object", object);
		this.setSuccessResultValue(this.getBasePath()+"edit.jsp");
		return SUCCESS; 
	}

	@Override
	protected void saveParse(Object object_find) {
		super.saveParse(object_find);
		
		MarketingActivitiesMerchant marketingActivitiesMerchant = (MarketingActivitiesMerchant) object_find;

	}



}