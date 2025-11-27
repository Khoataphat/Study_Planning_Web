 /*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

/**
 *
 * @author Admin
 */
@WebServlet("/basic-setup/save")
public class SetupController extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        // lấy form info user chọn
        //String goal = req.getParameter("goal");
        //String studyTime = req.getParameter("studyTime");
        //String skillLevel = req.getParameter("skillLevel");

        // lưu DB
        //setupService.saveBasicInfo(user.getId(), goal, studyTime, skillLevel);

        // update flag first_login
        //UserDAO.updateFirstLogin(user.getId());

        // update lại trong session luôn
        //user.setIsFirstLogin(0);

        //response.sendRedirect("dashboard");
    }
}
