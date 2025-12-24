/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author Admin
 */
import service.CareerService;
import model.CareerQuestion;
import model.CareerResult;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CareerQuizController", 
           urlPatterns = {"/quiz/career", "/quiz/career/submit"})
public class CareerQuizController extends HttpServlet {
    
    private CareerService careerService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        this.careerService = new CareerService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int userId = user.getUserId();
        
        try {
            request.setAttribute("userName", user.getUsername());

            // Kiểm tra nếu đã hoàn thành quiz
            if (careerService.hasUserCompletedQuiz(userId)) {
                CareerResult result = careerService.getUserResult(userId);
                request.setAttribute("careerResult", result);

                // Lấy career recommendations dưới dạng List<Map>
                List<Map<String, Object>> recommendations = careerService.getCareerRecommendations(result);
                request.setAttribute("careerRecommendations", recommendations);

                // Lấy chi tiết điểm số
                Map<String, Integer> scoreBreakdown = careerService.getScoreBreakdown(result);
                request.setAttribute("scoreBreakdown", scoreBreakdown);
                
                request.getRequestDispatcher("/views/quiz/career-result.jsp").forward(request, response);
                return;
            }
            
            // Nếu chưa làm quiz, hiển thị câu hỏi
            List<CareerQuestion> questions = careerService.getCareerQuestions();
            request.setAttribute("questions", questions);
            
            request.getRequestDispatcher("/views/quiz/career-quiz.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải bài quiz: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int userId = user.getUserId();
        
        try {
            CareerResult result = careerService.submitQuiz(userId, request.getParameterMap());
            
            if (result != null) {
                response.sendRedirect(request.getContextPath() + "/quiz/career");
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
