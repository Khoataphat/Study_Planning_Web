package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import service.UserProfilesService;
import dao.UserDAO;
import model.UserProfiles;
import model.User;
import java.io.IOException;

@WebServlet(name = "LearningStyleSetupController", urlPatterns = {"/learning-style-setup"})
public class LearningStyleSetupController extends HttpServlet {

    private UserProfilesService userProfilesService;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.userProfilesService = new UserProfilesService();
        this.userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== LearningStyleSetupController.doGet() START ===");
        
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null) {
            System.out.println(">>> No session found, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (user == null) {
            System.out.println(">>> No user in session, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        System.out.println(">>> User found: " + user.getUsername() + ", ID: " + user.getUserId());
        
        try {
            // Lấy profile từ database
            UserProfiles profile = userProfilesService.getProfile(user.getUserId());
            
            // Nếu chưa có profile, tạo mới
            if (profile == null) {
                System.out.println(">>> No profile found, creating new one");
                profile = new UserProfiles();
                profile.setUserId(user.getUserId());
            } else {
                System.out.println(">>> Profile found, learning_style: " + profile.getLearningStyle());
                System.out.println(">>> Profile found, preferred_study_time: " + profile.getPreferredStudyTime());
            }
            
            // Đặt profile vào request
            request.setAttribute("userProfile", profile);
            
            // Forward đến JSP
            System.out.println(">>> Forwarding to /views/learning-style-setup.jsp");
            request.getRequestDispatcher("/views/learning-style-setup.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println(">>> ERROR in doGet(): " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải trang thiết lập: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
        
        System.out.println("=== LearningStyleSetupController.doGet() END ===");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("=== LearningStyleSetupController.doPost() START ===");
        
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null) {
            System.out.println(">>> No session in POST, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (user == null) {
            System.out.println(">>> No user in POST, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        System.out.println(">>> Processing form for user: " + user.getUsername());
        
        try {
            // ====================================================
            // 1. LẤY TẤT CẢ THAM SỐ TỪ FORM
            // ====================================================
            String learningStyle = request.getParameter("learning_style");
            String preferredStudyTime = request.getParameter("preferred_study_time");
            String yearOfStudyStr = request.getParameter("year_of_study");
            String focusDurationStr = request.getParameter("focus_duration");
            String personalityType = request.getParameter("personality_type");
            String goal = request.getParameter("goal");
            
            // Debug log
            System.out.println(">>> Form parameters:");
            System.out.println(">>> learning_style: " + learningStyle);
            System.out.println(">>> preferred_study_time: " + preferredStudyTime);
            System.out.println(">>> year_of_study: " + yearOfStudyStr);
            System.out.println(">>> focus_duration: " + focusDurationStr);
            System.out.println(">>> personality_type: " + personalityType);
            System.out.println(">>> goal: " + goal);
            
            // ====================================================
            // 2. VALIDATE DỮ LIỆU
            // ====================================================
            StringBuilder errorMessage = new StringBuilder();
            
            // Kiểm tra các trường bắt buộc
            if (learningStyle == null || learningStyle.trim().isEmpty()) {
                errorMessage.append("- Vui lòng chọn phong cách học tập\n");
            }
            
            if (preferredStudyTime == null || preferredStudyTime.trim().isEmpty()) {
                errorMessage.append("- Vui lòng chọn thời gian học hiệu quả\n");
            }
            
            if (focusDurationStr == null || focusDurationStr.trim().isEmpty()) {
                errorMessage.append("- Vui lòng chọn thời gian tập trung\n");
            }
            
            if (goal == null || goal.trim().isEmpty()) {
                errorMessage.append("- Vui lòng nhập mục tiêu học tập\n");
            }
            
            // Nếu có lỗi validation
            if (errorMessage.length() > 0) {
                System.out.println(">>> Validation errors: " + errorMessage.toString());
                
                // Lấy lại profile để hiển thị form với dữ liệu cũ
                UserProfiles profile = new UserProfiles();
                profile.setUserId(user.getUserId());
                profile.setLearningStyle(learningStyle);
                profile.setPreferredStudyTime(preferredStudyTime);
                profile.setGoal(goal);
                
                // Chuyển đổi yearOfStudy
                if (yearOfStudyStr != null && !yearOfStudyStr.trim().isEmpty()) {
                    try {
                        profile.setYearOfStudy(Integer.parseInt(yearOfStudyStr));
                    } catch (NumberFormatException e) {
                        // Không xử lý
                    }
                }
                
                // Chuyển đổi focusDuration
                if (focusDurationStr != null && !focusDurationStr.trim().isEmpty()) {
                    try {
                        profile.setFocusDuration(Integer.parseInt(focusDurationStr));
                    } catch (NumberFormatException e) {
                        // Không xử lý
                    }
                }
                
                profile.setPersonalityType(personalityType);
                
                request.setAttribute("userProfile", profile);
                request.setAttribute("error", errorMessage.toString());
                request.getRequestDispatcher("/views/learning-style-setup.jsp").forward(request, response);
                return;
            }
            
            // ====================================================
            // 3. CHUYỂN ĐỔI KIỂU DỮ LIỆU
            // ====================================================
            Integer yearOfStudy = null;
            if (yearOfStudyStr != null && !yearOfStudyStr.trim().isEmpty()) {
                try {
                    yearOfStudy = Integer.parseInt(yearOfStudyStr);
                } catch (NumberFormatException e) {
                    System.out.println(">>> Warning: Invalid year_of_study format: " + yearOfStudyStr);
                }
            }
            
            Integer focusDuration;
            try {
                focusDuration = Integer.parseInt(focusDurationStr);
            } catch (NumberFormatException e) {
                System.out.println(">>> Error: Invalid focus_duration format: " + focusDurationStr);
                request.setAttribute("error", "Thời gian tập trung phải là số hợp lệ");
                
                UserProfiles profile = new UserProfiles();
                profile.setUserId(user.getUserId());
                profile.setLearningStyle(learningStyle);
                profile.setPreferredStudyTime(preferredStudyTime);
                profile.setGoal(goal);
                profile.setYearOfStudy(yearOfStudy);
                profile.setPersonalityType(personalityType);
                
                request.setAttribute("userProfile", profile);
                request.getRequestDispatcher("/views/learning-style-setup.jsp").forward(request, response);
                return;
            }
            
            // ====================================================
            // 4. LẤY HOẶC TẠO PROFILE
            // ====================================================
            UserProfiles profile = userProfilesService.getProfile(user.getUserId());
            if (profile == null) {
                System.out.println(">>> Creating new profile for user: " + user.getUserId());
                profile = new UserProfiles();
                profile.setUserId(user.getUserId());
            } else {
                System.out.println(">>> Updating existing profile");
            }
            
            // ====================================================
            // 5. CẬP NHẬT DỮ LIỆU
            // ====================================================
            profile.setLearningStyle(learningStyle);
            profile.setPreferredStudyTime(preferredStudyTime);
            profile.setYearOfStudy(yearOfStudy);
            profile.setFocusDuration(focusDuration);
            profile.setPersonalityType(personalityType);
            profile.setGoal(goal);
            
            System.out.println(">>> Profile data to save:");
            System.out.println(">>> - learning_style: " + profile.getLearningStyle());
            System.out.println(">>> - preferred_study_time: " + profile.getPreferredStudyTime());
            System.out.println(">>> - year_of_study: " + profile.getYearOfStudy());
            System.out.println(">>> - focus_duration: " + profile.getFocusDuration());
            System.out.println(">>> - personality_type: " + profile.getPersonalityType());
            System.out.println(">>> - goal: " + profile.getGoal());
            
            // ====================================================
            // 6. LƯU VÀO DATABASE
            // ====================================================
            try {
                boolean success = userProfilesService.saveOrUpdateProfile(profile);
                if (success) {
                    System.out.println(">>> Profile saved successfully");
                } else {
                    System.out.println(">>> Failed to save profile");
                }
            } catch (Exception e) {
                System.err.println(">>> ERROR saving profile: " + e.getMessage());
                e.printStackTrace();
                throw e;
            }
            
            // ====================================================
            // 7. CẬP NHẬT USER STATUS
            // ====================================================
            try {
                userDAO.markSetupDone(user.getUserId());
                System.out.println(">>> User setup marked as done");
                
                // Cập nhật session
                user.setisFirstLogin(0);
                session.setAttribute("user", user);
                System.out.println(">>> Session updated: isFirstLogin = 0");
                
            } catch (Exception e) {
                System.err.println(">>> ERROR updating user status: " + e.getMessage());
                // Không throw, vẫn tiếp tục vì profile đã được lưu
            }
            
            // ====================================================
            // 8. REDIRECT ĐẾN DASHBOARD
            // ====================================================
            System.out.println(">>> Redirecting to dashboard");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            
        } catch (Exception e) {
            System.err.println(">>> ERROR in doPost(): " + e.getMessage());
            e.printStackTrace();
            
            // Hiển thị lỗi cho người dùng
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            
            // Cố gắng lấy lại profile để hiển thị form
            try {
                UserProfiles profile = userProfilesService.getProfile(user.getUserId());
                if (profile == null) {
                    profile = new UserProfiles();
                    profile.setUserId(user.getUserId());
                }
                request.setAttribute("userProfile", profile);
            } catch (Exception ex) {
                // Bỏ qua
            }
            
            request.getRequestDispatcher("/views/learning-style-setup.jsp").forward(request, response);
        }
        
        System.out.println("=== LearningStyleSetupController.doPost() END ===");
    }
}