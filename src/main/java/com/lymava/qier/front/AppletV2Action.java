package com.lymava.qier.front;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.lymava.base.action.BaseAction;
import com.lymava.base.model.*;
import com.lymava.base.util.ContextUtil;
import com.lymava.base.util.WebConfigContent;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.pay.PayFinalVariable;
import com.lymava.commons.state.State;
import com.lymava.commons.state.StatusCode;
import com.lymava.commons.util.*;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.nosql.util.PageSplit;
import com.lymava.nosql.util.QuerySort;
import com.lymava.qier.action.CashierAction;
import com.lymava.qier.action.MerchantShowAction;
import com.lymava.qier.activities.model.Daka;
import com.lymava.qier.business.BusinessIntIdConfigQier;
import com.lymava.qier.model.*;
import com.lymava.qier.model.xiaoChengXuModel.*;
import com.lymava.qier.service.ActionUtil;
import com.lymava.qier.util.AES;
import com.lymava.qier.util.DiLiUtil;
import com.lymava.qier.util.SunmingUtil;
import com.lymava.trade.base.model.Business;
import com.lymava.trade.base.model.BusinessIntIdConfig;
import com.lymava.trade.pay.model.PaymentRecord;
import com.lymava.trade.pay.model.PaymentRecordOperationRecord;
import com.lymava.wechat.gongzhonghao.GongzonghaoContent;
import com.mongodb.BasicDBList;
import com.mongodb.BasicDBObject;
import org.apache.commons.lang3.StringUtils;
import org.bson.types.ObjectId;

import java.io.IOException;
import java.text.DecimalFormat;
import java.util.*;
import java.util.Base64;

public class AppletV2Action extends BaseAction {

    /**
     * 实例化action的帮助类
     */
    ActionUtil actionUtil = new ActionUtil();


    /**
     * 格式化double数据   米和千米的显示   目前有两个地方在用  loadMerchants(4_0) 和  getOnePubById(5)   孙M  6.28
     */
    DecimalFormat df_m = new DecimalFormat("#");
    DecimalFormat df_km = new DecimalFormat("#.0");



    /**
     * 检查登录
     *
     * @return
     */
    public User72 check_login_user() {

        String userId = request.getParameter("userId");
        String key_sign = request.getParameter("token");
        String randCode = request.getParameter("randCode");

        User72 user72 = (User72) serializContext.get(User72.class,userId);
        String key = user72.getKey();
        String key_find = Md5Util.MD5Normal(key+randCode);

        CheckException.checkIsTure(key_find.equals(key_sign),"用户信息错误");

        return user72;
    }


    // 距离配置
    private static Double juli = 3.0D;

    // 推荐卡底部图片
    private static String url_tuijiankaPic= "tuijianla.jpg";

    // "我的"底部图片
    private static String url_wodePic= "wode.jpn";

    // "我的" 背景图片
    private static String url_wodeBackground= "background.jpg";

    // 签到 的背景图片
    private static String url_signInBackground= "background.jpg";

    // 使用规则 的背景图片
    private static String url_shiyongguize= "background.jpg";
    // 使用规则
    private static String shiyongguize= "1: 任意使用";

    // 错误文章id
    private static String errorId= "5b4f098a5ff47d089c373425";
    // 红包使用说明id
    private static String shuoMing= "5b4f098a5ff47d089c373425";
    // 商家id (新用户引导完后, 跳转的商家)
    private static String newUser_merchantId= "5b4f098a5ff47d089c373425";


    // 第一次使用小程序得奖励
    private static Long firstUse = 0L;

    // 商家详情页
    private static String isMerchant= "pages/mylive/detail";
    // 正文详情页
    private static String isArticle= "pages/recommend/detail";

    private static String activityUrl= "www.yorz.vip";



