package com.lymava.qier.action;

import static java.lang.System.currentTimeMillis;

import java.io.File;
import java.text.ParseException;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import com.lymava.base.action.BaseAction;
import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.base.vo.StatusCode;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.state.State;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.nosql.util.PageSplit;
import com.lymava.qier.model.UserVoucher;
import com.lymava.qier.model.Voucher;
import com.lymava.qier.util.SunmingUtil;
import com.lymava.userfront.util.FrontUtil;
import com.mongodb.BasicDBList;

public class VoucherAction extends BaseAction {


    /** 
	 * 
	 */
	private static final long serialVersionUID = 1215725501784800675L;
	private Voucher voucher;

    public Voucher getVoucher() {
        return voucher;
    }

    public void setVoucher(Voucher voucher) {
        this.voucher = voucher;
    }


    /**
     *检查登录
     */
    public User check_login_user() {
        User init_http_user = FrontUtil.init_http_user(request);
        CheckException.checkIsTure(init_http_user != null, "请先登录!", StatusCode.USER_INFO_TIMEOUT);
        return init_http_user;
    }


    /**
     *  填写一种代金券的信息  填写和修改方法写在一起的
     * @return
     */
    public String voucher_add() {
        User init_http_user = this.check_login_user();

        Voucher voucher_add = new Voucher();


        String voucherName = request.getParameter("voucherName");
        String voucherValue = request.getParameter("voucherValue");
        String voucherCount = request.getParameter("voucherCount");
        String releaseTime = request.getParameter("releaseTime");

        String useWhere = request.getParameter("useWhere");;
        String voucherMiaoSu = request.getParameter("voucherMiaoSu");
        String stopTime = request.getParameter("stopTime");

        String useReleaseTime = request.getParameter("useReleaseTime");
        String useStopTime = request.getParameter("useStopTime");

        // 必填项数据完整性校验
        if(SunmingUtil.strIsNull(voucherName) || SunmingUtil.strIsNull(voucherValue) || SunmingUtil.strIsNull(voucherCount) ||  SunmingUtil.strIsNull(releaseTime)){
            this.setStatusCode(com.lymava.commons.state.StatusCode.ACCEPT_FALSE);
            this.setMessage("数据不完整! ");
            return SUCCESS;
        }

        voucher_add.setVoucherName(voucherName);


        Long releaseDateTime = SunmingUtil.dateStrToLongYMD_h(releaseTime);
        Long stopDateTime;


        // 发布的起止时间判断
        if(releaseDateTime == null  ||  releaseDateTime < DateUtil.getDayStartTime()){
            this.setStatusCode(com.lymava.commons.state.StatusCode.ACCEPT_FALSE);
            this.setMessage("开始时间要大于今天! ");
            return SUCCESS;
        }
        voucher_add.setReleaseTime(releaseDateTime);
        stopDateTime = SunmingUtil.dateStrToLongYMD_h(stopTime);
        if(!SunmingUtil.strIsNull(stopTime) && null != stopDateTime){
            if (stopDateTime < releaseDateTime){
                this.setStatusCode(com.lymava.commons.state.StatusCode.ACCEPT_FALSE);
                this.setMessage("结束时间要大于发布时间! ");
                return SUCCESS;
            }
            voucher_add.setStopTime(stopDateTime);
        }else {
            voucher_add.setStopTime(SunmingUtil.dateStrToLongYMD("2999-12-12"));
        }


        // 数值数据校验
        if (null == MathUtil.parseDoubleNull(voucherValue)  ||  null == MathUtil.parseIntegerNull(voucherCount)){
            this.setStatusCode(com.lymava.commons.state.StatusCode.ACCEPT_FALSE);
            this.setMessage("代金券面额必须为数字!  数量必须为整数!  使用条件必须为数字! ");
            return SUCCESS;
        };
        voucher_add.setVoucherValue(MathUtil.parseDoubleNull(voucherValue));
        voucher_add.setVoucherCount(MathUtil.parseIntegerNull(voucherCount));


        if (!SunmingUtil.strIsNull(useWhere)){
            if(null == MathUtil.parseLongNull(useWhere)){
                this.setStatusCode(com.lymava.commons.state.StatusCode.ACCEPT_FALSE);
                this.setMessage("代金券面额必须为数字!  数量必须为整数!  使用条件必须为整数!");
                return SUCCESS;
            }
            voucher_add.setUseWhere(MathUtil.parseLongNull(useWhere));
        }


        // 有效使用时间的判断
        Long startTime = SunmingUtil.dateStrToLongYMD_h(useReleaseTime);
        if(!SunmingUtil.strIsNull(useReleaseTime) &&  startTime != null){
            startTime = SunmingUtil.dateStrToLongYMD_h(useReleaseTime);
            voucher_add.setUseReleaseTime(startTime);
        }
        // 有效使用结束时间的判断
        Long endTime = SunmingUtil.dateStrToLongYMD_h(useStopTime);
        if(!SunmingUtil.strIsNull(useStopTime) && endTime != null){
            endTime = SunmingUtil.dateStrToLongYMD(useStopTime);
            voucher_add.setUseStopTime(endTime);
        }
        if((endTime != null && startTime != null ) && endTime<=startTime){
            this.setStatusCode(com.lymava.commons.state.StatusCode.ACCEPT_FALSE);
            this.setMessage("限时使用的开始时间小于了结束时间!");
            return SUCCESS;
        }

        voucher_add.setVoucherMiaoSu(voucherMiaoSu);
        voucher_add.setState(Voucher.voucherState_editing);
        voucher_add.setUser_merchant(init_http_user);
        voucher_add.setVoucherOutCount(0);


        // 得到操作符
        String op = request.getParameter("op");

        //返回输出类容  修改和添加
        if("update".equals(op)){
            String id = request.getParameter("id");
            if (!SunmingUtil.strIsNull(id)){
                ContextUtil.getSerializContext().updateObject(id,voucher_add);
            }

            this.setStatusCode(StatusCode.ACCEPT_OK);
            this.setMessage("修改成功！");
            return SUCCESS;
        }else {
            ContextUtil.getSerializContext().save(voucher_add);

            this.setStatusCode(StatusCode.ACCEPT_OK);
            this.setMessage("添加成功！ 请确定信息后,提交审核...");
            return SUCCESS;
        }
    }





