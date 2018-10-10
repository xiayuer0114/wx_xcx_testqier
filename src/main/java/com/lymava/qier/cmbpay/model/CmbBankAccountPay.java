package com.lymava.qier.cmbpay.model;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.Socket;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.bson.types.ObjectId;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import com.lymava.base.util.WebConfigContent;
import com.lymava.commons.pay.PayFinalVariable;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.qier.cmbpay.util.XmlPacket;
import com.lymava.qier.model.SettlementBank;
import com.lymava.trade.pay.model.PaymentRecord;
import com.lymava.trade.pay.passway.PayMethod;

/**
 * 招商银行账户
 * 
 * @author lymava
 *
 */
public class CmbBankAccountPay extends PayMethod {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3174688998632782956L;

	/**
	 * 登录名称
	 */
	private String login_name = null;
	/**
	 * 分行号 23 重庆
	 */
	private String BBKNBR = null;
	/**
	 * 银行帐号
	 */
	private String ACCNBR = null;
	/**
	 * 前置机地址
	 */
	private String hostname = null;
	/**
	 * 前置机端口
	 */
	private Integer port = null;
	/**
	 * A=活动，B=冻结，C=关户
	 */
	private String STSCOD;

	/**
	 *  上日余额
	 */
	private Long ACCBLV_fen;
	/**
	 *  联机余额
	 */
	private Long ONLBLV_fen;
	/**
	 *  冻结余额
	 */
	private Long HLDBLV_fen;
	/**
	 *  可用余额
	 */
	private Long AVLBLV_fen;
	/**
	 *  透支额度
	 */
	private Long LMTOVR_fen;
	/**
	 * 最近更新时间
	 */
	private Long last_update_time; 

	public static void main(String[] args) throws Exception {

		CmbBankAccountPay cmbBankAccount = new CmbBankAccountPay();

		cmbBankAccount.setLogin_name("昕玥游冬梅");
		cmbBankAccount.setBBKNBR("23");
		cmbBankAccount.setACCNBR("123910039710601");
		cmbBankAccount.setHostname("172.160.1.189");
		cmbBankAccount.setPort(7443);

//		Long queryAccountBalanceFromCmb = cmbBankAccount.queryAccountBalanceFromCmb();
		
		String accept_account = "622090346722291911";
		String accept_name = "马朝华";
		String accept_depositary_bank = "兴业银行重庆渝中支行";
		String accept_bank_addr = "重庆市渝中区";
		
		TransferToMerchantRecord transferToMerchantRecord = new TransferToMerchantRecord();
		
		transferToMerchantRecord.setId(new ObjectId().toString());
		transferToMerchantRecord.setPrice_fen_all(-1l);
		transferToMerchantRecord.setAccept_account(accept_account);
		transferToMerchantRecord.setAccept_name(accept_name);
		transferToMerchantRecord.setAccept_depositary_bank(accept_depositary_bank);
		transferToMerchantRecord.setAccept_bank_type(SettlementBank.bank_type_xingye);
		transferToMerchantRecord.setAccept_bank_addr(accept_bank_addr);
		
		System.out.println(5.0 == new Integer(5));
		
		System.out.println(3.1*3);
	
//		String pay_to_bankaccount = cmbBankAccount.pay_to_bankaccount(transferToMerchantRecord);
//		
//		transferToMerchantRecord.setId("5b5a8c99ef70d116b9ddafe9");
//		String queryTradeOrder = cmbBankAccount.queryTradeOrder(transferToMerchantRecord);
	}
	
	public static final String config_cmb_pay_login_name 	= "cmb_pay_login_name";
	public static final String config_cmb_pay_BBKNBR 		= "cmb_pay_BBKNBR";
	public static final String config_cmb_pay_ACCNBR 		= "cmb_pay_ACCNBR";
	public static final String config_cmb_pay_hostname 		= "cmb_pay_hostname";
	public static final String config_cmb_pay_port 			= "cmb_pay_port";
	
