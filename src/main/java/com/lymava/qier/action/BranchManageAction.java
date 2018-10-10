package com.lymava.qier.action;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.lymava.base.action.BaseAction;
import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.pay.PayFinalVariable;
import com.lymava.commons.state.State;
import com.lymava.commons.state.StatusCode;
import com.lymava.commons.util.*;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.qier.action.manager.OrderReportContent;
import com.lymava.qier.action.manager.OrderReportEntry;
import com.lymava.qier.business.BusinessIntIdConfigQier;
import com.lymava.qier.business.businessRecord.MerchantRedEnvelopePayRecord;
import com.lymava.qier.model.*;
import com.lymava.qier.util.SunmingUtil;
import com.lymava.trade.base.model.BusinessIntIdConfig;
import com.lymava.trade.business.model.TradeRecord;
import com.lymava.trade.util.WebConfigContentTrade;
import com.lymava.userfront.util.FrontUtil;
import jxl.write.WritableSheet;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.*;


/**
 *  分店管理Action
 */
public class BranchManageAction extends BaseAction {

    /**
	 *
	 */
	private static final long serialVersionUID = 5441400094573189474L;


    /**
     * 检查登录
     * @return
     */
    public Merchant72 check_login_user() {
        User init_http_user = FrontUtil.init_http_user(request);
        CheckException.checkIsTure(init_http_user != null, "请先登录!", StatusCode.USER_INFO_TIMEOUT);
        Merchant72 merchant72 = (Merchant72) init_http_user;
        return merchant72;
    }
    
    private List<String> getFendian_MerchantId_list(User user_merchant){
    	  //分店merchantId
        String[] subMerchantIds = this.getParameterValues("subMerchantId");

        //分店的搜索条件
        List<String> fendian_MerchantId_list = new LinkedList<String>();
        
        //解析客户端上传上来的分店编号
        if(subMerchantIds != null) {
        	for (String subMerchantId_tmp : subMerchantIds) {
            	if(MyUtil.isValid(subMerchantId_tmp)) {
            		fendian_MerchantId_list.add(subMerchantId_tmp);
            	}
    		}
        }
        //如果没传id进来 查询所有下架
        if(fendian_MerchantId_list.size() <= 0) {
        	
        	Merchant72 merchant72_find  = new Merchant72();
        	
            merchant72_find.setTopUserId(user_merchant.getId());
            merchant72_find.setUserGroupId(WebConfigContentTrade.getInstance().getMerchantUserGroupId());

            List<Merchant72> merchant72_branch_list = serializContext.findAll(merchant72_find);
            
            for (Merchant72 merchant722 : merchant72_branch_list) {
            	fendian_MerchantId_list.add(merchant722.getId());
			}
        }
        return fendian_MerchantId_list;
    }

    /**
     *  报表数据方法  获取前台传过来的范围scope  根据范围设置开始时间  今天 七天 十五天
     * @return
     */
    public String selDataQuick() {

        Merchant72 user =this.check_login_user();
        Integer selHhour = user.getQueryHour();
        selHhour = selHhour==null?6:selHhour;  //  获取商家设置的结账小时节点

        //↓  今天结束的时间+商家设置的时间节点  这个时间应该是所有报表数据的结束时间
        Long stop_todayTime = DateUtil.getDayStartTime()+DateUtil.one_day+selHhour*DateUtil.one_hour;

        Long start_Time = stop_todayTime - DateUtil.one_day;  // 开始时间  结束时间减一天的时间
        Long jiege = DateUtil.one_hour*4;  // 间隔时间 默认4个小时

        // 根据前台传进来的范围  设置开始时间和间隔时间
        String scope = request.getParameter("scope");


        if("today".equals(scope)){
            // 今日报表  开始时间和间隔时间 可以直接使用默认
        }
        if("week".equals(scope)){
            // 七日报表  开始时间和间隔时间 可以直接使用默认
            start_Time = start_Time - DateUtil.one_day*7;
            jiege = DateUtil.one_day;
        }
        if("month".equals(scope)){
            // 十五日报表  开始时间和间隔时间 可以直接使用默认
            start_Time = start_Time - DateUtil.one_day*15;
            jiege = DateUtil.one_day;
        }

        // 下载exce文件的时候要用
        request.getSession().setAttribute("start_todayTime",start_Time);
        request.getSession().setAttribute("stop_todayTime",stop_todayTime);

        //分店的搜索条件
        List<String> fendian_MerchantId_list = this.getFendian_MerchantId_list(user);
         
        List<OrderReportEntry> datas = OrderReportContent.create_orderReport(start_Time,stop_todayTime,jiege, fendian_MerchantId_list);

        // 将得到数据转换成json数据
        JsonArray jsonArray =  JsonUtil.convert_to_jsonArray(datas);
        // 得到显示时间的字符串
        String showTime = new OrderReportContent().getShowTime(start_Time,stop_todayTime,jiege);


        // 返回数据
        request.getSession().setAttribute("listForOrderReportEntry",datas);
        request.setAttribute("datas",jsonArray);
        request.setAttribute("showTime",showTime);
        this.setSuccessResultValue("/merchant/business_page/transaction_settlement/orderDataView.jsp");
        return SUCCESS;
    }


