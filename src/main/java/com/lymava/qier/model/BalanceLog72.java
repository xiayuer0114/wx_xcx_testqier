package com.lymava.qier.model;

import com.lymava.base.model.BalanceLog;

public class BalanceLog72 extends BalanceLog {

    // 充值金额  每次的余额变动我们实际向商家打的钱    (面值金额-折扣额)
    private Long topUpBalance;


    // 折扣额  每次的余额变动我们赚的钱   (面值金额-充值金额)
    private Long discount;






    public Long getDiscount() {
        return discount;
    }

    public void setDiscount(Long discount) {
        this.discount = discount;
    }

    public Long getTopUpBalance() {
        return topUpBalance;
    }

    public void setTopUpBalance(Long topUpBalance) {
        this.topUpBalance = topUpBalance;
    }
}
