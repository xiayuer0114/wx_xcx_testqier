package com.lymava.qier.util;

import com.lymava.commons.http.HttpsGet;


import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class DiLiUtil {


    private static  double EARTH_RADIUS = 6378.137d;

    private static double rad(double d) {
        return d * Math.PI / 180.0;
    }


    // 开发秘钥  目前这个是私人的  每天的访问量有限(每天一万次, 并发访问5次每秒)
    private static final String sunM_key = "BXTBZ-FEZC4-YH4US-DZG54-EQEQK-2SB3N";


    /**
     * 经纬度检查(只针对中国的经纬度)  在中国经度(longitude)是绝对大于纬度(latitude)
     * 传入经纬度 进行校验  纬度大于了经度就交换经纬度的值
     * @param longitude
     * @param latitude
     * @return  返回一个map  map里面的值只有两个 key="longitude" 和 key="latitude"  value就是对应的经纬度值
     */
    public static Map<String,Double>  check_location_china(Double longitude, Double latitude){
        // 对传进来的经纬度做校正
        longitude = longitude==null?0d:longitude;     // 传进来的经度
        latitude = latitude==null?0d:latitude;  // 传进来的纬度

        double longitude_1 = longitude;
        double latitude_1 = latitude;

        if(latitude > longitude){
            longitude_1 = latitude;
            latitude_1 = longitude;
        }
        Map<String,Double> location = new HashMap<>();
        location.put("latitude",latitude_1);
        location.put("longitude",longitude_1);

        return location;
    }




    /**
     * 获取距离  传入两个点的经纬度  得到两个点的直线距离  单位:米(m)
     * @param latitude_1	纬度
     * @param longitude_1	经度
     * @param latitude_2	纬度
     * @param longitude_2	经度
     * @return  返回的值为两个点的距离, 单位:米
     */
    public static double getDistance(double latitude_1, double longitude_1, double latitude_2, double longitude_2){
        double radLat1 = rad(latitude_1);
        double radLat2 = rad(latitude_2);
        double a = radLat1 - radLat2;
        double b = rad(longitude_1) - rad(longitude_2);

        double pow_a = Math.pow(Math.sin(a / 2), 2);
        double pow_b = Math.pow(Math.sin(b / 2), 2);

        double s = 2 * Math.asin(Math.sqrt(pow_a + Math.cos(radLat1) * Math.cos(radLat2) * pow_b ));

        s = s * EARTH_RADIUS;;

        s = Math.round(s * 1000);
        return s;
    }














    /**
     * 解析经纬度   传入经纬度  得到这个经纬度的详细信息(城市,区域,街道等)
     * @param longitude
     * @param latitude
     * @return 返回的是一个json样式的字符串  (四个根节点信息: status, message, request_id, result)
     *         返回结果是正确的时候 :  {"status": 0,"message": "query ok","request_id": "请求id","result": "详细信息"}
     *         返回结果是错误的时候 :  {"status": 错误码,"message": "错误原因"}
     * @throws Exception
     */
    public static String latitude_and_longitude_analysis(Double longitude, Double latitude) throws Exception {

        // api地址:  http://lbs.qq.com/webservice_v1/guide-gcoder.html
        // 小程序端用的是腾讯的经纬度服务, 这儿的话统一先用腾讯的

        // 请求地址  方式get   参数两个必选
        String requestUrl = "https://apis.map.qq.com/ws/geocoder/v1/?";

        Map<String,Double> map = check_location_china(longitude, latitude);
        longitude = map.get("longitude");
        latitude = map.get("latitude");
        String location = latitude+","+longitude;

        requestUrl += "location="+location;
        requestUrl += "&key="+sunM_key;

        HttpsGet requestUrl_https = new HttpsGet(requestUrl);

//        requestUrl_https.addParemeter("location", location);    // 必选参数
//        requestUrl_https.addParemeter("key", sunM_key);         // 必选参数
//        requestUrl_https.addParemeter("get_poi", "1");
//        requestUrl_https.addParemeter("poi_options", "");
//        requestUrl_https.addParemeter("output", "");
//        requestUrl_https.addParemeter("callback", "");

        String result = requestUrl_https.getResult();

        return result;
    }








    /**
     * 传入两个点 和 前往方式(mode)  mode的值只有两个 driving（驾车）、walking（步行）   返回前往方方式的距离(单位米)
     * 开车去是多少米
     * 走路去是多少米
     * @param latitude_1
     * @param longitude_1
     * @param latitude_2
     * @param longitude_2
     * @param mode
     * @return  返回的是一个json样式的字符串  (三个根节点信息: status, message, result)
                返回结果是正确的时候 :  {"status": 0,"message": "query ok","result": "详细信息"}
                返回结果是错误的时候 :  {"status": 错误码,"message": "错误原因"}
     * @throws IOException
     */
    public static String getDistance(double latitude_1, double longitude_1, double latitude_2, double longitude_2, String mode) throws IOException {
        // api地址:  http://lbs.qq.com/webservice_v1/guide-distance.html
        // 小程序端用的是腾讯的经纬度服务, 这儿的话统一先用腾讯的

        // 请求地址  方式get   参数两个必选
        String requestUrl = "https://apis.map.qq.com/ws/distance/v1/?";

        // 检查第一个经纬度点
        Map<String,Double> map_from = check_location_china(longitude_1, latitude_1);
        longitude_1 = map_from.get("longitude");
        latitude_1 = map_from.get("latitude");
        String location_from = latitude_1+","+longitude_1;

        // 检查第二个经纬度点
        Map<String,Double> map_to = check_location_china(longitude_2, latitude_2);
        longitude_2 = map_to.get("longitude");
        latitude_2 = map_to.get("latitude");
        String location_to = latitude_2+","+longitude_2;

        requestUrl += "from="+location_from;
        requestUrl += "&to="+location_to;
        requestUrl += "&key="+sunM_key;
        requestUrl += "&mode="+mode;

        HttpsGet requestUrl_https = new HttpsGet(requestUrl);

        String result = requestUrl_https.getResult();
        return result;

    }



}
