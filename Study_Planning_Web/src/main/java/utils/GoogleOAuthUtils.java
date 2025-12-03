/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

/**
 *
 * @author Admin
 */
public class GoogleOAuthUtils {

    public static final String CLIENT_ID = "43978001996-2odnhc8r6m66viqp6j6p87248kfgl47i.apps.googleusercontent.com";
    public static final String CLIENT_SECRET = "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";
    public static final String REDIRECT_URI = "http://localhost:8080/oauth/google/callback";

    public static final String AUTH_URL =
        "https://accounts.google.com/o/oauth2/auth" +
        "?scope=email%20profile" +
        "&redirect_uri=" + REDIRECT_URI +
        "&response_type=code" +
        "&client_id=" + CLIENT_ID;

    public static final String TOKEN_URL = "https://oauth2.googleapis.com/token";
    public static final String USERINFO_URL = "https://www.googleapis.com/oauth2/v2/userinfo";
}
