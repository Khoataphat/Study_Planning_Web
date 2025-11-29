package com.studyplanning.controller;

import com.studyplanning.service.AuthService;
import com.studyplanning.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

/**
 * Login Controller for handling user authentication
 */
@WebServlet("/login")
public class LoginController extends HttpServlet {

    private AuthService authService = new AuthService();

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            
            System.out.println("Login attempt - Username: " + username); // Debug log

            User user = authService.login(username, password);

            if (user != null) {
                System.out.println("Login successful for user: " + user.getUsername());
                HttpSession session = req.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getUserId()); // Store userId separately
                
                String redirectURL = req.getContextPath() + "/dashboard.jsp";
               resp.sendRedirect(redirectURL);
            } else {
                System.out.println("Login failed - Invalid credentials");
                req.setAttribute("error", "Sai username hoặc password");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            System.out.println("Login error: " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "System error");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }
}
