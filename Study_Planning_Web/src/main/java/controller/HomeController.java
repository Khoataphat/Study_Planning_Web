package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import service.UserProfilesService;
import model.UserProfiles;
import java.io.IOException;

@WebServlet("/home")
public class HomeController extends HttpServlet {

    private UserProfilesService userProfilesService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.userProfilesService = new UserProfilesService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int userId = getUserIdFromSession(request);
        
        // Chưa đăng nhập
        if (userId == 0) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Kiểm tra trạng thái setup để chuyển hướng thông minh
            UserProfiles profile = userProfilesService.getProfile(userId);
            
            if (profile == null || profile.getGoal() == null) {
                // Chưa hoàn thành basic setup
                response.sendRedirect(request.getContextPath() + "/basic-setup-save");
            } else if (!isLearningStyleSetupCompleted(profile)) {
                // Chưa hoàn thành learning style setup
                response.sendRedirect(request.getContextPath() + "/learning-style-setup");
            } else {
                // Đã hoàn thành tất cả, đến dashboard
                response.sendRedirect(request.getContextPath() + "/dashboard");
            }
            
        } catch (Exception e) {
            // Nếu có lỗi, mặc định chuyển đến dashboard
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }

    private boolean isLearningStyleSetupCompleted(UserProfiles profile) {
    return (profile.getStudyMethodVisual() != null && !"false".equals(profile.getStudyMethodVisual())) ||
           (profile.getStudyMethodAuditory() != null && !"false".equals(profile.getStudyMethodAuditory())) ||
           (profile.getStudyMethodReading() != null && !"false".equals(profile.getStudyMethodReading())) ||
           (profile.getStudyMethodPractice() != null && !"false".equals(profile.getStudyMethodPractice()));
}


    private int getUserIdFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            Object userObj = session.getAttribute("user");
            if (userObj instanceof model.User) {
                return ((model.User) userObj).getUserId();
            }
        }
        return userId != null ? userId : 0;
    }
}