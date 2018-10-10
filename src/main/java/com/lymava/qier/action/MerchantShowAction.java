package com.lymava.qier.action;


import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.lymava.base.action.BaseAction;
import com.lymava.base.model.*;
import com.lymava.base.util.ContextUtil;
import com.lymava.base.util.FinalVariable;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.pay.PayFinalVariable;
import com.lymava.commons.state.StatusCode;
import com.lymava.nosql.model.SerializModel;
import com.lymava.nosql.util.PageSplit;
import com.lymava.qier.model.MerchantPub;
import com.lymava.trade.base.model.BusinessIntIdConfig;
import com.lymava.trade.base.model.BusinessRecord;
import com.lymava.trade.pay.model.PaymentRecord;
import com.lymava.userfront.util.FrontUtil;
import org.bson.types.ObjectId;

import java.util.Iterator;
import java.util.List;

public class MerchantShowAction extends BaseAction {
    // 公众号端的商家主页的请求


    /**
	 *
	 */
	private static final long serialVersionUID = 7183523806383424799L;



    //  根节点: 商家展示
    public static String getRootPubConlumnId(){ return  "5adad5cbd6c4593d38aa3787"; };

	// 美食的PubConlumnId
    public static String getFoodPubConlumnId(){ return "5adad618d6c4593d38aa37a5"; };

    // 娱乐的PubConlumnId
    public static String getRecreationPubConlumnId(){ return "5adad611d6c4593d38aa37a2"; }

    // 推荐的PubConlumnId
    public static String getRecommendPubConlumnId (){ return  "5adad609d6c4593d38aa379f"; }





    // 根节点: 系统类容
    public static String getSysRootPubConlumnId(){ return  "58774e61ef722c095388bd0e";}

    // 活动展示  的PubConlumnId
    public static String getHomePubConlumnId(){ return  "5ae28200c1e9ff1b2c0c3233";}

    //  文章推荐  的PubConlumnId
    public static String getArticleId(){ return  "5afc13a34ce5511c60882b37";}

    //  视频展示  的PubConlumnId
    public static String getVideoId(){ return  "5aff85934ce5511cdc39153a";}

    //  商圈标签配置  的PubConlumnId
    public static String getShangquanId(){ return  "5aff9c284ce5511cdc63a9b7";}

    //  商品类型标签  的PubConlumnId
    public static String getShangPingLeixingId(){ return  "5aff9c0a4ce5511cdc63a9b6";}

    //  消费类型标签  的PubConlumnId
    public static String getXiaoFeiLeiXingId(){ return  "5aff9c014ce5511cdc63a9b5";}

    //  用餐时段标签  的PubConlumnId
    public static String getYongCanShiDuanId(){ return  "5aff9bd44ce5511cdc63a9b1";}



    //  根节点: 积分兑换
    public static String getJifenDuihuanId(){ return "5b029acbceb6e41448f6f7db"; }

    //  兑换代金券的  的PubConlumnId
    public static String getDuihuanVouccherId(){ return "5b02a138ceb6e4144897345a"; }




    // 根节点: 系统外联
    public static String getXiTongWaiLianId(){return "58774e27ef722c095388bd08";};

    // 首页滚动 的PubConlumnId
    public static String getShouYeGunDongId(){return "58774e4eef722c095388bd0c";};

    // 生活圈滚动 的PubConlumnId
    public static String getShengHuoQuanGunDongId(){return "5b06820eceb6e41674d04b62";};

    // 首页视频 的PubConlumnId
    public static String getShouYeShiPinId(){return "5b0b669eceb6e410409cf170";};

    // 首页文章 的PubConlumnId
    public static String getShouYeWenZhangId(){return "5b1cde737d170b4f921951ec";};

    // 生活家文章&视频 的PubConlumnId
    public static String getShengHuoJiaId(){return "5b1cdea07d170b4f921951ed";};













    // 系统商家的id   我们平台自己发的代金券  (72号城市生活   悠择)
    public static String getSysMerchantId(){ return  "5ae2d068c1e9ff2164108dce";}

    /**
     * 收银牌的 跟id
     * @return
     */
    public static String getShouyinpai_pubConlumnId(){ return  "5aa0b2a3ef722c157280a31a";}





    /**
     * 检查登录
     * @return
     */
    public User check_login_user() {
        User init_http_user = FrontUtil.init_http_user(request);
        CheckException.checkIsTure(init_http_user != null, "请先登录!", com.lymava.base.vo.StatusCode.USER_INFO_TIMEOUT);
        return init_http_user;
    }


