package controller;


import utils.HttpClientUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.User;
import service.AuthService;
import org.json.JSONObject;
import utils.FacebookOAuthUtil;


/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author Admin
 */
@WebServlet("/auth/facebook/callback")
public class FacebookCallbackController extends HttpServlet {

    private AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        String code = req.getParameter("code");

        if (code == null) {
            resp.getWriter().println("Error: No code returned!");
            return;
        }

        // 1. GET ACCESS TOKEN
        String accessTokenJson = HttpClientUtil.sendGET(
                FacebookOAuthUtil.getAccessTokenURL(code)
        );

        JSONObject tokenObj = new JSONObject(accessTokenJson);
        String accessToken = tokenObj.getString("access_token");

        // 2. GET USER INFO
        String userInfoJson = HttpClientUtil.sendGET(
                FacebookOAuthUtil.getUserInfoURL(accessToken)
        );

        JSONObject fbUser = new JSONObject(userInfoJson);

        String email = fbUser.optString("email", null);
        String name = fbUser.getString("name");
        String avatar = fbUser.getJSONObject("picture")
                              .getJSONObject("data")
                              .getString("url");
        
        String facebookId = fbUser.getString("id"); // ⚠️ Sử dụng ID Facebook làm OAuth ID

        // ⚠️ Trường hợp Facebook không trả email → Fail Login
        if (email == null || email.isEmpty()) {
            resp.getWriter().println("Facebook did not return email. Cannot login.");
            return;
        }

        // 3. XỬ LÝ LOGIN
        User user;
        try {
            user = authService.loginWithOAuth(
                    "FACEBOOK",
                    facebookId,
                    email
                    //name,
                    //avatar
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

