<%@page import="com.lymava.base.model.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="auth" uri="http://tiesh.liebianzhe.com/tag/auth" %>
<div class="panelBar">
		<ul class="toolBar">
			<auth:if test="v2/huiyuan/add.do">
				<li><a class="add" href="${basePath  }${auth_url }?userGroup_id=${userGroup.id }" target="dialog" rel="addHuiyuan"><span>添加</span></a></li>
				<li class="line">line</li>
			</auth:if>
			<auth:if test="v2/huiyuan/save.do" auth_url="v2/huiyuan/edit.do">
				<li><a class="edit" href="${basePath  }${auth_url }?id={id}" target="dialog" title="资料编辑" rel="editHuiyuan"><span>编辑</span></a></li>
				<li class="line">line</li>
			</auth:if>
			<auth:if test="v2/huiyuan/resetPassword.do">
				<li><a class="icon" href="${basePath  }v2/huiyuan/edit.do?return_mod=changepasswd&id={id}" target="dialog"   title="密码重置"><span>密码</span></a></li>
				<li class="line">line</li>
			</auth:if>
			<auth:if test="v2/huiyuan/resetUserName.do">
				<li><a class="icon" href="${basePath  }v2/huiyuan/edit.do?return_mod=username&id={id}" target="dialog"   title="重置登录名"><span>重置登录名</span></a></li>
				<li class="line">line</li>
			</auth:if>
			<auth:if test="v2/huiyuan/resetPayPass.do">
				<li><a class="icon" href="${basePath  }v2/huiyuan/edit.do?return_mod=payPass&id={id}" target="dialog"   title="支付密码重置"><span>支付密码</span></a></li>
				<li class="line">line</li>
			</auth:if>
			<auth:if test="v2/huiyuan/resetKey.do">
				<li><a class="icon" href="${basePath  }v2/huiyuan/edit.do?return_mod=key&id={id}" target="dialog"   title="密钥重置"><span>密钥</span></a></li>
				<li class="line">line</li>
			</auth:if>
			<auth:if test="v2/huiyuan/balanceChange.do">
				<li><a class="add" href="${basePath  }v2/huiyuan/edit.do?return_mod=balance&id={id}" target="dialog"   title="余额变动"><span>余额变动</span></a></li>
				<li class="line">line</li>
			</auth:if>
			<auth:if test="v2/huiyuan/integralChange.do">
				<li><a class="edit" href="${basePath  }v2/huiyuan/edit.do?return_mod=integral&id={id}" target="dialog"   title="积分变动"><span>积分变动</span></a></li>
				<li class="line">line</li>
			</auth:if>
			<auth:if test="v2/huiyuan/frozenBalanceChange.do">
				<li><a class="edit" href="${basePath  }v2/huiyuan/edit.do?return_mod=frozenBalance&id={id}" target="dialog"   title="冻结金额变动"><span>冻结金额</span></a></li>
				<li class="line">line</li>
			</auth:if>
			<auth:if test="v2/huiyuan/delete.do">
				<li><a class="delete" rootPubConlumnId="${currentTimeMillis }" link="${basePath  }v2/huiyuan/delete.do"   title="确定要删除吗?"><span>删除</span></a></li>
				<li class="line">line</li>
			</auth:if>
			<auth:if test="v2/huiyuan/resetIpList.do">
				<li><a class="icon" href="${basePath  }v2/huiyuan/edit.do?return_mod=iplist&id={id}" target="dialog"   title="ip绑定"><span>ip绑定</span></a></li>
				<li class="line">line</li>
			</auth:if>
			<auth:if test="v2/huiyuan/resetNotifyUrl.do">
				<li><a class="icon" href="${basePath  }v2/huiyuan/edit.do?return_mod=notify_url&id={id}" target="dialog"   title="回调管理"><span>回调管理</span></a></li>
			</auth:if>
		</ul>
	</div>