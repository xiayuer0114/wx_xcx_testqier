package com.lymava.qier.action;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.util.List;

import org.apache.struts2.ServletActionContext;
import org.bson.types.ObjectId;

import com.google.gson.JsonObject;
import com.lymava.base.action.BaseAction;
import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.base.vo.State;
import com.lymava.base.vo.StatusCode;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.util.HexM;
import com.lymava.commons.util.ImageUtil;
import com.lymava.commons.util.JsonUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.Md5Util;
import com.lymava.commons.util.MyUtil;
import com.lymava.commons.util.QrCodeUtil;
import com.lymava.qier.model.Cashier;
import com.lymava.qier.model.TradeRecord72;
import com.lymava.wechat.gongzhonghao.Gongzonghao;
import com.lymava.wechat.gongzhonghao.GongzonghaoContent;

/**
 *   孙M     这个action是给 收银员小程序 使用的,   提供了接口   收银员小程序应该是被遗弃了
 */
public class OrderAction extends BaseAction {


    /**
	 * 
	 */
	private static final long serialVersionUID = 2764577672071060694L;


	/**
     * 检查是否是收银员
     * @return
     */
    public String checkCashier(){
            // 拿到codeId
        String code = request.getParameter("code");
            // 检查codeid
        if(code == null || "".equals(code)){
            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("state",false);
            jsonObject.addProperty("openId","");
            jsonObject.addProperty("userName","");
            jsonObject.addProperty("userId","");
            jsonObject.addProperty("isMerchant",false);
            this.setDataRoot(jsonObject);
            this.setMessage("需要code");
            return SUCCESS;
        }
             // 通过codeId拿到 openId
        Gongzonghao gongzonghao = GongzonghaoContent.getInstance().getDefaultGongzonghao();
        String user_access_token = null;
        try {
            user_access_token = gongzonghao.jscode2session(code);
        } catch (Exception e) {
        }
        JsonObject user_access_token_jsonObject =  JsonUtil.parseJsonObject(user_access_token);
        String openId  = JsonUtil.getRequestString(user_access_token_jsonObject, "openid");

            // 判断openId是否为空
        if(MyUtil.isEmpty(openId)){
            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("state",false);
            jsonObject.addProperty("openId",openId);
            jsonObject.addProperty("userName","");
            jsonObject.addProperty("userId","");
            jsonObject.addProperty("isMerchant",false);
            this.setDataRoot(jsonObject);
            this.setStatusCode(StatusCode.ACCEPT_OK);
            this.setMessage("得到的openId为空");
            return SUCCESS;
        }
//        String  openId= "oFqO35SQQqVME0f5jcDhQd1pbKhw";
            // 根据openId得到一个收银员
        Cashier cashier = new Cashier();
        cashier.setXiaochengxu_openid(openId);

            // 通过openId得到一个集合
        List<Cashier> cashiers = (List<Cashier>)ContextUtil.getSerializContext().findAll(cashier);
        if(cashiers.size() > 1){
            // 得到的集合数据大于了1个  清空openId 让他从新绑定
            for (int i =0;i<cashiers.size();i++){
                Cashier clear =  cashiers.get(i);
                clear.setXiaochengxu_openid("");
                ContextUtil.getSerializContext().updateObject(clear.getId(),clear);
            }
            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("state",false);
            jsonObject.addProperty("openId",openId);
            jsonObject.addProperty("userName","");
            jsonObject.addProperty("userId","");
            jsonObject.addProperty("isMerchant",false);
            this.setDataRoot(jsonObject);
            this.setStatusCode(StatusCode.ACCEPT_OK);
            this.setMessage("查询到多个收银员,请重新进行绑定...");
            return SUCCESS;
        }else if(cashiers.size() == 1){
                // 得到一个  就将这个作为判断依据
            cashier = cashiers.get(0);
        }else {
                // 没得到 空
            cashier = null;
        }

            //  判断是否是收银员  查不到说明不是收银员
        if (cashier == null){
            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("state",false);
            jsonObject.addProperty("openId",openId);
            jsonObject.addProperty("userName","");
            jsonObject.addProperty("userId","");
            jsonObject.addProperty("isMerchant",false);
            this.setDataRoot(jsonObject);
            this.setStatusCode(StatusCode.ACCEPT_OK);
            this.setMessage("没有找到该收银员,请进行绑定...");
            return SUCCESS;
        }
            // 查到 分组为商家  进一步判断状态
        if(CashierAction.getMerchantUserGroutId().equals(cashier.getUserGroupId())){
            // 正常的状态
            if(cashier.getState()==User.STATE_OK){
                // 正确的商家
                JsonObject jsonObject = new JsonObject();
                jsonObject.addProperty("userName",cashier.getNickname());
                jsonObject.addProperty("state",true);
                jsonObject.addProperty("userId",cashier.getId());
                jsonObject.addProperty("openId",openId);
                jsonObject.addProperty("isMerchant",true);

                this.setDataRoot(jsonObject);
                this.setStatusCode(StatusCode.ACCEPT_OK);
                this.setMessage("这个用户是商家");
                return SUCCESS;
            }else{
                //  异常状态
                JsonObject jsonObject = new JsonObject();
                jsonObject.addProperty("state",false);
                jsonObject.addProperty("openId",openId);
                jsonObject.addProperty("userName","");
                jsonObject.addProperty("userId","");
                jsonObject.addProperty("isMerchant",true);
                this.setDataRoot(jsonObject);
                this.setStatusCode(StatusCode.ACCEPT_OK);
                this.setMessage("这个商家的状态不正确");
                return SUCCESS;
            }
        }
            // 查到 分组为收银员  进一步判断状态 和 他商家信息
        if(CashierAction.getCashierUserGroutId().equals(cashier.getUserGroupId())){
                // 正常的状态 并且 上级用户(商家信息)不为空
            if(cashier.getState()==User.STATE_OK && !"".equals(cashier.getTopUserId()) && cashier.getTopUserId()!=null){
                    //  正确的收银员  得到他的商家信息
                User user = new User();
                user.setId(cashier.getTopUserId());
                user = (User) ContextUtil.getSerializContext().get(user);

                JsonObject jsonObject = new JsonObject();
                jsonObject.addProperty("userName",user.getNickname());
                jsonObject.addProperty("state",true);
                jsonObject.addProperty("userId",user.getId());
                jsonObject.addProperty("openId",openId);
                jsonObject.addProperty("isMerchant",false);

                this.setDataRoot(jsonObject);
                this.setStatusCode(StatusCode.ACCEPT_OK);
                this.setMessage("是正确的收银员 已返回他的商家信息");
                return SUCCESS;
            }else{
                // 异常的状态或者没有商家信息
                JsonObject jsonObject = new JsonObject();
                jsonObject.addProperty("state",false);
                jsonObject.addProperty("openId",openId);
                jsonObject.addProperty("userName","");
                jsonObject.addProperty("userId","");
                jsonObject.addProperty("isMerchant",false);
                this.setDataRoot(jsonObject);
                this.setStatusCode(StatusCode.ACCEPT_OK);
                this.setMessage("这个收银员的状态不正确或者没有找到他商家信息");
                return SUCCESS;
            }

        }

            // 其他状态 非收银员非商家(普通用户)
        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("state",false);
        jsonObject.addProperty("openId",openId);
        jsonObject.addProperty("userName","");
        jsonObject.addProperty("userId","");
        jsonObject.addProperty("isMerchant",false);
        this.setDataRoot(jsonObject);
        this.setStatusCode(StatusCode.ACCEPT_FALSE);
        this.setMessage("这不是一个收银员,也不是一个商家");
        return SUCCESS;

    }


