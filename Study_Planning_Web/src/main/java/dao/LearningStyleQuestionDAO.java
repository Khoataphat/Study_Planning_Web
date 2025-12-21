/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author Admin
 */
import model.LearningStyleQuestion;
import utils.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LearningStyleQuestionDAO {
    private static final Logger logger = LoggerFactory.getLogger(LearningStyleQuestionDAO.class);
    
    public List<LearningStyleQuestion> getAllQuestions() {
        List<LearningStyleQuestion> questions = new ArrayList<>();
        String sql = "SELECT * FROM learning_style_questions ORDER BY display_order";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                LearningStyleQuestion question = new LearningStyleQuestion();
                question.setId(rs.getInt("id"));
                question.setQuestionText(rs.getString("question_text"));
                question.setVisualOption(rs.getString("visual_option"));
                question.setAuditoryOption(rs.getString("auditory_option"));
                question.setKinestheticOption(rs.getString("kinesthetic_option"));
                question.setDisplayOrder(rs.getInt("display_order"));
                
                questions.add(question);
            }
            
            logger.info("Retrieved {} Learning Style questions", questions.size());
            
        } catch (SQLException e) {
            logger.error("Error retrieving Learning Style questions", e);
            // Return sample questions if database error
            return getSampleQuestions();
        }
        
        return questions;
    }
    
    public LearningStyleQuestion getQuestionById(int id) {
        String sql = "SELECT * FROM learning_style_questions WHERE id = ?";
        LearningStyleQuestion question = null;
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    question = new LearningStyleQuestion();
                    question.setId(rs.getInt("id"));
                    question.setQuestionText(rs.getString("question_text"));
                    question.setVisualOption(rs.getString("visual_option"));
                    question.setAuditoryOption(rs.getString("auditory_option"));
                    question.setKinestheticOption(rs.getString("kinesthetic_option"));
                    question.setDisplayOrder(rs.getInt("display_order"));
                }
            }
            
        } catch (SQLException e) {
            logger.error("Error retrieving Learning Style question with id: " + id, e);
        }
        
        return question;
    }
    
    private List<LearningStyleQuestion> getSampleQuestions() {
        List<LearningStyleQuestion> questions = new ArrayList<>();
        
        // Sample questions for fallback
        String[][] sampleData = {
            {"Khi học bài mới, bạn thích:", 
             "Xem video, hình ảnh minh họa", 
             "Nghe giảng giải từ giáo viên", 
             "Thực hành ngay với ví dụ cụ thể"},
            {"Để ghi nhớ thông tin, bạn thường:", 
             "Viết ra hoặc vẽ sơ đồ tư duy", 
             "Đọc to nhiều lần hoặc nghe lại", 
             "Liên hệ với trải nghiệm thực tế"},
            {"Trong lớp học, bạn tập trung nhất khi:", 
             "Có slide trình chiếu đẹp", 
             "Giáo viên giảng bài hay", 
             "Được thực hành, thí nghiệm"}
        };
        
        for (int i = 0; i < sampleData.length; i++) {
            LearningStyleQuestion question = new LearningStyleQuestion();
            question.setId(i + 1);
            question.setQuestionText(sampleData[i][0]);
            question.setVisualOption(sampleData[i][1]);
            question.setAuditoryOption(sampleData[i][2]);
            question.setKinestheticOption(sampleData[i][3]);
            question.setDisplayOrder(i + 1);
            
            questions.add(question);
        }
        
        logger.warn("Using sample Learning Style questions due to database error");
        return questions;
    }
}