    /**
     * 公众号上得到pubs数据
     * @return
     */
    public String getMorePub(){

        // 设置查询条件
        MerchantPub merchantPub = new MerchantPub();
        String leibie = (String) request.getSession().getAttribute("leibie");
        int op = 0;
        if ("meishi_1".equals(leibie)){
            merchantPub.setPubConlumnId(getFoodPubConlumnId());
            op = 1;
        }else if ("yule_2".equals(leibie)){
            merchantPub.setPubConlumnId(getRecreationPubConlumnId());
            op = 1;
        }else if ("tuijian_3".equals(leibie)){
            merchantPub.setPubConlumnId(getRecommendPubConlumnId());
            op = 1;
        }
        merchantPub.setRootPubConlumnId(getRootPubConlumnId());
        merchantPub.setState(Pub.state_nomal);
        merchantPub.setShenghe(Pub.shenghe_tongguo);

        // 分页设置
        String page_temp = request.getParameter("page_temp");
        String pageSize_temp = "4";
        PageSplit pageSplit = new PageSplit(page_temp,pageSize_temp);

        // 带条件的 分页 查询
        List<MerchantPub> allPubByPageSplit = ContextUtil.getSerializContext().findAll(merchantPub,pageSplit);

        User user = check_login_user();
        Shoucang shoucang  = new Shoucang();
        shoucang.setUser(user);
        List<Shoucang> shoucangs = ContextUtil.getSerializContext().findAll(shoucang);

        for (int i =0; i<allPubByPageSplit.size();i++){
            for (int j =0; j<shoucangs.size();j++){
                if(allPubByPageSplit.get(i).getId().equals(shoucangs.get(j).getPub_id()) ){
                    allPubByPageSplit.get(i).setBeCollected(MerchantPub.beCollected_yes);
                }
            }
        }

        request.setAttribute("allPubByPageSplit", allPubByPageSplit);

        // 返回op==0是主页的样式   op!=0是其页的样式
        if (op == 0){
            this.setSuccessResultValue("/merchant_show/index_show.jsp");
        }else {
            this.setSuccessResultValue("/merchant_show/fenlei_show_more.jsp");
        }
        return SUCCESS;
    }


    /**
     * 公众号上得到红包数据
     * @return
     */
    public String getMoreRed(){

        User check_login_user = this.check_login_user();

        PaymentRecord paymentRecord_find = new PaymentRecord();


        if(check_login_user != null){
        	paymentRecord_find.setUserId_huiyuan(check_login_user.getId());
        	paymentRecord_find.setBusinessIntId(BusinessIntIdConfig.businessIntId_pay);

            Iterator<PaymentRecord> paymentRecord_ite =  ContextUtil.getSerializContext().findIterable(paymentRecord_find, pageSplit);
            request.setAttribute("paymentRecord_ite", paymentRecord_ite);
        }

        this.setSuccessResultValue("/user_center/my-red-more.jsp");
        return SUCCESS;
    }


    /**
     * 点击小心心收藏这个pub
     * @return
     */
    public String collectPub(){

        String id = request.getParameter("id");

        User user = check_login_user();

        String pub_id = request.getParameter("id");

        Pub pub_find_out = Pub.getFinalPub(pub_id);

        CheckException.checkIsTure(pub_find_out != null, "未找到您要操作的内容!");

        Shoucang shoucang_find = new Shoucang();
        shoucang_find.setPub(pub_find_out);
        shoucang_find.setUser(user);

        SerializModel serializModel = serializContext.get(shoucang_find);

        CheckException.checkIsTure(serializModel == null, "您已收藏!");

        Shoucang shoucang_new = new Shoucang();

        shoucang_new.setId(new ObjectId().toString());
        shoucang_new.setPub(pub_find_out);
        shoucang_new.setUser(user);
        shoucang_new.setPubConlumnId(pub_find_out.getPubConlumnId());
        shoucang_new.setRootPubConlumnId(pub_find_out.getRootPubConlumnId());
        shoucang_new.setSecondPubConlumnId(pub_find_out.getSecondPubConlumnId());
        shoucang_new.setThirdPubConlumnId(pub_find_out.getThirdPubConlumnId());

        serializContext.save(shoucang_new);

        pub_find_out.shoucang_count();

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("收藏成功");
        return SUCCESS;
    }



    /**
     * index页面需要的一个清空session的请求
     * @return
     */
    public String clearSession(){
        request.getSession().setAttribute("leibie","");
        return SUCCESS;
    }


    /**
     * 首页上图片轮播加载的数据
     * @return
     */
    public String getHomePic(){
        MerchantPub merchantPub = new MerchantPub();
        merchantPub.setRootPubConlumnId(MerchantShowAction.getSysRootPubConlumnId());
        merchantPub.setPubConlumnId(MerchantShowAction.getHomePubConlumnId());
        merchantPub.setShenghe(MerchantPub.shenghe_tongguo);
        merchantPub.setState(MerchantPub.state_nomal);

        List<MerchantPub> merchantPubs = ContextUtil.getSerializContext().findAll(merchantPub);

        Gson gson = new Gson();
        String jsonData = gson.toJson(merchantPubs);

        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("jsonData",jsonData);

        this.setStatusCode(StatusCode.ACCEPT_FALSE);
        this.setMessage("已返回首页轮播数据");
        this.setDataRoot(jsonObject);
        return SUCCESS;
    }




}