    /**
     * 检查出不是收银员  通过登录绑定收银员
     * @return
     */
    public String bindingCashier(){
        String openId = request.getParameter("openId");

            // 判断openId是否为空
        if(openId == null || "".equals(openId)){
            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("state",false);
            jsonObject.addProperty("openId",openId);
            jsonObject.addProperty("isMerchant",false);
            this.setDataRoot(jsonObject);
            this.setMessage("没有得到你的微信信息(openid为空)");
            return SUCCESS;
        }


        String phone = request.getParameter("phone");
        String pwd = request.getParameter("pwd");
        CheckException.checkIsTure( !"".equals(phone)&&phone!=null, "电话不能为空!");
        CheckException.checkIsTure( !"".equals(pwd)&&pwd!=null, "密码不能为空!");

            // 判断密码是否正确
        Cashier cashierPanduan  = new Cashier();
        cashierPanduan.setUsername(phone);
        cashierPanduan.setUserpwd(Md5Util.MD5Normal(pwd));
        cashierPanduan = (Cashier) ContextUtil.getSerializContext().get(cashierPanduan);
        if(cashierPanduan == null){
            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("state",false);
            jsonObject.addProperty("openId",openId);
            jsonObject.addProperty("isMerchant",false);
            this.setDataRoot(jsonObject);
            this.setMessage("电话或者密码不正确!");
            return SUCCESS;
        }

            // 电话&密码正确 判断这个openId下是否已经绑定收银员 如果有清除已经绑定的openId
        Cashier cashierByOpenId = new Cashier();
        cashierByOpenId.setXiaochengxu_openid(openId);
        List<Cashier> clearCashiers = ContextUtil.getSerializContext().findAll(cashierByOpenId);
        if (clearCashiers != null){
            for (int i=0; i<clearCashiers.size(); i++){
                Cashier clear =  clearCashiers.get(i);
                clear.setXiaochengxu_openid("");
                ContextUtil.getSerializContext().updateObject(clear.getId(),clear);
            }
        }

//        String  openid= "oFqO35SQQqVME0f5jcDhQd1pbKhw";

        if(cashierPanduan.getUserGroupId().equals(CashierAction.getCommonUserGroutId()) || cashierPanduan.getUserGroupId()==CashierAction.getCommonUserGroutId()){
            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("state",false);
            jsonObject.addProperty("openId",openId);
            jsonObject.addProperty("isMerchant",false);
            this.setDataRoot(jsonObject);
            this.setMessage("这个账户只是一个普通用户!");
            return SUCCESS;
        }

        // 判断这个收银员是不是商家
        if(cashierPanduan.getUserGroupId().equals(CashierAction.getMerchantUserGroutId()) || cashierPanduan.getUserGroupId()==CashierAction.getMerchantUserGroutId()){
            Cashier cashierUpdate = new Cashier();
            cashierUpdate.setXiaochengxu_openid(openId);
            ContextUtil.getSerializContext().updateObject(cashierPanduan.getId(),cashierUpdate);

            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("state",true);
            jsonObject.addProperty("openId",openId);
            jsonObject.addProperty("isMerchant",true);
            this.setDataRoot(jsonObject);
            this.setMessage("成功!");
            return SUCCESS;
        };


            // 正确的信息  添加收银员(更新他的小程序openId)
        Cashier cashierUpdate = new Cashier();
        cashierUpdate.setXiaochengxu_openid(openId);
        ContextUtil.getSerializContext().updateObject(cashierPanduan.getId(),cashierUpdate);

            // 成功 返回信息
        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("state",true);
        jsonObject.addProperty("openId",openId);
        jsonObject.addProperty("isMerchant",false);
        this.setDataRoot(jsonObject);
        this.setMessage("成功!");
        return SUCCESS;
    }


