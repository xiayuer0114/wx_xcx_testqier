package com.lymava.qier.action;

import static java.lang.System.currentTimeMillis;

import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.Cookie;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.lymava.base.action.BaseAction;
import com.lymava.base.model.Pub;
import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.base.util.WebConfigContent;
import com.lymava.commons.cache.SimpleCache;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.pay.PayFinalVariable;
import com.lymava.commons.state.State;
import com.lymava.commons.state.StatusCode;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.JsonUtil;
import com.lymava.commons.util.Md5Util;
import com.lymava.commons.util.MyUtil;
import com.lymava.qier.model.*;
import com.lymava.qier.service.ActionUtil;
import com.lymava.qier.util.SunmingUtil;
import com.lymava.trade.base.model.BusinessIntIdConfig;
import com.lymava.trade.util.WebConfigContentTrade;
import com.lymava.userfront.util.FrontUtil;
import com.lymava.wechat.gongzhonghao.SubscribeUser;
import com.mongodb.BasicDBList;

/**
 * 孙M   用于处理 商家网页端 大部分的请求处理
 *      6.1 孙M    修改得到openid的方式  代码整理
 *      6.7 孙M      修改数据显示的是使用的字段有些显示是有问题的
 */
public class CashierAction extends BaseAction {

    // 设置常量
    private static final long serialVersionUID = 3882293933530444723L;


    // 得到  收银员  的分组id
    public static String getCashierUserGroutId() { return "5aaa3586ef722c26cae51910"; }

    // 得到  商家    的分组id
    public static String getMerchantUserGroutId() { return WebConfigContentTrade.getInstance().getMerchantUserGroupId(); }

    // 得到  普通用户 的分组id
    public static String getCommonUserGroutId() { return WebConfigContentTrade.getInstance().getDefaultUserGroupId(); }

    // 得到  业务员 的分组id
    public static String getSalesmanUserGroutId() { return "5b4066e1d6c4594b4cd699b1"; }



    // 得到产品管理的分组id  (业务交易下的产品管理)
    public static String getProductManagementConlumnId() { return "5aa0b4d7ef722c157280a31e"; };

    // 得到产品管理下默认分类的id  (业务交易下的产品管理 下的默认分类)
    public static String getProductDefaultClassConlumnId() { return "5aa0b2a3ef722c157280a31a"; };




    // action帮助方法类
    ActionUtil actionUtil = new ActionUtil();
    Integer usage = actionUtil.usage_gongzhonghao;   // 使用场景: 公众号

    /**
     * 检查登录
     *
     * @return
     */
    public User check_login_user() {
        User init_http_user = FrontUtil.init_http_user(request);
        CheckException.checkIsTure(init_http_user != null, "请先登录!", StatusCode.USER_INFO_TIMEOUT);
        return init_http_user;
    }


    /**
     * 商家的密码修改    暂时先将商家和收银员的请求做到一起  商家的请求也是在CashierAction中
     *
     * @return
     */
    public String changePwd() {
        User init_http_user = FrontUtil.init_http_user(request);
        CheckException.checkIsTure(init_http_user != null, "请先登录!", StatusCode.USER_INFO_TIMEOUT);

        String pwdOld = this.getParameter("pwdOld");
        String pwdNew = (String) this.getParameter("pwdNew");

        CheckException.checkIsTure(pwdOld != null, "密码不能为空!");

        if (pwdOld.equals(init_http_user.getUserpwd())) {
            User chenckUser = new User();
            chenckUser.setUserpwd(pwdNew);

            ContextUtil.getSerializContext().updateObject(init_http_user.getId(), chenckUser);

            this.setMessage("修改成功!");

            return SUCCESS;
        }

        this.setMessage("旧密码错误  修改失败!");
        return SUCCESS;
    }



