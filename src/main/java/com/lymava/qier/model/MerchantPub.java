package com.lymava.qier.model;

import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.nosql.mongodb.vo.NullBasicDBList;
import com.lymava.qier.action.MerchantShowAction;
import org.apache.struts2.ServletActionContext;

import com.lymava.base.model.Pub;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.qier.util.SunmingUtil;
import com.lymava.qier.util.WeiHtmlProcess;
import com.mongodb.BasicDBList;

public class MerchantPub extends Pub {

    /**
	 * 
	 */
	private static final long serialVersionUID = -8554853863408404960L;

	/**
     *  商家的id
     */
    private String merchant72_Id;

    // 商家实体
    private Merchant72 merchant72;

    // 商家logo
    private String merchantLogo;

    private String logo;

    // pub的标题
    private String title;

    // pub的小标题  副标题  用来放摄影师采编的信息
    private String subhead;


    //  收藏的状态
    private Integer beCollected;

    public static Integer beCollected_yes = 1;
    public static Integer beCollected_no = 0;


    //  商圈位置id
    private String shangQuanId;

    //  商家类型 标识  如:酒吧 牛排
    private String merchant72_type;

    //  商品类型
    private String shangPinType;


    // 人均消费  单位分  偏移100
    private Integer avg;


    // 是否需要预约
    private Integer yuyue;

    public static Integer yuyue_no = 200;
    public static Integer yuyue_yes = 300;

    // 在节假日是否可用
    private Integer jiari;

    public static Integer jiari_yes = 200;
    public static Integer jiari_no = 300;

    // 新店配置  几个月内是新店
    private Long xindian;

    // 人气得分
    private Integer renqi;

    // 好评得分
    private Integer haoping;
	/**
	 * 经纬度数组
	 */
	private BasicDBList location;

    /**
     * 头像背景列表
     */
    private BasicDBList headPics;

    /**
     * 使用红包的人数
     */
    private Integer useRenshu;

    /**
     * 头像背景
     */
    private String headBg;






	public Double getLongitude() {
		if(location != null && location.size() > 0) {
			return (Double) location.get(0);
		}
		return null;
	}

	public Double getLatitude() {
		if(location != null && location.size() > 1) {
			return (Double) location.get(1);
		}
		return null;
	}
    public BasicDBList getLocation() {
		return location;
	}

	public void setLocation(BasicDBList location) {
		this.location = location;
	}

	public void setInTagString(String[] test){
        //
        StringBuilder tag_string_builder = new StringBuilder();

        for (String tag_string:test){
            tag_string_builder.append(tag_string+"_");
        }
        this.setTag_string(tag_string_builder.toString());
    }






    // 被重写的get/set方法

    public String getHeadBg() {
        return headBg;
    }

    public void setHeadBg(String headBg) {
        this.headBg = headBg;
    }

    public Merchant72 getMerchant72() {
        if (merchant72 == null && MyUtil.isValid(this.merchant72_Id)) {
            merchant72 = (Merchant72) ContextUtil.getSerializContext().get(Merchant72.class, merchant72_Id);
        }
        return merchant72;
    }

    public void setMerchant72(Merchant72 merchant72) {
        if (merchant72!=null && merchant72.getId()!=null){
            this.setMerchant72_Id(merchant72.getId());
        }
        this.merchant72 = merchant72;
    }

    public String getLogo() {
        if(!SunmingUtil.strIsNull(this.getMerchantLogo())){
            return this.getMerchantLogo();
        }

        if(this.getMerchant72()!=null && this.getMerchant72().getPicname()!=null){
            return this.getMerchant72().getPicname();
        }

        return "merchanr_center/img/log.jpg";
    }

    public int avg_panyi = 100;

    public void setInAvg(double avg) {
        this.avg = (int)(avg*avg_panyi);
    }

    public String getShowAvg() {
        if(this.getAvg() == null){
            return "0.0";
        }
        return (((double)this.getAvg())/avg_panyi)+"";
    }

    public void setInXindian(Integer xin){

        Long sysTime = System.currentTimeMillis();

        Pub pub  = null;
        if(!SunmingUtil.strIsNull( this.id)){
            pub =(Pub) ContextUtil.getSerializContext().get(Pub.class, this.id);
        }
        if (pub != null){ sysTime = pub.getIndexid();}

        xin =   xin==null?1:xin;
        Long xindian  =  xin * DateUtil.one_day * 31;
        Long time_out = sysTime +  xindian;

        this.xindian = time_out;
    }

    public Integer getShowXindian(){
        Long timeRange = this.xindian==null?0:this.xindian - this.getIndexid();
        Integer xin = (int)(timeRange / DateUtil.one_day / 30);

        return xin;
    }

