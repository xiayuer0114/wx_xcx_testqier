<%@page import="com.lymava.base.model.User"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<c:if test="${front_user.payPwdState == 1 }">
	<div class="form-group confirm-paypassword">
      <label class="control-label col-md-3">支付密码</label>
        <div class="col-md-3" style="margin-right: 3px;margin-right: 3px; padding-right: 3px;">
            <div class="input-icon input-icon-md">
                <i class="fa fa-asterisk"></i>
                <input type="password" autocomplete="off" class="form-control input-md" name="confirm_paypassword">
            </div>
        </div>
    </div>
</c:if>