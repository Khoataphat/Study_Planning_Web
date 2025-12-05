/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import io.github.cdimascio.dotenv.Dotenv;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

/**
 *
 * @author Admin
 */
public class FacebookOAuthUtil {
    
    private static final Dotenv dotenv = Dotenv.load();

    public static final String CLIENT_ID = dotenv.get("FACEBOOK_APP_ID");
    public static final String CLIENT_SECRET = dotenv.get("FACEBOOK_APP_SECRET");
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
