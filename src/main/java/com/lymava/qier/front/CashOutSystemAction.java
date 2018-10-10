package com.lymava.qier.front;

import org.bson.types.ObjectId;

import com.google.gson.JsonObject;
import com.lymava.base.face.action.FaceAction;
import com.lymava.base.model.SimpleDbCacheContent;
import com.lymava.base.model.User;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.state.State;
import com.lymava.commons.state.StatusCode;
import com.lymava.commons.util.HexM;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.qier.model.Product72;
import com.lymava.qier.model.TradeRecord72;
import com.lymava.trade.pay.model.MmanualRefundRecord;
import com.lymava.trade.pay.model.PaymentRecord;

/**
 * 给收银系统的
 * @author lymava
 *
 */
public class CashOutSystemAction extends FaceAction {
	/**
	 * 
	 */
	private static final long serialVersionUID = 6516766946817317336L;
	
	private User check_user(){
		User user = requestFrameMsg.getUser();
		return user;
	}  
	
	/**
	 * 创建支付链接
	 * @return
	 */
	public String create_payment_link(){
		
		User check_user = this.check_user();
		
		String product_id = this.getRequestParameter("product_id");
		String orderId = this.getRequestParameter("orderId");
		String price_yuan = this.getRequestParameter("price_yuan");
		String table_umber = this.getRequestParameter("table_umber");
		String other_memo = this.getRequestParameter("other_memo");
		
		CheckException.checkIsTure(!MyUtil.isEmpty(orderId), "订单编号不能为空!");
		
		PaymentRecord paymentRecord_find = new PaymentRecord();
		paymentRecord_find.setRequestFlow(orderId);
		
		PaymentRecord paymentRecord_find_out = (PaymentRecord) serializContext.get(paymentRecord_find);
		
		CheckException.checkIsTure(paymentRecord_find_out == null, "订单编号重复!",State.STATE_ORDER_NOT_EXIST);

        String pay_url = MyUtil.getBasePath(request);
        
    	Product72 product_find_out = null;
    	if(MyUtil.isValid(product_id)){
    		product_find_out = (Product72) serializContext.get(Product72.class, product_id);
    	}else{
    		Long bianhao = MathUtil.parseLongNull(product_id);
    		if(bianhao != null){
    			Product72 product_find = new Product72();
    			product_find.setBianhao(bianhao);
    		
    			product_find_out = (Product72) serializContext.get(product_find);
    		}
    	}
    	
    	CheckException.checkIsTure(product_find_out != null, "产品编号配置有误!");
    	
    	CheckException.checkIsTure(check_user.getId().equals(product_find_out.getUserId_merchant()) , "产品编号配置有误!");

        pay_url+="?price_yuan="+price_yuan; 
        pay_url+="&b="+product_find_out.getBianhao();
        pay_url+="&orderId="+orderId;
        pay_url+="&table_umber="+HexM.encodeHexString(table_umber);
        pay_url+="&other_memo="+HexM.encodeHexString(other_memo);
        
//        Integer qrcode_size = 400;
//        BufferedImage bufferedImage = null;
//        String temp_pic_path ="";
//        try {
//            bufferedImage = QrCodeUtil.createQrBufferedImage(pay_url,qrcode_size);
//            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
//            ImageUtil.write(bufferedImage,byteArrayOutputStream);
//            String realPath = ServletActionContext.getServletContext().getRealPath("/");
//
//            temp_pic_path = MyUtil.savePic(byteArrayOutputStream.toByteArray(),realPath);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }

            // 设置返回信息
        JsonObject jsonObject =new JsonObject();
        jsonObject.addProperty("pay_url",pay_url);
//        jsonObject.addProperty("pay_url_qrcode",basePath+temp_pic_path);
        jsonObject.addProperty("pay_url_qrcode","");
        jsonObject.addProperty("orderId",orderId);
        
        this.setDataRoot(jsonObject);
		this.setStatusCode(StatusCode.ACCEPT_OK);
		return SUCCESS;
	} 
	
