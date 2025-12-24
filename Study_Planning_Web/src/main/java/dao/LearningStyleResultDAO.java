/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author Admin
 */
import model.LearningStyleResult;
import utils.DBUtil;
import java.util.Date;
import java.sql.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LearningStyleResultDAO {
    private static final Logger logger = LoggerFactory.getLogger(LearningStyleResultDAO.class);
    
    public boolean saveResult(LearningStyleResult result) {
        String sql = "INSERT INTO user_learning_style (user_id, visual_percentage, " +
                     "auditory_percentage, kinesthetic_percentage, primary_style, completed_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE " +
                     "visual_percentage = VALUES(visual_percentage), " +
                     "auditory_percentage = VALUES(auditory_percentage), " +
                     "kinesthetic_percentage = VALUES(kinesthetic_percentage), " +
                     "primary_style = VALUES(primary_style), " +
                     "completed_at = VALUES(completed_at)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, result.getUserId());
            stmt.setInt(2, result.getVisualPercentage());
            stmt.setInt(3, result.getAuditoryPercentage());
            stmt.setInt(4, result.getKinestheticPercentage());
            stmt.setString(5, result.getPrimaryStyle());
            stmt.setTimestamp(6, new Timestamp(new Date().getTime()));


            
            int rowsAffected = stmt.executeUpdate();
            logger.info("Saved Learning Style result for user {}: {} (V:{}, A:{}, K:{})", 
                       result.getUserId(), result.getPrimaryStyle(),
                       result.getVisualPercentage(), result.getAuditoryPercentage(),
                       result.getKinestheticPercentage());
            
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.error("Error saving Learning Style result for user: " + result.getUserId(), e);
            return false;
        }
    }
    
    public LearningStyleResult getResultByUserId(int userId) {
        String sql = "SELECT * FROM user_learning_style WHERE user_id = ?";
        LearningStyleResult result = null;
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    result = new LearningStyleResult();
                    result.setId(rs.getInt("id"));
                    result.setUserId(rs.getInt("user_id"));
                    result.setVisualPercentage(rs.getInt("visual_percentage"));
                    result.setAuditoryPercentage(rs.getInt("auditory_percentage"));
                    result.setKinestheticPercentage(rs.getInt("kinesthetic_percentage"));
                    result.setPrimaryStyle(rs.getString("primary_style"));
                    result.setCompletedAt(rs.getTimestamp("completed_at"));
                    
                    logger.debug("Retrieved Learning Style result for user {}: {}", 
                                userId, result.getPrimaryStyle());
                }
            }
            
        } catch (SQLException e) {
            logger.error("Error retrieving Learning Style result for user: " + userId, e);
        }
        
        return result;
    }
    
    public boolean hasCompletedQuiz(int userId) {
        String sql = "SELECT COUNT(*) FROM user_learning_style WHERE user_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
            
        } catch (SQLException e) {
            logger.error("Error checking Learning Style completion for user: " + userId, e);
        }
        
        return false;
    }
    
    public boolean deleteResult(int userId) {
        String sql = "DELETE FROM user_learning_style WHERE user_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            int rowsAffected = stmt.executeUpdate();
            logger.info("Deleted Learning Style result for user: {}", userId);
            
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.error("Error deleting Learning Style result for user: " + userId, e);
            return false;
        }
    }
}
