package com.lymava.qier.cmbpay.action;

import java.util.HashMap;
import java.util.Map;

import org.apache.struts2.ServletActionContext;
import org.bson.types.ObjectId;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlMethod;
import com.lymava.base.safecontroler.model.UserV2;
import com.lymava.base.util.ContextUtil;
import com.lymava.base.util.FinalVariable;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.state.State;
import com.lymava.commons.state.StatusCode;
import com.lymava.commons.util.HttpUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.commons.util.ThreadPoolContext;
import com.lymava.nosql.model.SerializModel;
import com.lymava.nosql.mongodb.vo.BaseModel;
import com.lymava.qier.business.BusinessIntIdConfigQier;
import com.lymava.qier.cmbpay.model.CmbBankAccountPay;
import com.lymava.qier.cmbpay.model.TransferToMerchantRecord;
import com.lymava.qier.model.Merchant72;
import com.lymava.qier.model.SettlementBank;
import com.lymava.trade.base.context.BusinessContext;
import com.lymava.trade.base.model.Business;
import com.lymava.trade.base.model.BusinessIntIdConfig;

@AcceptUrlAction(path="v2/TransferToMerchantRecord/",name="商户付款记录")
public class TransferToMerchantRecordAction extends LazyBaseAction {

    /**
	 * 
	 */
	private static final long serialVersionUID = -4293292843544616363L;

	@Override
    protected Class<? extends SerializModel> getObjectClass() {
        return TransferToMerchantRecord.class;
    }

    @Override
    protected void listParse(Object object_find) {

    	TransferToMerchantRecord transferToMerchantRecord = (TransferToMerchantRecord)object_find;
    	
    }
    
    @AcceptUrlMethod(name = "保存录入转账凭证")
	public String save_transferToMerchantRecord(){
    	
    	String merchant72_id = this.getParameter("merchant72_id"); 
		
		UserV2 userV2 = (UserV2) request.getAttribute(FinalVariable.SESSION_LOGINUSER);
		
		Merchant72 merchant72 = null;
		
		if(MyUtil.isValid(merchant72_id)){
			merchant72 = (Merchant72) serializContext.get(Merchant72.class,merchant72_id);
		}
		
		CheckException.checkIsTure(merchant72 != null, "商户不存在!");
		
		String requestFlow = this.getParameter("requestFlow"); 
		String transter_price_yuan_str = this.getParameter("transter_price_yuan");
		String transter_memo = this.getParameter("transter_memo");
		
		String object_pinzheng = this.getParameter("object.pinzheng");
		
		Double transter_price_yuan = MathUtil.parseDouble(transter_price_yuan_str);
		
		CheckException.checkIsTure(transter_price_yuan != 0, "转账金额不能为0!");
		
		CheckException.checkIsTure(!MyUtil.isEmpty(object_pinzheng), "请先录入凭证!");
		
		TransferToMerchantRecord transferToMerchantRecord = new TransferToMerchantRecord();
		
		SettlementBank settlementBank = merchant72.getSettlementBank();
		
		CheckException.checkIsTure(settlementBank != null, "结算账户未绑定!");
		
		CmbBankAccountPay cmbBankAccount = CmbBankAccountPay.getInstance();
		
		Long transter_price_fen = MathUtil.multiply(transter_price_yuan, 100).longValue();
		
		Long profit_fen = merchant72.get_profit_fen(transter_price_fen);
		
		Long balanceFen = merchant72.getMerchant_balance_fen();
		
		String objectId = new ObjectId().toString();
		
		transferToMerchantRecord.setId(objectId);
		transferToMerchantRecord.setRequestFlow(requestFlow);
		transferToMerchantRecord.setAccept_account(settlementBank.getAccount());
		transferToMerchantRecord.setAccept_depositary_bank(settlementBank.getDepositary_bank());
		transferToMerchantRecord.setAccept_name(settlementBank.getName());
		transferToMerchantRecord.setAccept_bank_type(settlementBank.getBank_type());
		transferToMerchantRecord.setAccept_bank_addr(settlementBank.getBank_addr());
		transferToMerchantRecord.setPay_account_no(cmbBankAccount.getACCNBR());
		transferToMerchantRecord.setPay_method(cmbBankAccount.getPay_method_id());
		transferToMerchantRecord.setYingxiao_price_fen(profit_fen);
		transferToMerchantRecord.setYufukuan_price_fen(transter_price_fen+profit_fen); 
		transferToMerchantRecord.setUserV2(userV2);
		transferToMerchantRecord.setBack_memo(transter_memo);
		transferToMerchantRecord.setPrice_fen_all(transter_price_fen);
		transferToMerchantRecord.setState(State.STATE_PAY_SUCCESS);
		transferToMerchantRecord.setIp(MyUtil.getIpAddr(request));
		transferToMerchantRecord.setUser_huiyuan(merchant72);
		transferToMerchantRecord.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_manual_transfer_to_merchant); 
		transferToMerchantRecord.setWallet_amount_balance_fen(balanceFen+transter_price_fen+profit_fen);
		
