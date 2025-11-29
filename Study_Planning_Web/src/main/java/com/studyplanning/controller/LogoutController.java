/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.studyplanning.controller;

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

    // Logic cốt lõi: Hủy Session và Chuyển hướng
    private void processLogout(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        
        // 1. NGĂN CHẶN CACHE
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setHeader("Expires", "0");

        // 2. HỦY SESSION
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // 3. CHUYỂN HƯỚNG VỀ LOGIN (Tuyệt đối)
        String redirectURL = req.getContextPath() + "/views/login.jsp"; 
        resp.sendRedirect(redirectURL);
    }
    
    // Xử lý yêu cầu GET
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        processLogout(req, resp);
    }
    
    // Xử lý yêu cầu POST (Yêu cầu từ nút Logout mới)
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        processLogout(req, resp);
    }
}
