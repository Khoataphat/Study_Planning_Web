/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.*;
import java.time.LocalDateTime;
import model.UserProfiles;
import utils.DBUtil;

/**
 *
 * @author Admin
 */
public class UserProfilesDAO {

    /**
     * Lưu trữ (hoặc cập nhật) thông tin cấu hình người dùng vào bảng user_profiles.
     * Lưu ý: Phương thức này được tối ưu hóa để CHÈN dữ liệu mới.
     * * @param info Đối tượng UserProfiles chứa dữ liệu cần lưu.
     * @throws Exception nếu có lỗi kết nối hoặc truy vấn SQL.
     */
    public void saveSetup(UserProfiles info) throws Exception {
        String sql = "INSERT INTO user_profiles ("
                + "user_id, year_of_study, personality_type, preferred_study_time, "
                + "learning_style, focus_duration, goal, created_at"
                + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?) "
                + "ON DUPLICATE KEY UPDATE "
                + "year_of_study = VALUES(year_of_study), "
                + "personality_type = VALUES(personality_type), "
                + "preferred_study_time = VALUES(preferred_study_time), "
                + "learning_style = VALUES(learning_style), "
                + "focus_duration = VALUES(focus_duration), "
                + "goal = VALUES(goal)";
        
        try (Connection con = DBUtil.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, info.getUserId());
            ps.setInt(2, info.getYearOfStudy() != null ? info.getYearOfStudy() : 1);
            ps.setString(3, info.getPersonalityType());
            ps.setString(4, info.getPreferredStudyTime());
            ps.setString(5, info.getLearningStyle());
            ps.setInt(6, info.getFocusDuration() != null ? info.getFocusDuration() : 0);
            ps.setString(7, info.getGoal());
            
            LocalDateTime now = info.getCreatedAt() != null ? info.getCreatedAt() : LocalDateTime.now();
            ps.setTimestamp(8, Timestamp.valueOf(now)); 
            
            ps.executeUpdate();
        }
    }

    /**
     * Lấy thông tin cấu hình người dùng dựa trên user_id.
     * * @param userId ID của người dùng.
     * @return Đối tượng UserProfiles hoặc null nếu không tìm thấy.
     * @throws Exception nếu có lỗi kết nối hoặc truy vấn SQL.
     */
    public UserProfiles getSetup(int userId) throws Exception {
        String sql = "SELECT * FROM user_profiles WHERE user_id = ?";
        
        try (Connection con = DBUtil.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                UserProfiles info = new UserProfiles();
                // Ánh xạ tất cả các cột từ bảng user_profiles
                info.setProfileId(rs.getInt("profile_id"));
                info.setUserId(rs.getInt("user_id"));
                info.setYearOfStudy(rs.getInt("year_of_study")); 
                info.setPersonalityType(rs.getString("personality_type"));
                info.setPreferredStudyTime(rs.getString("preferred_study_time"));
                info.setLearningStyle(rs.getString("learning_style")); 
                info.setFocusDuration(rs.getInt("focus_duration"));
                info.setGoal(rs.getString("goal"));
                
                Timestamp ts = rs.getTimestamp("created_at");
                if (ts != null) {
                    info.setCreatedAt(ts.toLocalDateTime());
                }
                
                return info;
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi lấy UserProfiles: " + e.getMessage());
            e.printStackTrace();
            throw e; // Ném lại ngoại lệ để lớp dịch vụ/controller xử lý
        }
        return null;
    }
    
    
    //vy
    public void updateSetup(UserProfiles info) throws Exception {
        String sql = "UPDATE user_profiles SET "
                + "year_of_study = ?, personality_type = ?, preferred_study_time = ?, "
                + "learning_style = ?, focus_duration = ?, goal = ? "
                + "WHERE user_id = ?";
        
        try (Connection con = DBUtil.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, info.getYearOfStudy() != null ? info.getYearOfStudy() : 1);
            ps.setString(2, info.getPersonalityType());
            ps.setString(3, info.getPreferredStudyTime());
            ps.setString(4, info.getLearningStyle());
            ps.setInt(5, info.getFocusDuration() != null ? info.getFocusDuration() : 0);
            ps.setString(6, info.getGoal());
            ps.setInt(7, info.getUserId());
            
            if (ps.executeUpdate() == 0) {
                saveSetup(info); // Nếu chưa có thì chèn mới luôn
            }
        }
    }
    
    public boolean profileExists(int userId) throws Exception {
        String sql = "SELECT COUNT(*) FROM user_profiles WHERE user_id = ?";
        try (Connection con = DBUtil.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        }
    }

    public void deleteProfile(int userId) throws Exception {
        String sql = "DELETE FROM user_profiles WHERE user_id = ?";
        try (Connection con = DBUtil.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }
}
