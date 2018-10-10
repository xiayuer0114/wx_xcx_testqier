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
			<auth:if test="v2/Merchant72/change_ratio.do"  >
				<li><a class="edit" href="${basePath  }v2/huiyuan/edit.do?return_mod=red_envolope&id={id}" target="dialog" title="返利配置" rel="editHuiyuan"><span>返利配置</span></a></li>
				<li class="line">line</li>
			</auth:if>
			<auth:if test="v2/Merchant72/merchant_redenvelope_balance_change.do" >
				<li><a class="edit" href="${basePath  }v2/huiyuan/edit.do?return_mod=merchant_redenvelope_balance_change&id={id}" target="dialog" title="定向红包变动" rel="editHuiyuan"><span>定向红包变动</span></a></li>
				<li class="line">line</li>
			</auth:if>

			<%-- todo 设置权限 --%>
				<li><a class="edit" href="${basePath  }v2/merchant72user/bankEdit.do?id={id}" target="dialog" title="商户银行编辑" rel="editHuiyuan"><span>商户银行变更</span></a></li>
				<li class="line">line</li>

				<li><a class="edit" href="${basePath  }v2/merchant72user/checkLiuShui.do?id={id}" target="dialog" title="流水检测" rel="editHuiyuan"><span>流水检测</span></a></li>
				<li class="line">line</li>

				<li><a class="edit" href="${basePath  }v2/merchant72user/yuxiajia.do?merchantId={id}" target="dialog" title="预下架" rel="editHuiyuan"><span>预下架</span></a></li>
				<li class="line">line</li>

				<li><a class="edit" href="${basePath  }v2/merchant72user/hongbaozhuanyi.do?merchantId={id}" target="dialog" title="红包转移" rel="editHuiyuan"><span>红包转移</span></a></li>
				<li class="line">line</li>

			<auth:if test="v2/huiyuan/resetPassword.do">
				<li><a class="icon" href="${basePath  }v2/huiyuan/edit.do?return_mod=changepasswd&id={id}" target="dialog"   title="密码重置"><span>密码</span></a></li>
				<li class="line">line</li>
			</auth:if>
			<auth:if test="v2/huiyuan/resetPayPass.do">
				<li><a class="icon" href="${basePath  }v2/huiyuan/edit.do?return_mod=payPass&id={id}" target="dialog"   title="支付密码重置"><span>支付密码</span></a></li>
				<li class="line">line</li>
			</auth:if>
			<auth:if test="v2/huiyuan/resetUserName.do">
				<li><a class="icon" href="${basePath  }v2/huiyuan/edit.do?return_mod=username&id={id}" target="dialog"   title="重置登录名"><span>重置登录名</span></a></li>
				<li class="line">line</li> 
			</auth:if>
			<auth:if test="v2/huiyuan/resetKey.do">
				<li><a class="icon" href="${basePath  }v2/huiyuan/edit.do?return_mod=key&id={id}" target="dialog"   title="密钥重置"><span>密钥</span></a></li>
				<li class="line">line</li>
			</auth:if>
			<%--<auth:if test="v2/Merchant72/merchant_balance_change.do">
				<li><a class="add" href="${basePath  }v2/huiyuan/edit.do?return_mod=merchant_balance&id={id}" target="dialog"   title="商户预付款变动"><span>商户预付款变动</span></a></li>
				<li class="line">line</li>
			</auth:if>--%>
			<auth:if test="v2/huiyuan/delete.do">
				<li><a class="delete" rootPubConlumnId="${currentTimeMillis }" link="${basePath  }v2/huiyuan/delete.do"   title="确定要删除吗?"><span>删除</span></a></li>
				<li class="line">line</li>
			</auth:if>
			<auth:if test="v2/TransferToMerchantRecord/transfer_to_merchant.do">
				<li><a class="add" href="${basePath  }v2/huiyuan/edit.do?return_mod=transfer_to_merchant&id={id}" target="dialog"   title="商户转款"><span>商户转款</span></a></li>
				<li class="line">line</li>
			</auth:if>
			<auth:if test="v2/TransferToMerchantRecord/save_transferToMerchantRecord.do">
				<li><a class="add" href="${basePath  }v2/huiyuan/edit.do?return_mod=manual_transfer_to_merchant&id={id}" target="dialog"   title="手动转账"><span>手动转账</span></a></li>
				<li class="line">line</li>
			</auth:if> 
			<li><a class="edit" href="${basePath  }v2/huiyuan/edit.do?return_mod=redirect_to_merchant_login&id={id}" target="dialog"   title="登录商户后台"><span>登录商户后台</span></a></li>
			<li class="line">line</li>
		</ul>
	</div>