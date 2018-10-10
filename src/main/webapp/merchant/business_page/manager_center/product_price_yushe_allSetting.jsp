<%@page import="com.lymava.commons.state.State"%>
<%@ page import="com.lymava.qier.model.Product72" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<div style="padding:30px;" class="form-horizontal" role="form">
	<div class="form-group">
		<label class="col-sm-2 control-label" style="width:40%;">开启预设</label>
		<div class="col-sm-10"  style="width:60%;">
			 <select class="form-control"  name="product72_all_open" id="product72_all_open" >
                <option value="<%= Product72.yushe_state_kaiqi%>">开启</option>
                <option value="<%= Product72.yushe_state_guanbi%>">关闭</option>
            </select>
		</div>
	</div> 
	<div class="form-group">
		<label class="col-sm-2 control-label" style="width:40%;">收取餐位费</label>
		<div class="col-sm-10"  style="width:60%;">
			 <select class="form-control"  name="canweifei_state_all" id="canweifei_state_all" >
                <option value="<%= State.STATE_FALSE %>">不收取</option>
                <option value="<%= State.STATE_OK%>">收取</option>
            </select>
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-2 control-label" style="width:40%;">初始餐位费</label>
		<div class="col-sm-10"  style="width:60%;">
			<input  type="text" class="form-control" id="chushi_canweifei" value="" placeholder="初始餐位费">
		</div>
	</div>  
    <div class="form-group">
        <div class="input-icon" style="color: #0c91e5">
            温馨提示: <br>
            在此处设置, 会开启或关闭所有收银牌的预设值功能, 同时也会修改所有收银牌的餐位费
        </div>
    </div>
</div>