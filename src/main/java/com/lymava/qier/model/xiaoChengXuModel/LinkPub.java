package com.lymava.qier.model.xiaoChengXuModel;

import com.lymava.base.model.PubLink;
import com.lymava.nosql.mongodb.vo.NullBasicDBList;
import com.mongodb.BasicDBList;

public class LinkPub extends PubLink{


    /**
     * 头像背景
     */
    public String  headBg;

    /**
     * 推荐卡下面三张小图片
     */
    public BasicDBList headPics;



        // 推荐卡下面三张小图片  in
    public void setInHeadPics(String[] picsArray) {

        if(picsArray != null && picsArray.length == 1 ){
            if(picsArray[0].isEmpty()){
                picsArray = null;
            }
        }

        if(picsArray == null || picsArray.length == 0){
            headPics = NullBasicDBList.getInstance();
            return;
        }

        if(picsArray != null && picsArray.length >0){
            if(headPics== null){
                headPics = new BasicDBList();
            }
            for (String string : picsArray) {
                headPics.add(string);
            }
        }
    }



    // get/ set

    public BasicDBList getHeadPics() {
        return headPics;
    }

    public void setHeadPics(BasicDBList headPics) {
        this.headPics = headPics;
    }

    public String getHeadBg() {
        return headBg;
    }

    public void setHeadBg(String headBg) {
        this.headBg = headBg;
    }
}