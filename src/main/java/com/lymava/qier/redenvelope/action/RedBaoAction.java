package com.lymava.qier.redenvelope.action;

import com.lymava.base.action.BaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlMethod;
import com.lymava.commons.util.MyUtil;
import com.lymava.qier.redenvelope.model.RedBao;

public class RedBaoAction extends BaseAction {

    /**
	 * 
	 */
	private static final long serialVersionUID = -5135969342422596642L;

 
	  	@AcceptUrlMethod(name = "领取红包")
		public String save_hongbao( ){
	  		
	
			String huiyuan = this.getParameter("object.huiyuan");
			String beizhu = this.getParameter("object.beizhu");
			
			if(!MyUtil.isEmpty(huiyuan)) {
//				setA
			}
			
			if(!MyUtil.isEmpty(beizhu)) {
				
			}
			
			return basePath;
	    }
	
}
