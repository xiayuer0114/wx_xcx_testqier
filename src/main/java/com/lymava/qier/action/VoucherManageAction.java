package com.lymava.qier.action;

import com.google.gson.JsonObject;
import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlMethod;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.model.SerializModel;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.nosql.mongodb.vo.BaseModel;
import com.lymava.qier.model.UserVoucher;
import com.lymava.qier.model.Voucher;
import com.lymava.trade.business.model.TradeRecord;
import org.bson.types.ObjectId;

import java.util.LinkedList;
import java.util.List;

@AcceptUrlAction(path="v2/voucherManage/",name="代金券")
public class VoucherManageAction extends LazyBaseAction {

    @Override
    protected Class<? extends SerializModel> getObjectClass() {
        return Voucher.class;
    }

    @Override
    protected void listParse(Object object_find) {

        Voucher voucher = (Voucher)object_find;
    }

    public String find_all_voucher(){

        return SUCCESS;
    }

        // 编辑代金券(审核商家发布的代金券),
    public String edit_voucher(){

        return SUCCESS;
    }

        // 对个人发布代金券
    @AcceptUrlMethod(name="发布代金券")
    public String fabu_voucher(){

        String voucherId = request.getParameter("voucherId");
        
        Voucher voucher = null;

            // 代金券状态检查
        if(MyUtil.isValid(voucherId)){
        	voucher = (Voucher) serializContext.get(Voucher.class, voucherId);
        }
        CheckException.checkIsTure(voucher != null   , "代金卷不存在");
        CheckException.checkIsTure(voucher.getState() == Voucher.voucherState_now , "代金卷状态不正确");


        
        String shangjiaId = request.getParameter("shangjiaId");
        String fabuCount_str = request.getParameter("fabuCount");
        String userId = request.getParameter("userId");
        
        Integer fabuCount = MathUtil.parseInteger(fabuCount_str);

        Integer voucherCount = voucher.getVoucherCount();
        Integer voucherOutCount = voucher.getVoucherOutCount();
        
        CheckException.checkIsTure(fabuCount != null && fabuCount > 0 && fabuCount <= (voucherCount-voucherOutCount), "数量不正确");

            // 循环添加数据
        UserVoucher userVoucher = new UserVoucher();
        
        userVoucher.setVoucherId(voucherId);
        userVoucher.setUserId_huiyuan(userId);
        userVoucher.setUserId_merchant(shangjiaId);
        userVoucher.setUseState(State.STATE_OK);
        userVoucher.setVoucherValue_fen(voucher.getVoucherValue_fen());
        userVoucher.setLow_consumption_amount(voucher.getLow_consumption_amount());

        for (int i=0; i<fabuCount; i++){
            userVoucher.setId(new ObjectId().toString());
            serializContext.save(userVoucher);
        }
        
//        List findAll = serializContext.findAll(new UserVoucher());

            // 对应的代金券发布数量增加
        Voucher voucher_update = new Voucher();
        
		if(voucher.getVoucherOutCount() == null){
			voucher_update.addCommand(MongoCommand.set, "voucherOutCount", 0);
		}else{
			voucher_update.addCommand(MongoCommand.jiaDengyu, "voucherOutCount", fabuCount);
		}
        ContextUtil.getSerializContext().commandUpdateObject(Voucher.class,voucher.getId(),voucher_update);

        JsonObject jo = new JsonObject();
        jo.addProperty("statusCode", "200");
        jo.addProperty("message", "保存成功");
        this.setStrutsOutString(jo.toString());
        return SUCCESS;
    }



}
