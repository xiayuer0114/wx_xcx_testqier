package com.lymava.qier.service;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map.Entry;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.nosql.context.SerializContext;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.nosql.util.PageSplit;
import com.lymava.qier.model.Merchant72;
import com.lymava.qier.model.MerchantRedEnvelope;
import com.lymava.qier.model.TradeRecord72;
import com.lymava.qier.model.User72;
import com.lymava.qier.redenvelope.model.MerchantRedEnvelopeRecommendRule;

public class MerchantRedEnvelopeService implements Serializable{
	
	
	protected final Log logger = LogFactory.getLog(getClass());

	/**
	 * 
	 */
	private static final long serialVersionUID = -7500133079298700367L;

	/**
	 * 根据交易推荐 红包
	 * 	第一步	根据配置的推荐规则推荐红包 详见 {@code MerchantRedEnvelopeRule}	
	 * 	第二步	根据默认的距离规则推荐红包	详见{@code MerchantRedEnvelopeService#recommendMerchantRedEnvelope(Double, Double, Integer)}
	 * 
	 * 			1.把这个订单的用户的有的红包排除
	 * 			2.通过配置的规则推荐红包 
	 * 			3.通过经纬度推荐距离最近的商户的红包
	 * @param tradeRecord72	当前交易的订单
	 * @param size	推荐红包的类型
	 * @return 红包的列表	推荐的红包的列表
	 */
	public List<MerchantRedEnvelope> recommendMerchantRedEnvelope(TradeRecord72 tradeRecord72,Integer size){
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		//结果列表
		List<MerchantRedEnvelope> merchantRedEnvelope_list = new ArrayList<MerchantRedEnvelope>();
		//存放已经领取的商家的id值的map
		HashMap<String, String> merchantRedEnvelope_had_map=new HashMap<String, String>();
		//存放已经定向商家的id值
		HashMap<String, String> merchantRedEnvelopeRecommendRule_map=new HashMap<String, String>();
		//根据订单得到消费的会员
		User72 user_huiyuan = tradeRecord72.getUser_huiyuan();
		//根据订单得到消费的商家
		Merchant72 user_merchant = tradeRecord72.getUser_merchant();

		
		MerchantRedEnvelope merchantRedEnvelope_find=new MerchantRedEnvelope();
		//未被领取的红包可以被领取
		merchantRedEnvelope_find.setState(State.STATE_WAITE_CHANGE);
		//未过期的红包可以被领取
		merchantRedEnvelope_find.addCommand(MongoCommand.dayuAndDengyu, "expiry_time", new Date().getTime());

		
		
		//排除用户的有的红包的商家的id
		MerchantRedEnvelope merchantRedEnvelope_had_find = new MerchantRedEnvelope();
		if(user_huiyuan!=null) {
		
		merchantRedEnvelope_had_find.setUserId_huiyuan(user_huiyuan.getId());
		//红包已领取
		merchantRedEnvelope_had_find.setState(State.STATE_OK);
		//红包未过期
		merchantRedEnvelope_had_find.addCommand(MongoCommand.dayuAndDengyu, "expiry_time", new Date().getTime());
		
		Iterator<MerchantRedEnvelope> merchantRedEnvelope_had_ite = serializContext.findIterable(merchantRedEnvelope_had_find);
		
		while(merchantRedEnvelope_had_ite.hasNext()) {
			MerchantRedEnvelope merchantRedEnvelope_had_next = merchantRedEnvelope_had_ite.next();
			
			String userId_merchant=merchantRedEnvelope_had_next.getUserId_merchant();
			
			merchantRedEnvelope_had_map.put(userId_merchant, userId_merchant);
//			merchantRedEnvelope_find.addCommand(MongoCommand.not_in, "userId_merchant", userId_merchant);
			}
		}
		
		//根据配置的规则得到定向商家的id
		if(user_merchant!=null) {
		MerchantRedEnvelopeRecommendRule merchantRedEnvelopeRecommendRule_find=new MerchantRedEnvelopeRecommendRule();
		
		merchantRedEnvelopeRecommendRule_find.setUser_merchant_xiaofei_id(user_merchant.getId());
		//规则生效
		merchantRedEnvelopeRecommendRule_find.setState(State.STATE_OK);
		//规则有效期
		merchantRedEnvelopeRecommendRule_find.addCommand(MongoCommand.xiaoyuAndDengyu, "start_time_shengxiao", new Date().getTime());
		merchantRedEnvelopeRecommendRule_find.addCommand(MongoCommand.dayuAndDengyu, "end_time_shengxiao", new Date().getTime());
		
		Iterator<MerchantRedEnvelopeRecommendRule> merchantRedEnvelopeRecommendRule_ite = serializContext.findIterable(merchantRedEnvelopeRecommendRule_find);
		//根据user查出已经发放的商家列表，将已经领取的商家的id   put到merchantRedEnvelopeRecommendRule_map中
		while(merchantRedEnvelopeRecommendRule_ite.hasNext()) {
			
			//随机选一个符合条件的推荐规则
			
			MerchantRedEnvelopeRecommendRule merchantRedEnvelopeRecommendRule_next = merchantRedEnvelopeRecommendRule_ite.next();
			System.out.println("定向商家名称"+merchantRedEnvelopeRecommendRule_next.getUser_merchant_hongbao().getShowName());
			
			String userId_merchant_key = merchantRedEnvelopeRecommendRule_next.getUser_merchant_hongbao_id();
			
			merchantRedEnvelopeRecommendRule_map.put(userId_merchant_key, userId_merchant_key);
			//merchantRedEnvelope_find.addCommand(MongoCommand.in,"userId_merchant" , userId_merchant_key);

			}
		
		}
		
		
			
				
			
		
		//根据map结果添加条件
		//如果有定向商家
		if(! merchantRedEnvelopeRecommendRule_map.isEmpty()) {
			//记录可以取得商家的list
			List<String> userIds_merchant=new ArrayList<String>();
			
			//循环， 排除掉已经领取的商家，得到可以领取的定向红包的商家id加到merchantRedEnvelopeRecommendRule_map中
			Set<Entry<String, String>> entrySet = merchantRedEnvelopeRecommendRule_map.entrySet();
			for (Entry<String, String> entry : entrySet) {
				String rule_val=merchantRedEnvelopeRecommendRule_map.get(entry.getKey());
				String had_val=merchantRedEnvelope_had_map.get(entry.getKey());
					if(had_val==null) {
						userIds_merchant.add(rule_val);
				}
					
			}
			
			
			while(userIds_merchant!=null && userIds_merchant.size()>0) {
				//随机取出一个商家
				int random = (int)(Math.random()*(userIds_merchant.size()));
				
				
				merchantRedEnvelope_find.setUserId_merchant(userIds_merchant.get(random));
				
				MerchantRedEnvelope MerchantRedEnvelope_findOneInlist = (MerchantRedEnvelope) serializContext.findOneInlist(merchantRedEnvelope_find);
				
				merchantRedEnvelope_list.add(MerchantRedEnvelope_findOneInlist);
				userIds_merchant.remove(random);
				
				
				if(merchantRedEnvelope_list.size()>=size) {
					return merchantRedEnvelope_list;
				}
			}
			//要将userId_merchant设为null，才能在查询
			merchantRedEnvelope_find.setUserId_merchant(null);
		}
		
		//如果没有定向商家但是有已经领取的商家
		
		
		else if(!merchantRedEnvelope_had_map.isEmpty()) {
			Set<Entry<String, String>> entrySet = merchantRedEnvelope_had_map.entrySet();
			for (Entry<String, String> entry : entrySet) {
				merchantRedEnvelope_find.addCommand(MongoCommand.not_in,"userId_merchant" , merchantRedEnvelope_had_map.get(entry.getKey()));
				
			}
		}
		
		//如果从定向商家取取出了红包但是没有取够，要排除已经取得的商家
		if(merchantRedEnvelope_list.size()>0&& merchantRedEnvelope_list.size()<size) {
			for (MerchantRedEnvelope merchantRedEnvelope : merchantRedEnvelope_list) {
				merchantRedEnvelope_find.addCommand(MongoCommand.not_in,"userId_merchant" , merchantRedEnvelope.getUserId_merchant());
			}
		}
		
		
		
		List<MerchantRedEnvelope> merchantRedEnvelope_list_tmp=recommendMerchantRedEnvelope(user_merchant.getLongitude(),user_merchant.getLatitude(),(size-merchantRedEnvelope_list.size()),merchantRedEnvelope_find);
		for (MerchantRedEnvelope merchantRedEnvelope : merchantRedEnvelope_list_tmp) {
			merchantRedEnvelope_list.add(merchantRedEnvelope);
		}
		
		
	
		return merchantRedEnvelope_list;
	}
	
