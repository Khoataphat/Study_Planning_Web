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
        // Đảm bảo request encoding được đặt (nếu cần xử lý ký tự tiếng Việt)
        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // Cờ để kiểm tra validation đầu vào (thiếu trường)
        boolean hasValidationError = false;
        String errorMessage = "Vui lòng điền đầy đủ Tên người dùng và Mật khẩu.";
        String errorField = null;

        // 1. Kiểm tra lỗi thiếu trường
        if (username == null || username.trim().isEmpty()) {
            errorMessage = "Vui lòng nhập Tên người dùng.";
            errorField = "username";
            hasValidationError = true;
        } else if (password == null || password.isEmpty()) {
            errorMessage = "Vui lòng nhập Mật khẩu.";
            errorField = "password";
            hasValidationError = true;
        }

        if (hasValidationError) {
            req.setAttribute("login_error", errorMessage);
            req.setAttribute("login_username", username);
            req.setAttribute("login_error_field", errorField); // Gửi trường lỗi để highlight

            req.getRequestDispatcher("views/login.jsp").forward(req, resp);
            return;
        }

        // 2. Xử lý logic đăng nhập (khi đã có đủ username/password)
        try {
            User user = authService.login(username, password);

            if (user == null) {
                // Xử lý đăng nhập thất bại (Lỗi chung: Sai cặp User/Pass)
                req.setAttribute("login_error", "Tên người dùng hoặc mật khẩu không đúng.");
                req.setAttribute("login_username", username);
                // KHÔNG set login_error_field vì không thể biết chính xác trường nào sai

                req.getRequestDispatcher("views/login.jsp").forward(req, resp);
                return;
            }

            // Xử lý đăng nhập thành công
            HttpSession session = req.getSession();
            session.setAttribute("user", user);

            if (user.getisFirstLogin() == 1) {
                resp.sendRedirect(req.getContextPath() + "/basic-setup-save");
            } else {
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Xử lý lỗi hệ thống
            req.setAttribute("login_error", "Lỗi hệ thống. Vui lòng thử lại sau.");
            req.setAttribute("login_username", username);
            req.getRequestDispatcher("views/login.jsp").forward(req, resp);
        }
    }
}