    /**
     * 得到收益数据  根据时间,得到时间段内的收益数据.
     * @return
     */
    public String getCollectDataByTime(){
        // 检查登录
        Merchant72 merchant72 = check_login_user();

        // 得到开始时间和结束时间  和  数据验证
        String selStartDate_str = this.getParameter("selStartDate");
        String selStopDate_str = this.getParameter("selStopDate");

        SimpleDateFormat sdf_ymdh =new SimpleDateFormat("yyyy-MM-dd HH");

        // 设置查询的开始时间和结束时间  默认是今天凌晨00:00:00 到 明天凌晨00:00:00
        Long end_time = DateUtil.getDayStartTime()+DateUtil.one_day;
        Long start_time = end_time - 2*DateUtil.one_day;

        if (merchant72.getQueryHour() != null){
            start_time += merchant72.getQueryHour()*DateUtil.one_hour;
            end_time += merchant72.getQueryHour()*DateUtil.one_hour;
        }

        // 传入了日期  得到这个日期的时间戳  & 检查
        try {
				Date selStartDate = sdf_ymdh.parse(selStartDate_str);
				start_time = selStartDate.getTime();
		} catch (Exception e) {
		}

        try {
				Date selStopDate = sdf_ymdh.parse(selStopDate_str);
				end_time = selStopDate.getTime();
		} catch (Exception e) {
		}

        CheckException.checkIsTure(start_time < end_time,"开始时间不能大于结束时间!");

        CheckException.checkIsTure(((end_time-start_time)<=DateUtil.one_day*31),"开始时间到结束时间不能超过31天 ");
        //分店的搜索条件
        List<String> fendian_MerchantId_list = this.getFendian_MerchantId_list(merchant72);
        
        // 得到所有订单
        TradeRecord72 tradeRecord72_find = new TradeRecord72();
        //业务订单
        tradeRecord72_find.setBusinessIntId(BusinessIntIdConfig.businessIntId_trade);
        
        for(String merchant_fengDian_id : fendian_MerchantId_list) {
        	tradeRecord72_find.addCommand(MongoCommand.in,"userId_merchant",merchant_fengDian_id);
    	}
        //如果没有分店 那么乱设一个数据
        if(fendian_MerchantId_list.size()<=0) {
        	tradeRecord72_find.setId(merchant72.getId());
        }


        tradeRecord72_find.addCommand(MongoCommand.in, "state", State.STATE_PAY_SUCCESS);// 付款成功
        tradeRecord72_find.addCommand(MongoCommand.in, "state", State.STATE_REFUND_OK);// 退款成功
        
        tradeRecord72_find = (TradeRecord72)SunmingUtil.setQueryWhere_time(tradeRecord72_find,start_time,end_time);

        // 得到时间段的所有数据
        Iterator<TradeRecord72> tradeRecord72_ite = serializContext.findIterable(tradeRecord72_find);

        Long price_fen_all = 0L;   // 总收益   单位分
        Integer order_size = 0;  // 收款笔数
        Long red_pay_fen = 0L;      // 红包消费 单位分  (全额使用红包支付的统计)
        Integer red_pay_size = 0;   // 红包消费笔数     (全额使用红包支付的统计)

        Long price_fen_alipay = 0L;           // 支付宝支付
        Integer price_fen_alipay_size = 0;    // 支付宝支付笔数
        Long price_fen_wechat = 0L;           // 微信支付
        Integer price_fen_wechat_size = 0;    // 微信支付笔数

        Long price_fen_yorz = 0L;             // 红包消费  悠择用户  (订单中包含了红包支付的统计)
        Long price_fen_yorz_size = 0L;        // 红包消费总笔数  悠择用户  (订单中包含了红包支付的统计)

        Long had_refund_amout_fen = 0L;        // 退款总金额


        while(tradeRecord72_ite.hasNext()) {
        	TradeRecord72 tradeRecord72_out = tradeRecord72_ite.next();
        	
        	order_size++;

        	Long thirdPayPrice_fen_all = tradeRecord72_out.getThirdPayPrice_fen_all();

        	Long wallet_amount_payment_fen = tradeRecord72_out.getWallet_amount_payment_fen();

            Long order_price = Math.abs(tradeRecord72_out.getShowPrice_fen_all());
            price_fen_all += order_price;

            had_refund_amout_fen += tradeRecord72_out.getHad_refund_amout_fen();

            // 悠择用户: 使用了红包支付的订单
            Long walletPay =  tradeRecord72_out.getWallet_amount_payment_fen();
            if(walletPay != null){
                price_fen_yorz += walletPay;
                price_fen_yorz_size++;
            }

            if(wallet_amount_payment_fen != null && wallet_amount_payment_fen > 0) {
            	 red_pay_fen += wallet_amount_payment_fen;
                 red_pay_size += 1;
            }
            // 余额支付(钱包支付)
//            if (PayFinalVariable.pay_method_balance.equals(tradeRecord72_out.getPay_method())) {
//                red_pay_fen += order_price;
//                red_pay_size += 1;
//            }

            // 支付宝支付
            if (PayFinalVariable.pay_method_alipay.equals(tradeRecord72_out.getPay_method())) {
                price_fen_alipay += thirdPayPrice_fen_all;
                price_fen_alipay_size += 1;
            }
            // 微信支付
            if (PayFinalVariable.pay_method_weipay.equals(tradeRecord72_out.getPay_method())) {
                price_fen_wechat += thirdPayPrice_fen_all;
                price_fen_wechat_size += 1;
            }

        }

        // 设置返回数据
        JsonObject jsonObject = new JsonObject();

        jsonObject.addProperty("start_date",SunmingUtil.longDateToStrDate_tall(start_time));  // 开始时间  用于展示
        jsonObject.addProperty("end_date",SunmingUtil.longDateToStrDate_tall(end_time));   // 结束时间  用于展示

        jsonObject.addProperty("price_fen_all",price_fen_all);
        jsonObject.addProperty("order_size",order_size);

        jsonObject.addProperty("red_pay_fen",red_pay_fen);
        jsonObject.addProperty("red_pay_size",red_pay_size);

        jsonObject.addProperty("price_fen_alipay",price_fen_alipay);
        jsonObject.addProperty("price_fen_alipay_size",price_fen_alipay_size);

        jsonObject.addProperty("price_fen_wechat",price_fen_wechat);
        jsonObject.addProperty("price_fen_wechat_size",price_fen_wechat_size);

        jsonObject.addProperty("price_fen_yorz",price_fen_yorz);
        jsonObject.addProperty("price_fen_yorz_size",price_fen_yorz_size);

        jsonObject.addProperty("had_refund_amout_fen",had_refund_amout_fen);

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已返回查询时间段的收益数据");
        this.setDataRoot(jsonObject);
        return SUCCESS;
    }