	/**
	 * 根据 定位获取 推荐的定向红包
	 * @param longitude
	 * @param latitude
	 * @param size
	 * @return
	 */
	public List<MerchantRedEnvelope> recommendMerchantRedEnvelope(Double longitude,Double latitude,Integer size,MerchantRedEnvelope merchantRedEnvelope){
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		List<MerchantRedEnvelope> merchantRedEnvelope_list =new ArrayList<MerchantRedEnvelope>();
		
		//未使用的红包可以被领取
		merchantRedEnvelope.setState(State.STATE_WAITE_CHANGE);
		
		//添加查询条件
		MongoCommand.nearSphere(merchantRedEnvelope, longitude, latitude);
		//默认就是采用距离排序	把id 排序这些去掉
		merchantRedEnvelope.setIs_sort(false);
		
		PageSplit pageSplit = new PageSplit();
		pageSplit.setPageSize(size);
			
		
		//要实现取不同的商家
		for(int i=0;i<size;i++) {
			MerchantRedEnvelope merchantRedEnvelope_findOneInlist = (MerchantRedEnvelope) serializContext.findOneInlist(merchantRedEnvelope);
			if(merchantRedEnvelope_findOneInlist!=null) {
				merchantRedEnvelope_list.add(merchantRedEnvelope_findOneInlist);
				merchantRedEnvelope.addCommand(MongoCommand.not_in, "userId_merchant" , merchantRedEnvelope_findOneInlist.getUserId_merchant());
			}
		}
		
		return merchantRedEnvelope_list;
	}
	
	
	
}
