package com.lymava.qier.model.xiaoChengXuModel;

import com.lymava.base.model.Pub;
import com.lymava.qier.util.DiLiUtil;

public class CityPub extends Pub {

    /**
     * 城市名
     */
    private String cityName;

    /**
     * 经度
     */
    private Double longitude;

    /**
     * 纬度
     */
    private Double latitude;

    /**
     * 标题
     */
    private String title;

    /**
     * 副标题
     */
    private String subtitle;

    /**
     * 红包使用数量
     */
    private String useRenshu;




    /**
     *
     * @param latitude_now
     * @param longitude_now
     * @return
     */
    public Double getDistance(Double latitude_now,Double longitude_now){

        // 对传进来的经纬度做校正
        latitude_now = latitude_now==null?0d:latitude_now;  // 传进来的纬度
        longitude_now = longitude_now==null?0d:longitude_now;     // 传进来的纬度

        // 对商家的经纬度做校正
        Double merchantLongitude = this.getLongitude()==null?0d:this.getLongitude();  // 商家的经度
        Double merchantLatitude = this.getLatitude()==null?0d:this.getLatitude();     // 商家的纬度

        // 前端 或者 后台 把经纬度弄反了的情况 做一次校正(目前只针对于中国地区)
        double latitude_1 = latitude_now;
        double longitude_1 = longitude_now;

        if(latitude_now > longitude_now){
            latitude_1 = longitude_now;
            longitude_1 = latitude_now;
        }

        double latitude_2 = merchantLatitude;
        double longitude_2 = merchantLongitude;

        if( merchantLatitude > merchantLongitude ){
            latitude_2 = merchantLongitude;
            longitude_2 = merchantLatitude;
        }

        // 获取两点的距离
        Double  distance = DiLiUtil.getDistance(latitude_1,  longitude_1,  latitude_2,  longitude_2);

        return distance;
    }



    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSubtitle() {
        return subtitle;
    }

    public void setSubtitle(String subtitle) {
        this.subtitle = subtitle;
    }

    public String getUseRenshu() {
        return useRenshu;
    }

    public void setUseRenshu(String useRenshu) {
        this.useRenshu = useRenshu;
    }

    public String getCityName() {
        return cityName;
    }

    public void setCityName(String cityName) {
        this.cityName = cityName;
    }

    public Double getLongitude() {
        return longitude;
    }

    public void setLongitude(Double longitude) {
        this.longitude = longitude;
    }

    public Double getLatitude() {
        return latitude;
    }

    public void setLatitude(Double latitude) {
        this.latitude = latitude;
    }
}