    /**
     * 返回生成的信息 (二维码, 订单Id)
     * @return
     */
    public String createOrder(){
        String openId = request.getParameter("openId");

            // 判断openId是否为空
        if(openId == null || "".equals(openId)){
            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("state",false);
            this.setDataRoot(jsonObject);
            this.setMessage("没有得到你的微信信息(openid为空)");
            return SUCCESS;
        }

        Cashier cashier = new Cashier();
        cashier.setXiaochengxu_openid(openId);
        cashier = (Cashier) ContextUtil.getSerializContext().get(cashier);

        CheckException.checkIsTure(cashier != null, "收银员不存在!");

        if(!cashier.getState().equals(User.STATE_OK) || cashier.getState()!=User.STATE_OK){
            JsonObject jsonObject =new JsonObject();
            jsonObject.addProperty("url","");
            jsonObject.addProperty("orderId","");
            jsonObject.addProperty("state",false);

            this.setDataRoot(jsonObject);
            this.setMessage("这个收银员的状态不正确  可能未绑定");
            return SUCCESS;
        }

        Long bianhao = (Long)cashier.getBianhao();


        String price_yuan_str = request.getParameter("price_yuan");
        Double price_yuan = MathUtil.parseDoubleNull(price_yuan_str);
        CheckException.checkIsTure(price_yuan!=null && price_yuan>0,"金额错误");

        String quyu = request.getParameter("quyu");
        if (quyu == null || "".equals(quyu)) {
            quyu = "";
        }
        if(!MyUtil.isEmpty(quyu)){
        	quyu = HexM.encodeHexString(quyu);
        }

        String orderId = new ObjectId().toString();

            // 生成二维码地址
//      Gongzonghao gongzonghao = GongzonghaoContent.getInstance().getDefaultGongzonghao();
        String recall_url = MyUtil.getBasePath(request);

        recall_url+="?price_yuan="+price_yuan;
        recall_url+="&orderId="+orderId;
        recall_url+="&quyu="+quyu;
        recall_url+="&bianhao="+bianhao;

        Integer qrcode_size = 400;
        BufferedImage bufferedImage = null;
        String temp_pic_path ="";
        try {
            bufferedImage = QrCodeUtil.createQrBufferedImage(recall_url,qrcode_size);
            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            ImageUtil.write(bufferedImage,byteArrayOutputStream);
            String realPath = ServletActionContext.getServletContext().getRealPath("/");

            temp_pic_path = MyUtil.savePic(byteArrayOutputStream.toByteArray(),realPath);

        } catch (Exception e) {
            e.printStackTrace();
        }

            // 设置返回信息
        JsonObject jsonObject =new JsonObject();
        jsonObject.addProperty("url",basePath+temp_pic_path);
        jsonObject.addProperty("orderId",orderId);
        jsonObject.addProperty("state",true);
        
        this.setDataRoot(jsonObject);
        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已返回");
        return SUCCESS;
    };


