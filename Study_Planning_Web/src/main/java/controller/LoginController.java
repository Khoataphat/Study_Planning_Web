/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import service.AuthService;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
/**
 *
 * @author Admin
 */
@WebServlet("/login")
public class LoginController extends HttpServlet {

    private AuthService authService = new AuthService();

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        try {
            String username = req.getParameter("username");
            String password = req.getParameter("password");

            User user = authService.login(username, password);

            if (user != null) {
                req.getSession().setAttribute("user", user);
                resp.sendRedirect("dashboard.jsp");
            } else {
                req.setAttribute("error", "Sai username hoặc password");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
