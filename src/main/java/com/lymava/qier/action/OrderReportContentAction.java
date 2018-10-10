package com.lymava.qier.action;
import static java.lang.System.currentTimeMillis;

import java.io.File;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import com.lymava.qier.action.manager.OrderReportContent;
import com.lymava.qier.action.manager.OrderReportEntry;
import org.bson.types.ObjectId;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.lymava.base.action.BaseAction;
import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.pay.PayFinalVariable;
import com.lymava.commons.state.State;
import com.lymava.commons.state.StatusCode;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.JExcelUtils;
import com.lymava.commons.util.JsonUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.nosql.util.PageSplit;
import com.lymava.qier.business.BusinessIntIdConfigQier;
import com.lymava.qier.business.businessRecord.MerchantRedEnvelopePayRecord;
import com.lymava.qier.model.Merchant72;
import com.lymava.qier.model.MerchantRedEnvelope;
import com.lymava.qier.model.OrderEntity;
import com.lymava.qier.model.TradeRecord72;
import com.lymava.qier.model.UserVoucher;
import com.lymava.qier.model.Voucher;
import com.lymava.qier.model.VoucherEntity;
import com.lymava.qier.util.SunmingUtil;
import com.lymava.trade.base.model.BusinessIntIdConfig;
import com.lymava.trade.business.model.TradeRecord;
import com.lymava.userfront.util.FrontUtil;

import jxl.write.WritableSheet;


/**
 *  孙M  这个action主要是用于商家端订单信息那一页的数据展示
 *      孙M  6.4  修改订单展示处理  采用ajax  修改报表查询的action(统一使用一个)
 */
public class OrderReportContentAction extends BaseAction {

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


    /**
     * 设置用户每天的对账时间查询的截止时间(小时)   右上角的设置对账时间
     * @return
     */
    public String setJiangeHour(){

        String setSelHour = request.getParameter("selHour");
        Integer SelHour = MathUtil.parseInteger(setSelHour);

        User user = check_login_user();

        Merchant72 merchant72 = new Merchant72();
        merchant72.setQueryHour(SelHour);

        ContextUtil.getSerializContext().updateObject(user.getId(),merchant72);

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("设置成功");
        return SUCCESS;
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

        // 得到报表数据
        List<String> user_id_list = Arrays.asList(user.getId());
        List<OrderReportEntry> datas = OrderReportContent.create_orderReport(start_Time,stop_todayTime,jiege, user_id_list);

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
        String selStartDate_str = request.getParameter("selStartDate");
        String selStopDate_str = request.getParameter("selStopDate");
        SimpleDateFormat sdf_ymdh =new SimpleDateFormat("yyyy-MM-dd HH:mm");
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
            Date selStopDate = sdf_ymdh.parse(selStopDate_str);
            end_time = selStopDate.getTime();
		} catch (Exception e) { }
        CheckException.checkIsTure(start_time < end_time,"开始时间不能大于结束时间!");
        CheckException.checkIsTure(((end_time-start_time)<=DateUtil.one_day*31),"开始时间到结束时间不能超过31天 ");


        Long merchant_price_fen_yorz = 0L;       // 商家的定向红包
        Long merchant_price_fen_yorz_size = 0L;    // 商家的定向红包总笔数

