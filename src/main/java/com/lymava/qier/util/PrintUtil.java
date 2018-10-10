package com.lymava.qier.util;

import java.awt.Font;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.awt.print.Book;
import java.awt.print.PageFormat;
import java.awt.print.Paper;
import java.awt.print.Printable;
import java.awt.print.PrinterException;
import java.awt.print.PrinterJob;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.lymava.commons.exception.CheckException;
import com.lymava.commons.util.DateUtil;
import com.lymava.commons.util.QrCodeUtil;
import com.lymava.trade.business.model.TradeRecord;
import com.lymava.trade.business.model.TradeRecordOld;

public class PrintUtil implements Printable {

    private static String yorzUrl = "http://weixin.qq.com/r/ty9ieuPEIb5eracZ93ql";
    private static BufferedImage bufferedImage = null;

    private static final Integer printType_80 = 1;
    private static final Integer printType_58 = 2;

    private static TradeRecord tradeRecordOld = null;
    private static Integer printType_out = printType_80;


    static {
        Integer qrcode_size = 140;
        try {
//            bufferedImage =  QrCodeUtil.createQrBufferedImage(yorzUrl,qrcode_size);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    @Override
    public int print(Graphics g, PageFormat pf, int page) throws PrinterException {
        if (page > 0) {
            return NO_SUCH_PAGE;
        }

        if (tradeRecordOld == null){
            return NO_SUCH_PAGE;
        }

        Integer font_size = 16;
        if ( printType_out.equals(printType_58) ||  printType_out == printType_58){
            font_size = 12;
        };


        Long data_now_long =  System.currentTimeMillis();
        SimpleDateFormat sdf = DateUtil.getSdfFull();
        String date_now_str = sdf.format(new Date(data_now_long));


        Graphics2D g2d = (Graphics2D) g;
        g2d.setFont(new Font("Default", Font.PLAIN, font_size));
        g2d.drawString("--", 7, 1);
        g2d.drawString(tradeRecordOld.getUser_merchant().getNickname(), 7, 20);

        g2d.setFont(new Font("Default", Font.PLAIN, (font_size-4)));
        g2d.drawString("------------------------------------------------", 7, 35);
        g2d.drawString("订单编号:  "+tradeRecordOld.getShowPayFlow(), 7, 50);
        g2d.drawString("订单时间:  "+tradeRecordOld.getShowTime(), 7, 65);
        g2d.drawString("打印时间:  "+ date_now_str, 7, 80);
        g2d.drawString("备注:  "+tradeRecordOld.getMemo() , 7, 95);
       
        
        g2d.drawString("------------------------------------------------", 7, 115);
        
//        g2d.setFont(new Font("Default", Font.PLAIN, (font_size-3)));
        String row1 = "商品           数量  单价  小计";
        g2d.drawString(row1, 7, 130);
        
        
        String row2 = tradeRecordOld.getProduct().getName()+"       "+((double)tradeRecordOld.getQuantity()/100)+"    "+tradeRecordOld.getPrice_fen()/100+"   "+((double)tradeRecordOld.getPrice_fen_all()/100);
        g2d.drawString(row2, 7, 145);
        
        Long qianbao = tradeRecordOld.getWallet_amount_payment_fen();

        g2d.drawString("------------------------------------------------", 7, 160);
        g2d.drawString("钱包支付: "+(double)(qianbao/100), 7, 175);
        g2d.drawString("实收(￥) : "+((double)tradeRecordOld.getPayPrice_fen_all()/100), 7, 190);
        g2d.drawString("合  计  : "+((double)tradeRecordOld.getPayPrice_fen_all()/100), 7, 205);
        g2d.drawString("", 7, 215);
        g2d.drawString("状  态  : "+tradeRecordOld.getShowState()+"("+tradeRecordOld.getShowPay_method()+")", 7, 230);

        g2d.drawString("------------------------------------------------", 7, 245);
        g2d.drawString("'悠择YORZ'竭诚为您服务!", 7, 260);
        g2d.drawString("关注'悠择YORZ'公众号领取红包", 7, 275);
        g2d.drawImage(bufferedImage,null,4,280);   // 关注yorz的二维码图片

        return PAGE_EXISTS;
    }


    /**
     * 打印订单
     * @param tradeRecordOld_out    传入一个订单对象 不能为空
     * @param pageSize               打印的张数  小于等于0或者为空答应一张  大于5打印5张
     * @param printType              智障的类型  1为80mm  2为58mm  空或其他数值默认是1
     */
    public static void  printToReceipt(TradeRecord tradeRecord,Integer pageSize, Integer printType){
        CheckException.checkIsTure(tradeRecord!=null,"不能打印一个空对象");

        tradeRecordOld = tradeRecord;
        if (printType != null  &&  (printType.equals(printType_58 ) ||  printType == printType_58)){
            printType_out = printType_58;
        };

        int height = 175 + 3 * 15 + 20+700;

        // 通俗理解就是书、文档
        Book book = new Book();

        // 打印格式
        PageFormat pf = new PageFormat();
        pf.setOrientation(PageFormat.PORTRAIT);

        // 通过Paper设置页面的空白边距和可打印区域。必须与实际打印纸张大小相符。
        Paper p = new Paper();
        p.setSize(400, height);
        p.setImageableArea(5, -20, 400, height + 20);
        pf.setPaper(p);

        // 把 PageFormat 和 Printable 添加到书中，组成一个页面
        book.append(new PrintUtil(), pf);

        // 获取打印服务对象
        PrinterJob job = PrinterJob.getPrinterJob();
        job.setPageable(book);
        try {
            if (pageSize == null  ||  pageSize < 1){pageSize = 1;};
            if (pageSize > 5){pageSize = 5;};
            for (int i =0 ; i<pageSize; i++){
                job.print();
            }
        } catch (PrinterException e) {
        	e.printStackTrace();
            System.out.println("================打印出现异常");
        }
    }
}
