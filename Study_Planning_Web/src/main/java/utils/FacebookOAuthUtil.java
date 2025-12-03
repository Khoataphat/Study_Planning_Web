/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

/**
 *
 * @author Admin
 */
public class FacebookOAuthUtil {

    public static final String CLIENT_ID = "825311667144555";
    public static final String CLIENT_SECRET = "e55c9520d0554bacea54f174e9b9fd59";
    public static final String REDIRECT_URI = "http://localhost:8080/auth/facebook/callback";

    public static String getLoginURL() throws UnsupportedEncodingException {
        return "https://www.facebook.com/v17.0/dialog/oauth?client_id=" 
                + CLIENT_ID + "&redirect_uri=" 
                + URLEncoder.encode(REDIRECT_URI, "UTF-8") 
                + "&scope=email,public_profile";
    }

    public static String getAccessTokenURL(String code) {
        return "https://graph.facebook.com/v17.0/oauth/access_token?client_id="
                + CLIENT_ID + "&redirect_uri=" + REDIRECT_URI
                + "&client_secret=" + CLIENT_SECRET
                + "&code=" + code;
    }

    public static String getUserInfoURL(String accessToken) {
        return "https://graph.facebook.com/me?fields=id,name,email,picture&access_token=" + accessToken;
    }
}
