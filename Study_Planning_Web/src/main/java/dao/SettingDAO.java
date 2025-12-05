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

    public SettingDAO(Connection conn){
        this.conn = conn;
    }

    public UserSetting getByUserId(int userId) throws Exception {
        String sql = "SELECT * FROM user_settings WHERE user_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        if(rs.next()){
            UserSetting s = new UserSetting();
            s.setUserId(userId);
            s.setTheme(rs.getString("theme"));
            s.setLanguage(rs.getString("language"));
            s.setNotificationLevel(rs.getString("notification_level"));
            s.setPreferredStudyTime(rs.getString("preferred_study_time"));
            s.setFocusLevel(rs.getString("focus_level"));
            s.setAiEnabled(rs.getBoolean("ai_enabled"));
            return s;
        }
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
}
