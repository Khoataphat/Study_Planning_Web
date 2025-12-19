package controller;

import service.UserProfilesService;
import model.UserProfiles;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "ProfilesController", value = "/profiles")
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

        try {
            UserProfiles userProfile = userProfilesService.getProfile(userId);
            request.setAttribute("userProfile", userProfile);
            request.getRequestDispatcher("/profiles.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải thông tin hồ sơ: " + e.getMessage());
            request.getRequestDispatcher("/profiles.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String action = request.getParameter("action");
        int userId = getUserIdFromSession(request);

        // Xử lý nút "TIẾP THEO" - chuyển đến learning-style-setup
        if ("next".equals(action)) {
            response.sendRedirect(request.getContextPath() + "/learning-style-setup");
            return;
        }

        // Xử lý cập nhật profile
        try {
            // Thông tin cá nhân
            String fullName = request.getParameter("fullName");
            String description = request.getParameter("description");
            String workStyle = request.getParameter("workStyle");
            String hobbies = request.getParameter("hobbies");
            
            // Phong cách học
            String[] learningStyles = request.getParameterValues("learningStyles");
            String productiveTime = request.getParameter("productiveTime");

            // Validate dữ liệu bắt buộc
            if (fullName == null || fullName.trim().isEmpty() ||
                workStyle == null || workStyle.trim().isEmpty() ||
                productiveTime == null || productiveTime.trim().isEmpty()) {
                
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc");
                UserProfiles userProfile = userProfilesService.getProfile(userId);
                request.setAttribute("userProfile", userProfile);
                request.getRequestDispatcher("/profiles.jsp").forward(request, response);
                return;
            }

            String learningStyleStr = "";
            if (learningStyles != null && learningStyles.length > 0) {
                learningStyleStr = String.join(",", learningStyles);
            }

            UserProfiles userProfile = userProfilesService.getProfile(userId);
            
            // Cập nhật thông tin cơ bản
            userProfile.setFullName(fullName);
            userProfile.setDescription(description != null ? description : "");
            userProfile.setLearningStyle(learningStyleStr);
            userProfile.setWorkStyle(workStyle);
            userProfile.setHobbies(hobbies != null ? hobbies : "");
            userProfile.setPreferredStudyTime(productiveTime);
            userProfile.setProductiveTime(productiveTime);

            // Giá trị mặc định cho các trường khác (nếu chưa có)
            setDefaultProfileValues(userProfile);

            boolean success = userProfilesService.update(userProfile);

            if (success) {
                request.setAttribute("success", "Cập nhật hồ sơ thành công!");
                request.setAttribute("userProfile", userProfile);
            } else {
                request.setAttribute("error", "Cập nhật hồ sơ thất bại!");
            }

            request.getRequestDispatcher("/profiles.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            handleException(request, response, e, "Lỗi: " + e.getMessage());
        }
    }

    /**
     * Thiết lập giá trị mặc định cho profile
     */
    private void setDefaultProfileValues(UserProfiles userProfile) {
        if (userProfile.getYearOfStudy() == null) {
            userProfile.setYearOfStudy(1);
        }
        if (userProfile.getFocusDuration() == null) {
            userProfile.setFocusDuration(45);
        }
        if (userProfile.getGoal() == null || userProfile.getGoal().trim().isEmpty()) {
            userProfile.setGoal("Hoàn thành chương trình học");
        }
        
        // Giá trị mặc định cho form khám phá (nếu chưa có)
        if (userProfile.getStudyMethodVisual() == null) {
            userProfile.setStudyMethodVisual("false");
        }
        if (userProfile.getStudyMethodAuditory() == null) {
            userProfile.setStudyMethodAuditory("false");
        }
        if (userProfile.getStudyMethodReading() == null) {
            userProfile.setStudyMethodReading("false");
        }
        if (userProfile.getStudyMethodPractice() == null) {
            userProfile.setStudyMethodPractice("false");
        }
        if (userProfile.getGroupStudyPreference() == null) {
            userProfile.setGroupStudyPreference(3);
        }
    }

    /**
     * Xử lý exception
     */
    private void handleException(HttpServletRequest request, HttpServletResponse response, 
                               Exception e, String errorMessage) 
            throws ServletException, IOException {
        try {
            // Load lại profile để hiển thị form
            int userId = getUserIdFromSession(request);
            UserProfiles userProfile = userProfilesService.getProfile(userId);
            request.setAttribute("userProfile", userProfile);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        
        request.setAttribute("error", errorMessage);
        request.getRequestDispatcher("/profiles.jsp").forward(request, response);
    }

    /**
     * Lấy userId từ session
     */
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