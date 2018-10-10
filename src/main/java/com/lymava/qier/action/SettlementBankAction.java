package com.lymava.qier.action;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.lymava.base.action.BaseAction;
import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.model.Pub;
import com.lymava.base.model.User;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
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
import com.lymava.nosql.model.SerializModel;
import com.lymava.qier.activities.model.Daka;
import com.lymava.qier.model.*;
import com.lymava.qier.service.ActionUtil;
import com.lymava.qier.util.SunmingUtil;
import com.lymava.trade.base.model.BusinessIntIdConfig;
import com.lymava.trade.util.WebConfigContentTrade;
import com.lymava.userfront.util.FrontUtil;
import com.lymava.wechat.gongzhonghao.SubscribeUser;

import javax.servlet.http.Cookie;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import static java.lang.System.currentTimeMillis;

/**
 * 商户银行卡
 */
@AcceptUrlAction(path="v2/SettlementBank/",name="商户银行卡")
public class SettlementBankAction extends LazyBaseAction {


    private static final long serialVersionUID = 1724099821973441218L;




    @Override
    protected Class<? extends SerializModel> getObjectClass() {
        return SettlementBank.class;
    }

    @Override
    protected void listParse(Object object_find) {
        SettlementBank settlementBank = (SettlementBank) object_find;

        String bank_type = this.getParameter("bank_type");
        String memo = this.getParameter("memo");
        String merchant72_id = this.getParameter("merchant72_id");

        if(!MyUtil.isEmpty(bank_type)){
            settlementBank.setBank_type(Integer.valueOf(bank_type));
        }
        if(!MyUtil.isEmpty(memo)){
            settlementBank.setMemo(memo);
        }
        if(!MyUtil.isEmpty(merchant72_id) && MyUtil.isValid(merchant72_id)){
            settlementBank.setMerchant72_id(merchant72_id);
        }
    }

    @Override
    protected void saveParse(Object object_find) {
        super.saveParse(object_find);


    }

}
