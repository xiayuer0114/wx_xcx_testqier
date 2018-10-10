package com.lymava.qier.activities.action;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.model.SerializModel;
import com.lymava.qier.activities.model.WorldCupForecast;
import com.lymava.qier.activities.model.XingGeTest;

@AcceptUrlAction(path="v2/XingGeTest/",name="性格测试")
public class XingGeTestAction extends LazyBaseAction {
    /**
	 * 
	 */
	private static final long serialVersionUID = -1192989015263667855L;

	@Override
    protected Class<? extends SerializModel> getObjectClass() {
        return XingGeTest.class;
    }

    @Override
    protected void listParse(Object object_find) {

		XingGeTest xingGeTest = (XingGeTest)object_find;
		String test_name = this.getParameter("test_name");

		if (!MyUtil.isEmpty(test_name)) {
			xingGeTest.setTest_name(test_name);
		}

    }

	public String save() {
		XingGeTest xingGeTest_save =new XingGeTest();

		String test_name=this.getParameter("test_name");
		String da_an=this.getParameter("da_an");
		String result_img=this.getParameter("result_img");
		int state=Integer.parseInt(this.getParameter("state"));
		xingGeTest_save.setTest_name(test_name);
		xingGeTest_save.setDa_an(da_an);
		xingGeTest_save.setResult_img(result_img);
		xingGeTest_save.setState(state);
		serializContext.save(xingGeTest_save);
		return SUCCESS;
	} 

}