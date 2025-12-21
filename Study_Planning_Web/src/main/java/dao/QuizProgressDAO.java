/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author Admin
 */
import model.QuizProgress;
import utils.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class QuizProgressDAO {
    private static final Logger logger = LoggerFactory.getLogger(QuizProgressDAO.class);
    
    public boolean updateProgress(int userId, String quizType, String status) {
        String sql = "INSERT INTO user_quiz_progress (user_id, quiz_type, status, started_at, last_updated) " +
                     "VALUES (?, ?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE " +
                     "status = VALUES(status), " +
                     "last_updated = VALUES(last_updated)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            Timestamp startedAt = null;
            Timestamp completedAt = null;
            Timestamp currentTime = new Timestamp(new Date().getTime());
            
            // Set started_at when first starting the quiz
            if ("IN_PROGRESS".equals(status)) {
                startedAt = currentTime;
            }
            
            stmt.setInt(1, userId);
            stmt.setString(2, quizType);
            stmt.setString(3, status);
            stmt.setTimestamp(4, startedAt);
            stmt.setTimestamp(5, currentTime);
            
            int rowsAffected = stmt.executeUpdate();
            
            // If completed, update completed_at
            if ("COMPLETED".equals(status)) {
                updateCompletedAt(userId, quizType, currentTime);
            }
            
            logger.info("Updated progress for user {} - Quiz: {}, Status: {}", 
                       userId, quizType, status);
            
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.error("Error updating progress for user {} - Quiz: {}", userId, quizType, e);
            return false;
        }
    }
    
    private void updateCompletedAt(int userId, String quizType, Timestamp completedAt) {
        String sql = "UPDATE user_quiz_progress SET completed_at = ? " +
                     "WHERE user_id = ? AND quiz_type = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, completedAt);
            stmt.setInt(2, userId);
            stmt.setString(3, quizType);
            stmt.executeUpdate();
            
            logger.debug("Set completed_at for user {} - Quiz: {}", userId, quizType);
            
        } catch (SQLException e) {
            logger.error("Error setting completed_at for user {} - Quiz: {}", userId, quizType, e);
        }
    }
    
    public QuizProgress getProgress(int userId, String quizType) {
        String sql = "SELECT * FROM user_quiz_progress WHERE user_id = ? AND quiz_type = ?";
        QuizProgress progress = null;
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, quizType);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    progress = new QuizProgress();
                    progress.setId(rs.getInt("id"));
                    progress.setUserId(rs.getInt("user_id"));
                    progress.setQuizType(rs.getString("quiz_type"));
                    progress.setStatus(rs.getString("status"));
                    progress.setStartedAt(rs.getTimestamp("started_at"));
                    progress.setCompletedAt(rs.getTimestamp("completed_at"));
                    progress.setLastUpdated(rs.getTimestamp("last_updated"));
                }
            }
            
        } catch (SQLException e) {
            logger.error("Error retrieving progress for user {} - Quiz: {}", userId, quizType, e);
        }
        
        return progress;
    }
    
    public List<QuizProgress> getUserProgress(int userId) {
        List<QuizProgress> progressList = new ArrayList<>();
        String sql = "SELECT * FROM user_quiz_progress WHERE user_id = ? ORDER BY quiz_type";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    QuizProgress progress = new QuizProgress();
                    progress.setId(rs.getInt("id"));
                    progress.setUserId(rs.getInt("user_id"));
                    progress.setQuizType(rs.getString("quiz_type"));
                    progress.setStatus(rs.getString("status"));
                    progress.setStartedAt(rs.getTimestamp("started_at"));
                    progress.setCompletedAt(rs.getTimestamp("completed_at"));
                    progress.setLastUpdated(rs.getTimestamp("last_updated"));
                    
                    progressList.add(progress);
                }
            }
            
            logger.debug("Retrieved {} progress records for user {}", progressList.size(), userId);
            
        } catch (SQLException e) {
            logger.error("Error retrieving user progress for user: " + userId, e);
        }
        
        return progressList;
    }
    
    public Map<String, QuizProgress> getUserProgressMap(int userId) {
        Map<String, QuizProgress> progressMap = new HashMap<>();
        List<QuizProgress> progressList = getUserProgress(userId);
        
        for (QuizProgress progress : progressList) {
            progressMap.put(progress.getQuizType(), progress);
        }
        
        return progressMap;
    }
    
    public int getCompletedQuizCount(int userId) {
        String sql = "SELECT COUNT(*) FROM user_quiz_progress " +
                     "WHERE user_id = ? AND status = 'COMPLETED'";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            logger.error("Error counting completed quizzes for user: " + userId, e);
        }
        
        return 0;
    }
    
    public List<String> getCompletedQuizTypes(int userId) {
        List<String> completedTypes = new ArrayList<>();
        String sql = "SELECT quiz_type FROM user_quiz_progress " +
                     "WHERE user_id = ? AND status = 'COMPLETED' ORDER BY quiz_type";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    completedTypes.add(rs.getString("quiz_type"));
                }
            }
            
        } catch (SQLException e) {
            logger.error("Error getting completed quiz types for user: " + userId, e);
        }
        
        return completedTypes;
    }
    
    public boolean resetProgress(int userId, String quizType) {
        String sql = "UPDATE user_quiz_progress SET status = 'NOT_STARTED', " +
                     "started_at = NULL, completed_at = NULL, " +
                     "last_updated = ? WHERE user_id = ? AND quiz_type = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, new Timestamp(new Date().getTime()));
            stmt.setInt(2, userId);
            stmt.setString(3, quizType);
            
            int rowsAffected = stmt.executeUpdate();
            logger.info("Reset progress for user {} - Quiz: {}", userId, quizType);
            
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.error("Error resetting progress for user {} - Quiz: {}", userId, quizType, e);
            return false;
        }
    }
    
    public boolean resetAllProgress(int userId) {
        String sql = "UPDATE user_quiz_progress SET status = 'NOT_STARTED', " +
                     "started_at = NULL, completed_at = NULL, " +
                     "last_updated = ? WHERE user_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setTimestamp(1, new Timestamp(new Date().getTime()));
            stmt.setInt(2, userId);
            
            int rowsAffected = stmt.executeUpdate();
            logger.info("Reset all progress for user {}", userId);
            
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.error("Error resetting all progress for user: " + userId, e);
            return false;
        }
    }
    
    public boolean deleteProgress(int userId, String quizType) {
        String sql = "DELETE FROM user_quiz_progress WHERE user_id = ? AND quiz_type = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, quizType);
            
            int rowsAffected = stmt.executeUpdate();
            logger.info("Deleted progress for user {} - Quiz: {}", userId, quizType);
            
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.error("Error deleting progress for user {} - Quiz: {}", userId, quizType, e);
            return false;
        }
    }
    
    public Date getLastUpdated(int userId) {
        String sql = "SELECT MAX(last_updated) as last_updated FROM user_quiz_progress WHERE user_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getTimestamp("last_updated");
                }
            }
            
        } catch (SQLException e) {
            logger.error("Error getting last updated time for user: " + userId, e);
        }
        
        return null;
    }
    
    // Thêm method mới: kiểm tra nếu user đã hoàn thành tất cả quiz
    public boolean hasCompletedAllQuizzes(int userId) {
        // Danh sách tất cả quiz types
        List<String> allQuizTypes = Arrays.asList("MBTI", "WORK_STYLE", "LEARNING", "CAREER");
        
        for (String quizType : allQuizTypes) {
            QuizProgress progress = getProgress(userId, quizType);
            if (progress == null || !"COMPLETED".equals(progress.getStatus())) {
                return false;
            }
        }
        
        return true;
    }
    
    // Thêm method mới: lấy tổng số quiz đã hoàn thành
    public int getTotalCompletionPercentage(int userId) {
        int totalQuizzes = 4; // MBTI, WORK_STYLE, LEARNING, CAREER
        int completedQuizzes = getCompletedQuizCount(userId);
        
        return (completedQuizzes * 100) / totalQuizzes;
    }
}