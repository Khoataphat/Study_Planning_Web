/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.TaskDAO;
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
@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            User user = (User) req.getSession().getAttribute("user");
            if (user == null) {
                resp.sendRedirect("/login");
                return;
            }

            Connection conn = DBUtil.getConnection();
            
            // Khởi tạo DAO
            TimetableDAO timetableDAO = new TimetableDAO(conn);
            TaskDAO taskDAO = new TaskDAO();
            
            // Tạo DashboardService
            DashboardService dashService = new DashboardService(
                timetableDAO, taskDAO
            );
            
            DashboardData dashboardData = dashService.loadDashboard(user.getUserId());
            
            // Thêm các thuộc tính cần thiết cho JSP
            req.setAttribute("dash", dashboardData);
            req.setAttribute("timeAllocation", dashboardData.getTimeAllocation());
            req.setAttribute("upcomingTasks", dashboardData.getUpcomingTasks());
            
            req.getRequestDispatcher("views/dashboard.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Có lỗi xảy ra khi tải dashboard: " + e.getMessage());
            req.getRequestDispatcher("views/dashboard.jsp").forward(req, resp);
        }
    }
}
