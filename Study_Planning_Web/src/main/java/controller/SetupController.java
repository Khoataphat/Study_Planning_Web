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

            // 3. Gọi Service để lưu DB và cập nhật trạng thái
            userProfilesService.saveSetup(profile);

            // 4. Cập nhật flag first_login trong session
            // Giả sử service.saveSetup() đã gọi userDAO.markSetupDone(user.getId())
            // Giả sử field để kiểm tra first login trong model User là IsFirstLogin
            user.setisFirstLogin(0);
            session.setAttribute("user", user);

            // 5. Chuyển hướng người dùng đến Dashboard
            resp.sendRedirect(req.getContextPath() + "/views/dashboard.jsp");
            // --AnNX-- nên đổi sang thành dashboard.jsp nha

        } catch (Exception e) {
            System.err.println("Lỗi khi xử lý setup cơ bản: " + e.getMessage());
            e.printStackTrace();
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
}