		String realPath = ServletActionContext.getServletContext().getRealPath("/");
		String picMove = MyUtil.picMove(object_pinzheng, objectId,realPath);
		
		transferToMerchantRecord.setPinzheng(picMove);
		
		serializContext.save(transferToMerchantRecord);
		Business.checkRequestFlow(transferToMerchantRecord);
		
		transferToMerchantRecord.pay_success_notify_back();
    	
    	this.setMessage("处理成功");
		this.setStatusCode(StatusCode.ACCEPT_OK);
		return SUCCESS; 
    } 
  
    @AcceptUrlMethod(name = "转账给商户")
	public String transfer_to_merchant(){
    	
		String merchant72_id = request.getParameter("merchant72_id"); 
		
		UserV2 userV2 = (UserV2) request.getAttribute(FinalVariable.SESSION_LOGINUSER);
		
		Merchant72 merchant72 = null;
		
		if(MyUtil.isValid(merchant72_id)){
			merchant72 = (Merchant72) serializContext.get(Merchant72.class,merchant72_id);
		}
		
		CheckException.checkIsTure(merchant72 != null, "商户不存在!");
		
		String requestFlow = request.getParameter("requestFlow"); 
		String transter_price_yuan_str = request.getParameter("transter_price_yuan");
		String transter_memo = request.getParameter("transter_memo");
		
		Double transter_price_yuan = MathUtil.parseDouble(transter_price_yuan_str);
		
		CheckException.checkIsTure(transter_price_yuan > 0, "转账金额必须大于0!");
		
		BusinessContext instance = BusinessContext.getInstance();
		
		Business<TransferToMerchantRecord> business = instance.getBusiness(BusinessIntIdConfigQier.businessIntId_transfer_to_merchant);
		
		CheckException.checkIsTure(business != null, "转账业务未配置!");
		
		Map requestMap = new HashMap();
		requestMap.putAll(request.getParameterMap());
		
		requestMap.put(Business.user_key, merchant72);
		requestMap.put(Business.ip_key, MyUtil.getIpAddr(request));
		requestMap.put(Business.requestFlow_key, requestFlow);
		requestMap.put("transter_memo", transter_memo);
		requestMap.put("transter_price_yuan", transter_price_yuan);
		requestMap.put("userV2", userV2);
		
		ThreadPoolContext.getExecutorService().execute(new Runnable() {
			@Override
			public void run() {
				//执行Business，保存记录
				TransferToMerchantRecord transferToMerchantRecord = business.executeBusiness(requestMap);
				transferToMerchantRecord.getState();
			}
		});
		
		this.setMessage("提交成功,银行处理中!");
		this.setStatusCode(StatusCode.ACCEPT_OK);
		return SUCCESS; 
	}


}