    /**
     *   发布 和 删除
     * @return
     */
    public String addVoucher(){
        String voucherId = request.getParameter("voucherId");

        Voucher voucherAdd = new Voucher();
        voucherAdd.setState(4);

        ContextUtil.getSerializContext().updateObject(voucherId,voucherAdd);

        this.setMessage("发布成功, 等待审核...");
        return SUCCESS;
    };
    public String delVoucher(){
        String voucherId = request.getParameter("voucherId");

        Voucher voucherDel = new Voucher();
        voucherDel.setId(voucherId);

        ContextUtil.getSerializContext().removeByKey(voucherDel);

        this.setMessage("删除成功...");
        return SUCCESS;
    };

    /**
     *  结束发布
     */
    public String endVoucher() {
        String voucherId = request.getParameter("voucherId");
        String outCount = request.getParameter("outCount");

        Voucher endVoucher = new Voucher();
        endVoucher.setId(voucherId);
        endVoucher.setVoucherCount(Integer.parseInt(outCount));

        ContextUtil.getSerializContext().updateObject(voucherId,endVoucher);
        this.setMessage("已经结束.");
        return SUCCESS;
    }


    /**
     * 修改后重新发布
     * @return
     */
    public String revampVoucher() {
        String voucherId = request.getParameter("voucherId");
        String countAll = request.getParameter("countAll");
        String date = request.getParameter("date");

        try {
            if (date!=null && !"".equals(date)){
                Date date1 = DateUtil.getSdfShort().parse(date);
                CheckException.checkIsTure(date1.getTime()>currentTimeMillis(),"有效时间至少是明天!.");
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }

        Voucher voucher = new Voucher();
        voucher.setId(voucherId);
        voucher = (Voucher)ContextUtil.getSerializContext().get(voucher);
        Integer newcountAll = (Integer.parseInt(countAll)+voucher.getVoucherCount());

        Voucher voucher1 = new Voucher();
        voucher1.setVoucherCount(newcountAll);

        voucher1.setInStopTime(date);
        voucher1.setState(1);

        ContextUtil.getSerializContext().updateObject(voucherId,voucher1);

        this.setMessage("修改成功.");
        return SUCCESS;
    }


    /**
     * 检查这个金额  能使用的一些代金券
     * @return
     */
    public String checkVoucherCount(){

        String userId = (String) request.getSession().getAttribute("check_user_id");
        String merchantId = (String) request.getSession().getAttribute("check_merchant_id");

        double sum_double = (MathUtil.parseDouble(request.getParameter("sum"))*100);
        Long sum = Math.round(sum_double);

        UserVoucher userVoucher_find = new UserVoucher();
        userVoucher_find.setUserId_huiyuan(userId);
        userVoucher_find.setUseState(State.STATE_OK);
        userVoucher_find.addCommand(MongoCommand.in, "userId_merchant", merchantId);
        userVoucher_find.addCommand(MongoCommand.in, "userId_merchant", MerchantShowAction.getSysMerchantId());

        // 查询
        PageSplit pageSplit = new PageSplit();
        pageSplit.setPageSize(5);
        Iterator<UserVoucher> userVoucher_list = ContextUtil.getSerializContext().findIterable(userVoucher_find,pageSplit);

        Long sysTime = System.currentTimeMillis();
        List<UserVoucher> userVoucher_list_read = new LinkedList<>();
        while (userVoucher_list.hasNext()){
            UserVoucher bijiao =  userVoucher_list.next();
            // 使用时间在有效时间内
            Voucher voucher_panduan = bijiao.getVoucher();

            // 可以使用的开始时间和可以使用的结束时间的判断
            if(voucher_panduan.getUseReleaseTime() != null ){
                if(voucher_panduan.getUseReleaseTime() > sysTime){
                    continue;
                }
            }
            if(voucher_panduan.getUseStopTime() != null ){
                if(voucher_panduan.getUseStopTime() < sysTime){
                    continue;
                }
            }
            // 金额判断
            if (sum !=0L  &&  sum<(voucher_panduan.getUseWhere()*100)){
                continue;
            }

            userVoucher_list_read.add(bijiao);
        }

        this.setStatusCode(StatusCode.ACCEPT_OK);
        this.setMessage(userVoucher_list_read.size()+"");
        return SUCCESS;
    }

}
