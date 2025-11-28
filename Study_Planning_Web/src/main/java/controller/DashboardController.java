/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.TimetableDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import model.DashboardData;
import model.User;
import service.DashboardService;
import utils.DBUtil;

/**
 *
 * @author Admin
 */
@WebServlet("/dashboard")
public class DashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            User user = (User) req.getSession().getAttribute("user");
            if (user == null) {
                resp.sendRedirect("login.jsp");
                return;
            }

            Connection conn = DBUtil.getConnection();
            DashboardService dash = new DashboardService(
//                    new UserActivityDAO(conn),
//                    new TaskDAO(conn)
                    new TimetableDAO(conn)
            );

            DashboardData dashboardData = dash.loadDashboard(user.getUserId());

            req.setAttribute("dash", dashboardData);

            req.getRequestDispatcher("views/dashboard.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}

