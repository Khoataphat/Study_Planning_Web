/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

/**
 *
 * @author Admin
 */
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import service.SettingService;
import dao.SettingDAO;
import jakarta.servlet.annotation.WebServlet;
import model.User;
import model.UserSetting;
import utils.CookieUtils;
import utils.DBUtil;
import utils.DefaultJsonUtil;
@WebServlet("/update-settings")
public class UpdateSettingController extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        
        // Cấu hình phản hồi (mặc định cho JSON)
        res.setContentType("application/json");
        res.setCharacterEncoding("UTF-8");
        
        try {
            // --- 1. KIỂM TRA SESSION VÀ USER ID ---
            User user = (User) req.getSession().getAttribute("user");
            
            // Nếu người dùng không tồn tại trong Session
            if (user == null) {
                System.out.println("LỖI UPDATE SETTING: User không tồn tại trong Session!");
                res.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // HTTP 401
                res.getWriter().write("{\"error\":\"Phiên người dùng không hợp lệ. Vui lòng đăng nhập lại.\"}");
                return;
            }
            int userId = user.getUserId();
            
            // --- 2. ĐỌC VÀ CHUYỂN ĐỔI JSON ---
            String json = req.getReader().lines().reduce("", (a, b) -> a + b);
            System.out.println("DEBUG UPDATE SETTING: JSON nhận được: " + json);
            
            if (json.isEmpty()) {
                throw new Exception("Không nhận được dữ liệu JSON từ request body.");
            }

            UserSetting data = DefaultJsonUtil.fromJson(json, UserSetting.class);
            
            // Kiểm tra xem đối tượng có được tạo thành công không
            if (data == null) {
                throw new Exception("Không thể chuyển đổi JSON thành UserSetting. Vui lòng kiểm tra cấu trúc JSON/Class.");
            }
            
            System.out.println("DEBUG UPDATE SETTING: UserSetting được tạo: " + data.getTheme() + ", " + data.getLanguage());
            
            // --- 3. GÁN USER ID VÀ LƯU DỮ LIỆU ---
            data.setUserId(userId);

            SettingService service = new SettingService(new SettingDAO());
            service.save(data); // Hàm này có trách nhiệm INSERT/UPDATE vào DB
            
            // ⭐⭐ BỔ SUNG: GHI LẠI COOKIE MỚI VÀO HTTP RESPONSE ⭐⭐
            final int ONE_YEAR = 365; // Đảm bảo bạn có hằng số này hoặc giá trị tương đương
            
            // Lấy giá trị theme mới đã lưu thành công
            String newTheme = data.getTheme(); 

            // Cập nhật cookie để trình duyệt sử dụng ngay lập tức
            CookieUtils.setCookie(res, "theme", newTheme, ONE_YEAR);
            // ⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐⭐
            
            // --- 4. PHẢN HỒI THÀNH CÔNG ---
            res.getWriter().write("{\"status\":\"ok\"}");

        } catch (Exception e) {
            // --- XỬ LÝ LỖI CHUNG ---
            System.out.println("LỖI UPDATE SETTING: Đã xảy ra lỗi trong quá trình xử lý.");
            e.printStackTrace(); // In lỗi đầy đủ ra console server
            
            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // HTTP 500
            // Trả về thông báo lỗi cho client (có thể rút gọn để tránh rò rỉ thông tin)
            res.getWriter().write("{\"error\":\"Lỗi server khi lưu cài đặt: "+e.getMessage()+"\"}");
        }
    }
}
