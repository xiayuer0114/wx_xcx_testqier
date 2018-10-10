package com.lymava.qier.action.manager;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.lymava.commons.face.JsonObjectFace;

import java.util.List;

/**
 * 订单报表统计
 * @author lymava
 *
 */
public class OrderReportEntry implements JsonObjectFace {
	/**
	 * 分段统计的起始时间
	 */
	private Long start_time;
	/**
	 * 分段统计的结束时间
	 */
	private Long end_time;
	/**
	 * 订单总数
	 */
	private Long order_sum_count;
	/**
	 * 交易总额 单位分
	 */
	private Long price_fen_all;
	/**
	 *平均消费
	 */
	private Long price_fen_avg;


	public Long getPrice_fen_avg() {
		return price_fen_avg;
	}

	public void setPrice_fen_avg(Long price_fen_avg) {
		this.price_fen_avg = price_fen_avg;
	}
	public Long getStart_time() {
		return start_time;
	}

	public void setStart_time(Long start_time) {
		this.start_time = start_time;
	}

	public Long getEnd_time() {
		return end_time;
	}

	public void setEnd_time(Long end_time) {
		this.end_time = end_time;
	}

	public Long getOrder_sum_count() {
		return order_sum_count;
	}

	public void setOrder_sum_count(Long order_sum_count) {
		this.order_sum_count = order_sum_count;
	}

	public Long getPrice_fen_all() {
		return price_fen_all;
	}

	public void setPrice_fen_all(Long price_fen_all) {
		this.price_fen_all = price_fen_all;
	}
	
	public JsonObject toJsonObject(){
		JsonObject jsonObject = new JsonObject();

		jsonObject.addProperty("start_time",start_time);
		jsonObject.addProperty("end_time",end_time);
		jsonObject.addProperty("order_sum_count",order_sum_count);
		jsonObject.addProperty("price_fen_all",price_fen_all);
		jsonObject.addProperty("price_fen_avg",price_fen_avg);
		return jsonObject;
	}

	public void parseJsonObject(JsonObject jsonObject) {
	}

}