    /**
     * 用户扫描主页上的二维码  变更订单通知的微信
     * @return
     */
    public String getUserOpenId() {

        // 获取请求参数  1: userid  2: 随机码  3: 匹配码
        String user_id = this.getParameter("user_id");
        String rand_code = this.getParameter("rand_code");
        String user_sign = this.getParameter("user_sign");

        // 这个action的返回参数  1: message_key是页面上的提示信息  2: 返回路劲
        String message_key = "message";
        this.setSuccessResultValue("/merchant_phone/cashier/success.jsp");

        // 得到对应的商家
        Merchant72 merchant72 = null;
        if (MyUtil.isValid(user_id)) {
            merchant72 = (Merchant72) serializContext.get(Merchant72.class, user_id);
        }
        //如果此用户不是商家
        if (merchant72 == null || !getMerchantUserGroutId().equals(merchant72.getUserGroupId())) {
            request.setAttribute(message_key, "商户不存在!");
            request.setAttribute("state", "300");
            return SUCCESS;
        }

        // 验证商家请求
        String user_sign_right = Md5Util.MD5Normal(merchant72.getKey() + rand_code.toLowerCase());
        if (!user_sign_right.equals(user_sign)) {
            request.setAttribute(message_key, "商户签名异常!");
            request.setAttribute("state", "300");
            return SUCCESS;
        }

        // 拿到codeId
        String code = this.getParameter("code");
        String user_access_token =null;
        String openId = null;

        // 通过codeId拿到 openId
        try {
            user_access_token = actionUtil.getToken(code,usage);

            JsonObject user_access_token_jsonObject =  JsonUtil.parseJsonObject(user_access_token);
            openId = JsonUtil.getRequestString(user_access_token_jsonObject, "openid");
        } catch (Exception e) {
            logger.error("获取 openId 失败 user_access_token 失败!", e);
        }

        // 验证openid
        if (MyUtil.isEmpty(openId)) {
            logger.error("user_access_token:" + user_access_token);
            request.setAttribute("state", "300");
            request.setAttribute(message_key, "openId获取失败!");
            return SUCCESS;
        }

        SubscribeUser subscribeUser_find = new SubscribeUser();
		subscribeUser_find.setOpenid(openId);

		subscribeUser_find = (SubscribeUser) serializContext.get(subscribeUser_find);

		//未关注
		if(subscribeUser_find == null || !State.STATE_OK.equals(subscribeUser_find.getState())){
			request.setAttribute("state",State.STATE_FALSE);
			request.setAttribute(message_key, "请先关注公众号再扫描二维码!");
		    return SUCCESS;
		}


		// 更新不在这儿做
        // 设置 更新订单通知的微信用户
//        Merchant72 merchant72_update = new Merchant72();


        request.setAttribute("state", State.STATE_OK);
        request.setAttribute(message_key, "绑定新订单通知微信成功,请关闭此页面!");

        String sign =  Md5Util.MD5Normal(openId+ merchant72.getId()+merchant72.getKey());

        request.setAttribute("sign",sign);
        request.setAttribute("openId", openId);
        request.setAttribute("merchantId", merchant72.getId());

        return SUCCESS;
    }


    /**
     * 商家 扫码登录   登录首页
     * @return
     */
    public String saomaLogin() {

        // 这个action的返回参数  1: message_key是页面上的提示信息  2: 返回路劲
        String message_key = "message";
        this.setSuccessResultValue("/merchant/business_page/cashier/success.jsp");

        // 获取参数 code   和  sessionId
        String sessionId = request.getParameter("sessionId");
        String code = this.getParameter("code");

        // 通过codeId拿到 openId
        String user_access_token = null;
        String openId = null;
        try {
            user_access_token = actionUtil.getToken(code,usage);

            JsonObject user_access_token_jsonObject =  JsonUtil.parseJsonObject(user_access_token);
            openId = JsonUtil.getRequestString(user_access_token_jsonObject, "openid");
        } catch (Exception e) {
            logger.error("获取 openId 失败 user_access_token 失败!", e);
        }

        // 检查openId
        if (MyUtil.isEmpty(openId)) {
            logger.error("user_access_token:" + user_access_token);
            request.setAttribute("state", "300");
            request.setAttribute(message_key, "openId获取失败!");
            return SUCCESS;
        }

        // 设置查询参数
        Merchant72 merchant72_find = new Merchant72();
        merchant72_find.setThird_user_id(openId);
        merchant72_find.setUserGroupId(getMerchantUserGroutId());
        merchant72_find.setState(User.STATE_OK);


        // 得到商家信息
        List<User> users = ContextUtil.getSerializContext().findAll(merchant72_find);
        if (users.size() == 1) {
             // 核心 : 通过前台唯一的sessionId在系统上缓存用户信息(user)  前台通过sessionId在系统缓存里面循环查找
            SimpleCache.cache_object(sessionId, users.get(0));

            request.setAttribute(message_key, "登录成功...");
            request.setAttribute("state", "200");
        } else {
            request.setAttribute(message_key, "没有获取到您的信息!");
            request.setAttribute("state", "300");
        }

        return SUCCESS;
    }


