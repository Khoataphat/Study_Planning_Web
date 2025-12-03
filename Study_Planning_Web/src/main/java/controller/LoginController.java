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
import java.io.IOException;

/**
 *
 * @author Admin
 */
@WebServlet("/login")
public class LoginController extends HttpServlet {

    private AuthService authService = new AuthService();

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String username = req.getParameter("username");
            String password = req.getParameter("password");

            User user = authService.login(username, password);

            if (user == null) {
                // Xử lý đăng nhập thất bại
                req.setAttribute("error", "Sai tài khoản hoặc mật khẩu");
                req.getRequestDispatcher("views/login.jsp").forward(req, resp);
                return; 
            }

            // Xử lý đăng nhập thành công
            HttpSession session = req.getSession();
            session.setAttribute("user", user);

            if (user.getisFirstLogin() == 1) {
                // Redirect đến trang chọn thông tin
                resp.sendRedirect(req.getContextPath() + "/basic-setup-save"); 
            } else {
                // Redirect đến trang dashboard
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "System error");
            req.getRequestDispatcher("views/login.jsp").forward(req, resp);

        }
    }
}
