package com.lymava.qier.model;

import com.lymava.base.model.Pub;
import com.lymava.base.util.ContextUtil;
import com.lymava.commons.util.MyUtil;

public class JifenDuihuanVoucherPub extends JifenDuihuanPub{

    /**
     * 代金卷
     */
    private Voucher voucher;
    /**
     * 代金券id
     */
    private String voucherId;

    public Voucher getVoucher() {
        if (voucher == null && MyUtil.isValid(this.voucherId)) {
            voucher = (Voucher) ContextUtil.getSerializContext().get(Voucher.class, voucherId);
        }
        return voucher;
    }

    public void setVoucher(Voucher voucher) {
        this.voucher = voucher;
    }

    public String getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(String voucherId) {
        this.voucherId = voucherId;
    }
}