	public static final String REQSTS_AUT = "AUT";// 	等待审批
	public static final String REQSTS_NTE = "NTE";//	终审完毕
	public static final String REQSTS_WCF = "WCF";//	订单待确认（商务支付用）
	public static final String REQSTS_BNK = "BNK";//	银行处理中
	public static final String REQSTS_FIN = "FIN";//	完成
	public static final String REQSTS_ACK = "ACK";//	等待确认(委托贷款用)
	public static final String REQSTS_APD = "APD";//	待银行确认(国际业务用)
	public static final String REQSTS_OPR = "OPR";//	数据接收中（代发）
	/**
	 * 成功 	银行支付成功
	 */
	public static final String RTNFLG_S = "S"; 
	/**
	 * 	失败 	银行支付失败
	 */
	public static final String RTNFLG_F = "F"; 
	/** 银行支付被退票 */
	public static final String RTNFLG_B = "B"; 
	/** 否决 	企业审批否决 */
	public static final String RTNFLG_R = "R";	
	/** 过期 	企业过期不审批 */
	public static final String RTNFLG_D = "D";
	/** 撤消 	企业撤销 */
	public static final String RTNFLG_C = "C";
	/** 商户撤销订单 	商务支付 */
	public static final String RTNFLG_M = "M";	
	/** 拒绝 	委托贷款被借款方拒绝 */
	public static final String RTNFLG_V = "V";
	/** 银行挂账 */
	public static final String RTNFLG_U = "U"; 	 	
	/** 退款 */
	public static final String RTNFLG_T = "T"; 
	 
