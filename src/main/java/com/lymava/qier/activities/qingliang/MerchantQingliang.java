package com.lymava.qier.activities.qingliang;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.InputStream;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.ServletContext;

import org.apache.struts2.ServletActionContext;

import com.google.gson.JsonObject;
import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.base.util.WebConfigContent;
import com.lymava.commons.state.State;
import com.lymava.commons.util.ImageUtil;
import com.lymava.commons.util.JsonUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.commons.util.QrCodeUtil;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.nosql.mongodb.vo.BaseModel;
import com.lymava.wechat.gongzhonghao.Gongzonghao;
import com.lymava.wechat.gongzhonghao.GongzonghaoContent;

/**
 * 商户清凉成绩
 * @author lymava
 *
 */
public class MerchantQingliang extends BaseModel{

	/**
	 * 
	 */
	private static final long serialVersionUID = -7009338364857849286L;

	/**
	 * 商户
	 */
	private User user_merchant;
	/**
	 * 商户系统编号
	 */
	private String userId_merchant; 
	/**
	 * 清凉金额 单位 分
	 */
	private Long price_fen; 
	/**
	 * 结果状态
	 */
	private Integer state; 
	/**
	 * 商家的推广图
	 */
	private String pic;
	/**
	 * 关注二维码
	 */
	private String subscribe_pic;
	
