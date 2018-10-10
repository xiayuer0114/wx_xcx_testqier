package com.lymava.qier.util;

import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.qier.action.CashierAction;
import com.lymava.qier.model.Merchant72;

public class QierUtil {

    /**
     * 获取 Merchant72
     * @return
     */
    public static Merchant72 getMerchant72User(User user) {
    	
    	if(user == null) {
    		return null;
    	}
    	
    	String userGroupId = user.getUserGroupId();
    	
    	if(CashierAction.getMerchantUserGroutId().equals(userGroupId)) {
    		if(user instanceof Merchant72) {
    			return (Merchant72) user;
    		}else {
    			Merchant72 merchant72 = (Merchant72) ContextUtil.getSerializContext().get(Merchant72.class, user.getId());
    			return merchant72;
    		}
    	}
    	
    	User topUser = user.getTopUser();
    	
        Merchant72 merchant72 = (Merchant72) topUser;
        return merchant72;
    }
	
}
