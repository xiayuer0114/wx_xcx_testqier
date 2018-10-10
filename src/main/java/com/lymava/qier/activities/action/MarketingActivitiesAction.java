package com.lymava.qier.activities.action;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.model.SerializModel;
import com.lymava.qier.activities.model.MarketingActivities;


@AcceptUrlAction(path="v2/MarketingActivities/",name="市场营销活动")
public class MarketingActivitiesAction extends LazyBaseAction
{
	/**
	 *
	 */
	private static final long serialVersionUID = 5722685628873558905L;

	@Override
    protected Class<? extends SerializModel> getObjectClass() {
        return MarketingActivities.class;
    }

    @Override
    protected void listParse(Object object_find) {
    	MarketingActivities marketingActivities = (MarketingActivities) object_find;
 
    }

	@Override
	protected void saveParse(Object object_find) {
		super.saveParse(object_find);
		
		MarketingActivities marketingActivities = (MarketingActivities) object_find;

		String[] config_other_name_array = request.getParameterValues("config_other_name");
		 String[] config_other_key_array = request.getParameterValues("config_other_key");
		 String[] config_other_value_array = request.getParameterValues("config_other_value");
		 
		 if(config_other_value_array == null && config_other_value_array == null && config_other_name_array == null){
//			 NullBasicDBList instance = NullBasicDBList.getInstance();
//			 marketingActivities.setMarketingActivitiesConfig_list(instance);
			 return;
		}
		 
		 CheckException.checkIsTure(config_other_key_array != null && config_other_value_array != null && config_other_key_array.length == config_other_value_array.length, "其他参数校验异常!");
		 
		 
		 for (int i=0;i<config_other_key_array.length;i++) {
			 
			 
			 String config_other_name  = MyUtil.trimNull(config_other_name_array[i]);
			 String config_other_key  = MyUtil.trimNull(config_other_key_array[i]);
			 String config_other_value = MyUtil.trimNull(config_other_value_array[i]);
			 
			 CheckException.checkIsTure(!MyUtil.isEmpty(config_other_key) ,"其他参数名称不能为空！");
			 
			 marketingActivities.addMarketingActivitiesConfig(config_other_name, config_other_key, config_other_value);
		} 

	}



}