    /**
     * 下载excel报表文件
     * @return
     */
    public String excelFileDownload(){

        // 检查登录
        Merchant72 merchant72 = this.check_login_user();
        String username = merchant72.getUsername(); // 商家电话
        String path = request.getRealPath("/excelFileDownload")+"/"+username+".xlsx";

        SimpleDateFormat sdf_ymdh =new SimpleDateFormat("yyyy-MM-dd HH");

        // 获取起止时间 (从session中去取时间参数, 说明现在是'快速'的请求(今日,七日,十五日))
        Long start_time = (Long) request.getSession().getAttribute("start_todayTime");
        Long end_time = (Long) request.getSession().getAttribute("stop_todayTime");

        // precise精确查询的下载入口  输入了起止时间 点击的下载
        String precise = request.getParameter("precise");
        if(State.STATE_OK.toString().equals(precise)){
            // 得到开始时间和结束时间  和  数据验证
            String selStartDate_str = request.getParameter("selStartDate");
            String selStopDate_str = request.getParameter("selStopDate");

            // 传入了日期  得到这个日期的时间戳  & 检查
            try {
                Date selStartDate = sdf_ymdh.parse(selStartDate_str);
                start_time = selStartDate.getTime();
            } catch (Exception e) {
            }
            CheckException.checkIsTure(start_time != null,"开始时间错误");

            try {
                Date selStopDate = sdf_ymdh.parse(selStopDate_str);
                end_time = selStopDate.getTime();
            } catch (Exception e) {
            }
            CheckException.checkIsTure(end_time != null,"结束时间错误");

            CheckException.checkIsTure(start_time<end_time,"开始时间大于了结束时间! ");
        }
        CheckException.checkIsTure(((end_time-start_time)<=DateUtil.one_day*31),"开始时间到结束时间不能超过31天 ");

        
        //分店的搜索条件
        List<String> fendian_MerchantId_list = this.getFendian_MerchantId_list(merchant72);
        
        // 得到所有订单
        TradeRecord72 tradeRecord72_find = new TradeRecord72();
        //业务订单
        tradeRecord72_find.setBusinessIntId(BusinessIntIdConfig.businessIntId_trade);
        //设置查询条件
        for(String merchant_fengDian_id : fendian_MerchantId_list) {
        	tradeRecord72_find.addCommand(MongoCommand.in,"userId_merchant",merchant_fengDian_id);
    	}
        //如果没有分店 那么乱设一个数据
        if(fendian_MerchantId_list.size()<=0) {
        	tradeRecord72_find.setId(merchant72.getId());
        }

        tradeRecord72_find.addCommand(MongoCommand.in, "state", State.STATE_PAY_SUCCESS);// 付款成功
        tradeRecord72_find.addCommand(MongoCommand.in, "state", State.STATE_REFUND_OK);// 退款成功
        
        tradeRecord72_find = (TradeRecord72)SunmingUtil.setQueryWhere_time(tradeRecord72_find,start_time,end_time);

        // 得到时间段的所有数据
        Iterator<TradeRecord72> tradeRecord72_ite = serializContext.findIterable(tradeRecord72_find);

        // 下载
        JExcelUtils jExcelUtils = new JExcelUtils();
        String[] time_str = {SunmingUtil.longDateToStrDate_tall(start_time)+"\n---至---\n"+SunmingUtil.longDateToStrDate_tall(end_time)};
        String[] titles = {"序号", "商品名称", "总价", "付款时间", "状态", "付款方式", "余额剩余", "备注",};
        try {
            jExcelUtils.createExcelFile(new File(path));
            WritableSheet createSheet = jExcelUtils.createSheet(0, "导出数据", time_str);

            // row_now = 0  起止时间显示
            Integer row_now = 0;
            jExcelUtils.insertRowData(createSheet,row_now,time_str);

            // row_now = 1 空一行
            ++row_now;
            jExcelUtils.insertRowData(createSheet,row_now,new String[]{""});

            // row_now = 2 显示订单信息的头部
            ++row_now;
            jExcelUtils.insertRowData(createSheet,row_now,titles);

//            // row_now = 3 空一行
//            ++row_now;
//            jExcelUtils.insertRowData(createSheet,row_now,new String[]{""});

            Long price_fen_all = 0L;
            // 数据主体 (订单信息)
            int index = 0;
            while(tradeRecord72_ite.hasNext()) {
            	
            	  TradeRecord72 tradeRecord72_next = tradeRecord72_ite.next();
            	
            	  price_fen_all += tradeRecord72_next.getPayPrice_fen_all();
                  Object[] row_data = {
                          (index+1)+"",
                          tradeRecord72_next.getProduct().getName(),
                          String.valueOf(((float) tradeRecord72_next.getPayPrice_fen_all())/100),
                          tradeRecord72_next.getShowPayTime(),
                          tradeRecord72_next.getShowState(),
                          tradeRecord72_next.getShowPayInfo(),
                          tradeRecord72_next.getShowMerchant_balance(),
                          tradeRecord72_next.getMemo()
                  };
                  ++row_now;
                  jExcelUtils.insertRowData(createSheet,row_now,row_data);
            	
            	index ++;
            }
             

            ++row_now;
            jExcelUtils.insertRowData(createSheet,row_now,new String[]{""});

            ++row_now;
            jExcelUtils.insertRowData(createSheet,row_now,new String[]{"", "总收益(付款成功):",String.valueOf(((float)price_fen_all)/100)});

            jExcelUtils.close();

        } catch (Exception e) {
            e.printStackTrace();  // 下载excel出现了异常
            this.setStatusCode(StatusCode.ACCEPT_FALSE);
            this.setMessage("出错了...");
            return SUCCESS;
        }
        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("userPhone",username);

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("");
        this.setDataRoot(jsonObject);
        return  SUCCESS;
    }