    /**
     * 商家扫描二维码  绑定微信,然后就可以进行扫码登录
     * @return
     */
    public String bindMerchantWeChat() {
        // 这个action的返回参数  1: message_key是页面上的提示信息  2: 返回路劲
        String message_key = "message";
        this.setSuccessResultValue("/merchant/business_page/cashier/success.jsp");

        // 在扫描二维码之前绑定之前  系统上缓存了用户信息  拿到用户更新他的openid
        String sessionId_user = request.getParameter("sessionId_user");
        User user = (User) SimpleCache.get_object(sessionId_user);

        // 当前的这个商家已经有openid
        if( !SunmingUtil.strIsNull(user.getThird_user_id())){
            request.setAttribute(message_key, "你已经绑定了一个商家, 请勿再次绑定");
            request.setAttribute("state", "300");
            return SUCCESS;
        }

        // 拿到codeId
        String code = this.getParameter("code");

        // 通过codeId拿到 openId
        String user_access_token = null;
        String openId = null;
        try {
            user_access_token = actionUtil.getToken(code,usage);
            JsonObject user_access_token_jsonObject =  JsonUtil.parseJsonObject(user_access_token);
            openId = JsonUtil.getRequestString(user_access_token_jsonObject, "openid");
        } catch (Exception e) {
            logger.error("获取 openId 失败 user_access_token 失败!", e);
        }

        // 检查openId
        if (MyUtil.isEmpty(openId)) {
            logger.error("user_access_token:" + user_access_token);
            request.setAttribute(message_key, "openId获取失败!");
            request.setAttribute("state", "300");
            return SUCCESS;
        }

        User user_find = new User();
        user_find.setThird_user_id(openId);
        user_find.setUserGroupId(this.getMerchantUserGroutId());
        user_find = (User)ContextUtil.getSerializContext().get(user_find);
        if( user_find != null){
            request.setAttribute(message_key, "你已经绑定了一个商家, 请勿再次绑定");
            request.setAttribute("state", "300");
            return SUCCESS;
        }

        // 跟新商家的openid   孙M  6.13
        User user_update = new User();
        user_update.setThird_user_id(openId);
        serializContext.updateObject(user.getId(),user_update);

        request.setAttribute(message_key, "绑定成功.");
        request.setAttribute("state", "200");
        return SUCCESS;
    }


    /**
     * 检查是否进行了扫码登录  前台循环调用这个接口
     *      孙M  6.8   正确的用户扫码登录成功 未跳转 已修改  本地测试通过
     * @return
     */
    public String checkSaomaLogin() {

        String sessionId = request.getParameter("sessionId");

        // 从缓存根据sessionId中拿到登录的商户
        User user = (User) SimpleCache.get_object(sessionId);

        JsonObject jsonObject = new JsonObject();

        if (user != null) {
            actionUtil.user_login_ok(jsonObject,user,request);
        } else {
            JsonUtil.addProperty(jsonObject, "statusCode", "300");
            JsonUtil.addProperty(jsonObject, "message", "未扫码或者扫码用户不是商家");
        }

        this.setStrutsOutString(jsonObject);
        return SUCCESS;
    }



    /**
     * 商家阅读了 后台发送的提示信息
     * @return
     */
    public String readMessage(){

        // 检查登录
        Merchant72 merchant72 = (Merchant72)check_login_user();

        // 获取 & 修改日志
        SendInformLog sendInformLog_find = new SendInformLog();

        sendInformLog_find.setMerchantId(merchant72.getId());
        sendInformLog_find.setStart(SendInformLog.start_send);   // 状态为 已发送

        sendInformLog_find = (SendInformLog)serializContext.findOneInlist(sendInformLog_find);

        if (sendInformLog_find != null){
            sendInformLog_find.setStart(SendInformLog.start_read);
            serializContext.updateObject(sendInformLog_find.getId(),sendInformLog_find);
        }




        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已阅读");
        return SUCCESS;
    }



