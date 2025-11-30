package com.studyplanning.dao;

import com.studyplanning.model.UserPreference;
import com.studyplanning.utils.DBUtil;

import java.sql.*;

/**
 * DAO class for user_preferences table
 */
public class UserPreferenceDAO {

    /**
     * Get user preference by user ID
     */
    public UserPreference getByUserId(int userId) {
        String sql = "SELECT * FROM user_preferences WHERE user_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractPreferenceFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Insert or update user preference
     */
    public boolean save(UserPreference preference) {
        // Check if preference exists
        UserPreference existing = getByUserId(preference.getUserId());
        
        if (existing == null) {
            return insert(preference) > 0;
        } else {
            preference.setPrefId(existing.getPrefId());
            return update(preference);
        }
    }

    /**
     * Insert new preference
     */
    private int insert(UserPreference preference) {
        String sql = "INSERT INTO user_preferences (user_id, subject_interest, dislike_subject, " +
                    "hobby, stress_level) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            setPreferenceParameters(stmt, preference);

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
     * Update existing preference
     */
    private boolean update(UserPreference preference) {
        String sql = "UPDATE user_preferences SET subject_interest = ?, dislike_subject = ?, " +
                    "hobby = ?, stress_level = ? WHERE pref_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            setPreferenceParameters(stmt, preference);
            stmt.setInt(5, preference.getPrefId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Helper method to set preference parameters
     */
    private void setPreferenceParameters(PreparedStatement stmt, UserPreference preference) throws SQLException {
        stmt.setString(1, preference.getSubjectInterest());
        stmt.setString(2, preference.getDislikeSubject());
        stmt.setString(3, preference.getHobby());
        
        if (preference.getStressLevel() != null) {
            stmt.setInt(4, preference.getStressLevel());
        } else {
            stmt.setNull(4, Types.INTEGER);
        }
    }

    /**
     * Helper method to extract UserPreference from ResultSet
     */
    private UserPreference extractPreferenceFromResultSet(ResultSet rs) throws SQLException {
        UserPreference preference = new UserPreference();
        preference.setPrefId(rs.getInt("pref_id"));
        preference.setUserId(rs.getInt("user_id"));
        preference.setSubjectInterest(rs.getString("subject_interest"));
        preference.setDislikeSubject(rs.getString("dislike_subject"));
        preference.setHobby(rs.getString("hobby"));
        
        int stressLevel = rs.getInt("stress_level");
        preference.setStressLevel(rs.wasNull() ? null : stressLevel);
        
        preference.setCreatedAt(rs.getTimestamp("created_at"));
        return preference;
    }
}
