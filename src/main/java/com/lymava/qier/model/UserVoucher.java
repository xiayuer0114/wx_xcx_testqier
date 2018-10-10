package com.lymava.qier.model;

import com.lymava.base.model.User;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.state.State;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.mongodb.vo.BaseModel;
/**
 * 用户代金卷
 * @author lymava
 *
 */
public class UserVoucher extends BaseModel{

	/**
	 * 
	 */
	private static final long serialVersionUID = -4252130904028036874L;
	/**
	 * 商户
	 */
	private Merchant72 user_merchant;
	/**
	 * 商户系统编号
	 */
	private String userId_merchant;
	/**
	 * 会员
	 */
	private User user_huiyuan;
	/**
	 * 会员系统编号
	 */
	private String userId_huiyuan;
	/**
	 * 代金卷
	 */
	private Voucher voucher;
     /**
      * 代金券id
      */
    private String voucherId;
    /**
     * 代金券价值	单位分
     */
    private Long voucherValue_fen;
    /**
     * 最低消费额	单位元
     */
    private Long low_consumption_amount;
    /**
     * 最高消费额	单位元
     */
    private Long hight_consumption_amount;
    /**
     * 使用状态
     */
    private Integer useState;
    
    static {
		Class<?> classTmp = UserVoucher.class;
		
		putConfig(classTmp, "st_" + State.STATE_OK, "正常");
		putConfig(classTmp, "st_" + State.STATE_FALSE, "不能使用");
		putConfig(classTmp, "st_" + State.STATE_CLOSED, "已过期"); 
		putConfig(classTmp, "st_" + State.STATE_PAY_SUCCESS, "已使用");
	}
    
	public Long getHight_consumption_amount() {
		return hight_consumption_amount;
	}
	public void setHight_consumption_amount(Long hight_consumption_amount) {
		this.hight_consumption_amount = hight_consumption_amount;
	}
	public Long getVoucherValue_fen() {
		return voucherValue_fen;
	}
	public void setVoucherValue_fen(Long voucherValue_fen) {
		this.voucherValue_fen = voucherValue_fen;
	}
	public Long getLow_consumption_amount() {
		return low_consumption_amount;
	}
	public void setLow_consumption_amount(Long low_consumption_amount) {
		this.low_consumption_amount = low_consumption_amount;
	}
	public String getShowUseState() {
		String state = (String) getConfig("st_" + this.useState);
		if (state == null) {
			state = "无";
		}
		return state;
	}
	public String getUserId_merchant() {
		return userId_merchant;
	}

	public void setUserId_merchant(String userId_merchant) {
		this.userId_merchant = userId_merchant;
	}

	public String getUserId_huiyuan() {
		return userId_huiyuan;
	}

	public void setUserId_huiyuan(String userId_huiyuan) {
		this.userId_huiyuan = userId_huiyuan;
	}

	public Voucher getVoucher() {
		if (voucher == null && MyUtil.isValid(this.voucherId)) {
			voucher = (Voucher) ContextUtil.getSerializContext().get(Voucher.class, voucherId);
		}
		return voucher;
	}

	public void setVoucher(Voucher voucher) {
		this.voucher = voucher;
	}

	public User getUser_huiyuan() {
		if (user_huiyuan == null && MyUtil.isValid(this.userId_huiyuan)) {
			user_huiyuan = (User) ContextUtil.getSerializContext().get(User.class, userId_huiyuan);
		}
		return user_huiyuan;
	}

	public void setUser_huiyuan(User user_huiyuan) {
		if (user_huiyuan != null) {
			userId_huiyuan = user_huiyuan.getId();
		}
		this.user_huiyuan = user_huiyuan;
	}
	public User getUser_merchant() {
		if (user_merchant == null && MyUtil.isValid(this.userId_merchant)) {
			user_merchant = (Merchant72) ContextUtil.getSerializContext().get(Merchant72.class, userId_merchant);
		}
		return user_merchant;
	}
	public void setUser_merchant(Merchant72 user_merchant) {
		if (user_merchant != null) {
			userId_merchant = user_merchant.getId();
		}
		this.user_merchant = user_merchant;
	}
    public String getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(String voucherId) {
        this.voucherId = voucherId;
    }

    public Integer getUseState() {
        return useState;
    }
    public void setUseState(Integer useState) {
        this.useState = useState;
    }
    
}