    /**
     * 编辑备注信息
     * @return
     */
    public String updateMemo(){
        String newMemo = request.getParameter("newMemo");
        String id = request.getParameter("id");
        CheckException.checkIsTure(id!=null,"订单信息不正确");

        TradeRecord updateTradeRecord = new TradeRecord();
        updateTradeRecord.setMemo(newMemo);

        ContextUtil.getSerializContext().updateObject(id,updateTradeRecord);

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("修改成功");
        return SUCCESS;
    }

    /**
     *  加载对应商家的订单数据
     * @return
     */
    public String loadMerchartOrder(){
        this.setSuccessResultValue("/merchant/business_page/BranchManage/businessRecord_list_data.jsp");

        // 检查登录
        Merchant72 merchant72 = check_login_user();

        SimpleDateFormat sdf_ymdh =new SimpleDateFormat("yyyy-MM-dd HH");

        // 得到开始时间和结束时间  和  数据验证 和 指定分店merchantId
        String selStartDate_str = request.getParameter("selStartDate");
        String selStopDate_str = request.getParameter("selStopDate");
        String payState = request.getParameter("payState");

        //是否是点击的插叙
        Object click_query = request.getParameter("click_query");
        if (click_query != null) {
            pageSplit.setPage(1);
        }

        //分店merchantId
        String[] subMerchantIds = request.getParameterValues("subMerchantId");

        // 设置查询的开始时间和结束时间  默认是今天凌晨00:00:00 到 明天凌晨00:00:00
        Long start_time = null;
        Long end_time = null;

        // 传入了日期  得到这个日期的时间戳  & 检查
        try {
            Date selStartDate = sdf_ymdh.parse(selStartDate_str);
            start_time = selStartDate.getTime();

        } catch (Exception e) {
		}
        try {
			Date selStopDate = sdf_ymdh.parse(selStopDate_str);
			end_time = selStopDate.getTime();

		} catch (Exception e) {
		}

        // 两个时间之间相差了三十天
        if(end_time != null &&  start_time != null &&   ((end_time-start_time)>DateUtil.one_day*31)){
        	return SUCCESS;
        }

        pageSplit.setPageSize(10);

        TradeRecord72 tradeRecord72_find = new TradeRecord72();
        tradeRecord72_find.setBusinessIntId(BusinessIntIdConfig.businessIntId_trade);

        //分店的搜索条件
        List<String> fendian_MerchantId_list = new LinkedList<String>();
        
        //解析客户端上传上来的分店编号
        if(subMerchantIds != null) {
        	for (String subMerchantId_tmp : subMerchantIds) {
            	if(MyUtil.isValid(subMerchantId_tmp)) {
            		fendian_MerchantId_list.add(subMerchantId_tmp);
            	}
    		}
        }
        //如果没传id进来 查询所有下架
        if(fendian_MerchantId_list.size() <= 0) {
        	
        	Merchant72 merchant72_find  = new Merchant72();
        	
            merchant72_find.setTopUserId(merchant72.getId());
            merchant72_find.setUserGroupId(WebConfigContentTrade.getInstance().getMerchantUserGroupId());

            List<Merchant72> merchant72_branch_list = serializContext.findAll(merchant72_find);
            
            for (Merchant72 merchant722 : merchant72_branch_list) {
            	fendian_MerchantId_list.add(merchant722.getId());
			}
        }
        
        for(String merchant_fengDian_id : fendian_MerchantId_list) {
        	tradeRecord72_find.addCommand(MongoCommand.in,"userId_merchant",merchant_fengDian_id);
    	}
        //如果没有分店 那么乱设一个数据
        if(fendian_MerchantId_list.size()<=0) {
        	tradeRecord72_find.setId(merchant72.getId());
        }


        if (!SunmingUtil.strIsNull(payState) && MathUtil.parseIntegerNull(payState) != null ){
            tradeRecord72_find.setState(MathUtil.parseIntegerNull(payState));
        }
        tradeRecord72_find = (TradeRecord72)SunmingUtil.setQueryWhere_time(tradeRecord72_find,start_time,end_time);
        
        List<TradeRecord72> object_ite = serializContext.findAll(tradeRecord72_find, pageSplit);

        request.setAttribute("object_ite", object_ite);
        request.setAttribute("pageSplit", pageSplit);
        return SUCCESS;
    }
    