        // 得到所有订单
        TradeRecord72 tradeRecord72 = new TradeRecord72();
        tradeRecord72.setUserId_merchant(merchant72.getId());
        tradeRecord72 = (TradeRecord72)SunmingUtil.setQueryWhere_time(tradeRecord72,start_time,end_time);
        tradeRecord72.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_dingxiang); // 定向红包消费充值  31103
        tradeRecord72.setState(State.STATE_OK); // 交易成功

        Iterator<TradeRecord72> tradeRecord72Iterator  = serializContext.findIterable(tradeRecord72);
        while (tradeRecord72Iterator.hasNext()){
            TradeRecord72 tradeRecord72_tmp = tradeRecord72Iterator.next();

            Long showPrice_fen_all = tradeRecord72_tmp.getShowPrice_fen_all();
            if(showPrice_fen_all != null){
                merchant_price_fen_yorz += showPrice_fen_all;
                merchant_price_fen_yorz_size++;
            }
        }


        tradeRecord72.setState(null);
        tradeRecord72.setBusinessIntId(BusinessIntIdConfig.businessIntId_trade);
        tradeRecord72.addCommand(MongoCommand.in, "state", State.STATE_PAY_SUCCESS);// 付款成功
        tradeRecord72.addCommand(MongoCommand.in, "state", State.STATE_REFUND_OK);// 退款成功

        // 得到时间段的所有数据
        Iterator<TradeRecord72> tradeRecord72_ite = serializContext.findIterable(tradeRecord72);

        Long price_fen_all = 0L;   // 总收益   单位分
        Integer order_size = 0  ;  // 收款笔数
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
        	order_size ++;
        	TradeRecord72 tradeRecord72_out  = tradeRecord72_ite.next();
        	
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

        Long terrace_price_fen_yorz = 0L;           // 平台通用红包
        Long terrace_price_fen_yorz_size = 0L;    // 平台通用红包总笔数
        terrace_price_fen_yorz = price_fen_yorz-merchant_price_fen_yorz; // 平台的红包 等于 总的红包 减去 定向红白
        terrace_price_fen_yorz_size = price_fen_yorz_size;  // 平台通用红包总笔数 现在直接等于红包使用数量


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

        jsonObject.addProperty("merchant_price_fen_yorz",merchant_price_fen_yorz);
        jsonObject.addProperty("merchant_price_fen_yorz_size",merchant_price_fen_yorz_size);
        jsonObject.addProperty("terrace_price_fen_yorz",terrace_price_fen_yorz);
        jsonObject.addProperty("terrace_price_fen_yorz_size",terrace_price_fen_yorz_size);
 
        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已返回查询时间段的收益数据");
        this.setDataRoot(jsonObject);
        return SUCCESS;
    }


    /**
     * 通过时间查询的的报表数据   // todo   这个action 可以不要了
     * @return
     */                                                                             
    public String selByTime() {
        Merchant72 user =this.check_login_user();

        // 得到开始时间和结束时间  和  数据验证
        String selStartDate = request.getParameter("selStartDate");
        String selStopDate = request.getParameter("selStopDate");
        String selStartTime = request.getParameter("selStartTime");
        String selStopTime = request.getParameter("selStopTime");
        CheckException.checkIsTure(selStartDate!=null,"开始日期不能为空!");
        CheckException.checkIsTure(selStartTime!=null,"开始时间不能为空!");
        CheckException.checkIsTure(selStopDate!=null,"结束日期不能为空!");
        CheckException.checkIsTure(selStopTime!=null,"结束时间不能为空!");
        //  得到小时
        Long hhStartLong = MathUtil.parseLong(selStartTime);
        Long hhStopLong = MathUtil.parseLong(selStopTime);
        // 错误数据矫正
        if(hhStartLong<1L || hhStartLong>24L){ hhStartLong = 6L; }
        if(hhStopLong<1L || hhStopLong>24L){ hhStopLong = 6L; }
        //得到小时的时间戳
        hhStartLong = hhStartLong*DateUtil.one_hour;
        hhStopLong = hhStopLong*DateUtil.one_hour;

        // 将日期 转化为时间戳
        Date startDate = null;
        Date stopDate = null;
        try {
            startDate = DateUtil.getSdfShort().parse(selStartDate);
            stopDate = DateUtil.getSdfShort().parse(selStopDate);
        } catch (ParseException e) {
            e.printStackTrace();
        }


        // 开始和结束日期的时间戳 加上 开始和结束时间的时间戳 间隔的时间戳
        Long startDateLong = startDate.getTime()+hhStartLong;
        Long stopDateLong = stopDate.getTime()+hhStopLong;

//        Long jiege = DateUtil.one_day;
        Long jiege =(stopDateLong-startDateLong)/12;

        // 下载excel文件的时候要用
        request.getSession().setAttribute("start_todayTime",startDateLong);
        request.getSession().setAttribute("stop_todayTime",stopDateLong);

//            // 设置开始时间为早上的5点
//        startDateLong = startDateLong+5*DateUtil.one_hour;
//        stopDateLong = stopDateLong+5*DateUtil.one_hour+DateUtil.one_day;
//
        // 得到报表数据
        List<OrderReportEntry> datas = null;
        OrderReportContent orderReportContent = new OrderReportContent();
        datas = orderReportContent.create_orderReport(startDateLong,stopDateLong,jiege,Arrays.asList(user.getId()));

        JsonArray jsonArray =  JsonUtil.convert_to_jsonArray(datas);

        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("MM-dd:hh");
        // 报表插件横坐标(X)显示的值
        String showTime = "";

        for (;;) {

            // 当开始时间大于等于了结束时间 终止循环
            if (startDateLong >= stopDateLong) {
                break;
            }
            Date date= new Date(startDateLong);
            showTime += simpleDateFormat.format(date)+"点,";
            startDateLong = startDateLong + jiege;
        }

        request.getSession().setAttribute("listForOrderReportEntry",datas);
        request.setAttribute("datas",jsonArray);
        request.setAttribute("showTime",showTime);
        this.setSuccessResultValue("/merchant/business_page/transaction_settlement/orderDataView.jsp");
        return SUCCESS;
    }





    /**
     * 下载excel报表文件
     * @return
     */
    public String excelFileDownload(){

        // 检查登录
        Merchant72 user =this.check_login_user();
        String username = user.getUsername(); // 商家电话
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



        //设置查询条件
        TradeRecord72 tradeRecord_find = new TradeRecord72();
        //业务订单
        tradeRecord_find.setBusinessIntId(BusinessIntIdConfig.businessIntId_trade);
        
        tradeRecord_find.setUser_merchant(user);
        
        tradeRecord_find.addCommand(MongoCommand.in, "state", State.STATE_PAY_SUCCESS);// 付款成功
        tradeRecord_find.addCommand(MongoCommand.in, "state", State.STATE_REFUND_OK);// 退款成功
        
        tradeRecord_find = (TradeRecord72) SunmingUtil.setQueryWhere_time(tradeRecord_find,start_time,end_time);

        // 得到时间段的所有数据
        Iterator<TradeRecord72> tradeRecord72_ite = serializContext.findIterable(tradeRecord_find);


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
        this.setSuccessResultValue("/merchant/business_page/BusinessRecord/TradeRecord72_list_data.jsp");

        // 检查登录
        Merchant72 merchant72 = check_login_user();
        
        SimpleDateFormat sdf_ymdh =new SimpleDateFormat("yyyy-MM-dd HH");

        // 得到开始时间和结束时间  和  数据验证 和 指定分店merchantId
        String selStartDate_str = request.getParameter("selStartDate");
        String selStopDate_str = request.getParameter("selStopDate");
        String payState_str = request.getParameter("payState");

        //是否是点击的插叙
        Object click_query = request.getParameter("click_query");
        if (click_query != null) {
            pageSplit.setPage(1);
        }

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

		//设置条件：ID
        tradeRecord72_find.setUserId_merchant(merchant72.getId());

        Integer payState = MathUtil.parseIntegerNull(payState_str);
        
        if (payState != null ){
            tradeRecord72_find.setState(payState);
        }
        tradeRecord72_find = (TradeRecord72)SunmingUtil.setQueryWhere_time(tradeRecord72_find,start_time,end_time);

        List<TradeRecord72> object_ite = serializContext.findAll(tradeRecord72_find, pageSplit);


        request.setAttribute("object_ite", object_ite);
        request.setAttribute("pageSplit", pageSplit);
        return SUCCESS;
    }
    /**
     * 公众号 初始化加载
     * @return
     */
    public String gongzonghaoInitOrderViewData(){

        User user = check_login_user();

        String isToday = request.getParameter("isToday");

        //开始的时间戳
        Long start_time = 0L;
        //结束的时间戳
        Long end_time = 0L;

        if (isToday == "0" || "0".equals(isToday)){
            start_time = DateUtil.getDayStartTime(currentTimeMillis());
            end_time = start_time + DateUtil.one_day;
        }else {
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");

            // 数据检查
            CheckException.checkIsTure(startDate!=null,"开始时间不能为空");
            CheckException.checkIsTure(endDate!=null,"结束时间不能为空");

            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");

            Date startDateTime = null;
            Date endDateTime = null;
            try {
                startDateTime = simpleDateFormat.parse(startDate);
                endDateTime = simpleDateFormat.parse(endDate);
            } catch (ParseException e) {
                e.printStackTrace();
            }
            start_time = startDateTime.getTime();
            end_time = endDateTime.getTime();
        }

        // 分页
        String page_temp = request.getParameter("pageNow");
        String pageSize_temp = "4";
        PageSplit pageSplit = new PageSplit(page_temp, pageSize_temp);

        // 该商家下付款成功的数据
        TradeRecord tradeRecord = new TradeRecord();
        
        if(CashierAction.getMerchantUserGroutId().equals(user.getUserGroupId())){
        	tradeRecord.setUser_merchant(user);	
        }else if(CashierAction.getCashierUserGroutId().equals(user.getUserGroupId()) && MyUtil.isValid(user.getTopUserId() )  ){
        	Merchant72 merchant72 = (Merchant72) serializContext.get(Merchant72.class, user.getTopUserId());
        	
        	if(merchant72 != null){
        		tradeRecord.setUser_merchant(merchant72);	
        	}else{
        		tradeRecord.setUserId_huiyuan(user.getId());
        	}
        }else{
        	tradeRecord.setUserId_huiyuan(user.getId());
        }
        
        
        tradeRecord.setState(State.STATE_PAY_SUCCESS);

        // 查询的时间段
        ObjectId today_start_object_id = new ObjectId(new Date(start_time));
        tradeRecord.addCommand(MongoCommand.dayuAndDengyu, "id", today_start_object_id);
        ObjectId today_end_object_id = new ObjectId(new Date(end_time));
        tradeRecord.addCommand(MongoCommand.xiaoyu, "id", today_end_object_id);
        // 迭代器
        Iterator object_ite = ContextUtil.getSerializContext().findIterable(tradeRecord, pageSplit);

        List<OrderEntity> orderEntities = new LinkedList<>();

        while (object_ite.hasNext()){
            TradeRecord tradeRecord1 = (TradeRecord)object_ite.next();
            OrderEntity orderEntity = new OrderEntity();
            orderEntity.setTradeRecord72Name(tradeRecord1.getProduct().getName());
            orderEntity.setPrice_fen_all(tradeRecord1.getShowPrice_fen_all());
            orderEntity.setPayTime(tradeRecord1.getShowPayTime());
            orderEntity.setMemo(tradeRecord1.getMemo());
            orderEntity.setPayMethed(tradeRecord1.getShowPay_method());
            orderEntity.setPayFlow(tradeRecord1.getShowPayFlow());
            orderEntity.setPayMethedInteger(tradeRecord1.getPay_method());
            if (tradeRecord1.getUser_huiyuan() == null){
                orderEntity.setPicName("");
            }else {
                orderEntity.setPicName(tradeRecord1.getUser_huiyuan().getPicname());
            }
            orderEntities.add(orderEntity);
        }


        List<TradeRecord> tradeRecords_today = ContextUtil.getSerializContext().findAll(tradeRecord);

        Long today_price_fen_all = 0L;
        Integer today_order =  tradeRecords_today.size();

        HashMap<String,String> hashMap = new HashMap();

        for (int i=0; i<tradeRecords_today.size();i++){
        	
        	TradeRecord tradeRecord_tmp = tradeRecords_today.get(i);
        	
            today_price_fen_all += tradeRecord_tmp.getShowPrice_fen_all();
            hashMap.put(tradeRecord_tmp.getUserId_huiyuan(),"0");
        }
        Integer renshu = hashMap.size();

        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("today_price_fen_all",today_price_fen_all);
        jsonObject.addProperty("today_order",today_order);
        jsonObject.addProperty("renshu",renshu);


        Gson gson = new Gson();
        String datasJson = gson.toJson(orderEntities);

        this.setDataRoot(jsonObject);
        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage(datasJson);
        return SUCCESS;
    };


    /**
     * 公众号上的订单,点击展示详情
     * @return
     */
    public String orderViewDetails(){

        User user = check_login_user();

        String orderId = request.getParameter("orderId");

        TradeRecord72 tradeRecord72 = new TradeRecord72();
        
        if(CashierAction.getMerchantUserGroutId().equals(user.getUserGroupId())){
        	tradeRecord72.setUser_merchant(user);	
        }else if(CashierAction.getCashierUserGroutId().equals(user.getUserGroupId()) && MyUtil.isValid(user.getTopUserId() )  ){
        	Merchant72 merchant72 = (Merchant72) serializContext.get(Merchant72.class, user.getTopUserId());
        	if(merchant72 != null){
        		tradeRecord72.setUser_merchant(merchant72);	
        	}else{
        		tradeRecord72.setUserId_huiyuan(user.getId());
        	}
        }else{
        	tradeRecord72.setUserId_huiyuan(user.getId());
        }
        
        tradeRecord72.setPayFlow(orderId);
        tradeRecord72 = (TradeRecord72) ContextUtil.getSerializContext().get(tradeRecord72);

        // 这个是因为在测试前期生成的订单  没有payFlow这个字段  所以得到的订单信息tradeRecord72是可能是空的
        if (tradeRecord72 == null){
            this.setDataRoot(null);
            return SUCCESS;
        }

        JsonObject jsonArray = new JsonObject();
        jsonArray.addProperty("pay_method",tradeRecord72.getPay_method());
        jsonArray.addProperty("nickname",tradeRecord72.getUser_huiyuan().getNickname());
        jsonArray.addProperty("price_fen_all",tradeRecord72.getShowPrice_fen_all());
        jsonArray.addProperty("showState",tradeRecord72.getShowState());
        jsonArray.addProperty("showPay_method",tradeRecord72.getShowPay_method());
        jsonArray.addProperty("productName",tradeRecord72.getProduct().getName());
        jsonArray.addProperty("showTime",tradeRecord72.getShowTime());
        jsonArray.addProperty("payFlow",tradeRecord72.getShowPayFlow());
        jsonArray.addProperty("productId",tradeRecord72.getProductId());

        this.setDataRoot(jsonArray);
        return SUCCESS;

    }


    /**
     * 公众号上展示出所有的代金券的信息
     * @return
     */
    public String getAllVoucherData(){

        // 得到所有状态为正在发布的代金券
        Voucher voucher =new Voucher();
        voucher.setState(Voucher.voucherState_now);
        List<Voucher> vouchers = ContextUtil.getSerializContext().findAll(voucher);

        // 组装返回的实体集合
        List<VoucherEntity> voucherEntities = this.getVoucherEntities(vouchers);

        request.setAttribute("voucherEntitiesAll", voucherEntities);
        this.setSuccessResultValue("/merchant_show/activity_load_more.jsp");  //  todo 这个页面已被删除
//        this.setSuccessResultValue("/merchant_show/coupon_load_more.jsp");
        return SUCCESS;
    }


    /**
     * 通过id得到一条代金券信息
     * @return
     */
    public String getOneVoucher(){

        // 获取id参数 并检验
        String id = request.getParameter("id" );
        CheckException.checkIsTure(id != null,"参数不正确");
        CheckException.checkIsTure(!"".equals(id),"参数不正确");

        //  根据id得到一个代金券  校验
        Voucher voucher_find = new Voucher();
        voucher_find.setId(id);
        voucher_find = (Voucher) ContextUtil.getSerializContext().get(voucher_find);
        CheckException.checkIsTure(voucher_find != null,"没有得到代金券信息");


        if(voucher_find.getState() != Voucher.voucherState_now){
            this.setDataRoot(null);
            this.setStatusCode(StatusCode.ACCEPT_FALSE);
            this.setMessage("代金券的状态不正确");
            return SUCCESS;
        };

        // 组装数据
        List<Voucher> vouchers = new LinkedList<>();
        vouchers.add(voucher_find);
        List<VoucherEntity> voucherEntities = this.getVoucherEntities(vouchers);

        Gson gson = new Gson();
        String jsonData = gson.toJson(voucherEntities);

        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("jsonData",jsonData);

        // 返回
        this.setDataRoot(jsonObject);
        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("以获取到所有代金券信息");
        return SUCCESS;
    }


    /**
     * 用户点击立即领取  得到一张代金券
     * @return
     */
    public String userGetOneVoucherNow(){


        User user = check_login_user();

        String id = request.getParameter("id");
        CheckException.checkIsTure(id != null,"参数有误!");
        CheckException.checkIsTure(!"".equals(id),"参数有误!");

        // 通过id得到代金券信息
        Voucher voucher_find = new Voucher();
        voucher_find.setId(id);
        voucher_find = (Voucher)ContextUtil.getSerializContext().get(voucher_find);
        CheckException.checkIsTure(voucher_find!=null,"没有找到代金券");


        if (voucher_find.getVoucherCount()<=voucher_find.getVoucherOutCount() || voucher_find.getState() != Voucher.voucherState_now){
            this.setStatusCode(StatusCode.ACCEPT_FALSE);
            this.setMessage("代金券已发完");
            return SUCCESS;
        }

        // 跟新代金券信息
        voucher_find.setVoucherOutCount(voucher_find.getVoucherOutCount()+1);
        if(voucher_find.getVoucherOutCount()+1 == voucher_find.getVoucherCount()){
            voucher_find.setState(Voucher.voucherState_stop);
        }
        serializContext.updateObject(voucher_find.getId(),voucher_find);

        // 获取代金券
        UserVoucher userVoucher = new UserVoucher();

        userVoucher.setId(new ObjectId().toString());

        userVoucher.setUserId_huiyuan(user.getId());
        userVoucher.setUser_huiyuan(user);
        userVoucher.setUserId_merchant(voucher_find.getTopUserId());
        userVoucher.setVoucherId(voucher_find.getId());
        userVoucher.setVoucher(voucher_find);
        userVoucher.setVoucherValue_fen(voucher_find.getVoucherValue_fen());
        userVoucher.setLow_consumption_amount(voucher_find.getLow_consumption_amount());
        userVoucher.setUseState(State.STATE_OK);

        serializContext.save(userVoucher);

//        UserVoucher userVoucher2 = (UserVoucher)ContextUtil.getSerializContext().get(userVoucher);
//        System.out.println(userVoucher2);

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("领取成功");
        return SUCCESS;
    }


    /**
     * 点击我的优惠券  展示登录用户已拥有的所有代金券
     * @return
     */
    public String getMyAllVoucher(){

        // 得到登录用户信息
        User user = check_login_user();


        UserVoucher userVoucher_find = new UserVoucher();
        userVoucher_find.setUserId_huiyuan(user.getId());

        List<UserVoucher> userVouchers_out = ContextUtil.getSerializContext().findAll(userVoucher_find);


        List<Voucher> vouchers = new LinkedList<>();
        for (int i = 0;i<userVouchers_out.size();i++){
            UserVoucher userVoucher_panduan = userVouchers_out.get(i);
            if (userVoucher_panduan == null){
                continue;
            }
            if (userVouchers_out.get(i).getVoucher() ==  null){
                continue;
            }

            if(userVoucher_panduan.getUseState() != com.lymava.commons.state.State.STATE_OK   &&  !userVoucher_panduan.getUseState().equals(com.lymava.commons.state.State.STATE_OK)){
                continue;
            }
            vouchers.add(userVouchers_out.get(i).getVoucher());
        }
        List<VoucherEntity> voucherEntities = this.getVoucherEntities(vouchers);
        
        request.setAttribute("voucherEntities", voucherEntities);
        this.setSuccessResultValue("/merchant_show/coupon_load_more.jsp");
//        this.setSuccessResultValue("/user_center/coupon_load_more.jsp");
        return SUCCESS;
    }


    //  组装返回实体 (代金券)
    private List<VoucherEntity> getVoucherEntities(List<Voucher> vouchers){
        List<VoucherEntity> voucherEntities = new LinkedList<>();
        for (int i = 0; i<vouchers.size(); i++){
            VoucherEntity voucherEntity= new VoucherEntity();

            voucherEntity.setId(vouchers.get(i).getId());
            voucherEntity.setVoucherName(vouchers.get(i).getVoucherName());
            voucherEntity.setUserName(vouchers.get(i).getShowInNickName());
            voucherEntity.setAddress(vouchers.get(i).getShowInAddress());
            voucherEntity.setVoucherCount(vouchers.get(i).getVoucherCount());
            voucherEntity.setVoucherOutCount(vouchers.get(i).getVoucherOutCount());
            voucherEntity.setVoucherValue(vouchers.get(i).getVoucherValue());
            voucherEntity.setLow_consumption_amount(vouchers.get(i).getLow_consumption_amount());
            voucherEntity.setShowReleaseTime(vouchers.get(i).getShowInReleaseTime());
            voucherEntity.setShowStopTime(vouchers.get(i).getShowInStopTime());

            voucherEntity.setShowUseReleaseTime(vouchers.get(i).getShowUseReleaseTime());
            voucherEntity.setShowUseStopTime(vouchers.get(i).getShowUseStopTime());
            if(vouchers.get(i).getLogo() != null){
                voucherEntity.setLogo(vouchers.get(i).getLogo());
            };

            voucherEntities.add(voucherEntity);
        }
        return voucherEntities;
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
           Long   red_package_price_fen_ALL=0L;  //红包总额
           Integer red_package_size=0;     //红包总个数
           
           Long   red_package_priceFa_fen_ALL=0L;  //红包已发放总额
           Integer red_packageFA_size=0;     //红包已发放总个数
           
           Long   red_packageNo_price_fen_ALL=0L;  //红包未领取总额
           Integer red_packageNo_size=0;     //红包未领取总个数
           
           Long  red_packageUse_price_fen_ALL=0L;//已使用红包总额
           Integer red_packageUse_size=0;   //已使用红包个数
           
           Long red_packageOverdue_price_fen_All=0L;//过期红包总额
           Integer red_packageOverdue_size=0;//过期红包个数 
           
           CheckException.checkIsTure(start_time < end_time,"开始时间不能大于结束时间!");
           
           CheckException.checkIsTure(((end_time-start_time)<=DateUtil.one_day*31),"开始时间到结束时间不能超过31天 ");
           
          /**	统计已经使用的定向红包金额和个数	结束	*/
          MerchantRedEnvelopePayRecord merchantRedEnvelopePayRecord_find = new MerchantRedEnvelopePayRecord();
       	
           merchantRedEnvelopePayRecord_find.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_dingxiang);
           merchantRedEnvelopePayRecord_find.setUserId_merchant(user.getId());
           
           merchantRedEnvelopePayRecord_find.addCommand(MongoCommand.in, "state", State.STATE_PAY_SUCCESS);
           merchantRedEnvelopePayRecord_find.addCommand(MongoCommand.in, "state", State.STATE_OK);
           
           
           SunmingUtil.setQueryWhere_time(merchantRedEnvelopePayRecord_find, start_time, end_time);
           
           //查询时间段 内  的所有数据
           Iterator<MerchantRedEnvelopePayRecord> merchantRedEnvelopePayRecord_ite= serializContext.findIterable(merchantRedEnvelopePayRecord_find);
           
           while(merchantRedEnvelopePayRecord_ite.hasNext()) {
        	   
        	 MerchantRedEnvelopePayRecord merchantRedEnvelopePayRecord_tmp = merchantRedEnvelopePayRecord_ite.next();
        	 
        	   
        	 MerchantRedEnvelope merchantRedEnvelopes_out = merchantRedEnvelopePayRecord_tmp.getMerchantRedEnvelope();
        	 if(merchantRedEnvelopes_out == null) {
        		 continue;
        	 }
           	 red_packageUse_price_fen_ALL	+=	merchantRedEnvelopes_out.getAmountFen();
           	 red_packageUse_size++;
           }
           /**	统计已经使用的定向红包金额和个数	结束	*/
           MerchantRedEnvelope merchantRedEnvelope_find	=	new MerchantRedEnvelope();
           merchantRedEnvelope_find.setUserId_merchant(user.getId());
           merchantRedEnvelope_find= (MerchantRedEnvelope) SunmingUtil.setQueryWhere_time(merchantRedEnvelope_find, start_time, end_time);
           //查询时间段 内  的所有数据
           Iterator<MerchantRedEnvelope> merchantRedEnvelope_ite = serializContext.findIterable(merchantRedEnvelope_find);
           
           while(merchantRedEnvelope_ite.hasNext()) {
        	   
        	   MerchantRedEnvelope merchantRedEnvelopes_next = merchantRedEnvelope_ite.next();
        	   
        	   Long amountFen = merchantRedEnvelopes_next.getAmountFen();
        	   
             	 red_package_price_fen_ALL += amountFen;
             	 red_package_size++;
             	 //已发放 红包 
             	 if(State.STATE_OK.equals(merchantRedEnvelopes_next.getState())){
	               	red_package_priceFa_fen_ALL+=amountFen;
	               	red_packageFA_size++;
             	 }
             	 //未领取的红包 
             	 else if(State.STATE_WAITE_CHANGE.equals(merchantRedEnvelopes_next.getState())){
                 	red_packageNo_price_fen_ALL+=amountFen;
                 	red_packageNo_size++;
             	} 
               //过期的红包 
             	else if(State.STATE_CLOSED.equals(merchantRedEnvelopes_next.getState())){
                  	red_packageOverdue_price_fen_All+=amountFen;
                  	red_packageOverdue_size++;
               }
        	   
           }
           
           
           // 设置返回数据
           JsonObject jsonObject = new JsonObject();
           
           jsonObject.addProperty("start_date",SunmingUtil.longDateToStrDate_tall(start_time));  // 开始时间  用于展示
           jsonObject.addProperty("end_date",SunmingUtil.longDateToStrDate_tall(end_time));   // 结束时间  用于展示

           jsonObject.addProperty("red_package_priceALL",MathUtil.divide(red_package_price_fen_ALL, 100).floatValue());
           jsonObject.addProperty("red_package_size",red_package_size);

           jsonObject.addProperty("red_package_priceFaALL",MathUtil.divide(red_package_priceFa_fen_ALL, 100).floatValue());
           jsonObject.addProperty("red_packageFA_size",red_packageFA_size);

           jsonObject.addProperty("red_packageNo_priceALL",MathUtil.divide(red_packageNo_price_fen_ALL, 100).floatValue());
           jsonObject.addProperty("red_packageNo_size",red_packageNo_size);
           
           jsonObject.addProperty("red_packageUse_priceALL",MathUtil.divide(red_packageUse_price_fen_ALL, 100).floatValue());
           jsonObject.addProperty("red_packageUse_size",red_packageUse_size);
           
           jsonObject.addProperty("red_packageOverdue_priceAll",MathUtil.divide(red_packageOverdue_price_fen_All, 100).floatValue());
           jsonObject.addProperty("red_packageOverdue_size",red_packageOverdue_size);
           
           this.setStatusCode(StatusCode.ACCEPT_OK);
           this.setMessage("已返回查询时间段的红包数据");
           this.setDataRoot(jsonObject);
   		return SUCCESS;
   	}
       
    
}