    /**
     * 添加一位收银员
     * @return
     */
    public String cashier_add() {

        // 检查登录方法
        User user = this.check_login_user();

        // 获取值 & 检查值
        String phone = this.getParameter("phone");
        String pwd = this.getParameter("pwd");
        CheckException.checkIsTure(!SunmingUtil.strIsNull(phone), "电话不能为空!");
        CheckException.checkIsTure(!SunmingUtil.strIsNull(pwd), "密码不能为空!");

        // 判断是不是收银员
        Cashier cashierPanduan = new Cashier();
        cashierPanduan.setPhone(phone);
        cashierPanduan.setUserGroupId(getCashierUserGroutId());
        cashierPanduan.setTopUser(user);
        cashierPanduan = (Cashier) ContextUtil.getSerializContext().get(cashierPanduan);
        if (cashierPanduan != null) {
            this.setStatusCode(StatusCode.ACCEPT_OK);
            this.setMessage("这个电话号码的用户 已经是收银员了！");
            return SUCCESS;
        }

        // 设置添加信息
        Cashier cashierAdd = new Cashier();
        cashierAdd.setTopUser(user);
        cashierAdd.setTopUserId(user.getId());
        cashierAdd.setUsername(phone);
        cashierAdd.setPhone(phone);
        cashierAdd.setNickname(phone);
        cashierAdd.setUserpwd(Md5Util.MD5Normal(pwd));
        cashierAdd.setState(User.STATE_OK);
        cashierAdd.setThird_user_type(User.third_user_type_weixin);
        cashierAdd.setRealname(user.getNickname()+"_收银员");
        cashierAdd.setShare_balance(User.share_balance_no);
        cashierAdd.setUserGroupId(this.getCashierUserGroutId());

        // 设置编号   调用方法生成编号,然后设置值
        WebConfigContent instance = WebConfigContent.getInstance();
        Long newUser_huiyuan_last_id = instance.getNewUser_huiyuan_last_id();
        cashierAdd.setBianhao(newUser_huiyuan_last_id);

        // 添加保存
        ContextUtil.getSerializContext().save(cashierAdd);

        // 返回信息
        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("添加成功！");
        return SUCCESS;
    }



    /**
     * 修改收银员信息
     * @return
     */
    public String cashier_update() {

        User user = check_login_user();

        // 获取参数 & 检查参数
        String cashierId = this.getParameter("cashierId");
        String cashierPhone = this.getParameter("cashierPhone");
        String newpwd = this.getParameter("newpwd");
        CheckException.checkIsTure(!SunmingUtil.strIsNull(cashierId),"id错误");
        CheckException.checkIsTure(!SunmingUtil.strIsNull(cashierPhone),"登录名(电话)不能为空");
        CheckException.checkIsTure(!SunmingUtil.strIsNull(newpwd),"密码不能为空");

        // 账户存在检测  根据id  核对username
        Cashier cashier_find_byUsername = new Cashier();
        cashier_find_byUsername.setUsername(cashierPhone);
        cashier_find_byUsername.setUserGroupId(getCashierUserGroutId());
        cashier_find_byUsername = (Cashier)serializContext.get(cashier_find_byUsername);
        if(cashier_find_byUsername != null){
            CheckException.checkIsTure(cashierId.equals(cashier_find_byUsername.getId()),"该账号(电话)已存在");
        }

        //设置修改信息
        Cashier cashier_update = new Cashier();
        cashier_update.setUsername(cashierPhone);
        cashier_update.setUserpwd(Md5Util.MD5Normal(newpwd));
        cashier_update.setPhone(cashierPhone);
        cashier_update.setNickname(cashierPhone);

        // 修改
        ContextUtil.getSerializContext().updateObject(cashierId, cashier_update);
        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("修改成功");
        return SUCCESS;
    }




    /**
     * 解除与收银员的绑定   只是修改了收银员的状态(State) 没有删除
     * @return
     */
    public String cashier_relieve() {

        // 获取参数
        String cashierId = this.getParameter("cashierId");
        CheckException.checkIsTure(!SunmingUtil.strIsNull(cashierId),"id错误");

        // 设置参数
        Cashier cashierUpdate = new Cashier();
        cashierUpdate.setState(User.STATE_NOTOK);

        // 修改绑定状态
        ContextUtil.getSerializContext().updateObject(cashierId, cashierUpdate);

        // 修改后,解绑成功
        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("解绑成功!");

        return SUCCESS;
    }



