/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package filters;

/**
 *
 * @author Admin
 */
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;
import service.SettingService;
import utils.CookieUtils;

// Ánh xạ tới tất cả các URL cần xử lý Theme (ngoại trừ các file tĩnh như CSS, JS)
@WebFilter("/*")
public class ThemeFilter implements Filter {

// Khai báo biến, nhưng KHÔNG khởi tạo ngay lập tức
    private SettingService service;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        // ⭐⭐ KHỞI TẠO LẦN ĐẦU TIÊN (nếu chưa được khởi tạo) ⭐⭐
        if (service == null) {
            service = new SettingService();
        }

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        // Bỏ qua các đường dẫn tài nguyên tĩnh (tùy chọn, nhưng nên có)
        String path = req.getRequestURI();
        if (path.endsWith(".css") || path.endsWith(".js") || path.endsWith(".png") || path.endsWith(".jpg")) {
            chain.doFilter(request, response);
            return;
        }

        // --- Bắt đầu Logic Load Theme ---
        String theme = CookieUtils.getCookie(req, "theme");
        User user = (User) req.getSession().getAttribute("user");

        // 1. Nếu Cookie không có và User đã Login
        if (theme == null && user != null) {
            try {
                // 2. Đọc từ DB (Lấy theme đã lưu vĩnh viễn)
                String dbTheme = service.getTheme(user.getUserId());
                if (dbTheme != null) {
                    theme = dbTheme;
                }
            } catch (Exception e) {
                System.err.println("Lỗi khi đọc theme từ DB: " + e.getMessage());
                // Không cần in stack trace ra console quá nhiều, chỉ cần log lỗi
                theme = "light"; // Mặc định nếu lỗi DB
            }
        }

        // 3. Nếu vẫn là null, dùng mặc định
        if (theme == null) {
            theme = "light";
        }

//        // LƯU Ý QUAN TRỌNG: Cần thiết lập lại Cookie nếu lấy từ DB hoặc dùng mặc định
//        // Để lần sau trình duyệt gửi cookie lên luôn.
//        if (CookieUtils.getCookie(req, "theme") == null) {
//            final int ONE_YEAR = 365;
//            // Giả sử CookieUtils.setCookie tồn tại
//            // Đây là bước quan trọng để tránh truy vấn DB cho mỗi request
//            // nếu theme được lấy từ DB hoặc là giá trị mặc định.
//            // 
//            CookieUtils.setCookie(resp, "theme", theme, ONE_YEAR); 
//        }
// Logic xác định theme đã chạy xong. Biến 'theme' hiện chứa giá trị đúng nhất.
// Ta luôn phải đảm bảo giá trị này được ghi vào Cookie để ưu tiên cho lần sau.
// Lấy giá trị cookie ban đầu để so sánh (tránh set cookie thừa thãi)
        String originalCookieTheme = CookieUtils.getCookie(req, "theme");

// Nếu theme được xác định khác với giá trị cookie cũ, hoặc cookie ban đầu không tồn tại, thì set lại.
        if (!theme.equals(originalCookieTheme)) { // Hoặc đơn giản là luôn set lại: final int ONE_YEAR = 365; CookieUtils.setCookie(resp, "theme", theme, ONE_YEAR);
            final int ONE_YEAR = 365;
            CookieUtils.setCookie(resp, "theme", theme, ONE_YEAR);
        }

        // Lưu theme cuối cùng vào request để JSP sử dụng
        req.setAttribute("theme", theme);

        // Chuyển tiếp yêu cầu đến Controller hoặc JSP tiếp theo
        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void destroy() {
    }
}