    /**
   	 * 根据时间段  查询红包的情况       技术部小冉
   	 * */
   	public String getCollectDataByTimeRedPackage(){
   		
   		User user = check_login_user();
   		 //得到开始时间和结束时间  和  数据验证
           String selStartDate_str = request.getParameter("selStartDate");
           String selStopDate_str = request.getParameter("selStopDate");
           SimpleDateFormat sdf_ymdh =new SimpleDateFormat("yyyy-MM-dd HH");
           // 设置查询的开始时间和结束时间  默认是今天凌晨00:00:00 到 明天凌晨00:00:00
           Long end_time = DateUtil.getDayStartTime()+DateUtil.one_day;
           Long start_time = end_time - 2*DateUtil.one_day;
           // 传入了日期  得到这个日期的时间戳  & 检查
           try {
   				Date selStartDate = sdf_ymdh.parse(selStartDate_str);
   				start_time = selStartDate.getTime();
   				Date selStopDate = sdf_ymdh.parse(selStopDate_str);
   				end_time = selStopDate.getTime();
   		} catch (Exception e) { 
   		}
           Long   red_package_priceALL=0L;  //红包总额
           Integer red_package_size=0;     //红包总个数
           
           Long   red_package_priceFaALL=0L;  //红包已发放总额
           Integer red_packageFA_size=0;     //红包已发放总个数
           
           Long   red_packageNo_priceALL=0L;  //红包未领取总额
           Integer red_packageNo_size=0;     //红包未领取总个数
           
           Long  red_packageUse_priceALL=0L;//已使用红包总额
           Integer red_packageUse_size=0;   //已使用红包个数
           
           Long red_packageOverdue_priceAll=0L;//过期红包总额
           Integer red_packageOverdue_size=0;//过期红包个数 
           
           CheckException.checkIsTure(start_time < end_time,"开始时间不能大于结束时间!");
           
           CheckException.checkIsTure(((end_time-start_time)<=DateUtil.one_day*31),"开始时间到结束时间不能超过31天 ");
           
          MerchantRedEnvelopePayRecord merchantRedEnvelopePayRecord_find = new MerchantRedEnvelopePayRecord();
       	
           merchantRedEnvelopePayRecord_find.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_dingxiang);
           merchantRedEnvelopePayRecord_find.setUserId_merchant(user.getId());
           
