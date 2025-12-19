package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import service.UserProfilesService;
import model.UserProfiles;
import java.io.IOException;

@WebServlet("/learning-style-setup")
public class LearningStyleSetupController extends HttpServlet {

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
        
        if (userId == 0) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Kiểm tra xem user đã hoàn thành form chưa
        try {
            UserProfiles profile = userProfilesService.getProfile(userId);
            if (profile != null && isLearningStyleSetupCompleted(profile)) {
                // Đã hoàn thành, chuyển hướng đến dashboard
                response.sendRedirect(request.getContextPath() + "/dashboard");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Hiển thị form khám phá phương pháp học
        request.getRequestDispatcher("/learning-style-setup.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        int userId = getUserIdFromSession(request);
        
        if (userId == 0) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Lấy dữ liệu từ form
            String studyVisual = request.getParameter("study_visual");
            String studyAuditory = request.getParameter("study_auditory");
            String studyReading = request.getParameter("study_reading");
            String studyPractice = request.getParameter("study_practice");
            String productiveTime = request.getParameter("productive_time");
            String groupStudyPrefStr = request.getParameter("group_study_preference");

            // Validate required fields
            if (productiveTime == null || productiveTime.trim().isEmpty() ||
                groupStudyPrefStr == null || groupStudyPrefStr.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc");
                request.getRequestDispatcher("/learning-style-setup.jsp").forward(request, response);
                return;
            }

            Integer groupStudyPreference = Integer.parseInt(groupStudyPrefStr);

            // Lấy và cập nhật profile
            UserProfiles profile = userProfilesService.getProfile(userId);
            profile.setStudyMethodVisual("true".equals(studyVisual) ? "true" : "false");
            profile.setStudyMethodAuditory("true".equals(studyAuditory) ? "true" : "false");
            profile.setStudyMethodReading("true".equals(studyReading) ? "true" : "false");
            profile.setStudyMethodPractice("true".equals(studyPractice) ? "true" : "false");
            
            // Các giá trị khác
            profile.setProductiveTime(productiveTime);
            profile.setGroupStudyPreference(groupStudyPreference);
        
            // Lưu vào database
            boolean success = userProfilesService.update(profile);

            if (success) {
                // Chuyển hướng đến dashboard
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi lưu thông tin học tập");
                request.getRequestDispatcher("/learning-style-setup.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Vui lòng chọn mức độ yêu thích học nhóm hợp lệ");
            request.getRequestDispatcher("/learning-style-setup.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/learning-style-setup.jsp").forward(request, response);
        }
    }

    /**
     * Cập nhật thông tin learning style cho profile
     */
    private void updateLearningStyleProfile(UserProfiles profile, String visual, String auditory, 
                                          String reading, String practice, String productiveTime, 
                                          Integer groupPreference) {
        profile.setStudyMethodVisual(visual != null ? visual : "false");
        profile.setStudyMethodAuditory(auditory != null ? auditory : "false");
        profile.setStudyMethodReading(reading != null ? reading : "false");
        profile.setStudyMethodPractice(practice != null ? practice : "false");
        profile.setProductiveTime(productiveTime);
        profile.setGroupStudyPreference(groupPreference);
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