    /**
     * 加载管理区域   商家或者收银员登录后在右上角设置管理区域,加载这个商家下的管理区域   与cookie配合使用
     *
     * @return
     */
    public String loadAdminArea() {
        // 检查登录
        User user = check_login_user();

        // 得到cookie中的商品收款码id
        Cookie[] cook = request.getCookies();
        String adminAreainfo = "";
        if (cook != null) {
            for (int i = 0; i < cook.length; i++) {
                if (cook[i].getName().equals(user.getId() + "myAdminArea")) {
                    adminAreainfo = cook[i].getValue();
                }
            }
        }


        JsonObject jsonObjectArea = new JsonObject();
        JsonUtil.addProperty(jsonObjectArea, "jsonObjectArea", adminAreainfo);


        // 设置商家id   是不是收银员
        String merchantId = "";
        if (user.getUserGroupId().equals(CashierAction.getMerchantUserGroutId())) {
            merchantId = user.getId();
        } else if (user.getUserGroupId().equals(CashierAction.getCashierUserGroutId())) {
            merchantId = user.getUserGroupId();
        }

        // 检查merchantId是否正确
        if (!MyUtil.isValid(merchantId)) {
            return SUCCESS;
        }

        // 得到这个商家下所有的收款码
        Product72 product72 = new Product72();
        product72.setPubConlumnId(getProductManagementConlumnId());
        product72.setRootPubConlumnId(getProductDefaultClassConlumnId());
        product72.setState(Pub.state_nomal);
        product72.setShenghe(Pub.shenghe_tongguo);
        product72.setUserId_merchant(merchantId);
        List<Product72> product72s_find = ContextUtil.getSerializContext().findAll(product72);

        // 设置返回信息
        JsonArray jsonArray = new JsonArray();
        for (int i = 0; i < SunmingUtil.listIsNull(product72s_find); i++) {
            Product72 product72_out = product72s_find.get(i);
            if (product72_out == null) {
                continue;
            }

            JsonObject jsonObject = new JsonObject();
            JsonUtil.addProperty(jsonObject, "product72Id", product72_out.getId());
            JsonUtil.addProperty(jsonObject, "productName", product72_out.getName());

            jsonArray.add(jsonObject);
        }
        jsonArray.add(jsonObjectArea);


        // 返回
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }


    /**
     * 设置cookie的信息
     *
     * @return
     */
    public String setAdminArea() {
        // 检查登录
        User user = check_login_user();

        String adminAreaList = this.getParameter("adminAreaList");

        if (SunmingUtil.strIsNull(adminAreaList)) {
            return "";
        }

        Cookie mycookie = new Cookie(user.getId() + "myAdminArea", adminAreaList);      // 新建Cookie
        mycookie.setMaxAge(60 * 60 * 24 * 365);           // 设置生命周期，单位秒
        mycookie.setPath("/");
        response.addCookie(mycookie);

        return SUCCESS;
    }



    /**
     * 财务数据
     * @return
     */
    public String financialData() {

        Long end_time = DateUtil.getDayStartTime(currentTimeMillis());
        Long start_time = end_time - DateUtil.one_day;

        end_time = currentTimeMillis();

        String start_time_str = request.getParameter("start_time");
        String end_time_str = request.getParameter("end_time");
        if(SunmingUtil.dateStrToLongYMD_hms(start_time_str) != null  &&  SunmingUtil.dateStrToLongYMD_hms(end_time_str) != null){
            start_time = SunmingUtil.dateStrToLongYMD_hms(start_time_str);
            end_time = SunmingUtil.dateStrToLongYMD_hms(end_time_str);
        }

        JsonObject jsonObject = new JsonObject();

        // 调用获取'支付数据'的方法
        this.getPayData(null, start_time, end_time, jsonObject);
        // 调用获取'用户数据'的方法  关注数据
        this.getUserData(start_time, end_time, jsonObject);

        // 可能还存在其他数据  暂留 .....

        // 返回的数据
        this.setStatusCode(State.STATE_OK);
        this.setDataRoot(jsonObject);
        this.addField("startDataStr",SunmingUtil.longDateToStrDate_tall(start_time));
        this.addField("endDataStr",SunmingUtil.longDateToStrDate_tall(end_time));
        return SUCCESS;
    }




    /**
     * 得到所有商家的总余额
     * @return
     */
    public String getMerchant72AllBalance() {

        // 查询出所有的商家
        Merchant72 merchant72 = new Merchant72();

        merchant72.setState(User.STATE_OK);   // 孙M   7.2  状态为正常的商家
        merchant72.setUserGroupId(getMerchantUserGroutId());

        List<Merchant72> merchant72s = ContextUtil.getSerializContext().findAll(merchant72);

        // 所用商家剩余的总金额
        Long price_all = 0L;

        for (int i = 0; i < merchant72s.size(); i++) {
            // 用户的余额可能为空(新商家)
            if (merchant72s.get(i).getMerchant_balance() == null) { continue; }
            price_all += merchant72s.get(i).getMerchant_balance();
        }

        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("price_all", price_all);

        // 返回商家的总余额
        this.setDataRoot(jsonObject);
        return SUCCESS;
    }



