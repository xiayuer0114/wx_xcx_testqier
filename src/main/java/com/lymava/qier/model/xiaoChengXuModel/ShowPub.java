package com.lymava.qier.model.xiaoChengXuModel;

import com.lymava.base.model.Pub;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.util.HttpUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.vo.NullBasicDBList;
import com.lymava.qier.model.Merchant72;
import com.lymava.qier.model.MerchantPub;
import com.lymava.qier.util.WeiHtmlProcess;
import com.mongodb.BasicDBList;
import org.apache.struts2.ServletActionContext;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

public class ShowPub extends Pub {

    /**
     * 商家id
     */
    private String merchant72_Id;

    /**
     * 商家实体
     */
    private Merchant72 merchant72;

    /**
     * 标题
     */
    private String title;

    /**
     * 副标题
     */
    private String subhead;

    /**
     * 视频连接
     */
    private String video;

    /**
     * 收藏字段  这是一个临时字段
     */
    private Integer beCollected;
    public static Integer beCollected_yes = 1;
    public static Integer beCollected_no = 0;

    /**
     * 人均消费  偏移分
     */
    private Long avg;
    private static Long avgPianyi = 100L;

    /**
     * 经度
     */
    private Double longitude;

    /**
     * 纬度
     */
    private Double latitude;

    /**
     * 经纬度集合
     */
    private BasicDBList location;

    /**
     * 背景   (生活圈背景)
     */
    private String background;

    /**
     * 头像轮播背景集合  (商家正文页头像后面的背景)
     */
    private BasicDBList headPics;

    /**
     * 使用的红包的人数
     */
    private Integer useRenshu;

    /**
     * 置顶项
     */
    private String zhiDing;

    /**
     * 使用规则, 这是一段文字说明
     */
    private String usageRule;

    /**
     * 所在城市
     */
    private String suozaiCity;





    // 人均  in/show
    public void setInAvg(double avg) {
        this.avg = (long)(avg*avgPianyi);
    }
    public String getShowAvg() {
        if(this.getAvg() == null){
            return "0.0";
        }
        return (((double)this.getAvg())/avgPianyi)+"";
    }

        // 标签 in
    public void setInTagString(String[] test){
        StringBuilder tag_string_builder = new StringBuilder();

        for (String tag_string:test){
            tag_string_builder.append(tag_string+"_");
        }
        this.setTag_string(tag_string_builder.toString());
    }

        // 置顶 in
    public void setInZhiDing(String[] test){
        StringBuilder tag_string_builder = new StringBuilder();

        for (String tag_string:test){
            tag_string_builder.append(tag_string+"_");
        }
        this.setZhiDing(tag_string_builder.toString());
    }

        // 经纬度数组  in/show
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
        // 在保存商家id的时候 把商家经纬度集合 也保存好
    public void setInMerchant72_Id(String merchant72_Id){
        this.merchant72_Id = merchant72_Id;


        if(this.location != null &&  this.location.size() ==2 ){
            if( ((Double)this.location.get(0)).equals(0D) && ((Double)this.location.get(1)).equals(0D) ){
                if(MyUtil.isValid(merchant72_Id)){
                    Merchant72 merchant72 = (Merchant72)ContextUtil.getSerializContext().get(Merchant72.class, merchant72_Id);
                    if(merchant72 != null){
                        this.setLocation(merchant72.getLocation());
                    }
                }
            }
        }

    }

        // 商家实体 get/set
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

        // 头像背景集合  in
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

        // 设置经纬度
    public void setInLongitude(Double longitude) {
            if(location == null) {
                location = new BasicDBList();
                location.add(longitude);
            }else if(location.size() == 0){
                location.add(longitude);
            }else if(location.size() >= 1){
                location.set(0, longitude);
            }
            this.longitude = longitude;
        }
    public void setInLatitude(Double latitude) {
        if(location == null || location.size() == 0) {
            location = new BasicDBList();
            location.add(0);
            location.add(latitude);
        }else if(location.size() == 1){
            location.add(latitude);
        }else if(location.size() > 1){
            location.set(1, latitude);
        }
        this.latitude = latitude;
    }



    @Override
    public void parseBeforeSearch(Map parameterMap) {
        String tag_string = HttpUtil.getParemater(parameterMap,"tag_string");
        if(!MyUtil.isEmpty(tag_string)){
            this.addCommand("$regex", "tag_string", "^.*"+tag_string+".*$");
        }

        String zhiDing = HttpUtil.getParemater(parameterMap,"zhiDing");
        if(!MyUtil.isEmpty(zhiDing)){
            this.addCommand("$regex", "zhiDing", "^.*"+zhiDing+".*$");
        }
    }

    @Override
    public void parseBeforeSave(Map parameterMap) {

        String readData = this.getContent();

        String process_weixin_html = WeiHtmlProcess.process_update_img_Style(readData);

        process_weixin_html = WeiHtmlProcess.process_img_addStyle_haveTwoImg(process_weixin_html);

        process_weixin_html = WeiHtmlProcess.process_remove_a(process_weixin_html);

        this.setContent(process_weixin_html);
    }






    // get/set


    public String getSuozaiCity() {
        return suozaiCity;
    }

    public void setSuozaiCity(String suozaiCity) {
        this.suozaiCity = suozaiCity;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }

    public String getUsageRule() {
        return usageRule;
    }

    public void setUsageRule(String usageRule) {
        this.usageRule = usageRule;
    }

    public String getZhiDing() {
        return zhiDing;
    }

    public void setZhiDing(String zhiDing) {
        this.zhiDing = zhiDing;
    }

    public String getVideo() {
        return video;
    }

    public void setVideo(String video) {
        this.video = video;
    }

    public String getBackground() {
        return background;
    }

    public void setBackground(String background) {
        this.background = background;
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

    public String getSubhead() {
        return subhead;
    }

    public void setSubhead(String subhead) {
        this.subhead = subhead;
    }

    public Integer getBeCollected() {
        return beCollected;
    }

    public void setBeCollected(Integer beCollected) {
        this.beCollected = beCollected;
    }

    public Long getAvg() {
        return avg;
    }

    public void setAvg(Long avg) {
        this.avg = avg;
    }

    public BasicDBList getLocation() {
        return location;
    }

    public void setLocation(BasicDBList location) {
        this.location = location;
    }

    public BasicDBList getHeadPics() {
        return headPics;
    }

    public void setHeadPics(BasicDBList headPics) {
        this.headPics = headPics;
    }

    public Integer getUseRenshu() {
        return useRenshu;
    }

    public void setUseRenshu(Integer useRenshu) {
        this.useRenshu = useRenshu;
    }
}
