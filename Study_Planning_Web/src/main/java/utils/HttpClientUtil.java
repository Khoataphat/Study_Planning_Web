/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

/**
 *
 * @author Admin
 */
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

public class HttpClientUtil {

    public static String postForm(String urlStr, String params) throws IOException {
        URL url = new URL(urlStr);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("POST");
        con.setDoOutput(true);
        con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

        try (OutputStream os = con.getOutputStream()) {
            os.write(params.getBytes());
        }

        return read(con);
    }

    public static String getWithAuth(String urlStr, String token) throws IOException {
        URL url = new URL(urlStr);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestProperty("Authorization", "Bearer " + token);
        return read(con);
    }

    private static String read(HttpURLConnection con) throws IOException {
        BufferedReader br = new BufferedReader(
                new InputStreamReader(con.getInputStream()));
        String line;
        StringBuilder sb = new StringBuilder();
        while ((line = br.readLine()) != null) {
            sb.append(line);
        }
        return sb.toString();
    }

    //facenook
    public static String sendGET(String urlStr) throws IOException {
        URL url = new URL(urlStr);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();

        con.setRequestMethod("GET");
        BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));

        StringBuilder result = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            result.append(line);
        }
        br.close();
        return result.toString();
    }
}
