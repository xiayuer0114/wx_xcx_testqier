package com.lymava.qier.model;

import com.lymava.base.model.Pub;
import com.lymava.commons.util.MyUtil;
import com.lymava.qier.util.WeiHtmlProcess;
import org.apache.struts2.ServletActionContext;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 孙M  6.9  这个实体主要是来保存 系统类容下-->系统类容下-->文章推荐/活动页面  的东西
 */
public class XiaochengxuPub extends Pub{

    @Override
    public void parseBeforeSave(Map parameterMap) {
        ServletContext servletContext = ServletActionContext.getServletContext();
        HttpServletRequest request = ServletActionContext.getRequest();

        String realPath = servletContext.getRealPath("/");

        String basePath = MyUtil.getBasePath(request);

        String readData = this.getContent();

        String process_weixin_html = WeiHtmlProcess.process_weixin_html(readData,basePath,realPath, this.getId());
        this.setContent(process_weixin_html);
    }
}