    public void setInHeadPics(String[] picsArray) {

        if(picsArray != null && picsArray.length == 1 ){
            if(picsArray[0].isEmpty()){
                picsArray = null;
            }
        }

        if(picsArray == null || picsArray.length == 0){
            headPics = NullBasicDBList.getInstance();
            return;
        }

        if(picsArray != null && picsArray.length >0){
            if(headPics== null){
                headPics = new BasicDBList();
            }
            for (String string : picsArray) {
                headPics.add(string);
            }
        }
    }



    // 原始的get/set方法


    public Integer getUseRenshu() {
        return useRenshu;
    }

    public void setUseRenshu(Integer useRenshu) {
        this.useRenshu = useRenshu;
    }

    public String getSubhead() {
        return subhead;
    }

    public void setSubhead(String subhead) {
        this.subhead = subhead;
    }

    public BasicDBList getHeadPics() {
        return headPics;
    }

    public void setHeadPics(BasicDBList headPics) {
        this.headPics = headPics;
    }

    public String getMerchantLogo() {
        return merchantLogo;
    }

    public void setMerchantLogo(String merchantLogo) {
        this.merchantLogo = merchantLogo;
    }

    public void setLogo(String logo) {
        this.logo = logo;
    }

    public Integer getBeCollected() {
        return beCollected;
    }

    public void setBeCollected(Integer beCollected) {
        this.beCollected = beCollected;
    }

    public String getMerchant72_Id() {
        return merchant72_Id;
    }

    public void setMerchant72_Id(String merchant72_Id) {
        this.merchant72_Id = merchant72_Id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getShangQuanId() {
        return shangQuanId;
    }

    public void setShangQuanId(String shangQuanId) {
        this.shangQuanId = shangQuanId;
    }

    public String getShowShangQuan() {
        if(MyUtil.isValid(this.shangQuanId)){
            Pub pub = new Pub();
            pub.setState(MerchantPub.state_nomal);
            pub.setShenghe(MerchantPub.shenghe_tongguo);
            pub.addCommand(MongoCommand.in, "pubConlumnId", MerchantShowAction.getShangquanId()); //  系统类容 --> 系统类容 --> 商圈

            pub = (Pub)ContextUtil.getSerializContext().get(pub);
            if (pub != null && pub.getName()!= null){
                return pub.getName();
            }
        }
        return shangQuanId;
    }

    public String getShangPinType() {
        return shangPinType;
    }

    public void setShangPinType(String shangPinType) {
        this.shangPinType = shangPinType;
    }

    public Integer getAvg() {
        return avg;
    }

    public void setAvg(Integer avg) {
        this.avg = avg;
    }

    public Integer getYuyue() {
        return yuyue;
    }

    public void setYuyue(Integer yuyue) {
        this.yuyue = yuyue;
    }

    public Integer getJiari() {
        return jiari;
    }

    public void setJiari(Integer jiari) {
        this.jiari = jiari;
    }

    public Long getXindian() {
        return xindian;
    }

    public void setXindian(Long xindian) {
        this.xindian = xindian;
    }

    public Integer getRenqi() {
        return renqi;
    }

    public void setRenqi(Integer renqi) {
        this.renqi = renqi;
    }

    public Integer getHaoping() {
        return haoping;
    }

    public void setHaoping(Integer haoping) {
        this.haoping = haoping;
    }

    public String getMerchant72_type() {
        return merchant72_type;
    }

    public void setMerchant72_type(String merchant72_type) {
        this.merchant72_type = merchant72_type;
    }

    @Override
    public void parseBeforeSave(Map parameterMap) {

        String  merchant72_Id = this.getMerchant72_Id();
        String pub_id = this.getId();

        //  根据pub的merchantId 得到一条pub数据   (用作判断)
        MerchantPub merchantPub_find_byMerchantId = new MerchantPub();

        merchantPub_find_byMerchantId.setRootPubConlumnId("5adad5cbd6c4593d38aa3787");
        merchantPub_find_byMerchantId.setMerchant72_Id(merchant72_Id);
        merchantPub_find_byMerchantId = (MerchantPub)ContextUtil.getSerializContext().get(merchantPub_find_byMerchantId);

        boolean check_res = merchantPub_find_byMerchantId != null  && !merchantPub_find_byMerchantId.getId().equals(pub_id);

        CheckException.checkIsTure(!check_res,"一个商家只能有一条展示数据");

        ServletContext servletContext = ServletActionContext.getServletContext();
        HttpServletRequest request = ServletActionContext.getRequest();

        String realPath = servletContext.getRealPath("/");
        
    	String basePath = MyUtil.getBasePath(request);

    	String readData = this.getContent();
    	
    	Merchant72 merchant72_tmp = this.getMerchant72();
    	this.setLocation(merchant72_tmp.getLocation());
    	

    	String process_weixin_html = WeiHtmlProcess.process_weixin_html(readData,basePath,realPath, this.getId());
    	this.setContent(process_weixin_html);
    }
}
