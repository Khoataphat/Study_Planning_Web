/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author Admin
 */
import model.MBTIResult;
import utils.DBUtil;
import java.sql.*;
import java.util.Date;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MBTIResultDAO {
    private static final Logger logger = LoggerFactory.getLogger(MBTIResultDAO.class);
    
    public boolean saveResult(int userId, MBTIResult result) {
        String sql = "INSERT INTO user_mbti_profile (user_id, mbti_type, dimension_e_i, " +
                     "dimension_s_n, dimension_t_f, dimension_j_p, description, completed_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE " +
                     "mbti_type = VALUES(mbti_type), " +
                     "dimension_e_i = VALUES(dimension_e_i), " +
                     "dimension_s_n = VALUES(dimension_s_n), " +
                     "dimension_t_f = VALUES(dimension_t_f), " +
                     "dimension_j_p = VALUES(dimension_j_p), " +
                     "description = VALUES(description), " +
                     "completed_at = VALUES(completed_at)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, result.getMbtiType());
            stmt.setString(3, result.getDimensionEI());
            stmt.setString(4, result.getDimensionSN());
            stmt.setString(5, result.getDimensionTF());
            stmt.setString(6, result.getDimensionJP());
            stmt.setString(7, result.getDescription());
            stmt.setTimestamp(8, new Timestamp(new Date().getTime()));
            
            int rowsAffected = stmt.executeUpdate();
            logger.info("Saved MBTI result for user {}: {}", userId, result.getMbtiType());
            
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.error("Error saving MBTI result for user: " + userId, e);
            return false;
        }
    }
    
    public MBTIResult getResultByUserId(int userId) {
        String sql = "SELECT * FROM user_mbti_profile WHERE user_id = ?";
        MBTIResult result = null;
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    result = new MBTIResult();
                    result.setId(rs.getInt("id"));
                    result.setUserId(rs.getInt("user_id"));
                    result.setMbtiType(rs.getString("mbti_type"));
                    result.setDimensionEI(rs.getString("dimension_e_i"));
                    result.setDimensionSN(rs.getString("dimension_s_n"));
                    result.setDimensionTF(rs.getString("dimension_t_f"));
                    result.setDimensionJP(rs.getString("dimension_j_p"));
                    result.setDescription(rs.getString("description"));
                    result.setCompletedAt(rs.getTimestamp("completed_at"));
                }
            }
            
        } catch (SQLException e) {
            logger.error("Error retrieving MBTI result for user: " + userId, e);
        }
        
        return result;
    }
    
    public boolean hasCompletedQuiz(int userId) {
        String sql = "SELECT COUNT(*) FROM user_mbti_profile WHERE user_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
            
        } catch (SQLException e) {
            logger.error("Error checking MBTI completion for user: " + userId, e);
        }
        
        return false;
    }
}
