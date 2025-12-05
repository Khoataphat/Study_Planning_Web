/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import com.google.gson.Gson;

/**
 *
 * @author Admin
 */
public class DefaultJsonUtil {
    private static final Gson gson = new Gson();

    public static <T> T fromJson(String json, Class<T> cls){
        return gson.fromJson(json, cls);
    }

    public static String toJson(Object obj){
        return gson.toJson(obj);
    }
    
}
