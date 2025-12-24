package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import service.UserProfilesService;
import model.UserProfiles;
import java.io.IOException;

@WebServlet("/")
public class RootController extends HttpServlet {

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
            
            // Nếu profile là null, chưa setup gì cả
            if (profile == null) {
                response.sendRedirect(request.getContextPath() + "/profiles");
                return;
            }
            
            // Kiểm tra xem đã hoàn thành bước 1 chưa (có learning_style)
            if (profile.getLearningStyle() == null || profile.getLearningStyle().trim().isEmpty()) {
                // Chưa hoàn thành bước 1 (Profiles)
                response.sendRedirect(request.getContextPath() + "/profiles");
            } 
            // Kiểm tra xem đã hoàn thành bước 2 chưa (có focus_duration và goal)
            else if (profile.getFocusDuration() == null || 
                     profile.getGoal() == null || 
                     profile.getGoal().trim().isEmpty()) {
                // Chưa hoàn thành bước 2 (Learning Style Setup)
                response.sendRedirect(request.getContextPath() + "/learning-style-setup");
            } 
            else {
                // Đã hoàn thành tất cả, đến dashboard
                response.sendRedirect(request.getContextPath() + "/dashboard");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // Nếu có lỗi, chuyển đến dashboard (hoặc login tùy bạn)
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
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