	public void init_subscribe_pic() {
		Gongzonghao defaultGongzonghao = GongzonghaoContent.getMorenGongzonghao();
		
		User user_merchant = this.getUser_merchant();
		
		QingliangShareBusiness gaokaoShareBusiness = new QingliangShareBusiness();
		gaokaoShareBusiness.setDataId(user_merchant.getBianhao()+"");
		
		try {
			
			ServletContext servletContext = ServletActionContext.getServletContext();
			String realPath = servletContext.getRealPath("/");
			
			/**
			 * {"ticket":"gQFu7zwAAAAAAAAAAS5odHRwOi8vd2VpeGluLnFxLmNvbS9xLzAydWdMSUJteC1jVmsxQUd3cmhyY3QAAgQq03NbAwQAjScA","expire_seconds":2592000,"url":"http:\/\/weixin.qq.com\/q\/02ugLIBmx-cVk1AGwrhrct"} 
			 */
			String create_qrcode = defaultGongzonghao.create_qrcode(gaokaoShareBusiness);
			
			JsonObject parseJsonObject = JsonUtil.parseJsonObject(create_qrcode);
			
			String ticket = JsonUtil.getString(parseJsonObject, "ticket");
			String expire_seconds = JsonUtil.getString(parseJsonObject, "expire_seconds");
			String qrcode_url = JsonUtil.getString(parseJsonObject, "url");
			
			BufferedImage  createQrBufferedImage = QrCodeUtil.createQrBufferedImage(qrcode_url, 400);
			
			BufferedImage scaledBufferedImage_156 = ImageUtil.getScaledBufferedImage(createQrBufferedImage, 156, 156);

			
			InputStream resourceAsStream = this.getClass().getResourceAsStream("/com/lymava/qier/activities/qingliang/source/code_base.jpg");
			BufferedImage subscribe_pic_bufferedImage = ImageIO.read(resourceAsStream);
			
			BufferedImage synthesisBufferedImage = ImageUtil.synthesisBufferedImage(subscribe_pic_bufferedImage, scaledBufferedImage_156, 172, 75);
			
			
			ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
			ImageUtil.write(synthesisBufferedImage, byteArrayOutputStream);
			
			subscribe_pic = MyUtil.fileMove(byteArrayOutputStream.toByteArray(), this.getId(), realPath);
		} catch (Exception e) {
			logger.error("生成二维码失败!");
		}
	}
	public void init_pic_tuiguang() {
		
		User user_merchant = this.getUser_merchant();
		
		WebConfigContent instance = WebConfigContent.getInstance();
		String projectPath = instance.getProjectPath();
		
		String share_url = projectPath+"activities/qingliang/?b="+user_merchant.getBianhao();
	
		try {
			
			ServletContext servletContext = ServletActionContext.getServletContext();
			String realPath = servletContext.getRealPath("/");
			
			BufferedImage  createQrBufferedImage = QrCodeUtil.createQrBufferedImage(share_url, 400);
			BufferedImage scaledBufferedImage_156 = ImageUtil.getScaledBufferedImage(createQrBufferedImage, 78, 78);
			
			File tuiguang_pic_file = new File(realPath+pic);
			if(!tuiguang_pic_file.exists()) {
				return;
			}
			BufferedImage subscribe_pic_bufferedImage = ImageIO.read(tuiguang_pic_file);
			
			BufferedImage synthesisBufferedImage = ImageUtil.synthesisBufferedImage(subscribe_pic_bufferedImage, scaledBufferedImage_156, 76, 1169);
			
			ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
			ImageUtil.write(synthesisBufferedImage, byteArrayOutputStream);
			
			pic = MyUtil.fileMove(byteArrayOutputStream.toByteArray(), this.getId(), realPath);
		} catch (Exception e) {
			logger.error("生成二维码失败!");
		}
		
	}
	@Override
	public void parseBeforeSave(Map parameterMap) {
		
		if(MyUtil.isEmpty(subscribe_pic)) {
			this.init_subscribe_pic();
		}else {
			ServletContext servletContext = ServletActionContext.getServletContext();
			String realPath = servletContext.getRealPath("/");
			File tuiguang_pic_file = new File(realPath+subscribe_pic);
			
			if(!tuiguang_pic_file.exists()) {
				this.init_subscribe_pic();
			}
		}
		if(!MyUtil.isEmpty(pic) ) {
			this.init_pic_tuiguang();
		}
	}
	static{
		putConfig(MerchantQingliang.class, "state_"+State.STATE_OK, "正常活动");
		putConfig(MerchantQingliang.class, "state_"+State.STATE_FALSE, "关闭活动"); 
	}
	public String getShowState(){
		 return (String) getConfig("state_"+this.getState());
	}
	public String getPic() {
		return pic;
	}
	public void setPic(String pic) {
		this.pic = pic;
	}
	public void setInPrice_fen(String price_yuan) {
		Double parseDoubleNull = MathUtil.parseDoubleNull(price_yuan);
		if(parseDoubleNull == null){
			return;
		}

		price_fen = MathUtil.multiply(parseDoubleNull, 100).longValue();
	}
	public Integer getState() {
		return state;
	}
	public void setState(Integer state) {
		this.state = state;
	}
	public User getUser_merchant() {
		if (user_merchant == null && MyUtil.isValid(this.userId_merchant)) {
			user_merchant = (User) ContextUtil.getSerializContext().get(User.class, userId_merchant);
		}
		return user_merchant;
	}
	public void setUser_merchant(User user_merchant) {
		if (user_merchant != null) {
			userId_merchant = user_merchant.getId();
		}
		this.user_merchant = user_merchant;
	}
	public String getUserId_merchant() {
		return userId_merchant;
	}
	public void setUserId_merchant(String userId_merchant) {
		this.userId_merchant = userId_merchant;
	}
	public Long getShowPriceYuan() {
		if(price_fen == null) {
			price_fen = 0l;
		}
		Long price_yuan_all = MathUtil.divide(price_fen, 100).longValue();
		return price_yuan_all;
	}
	public Long getPrice_fen() {
		return price_fen;
	}
	public void setPrice_fen(Long price_fen) {
		this.price_fen = price_fen;
	} 
	/**
	 * @param changeFen	单位分
	 */
	public void price_fen_change(Integer changeFen){
		MerchantQingliang merchantQingliang_update = new MerchantQingliang();
		if(this.price_fen == null){
			merchantQingliang_update.addCommand(MongoCommand.set, "price_fen", changeFen);
		}else{
			merchantQingliang_update.addCommand(MongoCommand.jiaDengyu, "price_fen", changeFen);
		}
		ContextUtil.getSerializContext().commandUpdateObject(MerchantQingliang.class,this.getId(), merchantQingliang_update);
	}
	public String getSubscribe_pic() {
		return subscribe_pic;
	}
	public void setSubscribe_pic(String subscribe_pic) {
		this.subscribe_pic = subscribe_pic;
	}
	
}
