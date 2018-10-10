package com.lymava.qier.util;

import java.net.UnknownHostException;
import java.util.List;

import org.dom4j.DocumentException;

import com.lymava.base.model.Pub;
import com.lymava.nosql.mongodb.MongoContext;
import com.lymava.nosql.util.PageSplit;
import com.mongodb.MongoException;

public class Test {

	// 测试修改分支名字

	// adasasd
	public static void main(String[] args) throws Exception {
		
		MongoContext mongoContext = new MongoContext("conf/mongo.xml");

		//Pub
//		PageSplit pageSplit = new PageSplit("1", "15");
//		List<Pub> findAll = mongoContext.findAll(new Pub(),pageSplit);
//		for (Pub object : findAll) {
//
//			System.out.println(object.getName());
//
//		}

		//
	}
	
}
