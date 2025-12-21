/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

/**
 *
 * @author Admin
 */
import dao.MBTIQuestionDAO;
import dao.MBTIResultDAO;
import dao.QuizProgressDAO;
import model.MBTIQuestion;
import model.MBTIResult;
import utils.MBTICalculator;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MBTIService {
    private static final Logger logger = LoggerFactory.getLogger(MBTIService.class);
    
    private MBTIQuestionDAO questionDAO;
    private MBTIResultDAO resultDAO;
    private QuizProgressDAO progressDAO;
    
    public MBTIService() {
        this.questionDAO = new MBTIQuestionDAO();
        this.resultDAO = new MBTIResultDAO();
        this.progressDAO = new QuizProgressDAO();
    }
    
    // Get all MBTI questions
    public List<MBTIQuestion> getMBTIQuestions() {
        return questionDAO.getAllQuestions();
    }
    
    // Check if user has completed MBTI quiz
    public boolean hasUserCompletedQuiz(int userId) {
        return resultDAO.hasCompletedQuiz(userId);
    }
    
    // Submit MBTI quiz answers
    public MBTIResult submitQuiz(int userId, Map<String, String[]> parameters) {
        try {
            logger.info("Submitting MBTI quiz for user: {}", userId);
            
            // 1. Extract answers from parameters
            Map<Integer, String> answers = extractAnswers(parameters);
            
            // 2. Calculate MBTI result
            MBTIResult result = MBTICalculator.calculateMBTI(answers);
            result.setUserId(userId);
            
            // 3. Save result to database
            boolean saved = resultDAO.saveResult(userId, result);
            
            if (saved) {
                // 4. Update quiz progress
                progressDAO.updateProgress(userId, "MBTI", "COMPLETED");
                logger.info("MBTI quiz completed successfully for user: {}", userId);
                return result;
            } else {
                logger.error("Failed to save MBTI result for user: {}", userId);
                return null;
            }
            
        } catch (Exception e) {
            logger.error("Error submitting MBTI quiz for user: " + userId, e);
            return null;
        }
    }
    
    // Get user's MBTI result
    public MBTIResult getUserResult(int userId) {
        return resultDAO.getResultByUserId(userId);
    }
    
    private Map<Integer, String> extractAnswers(Map<String, String[]> parameters) {
        // Implementation to extract answers from request parameters
        // Format: questionId -> selected option (A/B)
        Map<Integer, String> answers = new java.util.HashMap<>();
        
        for (Map.Entry<String, String[]> entry : parameters.entrySet()) {
            String key = entry.getKey();
            if (key.startsWith("question_")) {
                String questionIdStr = key.substring("question_".length());
                try {
                    int questionId = Integer.parseInt(questionIdStr);
                    String[] values = entry.getValue();
                    if (values != null && values.length > 0) {
                        answers.put(questionId, values[0]);
                    }
                } catch (NumberFormatException e) {
                    logger.warn("Invalid question ID format: {}", key);
                }
            }
        }
        
        logger.info("Extracted {} answers", answers.size());
        return answers;
    }
}