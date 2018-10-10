package com.lymava.qier.activities.model;

import com.lymava.commons.state.State;
import com.lymava.nosql.mongodb.vo.BaseModel;
/**
 * 录取通知书  活动
 * */
public class Notice extends BaseModel {
  /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
/**
 * 考生姓名
 * */	
private String name;
/**
  * 身份证号
 * */
private Long idNumber;
/**
 * 考生证
 * */	
private Long examineeCard;
/**
 * 报名序号
 * */
private Long signUpSerialNumber;

/**
 *  性别    少男  少女
 * */
 private Integer sex;
 
 static{
		putConfig(Notice.class, "sex_"+State.STATE_OK, "少男");
		putConfig(Notice.class, "sex_"+State.STATE_FALSE, "少女");
 }
 public String getShowSex(){
	 return (String) getConfig("state_"+this.getSex());
} 
 /**
  * 文科  理科
  * */
 private Integer artsAndScience;
 
 static{
		putConfig(Notice.class, "artsAndScience_"+State.STATE_OK, "文科");
		putConfig(Notice.class, "artsAndScience_"+State.STATE_FALSE, "理科");
}
public String getShowArtsAndScience(){
	 return (String) getConfig("state_"+this.getArtsAndScience());
} 
 
public Long getExamineeCard() {
	return examineeCard;
}

public void setExamineeCard(Long examineeCard) {
	this.examineeCard = examineeCard;
}

public Long getSignUpSerialNumber() {
	return signUpSerialNumber;
}

public void setSignUpSerialNumber(Long signUpSerialNumber) {
	this.signUpSerialNumber = signUpSerialNumber;
}



public String getName() {
	return name;
}
public void setName(String name) {
	this.name = name;
}
public Long getIdNumber() {
	return idNumber;
}
public void setIdNumber(Long idNumber) {
	this.idNumber = idNumber;
}
public Integer getSex() {
	return sex;
}
public void setSex(Integer sex) {
	this.sex = sex;
}
public Integer getArtsAndScience() {
	return artsAndScience;
}
public void setArtsAndScience(Integer artsAndScience) {
	this.artsAndScience = artsAndScience;
}
 
 

 

	
	
	

}
