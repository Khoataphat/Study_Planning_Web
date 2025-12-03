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
import service.AuthService;
import utils.DBUtil;

/**
 *
 * @author Admin
 */
@WebServlet("/register")
public class RegisterController extends HttpServlet {

    private AuthService authService = new AuthService();

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            String username = req.getParameter("username");
            String email = req.getParameter("email");
            String password = req.getParameter("password");

            String result = authService.register(username, email, password);

            if (!result.equals("SUCCESS")) {
                req.setAttribute("error", result);
                req.getRequestDispatcher("#").forward(req, resp);
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/login");

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}