    /**
     *  查询订单状态
     * @return
     */
    public String queryOrderState(){

        String orderId  = request.getParameter("orderId");
        if(orderId==null || "".equals(orderId)){
            JsonObject jsonObject =new JsonObject();
            jsonObject.addProperty("state",false);

            this.setDataRoot(jsonObject);
            this.setStatusCode(StatusCode.ACCEPT_FALSE);
            this.setMessage("需要订单编号(orderId)");
            return SUCCESS;
        }

        TradeRecord72 tradeRecord72 = new TradeRecord72();
        tradeRecord72.setId(orderId);

        tradeRecord72 = (TradeRecord72)ContextUtil.getSerializContext().get(tradeRecord72);

        if(tradeRecord72 == null){
            JsonObject jsonObject =new JsonObject();
            jsonObject.addProperty("state",false);

            this.setDataRoot(jsonObject);
            this.setStatusCode(StatusCode.ACCEPT_FALSE);
            this.setMessage("订单不存在");
            return SUCCESS;
        }

        // 设置返回数据
        JsonObject jsonObject =new JsonObject();
        jsonObject.addProperty("orderState",tradeRecord72.getState());
        jsonObject.addProperty("state",State.STATE_PAY_SUCCESS.equals(tradeRecord72.getState()));
        this.setDataRoot(jsonObject);
        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage("已经返回订单状态");
        return SUCCESS;
    };

}
