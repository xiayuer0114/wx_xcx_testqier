package com.lymava.qier.front;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.lymava.base.action.BaseAction;
import com.lymava.base.model.*;
import com.lymava.base.util.ContextUtil;
import com.lymava.base.util.WebConfigContent;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.state.State;
import com.lymava.commons.state.StatusCode;
import com.lymava.commons.util.*;
import com.lymava.nosql.model.SerializModel;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.nosql.util.PageSplit;
import com.lymava.nosql.util.QuerySort;
import com.lymava.qier.action.CashierAction;
import com.lymava.qier.action.Merchant72Action;
import com.lymava.qier.action.MerchantShowAction;
import com.lymava.qier.model.*;
import com.lymava.qier.service.ActionUtil;
import com.lymava.qier.util.SunmingUtil;
import com.lymava.trade.base.model.BusinessIntIdConfig;
import com.lymava.trade.business.model.TradeRecordOld;
import com.lymava.userfront.util.FrontUtil;
import com.lymava.wechat.gongzhonghao.GongzonghaoContent;
import com.mongodb.BasicDBList;
import com.mongodb.BasicDBObject;

import org.apache.commons.io.output.ByteArrayOutputStream;
import org.bson.types.ObjectId;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.awt.image.ImageObserver;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.DecimalFormat;
import java.util.*;
import java.util.regex.Pattern;

public class AppletAction extends BaseAction{

    /**
	 * 
	 */
	private static final long serialVersionUID = 17833843485518202L;



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



