<%@page import="com.lymava.base.safecontroler.model.UserRole"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript">
    jQuery(function(){
        resetDialog();
    });
</script>
<div class="pageContent" id="${currentTimeMillis }"  >
    <form method="post" action="${basePath }v2/userrole/save.do"class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone);">
        <div class="pageFormContent" layoutH="56">
            <fieldset  >
                <dl>
                    <dt>职位：</dt>
                    <dd  >
                        <input type="hidden" name="userRole.id" value="${userRole.id }"  />
                        <input type="text" name="userRole.roleName"  value="${userRole.role.name }"   class="required">
                        <input type="hidden"  name="userRole.roleId"  value="${userRole.roleId }"   >
                        <a class="btnLook" href="${basePath }v2/role/list.do?return_mod=lookup"  lookupGroup="userRole"  >查找</a>
                    </dd>
                </dl>
                <div class="divider"></div>
                <dl>
                    <dt>员工：</dt>
                    <dd class="lookup_dd" >
                        <input type="text" name="userRole.userv2ShowName"  value="${userRole.userV2.showName }"   class="required">
                        <input type="hidden"  name="userRole.userV2Id"  value="${userRole.userV2Id }"   >
                        <a class="btnLook" href="${basePath }v2/userv2/list.do?return_mod=lookup"  lookupGroup="userRole"  >查找</a>
                    </dd>
                </dl>
                <div class="divider"></div>
                <dl>
                    <dt>描述：</dt>
                    <dd  >
                        <input type="text" name="userRole.memo" value="${userRole.memo }"  >
                    </dd>
                </dl>
                <div class="divider"></div>
                <dl >
                    <dt>状态：</dt>
                    <dd >
                        <select name="userRole.state"  class="required combox" svalue="${userRole.state }">
                            <option  value="<%=UserRole.STATE_OK %>" >正常</option>
                            <option  value="<%=UserRole.STATE_NOTOK %>" >异常</option>
                        </select>
                    </dd>
                </dl>
            </fieldset>
        </div>
        <div class="formBar">
            <ul>
                <li><div class="buttonActive"><div class="buttonContent"><button type="submit">保存</button></div></div></li>
                <li>
                    <div class="button"><div class="buttonContent"><button type="button" class="close">取消</button></div></div>
                </li>
            </ul>
        </div>
    </form>
</div>