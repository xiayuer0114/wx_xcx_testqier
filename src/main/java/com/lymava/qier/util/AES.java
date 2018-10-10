package com.lymava.qier.util;

import org.bouncycastle.jce.provider.BouncyCastleProvider;

import java.security.AlgorithmParameters;
import java.security.Key;
import java.security.Security;
import java.util.HashMap;
import java.util.Map;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;


/**
 *
 * 这个类只针对 解密微信小程序的encryptedData    (直接从网上扣得代码,没去研究里面怎么实现的)
 *
 * 最下面有测试的main方法 (测试通过)
 *
 * 参数encryptedData, session_key, iv
 *
 * 三个参数都使用org.apache.commons.codec.binary.Base64.decodeBase64()转换成byte[]
 *      byte[] session_key_byte      = org.apache.commons.codec.binary.Base64.decodeBase64(session_key);
 *      byte[] encryptedData_byte    = org.apache.commons.codec.binary.Base64.decodeBase64(encryptedData);
 *      byte[] iv_byte               = org.apache.commons.codec.binary.Base64.decodeBase64(iv);
 *
 * 然后传入方法 decrypt(encryptedData_byte, session_key_byte, iv_byte);
 *
 *
 *
 *
 *
 *
 */



public final class AES {


    public static boolean initialized = false;

    /**
     * AES解密
     * @param content 密文
     * @return
     */
    public static byte[] decrypt(byte[] content, byte[] keyByte, byte[] ivByte) throws Exception {
        initialize();
        try {
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS7Padding");
            Key sKeySpec = new SecretKeySpec(keyByte, "AES");

            cipher.init(Cipher.DECRYPT_MODE, sKeySpec, generateIV(ivByte));// 初始化
            byte[] result = cipher.doFinal(content);
            return result;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static void initialize(){
        if (initialized) return;
        Security.addProvider(new BouncyCastleProvider());
        initialized = true;
    }
    //生成iv
    public static AlgorithmParameters generateIV(byte[] iv) throws Exception{
        AlgorithmParameters params = AlgorithmParameters.getInstance("AES");
        params.init(new IvParameterSpec(iv));
        return params;
    }


    public static void main(String[] args) throws Exception {
        Map map = new HashMap();

        String session_key =        "Pme1e2h42Ga481uaihTSnQ==";
        String encryptedData =      "nDX8gHV/jAtTHaWwexnZA5duBox+IaQ4U/upP6Yhe240yMWge2C9JI/gq3VX8TMO2YLtkysLgtF8IdVQOV9FtDxNRS4trhHseUHR8MTkBwYfmBqLk+jn4zfMllV0fCBstKH8XuPPqWf3LkfsAVB60h+bMwIgvAFzSDyBWKHiUdEym6XBgSDHasOYM2UBdNvyXdupH76gp3oKRaypAMNZ/1u6JEsFtpYHQ1nvPkvHdfrcckkClvf+iz34zcm5x5GfLXrBFN8/u37wwjFTS05sTNp6WB5qNBE/ixEHYQLDL5j9ESDmmW29CUo7UDEBenjDKX9AuqdAgpgcEF5H2LqqtQY3jeIYKcD0OoZwMPh+iCi5ZvZBCELGWCPR+O2Oo9TGdUjCi5PvFmD2uI+5QTsuuJqmJxCczDl/+PeKzz3FgqyNi33Uvslefq9ft64LfRZn";
        String iv =                 "FARdNTFf9aTU6/nv0nKLRA==";

        try {
            byte[] resultByte  = AES.decrypt(org.apache.commons.codec.binary.Base64.decodeBase64(encryptedData),
                    org.apache.commons.codec.binary.Base64.decodeBase64(session_key),
                    org.apache.commons.codec.binary.Base64.decodeBase64(iv));
            if(null != resultByte && resultByte.length > 0){
                String userInfo = new String(resultByte, "UTF-8");
                map.put("status", "1");
                map.put("msg", "解密成功");
                map.put("userInfo", userInfo);

                System.out.println(userInfo);
            }else{
                map.put("status", "0");
                map.put("msg", "解密失败");
            }
        }catch (Exception e) {
            e.printStackTrace();
        }

        System.out.println(map);

    }



}