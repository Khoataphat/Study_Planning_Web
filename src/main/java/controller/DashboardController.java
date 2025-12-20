/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import dao.TimetableDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import model.DashboardData;
import model.User;
import service.DashboardService;
import utils.DBUtil;

/**
 *
 * @author Admin
 */
@WebServlet(name = "DashboardController", urlPatterns = {"/dashboard"})
public class DashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            User user = (User) req.getSession().getAttribute("user");
            if (user == null) {
                resp.sendRedirect("/login");
                return;
            }

            // THÊM CODE MỚI: Kiểm tra user đã hoàn thành setup profile chưa
            try {
                // Khởi tạo UserProfilesService với constructor không tham số
                service.UserProfilesService userProfilesService = new service.UserProfilesService();
                
                // Kiểm tra xem user đã có profile chưa
                if (!userProfilesService.hasSetup(user.getUserId())) {
                    // Nếu chưa setup, chuyển hướng đến trang profiles
                    resp.sendRedirect(req.getContextPath() + "/profiles");
                    return;
                }
                
                // Lấy thông tin profile nếu đã setup
                model.UserProfiles userProfile = userProfilesService.getProfile(user.getUserId());
                if (userProfile != null) {
                    // Đặt thông tin profile vào request để JSP hiển thị
                    req.setAttribute("userProfile", userProfile);
                    
                    // Tạo và đặt gợi ý học tập vào request
                    String studySuggestion = generateStudySuggestion(userProfile);
                    req.setAttribute("studySuggestion", studySuggestion);
                    
                    // Đánh dấu đã hoàn thành setup
                    req.setAttribute("setupCompleted", true);
                    
                    // Đặt thông tin user vào request
                    req.setAttribute("userInfo", user);
                }
                
            } catch (Exception profileEx) {
                // Nếu có lỗi khi kiểm tra profile, vẫn cho vào dashboard
                System.err.println("Lỗi khi kiểm tra profile: " + profileEx.getMessage());
                profileEx.printStackTrace();
            }

            Connection conn = DBUtil.getConnection();
            if (conn != null && !conn.isClosed()) {
                System.out.println("DEBUG: Kết nối DB thành công!");
            } else {
                System.err.println("DEBUG: LỖI KẾT NỐI DB. Connection là null hoặc đã đóng.");
                return; // Dừng lại ở đây nếu kết nối thất bại
            }
            DashboardService dash = new DashboardService(
                    //                    new UserActivityDAO(conn),
                    //                    new TaskDAO(conn)
                    new TimetableDAO(conn)
            );
            // TẠM THỜI GHI ĐÈ USER ID ĐỂ TEST
            //int userIdToQuery = 25; // ID này có dữ liệu trong DB

            DashboardData dashboardData = dash.loadDashboard(user.getUserId());
            //DashboardData dashboardData = dash.loadDashboard(userIdToQuery); // Dùng ID 25 đã hardcode

            req.setAttribute("dash", dashboardData);

            req.getRequestDispatcher("views/dashboard.jsp").forward(req, resp);

        } catch (Exception e) {
            // Nếu có bất kỳ lỗi nào xảy ra (SQL, Mapping,...)
            // LỖI NÀY CẦN PHẢI ĐƯỢC IN RA CONSOLE ĐỂ PHÁT HIỆN!
            e.printStackTrace();
            // Sau đó Controller vẫn forward, nhưng đối tượng 'data' có thể null hoặc thiếu dữ liệu.
        }
    }
    
    // THÊM CODE MỚI: Phương thức tạo gợi ý học tập dựa trên profile
    private String generateStudySuggestion(model.UserProfiles profile) {
        if (profile == null || profile.getLearningStyle() == null) {
            return "Hãy hoàn thành thiết lập hồ sơ học tập để nhận được gợi ý phù hợp!";
        }

        String learningStyle = profile.getLearningStyle().toLowerCase();
        StringBuilder suggestion = new StringBuilder("Gợi ý học tập dựa trên phong cách ");
        
        if (learningStyle.contains("visual") || learningStyle.contains("hình ảnh")) {
            suggestion.append("hình ảnh: Sử dụng sơ đồ tư duy, biểu đồ, hình ảnh minh họa. Xem video bài giảng và ghi chú bằng màu sắc.");
        } else if (learningStyle.contains("auditory") || learningStyle.contains("thính giác")) {
            suggestion.append("thính giác: Nghe podcast, ghi âm bài giảng, thảo luận nhóm. Đọc to khi học và sử dụng ứng dụng đọc sách nói.");
        } else if (learningStyle.contains("reading") || learningStyle.contains("writing") || learningStyle.contains("đọc") || learningStyle.contains("viết")) {
            suggestion.append("đọc/viết: Ghi chép chi tiết, viết tóm tắt, đọc sách giáo trình. Sử dụng flashcard và viết lại các khái niệm quan trọng.");
        } else if (learningStyle.contains("kinesthetic") || learningStyle.contains("vận động")) {
            suggestion.append("vận động: Học qua thực hành, thí nghiệm, mô hình. Kết hợp học với vận động nhẹ và sử dụng các vật dụng hỗ trợ.");
        } else {
            suggestion.append("học tập: Hãy thử kết hợp nhiều phương pháp học khác nhau để tìm ra cách học hiệu quả nhất cho bạn.");
        }

        // Thêm gợi ý dựa trên personality type nếu có
        if (profile.getPersonalityType() != null) {
            suggestion.append("\n\nPhù hợp với tính cách ").append(profile.getPersonalityType());
            if (profile.getPreferredStudyTime() != null) {
                suggestion.append(": Bạn nên học trong môi trường ").append(profile.getPreferredStudyTime());
            }
            if (profile.getGoal() != null) {
                suggestion.append(" và đặt mục tiêu: ").append(profile.getGoal());
            }
        }

        return suggestion.toString();
    }
    
    // THÊM CODE MỚI: Phương thức tạo thống kê cá nhân hóa
    private java.util.Map<String, Object> createPersonalizedStats(model.UserProfiles profile) {
        java.util.Map<String, Object> stats = new java.util.HashMap<>();
        
        if (profile != null) {
            stats.put("learningStyle", profile.getLearningStyle());
            stats.put("personalityType", profile.getPersonalityType());
            stats.put("preferredStudyTime", profile.getPreferredStudyTime());
            stats.put("focusDuration", profile.getFocusDuration());
            stats.put("goal", profile.getGoal());
            
            // Tính toán số giờ học đề xuất dựa trên focus duration
            if (profile.getFocusDuration() != null) {
                int recommendedDailyHours = (int) Math.ceil(profile.getFocusDuration() / 60.0);
                stats.put("recommendedDailyHours", recommendedDailyHours);
            }
            
            // Đề xuất phân bổ thời gian học
            stats.put("studySchedule", generateStudySchedule(profile));
        }
        
        return stats;
    }
    
    // THÊM CODE MỚI: Phương thức tạo lịch học đề xuất
    private String generateStudySchedule(model.UserProfiles profile) {
        if (profile == null || profile.getPreferredStudyTime() == null) {
            return "Chưa có thông tin để tạo lịch học";
        }
        
        String preferredTime = profile.getPreferredStudyTime().toLowerCase();
        
        if (preferredTime.contains("sáng")) {
            return "Đề xuất: Học vào buổi sáng từ 6h-11h, nghỉ trưa 2 tiếng, ôn tập lại buổi tối 20-21h.";
        } else if (preferredTime.contains("chiều")) {
            return "Đề xuất: Học vào buổi chiều từ 14h-18h, buổi tối từ 19h-22h, sáng dành cho ôn tập nhẹ.";
        } else if (preferredTime.contains("tối")) {
            return "Đề xuất: Học vào buổi tối từ 19h-23h, sáng dành cho đọc lướt, chiều cho thực hành.";
        } else {
            return "Đề xuất: Chia đều thời gian học trong ngày, mỗi buổi 2-3 tiếng, nghỉ giữa giấc 15 phút.";
        }
    }
}