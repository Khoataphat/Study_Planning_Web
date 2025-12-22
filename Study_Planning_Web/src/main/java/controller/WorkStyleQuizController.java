/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author Admin
 */
import service.WorkStyleService;
import model.WorkStyleQuestion;
import model.WorkStyleResult;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "WorkStyleQuizController", 
           urlPatterns = {"/quiz/work-style", "/quiz/work-style/submit"})
public class WorkStyleQuizController extends HttpServlet {
    
    private WorkStyleService workStyleService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        this.workStyleService = new WorkStyleService();
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
            // Check if user has completed the quiz
            if (workStyleService.hasUserCompletedQuiz(userId)) {
                WorkStyleResult result = workStyleService.getUserResult(userId);
                request.setAttribute("workStyleResult", result);

                // Thêm thông tin mô tả
                Map<String, String> styleDescription = workStyleService.getStyleDescription(result.getPrimaryStyle());
                request.setAttribute("styleDescription", styleDescription);

                // Thêm breakdown scores
                Map<String, Integer> scoreBreakdown = workStyleService.getScoreBreakdown(result);
                request.setAttribute("scoreBreakdown", scoreBreakdown);

                request.getRequestDispatcher("/views/quiz/work-style-result.jsp").forward(request, response);
                return;
            }

            // Get questions
            List<WorkStyleQuestion> questions = workStyleService.getWorkStyleQuestions();
            request.setAttribute("questions", questions);
            
            // Forward to quiz page
            request.getRequestDispatcher("/views/quiz/work-style-quiz.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi tải quiz: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int userId = user.getUserId();
        
        try {
            // Submit quiz
            WorkStyleResult result = workStyleService.submitQuiz(userId, request.getParameterMap());
            
            if (result != null) {
                // Redirect to results page
                response.sendRedirect(request.getContextPath() + "/quiz/work-style");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi xử lý kết quả.");
                doGet(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            doGet(request, response);
        }
    }
    
    
}
