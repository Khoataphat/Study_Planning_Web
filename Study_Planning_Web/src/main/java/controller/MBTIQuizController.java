/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author Admin
 */
import service.MBTIService;
import model.MBTIQuestion;
import model.MBTIResult;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

/**
 * MBTI Quiz Controller đã được sửa đổi theo phong cách DashboardController
 * Sử dụng đối tượng User từ Session và Jakarta EE.
 */
@WebServlet(name = "MBTIQuizController", urlPatterns = {"/quiz/mbti", "/quiz/mbti/submit"})
public class MBTIQuizController extends HttpServlet {
    
    private MBTIService mbtiService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        this.mbtiService = new MBTIService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lấy đối tượng User từ session thay vì Integer userId đơn lẻ
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // 2. Kiểm tra đăng nhập (Giống DashboardController)
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int userId = user.getUserId();
        
        try {
            // Kiểm tra nếu người dùng đã hoàn thành bài test
            if (mbtiService.hasUserCompletedQuiz(userId)) {
                MBTIResult result = mbtiService.getUserResult(userId);
                request.setAttribute("mbtiResult", result);
                request.setAttribute("userName", user.getUsername()); // Hiển thị tên thật
                
                RequestDispatcher dispatcher = request.getRequestDispatcher("/views/quiz/mbti-result.jsp");
                dispatcher.forward(request, response);
                return;
            }
            
            // Lấy danh sách câu hỏi
            List<MBTIQuestion> questions = mbtiService.getMBTIQuestions();
            request.setAttribute("questions", questions);
            request.setAttribute("userName", user.getUsername());
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/quiz/mbti-quiz.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi tải bài trắc nghiệm.");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 3. Kiểm tra user từ session tương tự doGet
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int userId = user.getUserId();
        
        try {
            // Xử lý nộp bài với userId lấy từ đối tượng User
            MBTIResult result = mbtiService.submitQuiz(userId, request.getParameterMap());
            
            if (result != null) {
                request.setAttribute("mbtiResult", result);
                request.setAttribute("userName", user.getUsername());
                RequestDispatcher dispatcher = request.getRequestDispatcher("/views/quiz/mbti-result.jsp");
                dispatcher.forward(request, response);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi xử lý kết quả. Vui lòng thử lại.");
                // Quay lại trang quiz (Gọi lại doGet để load câu hỏi)
                doGet(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            doGet(request, response);
        }
    }
}