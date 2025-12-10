/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import model.User;
import model.ValidationError;
import service.AuthService;
import utils.DBUtil;

/**
 *
 * @author Admin
 */
@WebServlet("/register")
public class RegisterController extends HttpServlet {

    private AuthService authService = new AuthService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            // 1. Lấy dữ liệu
            String username = req.getParameter("username");
            String email = req.getParameter("email");
            String password = req.getParameter("password");

            // 2. GỌI SERVICE để thực hiện toàn bộ quy trình Validation, Hash, và INSERT
            // Hàm register() trong AuthService đã được bạn cấu hình để trả về 
            // "SUCCESS" hoặc thông báo lỗi cụ thể (String).
            String result = authService.register(username, email, password);

            if (!result.equals("SUCCESS")) {
                // 🛑 Xử lý THẤT BẠI (Có lỗi Validation hoặc Check trùng)

                // Lưu thông báo lỗi vào Request Attribute
                req.setAttribute("register_error", result); // Đổi tên attribute để phân biệt với lỗi login

                // ⭐ QUAN TRỌNG: Lưu lại dữ liệu hợp lệ đã nhập (trừ mật khẩu)
                req.setAttribute("reg_username", username);
                req.setAttribute("reg_email", email);

                // ⭐ 3. BỔ SUNG: SET TÊN TRƯỜNG LỖI CỤ THỂ ⭐
                String errorField = getErrorField(result); // Dùng hàm mới để phân tích lỗi
                req.setAttribute("reg_error_field", errorField);

                // Chuyển tiếp (FORWARD) đến file JSP chung
                req.getRequestDispatcher("views/login.jsp").forward(req, resp);
                return;
            }

            // ✅ Xử lý THÀNH CÔNG
            // Đặt thông báo thành công (Có thể dùng Session hoặc Request)
            req.getSession().setAttribute("success_message", "Đăng ký thành công! Hãy đăng nhập.");

            // Chuyển hướng đến Controller /login (hoặc file JSP)
            // Redirect là bắt buộc khi thành công để ngăn chặn việc submit lại form
            resp.sendRedirect(req.getContextPath() + "/login");

        } catch (Exception e) {
            // Xử lý lỗi hệ thống/DB (Lỗi 500)
            e.printStackTrace();
            req.setAttribute("register_error", "Lỗi server: Xảy ra sự cố khi đăng ký.");
            req.getRequestDispatcher("views/login.jsp").forward(req, resp);
        }
    }

    // ⭐ HÀM PHỤ TRỢ TẠM THỜI ĐỂ XÁC ĐỊNH TRƯỜNG LỖI ⭐
    private String getErrorField(String errorMessage) {
        if (errorMessage == null) {
            return null;
        }
        String lowerCaseMsg = errorMessage.toLowerCase();

        if (lowerCaseMsg.contains("username") || lowerCaseMsg.contains("tên người dùng")) {
            return "username";
        }
        if (lowerCaseMsg.contains("email")) {
            return "email";
        }
        if (lowerCaseMsg.contains("password") || lowerCaseMsg.contains("mật khẩu")) {
            return "password";
        }
        return null; // Lỗi chung
    }
}
