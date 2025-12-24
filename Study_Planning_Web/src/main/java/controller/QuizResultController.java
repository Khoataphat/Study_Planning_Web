/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author Admin
 */
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.Map;
import model.User; // Đảm bảo import model User
import service.QuizResultService;

@WebServlet(name = "QuizResultController", urlPatterns = {"/QuizResultController"})
public class QuizResultController extends HttpServlet {
    
    private QuizResultService quizResultService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        this.quizResultService = new QuizResultService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lấy đối tượng User từ session thay vì Integer userId
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // 2. Kiểm tra bảo mật: Nếu chưa đăng nhập, bắt buộc quay về trang login
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // 3. Sử dụng user.getUserId() để lấy ID thực tế của người đăng nhập
            Map<String, Object> dashboardData = quizResultService.getUserDashboardData(user.getUserId());
            
            // 4. Đẩy dữ liệu sang JSP
            request.setAttribute("dashboardData", dashboardData);
            
            // Lấy tên thật từ session để hiển thị trên giao diện
            request.setAttribute("userName", user.getUsername()); 
            
            // 5. Điều hướng đến trang kết quả (Đảm bảo đường dẫn views/... là chính xác)
            RequestDispatcher dispatcher = request.getRequestDispatcher("views/quizpage.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            // Gửi lỗi chi tiết về trình duyệt nếu có sự cố hệ thống
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Error loading quiz results: " + e.getMessage());
        }
    }
}