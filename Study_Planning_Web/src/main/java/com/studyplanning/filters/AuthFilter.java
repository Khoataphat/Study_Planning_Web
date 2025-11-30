/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.studyplanning.filters;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 *
 * @author Admin
 */
public class AuthFilter implements Filter {

public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        // Lấy URI và Session
        String requestURI = req.getRequestURI();
        HttpSession session = req.getSession(false); // Lấy Session hiện tại, không tạo mới nếu chưa có

        // ==========================================================
        //         VỊ TRÍ THÊM LOG ĐỂ KIỂM TRA (DEBUGGING)
        // ==========================================================
        
        System.out.println("--- AuthFilter Log ---");
        System.out.println("URI truy cập: " + requestURI);
        // Kiểm tra xem Session có tồn tại không
        System.out.println("Session ID: " + (session != null ? session.getId() : "null"));
        // Kiểm tra thuộc tính "user" trong Session
        System.out.println("Trạng thái User: " + (session != null ? session.getAttribute("user") : "null"));
        System.out.println("----------------------");
        
        // ==========================================================
        
        // --- LOGIC LOẠI TRỪ ---
        // Nếu URL là trang login (hoặc các tài nguyên công cộng khác)
        if (requestURI.endsWith("login.jsp") || requestURI.endsWith("/login")) {
            System.out.println(">> ĐƯỢC PHÉP: Trang công khai (Login).");
            chain.doFilter(request, response);
            return; // Dừng việc thực thi tiếp theo của Filter
        }

        // LOGIC BẢO MẬT
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("!!! CHUYỂN HƯỚNG: Người dùng chưa đăng nhập.");
            res.sendRedirect(req.getContextPath() + "/views/login.jsp");
        } else {
            System.out.println(">> CHO PHÉP: Người dùng đã đăng nhập.");
            chain.doFilter(request, response);
        }
    }
}