    /**
     * 得到每个的商家信息
     * @return
     */
    public String getMerchant72AllData() {

        // 结束时间默认明天早上00点00分00秒   开始时间默认这个月 月初00点00分00秒
        Long endTime = DateUtil.getDayStartTime() + DateUtil.one_day;
        Long startTime = SunmingUtil.getCurrentStartMonth(endTime);

        String startTime_str = this.getParameter("startTime");
        String endTime_str = this.getParameter("endTime");

        Boolean check_startTime = !SunmingUtil.strIsNull(startTime_str) && SunmingUtil.dateStrToLongYMD_hms(startTime_str) != null;
        Boolean check_endTime = !SunmingUtil.strIsNull(endTime_str) && SunmingUtil.dateStrToLongYMD_hms(endTime_str) != null;


        if(check_startTime == true && check_endTime == true){
            startTime =SunmingUtil.dateStrToLongYMD_hms(startTime_str);
            endTime =SunmingUtil.dateStrToLongYMD_hms(endTime_str);
        }

        // 查询出所有的商家
        Merchant72 merchant72 = new Merchant72();

        merchant72.setState(User.STATE_OK);
        merchant72.setUserGroupId(getMerchantUserGroutId());

        List<Merchant72> merchant72s = ContextUtil.getSerializContext().findAll(merchant72);

        // 设置返回数据
        JsonArray jsonArray = new JsonArray();
        for (Merchant72 merchant72_out : merchant72s ){

            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("id",merchant72_out.getId());
            jsonObject.addProperty("bianhao",merchant72_out.getBianhao());
            jsonObject.addProperty("nickname",merchant72_out.getNickname());
            jsonObject.addProperty("username",merchant72_out.getUsername());
            jsonObject.addProperty("balance",merchant72_out.getMerchant_balance());

            // 这段时间所有的打款金额 (实际打款)
            jsonObject.addProperty("allTopUpBalance",getMerchantAllbalanceByIdAndTime(merchant72_out.getId(),startTime,endTime));

            // 最后一次预付款
            jsonObject.addProperty("lastYufukuan",getMerchantLastYufukuanById(merchant72_out.getId()));

            jsonArray.add(jsonObject);
        }

        this.setDataRoot(jsonArray);
        return SUCCESS;
    }



    /**
     * 展示 一段时间 每天的收益情况
     * @return
     */
    public String showDayLiuShuiView(){

        // 结束时间 默认明天早上00点00分00秒  开始时间 默认结束时间的七天前
        Long endTime = DateUtil.getCurrentDayStartTime() ;
        Long startTime = endTime - 7*DateUtil.one_day;

        // 开始时间参数 结束时间参数 获取 & 校验
        String startTime_str = this.getParameter("startTime");
        String endTime_str = this.getParameter("endTime");

        Long startTime_temp = SunmingUtil.dateStrToLongYMD_hms(startTime_str);
        Long endTime_temp = SunmingUtil.dateStrToLongYMD_hms(endTime_str);

        if ( startTime_temp != null  && endTime_temp != null){
            startTime = startTime_temp;
            endTime = endTime_temp;
        }


        // 设置返回数据
        JsonArray jsonArray = new JsonArray();
        while ( startTime<(endTime+DateUtil.one_day) ) {

            String  showDate = "("+DateUtil.getShowWeek(startTime-DateUtil.one_day)+")  ";

            showDate += ""+DateUtil.getSdfShort().format(new Date(startTime));

            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("date",showDate);

            this.getPayData(null, startTime, startTime+DateUtil.one_day, jsonObject);

            jsonArray.add(jsonObject);

            startTime += DateUtil.one_day;
        }

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("success");
        this.setDataRoot(jsonArray);
        return SUCCESS;
    }













