package com.example.hive.udf;

import org.apache.hadoop.hive.ql.exec.UDF;
import org.apache.hadoop.hive.ql.metadata.HiveException;

import java.util.Map;
import java.util.HashMap;
import java.util.Iterator;

import org.json.JSONObject;
import org.json.JSONException;


public final class JsonToMap extends UDF {
	public Map<String, String> evaluate(final String s) throws HiveException {
		if (s == null) { return null; }
		Map<String, String> map = new HashMap<String, String>();  
		try {
			JSONObject jo = new JSONObject(s); 
			Iterator it = jo.keys();
			while (it.hasNext()) {
				String k = (String) it.next();
				map.put(k,jo.getString(k));
			}
		}catch (JSONException e1) {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }
		return map;
	}
}