	@Override
	public void reload_config() {
		
		login_name = WebConfigContent.getConfig(config_cmb_pay_login_name);
		BBKNBR = WebConfigContent.getConfig(config_cmb_pay_BBKNBR);
		ACCNBR = WebConfigContent.getConfig(config_cmb_pay_ACCNBR);
		hostname = WebConfigContent.getConfig(config_cmb_pay_hostname);
		
		String config_port = WebConfigContent.getConfig(config_cmb_pay_port);
		
		port = MathUtil.parseInteger(config_port);
	}
	
	
	/**
	 * 查询订单状态
	 * @return	返回当前可用余额	单位	分
	 */
	public String queryTradeOrder(PaymentRecord transferToMerchantRecord) {
		
				// 构造查询余额的请求报文
				XmlPacket xmlPkt = new XmlPacket("NTQRYSTY", login_name);

				Map mpAccInfo = new Properties();
				/**
				 * N02020: 内部转帐 N02030: 支付 N02031: 直接支付 N02040: 集团支付 N02041: 直接集团支付 
				 */
				mpAccInfo.put("BUSCOD", "N02031");
				mpAccInfo.put("YURREF", transferToMerchantRecord.getId());
				
				Long get_id_time_tmp = transferToMerchantRecord.get_id_time_tmp();
				
				SimpleDateFormat sdfyyyymmdd = new SimpleDateFormat("yyyyMMdd");
				
				String BGNDAT = sdfyyyymmdd.format(new Date(get_id_time_tmp-DateUtil.one_hour));
				String ENDDAT = sdfyyyymmdd.format(new Date(get_id_time_tmp+DateUtil.one_hour));
				
				mpAccInfo.put("BGNDAT", BGNDAT);
				mpAccInfo.put("ENDDAT", ENDDAT);
				
				xmlPkt.putProperty("NTQRYSTYX1", mpAccInfo);

				String xmlString = xmlPkt.toXmlString();
				
				// 连接前置机，发送请求报文，获得返回报文
				String result = this.sendRequest(xmlString);

				return result;
	}
	/**
	 * 查询可用余额
	 * @return	返回当前可用余额	单位	分
	 */
	public Long queryAccountBalanceFromCmb() {

		Long accountBalance = null;

		String accInfoFromCmb = getAccInfoFromCmb();

		try {
			Document parseText = DocumentHelper.parseText(accInfoFromCmb);

			Element rootElement = parseText.getRootElement();

			Element NTQACINFZ_element = rootElement.element("NTQACINFZ");

			// 上日余额
			String ACCBLV_str = NTQACINFZ_element.elementText("ACCBLV");
			// 联机余额
			String ONLBLV_str = NTQACINFZ_element.elementText("ONLBLV");
			// 冻结余额
			String HLDBLV_str = NTQACINFZ_element.elementText("HLDBLV");
			// 可用余额
			String AVLBLV_str = NTQACINFZ_element.elementText("AVLBLV");
			// 透支额度
			String LMTOVR_str = NTQACINFZ_element.elementText("LMTOVR");

			Double ACCBLV = MathUtil.parseDoubleNull(ACCBLV_str);
			Double ONLBLV = MathUtil.parseDoubleNull(ONLBLV_str);
			Double HLDBLV = MathUtil.parseDoubleNull(HLDBLV_str);
			Double AVLBLV = MathUtil.parseDoubleNull(AVLBLV_str);
			Double LMTOVR = MathUtil.parseDoubleNull(LMTOVR_str);
			
			if(ACCBLV != null) {
				ACCBLV_fen = MathUtil.multiply(ACCBLV, 100).longValue();;
			}
			if(ONLBLV != null) {
				ONLBLV_fen = MathUtil.multiply(ONLBLV, 100).longValue();;
			}
			if(HLDBLV != null) {
				HLDBLV_fen = MathUtil.multiply(HLDBLV, 100).longValue();;
			}
			if(AVLBLV != null) {
				accountBalance = MathUtil.multiply(AVLBLV, 100).longValue();
				AVLBLV_fen = accountBalance;
			}
			if(LMTOVR != null) {
				LMTOVR_fen = MathUtil.multiply(LMTOVR, 100).longValue();;
			}
			
			last_update_time = System.currentTimeMillis();
		} catch (DocumentException e) {
			logger.info("解析异常!",e);
		}

		return accountBalance;
	}
	/**
	 * 
	 * 
	 * @return
	 */
	public String pay_to_bankaccount(TransferToMerchantRecord transferToMerchantRecord) {

		// 构造支付的请求报文
				XmlPacket xmlPkt = new XmlPacket("DCPAYMNT", login_name);
				
				Map SDKPAYRQX = new Properties();
				/**
				 * N02031:直接支付 N02041:直接集团支付
				 */
				SDKPAYRQX.put("BUSCOD", "N02031");
				
				xmlPkt.putProperty("SDKPAYRQX", SDKPAYRQX);
				
				Map DCOPDPAYX = new Properties();
				
				Long showPrice_fen_all = transferToMerchantRecord.getShowPrice_fen_all();
				Double price_all_yuan = MathUtil.divide(showPrice_fen_all, 100).doubleValue();
				
				DCOPDPAYX.put("YURREF", transferToMerchantRecord.getId());
				DCOPDPAYX.put("DBTACC", this.getACCNBR());
				DCOPDPAYX.put("DBTBBK", this.getBBKNBR());
				DCOPDPAYX.put("TRSAMT", price_all_yuan.toString());
				DCOPDPAYX.put("CCYNBR", "10");
				//用途
				DCOPDPAYX.put("NUSAGE", "悠择预付款-"+transferToMerchantRecord.getBack_memo());
				if(SettlementBank.bank_type_zhaoshang.equals(transferToMerchantRecord.getAccept_bank_type())) {
					//Y：招行；N：非招行；
					DCOPDPAYX.put("BNKFLG", "Y");
					//N：普通 F：快速
					DCOPDPAYX.put("STLCHN", "F");
				}else {
					//Y：招行；N：非招行；
					DCOPDPAYX.put("BNKFLG", "N"); 
					//N：普通 F：快速
					DCOPDPAYX.put("STLCHN", "N");
					//跨行支付（BNKFLG=N）必填
					DCOPDPAYX.put("CRTBNK", transferToMerchantRecord.getAccept_depositary_bank());
					DCOPDPAYX.put("CRTADR", transferToMerchantRecord.getAccept_bank_addr());
				}
				
				DCOPDPAYX.put("CRTACC", transferToMerchantRecord.getAccept_account());
				DCOPDPAYX.put("CRTNAM", transferToMerchantRecord.getAccept_name());
				
				xmlPkt.putProperty("DCOPDPAYX", DCOPDPAYX);

		String xmlString = xmlPkt.toXmlString();
		
		// 连接前置机，发送请求报文，获得返回报文
		String result = this.sendRequest(xmlString);

		return result;
	}
	/**
	 * 查询账户信息
	 * 
	 * @return
	 */
	private String getAccInfoFromCmb() {

		// 构造查询余额的请求报文
		XmlPacket xmlPkt = new XmlPacket("GetAccInfo", login_name);

		Map mpAccInfo = new Properties();

		mpAccInfo.put("BBKNBR", BBKNBR);
		mpAccInfo.put("ACCNBR", ACCNBR);
		xmlPkt.putProperty("SDKACINFX", mpAccInfo);

		String xmlString = xmlPkt.toXmlString();

		// 连接前置机，发送请求报文，获得返回报文
		String result = this.sendRequest(xmlString);

		return result;
	}