    /**
     * 得到支付数据
     * 本action中的financialData()用的方法
     * 在Merchant72Action中也调用了这个方法  Merchant72Action调用时传入了商家id(merchantId)和起止时间
     *
     * @param merchantId  商家id
     * @param start_time  开始时间
     * @param end_time   开始时间
     * @param jsonObject  被赋值的jsonObject
     * @return
     */
    public HashMap<String, Object> getPayData(String merchantId, Long start_time, Long end_time, JsonObject jsonObject) {

        // 所有在输入的时间段内 付款成功的订单   (根据时间查询)
        TradeRecord72 tradeRecord72 = new TradeRecord72();
        tradeRecord72.setState(State.STATE_PAY_SUCCESS);
        tradeRecord72.setBusinessIntId(BusinessIntIdConfig.businessIntId_trade);
        if (merchantId != null) { tradeRecord72.setUserId_merchant(merchantId); };
        tradeRecord72 = (TradeRecord72) SunmingUtil.setQueryWhere_time(tradeRecord72, start_time, end_time);

        // 根据条件得到所有数据
        List<TradeRecord72> tradeRecord72s = ContextUtil.getSerializContext().findAll(tradeRecord72);

        Long price_all_alipay = 0L;             // 支付宝支付的所有余额
        Integer price_all_alipay_count = 0;     // 支付宝支付的总笔数

        Long price_all_wechatpay = 0L;          // 微信支付的所有余额
        Integer price_all_wechatpay_count = 0;  // 微信支付的总笔数

        Long price_all_redpay = 0L;             // 微信支付的所有余额
        Integer price_all_redpay_count = 0;     // 微信支付的总笔数

        Long price_all = 0L;                    // 这段时间的收银总金额(实际的付款)
        Integer price_all_count = 0;            // 这段时间的收银总笔数

        Long mao_price_all = 0L;                // 这段时间的订单上的总金额(毛总金额: 实际付款+红包+代金券)

        for (int i = 0; i < tradeRecord72s.size(); i++) {
            // 有些诡异的数据 取出来的订单金额为空 让程序抛异常  fffff
            TradeRecord72 tradeRecord72_out = tradeRecord72s.get(i);
            if (tradeRecord72_out == null){continue;};

            Long tradeRecord72_Price_fen_all = 0L;  // 支付金额  (每笔订单用户实际支付的金额)
            if (tradeRecord72_out.getPayPrice_fen_all() != null) {
                tradeRecord72_Price_fen_all = tradeRecord72_out.getThirdPayPrice_fen_all();
            };

            Long mao_tradeRecord72_Price_fen_all = 0L; // 订单金额 (订单上的金额;毛金额)
            if (tradeRecord72_out.getShowPrice_fen_all() != null) {
                mao_tradeRecord72_Price_fen_all = tradeRecord72_out.getShowPrice_fen_all();
            };

            price_all += tradeRecord72_Price_fen_all;   // 总金额
            mao_price_all += mao_tradeRecord72_Price_fen_all;  // 毛总金额
            price_all_count += 1;   // 总订单数累加

            // 支付宝支付
            if (PayFinalVariable.pay_method_alipay.equals(tradeRecord72_out.getPay_method())) {
                price_all_alipay += tradeRecord72_Price_fen_all;
                price_all_alipay_count += 1;
            }
            // 微信支付
            if (PayFinalVariable.pay_method_weipay.equals(tradeRecord72_out.getPay_method())) {
                price_all_wechatpay += tradeRecord72_Price_fen_all;
                price_all_wechatpay_count += 1;
            }
            // 钱包支付
            if (tradeRecord72_out.getWallet_amount_payment_fen() != null){
                price_all_redpay += tradeRecord72_out.getWallet_amount_payment_fen();
                price_all_redpay_count += 1;     // 微信支付的总笔数
            }
            // ... 可能存在更多的支付方式判断
        }

        // 两个的action进来的方式不一样  一个没带jsonObject 也没用用到jsonObject  这直接new一出来讲究用到
        if (jsonObject == null){jsonObject = new JsonObject();}

        jsonObject.addProperty("price_all_alipay", price_all_alipay);
        jsonObject.addProperty("price_all_alipay_count", price_all_alipay_count);
        jsonObject.addProperty("price_all_wechatpay", price_all_wechatpay);
        jsonObject.addProperty("price_all_wechatpay_count", price_all_wechatpay_count);
        jsonObject.addProperty("price_all", price_all);
        jsonObject.addProperty("price_all_count", price_all_count);
        jsonObject.addProperty("price_all_redpay", price_all_redpay);
        jsonObject.addProperty("price_all_redpay_count", price_all_redpay_count);

        jsonObject.addProperty("mao_price_all", mao_price_all);



        HashMap<String, Object> payData = new HashMap<>();
        payData.put("price_all_alipay", price_all_alipay);
        payData.put("price_all_alipay_count", price_all_alipay_count);
        payData.put("price_all_wechatpay", price_all_wechatpay);
        payData.put("price_all_wechatpay_count", price_all_wechatpay_count);
        payData.put("price_all", price_all);
        payData.put("price_all_count", price_all_count);
        payData.put("mao_price_all", mao_price_all);


        return payData;
    }




