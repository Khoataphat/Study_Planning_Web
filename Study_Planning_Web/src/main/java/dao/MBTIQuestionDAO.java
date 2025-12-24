/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author Admin
 */
import model.MBTIQuestion;
import utils.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MBTIQuestionDAO {
    private static final Logger logger = LoggerFactory.getLogger(MBTIQuestionDAO.class);
    
    public List<MBTIQuestion> getAllQuestions() {
        List<MBTIQuestion> questions = new ArrayList<>();
        String sql = "SELECT * FROM mbti_questions ORDER BY display_order";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                MBTIQuestion question = new MBTIQuestion();
                question.setId(rs.getInt("id"));
                question.setDimension(rs.getString("dimension"));
                question.setQuestionText(rs.getString("question_text"));
                question.setOptionAText(rs.getString("option_a_text"));
                question.setOptionAValue(rs.getString("option_a_value"));
                question.setOptionBText(rs.getString("option_b_text"));
                question.setOptionBValue(rs.getString("option_b_value"));
                question.setDisplayOrder(rs.getInt("display_order"));
                
                questions.add(question);
            }
            
            logger.info("Retrieved {} MBTI questions", questions.size());
            
        } catch (SQLException e) {
            logger.error("Error retrieving MBTI questions", e);
        }
        
        return questions;
    }
    
    public MBTIQuestion getQuestionById(int id) {
        String sql = "SELECT * FROM mbti_questions WHERE id = ?";
        MBTIQuestion question = null;
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    question = new MBTIQuestion();
                    question.setId(rs.getInt("id"));
                    question.setDimension(rs.getString("dimension"));
                    question.setQuestionText(rs.getString("question_text"));
                    question.setOptionAText(rs.getString("option_a_text"));
                    question.setOptionAValue(rs.getString("option_a_value"));
                    question.setOptionBText(rs.getString("option_b_text"));
                    question.setOptionBValue(rs.getString("option_b_value"));
                    question.setDisplayOrder(rs.getInt("display_order"));
                }
            }
            
        } catch (SQLException e) {
            logger.error("Error retrieving MBTI question with id: " + id, e);
        }
        
        return question;
    }
}
