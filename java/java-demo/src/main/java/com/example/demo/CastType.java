/**
 * 
 */
package com.example.demo;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import net.sf.json.JSONArray;

import org.apache.commons.lang.StringUtils;

/**
 * @author dhua
 *
 */
public class CastType {
	
	public static void list2Array() {
		ArrayList<String> list = new ArrayList<String>();
		list.add("a1");
		list.add("a2");
		list.add("a3");
		String[] toArray = list.toArray(new String[list.size()]);
		for (String s : toArray) {
			System.out.println(s);
		}
	}

	public static void array2List() {
		String[] arr = new String[] { "1", "2" };
		List<String> list = Arrays.asList(arr);
		System.out.println(list);
	}
	
	
	public static void stringUtils() {
		String[] array = new String[] { "1", "2", "3" };
		
		String js = StringUtils.join(array);
		System.out.println(js);

		js = StringUtils.join(array, "&");
		System.out.println(js);
		
		String[] toArray = StringUtils.split(js,"&");
		for (String s : toArray) {
			System.out.println(s);
		}

	}

	public static void jsonarray2Array() {
		JSONArray ja = new JSONArray();
		ja.add("a1");
		ja.add("a2");
		ja.add("a3");

		System.out.println(ja);

		String[] toArray = (String[]) JSONArray.toArray(ja, String.class);
		for (String s : toArray) {
			System.out.println(s);
		}
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		// list2Array();
		// array2List();
		// jsonarray2Array();
		stringUtils();

	}

}