	/**
	 * 连接前置机，发送请求报文，获得返回报文
	 * 
	 * @param data
	 * @return
	 */
	public String sendRequest(String data) {

		String result = null;

		InetAddress addr = null;
		Socket socket = null;
		try {
			
			logger.info("招行直付请求:" + data);

			addr = InetAddress.getByName(hostname);
			socket = new Socket(addr, port);

			// 设置2分钟通讯超时时间
			socket.setSoTimeout(120 * 1000);

			DataOutputStream wr = new DataOutputStream(socket.getOutputStream());

			// 通讯头为8位长度，右补空格：先补充8位空格，再取前8位作为报文头
			String strLen = String.valueOf(data.getBytes().length) + "        ";
			wr.write((strLen.substring(0, 8) + data).getBytes());
			wr.flush();
			DataInputStream rd = new DataInputStream(socket.getInputStream());
			// 接收返回报文的长度
			byte rcvLen[] = new byte[8];
			rd.read(rcvLen);
			String sLen = new String(rcvLen);
			int iSum = 0;
			try {
				iSum = Integer.valueOf(sLen.trim());
			} catch (NumberFormatException e) {
				logger.info("报文头格式错误：" + sLen);
			}
			if (iSum > 0) {
				// 接收返回报文的内容
				int nRecv = 0, nOffset = 0;
				byte[] rcvData = new byte[iSum];// data
				while (iSum > 0) {
					nRecv = rd.read(rcvData, nOffset, iSum);
					if (nRecv < 0)
						break;
					nOffset += nRecv;
					iSum -= nRecv;
				}
				result = new String(rcvData);
				logger.info("招行直付返回报文:" + result);
			}
			wr.close();
			rd.close();
		} catch (java.net.SocketTimeoutException e) {
			logger.info("通讯超时：" + e.getMessage());
		} catch (IOException e) {
			logger.info("通讯异常", e);
		} finally {
			if (socket != null) {
				try {
					socket.close();
				} catch (IOException e) {
					logger.info("关闭socket异常!", e);
				}
			}
		}
		return result;
	}

	public String getHostname() {
		return hostname;
	}

	public void setHostname(String hostname) {
		this.hostname = hostname;
	}

	public Integer getPort() {
		return port;
	}

	public void setPort(Integer port) {
		this.port = port;
	}

	public String getLogin_name() {
		return login_name;
	}

	public void setLogin_name(String login_name) {
		this.login_name = login_name;
	}

	public String getBBKNBR() {
		return BBKNBR;
	}

	public void setBBKNBR(String bBKNBR) {
		BBKNBR = bBKNBR;
	}

	public String getACCNBR() {
		return ACCNBR;
	}

	public void setACCNBR(String aCCNBR) {
		ACCNBR = aCCNBR;
	}

	public Long getAVLBLV_fen() {
		return AVLBLV_fen;
	}

	public void setAVLBLV_fen(Long aVLBLV_fen) {
		AVLBLV_fen = aVLBLV_fen;
	}

	public String getSTSCOD() {
		return STSCOD;
	}

	public void setSTSCOD(String sTSCOD) {
		STSCOD = sTSCOD;
	}

	public Long getACCBLV_fen() {
		return ACCBLV_fen;
	}

