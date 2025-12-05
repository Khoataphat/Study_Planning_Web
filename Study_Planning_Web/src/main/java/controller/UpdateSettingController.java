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
import utils.DefaultJsonUtil;
@WebServlet("/update-settings")
public class UpdateSettingController extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        try {
            int userId = ((User) req.getSession().getAttribute("user")).getUserId();

            String json = req.getReader().lines().reduce("", (a,b)->a+b);
            UserSetting data = DefaultJsonUtil.fromJson(json, UserSetting.class);

            data.setUserId(userId);

            SettingService service = new SettingService(new SettingDAO(DBUtil.getConnection()));
            service.save(data);

            res.getWriter().write("{\"status\":\"ok\"}");

        } catch(Exception e){
            res.getWriter().write("{\"error\":\""+e.getMessage()+"\"}");
        }
    }
}
