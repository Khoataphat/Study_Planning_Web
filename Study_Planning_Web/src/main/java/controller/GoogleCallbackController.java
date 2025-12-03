/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import utils.HttpClientUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.User;
import service.AuthService;
import utils.GoogleOAuthUtils;
import org.json.JSONObject;

/**
 *
 * @author Admin
 */
@WebServlet("/oauth/google/callback")
public class GoogleCallbackController extends HttpServlet {

    private AuthService authService = new AuthService();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String code = req.getParameter("code");

        // Step 1: exchange code for access token
        String tokenJson = HttpClientUtil.postForm(GoogleOAuthUtils.TOKEN_URL,
                "code=" + code
                + "&client_id=" + GoogleOAuthUtils.CLIENT_ID
                + "&client_secret=" + GoogleOAuthUtils.CLIENT_SECRET
                + "&redirect_uri=" + GoogleOAuthUtils.REDIRECT_URI
                + "&grant_type=authorization_code"
        );

        JSONObject tokenObj = new JSONObject(tokenJson);
        String accessToken = tokenObj.getString("access_token");

        // Step 2: get profile
        String profileJson = HttpClientUtil.getWithAuth(
                GoogleOAuthUtils.USERINFO_URL,
                accessToken
        );

        JSONObject profile = new JSONObject(profileJson);

        String email = profile.getString("email");
        //String name = profile.getString("name");
        //String picture = profile.getString("picture");
        String googleId = profile.getString("id");

        // Step 3: login or register
        User user = null;
        try {
            user = authService.loginWithOAuth(
                    "GOOGLE",
                    googleId,
                    email
            //name
            //picture
            );
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/login");
            return; // NGĂN KHÔNG CHO THỰC HIỆN CÁC BƯỚC TIẾP THEO
        }

        // Step 4: set session
        req.getSession().setAttribute("user", user);

        resp.sendRedirect(req.getContextPath() + "/basic-setup-save");
    }
}
