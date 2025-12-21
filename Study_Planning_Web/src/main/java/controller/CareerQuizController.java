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
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import static com.mysql.cj.conf.PropertyKey.logger;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CareerQuizController", 
           urlPatterns = {"/quiz/career", "/quiz/career/submit"})
public class CareerQuizController extends HttpServlet {
    
    private CareerService careerService;
    private ObjectMapper objectMapper;
    
    @Override
    public void init() throws ServletException {
        super.init();
        this.careerService = new CareerService();
        this.objectMapper = new ObjectMapper();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lấy đối tượng User từ session (Thống nhất với DashboardController)
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // 2. Kiểm tra đăng nhập chặt chẽ, không dùng ID mặc định
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int userId = user.getUserId();
        
        try {
            // Đẩy thông tin người dùng sang JSP
            request.setAttribute("userName", user.getUsername());

            // 3. Kiểm tra nếu người dùng đã hoàn thành bài test
            if (careerService.hasUserCompletedQuiz(userId)) {
                CareerResult result = careerService.getUserResult(userId);
                request.setAttribute("careerResult", result);

                // Xử lý JSON khuyến nghị nghề nghiệp
                if (result.getTopCareers() != null && !result.getTopCareers().isEmpty()) {
                    try {
                        JsonNode careersNode = objectMapper.readTree(result.getTopCareers());
                        request.setAttribute("careerRecommendations", careersNode);
                    } catch (Exception e) {
               
                        // Set empty list as fallback
                        request.setAttribute("careerRecommendations", new ArrayList<>());
                    }
                } else {
                    request.setAttribute("careerRecommendations", new ArrayList<>());
                }

                // Lấy chi tiết điểm số
                Map<String, Integer> scoreBreakdown = careerService.getScoreBreakdown(result);
                request.setAttribute("scoreBreakdown", scoreBreakdown);
                
                // Đảm bảo đường dẫn view đúng với cấu trúc dự án của bạn (thường bỏ /WEB-INF/ nếu dùng redirect trực tiếp)
                request.getRequestDispatcher("/views/quiz/career-result.jsp").forward(request, response);
                return;
            }
            
            // 4. Lấy danh sách câu hỏi cho bài test
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
        
        // 5. Kiểm tra user từ session tương tự doGet
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int userId = user.getUserId();
        
        try {
            // Xử lý nộp bài
            CareerResult result = careerService.submitQuiz(userId, request.getParameterMap());
            
            if (result != null) {
                // Sau khi nộp thành công, redirect về doGet để hiển thị kết quả
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
