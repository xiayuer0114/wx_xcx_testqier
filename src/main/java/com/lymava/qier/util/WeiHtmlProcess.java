package com.lymava.qier.util;

import java.awt.image.BufferedImage;
import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.nio.Buffer;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.imageio.ImageIO;

import org.apache.struts2.ServletActionContext;
import org.bson.types.ObjectId;

import com.lymava.commons.util.IOUtil;
import com.lymava.commons.util.ImageUtil;
import com.lymava.commons.util.MyUtil;
import com.lymava.commons.util.QrCodeUtil;

public class WeiHtmlProcess {


	public  static String process_weixin_html(String html,String basePath,String realPath,String objectId) {

		StringBuilder stringBuilder = null;

		String padding_html = "<div style=\"padding-left:1rem;padding-right:1rem;\">";

		boolean had_padding_html = html.startsWith(padding_html);

		if(!had_padding_html){
			stringBuilder = new StringBuilder(padding_html);
			stringBuilder.append(html);
		}else{
			stringBuilder = new StringBuilder(html);
		}


		Pattern compile = Pattern.compile("<img.*?/>");

		Matcher matcher = compile.matcher(html);

		while(matcher.find()) {

			String group = matcher.group();

			String image_src = MyUtil.subStr(group, "data-src=\"","\"");

			if(image_src == null ) {
				continue;
			}

			byte[] imageFromWeixin = getImageFromWeixin(image_src);

			try {
				String savePic = MyUtil.fileMove(imageFromWeixin, objectId, realPath);

				String replace_str = "data-src=\""+image_src+"\"";

				int indexOf = stringBuilder.indexOf(replace_str);

				stringBuilder = stringBuilder.replace(indexOf, indexOf+replace_str.length(), "src=\""+basePath+savePic+"\"");


			} catch (Exception e) {
				e.printStackTrace();
			}

		}

		if(!had_padding_html){
			stringBuilder.append("</div>");
		}

		String result_string = stringBuilder.toString();

		result_string = result_string.replaceAll("text-indent: 2em;","");

		return result_string;
	}


	public static void main(String[] args) throws Exception {

		String readData = IOUtil.readData("/home/lymava/酒阳");

		StringBuilder stringBuilder_readData = new StringBuilder(readData);

		boolean is_find = true;
		int index_of = 0;

		String start_str = "<img";
		String end_str = "<h3>";

		while(is_find){

			index_of = stringBuilder_readData.indexOf(start_str, index_of);
			int nameEnd = stringBuilder_readData.indexOf(end_str, index_of + start_str.length());

			if (index_of == -1 || nameEnd == -1 || nameEnd <= index_of) {
				is_find = false;
				break;
			}

			String str_find = stringBuilder_readData.substring(index_of + start_str.length(), nameEnd);

			if(MyUtil.isEmpty(str_find)) {
				is_find = false;
				break;
			}

			boolean check_only = check_only_p_h3(str_find);
			if(check_only) {

				String str_replace = start_str+str_find+"<h3 style=\"margin-top:0;\">";

				stringBuilder_readData = stringBuilder_readData.replace(index_of, start_str.length()+index_of+str_find.length()+end_str.length(),str_replace);

				index_of = index_of+start_str.length();
			}else {
				index_of = index_of+start_str.length();
			}

			if(index_of == -1) {
				is_find = false;
			}
		}

		System.out.println(stringBuilder_readData);

	}
	/**
	 * <p>
	 <img src="http://114.115.184.214:7210/attachFiles/temp/5b6fad5144213846571e65ae" alt="" />&nbsp;
	 </p>
	 <h3>
	 坚持川菜根本，传承川菜之魂
	 </h3>
	 * @return	是否是image 标签和h3 标签连起的
	 */
	public static boolean check_only_p_h3(String str) {

		if(str.contains("<p>")) {
			return false;
		}

		return true;
	}


	public  static String  process_update_img_Style(String html) {

		StringBuilder stringBuilder_readData = new StringBuilder(html);

		boolean is_find = true;
		int index_of = 0;

		String start_str = "<img";
		String end_str = "<h3>";

		while(is_find){

			index_of = stringBuilder_readData.indexOf(start_str, index_of);
			int nameEnd = stringBuilder_readData.indexOf(end_str, index_of + start_str.length());

			if (index_of == -1 || nameEnd == -1 || nameEnd <= index_of) {
				is_find = false;
				break;
			}

			String str_find = stringBuilder_readData.substring(index_of + start_str.length(), nameEnd);

			if(MyUtil.isEmpty(str_find)) {
				is_find = false;
				break;
			}

			boolean check_only = check_only_p_h3(str_find);
			if(check_only) {

				String str_replace = start_str+str_find+"<h3 style=\"margin-top:0;\">";

				stringBuilder_readData = stringBuilder_readData.replace(index_of, start_str.length()+index_of+str_find.length()+end_str.length(),str_replace);

				index_of = index_of+start_str.length();
			}else {
				index_of = index_of+start_str.length();
			}

			if(index_of == -1) {
				is_find = false;
			}
		}

		return stringBuilder_readData.toString();
	}



