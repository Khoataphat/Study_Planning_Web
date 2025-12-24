/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author Admin
 */
import service.LearningStyleService;
import model.LearningStyleQuestion;
import model.LearningStyleResult;
import model.User; 
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "LearningStyleQuizController", 
           urlPatterns = {"/quiz/learning-style", "/quiz/learning-style/submit"})
public class LearningStyleQuizController extends HttpServlet {
    
    private LearningStyleService learningStyleService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        this.learningStyleService = new LearningStyleService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lấy đối tượng User từ session (Giống DashboardController)
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // 2. Kiểm tra đăng nhập chặt chẽ
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int userId = user.getUserId();
        
        try {
            // Đẩy tên người dùng ra JSP để hiển thị lời chào
            request.setAttribute("userName", user.getUsername());

            // 3. Kiểm tra xem người dùng đã hoàn thành bài test chưa
            if (learningStyleService.hasUserCompletedQuiz(userId)) {
                LearningStyleResult result = learningStyleService.getUserResult(userId);
                request.setAttribute("learningStyleResult", result);
                
                RequestDispatcher dispatcher = 
                    request.getRequestDispatcher("/views/quiz/learning-style-result.jsp");
                dispatcher.forward(request, response);
                return;
            }
            
            // 4. Lấy danh sách câu hỏi
            List<LearningStyleQuestion> questions = learningStyleService.getLearningStyleQuestions();
            request.setAttribute("questions", questions);
            
            // Chuyển hướng đến trang làm bài test
            RequestDispatcher dispatcher = 
                request.getRequestDispatcher("/views/quiz/learning-style-quiz.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải bài quiz: " + e.getMessage());
            // Nếu lỗi nặng, trả về dashboard
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 5. Kiểm tra user từ session tương tự doGet
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int userId = user.getUserId();
        
        try {
            // Xử lý nộp bài
            LearningStyleResult result = learningStyleService.submitQuiz(userId, 
                request.getParameterMap());
            
            if (result != null) {
                request.setAttribute("learningStyleResult", result);
                request.setAttribute("userName", user.getUsername());
                
                RequestDispatcher dispatcher = 
                    request.getRequestDispatcher("/views/quiz/learning-style-result.jsp");
                dispatcher.forward(request, response);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi xử lý kết quả. Vui lòng thử lại.");
                doGet(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            doGet(request, response);
        }
    }
}