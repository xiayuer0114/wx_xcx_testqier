<%@page import="com.google.gson.JsonElement"%>
<%@page import="com.lymava.commons.util.JsonUtil"%>
<%@page import="java.net.URL"%>
<%@page import="com.lymava.commons.http.HttpsPost"%>
<%@page import="com.google.gson.JsonArray"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.qier.model.User72"%>
<%@page import="com.lymava.base.model.User"%>
<%@page import="com.lymava.commons.vo.EntityKeyValue"%>
<%@page import="java.util.List"%>
<%@page import="java.util.LinkedList"%>
<%@page import="com.lymava.commons.util.HttpUtil"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.wechat.gongzhonghao.GongzonghaoContent"%>
<%@page import="com.lymava.wechat.gongzhonghao.Gongzonghao"%>
<%@page import="com.lymava.commons.util.MathUtil"%>
<%@page import="com.lymava.trade.business.model.Product"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%!
	/**
	 * @return
	 * @throws IOException 
	 * @throws MalformedURLException 
	 */
	public static String changeopenid(String from_appid,List<String> openid_list,String access_token) throws Exception{
		
		String url = "https://api.weixin.qq.com/cgi-bin/changeopenid?access_token=" + access_token;
	
		JsonObject jsonObject = new JsonObject();
		
		JsonArray openid_list_jsonarray = new JsonArray();
		
		for(String openid_tmp:openid_list){
			openid_list_jsonarray.add(openid_tmp);
		}
		
		jsonObject.addProperty("from_appid",from_appid);
		jsonObject.add("openid_list",openid_list_jsonarray);
		
		HttpsPost httpsPost = new HttpsPost(new URL(url));
	
		httpsPost.addParemeterName(jsonObject.toString());
		
		String result = httpsPost.getResult();
		
		return result;
	}

	public static List<EntityKeyValue> changeopenid(String result_str){
		
		List<EntityKeyValue> openid_list_value = new LinkedList<EntityKeyValue>();
		
		JsonObject jsonObject_root = JsonUtil.parseJsonObject(result_str);
		
		String errcode = JsonUtil.getStringTrim(jsonObject_root, "errcode");
		String errmsg = JsonUtil.getStringTrim(jsonObject_root, "errmsg");
		
		if(!"0".equals(errcode) || !"ok".equals(errmsg)){
			return openid_list_value;
		}
		
		JsonArray result_list = JsonUtil.getRequestJsonArray(jsonObject_root, "result_list");
		
		for (JsonElement jsonElement : result_list) {
			
			JsonObject jsonObject_openid = jsonElement.getAsJsonObject();
			
			String ori_openid = JsonUtil.getStringTrim(jsonObject_openid, "ori_openid");
			String new_openid = JsonUtil.getStringTrim(jsonObject_openid, "new_openid");
			String err_msg = JsonUtil.getStringTrim(jsonObject_openid, "err_msg");
			
			if(!"ok".equals(err_msg) || MyUtil.isEmpty(new_openid)){
				continue;
			}
			
			EntityKeyValue entityKeyValue = new EntityKeyValue();
			
			entityKeyValue.setKey(ori_openid);
			entityKeyValue.setValue(new_openid);
			
			openid_list_value.add(entityKeyValue);
		}
		
		return openid_list_value;
	}
%>
<%
		//Gongzonghao gongzonghao = new Gongzonghao();
		
		//gongzonghao.setAppid("wx25566ab45eefdf8d");
		//gongzonghao.setAppSecret("5a46c6fa1f96f0ab7dae787bd410af58");
		
		String access_token = "9_Ofn4AugWRXUyFwznNug4Qlaq7u-hxY9ufWATNR_I4Sge4-WBsF8LdmO9-JmQc5S16PbHvziAdnKIx6w60OxZhxNS_S7i5K5p65wnAZEb51ntJooeO3l8dPUzKUt5deWLinAtnRCBitQc4In0EJOcAAAPUZ";
		//gongzonghao.setAccess_token(access_token);
		
		User user_find = new User();
		user_find.setThird_user_type(User.third_user_type_weixin);
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		Iterator<User> user_ite =  serializContext.findIterable(user_find);
		
		List<String> openid_list = new LinkedList<String>();
		
		boolean has_next = user_ite.hasNext();
		
		while(has_next){
			
			User user_next = user_ite.next();
			
			if(!MyUtil.isEmpty(user_next.getThird_user_id())){
				openid_list.add(user_next.getThird_user_id());	
			}
			
			
			has_next = user_ite.hasNext();
			
			if(openid_list.size() > 50 || !has_next){
				
				String changeopenid = changeopenid("wx0f682d47511cc916", openid_list,access_token);
				
				List<EntityKeyValue> changeopenid_list = changeopenid(changeopenid);
				
				for (EntityKeyValue entityKeyValue : changeopenid_list) {
					
					if(MyUtil.isEmpty(entityKeyValue.getKey()) || MyUtil.isEmpty((String)entityKeyValue.getValue())){
						continue;
					}
					

					String old_openid = entityKeyValue.getKey();
					String new_openid = (String)entityKeyValue.getValue();
					
					User user_update_find = new User();
					user_update_find.setThird_user_id(old_openid);
					user_update_find.setThird_user_type(User.third_user_type_weixin);
					
					
					List<User> user_update_list =  serializContext.findAll(user_update_find);
					
					for(User user_update_find_out:user_update_list){
						
						User user_update = new User();
						user_update.setThird_user_id(new_openid);
						user_update.setUsername(new_openid);
						
						serializContext.updateObject(user_update_find_out.getId(), user_update);
						
					}

				}
				
				
				openid_list.clear();
			}
		}
		
	
		
		
		
%>