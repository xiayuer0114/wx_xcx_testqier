package com.lymava.qier.action.manager;

import com.lymava.base.util.ContextUtil;
import com.lymava.base.vo.State;
import com.lymava.nosql.context.SerializContext;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.qier.business.BusinessIntIdConfigQier;
import com.lymava.trade.base.model.BusinessIntIdConfig;
import com.lymava.trade.business.model.TradeRecord;
import org.bson.types.ObjectId;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

public class OrderReportContent {

	
	/**
	 * 		
	 * @param start_time	统计的起始时间
	 * @param end_time		统计的结束时间
	 * @param jiange_time	统计的间隔时间
	 * @return
	 */
	public static List<OrderReportEntry> create_orderReport(Long start_time,Long end_time,Long jiange_time,List<String> user_id_list){

		TradeRecord tradeRecord_find = new TradeRecord();

		tradeRecord_find.setState(State.STATE_PAY_SUCCESS);
		tradeRecord_find.setBusinessIntId(BusinessIntIdConfig.businessIntId_trade);

		List<OrderReportEntry> orderReportEntries = new LinkedList<OrderReportEntry>();
		
		SerializContext serializContext = ContextUtil.getSerializContext();

		for (;;){

				// 当开始时间大于等于了结束时间 终止循环
			if (start_time>=end_time){
				break;
			}
				// 需要添加的数据
			OrderReportEntry orderReportEntry = new OrderReportEntry();

				// 查询条件: 时间大于等于开始时间
			ObjectId start_object_id = new ObjectId(new Date(start_time));
			tradeRecord_find.addCommand(MongoCommand.dayuAndDengyu, "id", start_object_id);

				// 添加数据 同时设置开始时间为:开始时间加上间隔时间 再将开始时间作为查询条件
			orderReportEntry.setStart_time(start_time);
			start_time = start_time+jiange_time;
			orderReportEntry.setEnd_time(start_time);

				// 查询条件: 时间小于(开始时间加间隔时间)
			ObjectId end_object_id = new ObjectId(new Date(start_time));
			tradeRecord_find.addCommand(MongoCommand.xiaoyu, "id", end_object_id);
			
			//查询条件：分店，则userId_merchant为选择的分店ID
			if (user_id_list != null) {
				if(user_id_list.size() == 1){
					String user_id_tmp = user_id_list.get(0);
					tradeRecord_find.setUserId_merchant(user_id_tmp);
				}else {
					for (String userId_merchant_tmp : user_id_list) {
						tradeRecord_find.addCommand(MongoCommand.in,"userId_merchant",userId_merchant_tmp);
					}
				}
			}

				// 查询出该时间段的数据
			Iterator<TradeRecord> tradeRecords_today = serializContext.findIterable(tradeRecord_find);

				// 循环得到该时间段的 总金额和订单量
			Long price_fen_all = 0L;
			Long countAll = 0L;
			
			while(tradeRecords_today.hasNext()) {
				TradeRecord tradeRecord_next = tradeRecords_today.next();
				price_fen_all += tradeRecord_next.getShowPrice_fen_all();
				 
				countAll++;
			}

				// 移除MongoCommands
			tradeRecord_find.removeAllMongoCommands();

				// 添加数据
			orderReportEntry.setPrice_fen_all(price_fen_all);
			orderReportEntry.setOrder_sum_count(countAll);
			if (countAll==0){
				orderReportEntry.setPrice_fen_avg(0L);
			}else {
				orderReportEntry.setPrice_fen_avg(price_fen_all/countAll);
			}

				// 添加数据
			orderReportEntries.add(orderReportEntry);
		}

		return orderReportEntries;


//
//			// 设置查询条件
//		ObjectId start_object_id = new ObjectId(new Date(start_time));
//		tradeRecord_find.addCommand(MongoCommand.dayuAndDengyu, "id", start_object_id);
//		ObjectId end_object_id = new ObjectId(new Date(end_time));
//		tradeRecord_find.addCommand(MongoCommand.xiaoyu, "id", end_object_id);
//
//			// 得到查询结果
//		List<TradeRecord> tradeRecords_today = ContextUtil.getSerializContext().findAll(tradeRecord_find);
//
//		Long price_fen_all = 0L;
//		Long countAll = 0L;
//		for (int i=0; i<tradeRecords_today.size();i++){
//			price_fen_all += tradeRecords_today.get(i).getPrice_fen_all();
//			countAll++;
//		}
//		tradeRecord_find.removeAllMongoCommands();
//
//		OrderReportEntry orderReportEntry = new OrderReportEntry();
//
//		orderReportEntry.setStart_time(start_time);
//		orderReportEntry.setEnd_time(end_time);
//		orderReportEntry.setPrice_fen_all(price_fen_all);
//		orderReportEntry.setOrder_sum_count(countAll);
//
////		return orderReportEntry;

//		return null;
	}



	/**
	 *
	 * @param start_Time
	 * @param end_Time
	 * @param jiege
	 * @return
	 */
	public String getShowTime(Long start_Time, Long end_Time, Long jiege){
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("MM-dd kk:mm");
		String showTime ="";

		for (;;) {
			// 当开始时间大于等于了结束时间 终止循环
			if (start_Time >= end_Time) {
				break;
			}
			Date date= new Date(start_Time);
			showTime += simpleDateFormat.format(date)+"点,";
			start_Time = start_Time + jiege;
		}

		return showTime;
	};

}
