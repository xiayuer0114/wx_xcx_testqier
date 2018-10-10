package com.lymava.qier.action;

import com.google.gson.JsonObject;
import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlMethod;
import com.lymava.base.util.FinalVariable;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.state.State;
import com.lymava.commons.state.StatusCode;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.MathUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.model.SerializModel;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.nosql.util.PageSplit;
import com.lymava.nosql.util.QuerySort;
import com.lymava.qier.activities.model.ActivitieMerchant;
import com.lymava.qier.business.BusinessIntIdConfigQier;
import com.lymava.qier.manager.model.UserRedEnvelopeTransfer;
import com.lymava.qier.model.Merchant72;
import com.lymava.qier.model.MerchantRedEnvelope;
import com.lymava.qier.model.TradeRecord72;
import com.lymava.trade.base.context.BusinessContext;
import com.lymava.trade.base.model.Business;
import com.lymava.trade.util.WebConfigContentTrade;
import org.bson.types.ObjectId;

import java.text.ParseException;
import java.util.*;

/**
 * 定向红包管理
 * @author lymava
 *
 */
@AcceptUrlAction(path="v2/ActivitieMerchant/",name="活动商家")
public class ActivitieMerchantAction extends LazyBaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6285710434054344790L;

	@Override
	protected Class<? extends SerializModel> getObjectClass() {
		return ActivitieMerchant.class;
	}

}
