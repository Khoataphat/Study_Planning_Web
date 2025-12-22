/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author Admin
 */
import model.WorkStyleResult;
import utils.DBUtil;
import java.sql.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class WorkStyleResultDAO {
    private static final Logger logger = LoggerFactory.getLogger(WorkStyleResultDAO.class);
    
    public boolean saveResult(WorkStyleResult result) {
        String sql = "INSERT INTO user_work_style (user_id, primary_style, leadership_score, " +
                     "support_score, analysis_score, communication_score, teamwork_score, " +
                     "creativity_score, completed_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE primary_style = VALUES(primary_style), " +
                     "leadership_score = VALUES(leadership_score), " +
                     "support_score = VALUES(support_score), " +
                     "analysis_score = VALUES(analysis_score), " +
                     "communication_score = VALUES(communication_score), " +
                     "teamwork_score = VALUES(teamwork_score), " +
                     "creativity_score = VALUES(creativity_score), " +
                     "completed_at = VALUES(completed_at)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, result.getUserId());
            stmt.setString(2, result.getPrimaryStyle());
            stmt.setInt(3, result.getLeadershipScore());
            stmt.setInt(4, result.getSupportScore());
            stmt.setInt(5, result.getAnalysisScore());
            stmt.setInt(6, result.getCommunicationScore());
            stmt.setInt(7, result.getTeamworkScore());
            stmt.setInt(8, result.getCreativityScore());
            stmt.setTimestamp(9, new Timestamp(new java.util.Date().getTime()));
            
            int rowsAffected = stmt.executeUpdate();
            logger.info("Saved Work Style result for user {}: {}", 
                       result.getUserId(), result.getPrimaryStyle());
            
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.error("Error saving Work Style result", e);
            return false;
        }
    }
    
    public WorkStyleResult getResultByUserId(int userId) {
        String sql = "SELECT * FROM user_work_style WHERE user_id = ?";
        WorkStyleResult result = null;
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    result = new WorkStyleResult();
                    result.setId(rs.getInt("id"));
                    result.setUserId(rs.getInt("user_id"));
                    result.setPrimaryStyle(rs.getString("primary_style"));
                    result.setLeadershipScore(rs.getInt("leadership_score"));
                    result.setSupportScore(rs.getInt("support_score"));
                    result.setAnalysisScore(rs.getInt("analysis_score"));
                    result.setCommunicationScore(rs.getInt("communication_score"));
                    result.setTeamworkScore(rs.getInt("teamwork_score"));
                    result.setCreativityScore(rs.getInt("creativity_score"));
                    result.setCompletedAt(rs.getTimestamp("completed_at"));
                }
            }
            
        } catch (SQLException e) {
            logger.error("Error retrieving Work Style result for user: " + userId, e);
        }
        
        return result;
    }
    
    public boolean hasCompletedQuiz(int userId) {
        String sql = "SELECT COUNT(*) FROM user_work_style WHERE user_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
            
        } catch (SQLException e) {
            logger.error("Error checking Work Style completion for user: " + userId, e);
        }
        
        return false;
    }
}
