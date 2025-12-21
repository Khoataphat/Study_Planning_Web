/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author Admin
 */
import model.CareerQuestion;
import utils.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CareerQuestionDAO {
    private static final Logger logger = LoggerFactory.getLogger(CareerQuestionDAO.class);
    
    public List<CareerQuestion> getAllQuestions() {
        List<CareerQuestion> questions = new ArrayList<>();
        String sql = "SELECT * FROM career_questions ORDER BY display_order";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                CareerQuestion question = new CareerQuestion();
                question.setId(rs.getInt("id"));
                question.setQuestionText(rs.getString("question_text"));
                question.setTechnologyScore(rs.getInt("technology_score"));
                question.setBusinessScore(rs.getInt("business_score"));
                question.setCreativeScore(rs.getInt("creative_score"));
                question.setScienceScore(rs.getInt("science_score"));
                question.setEducationScore(rs.getInt("education_score"));
                question.setSocialScore(rs.getInt("social_score"));
                question.setDisplayOrder(rs.getInt("display_order"));
                
                questions.add(question);
            }
            
            logger.info("Retrieved {} Career questions", questions.size());
            
        } catch (SQLException e) {
            logger.error("Error retrieving Career questions", e);
            // Return sample questions if database error
            return getSampleQuestions();
        }
        
        return questions;
    }
    
    public CareerQuestion getQuestionById(int id) {
        String sql = "SELECT * FROM career_questions WHERE id = ?";
        CareerQuestion question = null;
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    question = new CareerQuestion();
                    question.setId(rs.getInt("id"));
                    question.setQuestionText(rs.getString("question_text"));
                    question.setTechnologyScore(rs.getInt("technology_score"));
                    question.setBusinessScore(rs.getInt("business_score"));
                    question.setCreativeScore(rs.getInt("creative_score"));
                    question.setScienceScore(rs.getInt("science_score"));
                    question.setEducationScore(rs.getInt("education_score"));
                    question.setSocialScore(rs.getInt("social_score"));
                    question.setDisplayOrder(rs.getInt("display_order"));
                }
            }
            
        } catch (SQLException e) {
            logger.error("Error retrieving Career question with id: " + id, e);
        }
        
        return question;
    }
    
    private List<CareerQuestion> getSampleQuestions() {
        List<CareerQuestion> questions = new ArrayList<>();
        
        // Sample questions for fallback
        String[][] sampleData = {
            {"Bạn thích làm việc với:", "8,3,5,6,2,4"}, // tech,business,creative,science,edu,social
            {"Môi trường làm việc lý tưởng của bạn là:", "5,7,4,3,6,8"},
            {"Bạn giỏi nhất trong việc:", "9,6,5,7,4,3"}
        };
        
        for (int i = 0; i < sampleData.length; i++) {
            String[] scores = sampleData[i][1].split(",");
            
            CareerQuestion question = new CareerQuestion();
            question.setId(i + 1);
            question.setQuestionText(sampleData[i][0]);
            question.setTechnologyScore(Integer.parseInt(scores[0]));
            question.setBusinessScore(Integer.parseInt(scores[1]));
            question.setCreativeScore(Integer.parseInt(scores[2]));
            question.setScienceScore(Integer.parseInt(scores[3]));
            question.setEducationScore(Integer.parseInt(scores[4]));
            question.setSocialScore(Integer.parseInt(scores[5]));
            question.setDisplayOrder(i + 1);
            
            questions.add(question);
        }
        
        logger.warn("Using sample Career questions due to database error");
        return questions;
    }
    
    public boolean insertQuestion(CareerQuestion question) {
        String sql = "INSERT INTO career_questions (question_text, technology_score, business_score, " +
                     "creative_score, science_score, education_score, social_score, display_order) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, question.getQuestionText());
            stmt.setInt(2, question.getTechnologyScore());
            stmt.setInt(3, question.getBusinessScore());
            stmt.setInt(4, question.getCreativeScore());
            stmt.setInt(5, question.getScienceScore());
            stmt.setInt(6, question.getEducationScore());
            stmt.setInt(7, question.getSocialScore());
            stmt.setInt(8, question.getDisplayOrder());
            
            int rowsAffected = stmt.executeUpdate();
            logger.info("Inserted new Career question: {}", question.getQuestionText());
            
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            logger.error("Error inserting Career question", e);
            return false;
        }
    }
}