package controller;

import dao.TimetableDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import model.DashboardData;
import service.DashboardService;
import utils.DBUtil;
import service.UserProfilesService;
import model.UserProfiles;

@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {

    private UserProfilesService userProfilesService;

    @Override
    public void init() throws ServletException {
        userProfilesService = new UserProfilesService();
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
            // Lấy profile
            UserProfiles userProfile = userProfilesService.getProfile(userId);

            // Điều kiện chuyển trang
            if (userProfile == null || userProfile.getGoal() == null) {
                response.sendRedirect(request.getContextPath() + "/basic-setup-save");
                return;
            }

            if (!isLearningStyleSetupCompleted(userProfile)) {
                response.sendRedirect(request.getContextPath() + "/learning-style-setup");
                return;
            }

            // Lấy dashboard từ database
            Connection conn = DBUtil.getConnection();
            DashboardService dash = new DashboardService(new TimetableDAO(conn));
            DashboardData dashboardData = dash.loadDashboard(userId);

            request.setAttribute("dash", dashboardData);

            // Recommendation
            prepareDashboardData(request, userProfile);

            request.setAttribute("userProfile", userProfile);

            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải trang dashboard: " + e.getMessage());
            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
        }
    }


    // ==================== HÀM HỖ TRỢ ========================

    private void prepareDashboardData(HttpServletRequest request, UserProfiles profile) {
        request.setAttribute("weeklyStudyHours", "15h/20h");
        request.setAttribute("completedTasks", "8/12");
        request.setAttribute("studyProgress", "75%");

        request.setAttribute("studyRecommendation", generateStudyRecommendation(profile));
        request.setAttribute("scheduleRecommendation", generateScheduleRecommendation(profile));
        request.setAttribute("learningStyleDescription", getLearningStyleDescription(profile));
    }

    private String generateStudyRecommendation(UserProfiles profile) {
        StringBuilder recommendation = new StringBuilder();

        if (null == profile.getLearningStyle()) {
            recommendation.append("Bạn nên thực hành nhiều và làm bài tập thực tế. ");
        } else switch (profile.getLearningStyle()) {
            case "visual" -> recommendation.append("Bạn nên sử dụng sơ đồ tư duy, hình ảnh và video để học hiệu quả hơn. ");
            case "auditory" -> recommendation.append("Bạn nên nghe podcast, ghi âm bài giảng và thảo luận nhóm. ");
            case "reading" -> recommendation.append("Bạn nên đọc sách, ghi chú chi tiết và viết tóm tắt. ");
            default -> recommendation.append("Bạn nên thực hành nhiều và làm bài tập thực tế. ");
        }

        if ("true".equals(profile.getStudyMethodVisual())) {
            recommendation.append("Sử dụng infographic và mindmap sẽ giúp bạn ghi nhớ tốt. ");
        }
        if ("true".equals(profile.getStudyMethodAuditory())) {
            recommendation.append("Hãy thử ghi âm và nghe lại bài học. ");
        }

        return recommendation.toString();
    }

    private String generateScheduleRecommendation(UserProfiles profile) {
        String productiveTime = profile.getProductiveTime();
        String timeSuggestion;

        timeSuggestion = switch (productiveTime) {
            case "morning" -> "Buổi sáng (6h-10h)";
            case "afternoon" -> "Buổi chiều (14h-17h)";
            case "evening" -> "Buổi tối (19h-22h)";
            default -> "Buổi sáng";
        };

        return "Thời gian học hiệu quả nhất của bạn là: " + timeSuggestion 
             + ". Hãy sắp xếp các môn học khó vào khoảng thời gian này.";
    }

    private String getLearningStyleDescription(UserProfiles profile) {
        StringBuilder description = new StringBuilder();

        switch (profile.getLearningStyle()) {
            case "visual" -> description.append("Học qua hình ảnh");
            case "auditory" -> description.append("Học qua âm thanh");
            case "reading" -> description.append("Học qua đọc hiểu");
            case "kinesthetic" -> description.append("Học qua thực hành");
            default -> description.append("Đa dạng phong cách");
        }

        description.append(" (");
        boolean first = true;

        if ("true".equals(profile.getStudyMethodVisual())) {
            description.append("Hình ảnh"); first = false;
        }
        if ("true".equals(profile.getStudyMethodAuditory())) {
            if (!first) description.append(", "); 
            description.append("Âm thanh"); 
            first = false;
        }
        if ("true".equals(profile.getStudyMethodReading())) {
            if (!first) description.append(", "); 
            description.append("Đọc hiểu"); 
            first = false;
        }
        if ("true".equals(profile.getStudyMethodPractice())) {
            if (!first) description.append(", "); 
            description.append("Thực hành");
        }

        description.append(")");
        return description.toString();
    }

    private boolean isLearningStyleSetupCompleted(UserProfiles profile) {
        return ("true".equals(profile.getStudyMethodVisual()) ||
                "true".equals(profile.getStudyMethodAuditory()) ||
                "true".equals(profile.getStudyMethodReading()) ||
                "true".equals(profile.getStudyMethodPractice()));
    }

    private int getUserIdFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            Object userObj = session.getAttribute("user");
            if (userObj instanceof model.User user) {
                return user.getUserId();
            }
        }
        return (userId != null) ? userId : 0;
    }
}
