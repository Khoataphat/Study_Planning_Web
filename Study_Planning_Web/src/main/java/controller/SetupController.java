/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.UserDAO;
import dao.UserProfilesDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;
import model.UserProfiles;
import service.UserProfilesService;

/**
 *
 * @author Admin
 */
@WebServlet("/basic-setup-save")
public class SetupController extends HttpServlet {
// Khai báo Service Layer

    private UserProfilesService userProfilesService;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        // Khởi tạo các DAO và Service
        UserProfilesDAO userProfilesDAO = new UserProfilesDAO();
        UserDAO userDAO = new UserDAO(); // Giả định UserDAO tồn tại
        this.userProfilesService = new UserProfilesService(userProfilesDAO, userDAO);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            // Chuyển hướng người dùng chưa đăng nhập về trang login
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            // 1. Lấy dữ liệu từ form (từ các radio buttons đã sửa)

            // Tên form field: goals (Step 1)
            String goal = req.getParameter("goals");

            // Tên form field: study_style (Step 2) -> Ánh xạ vào learning_style trong DB
            String learningStyle = req.getParameter("study_style");

            // Tên form field: lifestyle (Step 3) -> Ánh xạ vào preferred_study_time trong DB
            String preferredStudyTime = req.getParameter("lifestyle");

            // 2. Tạo đối tượng UserProfiles và điền dữ liệu
            UserProfiles profile = extractProfileFromRequest(req, user.getUserId());
            profile.setUserId(user.getUserId());

            // Điền các giá trị từ form
            profile.setGoal(goal);
            profile.setLearningStyle(learningStyle);
            profile.setPreferredStudyTime(preferredStudyTime);

            // Các trường khác không có trong form 3 bước, cần đặt giá trị mặc định/null hoặc lấy từ nơi khác
            // Ví dụ: Đặt giá trị null cho các trường không bắt buộc
            profile.setYearOfStudy(null);
            profile.setFocusDuration(null);
            profile.setPersonalityType(null);
            
            // Validate dữ liệu
            if (!validateProfile(profile)) {
                req.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin bắt buộc");
                req.setAttribute("profile", profile);
                req.getRequestDispatcher("/basic-setup.jsp").forward(req, resp);
                return;
            }
            // Lưu profile và cập nhật trạng thái user
            boolean success = saveUserProfile(user, profile, session);
            if (success) {
            // Sau khi setup STEP 1 → chuyển sang STEP 2
            resp.sendRedirect(req.getContextPath() + "/learning-style-setup");
            } else {
            handleSaveError(req, resp, "Đã xảy ra lỗi khi lưu thông tin cấu hình");
            }

            // 3. Gọi Service để lưu DB và cập nhật trạng thái
            userProfilesService.saveSetup(profile);

            // 4. Cập nhật flag first_login trong session
            // Giả sử service.saveSetup() đã gọi userDAO.markSetupDone(user.getId())
            // Giả sử field để kiểm tra first login trong model User là IsFirstLogin
            user.setisFirstLogin(0);
            session.setAttribute("user", user);