	/**
	 * 查询支付状态
	 * @return
	 */
	public String query_payment_record(){
		
		User check_user = this.check_user();
		
		String orderId = this.getRequestParameter("orderId");
		
		TradeRecord72 paymentRecord_find = new TradeRecord72();
		
		paymentRecord_find.setRequestFlow(orderId);
		paymentRecord_find.setState(State.STATE_PAY_SUCCESS);
		paymentRecord_find.setUserId_merchant(check_user.getId());
		
		PaymentRecord paymentRecord_find_out = (PaymentRecord) serializContext.get(paymentRecord_find);
		
		
		Integer state  = State.STATE_WAITE_PAY;
		
		Long price_fen_all = null;
		String payFlow = null;
		Long payTime = null;
		Long payPrice_fen_all = null;
		Integer pay_method = null;
		Long balance_fen = 0l;
		Long integral = 0l;
		Long user_bianhao = 0l;
		
		if(paymentRecord_find_out != null){
			price_fen_all = paymentRecord_find_out.getShowPrice_fen_all();
			payFlow = paymentRecord_find_out.getShowPayFlow();
			payTime = paymentRecord_find_out.getPayTime();
			payPrice_fen_all = paymentRecord_find_out.getPayPrice_fen_all();
			pay_method = paymentRecord_find_out.getPay_method();
			state = paymentRecord_find_out.getState();
			
			User user_huiyuan = paymentRecord_find_out.getUser_huiyuan();
			
			if(user_huiyuan != null){
				balance_fen = user_huiyuan.getBalanceFen();
				integral = user_huiyuan.getIntegral();
				user_bianhao = user_huiyuan.getBianhao();
			}
			//狗日的自己写的垃圾代码
			TradeRecord72 tradeRecord72_tmp = new TradeRecord72();
			tradeRecord72_tmp.setUserId_merchant(check_user.getId());
			
			 String merchant_today_cash_total_key = tradeRecord72_tmp.get_merchant_today_cash_total_key();
			 Long today_total_fen  = (Long) SimpleDbCacheContent.get_object(merchant_today_cash_total_key);
			 if(today_total_fen == null){ today_total_fen = 0l;}
			 
			 String merchant_today_cash_total_key_alipay = tradeRecord72_tmp.get_merchant_today_cash_total_key_alipay();
			 Long today_total_fen_alipay  = (Long) SimpleDbCacheContent.get_object(merchant_today_cash_total_key_alipay);
			 if(today_total_fen_alipay == null){ today_total_fen_alipay = 0l;}
			 
			 String merchant_today_cash_total_key_weixin = tradeRecord72_tmp.get_merchant_today_cash_total_key_weixin();
			 Long today_total_fen_weixin  = (Long) SimpleDbCacheContent.get_object(merchant_today_cash_total_key_weixin);
			 if(today_total_fen_weixin == null){ today_total_fen_weixin = 0l;}
			 
			String merchant_today_cash_total_key_qianbao = tradeRecord72_tmp.get_merchant_today_cash_total_key_qianbao();
			Long today_total_fen_balance  = (Long) SimpleDbCacheContent.get_object(merchant_today_cash_total_key_qianbao);
			if(today_total_fen_balance == null){ today_total_fen_balance = 0l;}
			 /**
			  * 退款的统计
			  */
			String merchant_today_refund_total_key = tradeRecord72_tmp.get_merchant_today_refund_total_key();
			Long refund_today_total_fen_balance  = (Long) SimpleDbCacheContent.get_object(merchant_today_refund_total_key);
			if(refund_today_total_fen_balance == null){ refund_today_total_fen_balance = 0l;}
			
			Double today_total_yuan = MathUtil.divide(today_total_fen, 100).doubleValue();
			
			Double today_total_yuan_weixin = MathUtil.divide(today_total_fen_weixin, 100).doubleValue();
			Double today_total_yuan_alipay = MathUtil.divide(today_total_fen_alipay, 100).doubleValue();
			Double today_total_yuan_balance = MathUtil.divide(today_total_fen_balance, 100).doubleValue();
			//退款总金额
			Double refund_today_total_yuan_balance = MathUtil.divide(refund_today_total_fen_balance, 100).doubleValue();
			//减去了退款金额的实际总额
			Double today_total_yuan_shiji = MathUtil.divide(today_total_fen-refund_today_total_fen_balance, 100).doubleValue();
			
			this.addDataField("today_total_yuan", today_total_yuan);
			this.addDataField("today_total_yuan_balance", today_total_yuan_balance);
			this.addDataField("today_total_yuan_weixin", today_total_yuan_weixin);
			this.addDataField("today_total_yuan_alipay", today_total_yuan_alipay);
			this.addDataField("today_total_yuan_shiji", today_total_yuan_shiji);
			this.addDataField("refund_today_total_yuan_balance", refund_today_total_yuan_balance);
		}
		

		this.addDataField("state", state);
		this.addDataField("price_fen_all", price_fen_all);
		this.addDataField("payFlow", payFlow);
		this.addDataField("payTime", payTime);
		this.addDataField("payPrice_fen_all", payPrice_fen_all);
		this.addDataField("pay_method", pay_method);
		this.addDataField("balance_fen", balance_fen);
		this.addDataField("integral", integral);
		this.addDataField("user_bianhao", user_bianhao);
		
		this.setStatusCode(StatusCode.ACCEPT_OK);
		return SUCCESS;
	} 
	/**
	 * 支付单的退款冲正
	 * @return
	 */
	public String payment_record_refund(){
		
		User check_user = this.check_user();
		
		String orderId = this.getRequestParameter("orderId");
		String refund_orderId = this.getRequestParameter("refund_orderId");
		String price_yuan_str = this.getRequestParameter("price_yuan");
		String refund_memo = this.getRequestParameter("refund_memo");
		
		CheckException.checkIsTure(!MyUtil.isEmpty(refund_orderId), "refund_orderId 不能为空!");
		
		Double price_yuan = MathUtil.parseDoubleNull(price_yuan_str);
		
		TradeRecord72 paymentRecord_find = new TradeRecord72();
		
		paymentRecord_find.setRequestFlow(orderId);
		paymentRecord_find.setUserId_merchant(check_user.getId());
		
		paymentRecord_find.addCommand(MongoCommand.in, "state", State.STATE_PAY_SUCCESS);
		paymentRecord_find.addCommand(MongoCommand.in, "state", State.STATE_OK);
		
		PaymentRecord paymentRecord_find_out = (PaymentRecord) serializContext.get(paymentRecord_find);
		 
		CheckException.checkIsTure(paymentRecord_find_out != null, "订单不存在!",State.STATE_ORDER_NOT_EXIST);
		
		paymentRecord_find_out =	(PaymentRecord) paymentRecord_find_out.getFinalBusinessRecord();
		
		Long pianyi =  User.getPianyi(price_yuan);
		
		CheckException.checkIsTure(pianyi != null && pianyi > 0, "退款金额必须大于0！");
		
		CheckException.checkIsTure(State.STATE_OK.equals(paymentRecord_find_out.getState()) || State.STATE_PAY_SUCCESS.equals(paymentRecord_find_out.getState()), "该比状态异常订单不能退款！");
		
		MmanualRefundRecord refundRecord = new MmanualRefundRecord();
		
		refundRecord.setId(new ObjectId().toString());
		refundRecord.setPrice_pianyi_all(pianyi);
		refundRecord.setMemo(refund_memo);
		refundRecord.setRequestFlow(refund_orderId);
		refundRecord.setIp(MyUtil.getIpAddr(request));
		refundRecord.setPay_method(paymentRecord_find_out.getPay_method());
		refundRecord.setPaymentRecord_id(paymentRecord_find_out.getId());
		
		Integer state_refund = paymentRecord_find_out.refund(refundRecord);
		
		if(State.STATE_OK.equals(state_refund)) {
			this.setDataState(State.STATE_REFUND_OK);
			this.setMessage("退款成功！");
		}else {
			this.setDataState(State.STATE_FALSE);
			this.setMessage("退款失败！");
		}
		
		this.setStatusCode(StatusCode.ACCEPT_OK);
		return SUCCESS;
	} 
 
}
