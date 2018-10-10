package com.lymava.qier.business;

import java.util.Map;

import org.bson.types.ObjectId;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.lymava.base.safecontroler.model.UserV2;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.HttpUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.ThreadPoolContext;
import com.lymava.nosql.context.SerializContext;
import com.lymava.qier.cmbpay.model.CmbBankAccountPay;
import com.lymava.qier.cmbpay.model.TransferToMerchantRecord;
import com.lymava.qier.model.Merchant72;
import com.lymava.qier.model.SettlementBank;
import com.lymava.trade.base.model.BusinessRecord;
import com.lymava.trade.base.model.WriteBusiness;
/***
 * 给商户转账
 * @author lymava
 *
 */
public class TransferToMerchantBusiness extends WriteBusiness<TransferToMerchantRecord>{

	/**
	 * 
	 */
	private static final long serialVersionUID = 9191370854555747451L;

	@Override
	public TransferToMerchantRecord initBusinessRecord() {
		return new TransferToMerchantRecord();
	}

	@Override
	public Class<? extends BusinessRecord> getBusinessRecordClass() {
		return TransferToMerchantRecord.class;
	}

	@Override
	public TransferToMerchantRecord parseBusinessRecord(TransferToMerchantRecord businessRecord, Map requestMap) {
		
		String transter_memo = HttpUtil.getParemater(requestMap, "transter_memo");
		Double transter_price_yuan = (Double) requestMap.get("transter_price_yuan");
		
		Long transter_price_fen = MathUtil.multiply(transter_price_yuan, 100).longValue();
		
		Merchant72 merchant72 = (Merchant72) businessRecord.getUser_huiyuan();
		
		UserV2 userV2 = (UserV2) requestMap.get("userV2");
		
		SettlementBank settlementBank = merchant72.getSettlementBank();
		
		CheckException.checkIsTure(settlementBank != null, "结算账户未绑定!");
		
		CmbBankAccountPay cmbBankAccount = CmbBankAccountPay.getInstance();
		
		Long profit_fen = merchant72.get_profit_fen(transter_price_fen);
		
		businessRecord.setId(new ObjectId().toString());
		businessRecord.setAccept_account(settlementBank.getAccount());
		businessRecord.setAccept_depositary_bank(settlementBank.getDepositary_bank());
		businessRecord.setAccept_name(settlementBank.getName());
		businessRecord.setAccept_bank_type(settlementBank.getBank_type());
		businessRecord.setAccept_bank_addr(settlementBank.getBank_addr());
		businessRecord.setPay_account_no(cmbBankAccount.getACCNBR());
		businessRecord.setPay_method(cmbBankAccount.getPay_method_id());
		businessRecord.setYingxiao_price_fen(profit_fen);
		businessRecord.setYufukuan_price_fen(transter_price_fen+profit_fen); 
		businessRecord.setUserV2(userV2);
		businessRecord.setBack_memo(transter_memo);
		businessRecord.setPrice_fen_all(transter_price_fen);
		businessRecord.setState(State.STATE_INPROCESS);
		
		
		return businessRecord;
	}

	@Override
	public TransferToMerchantRecord executeWriteBusiness(TransferToMerchantRecord businessRecord) throws Exception{
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		CmbBankAccountPay cmbBankAccount = CmbBankAccountPay.getInstance();
		
		String pay_to_bankaccount = cmbBankAccount.pay_to_bankaccount(businessRecord);
		
		Document document_root = DocumentHelper.parseText(pay_to_bankaccount);
			
		Element rootElement = document_root.getRootElement();
		
		Element element_NTQPAYRQZ = rootElement.element("NTQPAYRQZ");
		
		String ERRCOD = element_NTQPAYRQZ.elementTextTrim("ERRCOD");
		String REQNBR = element_NTQPAYRQZ.elementTextTrim("REQNBR");
		String REQSTS = element_NTQPAYRQZ.elementTextTrim("REQSTS");
		String SQRNBR = element_NTQPAYRQZ.elementTextTrim("SQRNBR");
		String YURREF = element_NTQPAYRQZ.elementTextTrim("YURREF");
		String RTNFLG = element_NTQPAYRQZ.elementTextTrim("RTNFLG");
		
		Integer state_pay = State.STATE_INPROCESS;
		
		long currentTimeMillis = System.currentTimeMillis();
		
		if(CmbBankAccountPay.REQSTS_FIN.equals(REQSTS) && CmbBankAccountPay.RTNFLG_F.equals(RTNFLG) ) {
			state_pay = State.STATE_FALSE;
		}
		
		//
		while(  
				!State.STATE_PAY_SUCCESS.equals(state_pay) 
				&& !State.STATE_FALSE.equals(state_pay)
				&& System.currentTimeMillis()-currentTimeMillis < 30*DateUtil.one_sec
				) {
			
			state_pay = businessRecord.make_sure_paystate();
			
			if(!State.STATE_PAY_SUCCESS.equals(state_pay) && !State.STATE_FALSE.equals(state_pay) ) {
				Thread.sleep(3*DateUtil.one_sec);
			}
		}
		
		TransferToMerchantRecord transferToMerchantRecord_update = null;
		
		if(!State.STATE_INPROCESS.equals(state_pay)) {
			
			businessRecord.setState(state_pay);
			
			transferToMerchantRecord_update = new TransferToMerchantRecord();
			transferToMerchantRecord_update.setState(state_pay);
		}
		
		if(State.STATE_PAY_SUCCESS.equals(state_pay)) {
			if(transferToMerchantRecord_update != null) {
				transferToMerchantRecord_update.setPayTime(System.currentTimeMillis());
			}
//			businessRecord.pay_success_notify_back();
		}
		
		if(State.STATE_INPROCESS.equals(state_pay)) {
			//后台更新这个任务 60 分钟
			ThreadPoolContext.getExecutorService().execute(new Runnable() {
				@Override
				public void run() {
					Integer state_pay_tmp = businessRecord.getState();
					while(  
							!State.STATE_PAY_SUCCESS.equals(state_pay_tmp) 
							&& !State.STATE_FALSE.equals(state_pay_tmp)
							&& System.currentTimeMillis()-currentTimeMillis < 60*DateUtil.one_minite
							) {
						
						state_pay_tmp = businessRecord.make_sure_paystate();
						
						if(!State.STATE_PAY_SUCCESS.equals(state_pay_tmp) && !State.STATE_FALSE.equals(state_pay_tmp) ) {
							try {
								Thread.sleep(3*DateUtil.one_sec);
							} catch (InterruptedException e) {
								logger.error("休眠异常!", e);
							}
						}
					}
					
				}
			});
			 
		}
		
		
		return transferToMerchantRecord_update;
	}
	
	
}