           SunmingUtil.setQueryWhere_time(merchantRedEnvelopePayRecord_find, start_time, end_time);
           
           //查询时间段 内  的所有数据
           Iterator<MerchantRedEnvelopePayRecord> merchantRedEnvelope_ite= serializContext.findIterable(merchantRedEnvelopePayRecord_find);
           
           while(merchantRedEnvelope_ite.hasNext()) {
        	   
        	 MerchantRedEnvelopePayRecord merchantRedEnvelopePayRecord_tmp = merchantRedEnvelope_ite.next();
        	   
        	 MerchantRedEnvelope merchantRedEnvelopes_out = merchantRedEnvelopePayRecord_tmp.getMerchantRedEnvelope();
        	 if(merchantRedEnvelopes_out == null) {
        		 continue;
        	 }
        	   
           	 merchantRedEnvelopes_out.getAmount();//红包 总额
           	 Long order_price = Math.abs(merchantRedEnvelopes_out.getAmount()/1000000);
           	 red_package_priceALL += order_price;
           	 red_package_size++;
           	 //已发放 红包 
           	 if(State.STATE_OK.equals(merchantRedEnvelopes_out.getState())
           		|| State.STATE_WAITE_WAITSENDGOODS.equals(merchantRedEnvelopes_out.getState())
           		|| State.STATE_ORDER_NOT_EXIST.equals(merchantRedEnvelopes_out.getState())
           		){
           		Long order_price1 = Math.abs(merchantRedEnvelopes_out.getAmount()/1000000);
             	red_package_priceFaALL+=order_price1;
             	red_packageFA_size++;
           	 }
           	 //未领取的红包 
           	 else if(State.STATE_WAITE_CHANGE.equals(merchantRedEnvelopes_out.getState())){
           		Long order_price_Unreceived = Math.abs(merchantRedEnvelopes_out.getAmount()/1000000);
               	red_packageNo_priceALL+=order_price_Unreceived;
               	red_packageNo_size++;
           	 }
           //已使用的红包 
           	 else if(State.STATE_FALSE.equals(merchantRedEnvelopes_out.getState())){
           		Long order_price_use = Math.abs(merchantRedEnvelopes_out.getAmount()/1000000);
               	red_packageUse_priceALL+=order_price_use;
               	red_packageUse_size++;
           	 }
             //过期的红包 
             else if(State.STATE_CLOSED.equals(merchantRedEnvelopes_out.getState())){
          	   Long order_price_overdue = Math.abs(merchantRedEnvelopes_out.getAmount()/1000000);
                	red_packageOverdue_priceAll+=order_price_overdue;
                	red_packageOverdue_size++;
             }
           }
           // 设置返回数据
           JsonObject jsonObject = new JsonObject();
           
