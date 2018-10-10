package com.lymava.qier.filter;

import java.io.IOException;
import java.util.LinkedList;
import java.util.List;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.google.gson.JsonObject;
import com.lymava.base.model.User;
import com.lymava.base.util.WebConfigContent;
import com.lymava.commons.exception.CheckException;
import com.lymava.commons.state.StatusCode;
import com.lymava.commons.util.MyUtil;
import com.lymava.qier.action.CashierAction;
import com.lymava.qier.model.Merchant72;
import com.lymava.qier.util.QierUtil;
import com.lymava.userfront.util.FrontUtil;

public class UserFrontSafeControler implements Filter{
	
	private final Log logger = LogFactory.getLog(getClass());

	@Override
	public void destroy() {
		
	} 
//	public User initUser(HttpServletRequest request){
//		
//		
//		User user = (User) request.getAttribute(FinalVariable.SESSION_FRONT_FULL_USER);
//		
//		if(user != null){
//			return user;
//		}
//		
//		HttpSession session = request.getSession(false);
//	    
//	    String userId = null;
//	    
//	    if(session != null){
//	    	userId = (String) session.getAttribute(FinalVariable.SESSION_FRONT_USER);
//	    }
//	    //如果session编号为空
//	    if(!MyUtil.isValid(userId)){
//	    	return null;
//	    }
//    	
//    	if(MyUtil.isValid(userId)){
//    		user = (User) ContextUtil.getSerializContext().get(User.class, userId.toString());
//    		if(user != null){
//    			user = user.getFinalUser();
//    			request.setAttribute(FinalVariable.SESSION_FRONT_FULL_USER, user);
//    		}else{
//    			//内存里面id 还在 对象被删了
//    			session.removeAttribute(FinalVariable.SESSION_FRONT_USER);
//    		}
//    	}
//    	
//    	return user;
//	}
	
	private static final List<String> template_list = new LinkedList<String>(); 
	
	static{
		template_list.add("/merchant/");
	}
	
	/**
	 * 过滤 非登录用户
	 * 权限检测等
	 * 进行权限检测
	 */
	@Override
	public void doFilter(ServletRequest req, ServletResponse res,FilterChain filerChain) throws IOException, ServletException {
		HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
		
	    String requestPath = request.getRequestURI().substring(request.getContextPath().length());
	    requestPath = requestPath.replaceAll("/+", "/"); 
	    
	    String recharge_template = null;
	    
	    for (String recharge_template_tmp : template_list) {
	    	if (requestPath.startsWith(recharge_template_tmp) ){
	    		recharge_template = recharge_template_tmp;
	    		break;
	    	}
		}
	    
	    
	    if(recharge_template != null){
	    	
	    	String requestURI = request.getRequestURI();
	    	request.setAttribute("requestURL", MyUtil.getBasePath(request)+requestURI.substring(request.getContextPath().length()+1));
	    	
	    	String basePath = MyUtil.getBasePath(request);
	    	String basePathShort = MyUtil.getBasePathShort(request);
	    	
	    	String basePath_recharge = basePath+recharge_template.substring(1);
	    	
	    	request.setAttribute("basePath", basePath);
	    	request.setAttribute("basePathShort", basePathShort);
	    	
	    	//多根杠去掉
	    	request.setAttribute("basePath_merchant", basePath_recharge);
	    	request.setAttribute("currentTimeMillis", System.currentTimeMillis()/1000);
	    	
	    	//这个几个地址的直接放行 属于特殊url 
	    	if(  ( recharge_template+"login.jsp" ).equals(requestPath) 
						|| ( recharge_template+"hasNoPermission.jsp").equals(requestPath) 
						|| ( recharge_template+"hasNoPermissionAjax.jsp").equals(requestPath)
						|| ( recharge_template+"needLogin.jsp").equals(requestPath)  
						|| ( recharge_template+"loginOut.jsp").equals(requestPath)  
						|| ( recharge_template+"register.jsp").equals(requestPath)  
						|| ( recharge_template+"login_ajax.jsp").equals(requestPath)   ){
	    		filerChain.doFilter(request, response);
	    		return;
	    	}
	    	request.setAttribute("webConfig", WebConfigContent.getInstance());
	    	
		    //初始化登录的用户
		    User user = FrontUtil.init_http_user(request);
	    	
	    	//如果没登录 那么就返回
	    	//必须是收银员 或者 商户
	    	if(user == null
	    			||
	    			   (!CashierAction.getMerchantUserGroutId().equals(user.getUserGroupId())
	    					   &&
	    				!CashierAction.getCashierUserGroutId().equals(user.getUserGroupId())
	    			   ) 
	    			){
	    		this.parseReturnPage(request, response,recharge_template+"needLogin.jsp" );
	    		return ;
	    	}
	    	
	    	Merchant72 merchant72 = QierUtil.getMerchant72User(user);
	    	request.setAttribute("merchant72", merchant72);
	    	
	    	//执行接口
			try{
				filerChain.doFilter(request, response);
			}catch(Exception e){
				//csd
				JsonObject json_retuern = new JsonObject();
				
				Throwable cause = e.getCause();
				while(cause != null && cause.getCause() != null){
					cause = cause.getCause();
				}
				
				if(e instanceof CheckException || (cause != null && cause instanceof CheckException) ){
					CheckException checkException =  (CheckException)cause;
					
					Integer statusCode = checkException.getStatusCode();
					if(statusCode == null){ statusCode = StatusCode.ACCEPT_FALSE; }
					
					JsonObject data_root = checkException.getData_root();
					if(data_root != null){ json_retuern.add(StatusCode.statusCode_data, data_root);	 }
					
					json_retuern.addProperty(StatusCode.statusCode_key, statusCode);
					json_retuern.addProperty(StatusCode.statusCode_message_key, checkException.getMessage());
					response.getWriter().write(json_retuern.toString());
				}else{
					logger.error("系统异常!",e); 
					json_retuern.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_GUAQI);
					json_retuern.addProperty(StatusCode.statusCode_message_key, "系统繁忙!");
					response.getWriter().write(json_retuern.toString());
				}
			}
	    }else{
	    	filerChain.doFilter(request, response);
	    }
	}
	
	public  void parseReturnPage(HttpServletRequest request, HttpServletResponse response,String path) throws ServletException, IOException{ 
    	
		int lastIndexOf = path.lastIndexOf(".");
		
		//如果没有后缀
		if(lastIndexOf <= 0){
			request.getRequestDispatcher(path).forward(request, response);
			return;
		}
		
		String pathPre = path.substring(0,lastIndexOf);
		String pathLast = path.substring(lastIndexOf);
		
		String requestType = request.getHeader("X-Requested-With");
		
		 	if("XMLHttpRequest".equals(requestType) ){
				 request.getRequestDispatcher( pathPre+"_ajax"+pathLast).forward(request, response);
			 }else{
				 request.getRequestDispatcher(path).forward(request, response);
			 }
	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {
	}
}
