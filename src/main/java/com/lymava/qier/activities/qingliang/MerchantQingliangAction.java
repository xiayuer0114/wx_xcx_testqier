package com.lymava.qier.activities.qingliang;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.model.SerializModel;

@AcceptUrlAction(path="v2/MerchantQingliang/",name="商户清凉成绩")
public class MerchantQingliangAction extends LazyBaseAction {
  
	/**
	 * 
	 */
	private static final long serialVersionUID = -8914619439705349973L;

	@Override
    protected Class<? extends SerializModel> getObjectClass() {
        return MerchantQingliang.class;
    }

    @Override
    protected void listParse(Object object_find) {
    	MerchantQingliang merchantQingliang = (MerchantQingliang)object_find;
    	
    	String userId_merchant = this.getRequestParameter("userId_merchant","object.userId_merchant");
    	
    	String object_state = this.getParameter("object.state");
    	Integer state = MathUtil.parseIntegerNull(object_state);
    	
    	if(MyUtil.isValid(userId_merchant) ) {
    		merchantQingliang.setUserId_merchant(userId_merchant);
    	}
    	if(state != null && state != -1) { 
    		merchantQingliang.setState(state);
    	}
    }
 

}