	public  static String  process_img_addStyle_haveTwoImg(String html){

		if(MyUtil.isEmpty(html)){return "";}

		StringBuilder sb_readData = new StringBuilder(html);

		boolean b = true;

		int str_start = 0;
		int img_one = -1;

		while ( b ){

			// 第一次出现 <img 的位子
			img_one = sb_readData.indexOf("<img",str_start);
			if(img_one == -1){ b=false; break;}

			// 出现了第一个 <img 从他的后面开始再去找一个 <img
			int img_two = sb_readData.indexOf("<img",img_one+3);
			if(img_two == -1){ b=false; break;}


			// 找到两个下标之间的 字符串
			String jiequ = sb_readData.substring(img_one, img_two);

			// 字符串当中的第一个<p>
			int p_one = jiequ.indexOf("<p>");
			if(p_one == -1){
				// 没有第一个p  continue
				str_start = img_two;
				continue;
			}

			// 字符串当中的第二个<p>
			int p_two = jiequ.indexOf("<p>", p_one+3);
			if(p_two != -1){
				// 有第二个p  continue
				str_start = img_two;
				continue;
			}

			// 在截取的字符串当中 没有找到第二个<p> 就是需要操作的字符串  就从第二个 img开始操作
			sb_readData.insert(img_two+4, " style=\"margin-top: 0;\"");
			str_start = img_two;
		}

		return sb_readData.toString();
	}


	public  static String  process_replace_img_src(String html, String basePath){
		if(MyUtil.isEmpty(html)){return "";}

		StringBuilder sb_readData = new StringBuilder(html);


		boolean b = true;

		int str_start = 0;


		while ( b ){

			// 找到一个img标签
			int img_one = sb_readData.indexOf("<img",str_start);
			if(img_one == -1){
				b = false;
				break;
			}

			//出现了第一个 <img 从他的后面开始再去找资源标签
			int img_src = sb_readData.indexOf("http://114.115",img_one+3);
			if(img_src == -1){
				b = false;
				break;
			}

			// 第一个分隔符
			int one_feige = img_src + 9;
			int src_jieshu = sb_readData.indexOf("/",one_feige);
			if(src_jieshu == -1){
				b = false;
				break;
			}


			// 把两个a标签  换成  a标签之间的值
			sb_readData.replace(img_src, src_jieshu+1, basePath);
			str_start = src_jieshu;
		}

		return sb_readData.toString();
	}


	public  static String  process_remove_a(String html){

		if(MyUtil.isEmpty(html)){return "";}

		StringBuilder sb_readData = new StringBuilder(html);

		boolean b = true;

		int str_start = 0;
		int img_one = -1;

		while ( b ){

			// 找到一个a标签
			int a_one = sb_readData.indexOf("<a",0);
			if(a_one == -1){
				b = false;
				break;
			}

			//出现了第一个 <a 从他的后面开始再去找一个 <a
			int a_two = sb_readData.indexOf("</a>",a_one+3);
			if(a_two == -1){
				b = false;
				break;
			}


			// 找到两个下标之间的 字符串  并且 找到两个标签之间的字符
			String jiequ = sb_readData.substring(a_one, a_two);
			int a_one_jieshu = jiequ.indexOf(">")+1;
			String a_zhijiandezhi = jiequ.substring(a_one_jieshu);

			// 把两个a标签  换成  a标签之间的值
			sb_readData.replace(a_one, a_two+4, a_zhijiandezhi);
		}

		return sb_readData.toString();
	}




	public static byte[] getImageFromWeixin(String image_src) {

		image_src = image_src.replaceAll("https", "http");

		BufferedImage bufferedImage = null;

		URL url;
		try {
			url = new URL(image_src);

			URLConnection urlConnection_image = url.openConnection();

			urlConnection_image.setRequestProperty("Host", "mmbiz.qpic.cn");

			InputStream inputStream = urlConnection_image.getInputStream();

			bufferedImage = ImageIO.read(inputStream);

			inputStream.close();

			ByteArrayOutputStream baos = new ByteArrayOutputStream();

			boolean write = ImageUtil.write(bufferedImage, baos);

			return baos.toByteArray();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}
 
}
