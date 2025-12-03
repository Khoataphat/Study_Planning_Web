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
@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
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
            if (conn != null && !conn.isClosed()) {
                System.out.println("DEBUG: Kết nối DB thành công!");
            } else {
                System.err.println("DEBUG: LỖI KẾT NỐI DB. Connection là null hoặc đã đóng.");
                return; // Dừng lại ở đây nếu kết nối thất bại
            }
            DashboardService dash = new DashboardService(
                    //                    new UserActivityDAO(conn),
                    //                    new TaskDAO(conn)
                    new TimetableDAO(conn)
            );
            // TẠM THỜI GHI ĐÈ USER ID ĐỂ TEST
            int userIdToQuery = 25; // ID này có dữ liệu trong DB

            //DashboardData dashboardData = dash.loadDashboard(user.getUserId());
            DashboardData dashboardData = dash.loadDashboard(userIdToQuery); // Dùng ID 25 đã hardcode

            req.setAttribute("dash", dashboardData);

            req.getRequestDispatcher("views/dashboard.jsp").forward(req, resp);

        } catch (Exception e) {
            // Nếu có bất kỳ lỗi nào xảy ra (SQL, Mapping,...)
            // LỖI NÀY CẦN PHẢI ĐƯỢC IN RA CONSOLE ĐỂ PHÁT HIỆN!
            e.printStackTrace();
            // Sau đó Controller vẫn forward, nhưng đối tượng 'data' có thể null hoặc thiếu dữ liệu.
        }
    }
}
