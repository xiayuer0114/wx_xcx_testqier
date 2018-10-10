package com.lymava.qier.util;

import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.nosql.model.SerializModel;
import com.lymava.nosql.mongodb.util.MongoCommand;
import com.lymava.nosql.mongodb.vo.BaseModel;

import org.bson.types.ObjectId;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class SunmingUtil {

    /**
     * 判断一个字符串是不是null或者""
     * @param s
     * @return
     */
    public static boolean strIsNull(String s){
        if(s == null || "".equals(s) || "" == s || s.trim().isEmpty()){
            return true;
        }
        return false;
    };


    /**
     * 判断一个集合是否为空 长度是否正常  返回0或集合的长度
     * @param list
     * @return
     */
    public static Integer listIsNull(List<?> list){
        if(list == null || list.size() == 0){
            return 0;
        }
        return list.size();
    };


    /**
     * 单纯的为一个查询的实体 添加时间的查询条件
     * @param model
     * @param start_time
     * @param end_time
     * @return
     */
    public static SerializModel setQueryWhere_time(BaseModel model, Long start_time, Long end_time){

        if(start_time != null && model.getId() == null) {
            ObjectId start_object_id = new ObjectId(new Date(start_time));
            model.addCommand(MongoCommand.dayuAndDengyu, "id", start_object_id);
        }

        if(end_time != null && model.getId() == null){
            ObjectId end_object_id = new ObjectId(new Date(end_time));
            model.addCommand(MongoCommand.xiaoyu, "id", end_object_id);
        }

        return model;
    }



    /**
     * 单纯的为一个查询的实体 设置条件为'或'的查询(单字段)
     * @param model     实体
     * @param name      字段名
     * @param objectValue     字段名对应的值得集合
     * @return
     */
    public static SerializModel setQueryWhere_or(SerializModel model,String name, Object...objectValue){
        for (int i= 0; i<objectValue.length; i++){
            model.addCommand(MongoCommand.in, name, objectValue[i]);  //  系统内容下的商家展示
        }
        return model;
    }



    /**
     * 传入一个字符串的时间(yyyy-MM-dd)  转换成时间戳
     * @param DateStr
     * @return
     */
    public static Long dateStrToLongYMD(String DateStr){
        Date date = null;
        try {
            date = DateUtil.getSdfShort().parse(DateStr);
        } catch (ParseException e) {
            return null;
        }
        return date.getTime();
    }

    /**
     * 传入一个字符串的时间(yyyy-MM-dd hh)  转换成时间戳
     * @param DateStr
     * @return
     */
    public static Long dateStrToLongYMD_h(String DateStr){
        DateStr = DateStr+":00";

        Date date = null;
        try {
            date = DateUtil.getSdfYmdhm().parse(DateStr);
        } catch (ParseException e) {
            return null;
        }
        return date.getTime();
    }


    /**
     * 传入一个字符串的时间(yyyy-MM-dd HH:mm:ss)  转换成时间戳
     * @param dateStr
     * @return
     */
    public static Long dateStrToLongYMD_hms(String dateStr){
        Date date = null;

        if (strIsNull(dateStr)){return null;}

        try {
        	
            date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(dateStr);
        } catch (ParseException e) {
            return null;
        }
        return date.getTime();
    }



    /**
     * 传入一个的时间戳    得到这个时间的月初的时间0点0分0秒的时间戳(如:2018-04-01 00:00:00的时间戳)
     * @param dateLong
     * @return
     */
    public static Long getCurrentStartMonth(Long dateLong){

        Date date = new Date(dateLong);

        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM");

        String dateStr = "";

        dateStr = simpleDateFormat.format(date);

        try {
            date =  simpleDateFormat.parse(dateStr);
        } catch (ParseException e) {
            return null;
        }

        return date.getTime();
    }



    /**
     * 传入一个的时间戳  装换成中文数据(样式: 2018年6月4号 12点36分24秒)  一般用于显示
     * @param dateLong
     * @return
     */
    public static String longDateToStrDate_tall(Long dateLong){

        Date date = new Date(dateLong);

        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy年MM月dd号 HH点mm分ss秒");

        String dateStr = "";
        dateStr = simpleDateFormat.format(date);

        return dateStr;
    };



    /**
     *  传入一个 被偏移的值 和 偏移数  返回一个祝字符串
     * @param balance   被偏移的值  大于0
     * @param pianyi    偏移数   大于0  一般来说这个pianyi值为开头为1后面全是0的数
     * @return
     */
    public static String longToStr_pianyi(Long balance, Long pianyi){
        if(balance==null){return "";};
        if(pianyi==null){return "";};

        //丢   有些数据就是负数的
//        if(balance<=0){return "";};
        if(pianyi<=0){return "";};

        Double balance_D = (double)balance;
        Double out_D = balance_D/pianyi;

        return out_D+"";
    }


    /**
     * 根据id(objectid) 获取到时间
     * @param id  模型的id
     * @return   返回时间错
     */
    public static Long getlongTimeById(String id){
        if (!MyUtil.isValid(id)){
            return null;
        }

        Long time = new ObjectId(id).getDate().getTime();

        return time;
    }



}
