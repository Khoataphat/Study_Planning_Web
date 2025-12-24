/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

/**
 *
 * @author Admin
 */
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CookieUtils {

    /**
     * Tạo và thêm cookie vào response.
     * @param resp HttpServletResponse.
     * @param name Tên cookie.
     * @param value Giá trị cookie.
     * @param days Thời gian sống của cookie (theo ngày).
     */
    public static void setCookie(HttpServletResponse resp, String name, String value, int days) {
        Cookie c = new Cookie(name, value);
        c.setPath("/"); // Áp dụng cho toàn bộ context path
        c.setMaxAge(days * 24 * 60 * 60); // Đổi sang giây
        resp.addCookie(c);
    }

/**
     * Lấy giá trị của cookie từ HttpServletRequest.
     * @param req Đối tượng HttpServletRequest.
     * @param name Tên của cookie cần tìm.
     * @return Giá trị của cookie (String) hoặc null nếu không tìm thấy.
     */
    public static String getCookie(HttpServletRequest req, String name) {
        
        // 1. Lấy mảng tất cả các Cookie từ Request
        Cookie[] cookies = req.getCookies();
        
        // 2. Kiểm tra xem có Cookie nào tồn tại không
        if (cookies == null) {
            return null;
        }

        // 3. Lặp qua mảng Cookie để tìm tên trùng khớp
        for (Cookie c : cookies) {
            // Sử dụng .equals() để so sánh tên (String)
            if (c.getName().equals(name)) {
                // Trả về giá trị của Cookie nếu tìm thấy
                return c.getValue();
            }
        }
        
        // 4. Trả về null nếu không tìm thấy sau khi duyệt hết mảng
        return null;
    }
}