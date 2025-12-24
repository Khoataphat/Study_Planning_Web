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
import utils.DBUtil;
import utils.DefaultJsonUtil;
@WebServlet("/setting")
public class SettingController extends HttpServlet {
protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        // RẤT QUAN TRỌNG: Đặt Content Type là JSON
        res.setContentType("application/json"); 
        res.setCharacterEncoding("UTF-8");        
        try {
            
            int userId = ((User) req.getSession().getAttribute("user")).getUserId();

            SettingService service = new SettingService(new SettingDAO());
            UserSetting settings = service.load(userId);

            // BỔ SUNG: Xử lý trường hợp cài đặt chưa tồn tại (trả về giá trị mặc định)
    if (settings == null) {
        settings = new UserSetting(); // Tạo đối tượng mới
        // Thiết lập các giá trị mặc định
        settings.setTheme("light"); 
        settings.setLanguage("vi");
        // Bạn có thể không cần lưu vào DB ở đây, chỉ trả về mặc định
    }
            
// 1. Chuyển đối tượng Java thành chuỗi JSON
            String jsonOutput = DefaultJsonUtil.toJson(settings); // SỬ DỤNG .toJson()

            // 2. Ghi JSON vào Response
            res.getWriter().write(jsonOutput);

        } catch(Exception e){
            res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); 
            res.getWriter().write("{\"error\":\"Server error: "+e.getMessage()+"\"}");
        }
    }
}
