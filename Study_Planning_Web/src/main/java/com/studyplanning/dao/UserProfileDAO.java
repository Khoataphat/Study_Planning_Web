package com.studyplanning.dao;

import com.studyplanning.model.UserProfile;
import com.studyplanning.utils.DBUtil;

import java.sql.*;

/**
 * DAO class for user_profiles table
 */
public class UserProfileDAO {

    /**
     * Get user profile by user ID
     */
    public UserProfile getByUserId(int userId) {
        String sql = "SELECT * FROM user_profiles WHERE user_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractProfileFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Insert or update user profile
     */
    public boolean save(UserProfile profile) {
        // Check if profile exists
        UserProfile existing = getByUserId(profile.getUserId());
        
        if (existing == null) {
            return insert(profile) > 0;
        } else {
            profile.setProfileId(existing.getProfileId());
            return update(profile);
        }
    }

    /**
     * Insert new profile
     */
    private int insert(UserProfile profile) {
        String sql = "INSERT INTO user_profiles (user_id, year_of_study, personality_type, " +
                    "preferred_study_time, learning_style, focus_duration, goal) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            setProfileParameters(stmt, profile);

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return -1;
    }

    /**
     * Update existing profile
     */
    private boolean update(UserProfile profile) {
        String sql = "UPDATE user_profiles SET year_of_study = ?, personality_type = ?, " +
                    "preferred_study_time = ?, learning_style = ?, focus_duration = ?, goal = ? " +
                    "WHERE profile_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            setProfileParameters(stmt, profile);
            stmt.setInt(7, profile.getProfileId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Helper method to set profile parameters
     */
    private void setProfileParameters(PreparedStatement stmt, UserProfile profile) throws SQLException {
        if (profile.getYearOfStudy() != null) {
            stmt.setInt(1, profile.getYearOfStudy());
        } else {
            stmt.setNull(1, Types.INTEGER);
        }
        stmt.setString(2, profile.getPersonalityType());
        stmt.setString(3, profile.getPreferredStudyTime());
        stmt.setString(4, profile.getLearningStyle());
        stmt.setInt(5, profile.getFocusDuration());
        stmt.setString(6, profile.getGoal());
    }

    /**
     * Helper method to extract UserProfile from ResultSet
     */
    private UserProfile extractProfileFromResultSet(ResultSet rs) throws SQLException {
        UserProfile profile = new UserProfile();
        profile.setProfileId(rs.getInt("profile_id"));
        profile.setUserId(rs.getInt("user_id"));
        
        int yearOfStudy = rs.getInt("year_of_study");
        profile.setYearOfStudy(rs.wasNull() ? null : yearOfStudy);
        
        profile.setPersonalityType(rs.getString("personality_type"));
        profile.setPreferredStudyTime(rs.getString("preferred_study_time"));
        profile.setLearningStyle(rs.getString("learning_style"));
        profile.setFocusDuration(rs.getInt("focus_duration"));
        profile.setGoal(rs.getString("goal"));
        profile.setCreatedAt(rs.getTimestamp("created_at"));
        return profile;
    }
}
