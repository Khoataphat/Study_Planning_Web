/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author Admin
 */
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import service.SettingService;
import dao.SettingDAO;
import jakarta.servlet.annotation.WebServlet;
import model.User;
import model.UserSetting;
import utils.DBUtil;
@WebServlet("/setting")
public class SettingController extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        try {
            int userId = ((User) req.getSession().getAttribute("user")).getUserId();

            SettingService service = new SettingService(new SettingDAO(DBUtil.getConnection()));
            UserSetting settings = service.load(userId);

            req.setAttribute("settings", settings);
            req.getRequestDispatcher("views/settings-overlay.jsp").forward(req, res);

        } catch(Exception e){
            e.printStackTrace();
        }
    }
}
