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
        // Cập nhật tên bảng thành 'user_profiles' và thêm các cột còn thiếu
        String sql = "INSERT INTO user_profiles ("
                + "user_id, year_of_study, personality_type, preferred_study_time, "
                + "learning_style, focus_duration, goal, created_at"
                + ") VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection con = DBUtil.getConnection(); 
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            // Đảm bảo rằng bạn đã có các giá trị mặc định cho các trường chưa được cung cấp từ form
            
            ps.setInt(1, info.getUserId());
            
            // Sử dụng các Getter mới (year_of_study, learning_style, preferred_study_time, goal)
            // Cần xử lý giá trị null/mặc định nếu các trường này không được lấy từ form
            ps.setInt(2, info.getYearOfStudy() != null ? info.getYearOfStudy() : 1); // Ví dụ: sử dụng 0 nếu null
            ps.setString(3, info.getPersonalityType());
            ps.setString(4, info.getPreferredStudyTime());
            ps.setString(5, info.getLearningStyle());
            
            // Giả sử focusDuration được tính toán hoặc là giá trị mặc định
            ps.setInt(6, info.getFocusDuration() != null ? info.getFocusDuration() : 0); // Ví dụ: sử dụng 0 nếu null
            ps.setString(7, info.getGoal());
            
            // Xử lý created_at
            LocalDateTime now = info.getCreatedAt() != null ? info.getCreatedAt() : LocalDateTime.now();
            ps.setTimestamp(8, Timestamp.valueOf(now)); 
            
            ps.executeUpdate();
            
        } catch (Exception e) {
            System.err.println("Lỗi khi lưu UserProfiles: " + e.getMessage());
            e.printStackTrace();
            throw e; // Ném lại ngoại lệ để lớp dịch vụ/controller xử lý
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
}
