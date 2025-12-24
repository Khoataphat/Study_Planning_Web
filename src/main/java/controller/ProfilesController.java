package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import service.UserProfilesService;
import model.UserProfiles;
import java.io.IOException;

@WebServlet(name = "ProfilesController", urlPatterns = {"/user/profiles"})
public class ProfilesController extends HttpServlet {

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

        try {
            UserProfiles userProfile = userProfilesService.getOrCreateDefaultProfile(userId);
            request.setAttribute("userProfile", userProfile);
            request.getRequestDispatcher("/views/profiles.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải thông tin hồ sơ: " + e.getMessage());
            request.getRequestDispatcher("/views/profiles.jsp").forward(request, response);
        }
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
            // Chỉ lấy 4 trường đầu
            String yearOfStudyStr = request.getParameter("year_of_study");
            String personalityType = request.getParameter("personality_type");
            String preferredStudyTime = request.getParameter("preferred_study_time");
            String learningStyle = request.getParameter("learning_style");

            // Validate
            if (personalityType == null || personalityType.trim().isEmpty() ||
                preferredStudyTime == null || preferredStudyTime.trim().isEmpty() ||
                learningStyle == null || learningStyle.trim().isEmpty()) {
                
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc");
                request.getRequestDispatcher("/views/profiles.jsp").forward(request, response);
                return;
            }

            Integer yearOfStudy = null;
            try {
                if (yearOfStudyStr != null && !yearOfStudyStr.trim().isEmpty()) {
                    yearOfStudy = Integer.parseInt(yearOfStudyStr);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Năm học phải là số");
                request.getRequestDispatcher("/views/profiles.jsp").forward(request, response);
                return;
            }

            UserProfiles userProfile = userProfilesService.getOrCreateDefaultProfile(userId);
            
            // Cập nhật 4 trường đầu
            userProfile.setYearOfStudy(yearOfStudy);
            userProfile.setPersonalityType(personalityType);
            userProfile.setPreferredStudyTime(preferredStudyTime);
            userProfile.setLearningStyle(learningStyle);

            // Lưu vào database (chỉ 4 trường đầu, các trường khác giữ nguyên nếu có)
            userProfilesService.saveOrUpdateProfile(userProfile);
            
            // Chuyển hướng đến bước 2
            response.sendRedirect(request.getContextPath() + "/learning-style-setup");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/views/profiles.jsp").forward(request, response);
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