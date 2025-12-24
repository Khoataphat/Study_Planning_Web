/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author Admin
 */
import model.CareerResult;
import utils.DBUtil;
import java.sql.*;
import java.util.Date;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CareerResultDAO {
    private static final Logger logger = LoggerFactory.getLogger(CareerResultDAO.class);
    
    public boolean saveResult(CareerResult result) {
        String sql = "INSERT INTO user_career_interests (user_id, technology_score, business_score, " +
                     "creative_score, science_score, education_score, social_score, top_careers, completed_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE " +
                     "technology_score = VALUES(technology_score), " +
                     "business_score = VALUES(business_score), " +
                     "creative_score = VALUES(creative_score), " +
                     "science_score = VALUES(science_score), " +
                     "education_score = VALUES(education_score), " +
                     "social_score = VALUES(social_score), " +
                     "top_careers = VALUES(top_careers), " +
                     "completed_at = VALUES(completed_at)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, result.getUserId());
            stmt.setInt(2, result.getTechnologyScore());
            stmt.setInt(3, result.getBusinessScore());
            stmt.setInt(4, result.getCreativeScore());
            stmt.setInt(5, result.getScienceScore());
            stmt.setInt(6, result.getEducationScore());
            stmt.setInt(7, result.getSocialScore());
            stmt.setString(8, result.getTopCareers());
            stmt.setTimestamp(9, new Timestamp(new Date().getTime()));
            
            int rowsAffected = stmt.executeUpdate();
            logger.info("Saved Career result for user {} - Tech: {}, Business: {}, Creative: {}", 
                       result.getUserId(), result.getTechnologyScore(),
                       result.getBusinessScore(), result.getCreativeScore());
            
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.error("Error saving Career result for user: " + result.getUserId(), e);
            return false;
        }
    }
    
    public CareerResult getResultByUserId(int userId) {
        String sql = "SELECT * FROM user_career_interests WHERE user_id = ?";
        CareerResult result = null;
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    result = new CareerResult();
                    result.setId(rs.getInt("id"));
                    result.setUserId(rs.getInt("user_id"));
                    result.setTechnologyScore(rs.getInt("technology_score"));
                    result.setBusinessScore(rs.getInt("business_score"));
                    result.setCreativeScore(rs.getInt("creative_score"));
                    result.setScienceScore(rs.getInt("science_score"));
                    result.setEducationScore(rs.getInt("education_score"));
                    result.setSocialScore(rs.getInt("social_score"));
                    result.setTopCareers(rs.getString("top_careers"));
                    result.setCompletedAt(rs.getTimestamp("completed_at"));
                    
                    logger.debug("Retrieved Career result for user {}", userId);
                }
            }
            
        } catch (SQLException e) {
            logger.error("Error retrieving Career result for user: " + userId, e);
        }
        
        return result;
    }
    
    public boolean hasCompletedQuiz(int userId) {
        String sql = "SELECT COUNT(*) FROM user_career_interests WHERE user_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
            
        } catch (SQLException e) {
            logger.error("Error checking Career quiz completion for user: " + userId, e);
        }
        
        return false;
    }
    
    public boolean deleteResult(int userId) {
        String sql = "DELETE FROM user_career_interests WHERE user_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            int rowsAffected = stmt.executeUpdate();
            logger.info("Deleted Career result for user: {}", userId);
            
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.error("Error deleting Career result for user: " + userId, e);
            return false;
        }
    }
    
    public int getTopScoreCategory(int userId) {
        String sql = "SELECT " +
                     "GREATEST(technology_score, business_score, creative_score, " +
                     "science_score, education_score, social_score) as max_score " +
                     "FROM user_career_interests WHERE user_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("max_score");
                }
            }
            
        } catch (SQLException e) {
            logger.error("Error getting top score category for user: " + userId, e);
        }
        
        return 0;
    }
}