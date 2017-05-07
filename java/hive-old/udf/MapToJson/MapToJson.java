package com.ctrip.vac.hive.common.func;
 
import org.apache.hadoop.hive.ql.exec.UDF;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.hive.ql.metadata.HiveException;

import java.util.Map;
import java.util.HashMap;
import java.util.Iterator;

import org.json.JSONObject;
import org.json.JSONException;

 
public final class MapToJson extends UDF {
	public String evaluate(final Map<String, String> map) throws HiveException {
		if (map == null) { return null; }
		JSONObject jo = new JSONObject();
		try {
			for (String key : map.keySet()){
				jo.put(key,map.get(key));
			}
		}catch (JSONException e1) {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }
		return jo.toString();
	}
}