           jsonObject.addProperty("start_date",SunmingUtil.longDateToStrDate_tall(start_time));  // 开始时间  用于展示
           jsonObject.addProperty("end_date",SunmingUtil.longDateToStrDate_tall(end_time));   // 结束时间  用于展示

           jsonObject.addProperty("red_package_priceALL",red_package_priceALL);
           jsonObject.addProperty("red_package_size",red_package_size);

           jsonObject.addProperty("red_package_priceFaALL",red_package_priceFaALL);
           jsonObject.addProperty("red_packageFA_size",red_packageFA_size);

           jsonObject.addProperty("red_packageNo_priceALL",red_packageNo_priceALL);
           jsonObject.addProperty("red_packageNo_size",red_packageNo_size);
           
           jsonObject.addProperty("red_packageUse_priceALL",red_packageUse_priceALL);
           jsonObject.addProperty("red_packageUse_size",red_packageUse_size);
           
           jsonObject.addProperty("red_packageOverdue_priceAll",red_packageOverdue_priceAll);
           jsonObject.addProperty("red_packageOverdue_size",red_packageOverdue_size);
           
           this.setStatusCode(StatusCode.ACCEPT_OK);
           this.setMessage("已返回查询时间段的红包数据");
           this.setDataRoot(jsonObject);
   		return SUCCESS;
   	}
       
    
}
