/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

/**
 *
 * @author Admin
 */
import dao.LearningStyleQuestionDAO;
import dao.LearningStyleResultDAO;
import dao.QuizProgressDAO;
import model.LearningStyleQuestion;
import model.LearningStyleResult;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LearningStyleService {
    private static final Logger logger = LoggerFactory.getLogger(LearningStyleService.class);
    
    private LearningStyleQuestionDAO questionDAO;
    private LearningStyleResultDAO resultDAO;
    private QuizProgressDAO progressDAO;
    
    public LearningStyleService() {
        this.questionDAO = new LearningStyleQuestionDAO();
        this.resultDAO = new LearningStyleResultDAO();
        this.progressDAO = new QuizProgressDAO();
    }
    
    public List<LearningStyleQuestion> getLearningStyleQuestions() {
        return questionDAO.getAllQuestions();
    }
    
    public boolean hasUserCompletedQuiz(int userId) {
        return resultDAO.hasCompletedQuiz(userId);
    }
    
    public LearningStyleResult submitQuiz(int userId, Map<String, String[]> parameters) {
        try {
            logger.info("Processing Learning Style quiz for user: {}", userId);
            
            List<LearningStyleQuestion> questions = getLearningStyleQuestions();
            
            // Initialize counters
            int visualCount = 0;
            int auditoryCount = 0;
            int kinestheticCount = 0;
            int totalQuestions = questions.size();
            int answeredQuestions = 0;
            
            // Process each answer
            for (LearningStyleQuestion question : questions) {
                String paramName = "question_" + question.getId();
                String[] values = parameters.get(paramName);
                
                if (values != null && values.length > 0) {
                    String selectedOption = values[0].toUpperCase();
                    
                    switch (selectedOption) {
                        case "VISUAL":
                            visualCount++;
                            break;
                        case "AUDITORY":
                            auditoryCount++;
                            break;
                        case "KINESTHETIC":
                            kinestheticCount++;
                            break;
                        default:
                            logger.warn("Invalid option selected: {}", selectedOption);
                            continue;
                    }
                    answeredQuestions++;
                }
            }
            
            // Validate that all questions were answered
            if (answeredQuestions < totalQuestions) {
                logger.warn("User {} answered only {}/{} questions", 
                           userId, answeredQuestions, totalQuestions);
            }
            
            // Calculate percentages
            int totalAnswers = visualCount + auditoryCount + kinestheticCount;
            
            if (totalAnswers == 0) {
                logger.error("No valid answers for user: {}", userId);
                return null;
            }
            
            int visualPercentage = (visualCount * 100) / totalAnswers;
            int auditoryPercentage = (auditoryCount * 100) / totalAnswers;
            int kinestheticPercentage = 100 - visualPercentage - auditoryPercentage;
            
            // Ensure percentages sum to 100
            int adjustment = 100 - (visualPercentage + auditoryPercentage + kinestheticPercentage);
            kinestheticPercentage += adjustment;
            
            // Determine primary learning style
            String primaryStyle = determinePrimaryStyle(visualPercentage, 
                                                       auditoryPercentage, 
                                                       kinestheticPercentage);
            
            // Create result object
            LearningStyleResult result = new LearningStyleResult(
                userId, 
                visualPercentage, 
                auditoryPercentage, 
                kinestheticPercentage, 
                primaryStyle
            );
            
            // Save to database
            boolean saved = resultDAO.saveResult(result);
            
            if (saved) {
                progressDAO.updateProgress(userId, "LEARNING", "COMPLETED");
                logger.info("Learning Style quiz completed for user {}: {}", 
                           userId, primaryStyle);
                return result;
            } else {
                logger.error("Failed to save Learning Style result for user: {}", userId);
                return null;
            }
            
        } catch (Exception e) {
            logger.error("Error processing Learning Style quiz for user: " + userId, e);
            return null;
        }
    }
    
    private String determinePrimaryStyle(int visual, int auditory, int kinesthetic) {
        // Check for dominant style (≥ 60%)
        if (visual >= 60) return "VISUAL";
        if (auditory >= 60) return "AUDITORY";
        if (kinesthetic >= 60) return "KINESTHETIC";
        
        // Check for primary style (highest percentage)
        if (visual > auditory && visual > kinesthetic) {
            return "VISUAL_PRIMARY";
        } else if (auditory > visual && auditory > kinesthetic) {
            return "AUDITORY_PRIMARY";
        } else if (kinesthetic > visual && kinesthetic > auditory) {
            return "KINESTHETIC_PRIMARY";
        }
        
        // If scores are close, return balanced
        return "BALANCED";
    }
    
    public LearningStyleResult getUserResult(int userId) {
        return resultDAO.getResultByUserId(userId);
    }
    
    public boolean resetQuiz(int userId) {
        boolean deleted = resultDAO.deleteResult(userId);
        if (deleted) {
            progressDAO.updateProgress(userId, "LEARNING", "NOT_STARTED");
            logger.info("Reset Learning Style quiz for user: {}", userId);
        }
        return deleted;
    }
}