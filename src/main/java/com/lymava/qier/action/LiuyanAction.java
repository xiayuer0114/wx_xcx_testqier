package com.lymava.qier.action;

import com.lymava.base.action.LazyBaseAction;
import com.lymava.base.safecontroler.annotation.AcceptUrlAction;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.model.SerializModel;
import com.lymava.qier.model.qianduanModel.Liuyan;

@AcceptUrlAction(path="v2/Liuyan/",name="留言管理")
public class LiuyanAction extends LazyBaseAction
{
	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	@Override
	protected Class<? extends SerializModel> getObjectClass() {
		return Liuyan.class;
	}

	@Override
	protected void listParse(Object object_find)
	{

		Liuyan liuyan = (Liuyan) object_find;

//		String object_teacher_name = this.getParameter("object.teacher_name");
//		String object_banji_id = this.getParameter("object.banji_id");

//		if (!MyUtil.isEmpty(object_teacher_name)) {
//			teacher.setTeacher_name(object_teacher_name);
//		}
//
//		if (MyUtil.isValid(object_banji_id)) {
//			teacher.setBanji_id(object_banji_id);
//		}
	}

	}