    /**
     *  用户静默登录  上传参数code 通过code去查找用户(先拿到openid在拿用户)  没找到用户根据openid添加一个
     *  todo  ok  1
     * @return
     */
    public String homeLogin(){

            // 拿到codeId ,  检查codeId
        String code = this.getParameter("code");
        CheckException.checkIsTure(!SunmingUtil.strIsNull(code),"登录失败!");
        
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
		
		User72 user_find_out = null;
		
		if(!MyUtil.isEmpty(unionid)) {
			User72 user_find = new User72();
	        user_find.setUnionid(unionid);
	        
	        user_find_out = (User72) ContextUtil.getSerializContext().get(user_find);
		}
		
		if(user_find_out == null && !MyUtil.isEmpty(openId)) {
	        // 通过openid 拿到一个用户  判断用户的是否为空  不为空判断他的状态  为空根据他的openid去添加一条
	        User72 user_find = new User72();
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

        JsonObject jsonObject = new JsonObject();
            // 不为空  检查状态
        if ( user_find_out != null){
            CheckException.checkIsTure(User.STATE_OK.equals(user_find_out.getState()),"用户状态异常");
            jsonObject = actionUtil.user_login_ok(jsonObject,user_find_out,request);
            this.setStrutsOutString(jsonObject);
            return SUCCESS;
        }

        
        User72 user72_add = new User72();
        
        user72_add.setXiaochengxu_openid(openId);
        user72_add.setState(User.STATE_OK );
        user72_add.setUserGroupId(CashierAction.getCommonUserGroutId());
        user72_add.setUsername(openId);
        user72_add.setNickname("微信用户");
        user72_add.setThird_user_type(User.third_user_type_weixin);
        user72_add.setRealname("微信用户");
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
        jsonObject = actionUtil.user_login_ok(jsonObject,user72_new,request);
        this.setStrutsOutString(jsonObject);
        return SUCCESS;
    }
    


    /**
     *  加载 首页/生活圈  轮播的类容
     *  todo  ok  2
     * @return
     */
    String homeGundong = "home";
    String shenghuoquanGundong = "shenghuoquan";
    public String loadPubs(){
        PubLink pubLink_find = new PubLink();
        pubLink_find.setRootPubConlumnId(MerchantShowAction.getXiTongWaiLianId());
        pubLink_find.setShenghe(Pub.shenghe_tongguo);  // 审核通过
        pubLink_find.setState(Pub.state_nomal);  // 状态正常
        pubLink_find.initQuerySort("indexid", QuerySort.desc); // 排序

        String gundong = request.getParameter("gundongType");
        // ↓ 想加载首页的轮播数据
        if(homeGundong.equals(gundong)){ pubLink_find.setPubConlumnId(MerchantShowAction.getShouYeGunDongId()); }
        // ↓ 想加载生活圈的轮播数据
        if(shenghuoquanGundong.equals(gundong)){ pubLink_find.setPubConlumnId(MerchantShowAction.getShengHuoQuanGunDongId()); }

        List<PubLink> pubLink_List = serializContext.findAll(pubLink_find);


        JsonArray jsonArray = new JsonArray();
        for (PubLink pubLink_out : pubLink_List){
            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("pubId",pubLink_out.getPub_link_id());
            jsonObject.addProperty("pubName",pubLink_out.getName());
            jsonObject.addProperty("pubPic",pubLink_out.getPic());

            String mark = pubLink_out.getPub_link().getPubConlumnId();
            if(MerchantShowAction.getRootPubConlumnId().equals(pubLink_out.getPub_link().getRootPubConlumnId())){
                mark =MerchantShowAction.getRootPubConlumnId();
            }
            jsonObject.addProperty("mark",mark);
            jsonArray.add(jsonObject);
        }

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已返回轮播数据");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    };


    /**
     *  (首页)加载首页的那一条视频和生活家的那张图片
     *  todo  ok  2_1
     * @return
     */
    public String loadOneVideo(){

        PubLink pubLink = new PubLink();
        pubLink.setShenghe(MerchantPub.shenghe_tongguo);
        pubLink.setState(MerchantPub.state_nomal);
        pubLink.setPubConlumnId(MerchantShowAction.getShouYeShiPinId());
        pubLink = (PubLink)serializContext.get(pubLink);

        Pub pub = pubLink.getPub_link();

        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("videoId",pub.getId());
        jsonObject.addProperty("videoLink",pub.getLink());
        jsonObject.addProperty("poster",pub.getPic());
        jsonObject.addProperty("pic",pubLink.getPic());

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已返回一条视频和一张图片");
        this.setDataRoot(jsonObject);
        return SUCCESS;
    }


    /**
     * 搜索框的功能
     * todo  ok  2_2
     * @return
     */
    public String loadPubBySearch(){

        // 分页设置
        String page = request.getParameter("page");
        String pageSize = request.getParameter("pageSize");
        pageSplit = new PageSplit(page,pageSize);

        // 搜索类容
        String searchBody = request.getParameter("searchBody");
        
        String shangjia_rootPubConlumnId = MerchantShowAction.getRootPubConlumnId();
        PubConlumn shangjia_pubConlumn = PubConlumn.getPubConlumn(shangjia_rootPubConlumnId);
        
        List<PubConlumn> childrenPubConlumns = shangjia_pubConlumn.getChildrenPubConlumns();

        MerchantPub merchantPub_find = new MerchantPub();
        
        for (PubConlumn pubConlumn : childrenPubConlumns) {
        	// 设置范围     系统类容下的文章推荐/活动页面    商家展示下的所有类容(美食/娱乐/推荐)
        	merchantPub_find.addCommand(MongoCommand.in, "pubConlumnId",pubConlumn.getId());  // 商家展示 的根节点
		}
        
        merchantPub_find.addCommand(MongoCommand.in, "pubConlumnId", MerchantShowAction.getArticleId());         //  系统类容 --> 文章推荐
        merchantPub_find.addCommand(MongoCommand.in, "pubConlumnId", MerchantShowAction.getHomePubConlumnId()); //  系统类容 --> 活动展示
        merchantPub_find.setShenghe(MerchantPub.shenghe_tongguo);
        merchantPub_find.setState(MerchantPub.state_nomal);


        BasicDBObject basicDBObject_regx = new BasicDBObject();
        basicDBObject_regx.put("$regex", "^.*"+searchBody+".*$");

        // 值为"searchBody"的一个模糊查询
        merchantPub_find.addCommand(MongoCommand.or, "name", basicDBObject_regx);   //  文章名 包含搜索条件
        merchantPub_find.addCommand(MongoCommand.or, "merchant72_type", basicDBObject_regx); //  商家类型 包含搜索条件
        merchantPub_find.addCommand(MongoCommand.or, "title", basicDBObject_regx);  //  标题 包含搜索条件  孙M 6.26
        merchantPub_find.addCommand(MongoCommand.or, "intro", basicDBObject_regx);  //  简介 包含搜索条件  孙M 6.26


        List<MerchantPub> merchantPubs = serializContext.findAll(merchantPub_find,pageSplit);

        JsonArray jsonArray = new JsonArray();
        for (MerchantPub merchantPub_out : merchantPubs){
            if (merchantPub_out == null){continue;}
            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("pubId",merchantPub_out.getId());
            jsonObject.addProperty("pubName",merchantPub_out.getName());
            jsonObject.addProperty("pubIntro",merchantPub_out.getIntro());
            String mark = merchantPub_out.getPubConlumnId();
            if (MerchantShowAction.getRootPubConlumnId().equals(merchantPub_out.getRootPubConlumnId())){ mark = merchantPub_out.getRootPubConlumnId(); }
            jsonObject.addProperty("mark",mark);

            jsonArray.add(jsonObject);
        }

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已返回搜索出来的类容");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }



    /**
     *  (首页或者生活圈) 加载首页的多篇文章和视频的简单类容
     *  todo  ok  3
     * @return
     */
    public String loadArticleAndVideo(){
        // 分页设置
        String page = request.getParameter("page");
        String pageSize = request.getParameter("pageSize");
        pageSplit = new PageSplit(page,pageSize);

        // 设置查询条件
        PubLink pubLink = new PubLink();
        pubLink.setState(MerchantPub.state_nomal);
        pubLink.setShenghe(MerchantPub.shenghe_tongguo);
        pubLink.setRootPubConlumnId(MerchantShowAction.getXiTongWaiLianId());   // 系统外联
        pubLink.setPubConlumnId(MerchantShowAction.getShouYeWenZhangId());      //  系统外联下的 首页文章
        pubLink.initQuerySort("indexid", QuerySort.desc);    // 根据 排序时间(indexid) 排序


        String haveVideo = request.getParameter("haveVideo");
        if("200".equals(haveVideo)){
            pubLink.setPubConlumnId(MerchantShowAction.getShengHuoJiaId());   // 系统外联下的  生活家
        }

        List<PubLink> pubLinkList = serializContext.findAll(pubLink,pageSplit);

        JsonArray jsonArray = new JsonArray();
        for (PubLink pubLink_out : pubLinkList){
            Pub pub_temp = pubLink_out.getPub_link();
            if (pub_temp == null){continue;};

            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("pubId",pub_temp.getId());
            jsonObject.addProperty("pubPic",pubLink_out.getPic());
            jsonObject.addProperty("pubName",pubLink_out.getName());
            jsonObject.addProperty("pubIntro",pub_temp.getIntro());
            jsonObject.addProperty("link",pub_temp.getLink());
            jsonObject.addProperty("isVideo",MerchantShowAction.getVideoId().equals(pub_temp.getPubConlumnId())?"200":"300");
            jsonObject.addProperty("mark",pub_temp.getRootPubConlumnId());

            jsonArray.add(jsonObject);
        }

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已返回文章和视频的简单信息");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }




    /**
     *  (生活圈)加载商家得简单信息
     *  todo  ok    4_0
     * @return
     */
    private static Integer page = 0;
    public String loadMerchants(){

        String userId = this.getRequestParameter("userId");
        String page = request.getParameter("page");
        String pageSize = request.getParameter("pageSize");

        String longitude_now_str = request.getParameter("longitude");  // 当前位置的经度
        String latitude_now_str = request.getParameter("latitude");    // 当前位置的纬度

        String shangQuanId = request.getParameter("shangQuanId");  // 商圈

        String remen = request.getParameter("remen");  // 热门
            String renqi = request.getParameter("renqi");  // 热门 --> 人气
            String haoping = request.getParameter("haoping");  // 热门 --> 好评
            String xindian = request.getParameter("xindian");  // 热门 --> 新店

        String fujin = request.getParameter("fujin");

        String pinLeiId = request.getParameter("pinLeiId");

        String shaixuan = request.getParameter("shaixuan");
            String yuyue = request.getParameter("yuyue");     // 免预约
            String jiari = request.getParameter("jiari");    //  节假日可用
            String yongcan = request.getParameter("yongcan");   // 用餐时段
            String xiaofei = request.getParameter("xiaofei");   // 消费类型
            String minRenjun = request.getParameter("minRenjun");      // 人均消费  最低消费
            String maxRenjun = request.getParameter("maxRenjun");      // 人均消费  最高消费

        String tetui = request.getParameter("tetui");   // 特推页传的参数  值200  先准备用来做循环,循环现在前端实现了的

        // 获取用户信息  用于收藏的状态判断
        CheckException.checkIsTure(MyUtil.isValid(userId),"用户id不正确");
        
        User user_find = new User();
        user_find.setId(userId);
        
        user_find = (User)serializContext.get(user_find);
        
        CheckException.checkIsTure(user_find!=null,"没有找到用户信息");

        // 当前位置获取和检查
        Double latitude_now = MathUtil.parseDouble(latitude_now_str);
        Double longitude_now = MathUtil.parseDouble(longitude_now_str);
        
        //校验前端经纬度
		if(latitude_now > longitude_now){
			Double latitude_tmp = longitude_now;
			longitude_now = latitude_now;
			latitude_now = latitude_tmp;
		}


        // 分页设置
        pageSplit = new PageSplit(page,pageSize);

        // 设置查询条件
        MerchantPub merchantPub = new MerchantPub();
        merchantPub.setRootPubConlumnId(MerchantShowAction.getRootPubConlumnId());  //  系统内容下的商家展示
        merchantPub.setShenghe(MerchantPub.shenghe_tongguo);
        merchantPub.setState(MerchantPub.state_nomal);
        merchantPub.initQuerySort("indexid", QuerySort.desc);

        // 传入了 商圈  ↓
        if (shangQuanId != null){
            merchantPub.setShangQuanId(shangQuanId);
        }
        // 传入了品类   ↓
        if(pinLeiId != null){
            merchantPub.setPubConlumnId(pinLeiId);
        }

        String getNod  = StatusCode.ACCEPT_OK.toString();
        
        // 传入了 筛选
        if(getNod.equals(shaixuan)){
        	
        	String regex_str = "^.*["+yongcan+"|"+xiaofei+"].*["+xiaofei+"|"+yongcan+"].*$";
        	
            merchantPub.addCommand("$regex", "tag_string", regex_str);

            if(StatusCode.ACCEPT_OK.equals(MathUtil.parseInteger(yuyue))){
                merchantPub.setYuyue(MathUtil.parseInteger(yuyue));
            }
            if(StatusCode.ACCEPT_OK.equals(MathUtil.parseInteger(jiari))){
                merchantPub.setJiari(MathUtil.parseInteger(jiari));
            }
            if(getNod.equals(xindian)){
                merchantPub.addCommand(MongoCommand.dayuAndDengyu, "xindian", System.currentTimeMillis());
            }
            merchantPub.addCommand(MongoCommand.xiaoyuAndDengyu, "avg", (MathUtil.parseInteger(maxRenjun)*merchantPub.avg_panyi));
            merchantPub.addCommand(MongoCommand.dayuAndDengyu, "avg", (MathUtil.parseInteger(minRenjun)*merchantPub.avg_panyi));
        }

        // 传入了 热门
        if(getNod.equals(remen)){
            if(getNod.equals(renqi)){
                merchantPub.initQuerySort("renqi", QuerySort.desc);
            }
            if(getNod.equals(haoping)){
                merchantPub.initQuerySort("haoping", QuerySort.desc);
            }
            if(getNod.equals(xindian)){
                merchantPub.addCommand(MongoCommand.dayuAndDengyu, "xindian", System.currentTimeMillis());
            }
        }


        JsonArray jsonArray =  new JsonArray();

        List<Merchant72XiaochengxuShowPub> merchant72XiaochengxuShowPubs = new LinkedList<Merchant72XiaochengxuShowPub>();
        List<MerchantPub> merchantPubs = new LinkedList<MerchantPub>();

        // 传入了 附近
        if (getNod.equals(fujin)){
        	
        	merchantPub.setIs_sort(false);
        	//添加查询条件
        	MongoCommand.nearSphere(merchantPub, longitude_now, latitude_now);
            merchantPubs = serializContext.findAll(merchantPub,pageSplit);
        }else {
            merchantPubs = serializContext.findAll(merchantPub,pageSplit);
        }

        
        for (MerchantPub merchant_out : merchantPubs){
            Merchant72 merchant72 = merchant_out.getMerchant72();
            if(merchant72 == null){continue;}
            if(!User.STATE_OK.equals(merchant72.getState())){continue;}  // 商家状态判断

            // 模型内聚的 获取当前位子(经纬度) 到这个商家的距离
            Double distance = merchant72.getDistance(latitude_now,longitude_now);

            // 将商家的临时距离放到用作处理的  Merchant72XiaochengxuShowPub 中
            Merchant72XiaochengxuShowPub merchant72XiaochengxuShowPub = new Merchant72XiaochengxuShowPub();
            merchant72XiaochengxuShowPub.setMerchantPub(merchant_out);
            merchant72XiaochengxuShowPub.setDistance_temp(distance);

            merchant72XiaochengxuShowPubs.add(merchant72XiaochengxuShowPub);
        }

        if (getNod.equals(fujin)){
            Collections.sort(merchant72XiaochengxuShowPubs); // 根据临时距离排序
        }

        
        List<Merchant72XiaochengxuShowPub> merchant72XiaochengxuShowPubs_final_show = merchant72XiaochengxuShowPubs;
        
        if (getNod.equals(fujin)){
        	pageSplit.setCount(merchantPubs.size()*1l);
        	
        	merchant72XiaochengxuShowPubs_final_show = new LinkedList<Merchant72XiaochengxuShowPub>();
        	
        	for(int i=pageSplit.getFirstResult();i<pageSplit.getLastResult() && i<merchant72XiaochengxuShowPubs.size();i++ ) {
        		merchant72XiaochengxuShowPubs_final_show.add(merchant72XiaochengxuShowPubs.get(i));
        	}
        }


        // 现在的merchant72XiaochengxuShowPubs 已经是正确的 不为空的 包含了临时距离的一个集合
        for (Merchant72XiaochengxuShowPub merchant72XiaochengxuShowPub_out : merchant72XiaochengxuShowPubs_final_show){
            Merchant72 merchant72 = merchant72XiaochengxuShowPub_out.getMerchantPub().getMerchant72();
            MerchantPub merchant_out = merchant72XiaochengxuShowPub_out.getMerchantPub();

            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("pubId",merchant_out.getId());
            jsonObject.addProperty("pic",merchant_out.getPic());
            jsonObject.addProperty("headPortrait",merchant72.getPicname());
            jsonObject.addProperty("headBackground",merchant_out.getFile());
            jsonObject.addProperty("pubIntro",merchant_out.getIntro());
            jsonObject.addProperty("name",merchant72.getNickname());
            jsonObject.addProperty("title",merchant_out.getTitle());
            jsonObject.addProperty("avg",merchant_out.getShowAvg());
            jsonObject.addProperty("addr",merchant72.getAddr());

            Double distance_temp = merchant72XiaochengxuShowPub_out.getDistance_temp();


            String showDistance = "";

            if (distance_temp<1000D){
                showDistance = df_m.format(distance_temp)+"m";
            }else {
                showDistance = df_km.format((distance_temp/1000))+"km";
            }

//            jsonObject.addProperty("distance",(int)Math.ceil((distance_temp/1000)));
            jsonObject.addProperty("distance",showDistance);
            jsonObject.addProperty("mark",merchant_out.getRootPubConlumnId());

            BasicDBList dbList_pic = merchant_out.getPics();
            JsonArray jsonArray_Pics = new JsonArray();
            if (dbList_pic != null){
                for (Object showPic : merchant_out.getPics()){
                    jsonArray_Pics.add(showPic+"");
                }
            }
            jsonObject.add("showPic",jsonArray_Pics);

            Shoucang shoucang  = new Shoucang();
            shoucang.setUser(user_find);
            List<Shoucang> shoucangs = ContextUtil.getSerializContext().findAll(shoucang);

            Integer beCollected = MerchantPub.beCollected_no;
            for (int j =0; j<shoucangs.size();j++){
                if(merchant_out.getId().equals(shoucangs.get(j).getPub_id()) ){
                    beCollected = MerchantPub.beCollected_yes;
                }
            }
            jsonObject.addProperty("beCollected",beCollected);

            jsonArray.add(jsonObject);
        }

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已返回商家的简单信息");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }



    private String getHeadBg(String path){
        try {
            String basePath = MyUtil.getBasePath(request);
            URL url = new URL(basePath+path);

            String img_path = request.getRealPath("/attachFiles/temp")+"/"+System.currentTimeMillis()+".jpg";
            File file = new File(img_path);

            // 保存为jpg文件
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(5 * 1000);
            InputStream inStream = conn.getInputStream();
            ByteArrayOutputStream outStream = new ByteArrayOutputStream();
            byte[] buffer = new byte[1024];
            int len = 0;
            while ((len = inStream.read(buffer)) != -1) {
                outStream.write(buffer, 0, len);
            }
            inStream.close();
            FileOutputStream outStream2 = new FileOutputStream(file);
            outStream2.write(outStream.toByteArray());
            outStream2.close();


            BufferedImage b_img = ImageIO.read(file);
            file.delete();


            int p = (int)(b_img.getHeight()*0.2);

            BufferedImage b = ImageUtil.cut_bufferedImage(b_img,0,p/2,b_img.getWidth(),b_img.getHeight()-p);

            ByteArrayOutputStream byteArrayOutputStream1 = new ByteArrayOutputStream();
            ImageUtil.write(b,byteArrayOutputStream1);
            String realPath1 = request.getRealPath("/");
            String temp_pic_path1 = MyUtil.savePic(byteArrayOutputStream1.toByteArray(),realPath1);

            return temp_pic_path1;
        } catch (Exception e){
            e.printStackTrace();
        }
        return path;
    }

    /**
     * 根据id得到一个pub的详细信息  (入口:点击轮播上的东西,点击文章, 点击一个商家的信息)
     * todo  ok 5
     * @return
     */
    public String getOnePubById(){
        // 获取用户信息  用于收藏的状态判断
        String userId = request.getParameter("userId");
        CheckException.checkIsTure(MyUtil.isValid(userId),"用户id不正确");
        
        User user_find = new User();
        user_find.setId(userId);
        user_find = (User)serializContext.get(user_find);

        String  pubId  = request.getParameter("pubId");
        CheckException.checkIsTure(MyUtil.isValid(pubId),"文章id不正确");

        MerchantPub merchantPub_find = new MerchantPub();
        
        merchantPub_find.setId(pubId);
        merchantPub_find.setShenghe(MerchantPub.shenghe_tongguo);
        merchantPub_find.setState(MerchantPub.state_nomal);
        
        merchantPub_find = (MerchantPub) serializContext.get(merchantPub_find);
        
        CheckException.checkIsTure(merchantPub_find!=null,"没有找到对应的信息");


        JsonObject jsonObject = new JsonObject();
        
        jsonObject.addProperty("pubId",merchantPub_find.getId());
        jsonObject.addProperty("pubPic",merchantPub_find.getPic());
        jsonObject.addProperty("pubName",merchantPub_find.getName());
        jsonObject.addProperty("pubIntro",merchantPub_find.getIntro());
        jsonObject.addProperty("pubContent",merchantPub_find.getContent());

        jsonObject.addProperty("headPortrait","");
        jsonObject.addProperty("headBackground","");
        jsonObject.addProperty("name","");
        jsonObject.addProperty("title",merchantPub_find.getIntro());
        jsonObject.addProperty("lable","");
        jsonObject.addProperty("distance","");
        jsonObject.addProperty("avg","");
        jsonObject.addProperty("businessHours","");
        jsonObject.addProperty("addr","");
        jsonObject.addProperty("longitude","");
        jsonObject.addProperty("latitude","");
        jsonObject.addProperty("phone","");

        if(merchantPub_find.getMerchant72() != null){
            // 当前位置获取
            String longitude_now_str = request.getParameter("longitude");  // 当前位置的经度
            String latitude_now_str = request.getParameter("latitude");    // 当前位置的纬度
            Double latitude_now = MathUtil.parseDouble(latitude_now_str);
            Double longitude_now = MathUtil.parseDouble(longitude_now_str);

            Merchant72 merchant72_out = merchantPub_find.getMerchant72();
            jsonObject.addProperty("headPortrait",merchant72_out.getPicname());

            String headBg = merchantPub_find.getFile();

            if (merchantPub_find.getFile() != null && merchantPub_find.getHeadBg() == null){
                headBg = getHeadBg(merchantPub_find.getFile());
                MerchantPub merchantPub_update = new MerchantPub();
                merchantPub_update.setHeadBg(headBg);
                serializContext.updateObject(MerchantPub.class,merchantPub_find.getId(),merchantPub_update);
            }else {
                headBg = merchantPub_find.getHeadBg();
            }

            jsonObject.addProperty("headBackground",headBg);
            jsonObject.addProperty("name",merchant72_out.getNickname());
            jsonObject.addProperty("title",merchantPub_find.getTitle());
            jsonObject.addProperty("lable",merchantPub_find.getShangPinType());


            // 模型内聚的 获取当前位子(经纬度) 到这个商家的距离
            Double distance_temp = merchant72_out.getDistance(latitude_now,longitude_now);


            String showDistance = "";

            if (distance_temp<1000D){
                showDistance = df_m.format(distance_temp)+"m";
            }else {
                showDistance = df_km.format((distance_temp/1000))+"km";
            }

            jsonObject.addProperty("distance",showDistance);

            jsonObject.addProperty("avg",merchantPub_find.getShowAvg());
            jsonObject.addProperty("businessHours",merchant72_out.getBusinessHours());
            jsonObject.addProperty("addr",merchant72_out.getAddr());
            jsonObject.addProperty("longitude",merchant72_out.getLongitude());
            jsonObject.addProperty("latitude",merchant72_out.getLatitude());
            jsonObject.addProperty("phone",merchant72_out.getMerchart72Phone());

        }


        Shoucang shoucang  = new Shoucang();
        shoucang.setUser(user_find);
        List<Shoucang> shoucangs = ContextUtil.getSerializContext().findAll(shoucang);
        Integer beCollected = MerchantPub.beCollected_no;
        for (int j =0; j<shoucangs.size();j++){
            if(merchantPub_find.getId().equals(shoucangs.get(j).getPub_id()) ){
                beCollected = MerchantPub.beCollected_yes;
            }
        }
        jsonObject.addProperty("beCollected",beCollected);



        // 添加浏览记录
        UserBrowseHistory userBrowseHistory = new UserBrowseHistory();
        userBrowseHistory.setUserId(user_find.getId());
        userBrowseHistory.setPubId(merchantPub_find.getId());
        userBrowseHistory.setState(UserBrowseHistory.browse_state_normal);

        UserBrowseHistory history_find = (UserBrowseHistory)serializContext.get(userBrowseHistory);
        userBrowseHistory.setLast_browse_time(System.currentTimeMillis());
        if(history_find != null){
            ContextUtil.getSerializContext().updateObject(history_find.getId(),userBrowseHistory);
        }else {
            serializContext.save(userBrowseHistory);
        }


        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已返回文章的详细信息");
        this.setDataRoot(jsonObject);
        return SUCCESS;
    }



    /**
     * 收藏
     * @return
     * todo  ok 6
     */
    public String collectPub(){

        // 获取用户信息  用于收藏的状态判断
        String userId = request.getParameter("userId");
        CheckException.checkIsTure(MyUtil.isValid(userId),"用户id不正确");
        User user_find = new User();
        user_find.setId(userId);
        user_find = (User)serializContext.get(user_find);

        // 获取想要瘦收藏的pubId
        String pub_id = request.getParameter("pubId");
        Pub pub_find_out = Pub.getFinalPub(pub_id);
        CheckException.checkIsTure(pub_find_out != null, "未找到您要操作的内容!");

        Shoucang shoucang_find = new Shoucang();
        shoucang_find.setPub(pub_find_out);
        shoucang_find.setUser(user_find);

        Shoucang serializModel = (Shoucang)serializContext.get(shoucang_find);

        if(serializModel != null){
            serializContext.removeByKey(serializModel);
            this.setStatusCode(StatusCode.ACCEPT_OK);
            this.setMessage("已取消收藏");
            return SUCCESS;
        }

        Shoucang shoucang_new = new Shoucang();

        shoucang_new.setId(new ObjectId().toString());
        shoucang_new.setPub(pub_find_out);
        shoucang_new.setUser(user_find);
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
     * (我的)  加载我的  收藏
     * todo ok  7
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
        
        User user_find = new User();
        user_find.setId(userId);
        
        user_find = (User)serializContext.get(user_find);


        Shoucang shoucang  = new Shoucang();
        shoucang.setUser(user_find);
        List<Shoucang> shoucangs = ContextUtil.getSerializContext().findAll(shoucang,pageSplit);

        JsonArray jsonArray = new JsonArray();

        for (int j =0; j<shoucangs.size();j++){
            // 得到收藏的pub对象  转换为merchantPub对象  只需要得到商家的收藏(pub对象为空,pub中商家对象为空,进入下一次循环)
        	
            String pubId= shoucangs.get(j).getPub_id();
            
            MerchantPub merchantPub_find = new MerchantPub();
            merchantPub_find.setId(pubId);
            
            merchantPub_find = (MerchantPub)serializContext.get(merchantPub_find);
            if(merchantPub_find == null){continue;}
            
            if(!MerchantPub.shenghe_tongguo.equals(merchantPub_find.getShenghe())){continue;}
            if(!MerchantPub.state_nomal.equals(merchantPub_find.getState())){continue;}
            
            Merchant72 merchant72 = merchantPub_find.getMerchant72();
            if(merchant72 == null){continue;}
            
            if(!User.STATE_OK.equals(merchant72.getState())){continue;}

            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("pubId",merchantPub_find.getId());
            jsonObject.addProperty("pic",merchant72.getPicname());
            jsonObject.addProperty("name",merchant72.getNickname());
            jsonObject.addProperty("avg",merchantPub_find.getShowAvg());
            jsonObject.addProperty("addr",merchant72.getAddr());
            jsonObject.addProperty("label",merchantPub_find.getShangPinType());
            jsonObject.addProperty("date",shoucangs.get(j).getShowMonthDay());
            jsonObject.addProperty("mark",merchantPub_find.getRootPubConlumnId());

            jsonArray.add(jsonObject);
        }

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已返回收藏的商家数据");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }


    /**
     *(我的)   加载我的 浏览记录
     * todo ok   8
     * @return
     */
    public String loadMyBrowseHistory(){
        // 分页设置
        String page = request.getParameter("page");
        String pageSize = request.getParameter("pageSize");
        pageSplit = new PageSplit(page,pageSize);

        // 获取用户信息  用于收藏的状态判断
        String userId = request.getParameter("userId");
        CheckException.checkIsTure(MyUtil.isValid(userId),"用户id不正确");
        User user_find = new User();
        user_find.setId(userId);
        user_find = (User)serializContext.get(user_find);

        UserBrowseHistory his_find = new UserBrowseHistory();
        his_find.setUser(user_find);
        his_find.setState(UserBrowseHistory.browse_state_normal);
        his_find.initQuerySort("last_browse_time", QuerySort.desc);


        List<UserBrowseHistory>  historyList = serializContext.findAll(his_find,pageSplit);

        JsonArray jsonArray = new JsonArray();
        for (UserBrowseHistory history_out : historyList ){
            MerchantPub merchantPub = history_out.getPub();
            if(merchantPub == null){continue;}
            if(!MerchantPub.shenghe_tongguo.equals(merchantPub.getShenghe())){continue;}
            if(!MerchantPub.state_nomal.equals(merchantPub.getState())){continue;}
            Merchant72 merchant72 = merchantPub.getMerchant72();
            if(merchant72 == null){continue;}
            if(!User.STATE_OK.equals(merchant72.getState())){continue;}

            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("pubId",merchantPub.getId());
            jsonObject.addProperty("pic",merchant72.getPicname());
            jsonObject.addProperty("name",merchant72.getNickname());
            jsonObject.addProperty("avg",merchantPub.getShowAvg());
            jsonObject.addProperty("addr",merchant72.getAddr());
            jsonObject.addProperty("label",merchantPub.getShangPinType());
            jsonObject.addProperty("date",history_out.getShowLastTime());
            jsonObject.addProperty("mark",merchantPub.getRootPubConlumnId());


            jsonArray.add(jsonObject);

        }

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已返回浏览记录中的商家数据");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }


    /**
     * 加载我的 历史消费信息
     * todo ok
     * todo     9
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

        TradeRecord72 tradeRecord72 = new TradeRecord72();
        tradeRecord72.setUserId_huiyuan(userId);
//        tradeRecord72.setBusinessIntId(30001);
        tradeRecord72.setBusinessIntId(BusinessIntIdConfig.businessIntId_trade);
//        tradeRecord72.initQuerySort("indexid", QuerySort.desc);

        List<TradeRecord72> tradeRecord72_list = serializContext.findAll(tradeRecord72,pageSplit);

        JsonArray jsonArray = new JsonArray();
        for (TradeRecord72 tradeRecord72_out : tradeRecord72_list){
            MerchantPub merchantPub = new MerchantPub();
            merchantPub.setMerchant72_Id(tradeRecord72_out.getUserId_merchant());
            merchantPub = (MerchantPub) serializContext.get(merchantPub);
            if (merchantPub ==null ){continue;}
            if (merchantPub.getMerchant72() == null){continue;}
            // 这儿不对状态做判断
            Merchant72 merchant72 = tradeRecord72_out.getUser_merchant();

            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("pubId",merchantPub.getId());
            jsonObject.addProperty("pic",merchant72.getPicname());
            jsonObject.addProperty("name",merchant72.getNickname());
            jsonObject.addProperty("lable",merchantPub.getShangPinType());
            jsonObject.addProperty("xiafei",Math.abs(MathUtil.parseDouble(tradeRecord72_out.getPrice_fen_all()+"")/100));
            jsonObject.addProperty("dikou",(MathUtil.parseDouble(tradeRecord72_out.getWallet_amount_payment_fen()+"")/100));
            jsonObject.addProperty("date",tradeRecord72_out.getShowMonthDay());

            jsonArray.add(jsonObject);
        }

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已返回我的消费信息");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }


    /**
     * 加载我的 加载签到记录
     * todo  ok   10
     * @return
     */
    public String loadMySignInRecord(){
        // 判断id
        String userId = request.getParameter("userId");
        CheckException.checkIsTure(MyUtil.isValid(userId),"用户id不正确");


        // 得到月初的时间戳
        Long monthStartLong = SunmingUtil.getCurrentStartMonth(System.currentTimeMillis());

        SignInRecord signInRecord = new SignInRecord();
        signInRecord.setUserId(userId);
        signInRecord = (SignInRecord)SunmingUtil.setQueryWhere_time(signInRecord,monthStartLong,null);

        // 当月签到的集合
        List<SignInRecord> signInRecords = serializContext.findAll(signInRecord);


        JsonArray jsonArray = new JsonArray();
        Integer qiandao = 0;

        Long currentTimeMillis = System.currentTimeMillis();

        for (Long day_start = monthStartLong;  day_start <currentTimeMillis ;day_start += DateUtil.one_day){

            Integer signState = 300;

            JsonObject jsonObject = new JsonObject();
            for (SignInRecord signInRecord_out : signInRecords){
                if(signInRecord_out.getSignStartTime().equals(day_start)){
                    signState = 200;  // 这一天签到
                }
            }
            if(signState.equals(200)){++qiandao;}
            jsonObject.addProperty("is_sign",signState);

            jsonArray.add(jsonObject);

        }

        User72 user72 = new User72();
        user72 = (User72) serializContext.get(User72.class,userId);

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已返回我本月的签到记录");
        this.addField("jifen",user72.getIntegral());
        this.addField("tianshu",qiandao);
        this.setDataRoot(jsonArray);
        return SUCCESS;
    };



    /**
     * 请求签到
     * todo  ok  10_1
     * @return
     */
    public String signIn(){

        User72 user72 = (User72)check_login_user();

        SignInRecord signInRecord = new SignInRecord();
        signInRecord.setUser72(user72);
        signInRecord = (SignInRecord)serializContext.findOneInlist(signInRecord);


        Long sysNowTime = System.currentTimeMillis();
        Long sysNowDayTime = DateUtil.getDayStartTime(sysNowTime);

        SignInRecord signInRecord_add = new SignInRecord();
        signInRecord_add.setUser72(user72);
        signInRecord_add.setSignTime(sysNowTime);
        signInRecord_add.setSignStartTime(sysNowDayTime);
        signInRecord_add.setState(SignInRecord.sign_state_normal);

        Long jifen = 1L;
        if(signInRecord == null){
            // 第一次添加签到记录
            signInRecord_add.setJifen(1L);
            user72.integralChange(1L);
        }else {
            CheckException.checkIsTure(!sysNowDayTime.equals(signInRecord.getSignStartTime()),"您今天已签到");
            if( (sysNowDayTime - signInRecord.getSignStartTime()) <= DateUtil.one_day ){
                jifen = jifen+signInRecord.getJifen();
                jifen = (jifen>=7L?7L:jifen);
            };
            signInRecord_add.setJifen(jifen);
            user72.integralChange(jifen);
        }
        serializContext.save(signInRecord_add);

        User72 user72_getJifen = new User72();
        user72_getJifen = (User72)serializContext.get(User72.class,user72.getId());

        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("jifen",user72_getJifen.getIntegral());

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("成功");
        this.setDataRoot(jsonObject);
        return SUCCESS;
    }


    /**
     *  加载兑换商品的列表
     *  todo   ok  11_0
     * @return
     */
    public String laodForGoods(){

        // 分页设置
        String page = request.getParameter("page");
        String pageSize = request.getParameter("pageSize");
        pageSplit = new PageSplit(page,pageSize);

        JifenDuihuanVoucherPub jifenDuihuanPub = new JifenDuihuanVoucherPub();
        jifenDuihuanPub.setShenghe(Pub.shenghe_tongguo);
        jifenDuihuanPub.setState(MerchantPub.state_nomal);
        jifenDuihuanPub.setRootPubConlumnId(MerchantShowAction.getJifenDuihuanId());
        jifenDuihuanPub.setPubConlumnId(MerchantShowAction.getDuihuanVouccherId());

        List<JifenDuihuanVoucherPub> jifenDuihuanPubs_find = serializContext.findAll(jifenDuihuanPub,pageSplit);


        JsonArray jsonArray = new JsonArray();

        for (JifenDuihuanVoucherPub jifenDuihuanPub_out : jifenDuihuanPubs_find){
            Voucher voucher_out = jifenDuihuanPub_out.getVoucher();

            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("goodId",jifenDuihuanPub_out.getId());
            jsonObject.addProperty("pic",voucher_out.getLogo());
            jsonObject.addProperty("name",jifenDuihuanPub_out.getName());
            jsonObject.addProperty("title",voucher_out.getUser_merchant().getNickname());
            jsonObject.addProperty("content",voucher_out.getVoucherMiaoSu());
            jsonObject.addProperty("needJifen",jifenDuihuanPub_out.getJifen());

            jsonArray.add(jsonObject);
        }

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已返回可以兑换的商品列表");
        this.addField("jifen",79);
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }


    /**
     *  兑换一个商品
     *  todo  ok 11_1
     * @return
     */
    public String getOneGoods(){
        User72 user72 = check_login_user();

        //  兑换的商品 积分 的检查
        String goodId = request.getParameter("goodId");
        CheckException.checkIsTure(!SunmingUtil.strIsNull(goodId),"兑换的商品id为空");
        JifenDuihuanVoucherPub jifenDuihuanVoucherPub = new JifenDuihuanVoucherPub();
        jifenDuihuanVoucherPub.setId(goodId);
        jifenDuihuanVoucherPub.setShenghe(Pub.shenghe_tongguo);
        jifenDuihuanVoucherPub.setState(MerchantPub.state_nomal);
        jifenDuihuanVoucherPub.setRootPubConlumnId(MerchantShowAction.getJifenDuihuanId());  // 积分兑换
        jifenDuihuanVoucherPub.setPubConlumnId(MerchantShowAction.getDuihuanVouccherId());   //  兑换代金券
        jifenDuihuanVoucherPub =(JifenDuihuanVoucherPub) serializContext.get(jifenDuihuanVoucherPub);
        CheckException.checkIsTure(jifenDuihuanVoucherPub != null,"兑换的商品错误");
        CheckException.checkIsTure(user72.getIntegral()>=jifenDuihuanVoucherPub.getJifen(),"您的积分不足!");

        // 代金券的检查  和  数量的减少
        Voucher voucher = jifenDuihuanVoucherPub.getVoucher();
        CheckException.checkIsTure(Voucher.fubu_state_success.equals(voucher.fabuOneVoucher()),"兑换失败");

        // 扣除用户积分
        user72.integralChange((long) -jifenDuihuanVoucherPub.getJifen());

        // 添加 用户代金券记录
        UserVoucher userVoucher = new UserVoucher();
        userVoucher.setVoucher(voucher);
        userVoucher.setVoucherId(voucher.getId());
        userVoucher.setUser_huiyuan(user72);
        userVoucher.setUserId_huiyuan(user72.getId());
        userVoucher.setUserId_merchant(voucher.getTopUserId());
        userVoucher.setUseState(State.STATE_OK);
        serializContext.save(userVoucher);


        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("jifen",user72.getIntegral()-jifenDuihuanVoucherPub.getJifen());

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("兑换成功");
        this.setDataRoot(jsonObject);
        return SUCCESS;
    }


    /**
     *   加载兑换记录
     *   todo   ok   11_2   兑换的东西
     * @return
     */
    public String laodExchangeRecord(){

        // 分页设置
        String page = request.getParameter("page");
        String pageSize = request.getParameter("pageSize");
        pageSplit = new PageSplit(page,pageSize);

        String userId = request.getParameter("userId");
        CheckException.checkIsTure(MyUtil.isValid(userId),"用户id不正确");

        UserVoucher userVoucher = new UserVoucher();
        userVoucher.setUserId_huiyuan(userId);
        userVoucher.initQuerySort("indexid", QuerySort.desc);

        List<UserVoucher> userVouchers = serializContext.findAll(userVoucher,pageSplit);

        JsonArray jsonArray = new JsonArray();
        for (UserVoucher userVoucher_out : userVouchers){
            JsonObject jsonObject = new JsonObject();

            Voucher voucher_out = userVoucher_out.getVoucher();

            jsonObject.addProperty("pic",voucher_out.getLogo());
            jsonObject.addProperty("name","代金券");
            jsonObject.addProperty("title",userVoucher_out.getUser_merchant().getNickname());
            jsonObject.addProperty("content",voucher_out.getVoucherMiaoSu());
            jsonObject.addProperty("date",userVoucher_out.getShowMMddHHmm());

            jsonArray.add(jsonObject);
        }

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已返回兑换记录中的商品列表");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }



    /**
     * 加载  我的
     * todo  ok 12
     * @return
     */
    public String laodMy(){

        // 分页设置
        String page = request.getParameter("page");
        String pageSize = request.getParameter("pageSize");
        pageSplit = new PageSplit(page,pageSize);

        String userId = request.getParameter("userId");
        
        CheckException.checkIsTure(MyUtil.isValid(userId) , "请重新登录!",StatusCode.USER_INFO_TIMEOUT);
        
        User72 user72 = (User72) serializContext.get(User72.class,userId);
        
        CheckException.checkIsTure(user72 != null , "请重新登录!",StatusCode.USER_INFO_TIMEOUT);
//        CheckException.checkIsTure(!MyUtil.isEmpty( user72.getUnionid()  ) , "请重新登录!",StatusCode.USER_INFO_TIMEOUT);
        
 
        
        
        String balance = user72.getShowBalance();

        MerchantRedEnvelope merchantRedEnvelope_find = new MerchantRedEnvelope();
        merchantRedEnvelope_find.setUserId_huiyuan(userId);
        merchantRedEnvelope_find.setState(State.STATE_OK);
        merchantRedEnvelope_find.initQuerySort("index_id", QuerySort.desc);
        List<MerchantRedEnvelope> merchantRedEnvelope_list = serializContext.findAll(merchantRedEnvelope_find,pageSplit);

        JsonArray jsonArray = new JsonArray();
        
        for (MerchantRedEnvelope merchantRedEnvelope_out : merchantRedEnvelope_list){

            Merchant72 user_merchant = merchantRedEnvelope_out.getUser_merchant();
            MerchantPub merchantPub_out = new MerchantPub();
            merchantPub_out.setRootPubConlumnId(MerchantShowAction.getRootPubConlumnId());
            merchantPub_out.setMerchant72(user_merchant);
            merchantPub_out.setShenghe(MerchantPub.shenghe_tongguo);
            merchantPub_out.setState(MerchantPub.state_nomal);
            merchantPub_out = (MerchantPub) serializContext.get(merchantPub_out);
            
            Long amountFen = merchantRedEnvelope_out.getAmountFen();
            Double amountYuan = MathUtil.divide(amountFen, 100).doubleValue();


            String pubId = "5b3dc809d6c4590bcd9994f4";
            String mark = MerchantShowAction.getArticleId();

            if (merchantPub_out != null){
                pubId  = merchantPub_out.getId();
                mark = merchantPub_out.getRootPubConlumnId();
            }

            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("pubId",pubId);
            jsonObject.addProperty("pic",user_merchant.getPicname());
            jsonObject.addProperty("name",merchantRedEnvelope_out.getRed_envolope_name());
            jsonObject.addProperty("title",user_merchant.getNickname()+" "+amountYuan+"元"); 
            jsonObject.addProperty("lable",merchantRedEnvelope_out.getMerchant_type());
            jsonObject.addProperty("addr",user_merchant.getAddr()); 
            jsonObject.addProperty("date",merchantRedEnvelope_out.getShowExpiryMonthDay());
            jsonObject.addProperty("mark",mark);

            jsonArray.add(jsonObject);

        } 
 
        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已返回我的信息");
        this.addField("balance",balance);
        this.addField("userId",userId);
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }



    /**
     * 加载商圈的信息  ↓
     * todo  ok  4_1
     * @return
     */
    public String loadShangQuan(){
        Pub pub = new Pub();
        pub.setState(MerchantPub.state_nomal);
        pub.setShenghe(MerchantPub.shenghe_tongguo);
        pub.addCommand(MongoCommand.in, "pubConlumnId", MerchantShowAction.getShangquanId()); //  系统类容 --> 系统类容 --> 商圈

        List<Pub> pubs =ContextUtil.getSerializContext().findAll(pub);

        JsonArray jsonArray = new JsonArray();
        for (Pub pub_out : pubs){
            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("shangQuanId",pub_out.getId());
            jsonObject.addProperty("pubName",pub_out.getName());
            jsonObject.addProperty("pubPic",pub_out.getPic());

            jsonArray.add(jsonObject);
        }

        request.getSession().setAttribute("shangQuanPubs",pubs);
        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已返回商圈的列表");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }
    /**
     * 加载 品类信息 列表↓
     * todo ok    4_2
     * @return
     */
    public String loadPinLei(){
        PubConlumn pubConlumn = new PubConlumn();
        pubConlumn.setRootPubConlumnId(MerchantShowAction.getRootPubConlumnId());
        pubConlumn.setState(MerchantPub.state_nomal);

        List<PubConlumn> pubs =ContextUtil.getSerializContext().findAll(pubConlumn);

        JsonArray jsonArray = new JsonArray();
        for (PubConlumn pub_out : pubs){
            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("pinLeiId",pub_out.getId());
            jsonObject.addProperty("pubName",pub_out.getName());
            jsonObject.addProperty("pubPic",pub_out.getPic());

            jsonArray.add(jsonObject);
        }

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已返回品类列表");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }



    /**
     * 加载 用餐时段标签 列表↓
     * todo  ok 4_3
     * @return
     */
    public String loadYongCan(){
        Pub pub = new Pub();
        pub.setState(MerchantPub.state_nomal);
        pub.setShenghe(MerchantPub.shenghe_tongguo);
        pub.addCommand(MongoCommand.in, "pubConlumnId", MerchantShowAction.getYongCanShiDuanId()); //  系统类容 --> 系统类容 --> 用餐

        List<Pub> pubs =ContextUtil.getSerializContext().findAll(pub);

        JsonArray jsonArray = new JsonArray();
        for (Pub pub_out : pubs){
            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("yongCanId",pub_out.getId());
            jsonObject.addProperty("pubName",pub_out.getName());

            jsonArray.add(jsonObject);
        }

        request.getSession().setAttribute("yongCanPubs",pubs);
        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已返回用餐时段标签列表");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }
    /**
     * 加载 消费类型标签 列表↓
     *  todo  ok  4_4
     * @return
     */
    public String loadXiaoFei(){
    	
        Pub pub = new Pub();
        
        pub.setState(MerchantPub.state_nomal);
        pub.setShenghe(MerchantPub.shenghe_tongguo);
        pub.addCommand(MongoCommand.in, "pubConlumnId", MerchantShowAction.getXiaoFeiLeiXingId()); //  系统类容 --> 系统类容 --> 消费

        List<Pub> pubs =ContextUtil.getSerializContext().findAll(pub);

        JsonArray jsonArray = new JsonArray();
        for (Pub pub_out : pubs){
            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("xiaoFeiId",pub_out.getId());
            jsonObject.addProperty("pubName",pub_out.getName());

            jsonArray.add(jsonObject);
        }

        request.getSession().setAttribute("xiaoFeiPubs",pubs);
        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已返回消费类型标签列表");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }
    /**
     * 加载 商品类型标签 列表↓
     * todo ok
     * @return
     */
    public String loadShangPing(){
    	
        Pub pub = new Pub();
        
        pub.setState(MerchantPub.state_nomal);
        pub.setShenghe(MerchantPub.shenghe_tongguo);
        pub.addCommand(MongoCommand.in, "pubConlumnId", MerchantShowAction.getShangPingLeixingId()); //  系统类容 --> 系统类容 --> 商品

        List<Pub> pubs =ContextUtil.getSerializContext().findAll(pub);

        JsonArray jsonArray = new JsonArray();
        for (Pub pub_out : pubs){
            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("shangPingId",pub_out.getId());
            jsonObject.addProperty("pubName",pub_out.getName());

            jsonArray.add(jsonObject);
        }

        request.getSession().setAttribute("shangPingPubs",pubs);
        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已返回消费类型标签列表");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }


























































    // 距离配置
    private static Double juli = 3.0D;



    //  根节点: 商家展示
    public static String getXiaoChenXuConfigId(){ return  "5adad5cbd6c4593d38aa3787"; };

    /**
     * 加载小程序的相关配置
     * @return
     */
    public String loadConfig(){


//        XiaochengxuConfigPub xiaochengxuConfigPub_find = new XiaochengxuConfigPub();
//        xiaochengxuConfigPub_find.setRootPubConlumnId(getXiaoChenXuConfigId());
//
//        // 得到小程序的配置
//        List<XiaochengxuConfigPub> xiaochengxuConfigPubList = serializContext.findAll(xiaochengxuConfigPub_find);
//
//        for(XiaochengxuConfigPub xiaochengxuConfigPub_out : xiaochengxuConfigPubList){
//            String key = xiaochengxuConfigPub_out.getConfigKey();
//            String value = xiaochengxuConfigPub_out.getConfigValue();
//
//            if( juli.equals(key) &&  !MyUtil.isEmpty(value) ){
//                if (MathUtil.parseDoubleNull(value) != null){
//                    juli = MathUtil.parseDoubleNull(value);
//                }
//            }
//        }


        return SUCCESS;
    }



    /**
     * 加载推荐卡(首页)的内容
     * @return
     */
    public String loadTuiJianKa(){

        String latitude = this.getParameter("latitude");
        String longitude = this.getParameter("longitude");

        // 当前位置获取和检查
        Double latitude_now = MathUtil.parseDouble(latitude);
        Double longitude_now = MathUtil.parseDouble(longitude);

        // todo 分页

        PubLink pubLink_find = new PubLink();

        pubLink_find.setState(Pub.state_nomal);
        pubLink_find.setShenghe(Pub.shenghe_tongguo);
        pubLink_find.setPubConlumnId(MerchantShowAction.getShouYeGunDongId());

        List<PubLink> pubLinkList = serializContext.findAll(pubLink_find);

        JsonArray jsonArray = new JsonArray();

        for(PubLink pubLink_out : pubLinkList){

            MerchantPub merchantPub = (MerchantPub)pubLink_out.getPub_link();
            Merchant72 merchant72 = merchantPub.getMerchant72();

            if (pubLink_out == null){ continue; }
            if (merchantPub == null){ continue; }
            if (merchant72 == null){ continue; }
            if(  !Pub.state_nomal.equals(merchantPub.getState()) ){ continue; }

            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("headPortrait",merchant72.getPicname());
            jsonObject.addProperty("name",merchant72.getNickname());
            jsonObject.addProperty("headBackground",merchantPub.getFile());
            jsonObject.addProperty("title","About."+merchant72.getNickname());
            jsonObject.addProperty("pubIntro",merchantPub.getIntro());
            jsonObject.addProperty("mark",merchantPub.getRootPubConlumnId());

            BasicDBList dbList_pic = merchantPub.getPics();
            JsonArray jsonArray_Pics = new JsonArray();
            if (dbList_pic != null){
                for (Object showPic : merchantPub.getPics()){
                    jsonArray_Pics.add(showPic+"");
                }
            }
            jsonObject.add("showPic",jsonArray_Pics);

            String showDistance = "距您较近";
            Double dis = merchant72.getDistance(latitude_now, longitude_now);
            if (dis > juli){showDistance = "距您较远";}

            jsonObject.addProperty("showDistance",showDistance);

            jsonArray.add(jsonObject);
        }

        System.out.println(pubLinkList);

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("success");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }














}
