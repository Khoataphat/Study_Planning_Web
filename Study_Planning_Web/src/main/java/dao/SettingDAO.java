/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author Admin
 */
import java.sql.*;
import model.UserSetting;

public class SettingDAO {

    private Connection conn;

    public SettingDAO(Connection conn) {
        this.conn = conn;
    }

    public UserSetting getByUserId(int userId) throws Exception {
        String sql = "SELECT * FROM user_settings WHERE user_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);

        System.out.println("DEBUG DAO GET: Th?c thi SELECT cho User ID: " + userId); // Log kiểm tra

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            // THÀNH CÔNG - DỮ LIỆU ĐƯỢC TÌM THẤY
            System.out.println("DEBUG DAO GET: Du lieu cài dat dã ton tai. Theme: " + rs.getString("theme")); // Log thành công

            UserSetting s = new UserSetting();
            s.setUserId(userId);
            // ⭐ SỬA LỖI: ĐỌC DỮ LIỆU TỪ RESULTSET VÀ GÁN VÀO ĐỐI TƯỢNG ⭐
            s.setTheme(rs.getString("theme"));
            s.setLanguage(rs.getString("language"));
            s.setNotificationLevel(rs.getString("notification_level"));
            s.setPreferredStudyTime(rs.getString("preferred_study_time"));
            s.setFocusLevel(rs.getString("focus_level"));
            s.setAiEnabled(rs.getBoolean("ai_enabled"));
            // -------------------------------------------------------------
            return s;
        }

        // THẤT BẠI - KHÔNG TÌM THẤY
        System.out.println("DEBUG DAO GET: Kh?ng tìm th?y d? li?u cài d?t cho User ID: " + userId); // Log thất bại
        return null;
    }

    public void update(UserSetting s) throws Exception {
        String sql = "UPDATE user_settings SET theme=?, language=?, notification_level=?, preferred_study_time=?, focus_level=?, ai_enabled=? WHERE user_id=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, s.getTheme());
        ps.setString(2, s.getLanguage());
        ps.setString(3, s.getNotificationLevel());
        ps.setString(4, s.getPreferredStudyTime());
        ps.setString(5, s.getFocusLevel());
        ps.setBoolean(6, s.isAiEnabled());
        ps.setInt(7, s.getUserId());
        ps.executeUpdate();
    }

    public void insert(UserSetting s) throws Exception {
        // Đảm bảo bạn liệt kê tất cả các cột, bao gồm cả user_id
        String sql = "INSERT INTO user_settings (user_id, theme, language, notification_level, preferred_study_time, focus_level, ai_enabled) VALUES (?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);

        // Cột 1: user_id (Bắt buộc phải set đầu tiên)
        ps.setInt(1, s.getUserId());

        // Các cột còn lại (Bắt đầu từ 2)
        ps.setString(2, s.getTheme());
        ps.setString(3, s.getLanguage());
        ps.setString(4, s.getNotificationLevel());
        ps.setString(5, s.getPreferredStudyTime());
        ps.setString(6, s.getFocusLevel());
        ps.setBoolean(7, s.isAiEnabled());

        ps.executeUpdate();
    }
}