    /**
     * 得到用户关注的数据  给这个action中financialData()调用的方法
     * 传入了开始时间和结束时间 和一个JsonObject调用这个方法后 这个JsonObject会多三个数据
     * {"newGuanZhuUser":"新增加的用户","guanZhuUser":"关注用户","quXiaoGuanZhuUser":"取消关注的用户"}
     *
     * @param start_time 开始时间
     * @param end_time 结束时间
     * @param jsonObject  被赋值的jsonObject
     */
    private void getUserData(Long start_time, Long end_time, JsonObject jsonObject) {
        //所有在输入的时间段内的所用用户
        SubscribeUser subscribeUser = new SubscribeUser();
        subscribeUser = (SubscribeUser) SunmingUtil.setQueryWhere_time(subscribeUser, start_time, end_time);

        List<SubscribeUser> subscribeUsers = ContextUtil.getSerializContext().findAll(subscribeUser);

        Integer guanZhuUser = 0;
        Integer quXiaoGuanZhuUser = 0;

        for (int i = 0; i < subscribeUsers.size(); i++) {
            if (subscribeUsers.get(i).getState().equals(com.lymava.commons.state.State.STATE_OK)) {
                guanZhuUser++;
            }
            if (subscribeUsers.get(i).getState().equals(com.lymava.commons.state.State.STATE_FALSE)) {
                quXiaoGuanZhuUser++;
            }
        }


        jsonObject.addProperty("newGuanZhuUser", subscribeUsers.size());
        jsonObject.addProperty("guanZhuUser", guanZhuUser);
        jsonObject.addProperty("quXiaoGuanZhuUser", quXiaoGuanZhuUser);
    }




    /**
     *  得到一个商家的最后一次充值金额 (预付款)
     * @param id  商家的id
     * @return  返回最后一次预付款  偏移User.pianyiYuan (偏移6位)
     */
    private Long getMerchantLastYufukuanById(String id){

        // 根据商家的id得到最后一条 打款记录
        BalanceLog72 balanceLog72_find = new BalanceLog72();
        balanceLog72_find.setUser_id(id);
        balanceLog72_find.setMemo(Merchant72Action.getBalanceLogMerchantMemo()); //类型为'商户预付款' Memo = '商户预付款'
        balanceLog72_find = (BalanceLog72) serializContext.findOneInlist(balanceLog72_find);

        Long count = 0L;

        if (balanceLog72_find !=null && balanceLog72_find.getCount() != null){
            count = balanceLog72_find.getCount();
        }


        return count;
    }




    /**
     * 获取一个商家在一段时间内的打款总金额 (实际打款的金额)
     * @param id   商家的id
     * @param startTime  开始时间 (可以为null)
     * @param endTime   结束时间  (可以为null)
     * @return  返回打款总金额    偏移 User.pianyiYuan (偏移6位)
     */
    private Long getMerchantAllbalanceByIdAndTime(String id, Long startTime, Long endTime){

        // 获取这个商家 在这段时间的所有预付款记录
        BalanceLog72 balanceLog72_find = new BalanceLog72();
        balanceLog72_find.setUser_id(id);
        balanceLog72_find.setMemo(Merchant72Action.getBalanceLogMerchantMemo()); //类型为'商户预付款' Memo = '商户预付款'
        balanceLog72_find = (BalanceLog72) SunmingUtil.setQueryWhere_time(balanceLog72_find,startTime,endTime);

        List<BalanceLog72> balanceLog72List = serializContext.findAll(balanceLog72_find);

        // 这段时间的预付款总金额
        Long merchantAllbalanceByIdAndTime = 0L;

        for (BalanceLog72 balanceLog72_out : balanceLog72List){
            if (balanceLog72_out == null) {continue;}
            if (balanceLog72_out.getTopUpBalance() == null) {continue;}

            merchantAllbalanceByIdAndTime += balanceLog72_out.getTopUpBalance();
        }

        return merchantAllbalanceByIdAndTime;
    }


}
