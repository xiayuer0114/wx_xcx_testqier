package com.lymava.qier.service;


import com.google.gson.JsonObject;
import com.lymava.base.model.User;
import com.lymava.base.util.FinalVariable;
import com.lymava.commons.util.JsonUtil;
import com.lymava.wechat.gongzhonghao.Gongzonghao;
import com.lymava.wechat.gongzhonghao.GongzonghaoContent;

import javax.servlet.http.HttpServletRequest;

public class ActionUtil {


    public Integer usage_xiaochengxu = 1;
    public Integer usage_gongzhonghao = 2;

    /**
     * 传入一个字符串code  返回字符串token
     * @param code
     * @param usage   使用场景   小程序:1  公众号:2
     * @return
     */
    public String getToken(String code, Integer usage){
        Gongzonghao gongzonghao = GongzonghaoContent.getInstance().getDefaultGongzonghao();
        String user_access_token = null;
        try {
            // ↓ 小程序的token
            if (usage.equals(usage_xiaochengxu)){ user_access_token = gongzonghao.jscode2session(code); }
            // ↓ 公众号的token
            if (usage.equals(usage_gongzhonghao)){ user_access_token = gongzonghao.get_user_access_token(code); }
        } catch (Exception e) { }
        return user_access_token;
    }



    /**
     * 传入一个字符串code  返回字符串openid
     * @param code
     * @param usage  使用场景 1和2
     * @return
     */
    public String getOpenIdByCode(String code,Integer usage){
        // 通过codeId拿到 openId
        String user_access_token = getToken(code,usage);
        JsonObject user_access_token_jsonObject =  JsonUtil.parseJsonObject(user_access_token);
        String openId  = JsonUtil.getRequestString(user_access_token_jsonObject, "openid");

        return openId;
    }



    /**
     * 传入一个字符串token  返回字符串openid
     * @param token
     * @param usage  使用场景 1和2
     * @return
     */
    public String getOpenIdByToken(String token,Integer usage){
        // 通过codeId拿到 openId
//        String user_access_token = getToken(token,usage);
        JsonObject user_access_token_jsonObject =  JsonUtil.parseJsonObject(token);
        String openId  = JsonUtil.getRequestString(user_access_token_jsonObject, "openid");

        return openId;
    }



    /**
     * 登录成功检测
     *
     * @param userRight
     */
    public JsonObject user_login_ok( JsonObject jsonReturn,User userRight,HttpServletRequest request) {
        JsonUtil.addProperty(jsonReturn, "statusCode", "200");
        JsonUtil.addProperty(jsonReturn, "message", "登录成功");
        JsonUtil.addProperty(jsonReturn, "userId", userRight.getId());
        JsonUtil.addProperty(jsonReturn, "key", userRight.getKey());

        request.getSession().setAttribute(FinalVariable.SESSION_FRONT_USER, userRight.getId());
        return jsonReturn;
    }


}
