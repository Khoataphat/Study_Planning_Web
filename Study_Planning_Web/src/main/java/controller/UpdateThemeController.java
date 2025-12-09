/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author Admin
 */
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;
import service.SettingService;
import utils.CookieUtils;

@WebServlet("/settings/theme")
public class UpdateThemeController extends HttpServlet {

    private SettingService service = new SettingService();

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String theme = req.getParameter("theme"); // light / dark
        
        // 1. GHI VÀO COOKIE (Cho Client, ưu tiên tốc độ)
        final int ONE_YEAR = 365;
        CookieUtils.setCookie(resp, "theme", theme, ONE_YEAR);

        User user = (User) req.getSession().getAttribute("user");
        if (user != null) {
            try {
                // 2. GHI VÀO DB (Cho tính vĩnh viễn và đồng bộ)
                service.saveTheme(user.getUserId(), theme);
            } catch (Exception e) {
                // X? lý l?i l?u DB
                e.printStackTrace(); 
            }
        }

        // Tr? l?i thành công (200 OK) mà không c?n chuy?n h??ng/reload
        resp.setStatus(HttpServletResponse.SC_OK); 
    }
}