    // 得到一个经纬度所在的城市
    private Map getCityName(Double longitude_now, Double latitude_now , String message){
        String response = null;
        try {
            response = DiLiUtil.latitude_and_longitude_analysis(longitude_now,latitude_now);
        } catch (Exception e) {
            e.printStackTrace();
        }
        JsonObject response_json = JsonUtil.parseJsonObject(response);

        String status = JsonUtil.getRequestString(response_json, "status");
        String cityName = "重庆市";
        if("0".equals(status)){
            JsonObject result_json = JsonUtil.getRequestJsonObject(response_json, "result");
            JsonObject address_component_json = JsonUtil.getRequestJsonObject(result_json, "address_component");
            cityName = JsonUtil.getRequestString(address_component_json, "city");
        }else {
            message += " 获取城市位子失败(第一次):"+response_json;
            if(longitude_now!=null && latitude_now!= null){
                try {
                    response = DiLiUtil.latitude_and_longitude_analysis(longitude_now,latitude_now);
                    response_json = JsonUtil.parseJsonObject(response);
                    status = JsonUtil.getRequestString(response_json, "status");
                    if("0".equals(status)){
                        JsonObject result_json = JsonUtil.getRequestJsonObject(response_json, "result");
                        JsonObject address_component_json = JsonUtil.getRequestJsonObject(result_json, "address_component");
                        cityName = JsonUtil.getRequestString(address_component_json, "city");
                    }else{
                        message += " 获取城市位子失败(第二次):"+response_json;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        Map<String,String> map = new HashMap<String,String>();
        map.put("cityName",cityName);
        map.put("message",message);

        return map;
    }
    // 得到一个城市的节点id   传入成都市 就得到成都的节点id   错误或为空时得到的是重庆的id
    private String getCityId(String cityName){

        String id = ConfigPub.getChongqing();

        if (MyUtil.isEmpty(cityName)){
            return  id;
        }

        PubConlumn pubConlumn_find = new PubConlumn();
        pubConlumn_find.setState(PubConlumn.state_nomal);
        pubConlumn_find.setFatherPubConlumnId(ConfigPub.getQuyu());
        pubConlumn_find.setName(cityName);

        pubConlumn_find = (PubConlumn)serializContext.get(pubConlumn_find);


        if( pubConlumn_find != null){
            id = pubConlumn_find.getId();
        }

        return id;
    }
    // 得到一个商圈的节点id   传入成都市 就得到成都的节点id   错误或为空时得到的是重庆的id
    private String getShangquanId(String city_NameOrId, String shangQuanName){
        PubConlumn pubConlumn_find = new PubConlumn();
        pubConlumn_find.setState(PubConlumn.state_nomal);
        pubConlumn_find.setFatherPubConlumnId(ConfigPub.getQuyu());
        pubConlumn_find.addCommand(MongoCommand.or, "id", city_NameOrId);
        pubConlumn_find.addCommand(MongoCommand.or, "name", city_NameOrId);

        pubConlumn_find = (PubConlumn)serializContext.get(pubConlumn_find);


        String id = ConfigPub.getChongqing();
        if( pubConlumn_find != null){
            id = pubConlumn_find.getId();
        }

        return id;
    }
    // 得到两点的距离(曲线距离:驾车的距离)
    private Double getDistance(Double latitude_1, Double longitude_1, Double latitude_2, Double longitude_2){

        if (latitude_1 == null || longitude_1 == null || latitude_2 == null || longitude_2 == null){
            return 0D;
        }



        String mode = "driving";
        String dis_info = null;
        try {
            dis_info = DiLiUtil.getDistance(latitude_1,longitude_1,latitude_2,longitude_2,mode);
        } catch (IOException e) {
            e.printStackTrace();
        }

        JsonObject dis_json = JsonUtil.parseJsonObject(dis_info);

        String status = JsonUtil.getRequestString(dis_json, "status");

        if(!"0".equals(status)){
            return 0D;
        }

        JsonObject result_json = JsonUtil.getRequestJsonObject(dis_json, "result");

        JsonArray elements_json = JsonUtil.getRequestJsonArray(result_json, "elements");

        JsonObject one_json  = (JsonObject)elements_json.get(0);

        String distance = JsonUtil.getRequestString(one_json, "distance");

        Long distance_long = MathUtil.parseLong(distance);

        Double distance_doble = (double)distance_long;

        return distance_doble;
    }






    /**
     * 加载小程序的相关配置
     * sunm1
     * @return
     */
    public String loadConfig(){

        ConfigPub configPub_find = new ConfigPub();
        configPub_find.setPubConlumnId(ConfigPub.getXiaochengxupeizhi());

        // 得到小程序的配置
        List<ConfigPub> configPubList = serializContext.findAll(configPub_find);

        JsonObject jsonObject = new JsonObject();

        for(ConfigPub configPub_out : configPubList){
            String key = configPub_out.getKey();
            String value = configPub_out.getValue();
            String pic = configPub_out.getPic();

            if( "JuLiPeiZhi".equals(key) &&  !MyUtil.isEmpty(value) ){
                if (MathUtil.parseDoubleNull(value) != null){
                    juli = MathUtil.parseDoubleNull(value);
                }
            }
            if( "TuiJianKaDiBuTuPian".equals(key) &&  !MyUtil.isEmpty(pic) ){
                url_tuijiankaPic = pic;
            }
            if( "woDeDiBuTuPian".equals(key) &&  !MyUtil.isEmpty(pic) ){
                url_wodePic = pic;
            }
            if( "woDeBeiJing".equals(key) &&  !MyUtil.isEmpty(pic) ){
                url_wodeBackground = pic;
            }
            if( "signInBg".equals(key) &&  !MyUtil.isEmpty(pic) ){
                url_signInBackground = pic;
            }
            if( "firstUse".equals(key) && MathUtil.parseLongNull(value) != null ){
                firstUse = MathUtil.parseLongNull(value)*100;
            }
            if( "errorId".equals(key) && MyUtil.isValid(value)){
                errorId = value;
            }
            if( "shuoMing".equals(key) && MyUtil.isValid(value)){
                shuoMing = value;
            }
            if( "shiYongGuiZe".equals(key) &&  !MyUtil.isEmpty(pic) && !MyUtil.isEmpty(value)){
                url_shiyongguize = pic;
                shiyongguize = value;
            }
            if( "activityUrl".equals(key) && !MyUtil.isEmpty(value)){
                activityUrl = value;
            }
            if( "newUser_merchantId".equals(key) && MyUtil.isValid(value)){
                newUser_merchantId = value;
            }

        }

        jsonObject.addProperty("juli",juli);
        jsonObject.addProperty("url_tuijiankaPic",url_tuijiankaPic);
        jsonObject.addProperty("url_wodePic",url_wodePic);
        jsonObject.addProperty("url_wodeBackground",url_wodeBackground);
        jsonObject.addProperty("url_signInBackground",url_signInBackground);
        jsonObject.addProperty("firstUse",firstUse);
        jsonObject.addProperty("shuoMing",shuoMing);
        jsonObject.addProperty("url_usageRule",url_shiyongguize);
        jsonObject.addProperty("activityUrl",activityUrl);
        jsonObject.addProperty("newUser_merchantId",newUser_merchantId);




        PubConlumn pubConlumn_find = new PubConlumn();
        pubConlumn_find.setFatherPubConlumnId(ConfigPub.getQuyu());
        pubConlumn_find.setState(PubConlumn.state_nomal);

        List<PubConlumn> pubConlumnList_city = serializContext.findAll(pubConlumn_find);

        JsonArray jsonArray_city = new JsonArray();
        for (PubConlumn pubConlumn_out : pubConlumnList_city){
            jsonArray_city.add(pubConlumn_out.getName());
        }

        ShowPub showPub_label = new ShowPub();
        showPub_label.setState(Pub.state_nomal);
        showPub_label.setShenghe(Pub.shenghe_tongguo);
        showPub_label.setPubConlumnId(ConfigPub.getLeixingpeizhi());
        showPub_label.initQuerySort("indexid", QuerySort.desc);

        List<ShowPub> showPubList_label = serializContext.findAll(showPub_label);

        JsonArray jsonArray_label = new JsonArray();
        for (ShowPub showPub_out : showPubList_label){
            jsonArray_label.add(showPub_out.getName());
        }


        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("success");
        this.addField("cityList", jsonArray_city);
        this.addField("labelList", jsonArray_label);
        this.setDataRoot(jsonObject);
        return SUCCESS;
    }



    /**
     *  用户静默登录  上传参数code 通过code去查找用户(先拿到openid在拿用户)  没找到用户根据openid添加一个
     *  sunm2
     * @return
     */
    public String homeLogin()   {

        // 用户敏感信息字符串(AES)
        String encryptedData = this.getParameter("encryptedData");
        // 解密 矢量  iv
        String iv = this.getParameter("iv");
        // 输出信息
        String print_message  = "";

        // 经纬度参数
        String latitude = this.getParameter("latitude");
        String longitude = this.getParameter("longitude");
        print_message +="前端传上来的latitude:"+latitude+" 和longitude:"+longitude+" ";
        Double latitude_now = MathUtil.parseDouble(latitude);
        Double longitude_now = MathUtil.parseDouble(longitude);

        // 这个经纬度对应的城市名
        Map<String,String> cityNameAndMessage = getCityName(longitude_now, latitude_now, print_message);
        String cityName = cityNameAndMessage.get("cityName");
        // 城市名对应的id
        String cityId = getCityId(cityName);
        // 获取城市下的标签
        JsonArray jsonArray_label = getLabelByCityName(cityName);
        print_message = cityNameAndMessage.get("message");


        // 拿到codeId ,  检查codeId
        String code = this.getParameter("code");
        CheckException.checkIsTure(!SunmingUtil.strIsNull(code),"登录失败!  (code is null)");

        String openId  = null;
        String session_key  = null;
        String unionid  = null;

        String jscode2session ;
        try {
            jscode2session = GongzonghaoContent.getMorenGongzonghao().jscode2session(code);

            JsonObject user_access_token_jsonObject =  JsonUtil.parseJsonObject(jscode2session);

            openId  = JsonUtil.getRequestString(user_access_token_jsonObject, "openid");
            session_key  = JsonUtil.getRequestString(user_access_token_jsonObject, "session_key");
            unionid  = JsonUtil.getRequestString(user_access_token_jsonObject, "unionid");

        } catch (Exception e) {
            logger.error("获取小程序用户信息失败!", e);
        }
        CheckException.checkIsTure(!MyUtil.isEmpty(openId), "登录失败! (openid is null)");


        // 不能对unionid检测
//        CheckException.checkIsTure(!MyUtil.isEmpty(unionid), "登录失败! (unionid is null)");

        User72 user_find_out = null;

        if(!MyUtil.isEmpty(unionid)) {
            User72 user_find = new User72();
            user_find.setUserGroupId(CashierAction.getCommonUserGroutId());
            user_find.setUnionid(unionid);

            user_find_out = (User72) ContextUtil.getSerializContext().get(user_find);
        }

        if(user_find_out == null && !MyUtil.isEmpty(openId)) {
            // 通过openid 拿到一个用户  判断用户的是否为空  不为空判断他的状态  为空根据他的openid去添加一条
            User72 user_find = new User72();
            user_find.setUserGroupId(CashierAction.getCommonUserGroutId());
            user_find.setXiaochengxu_openid(openId);

            user_find_out = (User72) ContextUtil.getSerializContext().get(user_find);

            if(user_find_out != null && MyUtil.isEmpty(user_find_out.getUnionid()) && !MyUtil.isEmpty(unionid)) {

                User72 user72_update = new User72();
                user72_update.setUnionid(unionid);

                serializContext.updateObject(user_find_out.getId(), user72_update);
                
	        	//小程序登录有unoinid 的时候检查并合并账户
	        	user_find_out.setUnionid(unionid);
	        	user_find_out.check_repeat_and_all_in_one();
            }
        }


        ZhuanZengRecord zhuanZengRecord_find = new ZhuanZengRecord();
        zhuanZengRecord_find.setNewOpenId(openId);
        zhuanZengRecord_find.setState(ZhuanZengRecord.state_wait);

        List<ZhuanZengRecord> zhuanZengRecordList = serializContext.findAll(zhuanZengRecord_find, pageSplit);
        for (ZhuanZengRecord zhuanZengRecord_out : zhuanZengRecordList){
            ZhuanZengRecord zhuanZengRecord_update = new ZhuanZengRecord();
            zhuanZengRecord_update.setState(ZhuanZengRecord.state_yes);
            //todo
//            serializContext.updateObject(zhuanZengRecord_out.getId(), zhuanZengRecord_update);
        }


        JsonObject jsonObject = new JsonObject();
        // 不为空  检查状态
        if ( user_find_out != null){
            CheckException.checkIsTure(User.STATE_OK.equals(user_find_out.getState()),"用户状态异常");


            Integer isNewUser = user_find_out.getNewUser();

            // 如果是新用户 ,  更新
            if (!User72.newUser_false.equals(isNewUser)){
                isNewUser = User72.newUser_true;
                user_find_out.chang_to_oldUser();
            }

            jsonObject = actionUtil.user_login_ok(jsonObject,user_find_out,request);
            jsonObject.addProperty("cityName",cityName);
            jsonObject.addProperty("isNewUser",isNewUser);
            jsonObject.addProperty("print_message",print_message);
            jsonObject.add("label_list",jsonArray_label);
            this.setStrutsOutString(jsonObject);
            return SUCCESS;
        }

        // 添加用户
        User72 user72_add = new User72();

        user72_add.setXiaochengxu_openid(openId);
        user72_add.setState(User.STATE_OK );
        user72_add.setUserGroupId(CashierAction.getCommonUserGroutId());
        user72_add.setUsername(openId);
        user72_add.setNickname("微信用户");
        user72_add.setThird_user_type(User.third_user_type_weixin);
        user72_add.setRealname("微信用户_小程序");
        user72_add.setShare_balance(User.share_balance_no);
        user72_add.setKey(Md5Util.MD5Normal("sunMing"+System.currentTimeMillis()));
        user72_add.setUnionid(unionid);


        // 设置编号   调用方法生成编号,然后设置值
        WebConfigContent instance = WebConfigContent.getInstance();
        Long newUser_huiyuan_last_id = instance.getNewUser_huiyuan_last_id();
        user72_add.setBianhao(newUser_huiyuan_last_id);

        ContextUtil.getSerializContext().save(user72_add);

        User72 user72_new  = (User72)serializContext.get(user72_add);
        CheckException.checkIsTure(user72_new != null,"程序错误");
        user72_new.chang_to_oldUser();  // 马上改变'自己'为老用户

        if(  !(firstUse == 0L || firstUse.equals(0L))  ){
            // 添加用户成功  为这个用户发送一个红包
            PaymentRecord wallet_amount_paymentRecord  = new PaymentRecordOperationRecord();

            wallet_amount_paymentRecord.setId(new ObjectId().toString());
            wallet_amount_paymentRecord.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_newUser);
            wallet_amount_paymentRecord.setPay_method(PayFinalVariable.pay_method_balance);
            wallet_amount_paymentRecord.setPrice_fen_all(firstUse);
            wallet_amount_paymentRecord.setUserId_huiyuan(user72_new.getId());
            wallet_amount_paymentRecord.setState(State.STATE_PAY_SUCCESS);
            wallet_amount_paymentRecord.setRequestFlow(new ObjectId().toString());
            wallet_amount_paymentRecord.setMemo("新用户首次使用小程序得奖励");

            // 保存这次业务交易
            serializContext.save(wallet_amount_paymentRecord);
            Business.checkRequestFlow(wallet_amount_paymentRecord);

            // 用户余额变动
            user72_new.balanceChangeFen(firstUse);
        }


        jsonObject = actionUtil.user_login_ok(jsonObject, user72_new, request);
        jsonObject.addProperty("isNewUser",User72.newUser_true);
        jsonObject.addProperty("cityName",cityName);
        jsonObject.addProperty("print_message",print_message);
        jsonObject.add("label_list",jsonArray_label);
        this.setStrutsOutString(jsonObject);
        return SUCCESS;
    }

    // 根据城市名字找到 城市下对应的标签
    public String getLabel(){

        String cityName = this.getParameter("cityName");
        CheckException.checkIsTure(!MyUtil.isEmpty(cityName), "没有城市名");

        JsonArray jsonArray_label = getLabelByCityName(cityName);

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setStatusCode("success");
        this.addField("labelList",jsonArray_label);
        return SUCCESS;
    }

    // 根据城市名字找到 城市下对应的标签
    private JsonArray getLabelByCityName(String cityName){

        JsonArray jsonArray_lable = new JsonArray();
        if(MyUtil.isEmpty(cityName)){
            return jsonArray_lable;
        }

        // 获取城市下的标签
        ShowPub showPub_find = new ShowPub();
        showPub_find.setSuozaiCity(cityName);
        showPub_find.setState(Pub.state_nomal);
        showPub_find.setShenghe(Pub.shenghe_tongguo);
        showPub_find.initQuerySort("indexid", QuerySort.desc);
        Iterator<ShowPub> showPubIterator = serializContext.findIterable(showPub_find);

        while (showPubIterator.hasNext()){
            ShowPub showPub_tmp = showPubIterator.next();
            if (showPub_tmp.getName() != null){
                jsonArray_lable.add(showPub_tmp.getName());
            }
        }
        return jsonArray_lable;
    }




    /**
     * 加载推荐卡(首页)的内容
     * sunm3
     * @return
     */
    public String loadTuiJianKa(){
        // 分页
        String page = this.getParameter("page");
        String pageSize = this.getParameter("pageSize");
        pageSplit = new PageSplit(page,pageSize);

        // 当前位置获取
        String latitude = this.getParameter("latitude");
        String longitude = this.getParameter("longitude");
        Double latitude_now = MathUtil.parseDouble(latitude);
        Double longitude_now = MathUtil.parseDouble(longitude);

        //选择的城市
        String cityName = this.getParameter("cityName");
        CheckException.checkIsTure(!MyUtil.isEmpty(cityName), "cityName 不能为空");

        PubConlumn pubConlumn_find = new PubConlumn();
        pubConlumn_find.setFatherPubConlumnId(ConfigPub.getTuijianka());
        pubConlumn_find.setName(cityName);
        pubConlumn_find = (PubConlumn) serializContext.get(pubConlumn_find);

        // 查询设置
        LinkPub linkPub_find = new LinkPub();

        linkPub_find.setState(Pub.state_nomal);
        linkPub_find.setShenghe(Pub.shenghe_tongguo);
        linkPub_find.setSecondPubConlumnId(ConfigPub.getTuijianka());
        linkPub_find.initQuerySort("indexid", QuerySort.desc);
        if(pubConlumn_find != null){
            linkPub_find.setPubConlumnId(pubConlumn_find.getId());
        }

        List<LinkPub> linkPubList = serializContext.findAll(linkPub_find, pageSplit);

        // 设置返回数据
        JsonArray jsonArray = new JsonArray();
        for(LinkPub linkPub_out : linkPubList){
            ShowPub showPub = (ShowPub)linkPub_out.getPub_link();
            if (showPub == null){ continue; }
            Merchant72 merchant72 = showPub.getMerchant72();
            if (merchant72 == null){ continue; }
            if(  !Pub.state_nomal.equals(showPub.getState()) ){ continue; }
            if(  !Pub.shenghe_tongguo.equals(showPub.getShenghe()) ){ continue; }

            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("pubId",showPub.getId());
            jsonObject.addProperty("url",isMerchant);
            jsonObject.addProperty("headPortrait",merchant72.getPicname());
            jsonObject.addProperty("pubName",merchant72.getNickname());
            jsonObject.addProperty("headBackground",linkPub_out.getHeadBg());
            jsonObject.addProperty("title","About."+merchant72.getNickname());
            jsonObject.addProperty("pubIntro",showPub.getIntro());
            jsonObject.addProperty("addr",merchant72.getAddr());



            BasicDBList dbList_pic = linkPub_out.getHeadPics();
            JsonArray jsonArray_Pics = new JsonArray();
            if (dbList_pic != null){
                for (Object showPic : linkPub_out.getHeadPics()){
                    jsonArray_Pics.add(showPic+"");
                }
            }
            jsonObject.add("showPic",jsonArray_Pics);

            String showDistance = "距您较近";
            Double dis = merchant72.getDistance(latitude_now, longitude_now);
            if (dis/1000 > juli){showDistance = "距您较远";}

            jsonObject.addProperty("showDistance",showDistance);
            jsonObject.addProperty("latitude",merchant72.getLatitude());
            jsonObject.addProperty("longitude",merchant72.getLongitude());

            jsonArray.add(jsonObject);
        }


        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("success");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }


    /**
     * 搜索框
     * sunm4
     * @return
     */
    public String loadPubBySearch(){
        // 分页设置
        String page = request.getParameter("page");
        String pageSize = request.getParameter("pageSize");
        pageSplit = new PageSplit(page,pageSize);

        // 搜索类容
        String searchBody = request.getParameter("searchBody");

        // 设置查询
        ShowPub showPub_find = new ShowPub();

        showPub_find.setShenghe(MerchantPub.shenghe_tongguo);
        showPub_find.setState(MerchantPub.state_nomal);
        showPub_find.addCommand(MongoCommand.in, "secondPubConlumnId", ConfigPub.getZhuanti());
        showPub_find.addCommand(MongoCommand.in, "secondPubConlumnId", ConfigPub.getQuyu());

            // 值为"searchBody"的一个模糊查询
        BasicDBObject basicDBObject_regx = new BasicDBObject();
        basicDBObject_regx.put("$regex", "^.*"+searchBody+".*$");

        showPub_find.addCommand(MongoCommand.or, "name", basicDBObject_regx);   //  文章名 包含搜索条件
        showPub_find.addCommand(MongoCommand.or, "tag_string", basicDBObject_regx); //  商家类型 包含搜索条件
        showPub_find.addCommand(MongoCommand.or, "title", basicDBObject_regx);  //  标题 包含搜索条件  孙M 6.26
        showPub_find.addCommand(MongoCommand.or, "intro", basicDBObject_regx);  //  简介 包含搜索条件  孙M 6.26

        List<ShowPub> showPubList = serializContext.findAll(showPub_find,pageSplit);

        // 设置返回数据
        JsonArray jsonArray = new JsonArray();
        for (ShowPub showPub_out : showPubList){
            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("pubId",showPub_out.getId());
            jsonObject.addProperty("pubName",showPub_out.getName());
            jsonObject.addProperty("pubIntro",showPub_out.getIntro());
            String url = isArticle;
            if (ConfigPub.getQuyu().equals(showPub_out.getSecondPubConlumnId())){
                url = isMerchant;
            }
            jsonObject.addProperty("url",url);

            jsonArray.add(jsonObject);
        }

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("success");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }



    // 加载 一个商品类型的 banner图信息  sunm5
    public String loadShengHuoQuanBanner(){
        // 标签名参数
        String name = this.getParameter("labelName");
        CheckException.checkIsTure(!MyUtil.isEmpty(name), "labelName 不能为空");
        // 获取城市名
        String cityName = this.getParameter("cityName");
        CheckException.checkIsTure(!MyUtil.isEmpty(cityName), "cityName 不能为空");

        // 设置查询
        ShowPub showPub_find = new ShowPub();

        //showPub_find.setShenghe(Pub.shenghe_tongguo);  // 商圈的审核设置为的是审核未通过
        showPub_find.setState(Pub.state_nomal);
        showPub_find.setPubConlumnId(ConfigPub.getLeixingpeizhi());
        showPub_find.setName(name);
        showPub_find.setSuozaiCity(cityName);


        showPub_find = (ShowPub)serializContext.get(showPub_find);
        CheckException.checkIsTure(showPub_find!=null, "根据labelName没有找到信息");

        // 设置返回数据
        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("id",showPub_find.getId());
        jsonObject.addProperty("pic",showPub_find.getBackground());
        jsonObject.addProperty("url",isArticle);
        if (showPub_find.getAvg() != null && showPub_find.getUseRenshu() != null ){
            jsonObject.addProperty("url",isMerchant);
        }

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("success");
        this.setDataRoot(jsonObject);
        return SUCCESS;
    }

    // 加载 商圈列表  sunm5_1
    public String loadShangQuan(){
        // 分页
        String page = this.getParameter("page");
        String pageSize = this.getParameter("pageSize");
        pageSplit = new PageSplit(page, pageSize);

        // 当前经纬度
        String latitude = this.getParameter("latitude");
        String longitude = this.getParameter("longitude");
        Double latitude_now = MathUtil.parseDouble(latitude);
        Double longitude_now = MathUtil.parseDouble(longitude);

        // 获取城市id
        String cityName = this.getParameter("cityName");
        String cityId = getCityId(cityName);

        // 得到这个城市下 所有的商圈
        PubConlumn pubConlumn_find =  new PubConlumn();
        pubConlumn_find.setState(PubConlumn.state_nomal);
        pubConlumn_find.setFatherPubConlumnId(cityId);
        pubConlumn_find.initQuerySort("indexid", QuerySort.desc);
        List<PubConlumn> pubConlumnList =  serializContext.findAll(pubConlumn_find,pageSplit);

        // 去找到每个商圈下 用于展示的那一条数据  name = "root_"+name+"_show"
        JsonArray jsonArray = new JsonArray();
        for (PubConlumn pubConlumn : pubConlumnList){

            ShowPub showPub_city = new ShowPub();
            showPub_city.setState(Pub.state_nomal);
            showPub_city.addCommand(MongoCommand.budengyu,"shenghe",Pub.shenghe_tongguo);
            showPub_city.setPubConlumnId(pubConlumn.getId());
            showPub_city.setName("root_"+pubConlumn.getName()+"_show");

            showPub_city = (ShowPub)serializContext.get(showPub_city);
            if (showPub_city == null){ continue;}
            if (showPub_city.getMerchant72() == null){ continue;}

            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("id",showPub_city.getId());
            jsonObject.addProperty("url", "");
            jsonObject.addProperty("headBackground",showPub_city.getBackground());
            jsonObject.addProperty("shangQuanName",pubConlumn.getName());
            jsonObject.addProperty("title_one",showPub_city.getTitle());

            // Double dis = getDistance(latitude_now,longitude_now,showPub_city.getMerchant72().getLatitude(),showPub_city.getMerchant72().getLongitude());
            Double dis = getDistance(latitude_now,longitude_now,showPub_city.getLatitude(),showPub_city.getLongitude());
            // String title_two = df_km.format((dis/1000))+"km "+pubConlumn.getName();
            String title_two = df_km.format((dis/1000))+"km ";
            if(!MyUtil.isEmpty(showPub_city.getSubhead())){
                title_two += " | "+showPub_city.getSubhead();
            }

            // 红包使用人数,  如果手动设置了红包使用人数,就取手动输入的, 没有就取累加商户的
            Integer useRed_renshu = showPub_city.getUseRenshu();
            if(useRed_renshu == null || useRed_renshu==0){
                ShowPub showPub_hongbao = new ShowPub();
                showPub_hongbao.setPubConlumnId(pubConlumn.getId());
                showPub_hongbao.setState(Pub.state_nomal);
                showPub_hongbao.setShenghe(Pub.shenghe_tongguo);

                Iterator<ShowPub> showPubIterator = serializContext.findIterable(showPub_hongbao);

                while(showPubIterator.hasNext()){
                    ShowPub showPub = showPubIterator.next();
                    Merchant72 merchant72 = showPub.getMerchant72();
                    if(merchant72.getUseRed_renshu() != null ){
                        useRed_renshu += merchant72.getUseRed_renshu();
                    }
                }
            }

            jsonObject.addProperty("title_two",title_two);
            jsonObject.addProperty("renShu",useRed_renshu); // 得到这个使用红包的人数

            jsonArray.add(jsonObject);
        }

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("success");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }

    // 加载一个 商圈 下对应的商家信息  sunm5_2
    public String loadMerchantBySQ(){
        // 分页
        String page = this.getParameter("page");
        String pageSize = this.getParameter("pageSize");
        pageSplit = new PageSplit(page, pageSize);

        // 当前经纬度
        String latitude = this.getParameter("latitude");
        String longitude = this.getParameter("longitude");
        Double latitude_now = MathUtil.parseDouble(latitude);
        Double longitude_now = MathUtil.parseDouble(longitude);

        // 选择的城市
        String cityName = this.getParameter("cityName");
        CheckException.checkIsTure(!MyUtil.isEmpty(cityName), "cityName不能为空");
        String cityId = getCityId(cityName);

        // 选择的商圈
        String shangQuanName = this.getParameter("shangQuanName");
        CheckException.checkIsTure(!MyUtil.isEmpty(shangQuanName), "shangQuanName不能为空");

        // 找到这个城市下对应的这个商圈的id   重庆市-->鎏嘉码头
        PubConlumn pubConlumn_find = new PubConlumn();
        pubConlumn_find.setState(PubConlumn.state_nomal);
        pubConlumn_find.setFatherPubConlumnId(cityId);
        pubConlumn_find.setName(shangQuanName);
        pubConlumn_find = (PubConlumn) serializContext.get(pubConlumn_find);

        // 设置查询 在这个商圈下的商家
        ShowPub showPub_find = new ShowPub();
        showPub_find.setState(Pub.state_nomal);
        showPub_find.setShenghe(Pub.shenghe_tongguo);
        showPub_find.setSecondPubConlumnId(ConfigPub.getQuyu());
        showPub_find.setIs_sort(false);
        MongoCommand.nearSphere(showPub_find, longitude_now, latitude_now);
        if(pubConlumn_find != null ){
            showPub_find.setPubConlumnId(pubConlumn_find.getId());
        }

        List<ShowPub> showPubList = serializContext.findAll(showPub_find,pageSplit);

        // 设置返回数据
        JsonArray jsonArray = new JsonArray();
        for (ShowPub showPub_out : showPubList){
            Merchant72 merchant72 = showPub_out.getMerchant72();
            if(merchant72 == null ){ continue; }
            if( !User.STATE_OK.equals(merchant72.getState() )){ continue; }

            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("id",showPub_out.getId());
            jsonObject.addProperty("url",isMerchant);
            jsonObject.addProperty("headBackground",showPub_out.getBackground());
            jsonObject.addProperty("title_one",showPub_out.getTitle());

            Double dis = getDistance(latitude_now,longitude_now,merchant72.getLatitude(),merchant72.getLongitude());
            String title_two = df_km.format((dis/1000))+"km "+showPub_out.getPubConlumn().getName()+" | "+merchant72.getNickname();


            Integer useRed_renshu = showPub_out.getUseRenshu();
            if(useRed_renshu == null || useRed_renshu == 0){
                useRed_renshu = merchant72.getUseRed_renshu();
            }

            jsonObject.addProperty("title_two",title_two);
            jsonObject.addProperty("renShu",useRed_renshu); // 得到这个使用红包的人数

            jsonArray.add(jsonObject);
        }

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("success");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }

    // 加载一个 类型 下对应商家信息  sunm5_3
    public String loadShengHuoQuan(){
        // 分页
        String page = this.getParameter("page");
        String pageSize = this.getParameter("pageSize");
        pageSplit = new PageSplit(page, pageSize);

        // 当前经纬度
        String latitude = this.getParameter("latitude");
        String longitude = this.getParameter("longitude");
        Double latitude_now = MathUtil.parseDouble(latitude);
        Double longitude_now = MathUtil.parseDouble(longitude);

        // 城市名
        String cityName = this.getParameter("cityName");
        String cityId = getCityId(cityName);

        // 获取参数 & 检查
        String name = this.getParameter("labelName");
        CheckException.checkIsTure(!MyUtil.isEmpty(name),"labelName不能为空");

        // 设置返回数据
        JsonArray jsonArray = new JsonArray();

        // 分页参数是第一页, 就先去查询置顶的数据(全查询)
        if("1".equals(page)){
            // 查询数据
            ShowPub showPub_find_zhiding = new ShowPub();
            showPub_find_zhiding.setState(MerchantPub.state_nomal);
            showPub_find_zhiding.setShenghe(MerchantPub.shenghe_tongguo);
            showPub_find_zhiding.setThirdPubConlumnId(cityId);
            showPub_find_zhiding.addCommand("$regex", "zhiDing", "^.*"+name+".*$");
            showPub_find_zhiding.initQuerySort("indexid", QuerySort.desc);

            List<ShowPub> showPubList_zhiding =  serializContext.findAll(showPub_find_zhiding);

            for (ShowPub showPub_out : showPubList_zhiding){
                Merchant72 merchant72 = showPub_out.getMerchant72();
                if(merchant72 == null ){ continue; }
                if( !User.STATE_OK.equals(merchant72.getState() )){ continue; }

                JsonObject jsonObject = new JsonObject();
                jsonObject.addProperty("id",showPub_out.getId());
                jsonObject.addProperty("url",isMerchant);
                jsonObject.addProperty("headBackground",showPub_out.getBackground());
                jsonObject.addProperty("title_one",showPub_out.getTitle());

                Double dis = getDistance(latitude_now,longitude_now,merchant72.getLatitude(),merchant72.getLongitude());
                String title_two = df_km.format((dis/1000))+"km "+showPub_out.getPubConlumn().getName()+" | "+merchant72.getNickname();

                Integer useRed_renshu = showPub_out.getUseRenshu();
                if(useRed_renshu == null || useRed_renshu == 0){
                    useRed_renshu = merchant72.getUseRed_renshu();
                }

                jsonObject.addProperty("title_two",title_two);
                jsonObject.addProperty("renShu",useRed_renshu); // 得到这个使用红包的人数

                jsonArray.add(jsonObject);
            }
        }

        // 查询数据  查询没有被置顶的数据
        ShowPub showPub_find = new ShowPub();
        showPub_find.setState(MerchantPub.state_nomal);
        showPub_find.setShenghe(MerchantPub.shenghe_tongguo);
        showPub_find.setThirdPubConlumnId(cityId);
        showPub_find.addCommand("$regex", "tag_string", "^.*"+name+".*$");
        showPub_find.addCommand("$regex", "zhiDing", "^((?!"+name+").)*$");
        showPub_find.setIs_sort(false);
        MongoCommand.nearSphere(showPub_find, longitude_now, latitude_now);

        List<ShowPub> showPubList =  serializContext.findAll(showPub_find, pageSplit);

        // 设置返回数据
        for (ShowPub showPub_out : showPubList){
            Merchant72 merchant72 = showPub_out.getMerchant72();
            if(merchant72 == null ){ continue; }
            if( !User.STATE_OK.equals(merchant72.getState() )){ continue; }

            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("id",showPub_out.getId());
            jsonObject.addProperty("url",isMerchant);
            jsonObject.addProperty("headBackground",showPub_out.getBackground());
            jsonObject.addProperty("title_one",showPub_out.getTitle());

            Double dis = getDistance(latitude_now,longitude_now,merchant72.getLatitude(),merchant72.getLongitude());
            String title_two = df_km.format((dis/1000))+"km "+showPub_out.getPubConlumn().getName()+" | "+merchant72.getNickname();

            Integer useRed_renshu = showPub_out.getUseRenshu();
            if(useRed_renshu == null || useRed_renshu == 0){
                useRed_renshu = merchant72.getUseRed_renshu();
            }

            jsonObject.addProperty("title_two",title_two);
            jsonObject.addProperty("renShu",useRed_renshu); // 得到这个使用红包的人数

            jsonArray.add(jsonObject);
        }


        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("success");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }



    /**
     * 加载 专题
     * sunm6
     * @return
     */
    public String loadZhuanTi(){


        // 分页
        String page = this.getParameter("page");
        String pageSize = this.getParameter("pageSize");
        pageSplit = new PageSplit(page,pageSize);

        String zhuanTiName = this.getParameter("zhuanTiName");

        // 专题的id
        String zhuanTiId = this.getParameter("zhuanTiId");



        List<ShowPub> showPubList = new LinkedList<>();

        if(!MyUtil.isEmpty(zhuanTiName)){
            PubConlumn pubConlumn_find_where = new PubConlumn();
            pubConlumn_find_where.setState(PubConlumn.state_nomal);
            pubConlumn_find_where.setFatherPubConlumnId(ConfigPub.getZhuanti());
            pubConlumn_find_where.setName(zhuanTiName);

            pubConlumn_find_where = (PubConlumn)serializContext.get(pubConlumn_find_where);
            CheckException.checkIsTure(pubConlumn_find_where != null, "没找到专题");

            zhuanTiId = pubConlumn_find_where.getId();

            // 设置查询  没传专题的id就查询所有专题
            ShowPub showPub_find = new ShowPub();
            showPub_find.setState(Pub.state_nomal);
            showPub_find.setShenghe(Pub.shenghe_tongguo);
            showPub_find.setSecondPubConlumnId(ConfigPub.getZhuanti());
            showPub_find.initQuerySort("indexid", QuerySort.desc);
            showPub_find.setPubConlumnId(zhuanTiId);

            showPubList = serializContext.findAll(showPub_find,pageSplit);
        }else {
            showPubList = new LinkedList<>();
            PubConlumn pubConlumn_find = new PubConlumn();
            pubConlumn_find.setFatherPubConlumnId(ConfigPub.getZhuanti());
            pubConlumn_find.initQuerySort("indexid", QuerySort.desc);
            pubConlumn_find.setState(Pub.state_nomal);

            List<PubConlumn> pubConlumnList = serializContext.findAll(pubConlumn_find, pageSplit);
            for (PubConlumn pubConlumn_out : pubConlumnList){
                String pubcName = pubConlumn_out.getName();

                if (MyUtil.isEmpty(pubcName)){continue;}

                ShowPub showPub_find = new ShowPub();
                showPub_find.setState(Pub.state_nomal);
                showPub_find.addCommand(MongoCommand.budengyu,"shenghe",Pub.shenghe_tongguo);
                showPub_find.setName("root_"+pubcName+"_show");

                showPub_find = (ShowPub)serializContext.get(showPub_find );

                if(showPub_find != null){
                    showPub_find.setName( showPub_find.getUsageRule() );
                    showPubList.add(showPub_find);
                }
            }
        }

        // 设置返回数据
        JsonArray jsonArray  = new JsonArray();
        for(ShowPub showPub_out : showPubList){
            JsonObject jsonObject =new JsonObject();
            jsonObject.addProperty("pubId",showPub_out.getId());
            jsonObject.addProperty("url",isArticle);
            jsonObject.addProperty("headBackground",showPub_out.getBackground());
            jsonObject.addProperty("zhuanTiId",showPub_out.getPubConlumn().getId());
            jsonObject.addProperty("zhuanTiName",showPub_out.getPubConlumn().getName());
            jsonObject.addProperty("pubName",showPub_out.getName());

            jsonArray.add(jsonObject);
        }

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("success");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }



    /**
     * 加载  我的钱包
     * sunm7
     * @return
     */
    public String loadMyWallet(){
        // 分页设置
        String page = request.getParameter("page");
        String pageSize = request.getParameter("pageSize");
        pageSplit = new PageSplit(page,pageSize);

        // 用户id
        String userId = request.getParameter("userId");
        CheckException.checkIsTure(MyUtil.isValid(userId) , "请重新登录! (userid is null)",StatusCode.USER_INFO_TIMEOUT);

        User72 user72 = (User72) serializContext.get(User72.class,userId);
        CheckException.checkIsTure(user72 != null , "请重新登录! user72 is null",StatusCode.USER_INFO_TIMEOUT);
        // 获取不到用户的Unionid
        // CheckException.checkIsTure(!MyUtil.isEmpty( user72.getUnionid()  ) , "请重新登录!",StatusCode.USER_INFO_TIMEOUT);
//        String unionid = user72.getUnionid();
//        if(!MyUtil.isEmpty(user72.getXiaochengxu_openid())) {
//            // 通过openid 拿到一个用户  判断用户的是否为空  不为空判断他的状态  为空根据他的openid去添加一条
//            User72 user_find = new User72();
//            user_find.setUnionid(unionid);
//
//            user72 = (User72) ContextUtil.getSerializContext().get(user_find);
//        }

        // 用户余额
        String balance = user72.getShowBalance();

        //设置查询   用户红包
        MerchantRedEnvelope merchantRedEnvelope_find = new MerchantRedEnvelope();
        merchantRedEnvelope_find.setUserId_huiyuan(userId);
        merchantRedEnvelope_find.setState(State.STATE_OK);
        merchantRedEnvelope_find.initQuerySort("index_id", QuerySort.desc);

        List<MerchantRedEnvelope> merchantRedEnvelope_list = serializContext.findAll(merchantRedEnvelope_find,pageSplit);

        // 设置返回数据
        JsonArray jsonArray = new JsonArray();
        for (MerchantRedEnvelope merchantRedEnvelope_out : merchantRedEnvelope_list){

            Merchant72 user_merchant = merchantRedEnvelope_out.getUser_merchant();
            if (user_merchant == null){continue;}
            //不判断商家的状态
            //if ( !User.STATE_OK.equals(user_merchant.getState())){continue;}

            // 获取到这个商家的展示信息
            ShowPub showPub_out = new ShowPub();
            showPub_out.setSecondPubConlumnId(ConfigPub.getQuyu());
            showPub_out.setMerchant72(user_merchant);
            showPub_out.setShenghe(MerchantPub.shenghe_tongguo);
            //不判断状态 显示所有的定向红包对应的merchantPub  在跳转的时候做处理
            //showPub_out.setState(MerchantPub.state_nomal);
            showPub_out = (ShowPub) serializContext.get(showPub_out);

            // 这个红包的金额
            Long amountFen = merchantRedEnvelope_out.getAmountFen();
            Double amountYuan = MathUtil.divide(amountFen, 100).doubleValue();

            // 配置一个'错误'的merchantPub(新的id,后台就没有这条数据.)
            String pubId = new ObjectId().toString();
            Integer merchantState = User.STATE_NOTOK;

            // showPub_out不为空,审核通过,状态正常   user_merchant状态正常,  才设置正确的pubId
            if(showPub_out != null){
                if(Pub.shenghe_tongguo.equals(showPub_out.getShenghe()) && Pub.state_nomal.equals(showPub_out.getState())){
                    if (User.STATE_OK.equals(user_merchant.getState())){
                        pubId = showPub_out.getId();
                        merchantState = User.STATE_OK;
                    }
                }
            }

            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("pubId",pubId);
            jsonObject.addProperty("url",isMerchant);
            jsonObject.addProperty("pic",user_merchant.getPicname());
            jsonObject.addProperty("name",merchantRedEnvelope_out.getRed_envolope_name());
            jsonObject.addProperty("title",amountYuan);
            jsonObject.addProperty("label",merchantRedEnvelope_out.getMerchant_type());
            jsonObject.addProperty("addr",user_merchant.getAddr());
            jsonObject.addProperty("date",merchantRedEnvelope_out.getShowExpiryMonthDay());
            jsonObject.addProperty("merchantState",merchantState);

            String usageRule = shiyongguize;
            if(showPub_out !=null && !MyUtil.isEmpty(showPub_out.getUsageRule())){
                usageRule = showPub_out.getUsageRule();
            }
            jsonObject.addProperty("usageRule",usageRule);

            jsonArray.add(jsonObject);
        }


        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("success");
        this.addField("balance",balance);
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }


    /**
     * 加载  交易明细
     * sunm8
     * @return
     */
    public String loadJiaoYi(){
        // 分页设置
        String page = request.getParameter("page");
        String pageSize = request.getParameter("pageSize");
        pageSplit = new PageSplit(page,pageSize);

        // 用户
        String userId = request.getParameter("userId");
        CheckException.checkIsTure(MyUtil.isValid(userId) , "userId不正确");

        // 设置查询
        PaymentRecord paymentRecord_find = new PaymentRecord();
        paymentRecord_find.setUserId_huiyuan(userId);

        List<PaymentRecord> paymentRecordList = serializContext.findAll(paymentRecord_find, pageSplit);

        // 设置返回数据
        JsonArray jsonArray = new JsonArray();
        for(PaymentRecord paymentRecord_out : paymentRecordList){
            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("name",paymentRecord_out.getBusiness().getBusinessName());

            // 有些订单的支付时间居然是空的?  展示的时候是null
            String date = paymentRecord_out.getShowPayTime();
            if( MyUtil.isEmpty(date) ){
                Long time = SunmingUtil.getlongTimeById(paymentRecord_out.getId());
                date = DateUtil.getSdfFull().format(time);
            }

            jsonObject.addProperty("date",date);
            jsonObject.addProperty("money",paymentRecord_out.getPrice_all_yuan());

            jsonArray.add(jsonObject);
        }

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("success");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }


    /**
     * 加载 红包转赠
     * sunm9
     * @return
     */
    public String loadZhuanZeng(){
        // 分页设置
        String page = request.getParameter("page");
        String pageSize = request.getParameter("pageSize");
        pageSplit = new PageSplit(page,pageSize);

        // 用户
        String userId = request.getParameter("userId");
        CheckException.checkIsTure(MyUtil.isValid(userId) , "userId错误!");

        // 设置查询 可以转赠的红包
        MerchantRedEnvelope merchantRedEnvelope_find = new MerchantRedEnvelope();
        merchantRedEnvelope_find.setUserId_huiyuan(userId);
        merchantRedEnvelope_find.setState(State.STATE_OK);
        merchantRedEnvelope_find.initQuerySort("index_id", QuerySort.desc);

        List<MerchantRedEnvelope> merchantRedEnvelope_list = serializContext.findAll(merchantRedEnvelope_find,pageSplit);

        // 设置返回信息
        JsonArray jsonArray = new JsonArray();
        for (MerchantRedEnvelope merchantRedEnvelope_out : merchantRedEnvelope_list){

            Merchant72 user_merchant = merchantRedEnvelope_out.getUser_merchant();
            if (user_merchant == null){continue;}
            if ( !User.STATE_OK.equals(user_merchant.getState())){continue;}

            // 这个红包的金额
            Long amountFen = merchantRedEnvelope_out.getAmountFen();
            Double amountYuan = MathUtil.divide(amountFen, 100).doubleValue();

            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("redId",merchantRedEnvelope_out.getId());
            jsonObject.addProperty("pic",user_merchant.getPicname());
            jsonObject.addProperty("name",merchantRedEnvelope_out.getRed_envolope_name());
            jsonObject.addProperty("title",user_merchant.getNickname()+" "+amountYuan+"元");
            jsonObject.addProperty("label",merchantRedEnvelope_out.getMerchant_type());

            jsonArray.add(jsonObject);
        }

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("success");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }


    /**
     * 转赠   todo  这个接口需要 和 小程序对接一下
     * sunm9_2
     * @return
     */
    public String zhuanZeng(){
        // 检查登录
        User72 user72 = this.check_login_user();

        // 红包id
        String redId = this.getParameter("redId");
        CheckException.checkIsTure(MyUtil.isValid(redId), "redId 不正确");

        MerchantRedEnvelope merchantRedEnvelope_find = (MerchantRedEnvelope)serializContext.get(MerchantRedEnvelope.class, redId);
        String red_userId = merchantRedEnvelope_find.getUserId_huiyuan();
        CheckException.checkIsTure(user72.getId().equals(red_userId), "这个红包不属于你 ");

        Integer red_state = merchantRedEnvelope_find.getState();
        CheckException.checkIsTure(State.STATE_OK.equals(red_state), "这个红包不能被转赠("+merchantRedEnvelope_find.getShowState()+")");

        // 红包状态修改
        MerchantRedEnvelope merchantRedEnvelope_update = new MerchantRedEnvelope();
        merchantRedEnvelope_update.setState(State.STATE_DONOTKNOW);
//        serializContext.updateObject(red_userId, merchantRedEnvelope_update);

        ZhuanZengRecord zhuanZengRecord_add = new ZhuanZengRecord();
        zhuanZengRecord_add.setRedId(redId);
        zhuanZengRecord_add.setOldOpenId(user72.getXiaochengxu_openid());
        zhuanZengRecord_add.setZhuanzengTime(System.currentTimeMillis());
        zhuanZengRecord_add.setNewOpenId("");  // todo
        zhuanZengRecord_add.setState(ZhuanZengRecord.state_wait);
//        serializContext.save(zhuanZengRecord_add);


        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("success");
        return SUCCESS;
    }


    /**
     * 加载  我的收藏
     * sunm10
     * @return
     */
    public String loadMyCollect(){
        // 分页设置
        String page = request.getParameter("page");
        String pageSize = request.getParameter("pageSize");
        pageSplit = new PageSplit(page,pageSize);

        // 获取用户信息  用于收藏的状态判断
        String userId = request.getParameter("userId");
        CheckException.checkIsTure(MyUtil.isValid(userId),"用户id不正确");

        // 这个用户收藏的列表
        Shoucang shoucang  = new Shoucang();
        shoucang.setUserId(userId);

        List<Shoucang> shoucangs = ContextUtil.getSerializContext().findAll(shoucang,pageSplit);

        // 设置返回数据
        JsonArray jsonArray = new JsonArray();
        for (int j =0; j<shoucangs.size();j++){
            // 得到收藏的pub对象  转换为merchantPub对象  只需要得到商家的收藏(pub对象为空,pub中商家对象为空,进入下一次循环)
            String pubId= shoucangs.get(j).getPub_id();
            ShowPub showPub_find = new ShowPub();
            showPub_find.addCommand(MongoCommand.or, "secondPubConlumnId", ConfigPub.getLeixingpeizhi());
            showPub_find.addCommand(MongoCommand.or, "secondPubConlumnId", ConfigPub.getQuyu());
            showPub_find.addCommand(MongoCommand.or, "secondPubConlumnId", ConfigPub.getZhuanti());
            showPub_find.setId(pubId);

            showPub_find = (ShowPub)serializContext.get(showPub_find);

            if(showPub_find == null){continue;}
            if(!Pub.shenghe_tongguo.equals(showPub_find.getShenghe())){continue;}
            if(!Pub.state_nomal.equals(showPub_find.getState())){continue;}
            String secondId= showPub_find.getSecondPubConlumnId();
            if (! (ConfigPub.getQuyu().equals(secondId) || ConfigPub.getZhuanti().equals(secondId) || ConfigPub.getLeixingpeizhi().equals(secondId)) ){continue;}

            Merchant72 merchant72 = showPub_find.getMerchant72();
            if(merchant72 == null){continue;}
            if(!User.STATE_OK.equals(merchant72.getState())){continue;}
            BasicDBList headPics= showPub_find.getHeadPics();


            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("pubId",showPub_find.getId());
            jsonObject.addProperty("date",shoucangs.get(j).getShowMonthDay());

            //跳转设置
            String url = isArticle;
            String pic = headPics !=null?(headPics.get(0)+""):"";
            jsonObject.addProperty("pic",pic);
            jsonObject.addProperty("name",showPub_find.getTitle());
            jsonObject.addProperty("avg","");
            jsonObject.addProperty("addr","");
            jsonObject.addProperty("label",showPub_find.getPubConlumn().getName());

            if (ConfigPub.getQuyu().equals(secondId)
                    || (showPub_find.getAvg()!=null && showPub_find.getAvg()!= 0L)
                    || (showPub_find.getUseRenshu()!=null && showPub_find.getUseRenshu()!= 0)
                    ){
                url = isMerchant;
                jsonObject.addProperty("pic",merchant72.getPicname());
                jsonObject.addProperty("name",merchant72.getNickname());
                jsonObject.addProperty("avg",showPub_find.getShowAvg());
                jsonObject.addProperty("addr",merchant72.getAddr());
                jsonObject.addProperty("label",merchant72.getMerchant72_type());
            }
            jsonObject.addProperty("url",url);

            jsonArray.add(jsonObject);
        }

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("success");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }



    /**
     * 加载 我的历史消费信息
     * sunm11
     * @return
     */
    public String loadMyPayHistory(){
        // 分页设置
        String page = request.getParameter("page");
        String pageSize = request.getParameter("pageSize");
        pageSplit = new PageSplit(page,pageSize);

        // 判断id
        String userId = request.getParameter("userId");
        CheckException.checkIsTure(MyUtil.isValid(userId),"用户id不正确");

        // 设置查询
        TradeRecord72 tradeRecord72 = new TradeRecord72();
        tradeRecord72.setUserId_huiyuan(userId);
        tradeRecord72.setBusinessIntId(BusinessIntIdConfig.businessIntId_trade);

        List<TradeRecord72> tradeRecord72_list = serializContext.findAll(tradeRecord72,pageSplit);

        // 设置返回数据
        JsonArray jsonArray = new JsonArray();
        for (TradeRecord72 tradeRecord72_out : tradeRecord72_list){
            ShowPub showPub_find = new ShowPub();
            showPub_find.setSecondPubConlumnId(ConfigPub.getQuyu());
            showPub_find.setMerchant72_Id(tradeRecord72_out.getUserId_merchant());
            showPub_find.setShenghe(Pub.shenghe_tongguo);
            showPub_find = (ShowPub) serializContext.get(showPub_find);
            if (showPub_find ==null ){continue;}
            if (showPub_find.getMerchant72() == null){continue;}
            // 这儿不对状态做判断
            Merchant72 merchant72 = tradeRecord72_out.getUser_merchant();

            // showPub_out不为空,审核通过,状态正常   user_merchant状态正常,  才能跳转
            Integer merchantState = User.STATE_NOTOK;
            if(showPub_find != null){
                if(Pub.shenghe_tongguo.equals(showPub_find.getShenghe()) && Pub.state_nomal.equals(showPub_find.getState())){
                    if (User.STATE_OK.equals(merchant72.getState())){
                        merchantState = User.STATE_OK;
                    }
                }
            }

            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("pubId",showPub_find.getId());
            jsonObject.addProperty("url", isMerchant);
            jsonObject.addProperty("pic",merchant72.getPicname());
            jsonObject.addProperty("name",merchant72.getNickname());
            jsonObject.addProperty("label",merchant72.getMerchant72_type());
            jsonObject.addProperty("xiafei",Math.abs(MathUtil.parseDouble(tradeRecord72_out.getPrice_fen_all()+"")/100));
            jsonObject.addProperty("dikou",(MathUtil.parseDouble(tradeRecord72_out.getWallet_amount_payment_fen()+"")/100));
            jsonObject.addProperty("date",tradeRecord72_out.getShowMonthDay());
            jsonObject.addProperty("merchantState",merchantState);


            jsonArray.add(jsonObject);
        }

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("success");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }



    /**
     * 加载  我的签到记录
     * sunm12
     * @return
     */
    public String loadMySignInRecord(){
//        // 现在的时间
//        Long nowTime = System.currentTimeMillis();
//
//        // 今天开始的时间
//        Long nowStartTime = DateUtil.getDayStartTime(nowTime);
//
//        // 昨天开始的时间
//        Long yesterdayTime = nowStartTime - DateUtil.one_day;
//
//        // 用户
//        String userId = request.getParameter("userId");
//        CheckException.checkIsTure(MyUtil.isValid(userId),"用户id不正确");
//
//        // 最后一次成功的签到记录
//        SignInRecord signInRecord_find = new SignInRecord();
//        signInRecord_find.setUserId(userId);
//        signInRecord_find.setState(SignInRecord.sign_state_normal);
//        signInRecord_find.initQuerySort("signStartTime", QuerySort.desc);
//
//        signInRecord_find  = (SignInRecord) serializContext.findOneInlist(signInRecord_find);
//
//        // 签到标记
//        Integer mark = 0;
//        if(signInRecord_find  != null && signInRecord_find.getLianxuMark()!=null){
//            Long lastSignTime = signInRecord_find.getSignStartTime();
//            if(nowStartTime.equals(lastSignTime) || yesterdayTime.equals(lastSignTime)){
//                mark = signInRecord_find.getLianxuMark();
//            }
//        }
//
//        this.setStatusCode(StatusCode.ACCEPT_OK);
//        this.setMessage("success");
//        this.addField("mark",mark);
        return  SUCCESS;
    }




    /**
     * 请求签到
     * sunm13
     * @return
     */
    public String signIn(){

//        // 现在的时间
//        Long nowTime = System.currentTimeMillis();
//
//        // 今天开始的时间
//        Long startTime = DateUtil.getDayStartTime(nowTime);
//
//        // 检查用户
//        User72 user72 = check_login_user();
//
//        // 得到最后一次签到记录
//        SignInRecord signInRecord_find = new SignInRecord();
//        signInRecord_find.setUserId(user72.getId());
//        signInRecord_find.setState(SignInRecord.sign_state_normal);
//        signInRecord_find.initQuerySort("signStartTime", QuerySort.desc);
//
//        signInRecord_find  = (SignInRecord) serializContext.findOneInlist(signInRecord_find);
//
//        // 重复签到
//        if (signInRecord_find != null &&  signInRecord_find.getSignStartTime() != null ){
//            CheckException.checkIsTure( !startTime.equals(signInRecord_find.getSignStartTime()),"您今天已经签到");
//        }
//
//        // 设置连续标记
//        Integer lianxu = 1;
//        if (signInRecord_find != null && signInRecord_find.getLianxuMark() != null && signInRecord_find.getSignStartTime() != null ){
//            Long time = signInRecord_find.getSignStartTime();
//            if(time.equals(startTime-DateUtil.one_day)){
//                lianxu = signInRecord_find.getLianxuMark()+1;
//                lianxu = lianxu==8?1:lianxu;
//                if(lianxu<0 || lianxu>7){
//                    lianxu = 1;
//                }
//            }
//        }
//
//        // 设置得到的奖励
//        Long jifen = 0L;
//        switch (lianxu){
//            case 2:
//                Random rand = new Random();
//                int r = rand.nextInt(11)+5;
//                jifen = SignInRecord.jifen_pianyi * r/10;
//                break;
//            case 5:
//                Random rand2 = new Random();
//                int r2 = rand2.nextInt(10)+16;
//                jifen = SignInRecord.jifen_pianyi * r2/10;
//                break;
//            case 7:
//                Random rand3 = new Random();
//                int r3 = rand3.nextInt(25)+26;
//                jifen = SignInRecord.jifen_pianyi * r3/10;
//                break;
//        }
//
//
//        // 保存签到记录
//        SignInRecord signInRecord_add = new SignInRecord();
//        signInRecord_add.setUserId(user72.getId());
//        signInRecord_add.setSignTime(nowTime);
//        signInRecord_add.setSignStartTime(startTime);
//        signInRecord_add.setState(SignInRecord.sign_state_normal);
//        signInRecord_add.setJifen(jifen);
//        signInRecord_add.setLianxuMark(lianxu);
//
//        serializContext.save(signInRecord_add);
//
//        if (!jifen.equals(0L)){
//            Long yue_balance = 0L;
//            if(user72.getBalance() != null){
//                yue_balance =  user72.getBalance();
//            }
//            PaymentRecord wallet_amount_paymentRecord  = new PaymentRecordOperationRecord();
//
//            wallet_amount_paymentRecord.setId(new ObjectId().toString());
//            wallet_amount_paymentRecord.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_xiaochengxuQianDao);
//            wallet_amount_paymentRecord.setPay_method(PayFinalVariable.pay_method_balance);
//            wallet_amount_paymentRecord.setPrice_fen_all(jifen);
//            wallet_amount_paymentRecord.setUserId_huiyuan(user72.getId());
//            wallet_amount_paymentRecord.setState(State.STATE_PAY_SUCCESS);
//            wallet_amount_paymentRecord.setRequestFlow(new ObjectId().toString());
//            wallet_amount_paymentRecord.setWallet_amount_balance_pianyi(jifen*User.pianyiFen+yue_balance);
//            wallet_amount_paymentRecord.setMemo("小程序签到奖励");
//
//            // 保存这次业务交易
//            serializContext.save(wallet_amount_paymentRecord);
//            Business.checkRequestFlow(wallet_amount_paymentRecord);
//
//            // 用户余额变动
//            user72.balanceChangeFen(jifen);
//        }
//
//        this.setStatusCode(StatusCode.ACCEPT_OK);
//        this.setMessage("签到成功");
//        this.addField("award", ((double)jifen)/SignInRecord.jifen_pianyi);
        return SUCCESS;
    }




    /**
     * 获取一篇文章的详细信息
     * sunm14
     * @return
     */
    public String getOnePubDetail(){
        // 文章id
        String  pubId  = request.getParameter("pubId");
        CheckException.checkIsTure(MyUtil.isValid(pubId),"文章id不正确");

        // 当前位置获取
        String longitude_now_str = request.getParameter("longitude");  // 当前位置的经度
        String latitude_now_str = request.getParameter("latitude");    // 当前位置的纬度
        Double latitude_now = MathUtil.parseDouble(latitude_now_str);
        Double longitude_now = MathUtil.parseDouble(longitude_now_str);

        // 设置查询
        ShowPub showPub_find = new ShowPub();

        showPub_find.setId(pubId);
        //showPub_find.setShenghe(MerchantPub.shenghe_tongguo);  // 有点尴尬
        showPub_find.setState(MerchantPub.state_nomal);
        showPub_find.addCommand(MongoCommand.or, "secondPubConlumnId", ConfigPub.getQuyu());
        showPub_find.addCommand(MongoCommand.or, "secondPubConlumnId", ConfigPub.getZhuanti());
        showPub_find.addCommand(MongoCommand.or, "secondPubConlumnId", ConfigPub.getLeixingpeizhi());


        showPub_find = (ShowPub) serializContext.get(showPub_find);
        if(showPub_find == null){
            showPub_find = (ShowPub) serializContext.get(ShowPub.class, errorId);
        }else {
            if(showPub_find.getMerchant72() == null || !User.STATE_OK.equals( showPub_find.getMerchant72().getState()) ){
                showPub_find = (ShowPub) serializContext.get(ShowPub.class, errorId);
            }
        }

        // 设置返回数据
        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("pubId",showPub_find.getId());
        jsonObject.addProperty("pubTitle",showPub_find.getTitle());
        jsonObject.addProperty("pubSubhead",showPub_find.getSubhead());
        jsonObject.addProperty("video",showPub_find.getVideo());
        jsonObject.addProperty("pubContent",showPub_find.getContent());

        JsonArray jsonArray = new JsonArray();
        String label = showPub_find.getTag_string();

        if(!MyUtil.isEmpty(label)){
            String[] labels = label.split("_");
            for (String la : labels){
                if (MyUtil.isEmpty(la)){continue;}
                jsonArray.add(la);
            }

            if(labels.length<=0){
                jsonArray.add(showPub_find.getPubConlumn().getName());
            }
        }
        jsonObject.add("labelList",jsonArray);


        // 如果是文章的话,没有这些属性
        jsonObject.addProperty("pubPics","");
        jsonObject.addProperty("avg","");
        jsonObject.addProperty("businessHours","");
        jsonObject.addProperty("distance","");
        jsonObject.addProperty("headPortrait", "");
        jsonObject.addProperty("name", "");
        jsonObject.addProperty("addr", "");
        jsonObject.addProperty("longitude", "");
        jsonObject.addProperty("latitude", "");
        jsonObject.addProperty("phone", "");

        if( (ConfigPub.getQuyu().equals(showPub_find.getSecondPubConlumnId())   &&  showPub_find.getMerchant72() != null)
                || errorId.equals(showPub_find.getId())
                || (ConfigPub.getLeixingpeizhi().equals(showPub_find.getSecondPubConlumnId())   &&  showPub_find.getMerchant72() != null && showPub_find.getUseRenshu() !=null && showPub_find.getAvg()!=null && showPub_find.getAvg()!= 0L )
                ){

            Merchant72 merchant72 = showPub_find.getMerchant72();

            BasicDBList dbList_pic = showPub_find.getHeadPics();
            JsonArray jsonArray_Pics = new JsonArray();
            if (dbList_pic != null){
                for (Object showPic : dbList_pic){
                    jsonArray_Pics.add(showPic+"");
                }
            }
            jsonObject.add("pubPics",jsonArray_Pics);  // 头像背景的集合
            jsonObject.addProperty("avg",showPub_find.getShowAvg()); // 人均
            jsonObject.addProperty("businessHours",merchant72.getBusinessHours()); // 营业时间

            // 模型内聚的 获取当前位子(经纬度) 到这个商家的距离
            Double distance_temp = getDistance(latitude_now,longitude_now,merchant72.getLatitude(),merchant72.getLongitude());
            String showDistance = "";
            if (distance_temp<1000D){
                showDistance = df_m.format(distance_temp)+"m";
            }else {
                showDistance = df_km.format((distance_temp/1000))+"km";
            }

            jsonObject.addProperty("distance",showDistance);  // 距离
            jsonObject.addProperty("headPortrait",merchant72.getPicname()); //头像
            jsonObject.addProperty("name",merchant72.getNickname());   // 商家名
            jsonObject.addProperty("addr",merchant72.getAddr());  // 地址
            jsonObject.addProperty("longitude",merchant72.getLongitude()); //这个地址对应的经纬度
            jsonObject.addProperty("latitude",merchant72.getLatitude());//这个地址对应的经纬度
            jsonObject.addProperty("phone",merchant72.getMerchart72Phone());  // 电话
        }


        Integer beCollected = MerchantPub.beCollected_no;


        // 获取用户信息  用于收藏的状态判断
        String userId = request.getParameter("userId");
        if(userId != null){
            CheckException.checkIsTure(MyUtil.isValid(userId),"用户id不正确");
            Shoucang shoucang  = new Shoucang();
            shoucang.setUserId(userId);
            List<Shoucang> shoucangs = ContextUtil.getSerializContext().findAll(shoucang);
            for (int j =0; j<shoucangs.size();j++){
                if(showPub_find.getId().equals(shoucangs.get(j).getPub_id()) ){
                    beCollected = MerchantPub.beCollected_yes;
                }
            }
            jsonObject.addProperty("beCollected",beCollected);   // 收藏状态
        }


        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已返回文章的详细信息");
        this.setDataRoot(jsonObject);
        return SUCCESS;
    }



    /**
     * 收藏
     * sunm15
     * @return
     */
    public String collectOnePub(){

        // 获取用户信息  用于收藏的状态判断
        String userId = request.getParameter("userId");
        CheckException.checkIsTure(MyUtil.isValid(userId),"用户id不正确");

        // 获取想要收藏的pubId
        String pub_id = request.getParameter("pubId");
        CheckException.checkIsTure(MyUtil.isValid(pub_id), "pubId 不正确");
        Pub pub_find_out = Pub.getFinalPub(pub_id);
        CheckException.checkIsTure(pub_find_out != null, "未找到您要操作的内容!");

        Shoucang shoucang_find = new Shoucang();
        shoucang_find.setPub(pub_find_out);
        shoucang_find.setUserId(userId);

        Shoucang serializModel = (Shoucang)serializContext.get(shoucang_find);

        //已经收藏就曲线收藏
        if(serializModel != null){
            serializContext.removeByKey(serializModel);
            this.setStatusCode(StatusCode.ACCEPT_OK);
            this.setMessage("已取消收藏");
            this.addField("handing",202);
            return SUCCESS;
        }

        // 没找到保存一条收藏记录
        Shoucang shoucang_new = new Shoucang();

        shoucang_new.setId(new ObjectId().toString());
        shoucang_new.setPub(pub_find_out);
        shoucang_new.setUserId(userId);
        shoucang_new.setPubConlumnId(pub_find_out.getPubConlumnId());
        shoucang_new.setRootPubConlumnId(pub_find_out.getRootPubConlumnId());
        shoucang_new.setSecondPubConlumnId(pub_find_out.getSecondPubConlumnId());
        shoucang_new.setThirdPubConlumnId(pub_find_out.getThirdPubConlumnId());

        serializContext.save(shoucang_new);

        pub_find_out.shoucang_count();

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("收藏成功");
        this.addField("handing",201);
        return SUCCESS;
    }


    /**
     * 加载广告
     * @return
     */
    public String loadGuangGao(){

        String cityName = this.getParameter("cityName");

        if(MyUtil.isEmpty(cityName)){ cityName = "重庆市"; }

        // 查找一个城市的广告
        LinkPub linkPub_find = new LinkPub();
        linkPub_find.setState(Pub.state_nomal);
        linkPub_find.addCommand(MongoCommand.budengyu, "shenghe", Pub.shenghe_tongguo);
        linkPub_find.setSecondPubConlumnId(ConfigPub.getTuijianka());
        linkPub_find.setName("root_"+cityName+"_ad");

        List<LinkPub> linkPubList  = serializContext.findAll(linkPub_find,pageSplit);

        JsonArray jsonArray = new JsonArray();
        for (LinkPub linkPub_out : linkPubList){
            ShowPub showPub = (ShowPub)linkPub_out.getPub_link();
            if(showPub == null){ continue; }
            if( !Pub.state_nomal.equals( showPub.getState() )){ continue; }
            if( !Pub.shenghe_tongguo.equals(showPub.getShenghe())){ continue; }

            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("pubId",showPub.getId());
            jsonObject.addProperty("pic",linkPub_out.getHeadBg());
            jsonObject.addProperty("url",isArticle);

            if(ConfigPub.getQuyu().equals(showPub.getSecondPubConlumnId())){
                jsonObject.addProperty("url",isMerchant);
            }
            jsonArray.add(jsonObject);
        }

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("success");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }





    private Integer getRenshuById(ShowPub merchantPub){

        // 使用红包的人数, 没有就生成一个100到400的随机数保存
        Random rand = new Random();
        Integer randNumber =rand.nextInt(400 - 100 + 1) + 100;


        if(merchantPub.getUseRenshu() != null &&  merchantPub.getUseRenshu() != 0){
            randNumber = merchantPub.getUseRenshu();
        }else {
            MerchantPub merchantPub_update = new MerchantPub();
            merchantPub_update.setUseRenshu(randNumber);
            serializContext.updateObject(merchantPub.getId(),merchantPub_update);
        }

        return randNumber;
    }








    /**
     * 加载商家类型
     * @return
     */
    public String loadMerchantType(){
        ShowPub showPub_find = new ShowPub();
        showPub_find.setShenghe(Pub.shenghe_tongguo);
        showPub_find.setState(Pub.state_nomal);
        showPub_find.setPubConlumnId(ConfigPub.getLeixingpeizhi());

        List<ShowPub> showPubList = serializContext.findAll(showPub_find);

        JsonArray jsonArray = new JsonArray();
        for(ShowPub showPub_out : showPubList){
            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("id",showPub_out.getId());
            jsonObject.addProperty("labelName",showPub_out.getName());

            jsonArray.add(jsonObject);
        }

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("success");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }
}
