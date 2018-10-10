package com.lymava.qier.manager.action;

import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlMethod;
import com.lymava.base.safecontroler.annotation.FinalVariableAcceptUrl;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;
import com.lymava.qier.model.TradeRecord72;
import com.lymava.trade.base.action.BusinessRecordManagerAction;
import com.lymava.trade.base.context.BusinessContext;
import com.lymava.trade.base.model.Business;
import com.lymava.trade.base.model.BusinessRecord;

/**
 * @author lymava
 *
 */
@AcceptUrlAction(path="v2/tradeRecord72/",name="72交易")
public  class TradeRecord72ManagerAction extends BusinessRecordManagerAction{
 
	/**
	 *  
	 */
	private static final long serialVersionUID = -1293914773529207326L;
	
	@Override
	public String edit() {
		throw new CheckException("请使用 BusinessRecordManagerAction 的方法!");
	}


	@Override
	public String save() {
		throw new CheckException("请使用 BusinessRecordManagerAction 的方法!");
	}
	/**
	 * 解析展示的业务记录类别
	 * @return
	 */
	public BusinessRecord parseShowBusinessRecord(){
		
		TradeRecord72 businessRecord  =  new TradeRecord72();
		
		request.setAttribute(showClass_hand, this.getObjectClass()); 
		
		String userId_merchant = this.getRequestParameter("userId_merchant","object.userId_merchant");
		if(MyUtil.isValid(userId_merchant)) {
			businessRecord.setUserId_merchant(userId_merchant);
		}
		
		return businessRecord;
	}

	@Override
	@AcceptUrlMethod(name = "管理" ,location=FinalVariableAcceptUrl.location_left,target=FinalVariableAcceptUrl.target_navTab)
	public String list() {
		return super.list();
	}


	@Override
	public String delete() {
		throw new CheckException("请使用 BusinessRecordManagerAction 的方法!");
	}


	@Override
	protected Class<? extends BaseModel> getObjectClass() {
		return TradeRecord72.class;
	}
}
