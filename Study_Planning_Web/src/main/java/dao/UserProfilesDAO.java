/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.UserProfiles;
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
    /**
     * Lấy profile mới nhất của user
     */
    public UserProfiles getLatestUserProfile(int userId) {
        String sql = "SELECT * FROM user_profiles WHERE user_id = ? ORDER BY created_at DESC LIMIT 1";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Thêm profile mới
     */
    public boolean insert(UserProfiles profile) {
        String sql =
            "INSERT INTO user_profiles (" +
            "user_id, full_name, description, learning_style, work_style, hobbies, " +
            "preferred_study_time, year_of_study, personality_type, focus_duration, " +
            "goal, study_method_visual, study_method_auditory, study_method_reading, " +
            "study_method_practice, productive_time, group_study_preference, created_at, updated_at" +
            ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            int index = 1;
            stmt.setInt(index++, profile.getUserId());
            stmt.setString(index++, profile.getFullName());
            stmt.setString(index++, profile.getDescription());
            stmt.setString(index++, profile.getLearningStyle());
            stmt.setString(index++, profile.getWorkStyle());
            stmt.setString(index++, profile.getHobbies());
            stmt.setString(index++, profile.getPreferredStudyTime());
            stmt.setObject(index++, profile.getYearOfStudy());
            stmt.setString(index++, profile.getPersonalityType());
            stmt.setObject(index++, profile.getFocusDuration());
            stmt.setString(index++, profile.getGoal());
            
            // Các field mới cho form khám phá phương pháp học
            stmt.setString(index++, profile.getStudyMethodVisual());
            stmt.setString(index++, profile.getStudyMethodAuditory());
            stmt.setString(index++, profile.getStudyMethodReading());
            stmt.setString(index++, profile.getStudyMethodPractice());
            stmt.setString(index++, profile.getProductiveTime());
            stmt.setObject(index++, profile.getGroupStudyPreference());
            
            stmt.setTimestamp(index++, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setTimestamp(index, Timestamp.valueOf(LocalDateTime.now()));

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update profile
     */
    public boolean update(UserProfiles profile) {
        String sql = 
            "UPDATE user_profiles SET " +
            "full_name = ?, description = ?, learning_style = ?, work_style = ?, " +
            "hobbies = ?, preferred_study_time = ?, year_of_study = ?, " +
            "personality_type = ?, focus_duration = ?, goal = ?, " +
            "study_method_visual = ?, study_method_auditory = ?, study_method_reading = ?, " +
            "study_method_practice = ?, productive_time = ?, group_study_preference = ?, " +
            "updated_at = ? " +
            "WHERE user_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            int index = 1;
            stmt.setString(index++, profile.getFullName());
            stmt.setString(index++, profile.getDescription());
            stmt.setString(index++, profile.getLearningStyle());
            stmt.setString(index++, profile.getWorkStyle());
            stmt.setString(index++, profile.getHobbies());
            stmt.setString(index++, profile.getPreferredStudyTime());
            stmt.setObject(index++, profile.getYearOfStudy());
            stmt.setString(index++, profile.getPersonalityType());
            stmt.setObject(index++, profile.getFocusDuration());
            stmt.setString(index++, profile.getGoal());
            
            // Các field mới cho form khám phá phương pháp học
            stmt.setString(index++, profile.getStudyMethodVisual());
            stmt.setString(index++, profile.getStudyMethodAuditory());
            stmt.setString(index++, profile.getStudyMethodReading());
            stmt.setString(index++, profile.getStudyMethodPractice());
            stmt.setString(index++, profile.getProductiveTime());
            stmt.setObject(index++, profile.getGroupStudyPreference());
            
            stmt.setTimestamp(index++, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(index, profile.getUserId());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Map ResultSet → Object
     */
    private UserProfiles mapRow(ResultSet rs) throws SQLException {
        UserProfiles up = new UserProfiles();

        // Các field cơ bản
        up.setProfileId(rs.getInt("profile_id"));
        up.setUserId(rs.getInt("user_id"));
        up.setFullName(rs.getString("full_name"));
        up.setDescription(rs.getString("description"));
        up.setLearningStyle(rs.getString("learning_style"));
        up.setWorkStyle(rs.getString("work_style"));
        up.setHobbies(rs.getString("hobbies"));
        up.setPreferredStudyTime(rs.getString("preferred_study_time"));

        int year = rs.getInt("year_of_study");
        up.setYearOfStudy(rs.wasNull() ? null : year);

        up.setPersonalityType(rs.getString("personality_type"));

        int focus = rs.getInt("focus_duration");
        up.setFocusDuration(rs.wasNull() ? null : focus);

        up.setGoal(rs.getString("goal"));

        // Các field mới cho form khám phá phương pháp học
        up.setStudyMethodVisual(rs.getString("study_method_visual"));
        up.setStudyMethodAuditory(rs.getString("study_method_auditory"));
        up.setStudyMethodReading(rs.getString("study_method_reading"));
        up.setStudyMethodPractice(rs.getString("study_method_practice"));
        up.setProductiveTime(rs.getString("productive_time"));
        
        int groupPref = rs.getInt("group_study_preference");
        up.setGroupStudyPreference(rs.wasNull() ? null : groupPref);

        // Timestamps
        Timestamp c = rs.getTimestamp("created_at");
        if (c != null) up.setCreatedAt(c.toLocalDateTime());

        Timestamp u = rs.getTimestamp("updated_at");
        if (u != null) up.setUpdatedAt(u.toLocalDateTime());

        return up;
    }

    /**
     * Kiểm tra xem user đã hoàn thành form khám phá phương pháp học chưa
     */
    public boolean hasCompletedLearningStyleSetup(int userId) {
        String sql = "SELECT study_method_visual FROM user_profiles WHERE user_id = ? ORDER BY created_at DESC LIMIT 1";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String visualMethod = rs.getString("study_method_visual");
                // Nếu có dữ liệu trong một trong các field mới, coi như đã hoàn thành
                return visualMethod != null && !visualMethod.trim().isEmpty();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy thông tin phương pháp học để hiển thị trên dashboard
     */
    public UserProfiles getLearningStyleInfo(int userId) {
        String sql = "SELECT study_method_visual, study_method_auditory, study_method_reading, " +
                    "study_method_practice, productive_time, group_study_preference " +
                    "FROM user_profiles WHERE user_id = ? ORDER BY created_at DESC LIMIT 1";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                UserProfiles up = new UserProfiles();
                
                up.setStudyMethodVisual(rs.getString("study_method_visual"));
                up.setStudyMethodAuditory(rs.getString("study_method_auditory"));
                up.setStudyMethodReading(rs.getString("study_method_reading"));
                up.setStudyMethodPractice(rs.getString("study_method_practice"));
                up.setProductiveTime(rs.getString("productive_time"));
                
                int groupPref = rs.getInt("group_study_preference");
                up.setGroupStudyPreference(rs.wasNull() ? null : groupPref);

                return up;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean createUserProfileNew(UserProfiles profile) throws SQLException {
        String sql = "INSERT INTO user_profiles (user_id, full_name, description, " +
                     "learning_style, work_style, interests, productive_time, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, profile.getUserId());
            pstmt.setString(2, profile.getFullName());
            pstmt.setString(3, profile.getDescription());
            pstmt.setString(4, profile.getLearningStyle());
            pstmt.setString(5, profile.getWorkStyle());
            pstmt.setString(6, profile.getInterests());
            pstmt.setString(7, profile.getProductiveTime());
            pstmt.setTimestamp(8, Timestamp.valueOf(profile.getCreatedAt()));
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Cập nhật từ form trắc nghiệm (Khám phá phương pháp học) - phiên bản mới
     */
    public boolean updateLearningQuizNew(int userId, String studyMethodVisual,
                                        String studyMethodAuditory, String studyMethodReading,
                                        String studyMethodPractice, String productiveTime,
                                        int groupStudyPreference) throws SQLException {
        String sql = "UPDATE user_profiles SET " +
                     "study_method_visual = ?, study_method_auditory = ?, " +
                     "study_method_reading = ?, study_method_practice = ?, " +
                     "productive_time = ?, group_study_preference = ?, " +
                     "updated_at = NOW() WHERE user_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, studyMethodVisual != null ? studyMethodVisual : "");
            pstmt.setString(2, studyMethodAuditory != null ? studyMethodAuditory : "");
            pstmt.setString(3, studyMethodReading != null ? studyMethodReading : "");
            pstmt.setString(4, studyMethodPractice != null ? studyMethodPractice : "");
            pstmt.setString(5, productiveTime);
            pstmt.setInt(6, groupStudyPreference);
            pstmt.setInt(7, userId);
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Lấy thông tin hồ sơ (phiên bản đầy đủ từ cả 2 form) - phiên bản mới
     */
    public UserProfiles getProfileByUserIdNew(int userId) throws SQLException {
        String sql = "SELECT * FROM user_profiles WHERE user_id = ? ORDER BY created_at DESC LIMIT 1";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    UserProfiles profile = new UserProfiles();
                    
                    // Các field cơ bản từ form đầu
                    profile.setProfileId(rs.getInt("profile_id"));
                    profile.setUserId(rs.getInt("user_id"));
                    profile.setFullName(rs.getString("full_name"));
                    profile.setDescription(rs.getString("description"));
                    profile.setLearningStyle(rs.getString("learning_style"));
                    profile.setWorkStyle(rs.getString("work_style"));
                    profile.setInterests(rs.getString("interests"));
                    profile.setProductiveTime(rs.getString("productive_time"));
                    
                    // Các field từ form trắc nghiệm
                    profile.setStudyMethodVisual(rs.getString("study_method_visual"));
                    profile.setStudyMethodAuditory(rs.getString("study_method_auditory"));
                    profile.setStudyMethodReading(rs.getString("study_method_reading"));
                    profile.setStudyMethodPractice(rs.getString("study_method_practice"));
                    
                    int groupPref = rs.getInt("group_study_preference");
                    profile.setGroupStudyPreference(rs.wasNull() ? null : groupPref);
                    
                    // Timestamps
                    Timestamp c = rs.getTimestamp("created_at");
                    if (c != null) profile.setCreatedAt(c.toLocalDateTime());
                    
                    Timestamp u = rs.getTimestamp("updated_at");
                    if (u != null) profile.setUpdatedAt(u.toLocalDateTime());
                    
                    return profile;
                }
            }
        }
        return null;
    }
    
    /**
     * Update profile (phiên bản đầy đủ) - phiên bản mới
     */
    public boolean updateNew(UserProfiles profile) throws SQLException {
        String sql = 
            "UPDATE user_profiles SET " +
            "full_name = ?, description = ?, learning_style = ?, work_style = ?, " +
            "interests = ?, productive_time = ?, " +
            "study_method_visual = ?, study_method_auditory = ?, study_method_reading = ?, " +
            "study_method_practice = ?, group_study_preference = ?, " +
            "updated_at = ? " +
            "WHERE user_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            int index = 1;
            stmt.setString(index++, profile.getFullName());
            stmt.setString(index++, profile.getDescription());
            stmt.setString(index++, profile.getLearningStyle());
            stmt.setString(index++, profile.getWorkStyle());
            stmt.setString(index++, profile.getInterests());
            stmt.setString(index++, profile.getProductiveTime());
            
            // Các field từ form trắc nghiệm
            stmt.setString(index++, profile.getStudyMethodVisual());
            stmt.setString(index++, profile.getStudyMethodAuditory());
            stmt.setString(index++, profile.getStudyMethodReading());
            stmt.setString(index++, profile.getStudyMethodPractice());
            stmt.setObject(index++, profile.getGroupStudyPreference());
            
            stmt.setTimestamp(index++, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(index, profile.getUserId());

            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean createUserProfile(UserProfiles profile) throws SQLException {
        String sql = "INSERT INTO user_profiles (user_id, full_name, description, " +
                     "learning_style, work_style, interests, productive_time, created-at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, profile.getUserId());
            pstmt.setString(2, profile.getFullName());
            pstmt.setString(3, profile.getDescription());
            pstmt.setString(4, profile.getLearningStyle());
            pstmt.setString(5, profile.getWorkStyle());
            pstmt.setString(6, profile.getInterests());
            pstmt.setString(7, profile.getProductiveTime());
            
            if (profile.getCreatedAt() != null) {
                pstmt.setTimestamp(8, Timestamp.valueOf(profile.getCreatedAt()));
            } else {
                pstmt.setTimestamp(8, Timestamp.valueOf(LocalDateTime.now()));
            }
            
            return pstmt.executeUpdate() > 0;
        }
    }

    public UserProfiles getProfileByUserId(int userId) {
        try {
            return getProfileByUserIdNew(userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
