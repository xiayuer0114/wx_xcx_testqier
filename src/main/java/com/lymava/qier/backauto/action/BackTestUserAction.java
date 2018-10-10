package com.lymava.qier.backauto.action;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;
import java.util.UUID;

import org.bson.types.ObjectId;

import com.google.gson.JsonArray;
import com.lymava.base.action.BaseAction;
import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.model.User;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlMethod;
import com.lymava.base.util.WebConfigContent;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.state.StatusCode;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.JsonUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.nosql.model.SerializModel;
import com.lymava.nosql.mongodb.util.ReflectUtil;
import com.lymava.nosql.util.PageSplit;
import com.lymava.qier.action.manager.OrderReportContent;
import com.lymava.qier.action.manager.OrderReportEntry;
import com.lymava.qier.model.Merchant72;
import com.lymava.qier.model.User72;
import com.lymava.wechat.gongzhonghao.SubscribeUser;

@AcceptUrlAction(path="v2/BackTestUser/")
public class BackTestUserAction extends LazyBaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8567511435366194950L;

	
	
	@AcceptUrlMethod(name = "批量增加用户保存")
    public String batch_save() {
		  
		PageSplit pageSplit=new PageSplit(); 
		SubscribeUser subscribeUser = new SubscribeUser();//微信关注用户对象
		
		
		String number_str = this.getParameter("number");
    	String defaultUserGroupId=this.getParameter("userGroup.id");
    	
    	Integer number = MathUtil.parseIntegerNull(number_str);
    	
    	CheckException.checkIsTure(number != null && number > 0, "创建数量必须大于0！");
    	
    	pageSplit.setPageSize(number);
    	/*
    	 * 随机区表中的subscribeUser
    	 * */
    	//对象的总记录数
    	serializContext.findIterable(subscribeUser,pageSplit);
 
    	//随机页数
    	int randomPage=(int) (Math.random()*pageSplit.getLastPage()); 
    	if(randomPage==0) {randomPage=1;}
    	//设置分页条件
    	pageSplit.setPage(randomPage);
    	pageSplit.setPageSize(number);
    	
    	
    	//查询得到的结果
    	List<SubscribeUser> subscribeUser_list = serializContext.findAll(subscribeUser,pageSplit);
    	 
    	
    	//随机取SubscribeUser对象
    	for(int i=0;i<number;i++) {
    		
//    		int ran=(int) (Math.random()*subscribeUser_list.size());
        	User user_tmp = new User();
    		user_tmp.setId(new ObjectId().toString());
    		user_tmp.setState(User.STATE_OK);
    		user_tmp.setPayPwdState(User.payPwdState_STATE_NOTOK);
    		user_tmp.setIntegral(0l);
    		user_tmp.setBalance(0l);
    		user_tmp.setShare_balance(User.share_balance_no);
    		user_tmp.setUserGroupId(defaultUserGroupId);
    		WebConfigContent instance = WebConfigContent.getInstance();
    		Long newUser_huiyuan_last_id = instance.getNewUser_huiyuan_last_id();
    		user_tmp.setBianhao(newUser_huiyuan_last_id); 
    		
    		user_tmp.setNickname(subscribeUser_list.get(i).getNickname());
    		user_tmp.setUsername(UUID.randomUUID().toString().replaceAll("-", ""));
    		
    		
        	if(defaultUserGroupId!=null) {
        		user_tmp.setUserGroupId(defaultUserGroupId);
        	} 
        	 	
    		serializContext.save(user_tmp);
        	
    	 }
    	
    	
    	
    	this.setMessage("操作成功!");
		this.setStatusCode(StatusCode.ACCEPT_OK);
        return SUCCESS;
    }




	@Override
	protected Class<? extends SerializModel> getObjectClass() {
		// TODO Auto-generated method stub
		return null;
	}
	
	
}
