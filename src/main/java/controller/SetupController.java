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
            UserProfiles profile = new UserProfiles();
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

            // THÊM CODE: Validate dữ liệu trước khi lưu
            if (goal == null || goal.trim().isEmpty() ||
                learningStyle == null || learningStyle.trim().isEmpty() ||
                preferredStudyTime == null || preferredStudyTime.trim().isEmpty()) {
                
                req.setAttribute("errorMessage", "Vui lòng chọn đầy đủ các tùy chọn");
                req.getRequestDispatcher("/views/basic-setup-save.jsp").forward(req, resp);
                return;
            }

            // 3. Gọi Service để lưu DB và cập nhật trạng thái
            userProfilesService.saveSetup(profile);

            // 4. Cập nhật flag first_login trong session
            // Giả sử service.saveSetup() đã gọi userDAO.markSetupDone(user.getId())
            // Giả sử field để kiểm tra first login trong model User là IsFirstLogin
            user.setisFirstLogin(0);
            session.setAttribute("user", user);

            // THÊM CODE: Lưu thông tin profile vào session để sử dụng sau này
            session.setAttribute("userProfile", profile);
            
            // THÊM CODE: Đánh dấu đã hoàn thành bước 1
            session.setAttribute("basicSetupStep1Completed", true);

            // THÊM CODE: Kiểm tra xem user đã hoàn thành cả 2 bước chưa
            if (profile.getFocusDuration() != null && profile.getGoal() != null) {
                // Đã hoàn thành cả 2 bước, chuyển đến dashboard
                resp.sendRedirect(req.getContextPath() + "/dashboard");
            } else {
                // Chỉ hoàn thành bước 1, chuyển đến bước 2
                resp.sendRedirect(req.getContextPath() + "/learning-style-setup");
            }

        } catch (Exception e) {
            System.err.println("Lỗi khi xử lý setup cơ bản: " + e.getMessage());
            e.printStackTrace();
            // Gửi lỗi về trang lỗi hoặc hiển thị thông báo
            req.setAttribute("errorMessage", "Đã xảy ra lỗi khi lưu cấu hình: " + e.getMessage());
            req.getRequestDispatcher("/views/basic-setup-save.jsp").forward(req, resp);
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

        // THÊM CODE: Kiểm tra xem user đã hoàn thành setup chưa
        if (user.getisFirstLogin() == 0) {
            // Nếu đã hoàn thành setup, kiểm tra xem đã có profile chưa
            try {
                UserProfiles profile = userProfilesService.getProfile(user.getUserId());
                if (profile != null) {
                    // Đã có profile, chuyển đến dashboard
                    resp.sendRedirect(req.getContextPath() + "/dashboard");
                    return;
                }
            } catch (Exception e) {
                // Nếu có lỗi, tiếp tục hiển thị form setup
                e.printStackTrace();
            }
        }

        // THÊM CODE: Kiểm tra xem đã hoàn thành bước 1 chưa
        Boolean step1Completed = (Boolean) session.getAttribute("basicSetupStep1Completed");
        if (Boolean.TRUE.equals(step1Completed)) {
            // Đã hoàn thành bước 1, chuyển đến bước 2
            resp.sendRedirect(req.getContextPath() + "/views/learning-style-setup.jsp");
            return;
        }

        // 2. Chuyển tiếp (Forward) request đến trang JSP/HTML chứa form setup
        // ⚠️ ĐẢM BẢO ĐƯỜNG DẪN NÀY CHÍNH XÁC ĐẾN FILE SETUP CỦA BẠN
        req.getRequestDispatcher("/views/basic-setup-save.jsp").forward(req, resp);
    }
    
    // THÊM CODE: Phương thức để tạo gợi ý học tập dựa trên learning style
    private String generateStudySuggestion(UserProfiles profile) {
        if (profile == null || profile.getLearningStyle() == null) {
            return "Hãy hoàn thành thiết lập hồ sơ học tập để nhận được gợi ý phù hợp!";
        }

        String learningStyle = profile.getLearningStyle().toLowerCase();
        StringBuilder suggestion = new StringBuilder("Dựa trên phong cách học tập của bạn: ");
        
        if (learningStyle.contains("visual") || learningStyle.contains("hình ảnh")) {
            suggestion.append("Bạn học tốt nhất qua hình ảnh và biểu đồ. Hãy sử dụng sơ đồ tư duy, xem video bài giảng và ghi chú bằng màu sắc.");
        } else if (learningStyle.contains("auditory") || learningStyle.contains("thính giác")) {
            suggestion.append("Bạn học tốt nhất qua âm thanh. Hãy nghe podcast, ghi âm bài giảng, thảo luận nhóm và đọc to khi học.");
        } else if (learningStyle.contains("kinesthetic") || learningStyle.contains("vận động")) {
            suggestion.append("Bạn học tốt nhất qua vận động và thực hành. Hãy học qua thí nghiệm, mô hình và kết hợp học với vận động nhẹ.");
        } else {
            suggestion.append("Hãy thử nhiều phương pháp học khác nhau để tìm ra cách học hiệu quả nhất cho bạn.");
        }

        // Thêm gợi ý dựa trên preferred study time
        if (profile.getPreferredStudyTime() != null) {
            String preferredTime = profile.getPreferredStudyTime().toLowerCase();
            if (preferredTime.contains("morning") || preferredTime.contains("sáng")) {
                suggestion.append(" Với năng lượng buổi sáng, hãy học các môn khó vào sáng sớm.");
            } else if (preferredTime.contains("evening") || preferredTime.contains("tối")) {
                suggestion.append(" Với năng lượng buổi tối, hãy dành thời gian tối để ôn tập và thực hành.");
            } else if (preferredTime.contains("night") || preferredTime.contains("đêm")) {
                suggestion.append(" Với thói quen học đêm, hãy đảm bảo đủ ánh sáng và nghỉ ngơi hợp lý.");
            }
        }

        return suggestion.toString();
    }
}