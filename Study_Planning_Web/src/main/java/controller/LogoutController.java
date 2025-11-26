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

/**
 *
 * @author Admin
 */
@WebServlet("/logout")
public class LogoutController extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. NGĂN CHẶN CACHE CỦA TRÌNH DUYỆT
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
        resp.setHeader("Pragma", "no-cache"); // HTTP 1.0
        resp.setHeader("Expires", "0"); // Proxies

        // 2. HỦY SESSION
        HttpSession session = req.getSession(false); // Lấy Session hiện tại, không tạo mới
        if (session != null) {
            session.invalidate();
        }

        // 3. CHUYỂN HƯỚNG VỀ LOGIN (Tuyệt đối)
        String redirectURL = req.getContextPath() + "/views/login.jsp";
        resp.sendRedirect(redirectURL);
    }
}