            // 5. Chuyển hướng người dùng đến Dashboard
            resp.sendRedirect(req.getContextPath() + "/views/home.html");
            // --AnNX-- nên đổi sang thành dashboard.jsp nha

        } catch (Exception e) {
            // Gửi lỗi về trang lỗi hoặc hiển thị thông báo
            req.setAttribute("errorMessage", "Đã xảy ra lỗi khi lưu cấu hình: " + e.getMessage());
        }
    }

    //google
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            // Chuyển hướng người dùng chưa đăng nhập về trang login
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 1. Kiểm tra trạng thái is_first_login
        // Nếu setup đã hoàn thành, chuyển hướng thẳng đến trang chủ (Dashboard)
        if (user.getisFirstLogin() == 0) { // Giả sử getIsFirstLogin() là getter đúng
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        // 2. Chuyển tiếp (Forward) request đến trang JSP/HTML chứa form setup
        // ⚠️ ĐẢM BẢO ĐƯỜNG DẪN NÀY CHÍNH XÁC ĐẾN FILE SETUP CỦA BẠN
        req.getRequestDispatcher("/views/basic-setup.jsp").forward(req, resp);
    }

    /**
     * Trích xuất thông tin profile từ request
     */
    private UserProfiles extractProfileFromRequest(HttpServletRequest req, int userId) {
        UserProfiles profile = new UserProfiles();
        profile.setUserId(userId);
        
        // Thông tin cá nhân
        profile.setFullName(getParameterOrDefault(req, "fullName", "Người dùng mới"));
        profile.setDescription(getParameterOrDefault(req, "description", "Chưa có mô tả"));
        
        // Thông tin học tập
        profile.setGoal(req.getParameter("goals"));
        profile.setLearningStyle(req.getParameter("study_style"));
        profile.setWorkStyle(req.getParameter("work_style"));
        profile.setHobbies(req.getParameter("hobbies"));
        profile.setPreferredStudyTime(req.getParameter("lifestyle"));
        profile.setProductiveTime(req.getParameter("lifestyle")); // Đồng bộ với preferredStudyTime
        
        // Thông tin năm học
        String yearOfStudyStr = req.getParameter("yearOfStudy");
        if (yearOfStudyStr != null && !yearOfStudyStr.trim().isEmpty()) {
            try {
                profile.setYearOfStudy(Integer.parseInt(yearOfStudyStr));
            } catch (NumberFormatException e) {
                profile.setYearOfStudy(1); // Default value
            }
        } else {
            profile.setYearOfStudy(1);
        }
        
        // Thiết lập giá trị mặc định cho các trường khác
        setDefaultProfileValues(profile);
        
        return profile;
    }

    /**
     * Lấy giá trị parameter hoặc giá trị mặc định
     */
    private String getParameterOrDefault(HttpServletRequest req, String paramName, String defaultValue) {
        String value = req.getParameter(paramName);
        return (value != null && !value.trim().isEmpty()) ? value : defaultValue;
    }

    /**
     * Thiết lập giá trị mặc định cho profile
     */
    private void setDefaultProfileValues(UserProfiles profile) {
        // Giá trị mặc định nếu không có từ form
        if (profile.getWorkStyle() == null) {
            profile.setWorkStyle("individual");
        }
        if (profile.getHobbies() == null || profile.getHobbies().trim().isEmpty()) {
            profile.setHobbies("Đang cập nhật");
        }
        
        profile.setFocusDuration(45);
        profile.setPersonalityType(null);
        
        // Giá trị mặc định cho form khám phá phương pháp học
        // (sẽ được cập nhật chi tiết trong form khám phá)
        profile.setStudyMethodVisual("false");
        profile.setStudyMethodAuditory("false");
        profile.setStudyMethodReading("false");
        profile.setStudyMethodPractice("false");
        profile.setGroupStudyPreference(3);
    }

    /**
     * Validate dữ liệu profile
     */
    private boolean validateProfile(UserProfiles profile) {
        // Validate các trường bắt buộc
        if (profile.getGoal() == null || profile.getGoal().trim().isEmpty()) {
            return false;
        }
        if (profile.getLearningStyle() == null || profile.getLearningStyle().trim().isEmpty()) {
            return false;
        }
        if (profile.getPreferredStudyTime() == null || profile.getPreferredStudyTime().trim().isEmpty()) {
            return false;
        }
        if (profile.getWorkStyle() == null || profile.getWorkStyle().trim().isEmpty()) {
            return false;
        }
        
        return true;
    }

    /**
     * Lưu profile và cập nhật trạng thái user
     */
    private boolean saveUserProfile(User user, UserProfiles profile, HttpSession session) throws Exception {
        boolean saveSuccess = userProfilesService.save(profile);
        
        if (saveSuccess) {
            try {
                // Cập nhật trạng thái first login trong database
                userDAO.markSetupDone(user.getUserId());
                
                // Cập nhật user trong session
                user.setisFirstLogin(0);
                session.setAttribute("user", user);
                session.setAttribute("basicSetupCompleted", true);
                
                return true;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        }
        return false;
    }

    /**
     * Chuyển hướng dựa trên trạng thái hoàn thành profile
     */
    private void redirectBasedOnProfileCompletion(HttpServletResponse resp, int userId) throws IOException {
        try {
            UserProfiles profile = userProfilesService.getProfile(userId);
            String redirectPath = (profile != null && isLearningStyleSetupCompleted(profile)) 
                ? "/dashboard"  // Đã hoàn thành cả form khám phá
                : "/learning-style-setup"; // Chưa hoàn thành form khám phá
            
            resp.sendRedirect(resp.encodeRedirectURL(redirectPath));
            
        } catch (Exception e) {
            // Nếu có lỗi khi kiểm tra, chuyển đến form khám phá để đảm bảo luồng tiếp tục
            resp.sendRedirect(resp.encodeRedirectURL("/learning-style-setup"));
        }
    }

    /**
     * Kiểm tra xem form khám phá phương pháp học đã hoàn thành chưa
     */
    private boolean isLearningStyleSetupCompleted(UserProfiles profile) {
    return (profile.getStudyMethodVisual() != null && !"false".equals(profile.getStudyMethodVisual())) ||
           (profile.getStudyMethodAuditory() != null && !"false".equals(profile.getStudyMethodAuditory())) ||
           (profile.getStudyMethodReading() != null && !"false".equals(profile.getStudyMethodReading())) ||
           (profile.getStudyMethodPractice() != null && !"false".equals(profile.getStudyMethodPractice()));
}


    /**
     * Xử lý lỗi khi lưu profile
     */
    private void handleSaveError(HttpServletRequest req, HttpServletResponse resp, String errorMessage) 
            throws ServletException, IOException {
        req.setAttribute("errorMessage", errorMessage);
        req.getRequestDispatcher("/basic-setup.jsp").forward(req, resp);
    }

    /**
     * Xử lý exception
     */
    private void handleException(HttpServletRequest req, HttpServletResponse resp, Exception e, String errorMessage) 
            throws ServletException, IOException {
        e.printStackTrace();
        req.setAttribute("errorMessage", errorMessage);
        req.getRequestDispatcher("/basic-setup.jsp").forward(req, resp);
    }
}
