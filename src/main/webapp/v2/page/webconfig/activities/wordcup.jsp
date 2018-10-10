<%@page import="com.lymava.base.model.User"%>
<%@page import="com.lymava.base.model.Pub"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<fieldset >
			<dl > 
					<dt>世界杯截止</dt>
					<dd>
						<input type="hidden" name="name" value=worldCupForecast_until>
						<input type="text" name="worldCupForecast_until"    value="${webConfig_worldCupForecast_until }"   class="required date"   datefmt="yyyy-MM-dd HH:mm:ss">
					</dd> 
				</dl> 
		</fieldset>