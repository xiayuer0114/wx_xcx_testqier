package com.lymava.qier.manager.action;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlMethod;
import com.lymava.base.safecontroler.model.UserV2;
import com.lymava.base.util.ContextUtil;
import com.lymava.base.util.FinalVariable;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.state.State;
import com.lymava.commons.state.StatusCode;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;
import com.lymava.qier.model.SettlementBank;
import com.lymava.qier.model.merchant.MerchantBankChangeRecord;

/**
 * 银行卡变更
 * @author lymava
 *
 */
@AcceptUrlAction(path="v2/MerchantBankChange/",name="银行卡变更")
public  class MerchantBankChangeAction extends LazyBaseAction{


	/**
	 * 
	 */
	private static final long serialVersionUID = -3693498164627873810L;
	@Override
	protected Class<? extends BaseModel> getObjectClass() {
		return MerchantBankChangeRecord.class;
	}

	@AcceptUrlMethod(name = "审核")
	public String shenghe() {

		//获取参数
		String id = this.getParameter("id");
		CheckException.isValid(id, "记录id无效！");
		
		UserV2 userV2_shenghe = (UserV2) request.getAttribute(FinalVariable.SESSION_LOGINUSER);
		
		String user_huiyuan_id = this.getParameter("user_huiyuan_id");
		CheckException.isValid(user_huiyuan_id, "商户id无效！");

		String record_memo = this.getParameter("record_memo");

		Integer bank_type = Integer.valueOf(this.getParameter("bank_type"));
		String depositary_bank = this.getParameter("depositary_bank");
		String account = this.getParameter("account");
		String bank_addr = this.getParameter("bank_addr");
		String name = this.getParameter("name");
		String memo = this.getParameter("memo");

		//已变更的银行卡不能再改变状态
		MerchantBankChangeRecord merchantBankChangeRecord_find = (MerchantBankChangeRecord) serializContext.get(MerchantBankChangeRecord.class, id);
		CheckException.checkIsTure(
				!MerchantBankChangeRecord.accept_shenhe_state_complete.equals(merchantBankChangeRecord_find.getState()), "不能修改已变更的银行卡状态");

		//修改状态
		String state_str = this.getParameter("state");
		Integer shenhe_state = Integer.valueOf(state_str);

		MerchantBankChangeRecord merchantBankChangeRecord_update = new MerchantBankChangeRecord();
		
		merchantBankChangeRecord_update.setState(shenhe_state);
		merchantBankChangeRecord_update.setRecord_memo(record_memo);
		merchantBankChangeRecord_update.setUserV2_shenghe(userV2_shenghe);
		
		serializContext.updateObject(id, merchantBankChangeRecord_update);

		//变更银行卡
        if (MerchantBankChangeRecord.accept_shenhe_state_complete.equals(shenhe_state)) {
        	
			SettlementBank settlementBank_panduan = new SettlementBank();
			settlementBank_panduan.setMerchant72_id(user_huiyuan_id);
			
			SettlementBank settlementBank_update = (SettlementBank) serializContext.get(settlementBank_panduan);

			if(settlementBank_update == null) {
				settlementBank_update = new SettlementBank();
				settlementBank_update.setMerchant72_id(user_huiyuan_id);
			}
			
			settlementBank_update.setBank_type(bank_type);
			settlementBank_update.setDepositary_bank(depositary_bank);
			settlementBank_update.setAccount(account);
			settlementBank_update.setBank_addr(bank_addr);
			settlementBank_update.setName(name);
			settlementBank_update.setMemo(memo);
			
			if(MyUtil.isValid(settlementBank_update.getId())) {
				
				serializContext.updateObject(settlementBank_update.getId(),settlementBank_update);
				
			}else {
				settlementBank_update.setState(State.STATE_OK);
				serializContext.save(settlementBank_update);
			}
			
		}

		this.setMessage("修改成功！");
		this.setStatusCode(StatusCode.ACCEPT_OK);
		return SUCCESS;
	}


	@Override
	public String list(){
		throw new CheckException("方法不存在");
	}
	@Override
	public String edit(){
		throw new CheckException("方法不存在");
	}
	@Override
	public String delete(){
		throw new CheckException("方法不存在");
	}
	@Override
	public String save(){
		throw new CheckException("方法不存在");
	}
}