	public void setACCBLV_fen(Long aCCBLV_fen) {
		ACCBLV_fen = aCCBLV_fen;
	}

	public Long getONLBLV_fen() {
		return ONLBLV_fen;
	}

	public void setONLBLV_fen(Long oNLBLV_fen) {
		ONLBLV_fen = oNLBLV_fen;
	}

	public Long getHLDBLV_fen() {
		return HLDBLV_fen;
	}

	public void setHLDBLV_fen(Long hLDBLV_fen) {
		HLDBLV_fen = hLDBLV_fen;
	}

	public Long getLMTOVR_fen() {
		return LMTOVR_fen;
	}

	public void setLMTOVR_fen(Long lMTOVR_fen) {
		LMTOVR_fen = lMTOVR_fen;
	}
	public Long getLast_update_time() {
		return last_update_time;
	}
	public void setLast_update_time(Long last_update_time) {
		this.last_update_time = last_update_time;
	}
	
	public static final String config_yijifu_partnerCode_key = "yijifu_partnerCode";
	public static final String config_yijifu_secretKey_key = "yijifu_secretKey";
	public static final String config_yijifu_url = "yijifu_url";
	
	/**
	 * 招商银行直接支付
	 */
	public static final Integer pay_method_cmb_pay = 723;
	
	private static CmbBankAccountPay cmbBankAccountPay;
	
	@Override
	public String getPay_method_name() {
		return "招商银行直接支付";
	}
	@Override
	public Integer getPay_method_id() {
		return pay_method_cmb_pay;
	}
	public static final CmbBankAccountPay getInstance() {
		if(cmbBankAccountPay == null) {
			synchronized (CmbBankAccountPay.class) {
				cmbBankAccountPay = new CmbBankAccountPay();
				cmbBankAccountPay.regist_me();
			}
		}
		cmbBankAccountPay.reload_config();
		return cmbBankAccountPay;
	} 
	@Override
	public String createPayData(PaymentRecord paymentRecord, Map<String, Object> parameterMap) {
		return null;
	}
	@Override
	public String pay_success_notify_back(Map parameterMap) throws IOException {
		return null;
	}
	@Override
	public Integer query_paymentRecord_state(PaymentRecord paymentRecord) {
		
		String queryTradeOrder = this.queryTradeOrder(paymentRecord);
		
		Document document_root;
		try {
			document_root = DocumentHelper.parseText(queryTradeOrder);
		
			Element rootElement = document_root.getRootElement();
			
			Element element_NTSTLLSTZ = rootElement.element("NTSTLLSTZ");
			
			Long get_id_time_tmp = paymentRecord.get_id_time_tmp();
			
			//没有查询到订单的 并且已经超过一个小时的 视为失败
			if(element_NTSTLLSTZ == null && System.currentTimeMillis()-get_id_time_tmp > DateUtil.one_hour) {
				paymentRecord.setState(State.STATE_FALSE);
				return State.STATE_FALSE;
			}
			
			String REQSTS = element_NTSTLLSTZ.elementTextTrim("REQSTS");
			
			String RTNFLG = element_NTSTLLSTZ.elementTextTrim("RTNFLG");

			logger.error("查询订单状态: 招行支付 订单编号:"+paymentRecord.getId()+" "+queryTradeOrder);
			
			if(REQSTS_FIN.equals(REQSTS) && RTNFLG_S.equals(RTNFLG)) {
				
				Map<String,Object> request_map = new HashMap<String,Object>();
				
				Long pay_total_fee_fen = paymentRecord.getShowPrice_fen_all();
				request_map.put(PayFinalVariable.third_pay_total_fee_key, pay_total_fee_fen);
					
				this.pay_success_notify_back_common(paymentRecord,request_map);
				
				return State.STATE_PAY_SUCCESS;
			}else if(RTNFLG_F.equals(RTNFLG)) {
				paymentRecord.setState(State.STATE_FALSE);
				return State.STATE_FALSE;
			}
		
		} catch (Exception e) {
			logger.error("状态查询失败", e);
		}
		
		return paymentRecord.getState();
	}
	
}
