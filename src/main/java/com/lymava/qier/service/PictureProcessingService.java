package com.lymava.qier.service;

import java.io.Serializable;
import java.lang.reflect.Method;
import java.util.Iterator;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.ss.formula.functions.T;

import com.lymava.base.model.Pub;
import com.lymava.base.model.PubConlumn;
import com.lymava.base.model.User;
import com.lymava.base.safecontroler.model.Company;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.context.SerializContext;
import com.lymava.nosql.model.SerializModel;
import com.lymava.nosql.mongodb.vo.BaseModel;
import com.lymava.qier.model.xiaoChengXuModel.ShowPub;
import com.mongodb.BasicDBList;

/**
 * 图片转出处理
 * @author lymava
 *
 */
public class PictureProcessingService  implements Serializable{
	

	
	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 7014338600815824552L;
	
	protected final Log logger = LogFactory.getLog(getClass());
	
	/**
	 * 图片处理的主逻辑
	 */
	public void pictureProcess() {
		
		SerializContext serializContext=ContextUtil.getSerializContext();
		//找到对应的模型
		//循环出所有的数据
			//拿出对应的图片
			//调用	image_url_convert 方法	获得新的图片路径
			//把原模型里的数据替换成新的路径
			//图片转换完成后update此条数据	
		//结束循环
		
		
		/**
		 * pub模型处理
		 */
		Iterator<SerializModel> pub_ite = serializContext.findIterable(new Pub());
		while(pub_ite.hasNext()) {
			Pub pub_next = (Pub) pub_ite.next();
			Pub pub_update=new Pub();
			Pub finalPub = pub_next.getFinalPub();
			//判断是否是ShowPub子类
			if(finalPub instanceof ShowPub) {
				
				pub_update = new ShowPub();
				ShowPub showPub = (ShowPub)finalPub;
				String old_background = showPub.getBackground();
				String new_background=image_url_convert(old_background);
				((ShowPub) pub_update).setBackground(new_background);
				
				
				BasicDBList old_headPics = showPub.getHeadPics();
				BasicDBList new_headPics=new BasicDBList();
				if(old_headPics!=null&&old_headPics.size()>0) {
					for (Object object_pic : old_headPics) {
						String image_url_convert = image_url_convert(object_pic.toString().trim());
						new_headPics.add(image_url_convert);
					}
					((ShowPub) pub_update).setHeadPics(new_headPics);
				}
				
			}
			
			//pic属性,						普通字符串
			String old_pic = pub_next.getPic();
			if(!MyUtil.isEmpty(old_pic)) {
				String new_pic =image_url_convert(old_pic);
				pub_update.setPic(new_pic);
			}
			//pics属性						BasicDBList对象		
			BasicDBList old_pics=pub_next.getPics();
			BasicDBList new_pics=new BasicDBList();
			if(old_pics!=null && old_pics.size()>0) {
			for (Object object_pic : old_pics) {
				String image_url_convert = image_url_convert(object_pic.toString().trim());
				new_pics.add(image_url_convert);
			}
			pub_update.setPics(new_pics);
			}
			//属性content,该属性保存的是一个html的字符串，要先从中取出图片的url				html字符串
			String content = pub_next.getContent();
			if(!MyUtil.isEmpty(content)) {
			String new_content=this.content_replace(content);
			pub_update.setContent(new_content);
			}
			
			
			
			
			//更新
			serializContext.updateObject(pub_next.getId(), pub_update);
			
		}
		
		
		/**
		 * pubConlumn模型处理
		 */
		Iterator<SerializModel> pubConlumn_ite = serializContext.findIterable(new PubConlumn());
		while(pubConlumn_ite.hasNext()) {
			PubConlumn pubConlumn_next = (PubConlumn) pubConlumn_ite.next();
			PubConlumn	pubConlumn_update=new PubConlumn();
			//pic属性,						普通字符串
			String old_pic = pubConlumn_next.getPic();
			String new_pic =image_url_convert(old_pic);
			pubConlumn_update.setPic(new_pic);
			
			serializContext.updateObject(pubConlumn_next.getId(), pubConlumn_update);
		}
		
		/**
		 * User模型处理
		 */
		Iterator<SerializModel> user_ite = serializContext.findIterable(new User());
		while(user_ite.hasNext()) {
			User user_next = (User) user_ite.next();
			User user_update=new User();
			//picname属性,						普通字符串
			String old_pic = user_next.getPicname();
			String new_pic =image_url_convert(old_pic);
			user_update.setPicname(new_pic);
			
			serializContext.updateObject(user_next.getId(), user_update);
		}
		
	
		
	}
	
	
	/**
	 * 原始的图片处理
	 * @return	处理后的新的图片的路径
	 */
	public String image_url_convert(String old_image_url) {
		/**
		 * @TODO	马朝华
		 */
		return old_image_url+"?id=123456";
	}
	
	
	
	
	/**
	 * 正则表达式更换src的值并返回更换后的结果
	 */
	public String content_replace(String old_content) {
		String new_content=new String(old_content);
		Pattern img_p = Pattern.compile("<(img|IMG)(.*?)(/>|></img>|>)");        
		Matcher img_m = img_p.matcher(old_content);        
		boolean img_result = img_m.find();        
		if (img_result) {            
			while (img_result) {                
				//获取到匹配的的内容   img            
				String img_str = img_m.group();                
				//开始匹配src                
				Pattern src_p = Pattern.compile("(src|SRC)=(\"|\')(.*?)(\"|\')");     
				Matcher src_m = src_p.matcher(img_str);               
				if (src_m.find()) {                    
					String src_str = src_m.group();  
					String old_src_path=src_str.substring(src_str.indexOf("=")+2,src_str.length()-1);
					new_content=new_content.replaceAll(old_src_path, image_url_convert(old_src_path));
					}                
				//匹配content中是否存在下一个<img />标签，有则继续以上步骤匹配<img />标签中的src                
				img_result = img_m.find();           
					}       
				}
		return new_content;
		
	}
	
	
	
	
}
